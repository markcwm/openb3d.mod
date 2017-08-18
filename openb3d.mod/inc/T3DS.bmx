' T3DS.bmx
' now loads separate meshes instead of surfaces which are childed to root mesh which is a dummy

Type T3DS

	' 3DS Chunks
	Const M3D_3DS_RGB3F = $0010
	Const M3D_3DS_RGB3B = $0011
	Const M3D_3DS_RGBGAMMA3B = $0012
	Const M3D_3DS_RGBGAMMA3F = $0013
	Const M3D_3DS_PERCENTI = $0030
	Const M3D_3DS_PERCENTF = $0031
	Const M3D_3DS_MAIN = $4D4D
	Const M3D_3DS_3DEDITOR = $3D3D
	Const M3D_3DS_OBJECTBLOCK = $4000
	Const M3D_3DS_TRIMESH = $4100
	Const M3D_3DS_VERTEXLIST = $4110
	Const M3D_3DS_FACELIST = $4120
	Const M3D_3DS_FACEMATLIST = $4130
	Const M3D_3DS_TEXCOORDS = $4140
	Const M3D_3DS_BrushBLOCK = $AFFF
	Const M3D_3DS_BrushNAME = $A000
	Const M3D_3DS_BrushAMBIENT = $A010
	Const M3D_3DS_BrushDIFFUSE = $A020
	Const M3D_3DS_BrushSPECULAR = $A030
	Const M3D_3DS_BrushSHININESS = $A040
	Const M3D_3DS_TEXTUREMAP1 = $A200
	Const M3D_3DS_TEXTUREMAP2 = $A33A
	Const M3D_3DS_MAPFILENAME = $A300
	Const M3D_3DS_MAPVSCALE = $A354
	Const M3D_3DS_MAPUSCALE = $A356
	Const M3D_3DS_MAPUOFFSET = $A358
	Const M3D_3DS_MAPVOFFSET = $A35A
	Const M3D_3DS_MAPROTATION = $A35C
	
	Field Stream : TStream
	Field ChunkID : Short
	Field ChunkSize : Int
	Field Surface : TSurface
	Field VertexCount : Int
	Field TriangleCount : Int
	Field Root : TMesh
	Field RootSurface : TSurface
	Field Mesh : TMesh[]
	Field currentMesh : Int
	Field Brush : TBrush
	Field Brushs : TList
	Field TextureLayer : Int
	Field Texture : TTexture
	Field MaxVert : Float[6]
	
	Method ReadChunk()
		ChunkID = Stream.ReadShort()
		ChunkSize = Stream.ReadInt()
	End Method
	
	Method SkipChunk()
		Stream.Seek(Stream.Pos() + ChunkSize - 6)
	End Method
	
	Method ReadCString:String()
		Local Char:Byte, CString:String
		
		' Null-terminated string
		While Not Stream.Eof()
			Char = Stream.ReadByte()
			If Char = 0 Then Exit
			CString:+ Chr(Char)
		Wend
		
		Return CString
	End Method
	
	Method ReadRGB(Format:Int, Red:Float Var, Green:Float Var, Blue:Float Var)
		Select Format
		
			Case M3D_3DS_RGB3F
				Red   = Stream.ReadFloat()
				Green = Stream.ReadFloat()
				Blue  = Stream.ReadFloat()
				
			Case M3D_3DS_RGB3B
				Red   = Float(Stream.ReadByte())/255.0
				Green = Float(Stream.ReadByte())/255.0
				Blue  = Float(Stream.ReadByte())/255.0
				
			Case M3D_3DS_RGBGAMMA3F
				Red   = Stream.ReadFloat()
				Green = Stream.ReadFloat()
				Blue  = Stream.ReadFloat()
				
			Case M3D_3DS_RGBGAMMA3B
				Red   = Float(Stream.ReadByte())/255.0
				Green = Float(Stream.ReadByte())/255.0
				Blue  = Float(Stream.ReadByte())/255.0
				
			Default
				SkipChunk()
		End Select
	End Method
	
	Method ReadPercent:Float(Format:Int)
		Select Format
		
			Case M3D_3DS_PERCENTI
				Return Float(Stream.ReadShort())/100.0
				
			Case M3D_3DS_PERCENTF
				Return Stream.ReadFloat()/100.0
				
			Default
				SkipChunk()
				Return 0.0
		End Select
	End Method
	
	Method ReadVertexList()
		Local Index:Int, Position:Float[3]
		VertexCount = Stream.ReadShort()
		
		For Index = 0 To VertexCount-1
			Position[0] = Stream.ReadFloat()
			Position[1] = Stream.ReadFloat()
			Position[2] = Stream.ReadFloat()
			
			Surface.AddVertex(Position[0], Position[1], Position[2])
			
			If Position[0]>MaxVert[0] Then MaxVert[0]=Position[0]
			If Position[0]<MaxVert[1] Then MaxVert[1]=Position[0]
			If Position[1]>MaxVert[2] Then MaxVert[2]=Position[1]
			If Position[1]<MaxVert[3] Then MaxVert[3]=Position[1]
			If Position[2]>MaxVert[4] Then MaxVert[4]=Position[2]
			If Position[2]<MaxVert[5] Then MaxVert[5]=Position[2]
		Next
		
		'Surface.UpdateVertices()
	End Method
	
	Method ReadFaceList()
		Local Index:Int, Indices:Int[3]
		TriangleCount = Stream.ReadShort()
		
		For Index = 0 To TriangleCount-1
			Indices[0] = Stream.ReadShort()
			Indices[1] = Stream.ReadShort()
			Indices[2] = Stream.ReadShort()
			Stream.ReadShort() ' FaceFlags
			
			Surface.AddTriangle(Indices[0], Indices[1], Indices[2])
		Next
		
		'Surface.UpdateTriangles()
		'Surface.SmoothNormals()
	End Method
	
	Method ReadFaceMatList()
		Local Name:String, Brush:TBrush, Found:Int, Count:Int
		Name = ReadCString()
		
		' Search for the Brush name
		Found = False
		For Brush = EachIn Brushs
			If String.FromCString(Brush.name) = Name
				Found = True
				Exit
			EndIf
		Next
		
		If Found And currentMesh>0 Then Mesh[currentMesh-1].PaintMesh(Brush)
		
		Count = Stream.ReadShort()
		Stream.Seek(Stream.Pos() + Count * 2)
	End Method
	
	Method ReadTexCoords()
		Local Count:Int, Index:Int, U:Float, V:Float
		Count = Stream.ReadShort()
		
		For Index = 0 To Count - 1
			U = Stream.ReadFloat()
			V = -Stream.ReadFloat()
			
			Surface.VertexTexCoords(Index, U, V, 0, 0)
			Surface.VertexTexCoords(Index, U, V, 0, 1)
		Next
		
		'Surface.UpdateVertices(False, False, True, True, False, False)
	End Method
	
	Method LoadMap()
		Local Filename:String = ReadCString()
		
		Local ext:String = ExtractExt(Filename).ToLower()
		Local name:String = StripExt(Filename) + "." + ext ' try lower ext
		If FileType(name) = 0 Then Filename=Filename.ToLower() ' try all lower
		If FileType(name) = 0 Then Filename=Filename.ToUpper() ' try all upper
		
		Texture = LoadTexture(Filename)
		If Texture
			If TextureLayer = M3D_3DS_TEXTUREMAP1
				' Layer 0
				Brush.BrushTexture(Texture, 0)
			Else
				' Layer 1
				Brush.BrushTexture(Texture, 1)
			EndIf
		EndIf
	End Method
	
	Method ReadMap(Layer:Int)
		Texture = New TTexture
		TextureLayer = Layer
	End Method
	
	Method ReadTriMesh()
		'Surface = Root.CreateSurface()
		Mesh=Mesh[..currentMesh+1]
		Mesh[currentMesh]=CreateMesh(Root)
		Surface = Mesh[currentMesh].CreateSurface()
		currentMesh:+1
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
		Root = Null
		currentMesh = 0
		Brush = Null
		Brushs = CreateList()
		TextureLayer = 0
		Texture = Null
	End Method
	
	Method Load:TMesh(url:Object, parent_ent:TEntity=Null)
		Local Size:Int
		Local OldDir:String
		Local Red:Float, Green:Float, Blue:Float, Percent:Float
		Local Pixmap:TPixmap
		
		Stream = ReadFile(url)
		If Stream = Null Then Return Null
		Size = Stream.Size()
		
		' Read Main-Chunk
		ReadChunk()
		If (ChunkID <> M3D_3DS_MAIN) Or (ChunkSize <> Size)
			Stream.Close()
			Print "No 3DS File"
			Return Null
		EndIf
		
		' Find 3DEditor-Chunk
		While Not Stream.Eof()
			ReadChunk()
			If ChunkID = M3D_3DS_3DEDITOR
				Exit
			Else
				SkipChunk()
			EndIf
		Wend
		
		OldDir = CurrentDir()
		If String(url) <> "" Then ChangeDir(ExtractDir(String(url)))
		Root = CreateMesh()
		RootSurface = Root.CreateSurface()
		'Surface.AddVertex(0,0,0)
		
		While Not Stream.Eof()
			ReadChunk()
			
			Select ChunkID
			
				Case M3D_3DS_OBJECTBLOCK
					ReadCString() ' ObjectName
					
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
					
				Case M3D_3DS_BrushNAME
					'Brush = CreateBrush()
					Brush.NameBrush(ReadCString()) ' Brush.name
					
				Case M3D_3DS_BrushAMBIENT
					'ReadChunk()
					'ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.SetAmbientColor(Red, Green, Blue)
					
				Case M3D_3DS_BrushDIFFUSE
					'ReadChunk()
					'ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.BrushColor(Red, Green, Blue)
					
				Case M3D_3DS_BrushSPECULAR
					'ReadChunk()
					'ReadRGB(ChunkID, Red, Green, Blue)
					'Brush.SetSpecularColor(Red, Green, Blue)
					
				Case M3D_3DS_BrushSHININESS
					'ReadChunk()
					'Percent = ReadPercent(ChunkID)
					'Brush.BrushShininess(Percent)
					
				Case M3D_3DS_MAPFILENAME
					LoadMap()
					
				Case M3D_3DS_MAPVSCALE
					Texture.v_scale[0] = Stream.ReadFloat()
					
				Case M3D_3DS_MAPUSCALE
					Texture.u_scale[0] = Stream.ReadFloat()
					
				Case M3D_3DS_MAPUOFFSET
					Texture.u_pos[0] = Stream.ReadFloat()
					
				Case M3D_3DS_MAPVOFFSET
					Texture.v_pos[0] = Stream.ReadFloat()
					
				Case M3D_3DS_MAPROTATION
					Texture.angle[0] = Stream.ReadFloat()
					
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
		
		' set max dimensions
		RootSurface.AddVertex(MaxVert[0] - MaxVert[1],0,0)
		RootSurface.AddVertex(0,MaxVert[2] - MaxVert[3],0)
		RootSurface.AddVertex(0,0,MaxVert[4] - MaxVert[5])
		
'		Surface.UpdateVertices()
'		Surface.UpdateTriangles()
		For Local child:Int=1 To CountChildren(Root)
			Mesh[child-1].UpdateNormals()
		Next
		'Mesh[0].UpdateBuffer()
		
		'DebugLog Surface.no_tris[0]
		'DebugLog Surface.no_verts[0]
		'Mesh[0].FlipMesh()
		
		Root.NameClass("Mesh")
		
		Root.AddParent(parent_ent)
		Root.AddList_(TEntity.entity_list) ' EntityListAdd
		Root.CopyList(Root.surf_list)
		
		' update matrix
		If Root.parent<>Null
			Root.mat.Overwrite(Root.parent.mat)
			Root.UpdateMat()
		Else
			Root.UpdateMat(True)
		EndIf
		
		Return Root
	End Method
	
End Type

