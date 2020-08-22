' T3DS2.bmx
' 3DS loader ported from Warner engine (by Bram den Hond)

Type TChunk

	Field id:Int
	Field size:Int
	Field endchunk:Int
	
	Function Create:TChunk(id:Int, size:Int, endchunk:Int)
		Local c:TChunk = New TChunk
		c.id = id
		c.size = size
		c.endchunk = endchunk
		Return c
	End Function
	
End Type

' hierarchy animation - not implemented yet
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

Type T3DS2

	'TGlobal3D.Mesh_Transform: 0=disable, 1=disabled if dummy found, 2=always - manually set by MeshLoader "trans"
	'Global Master_Scale:Float = 0 ' internal - manually set with ScaleMesh/ScaleAnimMesh
	
	Const CHUNK_M3DVERSION% = $0002
	Const CHUNK_MASTERSCALE% = $0100
	Const CHUNK_BKGCOLOR% = $1200
	Const CHUNK_AMBCOLOR% = $2100
	' color chunks
	Const CHUNK_RGB3F% = $0010
	Const CHUNK_RGB3B% = $0011 ' 24-bit
	Const CHUNK_RGBGAMMA3B% = $0012
	Const CHUNK_RGBGAMMA3F% = $0013
	' percent chunks
	Const CHUNK_PERCENTI% = $0030
	Const CHUNK_PERCENTF% = $0031
	' main chunk
	Const CHUNK_MAIN% = $4D4D
	' 3d editor chunk
	Const CHUNK_3DEDITOR% = $3D3D
	' object block
	Const CHUNK_OBJECTBLOCK% = $4000
	Const CHUNK_TRIMESH% = $4100
	Const CHUNK_VERTEXLIST% = $4110
	Const CHUNK_FACELIST% = $4120
	Const CHUNK_FACEMATLIST% = $4130
	Const CHUNK_MAPLIST% = $4140
	Const CHUNK_SMOOTHLIST% = $4150
	Const CHUNK_TRANSMATRIX% = $4160
	Const CHUNK_LIGHT% = $4600
	Const CHUNK_SPOTLIGHT% = $4610
	Const CHUNK_CAMERA% = $4700
	' material block
	Const CHUNK_MATBLOCK% = $AFFF
	Const CHUNK_MATNAME% = $A000
	Const CHUNK_AMBIENT% = $A010
	Const CHUNK_DIFFUSE% = $A020
	Const CHUNK_SPECULAR% = $A030
	Const CHUNK_SHININESS% = $A040
	Const CHUNK_SHININESSSTRENGTH% = $A041
	Const CHUNK_TRANSPARENCY% = $A050
	Const CHUNK_TRANSFALLOFF% = $A052
	Const CHUNK_REFLECTIONBLUR% = $A053
	Const CHUNK_TWOSIDED% = $A081
	Const CHUNK_ADDTRANSPARENCY% = $A083
	Const CHUNK_SELFILLUM% = $A084
	Const CHUNK_WIREFRAMEON% = $A085
	Const CHUNK_WIRETHICKNESS% = $A087
	Const CHUNK_FACEMAP% = $A088
	Const CHUNK_TRANSFALLOFFIN% = $A08A
	Const CHUNK_SOFTEN% = $A08C
	Const CHUNK_WIRETHICKNESSUNITS% = $A08E
	Const CHUNK_RENDERTYPE% = $A100
	Const CHUNK_TRANSFALLOFF2% = $A240
	Const CHUNK_REFLECTIONBLUR2% = $A250
	Const CHUNK_BUMPMAPPERCENT% = $A252
	Const CHUNK_TEXTUREMAP1% = $A200
	Const CHUNK_TEXTUREMAP2% = $A33A
	Const CHUNK_SPECULARMAP% = $A204
	Const CHUNK_OPACITYMAP% = $A210
	Const CHUNK_REFLECTIONMAP% = $A220
	Const CHUNK_BUMPMAP% = $A230
	Const CHUNK_SHININESSMAP% = $A33C
	Const CHUNK_SELFILLUMMAP% = $A33D
	Const CHUNK_MASKTEXTUREMAP1% = $A33E
	Const CHUNK_MASKTEXTUREMAP2% = $A340
	Const CHUNK_MASKOPACITYMAP% = $A342
	Const CHUNK_MASKBUMPMAP% = $A344
	Const CHUNK_MASKSHININESSMAP% = $A346
	Const CHUNK_MASKSPECULARMAP% = $A348
	Const CHUNK_MASKSELFILLUMMAP% = $A34A
	Const CHUNK_MASKREFLECTIONMAP% = $A34C
	' map or mask sub-chunks
	Const CHUNK_MAPFILENAME% = $A300
	Const CHUNK_AUTOREFLECTION% = $A310
	Const CHUNK_MAPPARAMETERS% = $A351
	Const CHUNK_BLUR% = $A353
	Const CHUNK_MAPVSCALE% = $A354
	Const CHUNK_MAPUSCALE% = $A356
	Const CHUNK_MAPUOFFSET% = $A358
	Const CHUNK_MAPVOFFSET% = $A35A
	Const CHUNK_MAPROTATION% = $A35C
	Const CHUNK_RGBALPHATINT1% = $A360
	Const CHUNK_RGBALPHATINT2% = $A362
	Const CHUNK_RGBTINTR% = $A364
	Const CHUNK_RGBTINTG% = $A366
	Const CHUNK_RGBTINTB% = $A368
	' keyframer chunk
	Const CHUNK_KEYFRAMER% = $B000
	Const CHUNK_MESHINFO% = $B002
	Const CHUNK_FRAMES% = $B008
	' information sub-chunks
	Const CHUNK_HIERINFO% = $B010
	Const CHUNK_INSTNAME% = $B011
	Const CHUNK_PIVOT% = $B013
	Const CHUNK_BOUNDBOX% = $B014
	Const CHUNK_POSTRACK% = $B020
	Const CHUNK_ROTTRACK% = $B021
	Const CHUNK_SCALETRACK% = $B022
	Const CHUNK_HIERPOS% = $B030
	
	Field Objlist:TList
	Field Materialmap:TMap
	Field Materialcolormap:TMap
	Field Materialshinemap:TMap
	Field Materiallayermap:TMap
	Field Matrixmap:TMap
	Field Filepath$, Filename$
	Field Stream:TStream
	Field Defaultbrush:TBrush
	Field Root:TMesh
	Field override_texflags:Int
	
	Method GetObject:TEntity( index% )
		If index < 0 Return Null
		If index >= Objlist.Count() Return Null
		
		'If TGlobal3D.Log_3DS Then DebugLog(" GetObject name"+TEntity(Objlist.ToArray()[index]).EntityName())
		Return TEntity(Objlist.ToArray()[index])
	End Method
	
	Method ReadChunk:TChunk()
		If Stream.Eof() Return TChunk.Create(0, 0, 0)
		
		Local id% = Stream.ReadShort()
		Local size% = Stream.ReadInt()
		Local endchunk% = StreamPos(Stream) + size - 6
		
		Return TChunk.Create(id, size, endchunk)
	End Method
	
	Method ParseString:String() ' null-terminated string
		Local char:Byte, CString:String
		
		While Not Stream.Eof()
			char = Stream.ReadByte()
			If char = 0 Then Exit
			CString :+ Chr(char)
		Wend
		
		Return CString
	End Method
	
	Method ParseVertexList:Short( surface:TSurface, parent:TEntity )
		Local count:Short = Stream.ReadShort()
		
		surface.no_verts[0] = count
		surface.vert_norm = surface.SurfaceFloatArrayResize(SURFACE_vert_norm, count*3)
		surface.vert_col = surface.SurfaceFloatArrayResize(SURFACE_vert_col, count*4)
		
		For Local id% = 0 Until count
			Local x# = Stream.ReadFloat()
			Local y# = Stream.ReadFloat()
			Local z# = Stream.ReadFloat()
			
			surface.SurfaceFloatArrayAdd(SURFACE_vert_coords, x)
			surface.SurfaceFloatArrayAdd(SURFACE_vert_coords, y)
			surface.SurfaceFloatArrayAdd(SURFACE_vert_coords, z) ' don't invert z for ogl needed for flip uvs
		Next
		
		Return count
	End Method
	
	Method ParseMapList( surface:TSurface, parent:TEntity )
		Local count:Short = Stream.ReadShort()
		
		surface.vert_tex_coords0 = surface.SurfaceFloatArrayResize(SURFACE_vert_tex_coords0, count*2)
		surface.vert_tex_coords1 = surface.SurfaceFloatArrayResize(SURFACE_vert_tex_coords1, count*2)
		
		For Local id% = 0 Until count
			Local u# = Stream.ReadFloat()
			Local v# = -Stream.ReadFloat() ' flip uvs
			
			surface.VertexTexCoords(id, u, v, 0, 0)
			surface.VertexTexCoords(id, u, v, 0, 1)
		Next
	End Method
	
	Method ParseFaceMatList( surface:TSurface, parent:TEntity )
		Local matname$, count:Short
		matname = ParseString()
		
		Local tex:TTexture = TTexture(MapValueForKey( Materialmap, matname ))
		Local col:Byte[] = Byte[](MapValueForKey( Materialcolormap, matname ))
		Local shine:Float[] = Float[](MapValueForKey( Materialshinemap, matname ))
		Local layer:Int[] = Int[](MapValueForKey( Materiallayermap, matname ))
		
		If tex<>Null
			surface.brush.BrushTexture(tex, 0, layer[0])
			surface.brush.BrushColor(255, 255, 255)
		ElseIf col<>Null
			surface.brush.BrushColor(col[0], col[1], col[2])
		EndIf
		If shine<>Null
			surface.brush.BrushShininess(Float(shine[0]) / 255.0)
		EndIf
		
		count = Stream.ReadShort()
		SeekStream(Stream, Stream.Pos() + count * 2)
	End Method
	
	Method ParseFaceList:Short( surface:TSurface, parent:TEntity, endchunk% )
		Local count:Short = Stream.ReadShort()
		For Local id% = 0 Until count
			Local v0% = Stream.ReadShort()
			Local v1% = Stream.ReadShort()
			Local v2% = Stream.ReadShort()
			Local face_flags:Short = Stream.ReadShort()
			
			surface.AddTriangle(v2, v1, v0) ' reverse winding order needed for flip uvs
		Next
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_FACEMATLIST ' $4130 - faces material list
					If TGlobal3D.Log_3DS Then DebugLog("     CHUNK_FACEMATLIST")
					ParseFaceMatList(surface, parent)
					
				'Case CHUNK_SMOOTHLIST ' $4150 - smoothing groups list
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("     CHUNK_SMOOTHLIST")
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		Return count
	End Method
	
	Method ParseMap:String( parent:TEntity, endchunk% )
		Local texname$ = "", tex:TTexture, val#
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_MAPFILENAME ' $A300 - map filename
					texname = ParseString()
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPFILENAME: "+texname)
					
				'Case CHUNK_AUTOREFLECTION ' $A310
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_AUTOREFLECTION")
				
				'Case CHUNK_MAPPARAMETERS ' $A351
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPPARAMETERS")
					
				'Case CHUNK_BLUR ' $A353 - percent
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_BLUR")
					
				Case CHUNK_MAPVSCALE ' $A354
					val = Stream.ReadFloat()
					tex = TTexture(MapValueForKey( Materialmap, texname ))
					If tex<>Null Then tex.v_scale[0] = val
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPVSCALE: "+val)
					
				Case CHUNK_MAPUSCALE ' $A356
					val = Stream.ReadFloat()
					tex = TTexture(MapValueForKey( Materialmap, texname ))
					If tex<>Null Then tex.u_scale[0] = val
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPUSCALE: "+val)
					
				Case CHUNK_MAPUOFFSET ' $A358
					val = Stream.ReadFloat()
					tex = TTexture(MapValueForKey( Materialmap, texname ))
					If tex<>Null Then tex.u_pos[0] = val
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPUOFFSET: "+val)
					
				Case CHUNK_MAPVOFFSET ' $A35A
					val = Stream.ReadFloat()
					tex = TTexture(MapValueForKey( Materialmap, texname ))
					If tex<>Null Then tex.v_pos[0] = val
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPVOFFSET: "+val)
					
				Case CHUNK_MAPROTATION ' $A35C
					val = Stream.ReadFloat()
					tex = TTexture(MapValueForKey( Materialmap, texname ))
					If tex<>Null Then tex.angle[0] = val
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPROTATION: "+val)
				
				'Case CHUNK_RGBALPHATINT1 ' $A360
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_RGBALPHATINT1")
					
				'Case CHUNK_RGBALPHATINT2 ' $A362
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_RGBALPHATINT2")
				
				'Case CHUNK_RGBTINTR ' $A364
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_RGBTINTR")
					
				'Case CHUNK_RGBTINTG ' $A366
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_RGBTINTG")
					
				'Case CHUNK_RGBTINTB ' $A368
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_RGBTINTB")
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		Return texname
	End Method
	
	Method ParseTriMesh( mesh:TMesh, parent:TEntity, endchunk% )
		Local count:Short, surface:TSurface = Null
		Local matrix:TMatrix = Null
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_VERTEXLIST ' $4110
					If surface = Null Then surface = mesh.CreateSurface()
					count = ParseVertexList(surface, parent)
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_VERTEXLIST: "+count)
					
				Case CHUNK_FACELIST ' $4120
					If surface = Null Then surface = mesh.CreateSurface()
					count = ParseFaceList(surface, parent, chunk.endchunk)
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_FACELIST: "+count)
					
				Case CHUNK_MAPLIST ' $4140 - tex coords
					If surface = Null Then surface = mesh.CreateSurface()
					ParseMapList(surface, parent)
					If TGlobal3D.Log_3DS Then DebugLog("    CHUNK_MAPLIST")
					
				Case CHUNK_TRANSMATRIX ' $4160 - local coords
					matrix = TMatrix.Create()
					matrix.LoadIdentity() ' set grid[x,3]
					
					For Local x% = 0 To 3 ' 4 vectors - X1, X2, X3 (axes), O (origin)
						For Local y% = 0 To 2
							matrix.grid[(4*x)+y] = Stream.ReadFloat()
						Next
					Next
					
					If TGlobal3D.Log_3DS
						DebugLog "    CHUNK_TRANSMATRIX"
						'For Local z% = 0 To 3
						'	DebugLog "    "+matrix.grid[(4*z)+0]+","+matrix.grid[(4*z)+1]+","+matrix.grid[(4*z)+2]+","+matrix.grid[(4*z)+3]
						'Next
					EndIf
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		If matrix<>Null
			MapInsert Matrixmap, mesh, matrix
		EndIf
	End Method
	
	Method ParseAnimKeys:TAnimKey[]( parent:TEntity, endchunk%, animKeys:TAnimKey[], chunk% )
		Local flags% = Stream.ReadShort()
		Local i1% = Stream.ReadInt() 
		Local i2% = Stream.ReadInt()
		Local frameCount% = Stream.ReadShort()
		Local s2% = Stream.ReadShort()
		
		If frameCount >= animKeys.length Then animKeys = animKeys[..frameCount]
		
		Local quat:Float[] = [1.0, 0.0, 0.0, 0.0]
		Local ang#, x#, y#, z#
		
		For Local k% = 0 To frameCount-1
			Local time% = Stream.ReadInt()
			Local flags% = Stream.ReadShort()
			If time >= frameCount Then time = frameCount-1 '0
			
			Local m% = 0
			For Local i% = 1 To 5
				If (flags & m) Stream.ReadFloat()
				m = m * 2
			Next
			
			If animKeys[time] = Null animKeys[time] = New TAnimKey
			
			Select chunk
				Case CHUNK_POSTRACK ' $B020
					x = Stream.ReadFloat()
					y = Stream.ReadFloat()
					z = Stream.ReadFloat()
					animKeys[time].pos = [x, y, z]
					'If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_POSTRACK: "+x+","+y+","+z)
					
				Case CHUNK_ROTTRACK ' $B021
					ang = -Stream.ReadFloat() / 0.0175
					x = Stream.ReadFloat()
					y = Stream.ReadFloat() 'some cases:::  1.swap y and z  2.negate new z
					z = Stream.ReadFloat()
					
					'Local q1:Float[] = NewQuaternion(ang, x, y, z)
					'Local ll# = VectorMagnitude([x, y, z])
					
					'Local test:Float[,] = BuildMatrix([0.0,0.0,0.0],q1,[1.0,1.0,1.0])
					
					'If (ll>EPSILON)
					'	x = x / ll y = y / ll z = z / ll
					'	quat = MultipliedQuaternion(q1, quat)
					'	quat = NormalizeQuaternion(quat)
					'	animKeys[time].rot = quat
					'EndIf
					'animKeys[time].rot = quat
					'If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_ROTTRACK: "+x+","+y+","+z)
					
				Case CHUNK_SCALETRACK ' $B022
					x = Stream.ReadFloat()
					y = Stream.ReadFloat()
					z = Stream.ReadFloat()
					animKeys[time].size = [x, y, z]
					'If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SCALETRACK: "+x+","+y+","+z)
			End Select
		Next
		
		Return animKeys
	End Method
	
	Method ParseMeshInfo( parent:TEntity, endchunk% )
		Local objname$ = "", instname$ = ""
		Local id% = -1, parid% = -1, mesh:TMesh = Null, surface:TSurface = Null
		Local piv_x#=0.0, piv_y#=0.0, piv_z#=0.0
		Local animkeys:TAnimKey[] = New TAnimKey[0]
		'Local animkeys:TAnimationKeys = NewAnimationKeys()
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_HIERPOS ' $B030 - node id
					id = Stream.ReadShort()
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_HIERPOS: "+id)
					
				Case CHUNK_HIERINFO ' $B010 - node header
					'DebugLog "CHUNK_HIERINFO .size="+chunk.size+" .endchunk="+Hex(chunk.endchunk)+" .pos="+Hex(Stream.Pos())
					objname = ParseString()
					Local flag1% = Stream.ReadShort()
					Local flag2% = Stream.ReadShort()
					parid = Stream.ReadShort()
					
					'SeekStream(Stream, chunk.endchunk)
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_HIERINFO: "+objname+", parent="+parid)
					
				Case CHUNK_INSTNAME ' $B011 - dummy name object
					instname = ParseString()
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_INSTNAME: "+instname)
					
				Case CHUNK_PIVOT ' $B013
					piv_x = Stream.ReadFloat()
					piv_y = Stream.ReadFloat()
					piv_z = Stream.ReadFloat()
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_PIVOT: "+piv_x+","+piv_y+","+piv_z)
					
				'Case CHUNK_BOUNDBOX ' $B014
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_BOUNDBOX")
					
				Case CHUNK_POSTRACK ' $B020
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Case CHUNK_ROTTRACK ' $B021
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Case CHUNK_SCALETRACK ' $B022
					animkeys = ParseAnimKeys(parent, endchunk, animkeys, chunk.id)
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		If objname = "$$$DUMMY"
			mesh = TMesh.Create()
			mesh.SetString(mesh.name,instname)
			mesh.SetString(mesh.class_name,"Mesh")
			mesh.AddParent(parent)
			mesh.EntityListAdd(TEntity.entity_list)
			'If TGlobal3D.Mesh_Transform = 1 Then TGlobal3D.Mesh_Transform = 0 ' disable transform vertices
		'Else
			Rem
			For Local ent:TEntity = EachIn Objlist
				If ent.EntityName() = objname
					Local par:TEntity, mesh:TMesh = TMesh(ent)
					
					If parid = 65535 ' root
						par = parent
					Else
						par = GetObject(parid)
					EndIf
					If par = ent Then par = parent ' in case of invalid parent
					If par<>Null Then mesh.SetParent(par)
					
					If mesh.parent<>Null ' update matrix
						mesh.mat.Overwrite(mesh.parent.mat)
						mesh.UpdateMat()
					Else
						mesh.UpdateMat(True)
					EndIf
					
					Local matrix:TMatrix = TMatrix(MapValueForKey( Matrixmap, mesh ))
					
					If parid <> 65535 And matrix = Null 'And mesh.no_surfs[0] = 0 ' if any dummy child mesh found
						If TGlobal3D.Mesh_Transform = 1 Then TGlobal3D.Mesh_Transform = 0 ' don't transform vertices
					EndIf
					
					Exit
				EndIf
			Next
			EndRem
		EndIf
		
	End Method
	
	Method ParseObject( parent:TEntity, endchunk% )
		Local mesh:TMesh = Null', surface:TSurface = Null
		Local objname$ = ParseString()
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_TRIMESH ' $4100 - triangular mesh
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TRIMESH: "+objname)
					mesh = TMesh.Create()
					mesh.SetString(mesh.name,objname)
					mesh.SetString(mesh.class_name,"Mesh")
					mesh.AddParent(parent)
					mesh.EntityListAdd(TEntity.entity_list)
					ListAddLast Objlist, mesh
					ParseTriMesh(mesh, parent, chunk.endchunk)
					
				'Case CHUNK_LIGHT ' $4600
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_LIGHT")
					
				'Case CHUNK_CAMERA ' $4700
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_CAMERA")
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParsePercent:Float( parent:TEntity, endchunk% )
		Local pc:Float
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
			Case CHUNK_PERCENTI ' $0030
				pc = Float(Stream.ReadShort())/100.0
				If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_PERCENTI: "+pc)
				
			Case CHUNK_PERCENTF ' $0031
				pc = Stream.ReadFloat()/100.0
				If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_PERCENTF: "+pc)
				
			Default
				SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		Return pc
	End Method
	
	Method ParseColor:Byte[]( parent:TEntity, endchunk% )
		Local r:Byte = 255, g:Byte = 255, b:Byte = 255
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_RGB3F ' $0010 - 0..1
					r = Stream.ReadFloat() * 255
					g = Stream.ReadFloat() * 255
					b = Stream.ReadFloat() * 255
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_RGB3F: "+r+","+g+","+b)
					
				Case CHUNK_RGB3B ' $0011 - 0..255
					r = Stream.ReadByte()
					g = Stream.ReadByte()
					b = Stream.ReadByte()
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_RGB3B: "+r+","+g+","+b)
					
				Case CHUNK_RGBGAMMA3F ' $0013 - 0..1
					r = Stream.ReadFloat() * 255
					g = Stream.ReadFloat() * 255
					b = Stream.ReadFloat() * 255
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_RGBGAMMA3F: "+r+","+g+","+b)
					
				Case CHUNK_RGBGAMMA3B ' $0012 - 0.255
					r = Stream.ReadByte()
					g = Stream.ReadByte()
					b = Stream.ReadByte()
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_RGBGAMMA3B: "+r+","+g+","+b)
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		Return [r, g, b]
	End Method
	
	Method ParseMaterial( parent:TEntity, endchunk% )
		Local matname$, texname$, layer:Int[] = [0]
		Local col:Byte[] = [Byte(255), Byte(255), Byte(255)]
		Local shine:Float[] = [1.0]
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id		
				Case CHUNK_MATNAME ' $A000
					matname = ParseString()
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MATNAME: "+matname)
					
				'Case CHUNK_AMBIENT ' $A010
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_AMBIENT") ' ignore, same as diffuse
					
				Case CHUNK_DIFFUSE ' $A020
					col = ParseColor(parent, chunk.endchunk)
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_DIFFUSE: "+col[0]+" "+col[1]+" "+col[2])
					
				'Case CHUNK_SPECULAR ' $A030
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SPECULAR") ' specular set by shininess
					
				Case CHUNK_SHININESS ' $A040
					shine[0] = ParsePercent(parent, chunk.endchunk)
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SHININESS: "+shine[0])
					
				'Case CHUNK_SHININESSSTRENGTH ' $A041
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SHININESSSTRENGTH")
					
				'Case CHUNK_TRANSPARENCY ' $A050
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TRANSPARENCY")
					
				'Case CHUNK_TRANSFALLOFF ' $A052
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TRANSFALLOFF")
					
				'Case CHUNK_REFLECTIONBLUR ' $A053
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_REFLECTIONBLUR")
					
				'Case CHUNK_TWOSIDED ' $A081
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TWOSIDED")
					
				'Case CHUNK_ADDTRANSPARENCY ' $A083
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_ADDTRANSPARENCY")
					
				'Case CHUNK_SELFILLUM ' $A084
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SELFILLUM")
					
				'Case CHUNK_WIREFRAMEON ' $A085
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_WIREFRAMEON")
					
				'Case CHUNK_WIRETHICKNESS ' $A087 ' float
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_WIRETHICKNESS")
					
				'Case CHUNK_FACEMAP ' $A088
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_FACEMAP")
					
				'Case CHUNK_TRANSFALLOFFIN ' $A08A
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TRANSFALLOFFIN")
					
				'Case CHUNK_SOFTEN ' $A08C
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SOFTEN")
					
				'Case CHUNK_WIRETHICKNESSUNITS ' $A08E
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_WIRETHICKNESSUNITS")
					
				'Case CHUNK_RENDERTYPE ' $A100 - short, 1=flat 2=gouraud 3=phong 4=metal
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_RENDERTYPE")
					
				'Case CHUNK_TRANSFALLOFF2 ' $A240
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TRANSFALLOFF2")
					
				'Case CHUNK_REFLECTIONBLUR2 ' $A250
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_REFLECTIONBLUR2")
					
				'Case CHUNK_BUMPMAPPERCENT ' $A252
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_BUMPMAPPERCENT")
					
				Case CHUNK_TEXTUREMAP1 ' $A200
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TEXTUREMAP1")
					layer[0] = 0
					texname = ParseMap(parent, chunk.endchunk)
					
				Case CHUNK_TEXTUREMAP2 ' $A33A
					If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_TEXTUREMAP2")
					layer[0] = 1
					texname = ParseMap(parent, chunk.endchunk)
					
				'Case CHUNK_SPECULARMAP ' $A204
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SPECULARMAP")
					
				'Case CHUNK_OPACITYMAP ' $A210
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_OPACITYMAP")
					
				'Case CHUNK_REFLECTIONMAP ' $A220
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_REFLECTIONMAP")
					
				'Case CHUNK_BUMPMAP ' $A230
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_BUMPMAP")
					
				'Case CHUNK_SHININESSMAP ' $A33C
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SHININESSMAP")
					
				'Case CHUNK_SELFILLUMMAP ' $A33D
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_SELFILLUMMAP")
					
				'Case CHUNK_MASKTEXTUREMAP1 ' $A33E
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKTEXTUREMAP1")
					
				'Case CHUNK_MASKTEXTUREMAP2 ' $A340
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKTEXTUREMAP2")
					
				'Case CHUNK_MASKOPACITYMAP ' $A342
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKOPACITYMAP")
					
				'Case CHUNK_MASKBUMPMAP ' $A344
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKBUMPMAP")
					
				'Case CHUNK_MASKSHININESSMAP ' $A346
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKSHININESSMAP")
					
				'Case CHUNK_MASKSPECULARMAP ' $A348
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKSPECULARMAP")
					
				'Case CHUNK_MASKSELFILLUMMAP ' $A34A
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKSELFILLUMMAP")
					
				'Case CHUNK_MASKREFLECTIONMAP ' $A34C
				'	SeekStream(Stream, chunk.endchunk)
				'	If TGlobal3D.Log_3DS Then DebugLog("   CHUNK_MASKREFLECTIONMAP")
					
				Default
					SeekStream(Stream, chunk.endchunk)
					
			End Select
		Wend
		
		Local name$ = StripDir(texname)
		If Filename.StartsWith("incbin::") Or Filename.StartsWith("zip::")
			name = Filepath + "/" + StripDir(texname)
		EndIf
		
		Local tex:TTexture = LoadTexture(name, override_texflags) ' check material has texture, bad path crash streams
		If TGlobal3D.Log_3DS Then DebugLog(" MAT TEX name="+name+" matname="+matname+" texname="+texname)
		
		MapInsert Materialmap, matname, tex
		MapInsert Materialcolormap, matname, col
		MapInsert Materialshinemap, matname, shine
		MapInsert Materiallayermap, matname, layer
		
		If tex<>Null
			Defaultbrush.BrushTexture(tex, 0, layer[0])
			Defaultbrush.BrushColor(255, 255, 255)
		ElseIf col<>Null
			Defaultbrush.BrushColor(col[0], col[1], col[2])
		EndIf
		If shine<>Null
			Defaultbrush.BrushShininess(Float(shine[0]) / 255.0)
		EndIf
		
	End Method
	
	Method ParseKeyFrames( parent:TEntity, endchunk% )
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
			Case CHUNK_MESHINFO ' $B002 - mesh information
				If TGlobal3D.Log_3DS Then DebugLog("  CHUNK_MESHINFO")
				ParseMeshInfo(parent, chunk.endchunk)
				
			Default
				SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParseScene( parent:TEntity, endchunk% )
		
		While StreamPos(Stream) < endchunk
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_OBJECTBLOCK ' $4000
					If TGlobal3D.Log_3DS Then DebugLog("  CHUNK_OBJECTBLOCK")
					ParseObject(parent, chunk.endchunk)
					
				Case CHUNK_MATBLOCK ' $AFFF - material block
					If TGlobal3D.Log_3DS Then DebugLog("  CHUNK_MATBLOCK")
					ParseMaterial(parent, chunk.endchunk)
				
				Case CHUNK_MASTERSCALE ' $0100
					Local scale# = Stream.ReadFloat()
					If TGlobal3D.Log_3DS Then DebugLog("  CHUNK_MASTERSCALE: "+scale)
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
	End Method
	
	Method ParseFile:TMesh( url:Object, parent_ent:TEntity=Null )
	
		Local parent:TMesh = TMesh.Create()
		parent.SetString(parent.name,"ROOT")
		parent.SetString(parent.class_name,"Mesh")
		parent.AddParent(parent_ent)
		parent.EntityListAdd(TEntity.entity_list)
		
		' update matrix
		If parent.parent<>Null
			parent.mat.Overwrite(parent.parent.mat)
			parent.UpdateMat()
		Else
			parent.UpdateMat(True)
		EndIf
		
		While Not Stream.Eof()
			Local chunk:TChunk = ReadChunk()
			If chunk.id = 0 Then Exit
			
			Select chunk.id
				Case CHUNK_3DEDITOR ' $3D3D
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_3DEDITOR")
					ParseScene(parent, chunk.endchunk)
					
				Case CHUNK_KEYFRAMER ' $B000
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_KEYFRAMER")
					ParseKeyFrames(parent, chunk.endchunk)
					
				Case CHUNK_M3DVERSION ' $0002
					Local version% = Stream.ReadInt()
					If TGlobal3D.Log_3DS Then DebugLog(" CHUNK_M3DVERSION: "+version)
					
				Default
					SeekStream(Stream, chunk.endchunk)
			End Select
		Wend
		
		Return parent
	End Method
	
	Function LoadAnim3DS:TMesh( url:Object, parent_ent_ext:TEntity=Null, texflags:Int = -1 )
		Local file:TStream=LittleEndianStream(ReadFile(url))
		If file = Null
			DebugLog " Invalid 3DS stream: "+String(url)
			Return Null
		EndIf
		
		Local model:T3DS2 = New T3DS2
		Local mesh:TMesh=model.LoadAnim3DSFromStream(file, url, parent_ent_ext, texflags)
		
		file.Close()
		Return mesh
	End Function
	
	Method LoadAnim3DSFromStream:TMesh( file:TStream, url:Object, parent_ent:TEntity=Null, texflags:Int = -1 )
	
		Stream = file
		Objlist = CreateList()
		Materialmap = CreateMap()
		Materialcolormap = CreateMap()
		Materialshinemap = CreateMap()
		Materiallayermap = CreateMap()
		Matrixmap = CreateMap()
		Defaultbrush = CreateBrush()
		If texflags = -1 Then override_texflags = TGlobal3D.Texture_Flags Else override_texflags = texflags
		
		Filename = String(url)
		Filepath = ExtractDir(String(url))
		Local olddir:String = CurrentDir()
		If Filepath <> "" Then ChangeDir(Filepath)
		
		Local chunk:TChunk = ReadChunk()
		If (chunk.id <> CHUNK_MAIN) Or (chunk.size <> Stream.Size()) ' $4D4D
			Stream.Close()
			DebugLog " Invalid 3DS file: "+Filename
			Return Null
		EndIf
		If TGlobal3D.Log_3DS Then DebugLog(" Filename: "+Filename)
		
		Root = ParseFile(url, parent_ent)
		
		'If TGlobal3D.Log_3DS Then DebugLog(" Mesh_Transform: "+TGlobal3D.Mesh_Transform)
		'If TGlobal3D.Log_3DS Then DebugLog(" override_texflags: "+override_texflags)
		
		ChangeDir(olddir)
		
		'Local vec:TVector
		'For Local ent:TEntity = EachIn Objlist ' master scale is largest matrix value, ignore CHUNK_MASTERSCALE
			'Local mesh:TMesh = TMesh(ent)
			'Local matrix:TMatrix = TMatrix(MapValueForKey( Matrixmap, mesh ))
			
			'If matrix<>Null And TGlobal3D.Mesh_Transform > 0
			'	vec = matrix.GetMatrixScale()
			'	If vec.x > Master_Scale Then Master_Scale = vec.x
			'	If vec.y > Master_Scale Then Master_Scale = vec.y
			'	If vec.z > Master_Scale Then Master_Scale = vec.z
			'EndIf
		'Next
		
		'If TGlobal3D.Log_3DS Then DebugLog(" Master_Scale:"+Master_Scale)
		
		'For Local ent:TEntity = EachIn Objlist ' normalize matrix (scale down) if too large
			'Local mesh:TMesh = TMesh(ent)
			'Local matrix:TMatrix = TMatrix(MapValueForKey( Matrixmap, mesh ))
			
			'If matrix<>Null And TGlobal3D.Mesh_Transform > 0 And Master_Scale > 1.0 ' if < 1 it would scale up
			'	matrix.Scale(1.0 / Master_Scale, 1.0 / Master_Scale, 1.0 / Master_Scale)
			'EndIf
		'Next
		
		For Local ent:TEntity = EachIn Objlist ' transform vertices, re-positions mesh by matrix
			Local mesh2:TMesh = TMesh(ent)
			Local mat:TMatrix = TMatrix(MapValueForKey( Matrixmap, mesh2 ))
			Local invmat:TMatrix = TMatrix.Create()
			If mat<>Null Then mat.GetInverse(invmat)
			
			For Local surf2:TSurface = EachIn mesh2.surf_list
				For Local v:Int = 0 Until surf2.CountVertices()
					Local px:Float = surf2.vert_coords[(v*3)+0]
					Local py:Float = surf2.vert_coords[(v*3)+1]
					Local pz:Float = -surf2.vert_coords[(v*3)+2]
					
					If TGlobal3D.Mesh_Transform > 0
						invmat.TransformVec(px, py, pz, 1)
						surf2.vert_coords[(v*3)+0] = px
						surf2.vert_coords[(v*3)+1] = py
						surf2.vert_coords[(v*3)+2] = -pz
					EndIf
				Next
				surf2.UpdateNormals()
			Next
			
			mesh2.cull_radius[0] = 0.0
			'If TGlobal3D.Log_3DS Then DebugLog(" ent.name:"+ent.EntityName()+" Root.name:"+ent.Root.EntityName())
		Next
		
		Rem ' animation
		For Local ent:TEntity = EachIn Objlist
			Local mesh:TMesh = TMesh(ent)
			Local mat:TMatrix = TMatrix(MapValueForKey( Matrixmap, mesh ))
			
			'DebugLog "pos:"+animKeys[0].pos[0]+","+ animKeys[0].pos[1]+","+ animKeys[0].pos[2]
			Local matrix:Float[,] = ent.GetGlobalMatrix()
			'ent.SetMatrix(matrix)
			
			If animkeys.length > 0
				Local oldmat:Float[,] = ent.GetGlobalMatrix()
			
				For Local i% = 0 To animkeys.length-1
					If animkeys[i]
						If animkeys[i].pos ent.pos = animkeys[i].pos[..]
						If animkeys[i].rot ent.rot = animkeys[i].rot[..]
						If animkeys[i].size ent.size = animkeys[i].size[..]
					End If
			
					ent.SetAnimKey(i)
				Next
			
				ent.AddAnimSeq(animkeys.length)
				'ent.SetMatrix(oldmat)
			EndIf
		Next
		EndRem
		
		If TGlobal3D.Log_3DS Then DebugLog("")
		Return Root
	End Method
	
End Type
