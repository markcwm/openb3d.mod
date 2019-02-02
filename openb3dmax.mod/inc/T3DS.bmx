' T3DS.bmx
' 3DS loader from OpenB3D - which is ported from MiniB3D Extended (by Benjamin Rossig)

Type T3DS
	
	Const M3D_3DS_M3DVERSION% = $0002
	Const M3D_3DS_RGB3F% = $0010
	Const M3D_3DS_RGB3B% = $0011
	Const M3D_3DS_RGBGAMMA3B% = $0012
	Const M3D_3DS_RGBGAMMA3F% = $0013
	Const M3D_3DS_PERCENTI% = $0030
	Const M3D_3DS_PERCENTF% = $0031
	Const M3D_3DS_MAIN% = $4D4D
	Const M3D_3DS_3DEDITOR% = $3D3D
	Const M3D_3DS_OBJECTBLOCK% = $4000
	Const M3D_3DS_TRIMESH% = $4100
	Const M3D_3DS_VERTEXLIST% = $4110
	Const M3D_3DS_FACELIST% = $4120
	Const M3D_3DS_FACEMATLIST% = $4130
	Const M3D_3DS_TEXCOORDS% = $4140
	Const M3D_3DS_TRANSMATRIX% = $4160
	Const M3D_3DS_BrushBLOCK% = $AFFF
	Const M3D_3DS_BrushNAME% = $A000
	Const M3D_3DS_BrushAMBIENT% = $A010
	Const M3D_3DS_BrushDIFFUSE% = $A020
	Const M3D_3DS_BrushSPECULAR% = $A030
	Const M3D_3DS_BrushSHININESS% = $A040
	Const M3D_3DS_TEXTUREMAP1% = $A200
	Const M3D_3DS_TEXTUREMAP2% = $A33A
	Const M3D_3DS_MAPFILENAME% = $A300
	Const M3D_3DS_MAPVSCALE% = $A354
	Const M3D_3DS_MAPUSCALE% = $A356
	Const M3D_3DS_MAPUOFFSET% = $A358
	Const M3D_3DS_MAPVOFFSET% = $A35A
	Const M3D_3DS_MAPROTATION% = $A35C
	
	Field Stream:TStream
	Field ChunkID:Short, ChunkSize:Int
	Field Surface:TSurface, Mesh:TMesh, Root:TMesh
	Field New_surface:TSurface, New_mesh:TMesh
	Field VertexCount:Int, TriangleCount:Int
	Field Brush:TBrush, Brushs:TList
	Field TextureLayer:Int, Texture:TTexture
	Field MovedTris:Int[], TrisIndex:Int
	Field ObjectNames:String[], ObjectIndex:Int
	Field Red:Byte, Green:Byte, Blue:Byte, Percent:Int
	Field Meshes:TList, MatrixMap:TMap
	Field New_matrix:TMatrix
	
	Method ReadChunk()
		If Stream.Eof() Return
		
		ChunkID = Stream.ReadShort()
		ChunkSize = Stream.ReadInt()
	End Method
	
	Method SkipChunk()
		Stream.Seek(Stream.Pos()+ChunkSize-6)
	End Method
	
	Method ReadCString:String()
		Local Char:Byte, CString:String
		
		' Null-terminated string
		While Not Stream.Eof()
			Char = Stream.ReadByte()
			If Char = 0 Then Exit
			CString:+Chr(Char)
		Wend
		
		Return CString
	End Method
	
	Method ReadRGB(Format:Int, Red:Byte Var, Green:Byte Var, Blue:Byte Var)
		Select Format
			Case M3D_3DS_RGB3F
				Red = Stream.ReadFloat()*255
				Green = Stream.ReadFloat()*255
				Blue = Stream.ReadFloat()*255
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_RGB3F: "+Red+" "+Green+" "+Blue)
				
			Case M3D_3DS_RGB3B
				Red = Stream.ReadByte()
				Green = Stream.ReadByte()
				Blue = Stream.ReadByte()
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_RGB3B: "+Red+" "+Green+" "+Blue)
				
			Case M3D_3DS_RGBGAMMA3F
				Red = Stream.ReadFloat()*255
				Green = Stream.ReadFloat()*255
				Blue = Stream.ReadFloat()*255
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_RGBGAMMA3F: "+Red+" "+Green+" "+Blue)
				
			Case M3D_3DS_RGBGAMMA3B
				Red = Stream.ReadByte()
				Green = Stream.ReadByte()
				Blue = Stream.ReadByte()
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_RGBGAMMA3B: "+Red+" "+Green+" "+Blue)
				
			Default
				SkipChunk()
		End Select
	End Method
	
	Method ReadPercent(Format:Int, Percent:Int Var)
		Select Format
			Case M3D_3DS_PERCENTI
				Percent = Stream.ReadShort()
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_PERCENTI: "+Percent)
				
			Case M3D_3DS_PERCENTF
				Percent = Stream.ReadFloat()'*255
				If TGlobal.Log_3DS Then DebugLog("- - M3D_3DS_PERCENTF: "+Percent)
				
			Default
				SkipChunk()
				Percent = 0
		End Select
	End Method
	
	Method ReadVertexList()
		Local Index:Int, Position:Float[3]
		
		VertexCount = Stream.ReadShort()
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_VERTEXLIST: VertexCount = "+VertexCount)
		
		For Index = 0 To VertexCount-1
			Position[0] = Stream.ReadFloat()
			Position[1] = Stream.ReadFloat()
			Position[2] = Stream.ReadFloat()
			
			Surface.AddVertex(Position[0], Position[1], -Position[2]) ' inverts z for ogl, re-invert needed for flip uvs
		Next
		
		'Surface.UpdateVertices()
	End Method
	
	Method ReadFaceList()
		Local Index:Int, Indices:Int[3]
		
		TriangleCount = Stream.ReadShort()
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_FACELIST: TriangleCount = "+TriangleCount)
		
		For Index = 0 To TriangleCount-1
			Indices[0] = Stream.ReadShort()
			Indices[1] = Stream.ReadShort()
			Indices[2] = Stream.ReadShort()
			Stream.ReadShort() ' FaceFlags
			
			Surface.AddTriangle(Indices[2], Indices[1], Indices[0]) ' reverse winding order needed for flip uvs
		Next
		
		'Surface.UpdateTriangles()
		'Surface.SmoothNormals()
	End Method
	
	Method ReadTexCoords()
		Local CoordCount:Int, Index:Int, U:Float, V:Float
		
		CoordCount = Stream.ReadShort()
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_TEXCOORDS: CoordCount = "+CoordCount)
		
		For Index = 0 To CoordCount-1
			U = Stream.ReadFloat()
			V = -Stream.ReadFloat() ' flip uvs
			
			Surface.VertexTexCoords(Index, U, V, 0, 0)
			Surface.VertexTexCoords(Index, U, V, 0, 1)
		Next
		
		'Surface.UpdateVertices(False, False, True, True, False, False)
	End Method
	
	Method ReadTransMatrix()
		New_matrix = NewMatrix()
		New_matrix.LoadIdentity() ' set grid[x,3]
		
		For Local x% = 0 To 3 ' 4 vectors - X1, X2, X3 (axes), O (origin)
			For Local y% = 0 To 2
				New_matrix.grid[(4*x)+y] = Stream.ReadFloat()
			Next
		Next
		
		If TGlobal.Log_3DS
			DebugLog "- M3D_3DS_TRANSMATRIX"
			'For Local z% = 0 To 3
			'	DebugLog "- "+New_matrix.grid[(4*z)+0]+","+New_matrix.grid[(4*z)+1]+","+New_matrix.grid[(4*z)+2]+","+New_matrix.grid[(4*z)+3]
			'Next
		EndIf
	End Method
	
	Method ReadFaceMatList()
	
		Local BrushName:String, Brush:TBrush, Found:Int, Count:Int
		Local Index:Int, v:Short, i:Int
		
		BrushName = ReadCString()
		Count = Stream.ReadShort()
		Found = False
		
		' Search for the BrushName
		For Brush = EachIn Brushs
			If Brush.GetString(Brush.name) = BrushName
				Found = True
				Exit
			EndIf
		Next
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_FACEMATLIST: BrushName = "+BrushName)
		
		If Found=True
			New_mesh = NewMesh()
			If ObjectIndex>0 Then New_mesh.SetString(New_mesh.name,ObjectNames[ObjectIndex-1])
			New_mesh.SetString(New_mesh.class_name,"Mesh")
			New_mesh.AddParent(Root)
			New_mesh.EntityListAdd(TEntity.entity_list)
			New_surface = New_mesh.CreateSurface()
			MapInsert MatrixMap, New_mesh, New_matrix
			Meshes.AddLast(New_mesh)
			
			For Index = 0 To Count-1 ' copy surface data
				v = Stream.ReadShort()
				Local v0:Int[3]
				For i=0 To 2 ' creates unwelded vertices
					v0[i]=Surface.TriangleVertex(v,i)
					Local x#=Surface.VertexX(v0[i])
					Local y#=Surface.VertexY(v0[i])
					Local z#=Surface.VertexZ(v0[i])
					Local u#=Surface.VertexU(v0[i])
					Local v#=Surface.VertexV(v0[i])
					Local w#=Surface.VertexW(v0[i])
					v0[i]=New_surface.AddVertex(x, y, z, u, v, w) ' inverts z for ogl
				Next
				New_surface.AddTriangle(v0[0], v0[1], v0[2])
				'Surface.RemoveTri(v)
				'v=(v+1)*3
				'Surface.tris[v-1]=0
				'Surface.tris[v-2]=0
				'Surface.tris[v-3]=0
				MovedTris = MovedTris[..TrisIndex+1]
				MovedTris[TrisIndex] = v
				TrisIndex:+1
			Next
			
			New_surface.PaintSurface(Brush)
		Else
			Stream.Seek(Stream.Pos()+Count*2)
		EndIf
		
	End Method
	
	Method LoadMap(Dir:String, Filepath:String)
		Local Filename:String = ReadCString()
		
		Local Texname:String = StripDir(Filename)
		If Dir.StartsWith("incbin::") Or Dir.StartsWith("zip::")
			Texname = Filepath+"/"+StripDir(Filename)
		EndIf
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPFILENAME: Filename = "+Filename+" Texname = "+Texname)
		
		Texture = LoadTexture(Texname, TGlobal.Texture_Flags)
		
		If TextureLayer = M3D_3DS_TEXTUREMAP1
			Brush.BrushTexture(Texture, 0, 0) ' Layer 0
		Else
			Brush.BrushTexture(Texture, 0, 1) ' Layer 1
		EndIf
	End Method
	
	Method ReadMap(Layer:Int)
		Texture = NewTexture()
		TextureLayer = Layer
		'If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPFILENAME: TextureLayer = "+Hex(TextureLayer)
	End Method
	
	Method ReadTriMesh()
		Local CheckSurface:Int=0
		If Surface<>Null
			MovedTris.Sort(False) ' descending
			For Local it:Int=EachIn MovedTris
				Surface.RemoveTri(it)
				CheckSurface=1
			Next
			MovedTris=MovedTris[..0] ' clear
			
			If Surface.no_tris[0]=0 And CheckSurface<>0
				Root.EntityListRemove(Root.child_list, Mesh)
				Mesh.FreeEntity()
			EndIf
		EndIf
		If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_TRIMESH: CheckSurface = "+CheckSurface)
		
		' Dummy mesh and surface
		Mesh = NewMesh()
		If ObjectIndex>0 Then Mesh.SetString(Mesh.name,ObjectNames[ObjectIndex-1])
		Mesh.SetString(Mesh.class_name,"Mesh")
		Mesh.AddParent(Root)
		Mesh.EntityListAdd(TEntity.entity_list)
		Surface = Mesh.CreateSurface()
	End Method
	
	Method ReadBrushBlock()
		Brush = CreateBrush()
		Brushs.AddLast(Brush)
	End Method
	
	Method New()
		Stream = Null
		ChunkID = 0
		ChunkSize = 0
		Surface = Null
		VertexCount = 0
		TriangleCount = 0
		Mesh = Null
		Root = Null
		Brush = Null
		TextureLayer = 0
		Texture = Null
		Brushs = CreateList()
		TrisIndex = 0
		ObjectIndex = 0
		Meshes = CreateList()
		MatrixMap = CreateMap()
	End Method
	
	Function Load3DS:TMesh( url:Object, parent_ent_ext:TEntity=Null )
		Local file:TStream=LittleEndianStream(ReadFile(url))
		If file = Null
			DebugLog " Invalid 3DS stream: "+String(url)
			Return Null
		EndIf
		
		Local model:T3DS = New T3DS
		Local mesh:TMesh = model.Load3DSFromStream(file, url, parent_ent_ext)
		
		file.Close()
		Return mesh
	End Function
	
	Method Load3DSFromStream:TMesh( file:TStream, url:Object, parent_ent:TEntity=Null )
		Local Size:Int, OldDir:String, Filepath:String, Dir:String
		Local Pixmap:TPixmap, BrushName:String
		
		Stream = file
		Size = Stream.Size()
		Dir = String(url)
		OldDir = CurrentDir()
		
		' Read Main-Chunk
		ReadChunk()
		If (ChunkID <> M3D_3DS_MAIN) Or (ChunkSize <> Size)
			Stream.Close()
			DebugLog " Invalid 3DS file: "+Dir
			Return Null
		EndIf
		If TGlobal.Log_3DS Then DebugLog(" Dir: "+Dir+" Size: "+Size)
		
		' Find 3DEditor-Chunk
		While Not Stream.Eof()
			ReadChunk()
			If ChunkID = M3D_3DS_3DEDITOR
				Exit
			Else
				SkipChunk()
			EndIf
		Wend
		
		Local in:Int=0
		While Instr(Dir, "\", in+1)<>0
			in=Instr(Dir, "\", in+1)
		Wend
		While Instr(Dir, "/", in+1)<>0
			in=Instr(Dir, "/", in+1)
		Wend
		If in<>0 Then Dir=Left(Dir, in-1)
		
		Filepath = ExtractDir(String(url))
		If Filepath<>"" Then ChangeDir(Filepath)
		If TGlobal.Log_3DS Then DebugLog(" OldDir: "+OldDir)
		
		Root = NewMesh()
		Root.SetString(Root.name,"ROOT")
		Root.SetString(Root.class_name, "Mesh")
		Root.AddParent(parent_ent)
		Root.EntityListAdd(TEntity.entity_list)
		
		While Not Stream.Eof()
			ReadChunk()
			If ChunkID = 0 Then Exit
			
			Select ChunkID
				Case M3D_3DS_OBJECTBLOCK
					ObjectNames = ObjectNames[..ObjectIndex+1]
					ObjectNames[ObjectIndex] = ReadCString()
					ObjectIndex:+1
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_OBJECTBLOCK: "+ObjectNames[ObjectIndex-1])
					
				Case M3D_3DS_BrushBLOCK
					ReadBrushBlock()
					
				Case M3D_3DS_TRIMESH
					ReadTriMesh()
					
				Case M3D_3DS_VERTEXLIST
					ReadVertexList()
					
				Case M3D_3DS_FACELIST
					ReadFaceList()
					
				Case M3D_3DS_FACEMATLIST
					ReadFaceMatList()
					
				Case M3D_3DS_TEXCOORDS
					ReadTexCoords()
					
				Case M3D_3DS_TRANSMATRIX
					ReadTransMatrix()
					
				Case M3D_3DS_BrushNAME
					'Brush = CreateBrush()
					BrushName = ReadCString()
					Brush.SetString(Brush.name, BrushName)
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_BrushNAME: "+BrushName)
					
				'Case M3D_3DS_BrushAMBIENT
					'ReadChunk()
					'ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.SetAmbientColor(Red, Green, Blue)
					
				Case M3D_3DS_BrushDIFFUSE
					ReadChunk()
					ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.BrushColor(Red, Green, Blue)
					
				'Case M3D_3DS_BrushSPECULAR
					'ReadChunk()
					'ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.SetSpecularColor(Red, Green, Blue)
					
				'Case M3D_3DS_BrushSHININESS
					'ReadChunk()
					'Percent = ReadPercent(ChunkID)
					'Brush.BrushShininess(Percent)
					
				Case M3D_3DS_MAPFILENAME
					LoadMap(Dir, Filepath)
					If Brush.no_texs[0]=0 Then Brush.BrushColor(Red, Green, Blue) ' only use rgb if no texture
					
				Case M3D_3DS_MAPVSCALE
					Texture.v_scale[0] = Stream.ReadFloat()
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPVSCALE: "+Texture.v_scale[0])
					
				Case M3D_3DS_MAPUSCALE
					Texture.u_scale[0] = Stream.ReadFloat()
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPUSCALE: "+Texture.u_scale[0])
					
				Case M3D_3DS_MAPUOFFSET
					Texture.u_pos[0] = Stream.ReadFloat()
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPUOFFSET: "+Texture.u_pos[0])
					
				Case M3D_3DS_MAPVOFFSET
					Texture.v_pos[0] = Stream.ReadFloat()
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPVOFFSET: "+Texture.v_pos[0])
					
				Case M3D_3DS_MAPROTATION
					Texture.angle[0] = Stream.ReadFloat()
					If TGlobal.Log_3DS Then DebugLog("- M3D_3DS_MAPROTATION: "+Texture.angle[0])
					
				Default
					If (ChunkID = M3D_3DS_TEXTUREMAP1) Or (ChunkID = M3D_3DS_TEXTUREMAP2)
						ReadMap(ChunkID)
					Else
						SkipChunk()
					EndIf
			End Select
		Wend
		
		Stream.Close()
		ChangeDir(OldDir)
		
		Local CheckSurface:Int=0
		If Surface<>Null
			MovedTris.Sort(False) ' descending
			For Local it:Int=EachIn MovedTris
				Surface.RemoveTri(it)
				CheckSurface=1
			Next
			MovedTris=MovedTris[..0] ' clear
			
			If Surface.no_tris[0]=0 And CheckSurface<>0
				Root.EntityListRemove(Root.child_list, Mesh)
				Mesh.FreeEntity()
			EndIf
		EndIf
		If TGlobal.Log_3DS Then DebugLog(" Surface: CheckSurface = "+CheckSurface)
		
		'Surface.UpdateVertices()
		'Surface.UpdateTriangles()
		'Root.UpdateNormals()
		'Root.UpdateBuffer()
		'Root.FlipMesh()
		
		For Local mesh2:TMesh = EachIn Meshes ' transform vertices, re-positions mesh by matrix
			Local mat:TMatrix = TMatrix(MapValueForKey( MatrixMap, mesh2 ))
			Local invmat:TMatrix = NewMatrix()
			If mat<>Null Then mat.GetInverse(invmat)
			
			For Local surf2:TSurface = EachIn mesh2.surf_list
				For Local v:Int = 0 Until surf2.CountVertices()
					Local px:Float = surf2.VertexX(v)
					Local py:Float = surf2.VertexY(v)
					Local pz:Float = surf2.VertexZ(v) ' inverts z for ogl
					
					If TGlobal.Mesh_Transform > 0
						invmat.TransformVec(px, py, pz, 1)
						surf2.VertexCoords(v, px, py, pz) ' inverts z for ogl
					EndIf
				Next
				surf2.UpdateNormals()
			Next
			
			mesh2.cull_radius[0] = 0.0
		Next
		
		If TGlobal.Log_3DS Then DebugLog("")
		Return Root
	End Method
	
End Type
