' T3DS.bmx
' 3DS loader from Warner engine (by Bramdenhond)
' loads meshes with single surface, pretransforms vertices but may need reorientation

Type TChunk
	Field id%
	Field size%
	Field endchunk%
	
	Function Create:TChunk(id%, size%, endchunk%)
		Local c:TChunk = New TChunk
		c.id = id
		c.size = size
		c.endchunk = endchunk
		Return c
	End Function
End Type

' animation not working, fixme?
Type TAnimKey
	Field pos:Float[]
	Field rot:Float[]
	Field size:Float[]
	
	Method Create:TAnimKey(ipos:Float[], irot:Float[], isize:Float[])
		pos = ipos[..]
		rot = irot[..]
		size = isize[..]
		Return Self
	End Method
	
	Method Interpolate:TAnimKey(key2:TAnimKey, time#)
		Local ret:TAnimKey = New TAnimKey
		'ret.size = InterpolateVector(size, key2.size, time)
		'ret.pos  = InterpolateVector(pos, key2.pos, time)
		'ret.rot  = SlerpQuaternion(rot, key2.rot, time)
		Return ret
	End Method
	
	Method Empty:TAnimKey()
		pos = [0.0, 0.0, 0.0]
		rot = [1.0, 0.0, 0.0, 0.0]
		size = [1.0, 1.0, 1.0]
		Return Self
	End Method
End Type

Type T3DS
	Global Log_Chunks:Int = 0 ' 1 to debug
	Global Transform_Verts:Int = 1 ' disabled if any child has no matrix
	Global Tex_Flags:Int = 9 ' default LoadTexture flags
	
	' misc
	Const CHUNK_M3DVERSION = $0002
	Const CHUNK_MASTERSCALE = $0100
	Const CHUNK_BKGCOLOR = $1200
	Const CHUNK_AMBCOLOR = $2100
	' color chunks
	Const CHUNK_RGB3F = $0010
	Const CHUNK_RGB3B = $0011 ' 24-bit
	Const CHUNK_RGBGAMMA3B = $0012
	Const CHUNK_RGBGAMMA3F = $0013
	' percent chunks
	Const CHUNK_PERCENTI = $0030
	Const CHUNK_PERCENTF = $0031
	' main chunk
	Const CHUNK_MAIN = $4D4D
	' 3d editor chunk
	Const CHUNK_3DEDITOR = $3D3D
	' object block
	Const CHUNK_OBJECTBLOCK = $4000
	Const CHUNK_TRIMESH = $4100
	Const CHUNK_VERTEXLIST = $4110
	Const CHUNK_FACELIST = $4120
	Const CHUNK_FACEMATLIST = $4130
	Const CHUNK_MAPLIST = $4140
	Const CHUNK_SMOOTHLIST = $4150
	Const CHUNK_TRANSMATRIX = $4160
	Const CHUNK_LIGHT = $4600
	Const CHUNK_SPOTLIGHT = $4610
	Const CHUNK_CAMERA = $4700
	' material block
	Const CHUNK_MATBLOCK = $AFFF
	Const CHUNK_MATNAME = $A000
	Const CHUNK_AMBIENT = $A010
	Const CHUNK_DIFFUSE = $A020
	Const CHUNK_SPECULAR = $A030
	Const CHUNK_SHININESS = $A040
	Const CHUNK_TEXTUREMAP1 = $A200
	Const CHUNK_TEXTUREMAP2 = $A33A
	Const CHUNK_BUMPMAP = $A230
	' map sub-chunk
	Const CHUNK_MAPFILENAME = $A300
	Const CHUNK_MAPVSCALE = $A354
	Const CHUNK_MAPUSCALE = $A356
	Const CHUNK_MAPUOFFSET = $A358
	Const CHUNK_MAPVOFFSET = $A35A
	Const CHUNK_MAPROTATION = $A35C
	' keyframer chunk
	Const CHUNK_KEYFRAMER = $B000
	Const CHUNK_MESHINFO = $B002
	Const CHUNK_FRAMES = $B008
	' information sub-chunk
	Const CHUNK_HIERINFO = $B010
	Const CHUNK_INSTNAME = $B011
	Const CHUNK_PIVOT = $B013
	Const CHUNK_BOUNDBOX = $B014
	Const CHUNK_POSTRACK = $B020
	Const CHUNK_ROTTRACK = $B021
	Const CHUNK_SCALETRACK = $B022
	Const CHUNK_HIERPOS = $B030
	
	Field objlist:TList
	Field materialmap:TMap
	Field materialcolormap:TMap
	Field materialshinemap:TMap
	Field materiallayermap:TMap
	Field matrixmap:TMap
	Field filepath$
	Field stream:TStream
	
	Method GetObject:TEntity( index% )
		If index < 0 Return Null
		If index >= objlist.Count() Return Null
		
		'If Log_Chunks Then DebugLog " GetObject name"+TEntity(objlist.ToArray()[index]).EntityName()
		Return TEntity(objlist.ToArray()[index])
	End Method
	
	Method ReadChunk:TChunk()
		If stream.Eof() Return TChunk.Create(0, 0, 0)
		
		Local id% = stream.ReadShort()
		Local size% = stream.ReadInt()
		Local endchunk% = StreamPos(stream) + size - 6
		
		Return TChunk.Create(id, size, endchunk)
	End Method
	
	' Null-terminated string
	Method ParseString:String()
		Local Char:Byte, CString:String
		
		While Not stream.Eof()
			Char = stream.ReadByte()
			If Char = 0 Then Exit
			CString:+ Chr(Char)
		Wend
		
		Return CString
	End Method
	
	Method ParseVertexList:Short( surface:TSurface, parent:TEntity )
		Local count:Short = stream.ReadShort()
		
		For Local id% = 0 To count-1
			Local x# = stream.ReadFloat()
			Local y# = stream.ReadFloat()
			Local z# = stream.ReadFloat()
			surface.AddVertex(x, y, z)
		Next
		
		Return count
	End Method
	
	Method ParseMapList( surface:TSurface, parent:TEntity )
		Local count:Short = stream.ReadShort()
		
		For Local id% = 0 To count-1
			Local u# = stream.ReadFloat()
			Local v# = -stream.ReadFloat()
			surface.VertexTexCoords(id, u, v, 0, 0)
			surface.VertexTexCoords(id, u, v, 0, 1)
		Next
	End Method
	
	Method ParseFaceMatList( surface:TSurface, parent:TEntity )
		Local matname$, count:Short
		matname = ParseString()
		
		Local tex:TTexture = TTexture(MapValueForKey( materialmap, matname ))
		Local col:Byte[] = Byte[](MapValueForKey( materialcolormap, matname ))
		Local shine:Float[] = Float[](MapValueForKey( materialshinemap, matname ))
		Local layer:Int[] = Int[](MapValueForKey( materiallayermap, matname ))
		
		If tex<>Null
			surface.brush.BrushTexture(tex, layer[0])
			surface.brush.BrushColor(255, 255, 255)
		ElseIf col<>Null
			surface.brush.BrushColor(col[0], col[1], col[2])
		EndIf
		If shine<>Null
			surface.brush.BrushShininess(Float(shine[0]) / 255.0)
		EndIf
		
		count = stream.ReadShort()
		stream.Seek(stream.Pos() + count * 2)
	End Method
	
	Method ParseFaceList:Short( surface:TSurface, parent:TEntity, endchunk% )
		Local count:Short = stream.ReadShort()
		
		For Local id% = 0 To count-1
			Local v0% = stream.ReadShort()
			Local v1% = stream.ReadShort()
			Local v2% = stream.ReadShort()
			stream.ReadShort() ' FaceFlags
			surface.AddTriangle(v0, v1, v2)
		Next
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_FACEMATLIST ' $4130 - faces material list
					If Log_Chunks Then DebugLog "- - - - - CHUNK_FACEMATLIST"
					ParseFaceMatList(surface, parent)
					
				Case CHUNK_SMOOTHLIST ' $4150 - smoothing groups list
					If Log_Chunks Then DebugLog "- - - - - CHUNK_SMOOTHLIST"
					stream.Seek(chunk.endchunk)
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Return count
	End Method
	
	Method ParseMap:String( parent:TEntity, endchunk% )
		Local texname$ = "", tex:TTexture, val#
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_MAPFILENAME ' $A300 - map filename
					texname = ParseString()
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPFILENAME: "+texname
					
				Case CHUNK_MAPVSCALE ' $A354
					val = stream.ReadFloat()
					tex = TTexture(MapValueForKey( materialmap, texname ))
					If tex <> Null Then tex.v_scale[0] = val
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPVSCALE: "+val
					
				Case CHUNK_MAPUSCALE ' $A356
					val = stream.ReadFloat()
					tex = TTexture(MapValueForKey( materialmap, texname ))
					If tex <> Null Then tex.u_scale[0] = val
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPUSCALE: "+val
					
				Case CHUNK_MAPUOFFSET ' $A358
					val = stream.ReadFloat()
					tex = TTexture(MapValueForKey( materialmap, texname ))
					If tex <> Null Then tex.u_pos[0] = val
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPUOFFSET: "+val
					
				Case CHUNK_MAPVOFFSET ' $A35A
					val = stream.ReadFloat()
					tex = TTexture(MapValueForKey( materialmap, texname ))
					If tex <> Null Then tex.v_pos[0] = val
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPVOFFSET: "+val
					
				Case CHUNK_MAPROTATION ' $A35C
					val = stream.ReadFloat()
					tex = TTexture(MapValueForKey( materialmap, texname ))
					If tex <> Null Then tex.angle[0] = val
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPROTATION: "+val
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Return texname
	End Method
	
	Method ParseTriMesh( mesh:TMesh, parent:TEntity, endchunk% )
		Local count:Short, surface:TSurface = Null
		Local matrix:TMatrix = Null
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_VERTEXLIST ' $4110
					If surface = Null Then surface = CreateSurface(mesh)
					count = ParseVertexList(surface, parent)
					If Log_Chunks Then DebugLog "- - - - CHUNK_VERTEXLIST: "+count
					
				Case CHUNK_FACELIST ' $4120
					If surface = Null Then surface = CreateSurface(mesh)
					count = ParseFaceList(surface, parent, chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - - CHUNK_FACELIST: "+count
					
				Case CHUNK_MAPLIST ' $4140 - tex coords
					If surface = Null Then surface = CreateSurface(mesh)
					ParseMapList(surface, parent)
					If Log_Chunks Then DebugLog "- - - - CHUNK_MAPLIST"
					
				Case CHUNK_TRANSMATRIX ' $4160 - local coords
					matrix = CreateMatrix()
					For Local x% = 0 To 3 ' 4 vectors - X1, X2, X3 (axes), O (origin)
						For Local y% = 0 To 2
							matrix.grid[(4*x)+y] = stream.ReadFloat()
						Next
					Next
					matrix.grid[(4*0)+3] = 0
					matrix.grid[(4*1)+3] = 0
					matrix.grid[(4*2)+3] = 0
					matrix.grid[(4*3)+3] = 1
					If Log_Chunks
						DebugLog "- - - - CHUNK_TRANSMATRIX"
						For Local z% = 0 To 2
							DebugLog "- - - - "+matrix.grid[(4*0)+z]+","+matrix.grid[(4*1)+z]+","+matrix.grid[(4*2)+z]+","+matrix.grid[(4*3)+z]
						Next
					EndIf
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		If matrix <> Null
			MapInsert matrixmap, mesh.EntityName(), matrix
		EndIf
	End Method
	
	Method ParseAnimKeys:TAnimKey[]( parent:TEntity, endchunk%, animKeys:TAnimKey[], chunk% )
		Local flags% = stream.ReadShort()
		Local i1% = stream.ReadInt() 
		Local i2% = stream.ReadInt()
		Local frameCount% = stream.ReadShort()
		Local s2% = stream.ReadShort()
		
		If frameCount >= animKeys.length Then animKeys = animKeys[..frameCount]
		
		Local quat:Float[] = [1.0, 0.0, 0.0, 0.0]
		Local ang#, x#, y#, z#
		
		For Local k% = 0 To frameCount-1
			Local time% = stream.ReadInt()
			Local flags% = stream.ReadShort()
			If time >= frameCount Then time = frameCount-1 '0
			
			Local m% = 0
			For Local i% = 1 To 5
				If (flags & m) stream.ReadFloat()
				m = m * 2
			Next
			
			If animKeys[time] = Null animKeys[time] = New TAnimKey
			
			Select chunk
				Case CHUNK_POSTRACK ' $B020
					x = stream.ReadFloat()
					y = stream.ReadFloat()
					z = stream.ReadFloat()
					animKeys[time].pos = [x, y, z]
					If Log_Chunks Then DebugLog "- - - CHUNK_POSTRACK: "+x+","+y+","+z
					
				Case CHUNK_ROTTRACK ' $B021
					ang = -stream.ReadFloat() / 0.0175
					x = stream.ReadFloat()
					y = stream.ReadFloat() 'some cases:::  1.swap y and z  2.negate new z
					z = stream.ReadFloat()
					'Local q1:Float[] = CreateQuaternion(ang, x, y, z)
					'Local ll# = VectorMagnitude([x, y, z])
					
					'Local test:Float[,] = BuildMatrix([0.0,0.0,0.0],q1,[1.0,1.0,1.0])
					
					'If (ll>EPSILON)
					'	x = x / ll y = y / ll z = z / ll
					'	quat = MultipliedQuaternion(q1, quat)
					'	quat = NormalizeQuaternion(quat)
					'	animKeys[time].rot = quat
					'EndIf
					'animKeys[time].rot = quat
					If Log_Chunks Then DebugLog "- - - CHUNK_ROTTRACK: "+x+","+y+","+z
					
				Case CHUNK_SCALETRACK ' $B022
					x = stream.ReadFloat()
					y = stream.ReadFloat()
					z = stream.ReadFloat()
					animKeys[time].size = [x, y, z]
					If Log_Chunks Then DebugLog "- - - CHUNK_SCALETRACK: "+x+","+y+","+z
			End Select
		Next
		
		Return animKeys
	End Method
	
	Method ParseMeshInfo( parent:TEntity, endchunk% )
		Local objname$ = "", instname$ = ""
		Local id% = -1, parid% = -1, mesh:TMesh
		Local piv_x#=0.0, piv_y#=0.0, piv_z#=0.0
		Local animkeys:TAnimKey[] = New TAnimKey[0]
		'Local animkeys:TAnimationKeys = CreateAnimationKeys()
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_HIERPOS ' $B030 - node id
					id = stream.ReadShort()
					If Log_Chunks Then DebugLog "- - - CHUNK_HIERPOS: "+id
					
				Case CHUNK_HIERINFO ' $B010 - node header
					objname = ParseString()
					Local flag1% = stream.ReadShort()
					Local flag2% = stream.ReadShort()
					parid = stream.ReadShort()
					If Log_Chunks Then DebugLog "- - - CHUNK_HIERINFO: "+objname+", parent="+parid
					
				Case CHUNK_INSTNAME ' $B011
					instname = ParseString()
					If Log_Chunks Then DebugLog "- - - CHUNK_INSTNAME: "+instname
					
				Case CHUNK_PIVOT ' $B013
					piv_x = stream.ReadFloat()
					piv_y = stream.ReadFloat()
					piv_z = stream.ReadFloat()
					If Log_Chunks Then DebugLog "- - - CHUNK_PIVOT: "+piv_x+","+piv_y+","+piv_z
					
				Case CHUNK_BOUNDBOX ' $B014
					stream.Seek(chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - CHUNK_BOUNDBOX"
					
				Case CHUNK_POSTRACK ' $B020
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Case CHUNK_ROTTRACK ' $B021
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Case CHUNK_SCALETRACK ' $B022
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		If objname = "$$$DUMMY"
			mesh = CreateMesh(parent)
			mesh.NameEntity(instname)
		Else
			For Local ent:TEntity = EachIn objlist
				If ent.EntityName() = objname
					Local par:TEntity, mesh:TMesh = TMesh(ent)
					
					If parid = 65535 ' root
						par = parent
					Else
						par = GetObject(parid)
					EndIf
					If par = Null Or par = ent Then par = parent ' in case of invalid parent
					ent.SetParent(par)
					
					Local matrix:TMatrix = TMatrix(MapValueForKey( matrixmap, mesh.EntityName() ))
					If parid <> 65535 And mesh.no_surfs[0] = 0 And matrix = Null ' if any dummy meshes
						Transform_Verts = 0 ' don't pretransform vertices
					EndIf
					
					Exit
				EndIf
			Next
		EndIf
		
	End Method
	
	Method ParseObject( parent:TEntity, endchunk% )
		Local mesh:TMesh = Null
		Local objname$ = ParseString()
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_TRIMESH ' $4100 - triangular mesh
					If Log_Chunks Then DebugLog "- - - CHUNK_TRIMESH: "+objname
					mesh = CreateMesh(parent)
					mesh.NameEntity(objname)
					ListAddLast objlist, mesh
					ParseTriMesh(mesh, parent, chunk.endchunk)
					
				Case CHUNK_LIGHT ' $4600
					If Log_Chunks Then DebugLog "- - - CHUNK_LIGHT"
					stream.Seek(chunk.endchunk)
					
				Case CHUNK_CAMERA ' $4700
					If Log_Chunks Then DebugLog "- - - CHUNK_CAMERA"
					stream.Seek(chunk.endchunk)
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParsePercent:Float( parent:TEntity, endchunk% )
		Local pc:Float
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
			Case CHUNK_PERCENTI ' $0030
				pc = Float(stream.ReadShort())/100.0
				If Log_Chunks Then DebugLog " CHUNK_PERCENTI: "+pc
				
			Case CHUNK_PERCENTF ' $0031
				pc = stream.ReadFloat()/100.0
				If Log_Chunks Then DebugLog " CHUNK_PERCENTF: "+pc
				
			Default
				stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Return pc
	End Method
	
	Method ParseColor:Byte[]( parent:TEntity, endchunk% )
		Local r:Byte = 255, g:Byte = 255, b:Byte = 255
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_RGB3F ' $0010 - 0..1
					r = stream.ReadFloat() * 255
					g = stream.ReadFloat() * 255
					b = stream.ReadFloat() * 255
					If Log_Chunks Then DebugLog " CHUNK_RGB3F: "+r+","+g+","+b
					
				Case CHUNK_RGB3B ' $0011 - 0..255
					r = stream.ReadByte()
					g = stream.ReadByte()
					b = stream.ReadByte()
					If Log_Chunks Then DebugLog " CHUNK_RGB3B: "+r+","+g+","+b
					
				Case CHUNK_RGBGAMMA3F ' $0013 - 0..1
					stream.Seek(chunk.endchunk)
					If Log_Chunks Then DebugLog " CHUNK_RGBGAMMA3F"
					
				Case CHUNK_RGBGAMMA3B ' $0012 - 0.255
					stream.Seek(chunk.endchunk) ' same as color
					If Log_Chunks Then DebugLog " CHUNK_RGBGAMMA3B"
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Return [r, g, b]
	End Method
	
	Method ParseMaterial( parent:TEntity, endchunk% )
		Local matname$, texname$, layer:Int[] = [0]
		Local col:Byte[] = [Byte(255), Byte(255), Byte(255)]
		Local shine:Float[] = [1.0]
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id		
				Case CHUNK_MATNAME ' $A000
					matname = ParseString()
					If Log_Chunks Then DebugLog "- - - CHUNK_MATNAME: "+matname
					
				Case CHUNK_AMBIENT ' $A010
					stream.Seek(chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - CHUNK_AMBIENT" ' same as diffuse
					
				Case CHUNK_DIFFUSE ' $A020
					col = ParseColor(parent, chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - CHUNK_DIFFUSE: "+col[0]+" "+col[1]+" "+col[2]
					
				Case CHUNK_SPECULAR ' $A030
					stream.Seek(chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - CHUNK_SPECULAR" ' specular set by shininess
					
				Case CHUNK_SHININESS ' $A040
					shine[0] = ParsePercent(parent, chunk.endchunk)
					If Log_Chunks Then DebugLog "- - - CHUNK_SHININESS: "+shine[0]
					
				Case CHUNK_TEXTUREMAP1 ' $A200
					If Log_Chunks Then DebugLog "- - - CHUNK_TEXTUREMAP1"
					layer[0] = 0
					texname = ParseMap(parent, chunk.endchunk)
					
				Case CHUNK_TEXTUREMAP2 ' $A33A
					If Log_Chunks Then DebugLog "- - - CHUNK_TEXTUREMAP2"
					layer[0] = 1
					texname = ParseMap(parent, chunk.endchunk)
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Local name$ = filepath+"/"+StripDir(texname)
		If FileType(name) = 0 Then name = name.ToLower() ' try all lowercase
		If FileType(name) = 0 Then name = name.ToUpper() ' try all uppercase
		Local tex:TTexture = TTexture.LoadTexture(name, Tex_Flags)
		
		MapInsert materialmap, matname, tex
		MapInsert materialcolormap, matname, col
		MapInsert materialshinemap, matname, shine
		MapInsert materiallayermap, matname, layer
		
	End Method
	
	Method ParseKeyFrames( parent:TEntity, endchunk% )
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
			Case CHUNK_MESHINFO ' $B002 - mesh information
				If Log_Chunks Then DebugLog "- - CHUNK_MESHINFO"
				ParseMeshInfo(parent, chunk.endchunk)
				
			Default
				stream.Seek(chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParseScene( parent:TEntity, endchunk% )
		
		While StreamPos(stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_OBJECTBLOCK ' $4000
					If Log_Chunks Then DebugLog "- - CHUNK_OBJECTBLOCK"
					ParseObject(parent, chunk.endchunk)
					
				Case CHUNK_MATBLOCK ' $AFFF - material block
					If Log_Chunks Then DebugLog "- - CHUNK_MATBLOCK"
					ParseMaterial(parent, chunk.endchunk)
				
				Case CHUNK_MASTERSCALE ' $0100
					Local scale# = stream.ReadFloat()
					If Log_Chunks Then DebugLog "- - CHUNK_MASTERSCALE: "+scale
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParseFile:TMesh( url:Object, Size% )
	
		Local chunk:TChunk = ReadChunk()
		If (chunk.id <> CHUNK_MAIN) Or (chunk.size <> Size) ' $4D4D
			stream.Close()
			Print "No 3DS File"
			Return Null
		EndIf
		
		Local parent:TMesh = CreateMesh()
		parent.NameEntity("ROOT")
		
		While Not stream.Eof()
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Exit
			
			Select chunk.id
				Case CHUNK_3DEDITOR ' $3D3D
					If Log_Chunks Then DebugLog "- CHUNK_3DEDITOR"
					ParseScene(parent, chunk.endchunk)
					
				Case CHUNK_KEYFRAMER ' $B000
					If Log_Chunks Then DebugLog "- CHUNK_KEYFRAMER"
					ParseKeyFrames(parent, chunk.endchunk)
					
				Case CHUNK_M3DVERSION ' $0002
					Local version% = stream.ReadInt()
					If Log_Chunks Then DebugLog "- CHUNK_M3DVERSION: "+version
					
				Default
					stream.Seek(chunk.endchunk)
			End Select
		Wend
		
		Return parent
	End Method
	
	Method Load:TMesh( url:Object, parent_ent:TEntity=Null )
		Local size:Int, oldDir:String
		
		stream = LittleEndianStream(ReadFile(url))
		If stream = Null Then Return Null
		size = stream.Size()
		
		objlist = CreateList()
		materialmap = CreateMap()
		materialcolormap = CreateMap()
		materialshinemap = CreateMap()
		materiallayermap = CreateMap()
		matrixmap = CreateMap()
		
		filepath = ExtractDir(String(url))
		oldDir = CurrentDir()
		If String(url) <> "" Then ChangeDir(ExtractDir(String(url)))
		If Log_Chunks Then DebugLog " filepath: "+filepath
		If Log_Chunks Then DebugLog " oldDir: "+oldDir
		
		Local parent:TMesh = ParseFile(url,size)
		
		If Log_Chunks Then DebugLog " Transform_Verts: "+Transform_Verts
		
		stream.Close()
		ChangeDir(oldDir)
		
		For Local ent:TEntity = EachIn objlist
			Local mesh:TMesh = TMesh(ent)
			Local matrix:TMatrix = TMatrix(MapValueForKey( matrixmap, mesh.EntityName() ))
			
			If matrix <> Null
				If Transform_Verts
					Local invmat:TMatrix = CreateMatrix()
					matrix.GetInverse(invmat)
					mesh.TransformVertices(invmat)
					mesh.cull_radius[0] = 0.0
					If Log_Chunks Then DebugLog " ent.name:"+ent.EntityName()+" parent.name:"+ent.parent.EntityName()
				EndIf
				mesh.SetMatrix(matrix)
			EndIf
			
			'DebugLog "pos:"+animKeys[0].pos[0]+","+ animKeys[0].pos[1]+","+ animKeys[0].pos[2]
			'Local matrix:Float[,] = ent.GetGlobalMatrix()
			'ent.SetMatrix(matrix)
			
			'If animkeys.length > 0
			'	Local oldmat:Float[,] = ent.GetGlobalMatrix()
			
			'	For Local i% = 0 To animkeys.length-1
			'		If animkeys[i]
			'			If animkeys[i].pos ent.pos = animkeys[i].pos[..]
			'			If animkeys[i].rot ent.rot = animkeys[i].rot[..]
			'			If animkeys[i].size ent.size = animkeys[i].size[..]
			'		End If
			
			'		ent.SetAnimKey(i)
			'	Next
			
			'	ent.AddAnimSeq(animkeys.length)
			'	ent.SetMatrix(oldmat)
			'EndIf
			
			' reorient, swap y with -z
			For Local surf:TSurface = EachIn mesh.surf_list
				For Local v% = 0 To surf.no_verts[0]-1
					Local pos_x# = surf.vert_coords[v*3 + 0]
					Local pos_y# = surf.vert_coords[v*3 + 1]
					Local pos_z# = surf.vert_coords[v*3 + 2]
					surf.vert_coords[v*3 + 1] = -pos_z
					surf.vert_coords[v*3 + 2] = pos_y
				Next
			Next
		Next
		
		'surface.UpdateVertices()
		'surface.UpdateTriangles()
		For Local surf:TSurface = EachIn parent.surf_list
			surf.UpdateNormals()
		Next
		parent.AddParent(parent_ent)
		
		' update matrix
		If parent.parent <> Null
			parent.mat.Overwrite(parent.parent.mat)
			parent.UpdateMat()
		Else
			parent.UpdateMat(True)
		EndIf
		
		Return parent
	End Method
End Type
