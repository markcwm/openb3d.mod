' TOBJ
' OBJ loader from MiniB3D Monkey by Adam Piette

Type TOBJ

	Const TIME:Int = False
	Const MATERIAL_USE_MAP:Int = False
	Const MAXVERTS:Int = 1024 ' auto-increment as needed
	
	Global override_texflags:Int
	Global MeshPath:String
	Global TexturePath:String
	Global MaterialPath:String
	
	Function LoadOBJ:TMesh(url:Object, parent_ent_ext:TEntity = Null, texflags:Int = -1)
	
		' Start file reading
		Local file:TStream = LittleEndianStream(ReadFile(url)) 'ReadStream("littleendian::" + url)
		If file = Null
			Print "Error: invalid .OBJ stream - " + String(url)
			Return Null
		EndIf
		
		Local mesh:TMesh = TOBJ.LoadOBJFromStream(file, url, parent_ent_ext, texflags)
		
		CloseStream file
		Return mesh
		
	EndFunction
	
	Function LoadOBJFromStream:TMesh(file:TStream, url:Object, parent_ent:TEntity = Null, texflags:Int = -1)
	
		MeshPath = ExtractDir(String(url))
		MaterialPath = MeshPath
		TexturePath = MaterialPath
		If texflags = -1 Then override_texflags = TGlobal3D.Texture_Flags Else override_texflags = texflags
		
		Local cd$ = CurrentDir()
		Local fname$ = StripDir(String(url))
		Local mesh:TMesh
		
		If fname <> ""
			'GCSuspend()
			mesh = ParseObj(file, parent_ent)
			'GCResume()
		EndIf
		
		If mesh = Null
			Print "Error: file not found - " + MeshPath + "/" + fname
		ElseIf TGlobal3D.Log_OBJ
			DebugLog "File: " + fname
			DebugLog "MeshPath: " + MeshPath
			DebugLog "MaterialPath: " + MaterialPath
			DebugLog "TexturePath: " + TexturePath
		EndIf
		
		ChangeDir(cd)
		Return mesh
		
	EndFunction
	
	Function ParseObj:TMesh(file:TStream, parent_ent:TEntity = Null, mtllib_string:String = "")
		
		Local stream:TOBJ = New TOBJ
		
		Local matlibsMap:TMap
		Local matlibsArray:TObjMtl[]
		Local matlibsArrayBuffSize:Int
		Local matlibsArrayCount:Int
		
		If MATERIAL_USE_MAP
			matlibsMap = CreateMap()
		Else
			matlibsArrayBuffSize = 64
			matlibsArray = New TObjMtl[matlibsArrayBuffSize]
		EndIf
		
		Local vertexP:TObjVertex[MAXVERTS]
		Local vertexN:TObjNormal[MAXVERTS]
		Local vertexT:TObjTexCoord[MAXVERTS]
		'Local faces:TFaceData[MAXVERTS]
		
		Local gname:String = ""
		Local snumber:Int = -1
		'Local curmtl:String = ""
		'Local Readface:Byte = True
		'Local vertsAdded:Byte = False
		
		Local hasNorms:Int = 0
		Local VC:Int = 0
		Local VN:Int = 0
		Local VT:Int = 0
		Local FC:Int = 0
		Local TRI:Int = 0
		Local SC:Int = 0
		
		Local v0:Int
		Local v1:Int
		Local v2:Int
		Local ri:Int
		Local id:Int
		
		Local root:TMesh = NewMesh()
		root.SetString(root.name, "ROOT")
		root.SetString(root.class_name, "Mesh")
		root.AddParent(parent_ent)
		root.EntityListAdd(TEntity.entity_list)
		
		Local mesh:TMesh
		Local surface:TSurface
		Local meshonce:Int
		Local currMtl:TObjMtl
		'Local surfaceCache:Int[] = New Int[255]
		'Local mtlCache:String[] = New String[255]
		'Local tag:String
		Local curline:String
		Local ms:Int
		Local startMs:Int = MilliSecs()
		
		While StreamPos(file) < StreamSize(file)
		
			curline = ReadLine(file)
			If curline.length < 1 Continue
			ms = MilliSecs()
			
			' Comment line
			If curline[0] = "#"[0]
				If TGlobal3D.Log_OBJ Then DebugLog(".OBJ Comment: " + curline)
				
				If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
				Continue
			EndIf
			
			Local tag:String = curline[0..9].ToLower()
			
			Select tag[0..2]
			
				Case "o "
					root.SetString(root.name, curline[2..]) ' model name
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "g "
					gname = curline[2..] ' surface brush name
					
					' g = groups, not supported
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "s "
					Local tt:String = curline[2..].ToLower()
					If tt <> "off" Then snumber = Int(curline[2..])
					
					' s = smoothing groups, not supported
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "v "
					If meshonce=0
						meshonce=1
						If TGlobal3D.Log_OBJ Then DebugLog "--vertexnew "
						
						mesh = NewMesh()
						mesh.SetString(mesh.class_name, "Mesh")
						mesh.AddParent(root)
						mesh.EntityListAdd(TEntity.entity_list)
					EndIf
					
					If VC >= vertexP.length - 1 Then vertexP = vertexP[..vertexP.length + MAXVERTS]
					
					vertexP[VC + 1] = New TObjVertex
					vertexP[VC + 1].GetValues(curline[1..])
					VC :+ 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "f "
					If Not surface
						If TGlobal3D.Log_OBJ Then DebugLog "--no mtl "
						
						' no mtl, assume only one surface, no material lib
						surface = mesh.CreateSurface()
						SC :+ 1
					EndIf
					
					If Not currMtl Then currMtl = New TObjMtl
					currMtl.meshSurface = surface
					meshonce = 0
					
					If surface
						' add verts
						' avoiding index 0 as this is reserved for null
						v0 = 0
						v1 = 0
						v2 = 0
						ri = 0
						
						Local FV:TFaceData[] = ParseFaces(curline[2..])
						
						' assume at least 3 verts for a triangle, start at 2 (base0)	
						' also do not use unused vertices
						' also each surface starts at vert id = 0
						For id = 2 To FV.length - 1
						
							v0 = FV[0].vi
							v1 = FV[id - 1].vi
							v2 = FV[id].vi
							ri = currMtl.cache.CheckVert(v0, FV[0].ti, FV[0].ni)
														
							If ri = 0
								v0 = surface.AddVertex(vertexP[v0].x, vertexP[v0].y, -vertexP[v0].z)
								' v0 + 1 for real index, can't use 0
								currMtl.cache.SetCache(FV[0].vi, v0 + 1, FV[0].ti, FV[0].ni)
							ElseIf ri = -1
								' different vt and vn, if so, create new vertex, **update cache
								v0 = surface.AddVertex(vertexP[v0].x, vertexP[v0].y, -vertexP[v0].z)
								currMtl.cache.SetCache(FV[0].vi, v0 + 1, FV[0].ti, FV[0].ni)
							Else
								' offset base 0
								v0 = ri - 1
							EndIf
							If ri = 0 And vertexP[v0 + 1] <> Null
								surface.VertexColor(v0, vertexP[v0 + 1].r, vertexP[v0 + 1].g, vertexP[v0 + 1].b)
							EndIf
							
							ri = currMtl.cache.CheckVert(v1, FV[id - 1].ti, FV[id - 1].ni)
							If ri = 0
								v1 = surface.AddVertex(vertexP[v1].x, vertexP[v1].y, -vertexP[v1].z)
								' v0 + 1 for real index, can't use 0
								currMtl.cache.SetCache(FV[id - 1].vi, v1 + 1, FV[id - 1].ti, FV[id - 1].ni)
							ElseIf ri = -1
								' different vt and vn, if so, create new vertex, **update cache
								v1 = surface.AddVertex(vertexP[v1].x, vertexP[v1].y, -vertexP[v1].z)
								currMtl.cache.SetCache(FV[id - 1].vi, v1 + 1, FV[id - 1].ti, FV[id - 1].ni)
							Else
								' offset base 0
								v1 = ri - 1
							EndIf
							If ri = 0 And vertexP[v1 + 1] <> Null
								surface.VertexColor(v1, vertexP[v1 + 1].r, vertexP[v1 + 1].g, vertexP[v1 + 1].b)
							EndIf
							
							ri = currMtl.cache.CheckVert(v2, FV[id].ti, FV[id].ni)
							If ri = 0
								v2 = surface.AddVertex(vertexP[v2].x, vertexP[v2].y, -vertexP[v2].z)
								' v0 + 1 for real index, can't use 0
								currMtl.cache.SetCache(FV[id].vi, v2 + 1, FV[id].ti, FV[id].ni)
							ElseIf ri = -1
								' different vt and vn, if so, create new vertex, **update cache
								v2 = surface.AddVertex(vertexP[v2].x, vertexP[v2].y, -vertexP[v2].z)
								currMtl.cache.SetCache(FV[id].vi, v2 + 1, FV[id].ti, FV[id].ni)
							Else
								' offset base 0
								v2 = ri - 1
							EndIf
							If ri = 0 And vertexP[v2 + 1] <> Null
								surface.VertexColor(v2, vertexP[v2 + 1].r, vertexP[v2 + 1].g, vertexP[v2 + 1].b)
							EndIf
														
							If vertexN[1] <> Null And FV[0].ni <> 0
								surface.VertexNormal v0, vertexN[FV[0].ni].nx , vertexN[FV[0].ni].ny , vertexN[FV[0].ni].nz
								surface.VertexNormal v1, vertexN[FV[id - 1].ni].nx, vertexN[FV[id - 1].ni].ny, vertexN[FV[id - 1].ni].nz
								surface.VertexNormal v2, vertexN[FV[id].ni].nx, vertexN[FV[id].ni].ny, vertexN[FV[id].ni].nz
							EndIf
							
							If vertexT[1] <> Null And FV[0].ti <> 0
								surface.VertexTexCoords v0, vertexT[FV[0].ti].u , 1-vertexT[FV[0].ti].v
								surface.VertexTexCoords v1, vertexT[FV[id - 1].ti].u, 1 - vertexT[FV[id - 1].ti].v
								surface.VertexTexCoords v2, vertexT[FV[id].ti].u, 1 - vertexT[FV[id].ti].v
		 					EndIf
							
							surface.AddTriangle(v0, v2, v1)
							TRI :+ 1
						Next
						
						FC :+ 1
					EndIf
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
			EndSelect
			
			Select tag[0..3]
			
				Case "vn "
					If VN >= vertexN.length - 1 Then vertexN = vertexN[..vertexN.length + MAXVERTS]
					
					vertexN[VN + 1] = New TObjNormal
					vertexN[VN + 1].GetValues(curline[2..])
					VN :+ 1
					hasNorms = 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "vt "
					If VT >= vertexT.length - 1 Then vertexT = vertexT[..vertexT.length + MAXVERTS]
					
					vertexT[VT + 1] = New TObjTexCoord
					vertexT[VT + 1].GetValues(curline[2..])
					VT :+ 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
			EndSelect
			
			Select tag[0..7]
			
				Case "mtllib "
					If TGlobal3D.Log_OBJ Then DebugLog "mtllib: " + MaterialPath + "/" + curline[7..]
					
					Local lib:TObjMtl[] = ParseMTLLib(MaterialPath + "/" + curline[7..], mtllib_string)
					
					For Local obj:TObjMtl = EachIn lib
						If obj
							If MATERIAL_USE_MAP
								MapInsert(matlibsMap, obj.name, obj)
							Else
								If matlibsArray.length <= matlibsArrayCount + 1
									matlibsArray = matlibsArray[..matlibsArray.length + matlibsArrayBuffSize]
								EndIf
								matlibsArray[matlibsArrayCount] = obj
								matlibsArrayCount :+ 1
							EndIf
						EndIf
					Next
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
				Case "usemtl "
					If MATERIAL_USE_MAP
						currMtl = TObjMtl(MapValueForKey(matlibsMap,curline[7..].Trim()))
					Else
						Local texName:String = curline[7..].Trim()
						For id = 0 Until matlibsArray.length
							If matlibsArray[id] And matlibsArray[id].name = texName
								currMtl = matlibsArray[id]
								Exit
							EndIf
						Next
					EndIf
					
					'currMtl = TObjMtl(matlibs.ValueForKey(curline[7..]))
					'DebugLog "--" + curline[7..]
					
					'Local mmtrue:Int = 0
					'Local surfnum:Int = 0
					
					If currMtl
						
						'reuse existing surfaces
						If currMtl.meshSurface
							DebugLog "--mtlmatch " + currMtl.name
						Else
							If TGlobal3D.Log_OBJ Then DebugLog "--mtlnew "
							
							currMtl.meshSurface = mesh.CreateSurface()
							currMtl.meshSurface.PaintSurface(currMtl.brush)
							
							If TGlobal3D.Log_OBJ Then DebugLog "--use brush " + currMtl.name
							
							SC :+ 1
						EndIf
						
						surface = currMtl.meshSurface
						If Not currMtl.cache Then currMtl.cache = TVertCache.Create(16)
						
						While currMtl.cache.size < VC + 1
							' increase vertex index cache
							currMtl.cache = TVertCache.Create(currMtl.cache.size + 16) ' wipes out old
						Wend
						
					EndIf
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + curline)
					Continue
					
			EndSelect
			
		Wend
		
		If TGlobal3D.Log_OBJ
			DebugLog "VertexCount: " + VC
			DebugLog "NormalsCount: " + VN
			DebugLog "TexCoordsCount: " + VT
			DebugLog "Faces: " + FC + ", Tris: " + TRI
			DebugLog "Surfs: " + SC
			
			'For Local MV:TObjMtl = EachIn MapValues(matlibsmap)
			'	DebugLog "Mtl names:" + MV.name
			'Next
			
			'For Local surf:TSurface = EachIn root.surf_list
			'	DebugLog "real no_verts " + surf.no_verts[0] + ", no_tris " + surf.no_tris[0]
			'Next
			
			Local count_children% = TEntity.CountAllChildren(root)
			For Local child_no% = 1 To count_children
				Local count% = 0
				Local child_ent:TEntity = root.GetChildFromAll(child_no, count, Null)
				For Local sid:Int = 1 To CountSurfaces(TMesh(child_ent))
					Local surf:TSurface = GetSurface(TMesh(child_ent), sid)
					DebugLog "surf id: " + sid + ", real no_verts: " + surf.no_verts[0] + ", no_tris: " + surf.no_tris[0]
				Next
			Next
			DebugLog "--------------------------"
			
			If MilliSecs() <> startMs Then DebugLog(((MilliSecs() - startMs) / 1000.0) + " seconds for entire mesh")
		EndIf
		
		'FlipMesh Mesh
		
		' clean up buffers
		'For Local surfx:TSurface = Eachin mesh.surf_list
			'surfx.CropSurfaceBuffers()
		'Next
		
		If Not hasNorms
			If TGlobal3D.Log_OBJ Then DebugLog "UpdateNormals()"
			
			Local count_children% = TEntity.CountAllChildren(root)
			For Local child_no% = 1 To count_children
				Local count% = 0
				Local child_ent:TEntity = root.GetChildFromAll(child_no,count, Null)
				TMesh(child_ent).UpdateNormals() ' create norms if none
			Next
		EndIf
		
		Return root
		
	EndFunction
	
	Function ParseFaces:TFaceData[](data:String)
		
		Local data1:String[] = data.Split(" ")
		
		Local s:Int = 0
		Local fdata:TFaceData[data1.length]
		
		For Local i:Int = 0 To data1.length - 1 ' s to data1
			If data1[i] = "" Then Continue
			
			fdata[s] = New TFaceData
			Local D2:String[] = CustomSplit(data1[i], "/")
			
			'DebugLog " " + D2[0] + "/ " + D2[1] + "/ " + D2[2]
			
			If D2[0] <> "" Then fdata[s].vi = Int(D2[0])
			If D2[1] <> "" Then fdata[s].ti = Int(D2[1])
			If D2[2] <> "" Then fdata[s].ni = Int(D2[2])
			
			If fdata[s].vi < 0 Then fdata[s].vi = 0
			If fdata[s].ti < 0 Then fdata[s].ti = 0
			If fdata[s].ni < 0 Then fdata[s].ni = 0
			
			s :+ 1
		Next
		
		fdata = fdata[..s]
		Return fdata
		
	EndFunction
	
	Function CustomSplit:String[](st:String, delim:String)
	
		' handles n/n/n as 3 numbers even when n//n
		Local out:String[] = New String[3]
		If st.length < 1 Then Return [""]
		
		Local n:Int = 0, nn:Int = 0
		Local reset:Int = 1
		Local s:String
		
		For Local i:Int = 0 To st.length - 1
			If reset
				out[n] = "0"
				reset = 0
			EndIf
			If st[i] = delim[0]
				Local ii:Int = i + nn
				s = st[i..ii]
				'out[n] = s
				
				n :+ 1
				reset = 1
				nn = 0
				
			Else
				out[n] :+ Chr(st[i])
				nn :+ 1
			EndIf
		Next
		
		'DebugLog nn
		Return out
		
	EndFunction
	
	Function ParseMTLLib:TObjMtl[](url:String, mtllib_string:String)
		
		Local MatLib:TObjMtl[0]
		Local stream:TOBJ = New TOBJ
		
		' Start file reading
		Local file:TStream = LittleEndianStream(ReadFile(url)) 'ReadStream("littleendian::" + url)
		If file = Null
			Print "Error: invalid .OBJ stream - " + String(url)
			Return Null
		EndIf
		
		Local CMI:Int = -1
		Local is_brush:Int = 0
		
		While StreamPos(file) < StreamSize(file)
		
			Local curline:String = ReadLine(file)
			Local tag:String = curline[0..9].ToLower()
			
			' Create new brush
			If tag[0..7] = "newmtl "
				MatLib = MatLib[..MatLib.length + 1]
				CMI = MatLib.length - 1
				
				MatLib[CMI] = New TObjMtl
				MatLib[CMI].name = curline[7..].Trim()
				MatLib[CMI].brush = CreateBrush()
				MatLib[CMI].brush.BrushFX 0 ' default, used to be 4 + 16
				MatLib[CMI].brush.SetString(MatLib[CMI].brush.name, MatLib[CMI].name)
				is_brush = 1
				
				If TGlobal3D.Log_OBJ Then DebugLog("Matname: " + MatLib[CMI].name)
			EndIf
			
			' Colours
			If tag[0..3] = "kd " And is_brush
			
				Local data:String = curline[3..].Trim()
				Local f:Float[3]
				Local comp:Int, values:String[] = data.Split(" ")
				
				For Local i:Int = 0 To values.length - 1
					If values[i].length > 0
						values[comp] = values[i]
						comp :+ 1
					EndIf
				Next
				
				f[0] = Float(values[0])
				f[1] = Float(values[1])
				f[2] = Float(values[2])
				
				'DebugLog("R:" + f[0] + " G:" + f[1] + " B:" + f[2])
				
				MatLib[CMI].brush.BrushColor(f[0] * 255, f[1] * 255, f[2] * 255)
				If TGlobal3D.Log_OBJ Then DebugLog("MatColor: " + (f[0] * 255) + "," + (f[1] * 255) + "," + (f[2] * 255))
				
			EndIf
			
			If tag[0..2] = "d " And is_brush
				MatLib[CMI].brush.BrushAlpha(Float(curline[2..]))
				If TGlobal3D.Log_OBJ Then DebugLog("MatAlpha: " + Float(curline[2..]))
			EndIf
			
			If tag[0..3] = "tr " And is_brush
				MatLib[CMI].brush.BrushAlpha(Float(curline[2..]))
				If TGlobal3D.Log_OBJ Then DebugLog("MatAlpha: " + Float(curline[2..]))
			EndIf
			
			If tag[0..7] = "map_kd " And is_brush
				
				Local texfile:String[] = curline[7..].Trim().Split("\") ' blender fix
				If texfile.length < 2 Then texfile = curline[7..].Trim().Split("/") ' blender fix
				
				texfile[0] = texfile[texfile.length - 1] ' get rid of any prior folders
				
				'Local texfile:String = TexturePath + StripDir(curline[7..])
				'If texfile[1] = "_"[0] Then texfile = texfile[2..]
				
				'Local textName:String = StripDir(curline[7..])
				'If textName[1] = "_"[0] Then textName = textName[2..] ' TODO: REMOVE THIS
				'textName = TexturePath + "/" + texfile
				
				MatLib[CMI].texture = LoadTexture(TexturePath + "/" + texfile[0], override_texflags)
				
				If MatLib[CMI].texture.TextureHeight() > 0
					MatLib[CMI].brush.BrushTexture(MatLib[CMI].texture)
					If TGlobal3D.Log_OBJ Then DebugLog("MatTexture: " + TexturePath + "/" + texfile[0])
				Else
					Print "Error: texture file not found - " + TexturePath + "/" + texfile[0]
				EndIf
				
			EndIf
			
		Wend
		
		Return MatLib
		
	EndFunction
	
EndType

Type TFaceData

	Field vi:Int
	Field ti:Int
	Field ni:Int
	Field its:Int
	
EndType

Type TObjNormal

	Field nx#, ny#, nz#
	
	Method GetValues(data:String)
	
		Local comp:Int, values:String[] = data.Split(" ")
		
		For Local i:Int = 0 To values.length - 1
			If values[i].length > 0
				values[comp] = values[i]
				comp :+ 1
			EndIf
		Next
		
		nx = Float(values[0])
		ny = Float(values[1])
		nz = Float(values[2])
		
		'DebugLog "X:" + nx + " Y:" + ny + " Z:" + nz
		
	EndMethod
	
EndType

Type TObjTexCoord

	Field u#, v#, w#
	
	Method GetValues(data:String)
	
		Local comp:Int, values:String[] = data.Split(" ")
		
		For Local i:Int = 0 To values.length - 1
			If values[i].length > 0
				values[comp] = values[i]
				comp :+ 1
			EndIf
		Next
		
		u = Float(values[0])
		v = Float(values[1])
		
		If comp = 2 Then Return Null
		
		w = Float(values[comp - 1])
		
		'DebugLog "X:" + u + " Y:" + v + " W:" + w
		
	EndMethod
	
EndType

Type TObjVertex

	Field x#, y#, z#, w# ' w = weight for curves + surfaces
	Field r#, g#, b# ' added support for vertex colors
	
	Method GetValues(data:String) ' Fixed a bug when line had > 1 space between values
	
		Local comp:Int, values:String[] = data.Split(" ")
		
		For Local i:Int = 0 To values.length - 1
			If values[i].length > 0
				values[comp] = values[i]
				comp :+ 1
			EndIf
		Next
		
		x = Float(values[0])
		y = Float(values[1])
		z = Float(values[2])
		
		If comp = 3 Or comp = 4 Then Return Null
		
		r = Abs(Float(values[comp - 3])) * 255.0
		g = Abs(Float(values[comp - 2])) * 255.0
		b = Abs(Float(values[comp - 1])) * 255.0
		
		'DebugLog "X:" + x + " Y:" + y + " Z:" + z + " R:" + r + " G:" + g + " B:" + b
		
	EndMethod
	
EndType

Type TObjMtl

	Field name:String
	Field brush:TBrush
	Field texture:TTexture
	Field meshSurface:TSurface
	Field cache:TVertCache
	
	Method New()
		cache = TVertCache.Create(1)
	EndMethod
	
EndType

Type TVertCache
	
	Field size:Int = 1
	Field realvertindex:Int[1] ' cache vert address when created
	Field texusedindex:Int[1] ' cache vert to tex coord index
	Field normusedindex:Int[1] ' cache vert to normal index used
	
	Function Create:TVertCache(i:Int)
	
		Local c:TVertCache = New TVertCache
		c.realvertindex = New Int[i]
		c.texusedindex = New Int[i]
		c.normusedindex = New Int[i]
		c.size = i
		Return c
		
	EndFunction
	
	' CheckVert(vert index, texture index, norm index)
	Method CheckVert:Int(vi:Int, ti:Int, ni:Int)
	
		If vi > size - 1 Then Return 0
		If Not realvertindex[vi] Then Return 0
		
		' check for similar vertex, different vt and vn, if so, create new vertex
		If (texusedindex[vi] <> ti And ti <> 0) Return -1
		If (normusedindex[vi] <> ni And ni <> 0) Return -1
		
		' else return real vertex index
		Return realvertindex[vi]
		
	EndMethod
	
	' Set real vert index
	Method SetCache(vi:Int, reali:Int, ti:Int = 0, ni:Int = 0)
	
		If vi > size - 1
			realvertindex = realvertindex[..vi + 1]
			texusedindex = texusedindex[..vi + 1]
			normusedindex = normusedindex[..vi + 1]
			size = vi + 1
		EndIf
		
		realvertindex[vi] = reali
		texusedindex[vi] = ti
		normusedindex[vi] = ni
		
	EndMethod
	
EndType
