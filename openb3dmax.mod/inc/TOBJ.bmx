' TOBJ
' OBJ loader from Hezkore

Type TOBJ

	Const TIME:Int = False
	Const MATERIAL_USE_MAP:Int = False
	Const MAXVERTS:Int = 1024 ' auto-increment as needed
	
	Global TexFlags:Int
	Global MeshPath:String
	Global TexturePath:String
	Global MaterialPath:String
	
	Function LoadOBJ:TMesh(url:Object, parent_ent_ext:TEntity = Null, flags:Int = 9)
	
		' Start file reading
		Local file:TStream = LittleEndianStream(ReadFile(url)) 'ReadStream("littleendian::" + url)
		If file = Null
			Print "Error: Invalid .OBJ stream: " + String(url)
			Return Null
		EndIf
		
		Local mesh:TMesh = TOBJ.LoadOBJFromStream(file, url, parent_ent_ext, flags)
		
		CloseStream file
		Return mesh
		
	EndFunction
	
	Function LoadOBJFromStream:TMesh(file:TStream, url:Object, parent_ent:TEntity = Null, flags:Int = 9)
	
		TexFlags = flags
		Local cd$ = CurrentDir()
		Local fname$ = StripDir(String(url))
		MeshPath = ExtractDir(String(url))
		MaterialPath = MeshPath
		TexturePath = MaterialPath
		
		Local mesh:TMesh
		If fname <> ""
			'GCSuspend()
			mesh = ParseObj(file, parent_ent, flags)
			'GCResume()
		EndIf
		
		If mesh = Null
			Print "Error: File not found: " + MeshPath + "/" + fname
		ElseIf TGlobal3D.Log_OBJ
			DebugLog "File: " + fname
			DebugLog "MeshPath: " + MeshPath
			DebugLog "MaterialPath: " + MaterialPath
			DebugLog "TexturePath: " + TexturePath
		EndIf
		If mesh Then mesh.SetString(mesh.name, fname)
		
		ChangeDir(cd)
		Return mesh
		
	EndFunction
	
	Function ParseObj:TMesh(file:TStream, parent_ent:TEntity = Null, flags:Int = 9, mtllib_string:String = "")
		
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
		
		'Local gname:String = ""
		'Local snumber:Int = -1
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
		Local t:Int
		Local i:Int
		
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
		Local line:String
		Local ms:Int
		Local startMs:Int = MilliSecs()
		
		While StreamPos(file) < StreamSize(file)
		
			line = ReadLine(file)
			If line.Length < 1 Continue
			ms = MilliSecs()
			
			' Comment line
			If line[0] = "#"[0]
				If TGlobal3D.Log_OBJ Then DebugLog(".OBJ Comment: " + line)
				
				If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
				Continue
			EndIf
			
			Select line[0..2]
			
				Case "f "
					If Not surface
						If TGlobal3D.Log_OBJ Then DebugLog "--no mtl " ' no mtl, assume only one surface, no material lib
						
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
						t = 0
						
						Local V:TFaceData[] = ParseFaces(Line[2..])
						
						' assume at least 3 verts for a triangle, start at 2 (base0)	
						' also do not use unused vertices
						' also each surface starts at vert id = 0
						For i = 2 To V.Length - 1
						
							v0 = V[0].vi
							v1 = V[i - 1].vi
							v2 = V[i].vi
							't = currMtl.cache.CheckVert(v0, V[0].ti, V[0].ni)
							
							'If t = 0
							'	v0 = surface.AddVertex( vertexP[v0].x, vertexP[v0].y, -vertexP[v0].z)
								' v0 + 1 for real index, can't use 0
								'currMtl.cache.SetCache( V[0].vi, v0 + 1, V[0].ti, V[0].ni)
							'ElseIf t = -1
								' different vt and vn, if so, create new vertex, **update cache
							'	v0 = surface.AddVertex( vertexP[v0].x, vertexP[v0].y, -vertexP[v0].z)
								'currMtl.cache.SetCache( V[0].vi, v0 + 1, V[0].ti, V[0].ni)
							'Else
								' offset base 0
							'	v0 = t - 1
							'EndIf
							
							't = currMtl.cache.CheckVert(v1, V[i - 1].ti, V[i - 1].ni)
							'If t = 0
							'	v1 = surface.AddVertex( vertexP[v1].x, vertexP[v1].y, -vertexP[v1].z)
								' v0 + 1 for real index, can't use 0
								'currMtl.cache.SetCache(V[i - 1].vi, v1 + 1, V[i - 1].ti, V[i - 1].ni)
							'ElseIf t = -1
								' different vt and vn, if so, create new vertex, **update cache
							'	v1 = surface.AddVertex( vertexP[v1].x, vertexP[v1].y, -vertexP[v1].z)
								'currMtl.cache.SetCache(V[i - 1].vi, v1 + 1, V[i - 1].ti, V[i - 1].ni)
							'Else
								' offset base 0
							'	v1 = t - 1
							'EndIf
							
							't = currMtl.cache.CheckVert(v2, V[i].ti, V[i].ni)
							'If t = 0
							'	v2 = surface.AddVertex( vertexP[v2].x, vertexP[v2].y, -vertexP[v2].z)
								' v0 + 1 for real index, can't use 0
								'currMtl.cache.SetCache(V[i].vi, v2 + 1, V[i].ti, V[i].ni)
							'ElseIf t = -1
								' different vt and vn, if so, create new vertex, **update cache
							'	v2 = surface.AddVertex( vertexP[v2].x, vertexP[v2].y, -vertexP[v2].z)
								'currMtl.cache.SetCache(V[i].vi, v2 + 1, V[i].ti, V[i].ni)
							'Else
								' offset base 0
							'	v2 = t - 1
							'EndIf
							
							If vertexP[1] <> Null And V[0].vi <> 0
								v0 = surface.AddVertex( vertexP[v0].x, vertexP[v0].y, -vertexP[v0].z)
								v1 = surface.AddVertex( vertexP[v1].x, vertexP[v1].y, -vertexP[v1].z)
								v2 = surface.AddVertex( vertexP[v2].x, vertexP[v2].y, -vertexP[v2].z)
							EndIf
							
							If vertexN[1] <> Null And V[0].ni <> 0
								surface.VertexNormal  v0 , vertexN[V[0].ni].nx , vertexN[V[0].ni].ny , vertexN[V[0].ni].nz
								surface.VertexNormal v1, vertexN[V[i - 1].ni].nx, vertexN[V[i - 1].ni].ny, vertexN[V[i - 1].ni].nz
								surface.VertexNormal v2, vertexN[V[i].ni].nx, vertexN[V[i].ni].ny, vertexN[V[i].ni].nz
							EndIf
							
							If vertexT[1] <> Null And V[0].ti <> 0
								surface.VertexTexCoords  v0 , vertexT[V[0].ti].u , 1-vertexT[V[0].ti].v
								surface.VertexTexCoords v1, vertexT[V[i - 1].ti].u, 1 - vertexT[V[i - 1].ti].v
								surface.VertexTexCoords v2, vertexT[V[i].ti].u, 1 - vertexT[V[i].ti].v
		 					EndIf
							
							surface.AddTriangle(v0, v2, v1)
							TRI :+ 1
						Next
						
						FC :+ 1
					EndIf
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
				Case "o "
					mesh.SetString(mesh.name, Line[2..])
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
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
					
					If VC >= vertexP.Length - 1 Then vertexP = vertexP[..vertexP.Length + MAXVERTS]
					
					vertexP[VC + 1] = New TObjVertex
					vertexP[VC + 1].GetValues(Line[1..])
					VC :+ 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
				Case "g "
					'gname = Line[2..].ToLower()
					
					' g = groups, not supported
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
				Case "s "
					'Local tt:String = Line[2..].ToLower()
					'If tt <> "off" Then snumber = Int(Line[2..])
					
					' s = smoothing groups, not supported
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
			EndSelect
			
			Select line[0..7]
			
				Case "usemtl "
					If MATERIAL_USE_MAP
						currMtl = TObjMtl(MapValueForKey(matlibsMap,Line[7..]))
					Else
						Local texName:String = Line[7..]
						For i = 0 Until matlibsArray.length
							If matlibsArray[i] And matlibsArray[i].name = texName
								currMtl = matlibsArray[i]
								Exit
							EndIf
						Next
					EndIf
					
					'currMtl = TObjMtl(matlibs.ValueForKey(Line[7..]))
					'DebugLog "--" + Line[7..]
					
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
						'If Not currMtl.cache Then currMtl.cache = TVertCache.NewVertCache(16)
						
						'While currMtl.cache.size < VC + 1
							' increase vertex index cache
						'	currMtl.cache = TVertCache.NewVertCache(currMtl.cache.size + 16) ' wipes out old
						'Wend
						
					EndIf
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
				Case "mtllib "
					If TGlobal3D.Log_OBJ Then DebugLog "mtllib: " + MaterialPath + "/" + Line[7..]
					
					Local lib:TObjMtl[] = ParseMTLLib(MaterialPath + "/" + Line[7..], mtllib_string)
					
					For Local obj:TObjMtl = EachIn lib
						If obj
							If MATERIAL_USE_MAP
								MapInsert(matlibsMap, obj.name, obj)
							Else
								If matlibsArray.Length <= matlibsArrayCount + 1 ..
									matlibsArray = matlibsArray[..matlibsArray.Length + matlibsArrayBuffSize]
								matlibsArray[matlibsArrayCount] = obj
								matlibsArrayCount :+ 1
							EndIf
						EndIf
					Next
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
			EndSelect
			
			Select line[0..3]
			
				Case "vn "
					If VN >= vertexN.Length - 1 Then vertexN = vertexN[..vertexN.Length + MAXVERTS]
					
					vertexN[VN + 1] = New TObjNormal
					vertexN[VN + 1].GetValues(Line[2..])
					VN :+ 1
					hasNorms = 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
				Case "vt "
					If VT >= vertexT.Length - 1 Then vertexT = vertexT[..vertexT.Length + MAXVERTS]
					
					vertexT[VT + 1] = New TObjTexCoord
					vertexT[VT + 1].GetValues(Line[2..])
					VT :+ 1
					
					If TIME And MilliSecs() <> ms Then DebugLog((MilliSecs() - ms) + "ms - " + line)
					Continue
					
			EndSelect
			
		Wend
		
		If TGlobal3D.Log_OBJ
			DebugLog "VertexCount: " + VC
			DebugLog "NormalsCount: " + VN
			DebugLog "TexCoordsCount: " + VT
			DebugLog "Faces: " + FC + ", Tris: " + TRI
			DebugLog "Surfs: " + SC
			
			'For Local V:TObjMtl = Eachin matlibs.Values()
			'	DebugLog "Mtl names:" + V.name
			'Next
			'For Local surf:TSurface = EachIn root.surf_list
			'	DebugLog "real no_verts " + surf.no_verts[0] + ", no_tris " + surf.no_tris[0]
			'Next
			Local count_children% = TEntity.CountAllChildren(root)
			If count_children=0
				Local surf:TSurface=GetSurface(root,1)
				DebugLog "real no_verts: " + surf.no_verts[0] + ", no_tris: " + surf.no_tris[0]
			EndIf
			Local child_no%=1 ' used to select child entity
			For Local child_no% = 1 To count_children
				Local count%=0
				Local child_ent:TEntity=root.GetChildFromAll( child_no,count,Null )
				For Local s:Int=1 To CountSurfaces(TMesh(child_ent))
					Local surf:TSurface=GetSurface(TMesh(child_ent),s)
					DebugLog "surf id: "+s+"real no_verts: " + surf.no_verts[0] + ", no_tris: " + surf.no_tris[0]
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
		Local fdata:TFaceData[data1.Length ]
		
		For Local i:Int = 0 To data1.Length - 1 ' s to data1
			If data1[i] = "" Then Continue
			
			fdata[s] = New TFaceData
			Local D2:String[] = CustomSplit( data1[i], "/" )
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
		If st.Length < 1 Then Return [""]
		
		Local n:Int = 0, nn:Int = 0
		Local reset:Int = 1
		Local s:String
		
		For Local i:Int = 0 To st.Length - 1
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
			Print "Error: Invalid .OBJ stream: " + String(url)
			Return Null
		EndIf
		
		Local CMI:Int = -1
		Local is_brush:Int = 0
		
		While StreamPos(file) < StreamSize(file)
		
			Local Line:String = ReadLine(file)
			Local tag:String = Line[0..9].ToLower()
			
			'create new brush
			If tag[0..7] = "newmtl "
				MatLib = MatLib[..MatLib.Length + 1]
				CMI = MatLib.Length - 1
				
				MatLib[CMI] = New TObjMtl
				MatLib[CMI].name = Line[7..].Trim()
				MatLib[CMI].brush = CreateBrush()
				MatLib[CMI].brush.BrushFX 0 ' default, used to be 4 + 16
				MatLib[CMI].brush.name = MatLib[CMI].name
				is_brush = 1
				
				If TGlobal3D.Log_OBJ Then DebugLog("Matname: " + MatLib[CMI].name)
			EndIf
			
			'Colours
			If tag[0..3] = "kd " And is_brush
			
				Local data:String = Line[2..]
				Local f:Float[3]
				Local comp:Int, vpos:Int[3]
				
				For Local i:Int = 0 To data.length - 1
					If data[i] = " "[0] And data[i + 1] <> " "[0]
						vpos[comp] = i + 1
						comp :+ 1
					EndIf
					If comp > 2 Then Exit
				Next
				
				f[0] = Float(data[vpos[0]..vpos[1] - 1])
				f[1] = Float(data[vpos[1]..vpos[2] - 1])
				f[2] = Float(data[vpos[2]..])
				'DebugLog ("R:" + f[0] + " G:" + f[1] + " B:" + f[2])
				
				MatLib[CMI].brush.BrushColor(f[0] * 255, f[1] * 255, f[2] * 255)
				If TGlobal3D.Log_OBJ Then DebugLog("MatColor: " + (f[0] * 255) + "," + (f[1] * 255) + "," + (f[2] * 255))
				
			EndIf
			
			If tag[0..2] = "d " And is_brush
				MatLib[CMI].brush.BrushAlpha( Float(Line[2..]) )
				If TGlobal3D.Log_OBJ Then DebugLog("MatAlpha: " + Float(Line[2..]) )
			EndIf
			
			If tag[0..3] = "tr " And is_brush
				MatLib[CMI].brush.BrushAlpha( Float(Line[2..]))
				If TGlobal3D.Log_OBJ Then DebugLog("MatAlpha: " + Float(Line[2..]) )
			EndIf
			
			If tag[0..7] = "map_kd " And is_brush
				
				'Local texfile:String[] = Line[7..].Trim().Split("\") ' blender fix
				'If texfile.Length < 2 Then texfile = Line[7..].Trim().Split("/")
				'texfile[0] = texfile[texfile.Length - 1] ' get rid of any prior folders
				
				'Local texfile:String = TexturePath + StripDir(Line[7..])
				'If texfile[1] = "_"[0] Then texfile = texfile[2..]
				
				Local textName:String = StripDir(Line[7..])
				'If textName[1] = "_"[0] Then textName = textName[2..] ' TODO: REMOVE THIS
				
				textName = TexturePath + "/" + textName				
				MatLib[CMI].texture = LoadTexture(textName, TexFlags)
				If MatLib[CMI].texture
					MatLib[CMI].brush.BrushTexture(MatLib[CMI].texture)
					If TGlobal3D.Log_OBJ Then DebugLog("MatTexture: " + textName)
				EndIf
				
				If Not MatLib[CMI].texture ' try loading fallback file
					MatLib[CMI].texture = LoadTexture(TexturePath + "/" + "notexture.png", TexFlags)
					If MatLib[CMI].texture = Null Then Print "Error: texture file not found (" + textName + ")"
				EndIf
				
			EndIf
			
		Wend
		
		Return MatLib
		
	EndFunction
	
EndType

Type TObjNormal

	Field nx#, ny#, nz#
	
	Method GetValues(data:String)
	
		Local comp:Int, vpos:Int[3]
		
		For Local i:Int = 0 To data.length - 1
			If data[i] = " "[0] And data[i + 1] <> " "[0]
				vpos[comp] = i + 1
				comp :+ 1
			EndIf
			If comp > 2 Then Exit
		Next
		
		nx = Float(data[vpos[0]..vpos[1] - 1])
		ny = Float(data[vpos[1]..vpos[2] - 1])
		nz = Float(data[vpos[2]..])
		'DebugLog ("X:" + nx + " Y:" + ny + " Z:" + nz)
		
	EndMethod
	
EndType

Type TObjTexCoord

	Field u#, v#
	
	Method GetValues(data:String)
	
		Local comp:Int, vpos:Int[2]
		
		For Local i:Int = 0 To data.length - 1
			If data[i] = " "[0] And data[i + 1] <> " "[0]
				vpos[comp] = i + 1
				comp :+ 1
			EndIf
			If comp > 1 Then Exit
		Next
		
		u = Float(data[vpos[0]..vpos[1] - 1])
		v = Float(data[vpos[1]..])
		'DebugLog ("X:" + u + " Y:" + v)
		
	EndMethod
	
EndType

Type TObjVertex

	Field x#, y#, z#
	
	Method GetValues(data:String) ' Fixed a bug when line had > 1 space between values
	
		Local comp:Int, vpos:Int[3]
		
		For Local i:Int = 0 To data.length - 1
			If data[i] = " "[0] And data[i + 1] <> " "[0]
				vpos[comp] = i + 1
				comp :+ 1
			EndIf
			If comp > 2 Then Exit
		Next
		
		x = Float(data[vpos[0]..vpos[1] - 1])
		y = Float(data[vpos[1]..vpos[2] - 1])
		z = Float(data[vpos[2]..])
		'DebugLog ("X:" + x + " Y:" + y + " Z:" + z)
		
	EndMethod
	
EndType

Type TFaceData

	Field vi:Int
	Field ti:Int
	Field ni:Int
	'Field its:Int
	
EndType

Type TObjMtl

	Field name:String
	Field brush:TBrush
	Field texture:TTexture
	Field meshSurface:TSurface
	Field cache:TVertCache
	Field mesh:TMesh
	
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
	Method CheckVert:Int(i:Int, ti:Int, ni:Int)
		
		If i > size - 1 Then Return 0
		If Not realvertindex[i] Then Return 0
		
		' -- check for similar vertex, different vt and vn, if so, create new vertex
		If (texusedindex[i] <> ti And ti <> 0) Return -1
		If (normusedindex[i] <> ni And ni <> 0) Return -1
		
		' else return real vertex index
		Return realvertindex[i]
		
	EndMethod
	
	Method SetCache(i:Int, reali:Int, ti:Int = 0, ni:Int = 0)
	
		' set real vert index
		If i > size - 1
			realvertindex = realvertindex[..i + 1]
			texusedindex = texusedindex[..i + 1]
			normusedindex = normusedindex[..i + 1]
			size = i + 1
		EndIf
		
		realvertindex[i] = reali
		texusedindex[i] = ti
		normusedindex[i] = ni
		
	EndMethod
	
EndType
