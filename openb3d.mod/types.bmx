' types.bmx

' Wrapper types
' -------------

Rem
bbdoc: Global
End Rem
Type TGlobal

	Global blob:TBlob=New TBlob
	Global brush:TBrush=New TBrush
	Global cam:TCamera=New TCamera
	Global ent:TEntity=New TEntity
	Global fluid:TFluid=New TFluid
	Global geo:TGeosphere=New TGeosphere
	Global light:TLight=New TLight
	Global mat:TMaterial=New TMaterial
	Global material:TShader=New TShader
	Global mesh:TMesh=New TMesh
	Global octree:TOcTree=New TOcTree
	Global piv:TPivot=New TPivot
	Global shad:TShadowObject=New TShadowObject
	Global sprite:TSprite=New TSprite
	Global stencil:TStencil=New TStencil
	Global surf:TSurface=New TSurface
	Global terr:TTerrain=New TTerrain
	Global tex:TTexture=New TTexture
	Global voxelspr:TVoxelSprite=New TVoxelSprite
	
	Const ALPHA_ENABLE:Int=1, FX1:Int=2, FX2:Int=3, VBO_ENABLED:Int=4
	
	Function GraphicsInit()
	
		TextureFilter("",9)
		
		glewInit() ' required for ARB funcs
		
		' get hardware info and set vbo_enabled accordingly
		THardwareInfo.GetInfo()
		SetRenderState(VBO_ENABLED,THardwareInfo.VBOSupport) ' vertex buffer objects
		
		' save the Max2D settings for later - by Oddball
		glPushAttrib(GL_ALL_ATTRIB_BITS)
		glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS)
		glMatrixMode(GL_MODELVIEW)
		glPushMatrix()
		glMatrixMode(GL_PROJECTION)
		glPushMatrix()
		glMatrixMode(GL_TEXTURE)
		glPushMatrix()
		glMatrixMode(GL_COLOR)
		glPushMatrix()
		
		EnableStates()
		
		glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL,GL_SEPARATE_SPECULAR_COLOR)
		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,GL_TRUE)
		
		glClearDepth(1.0)						
		glDepthFunc(GL_LEQUAL)
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL,0.5)
		
	End Function
	
	Function EnableStates()
	
		glEnable(GL_LIGHTING)
   		glEnable(GL_DEPTH_TEST)
		glEnable(GL_FOG)
		glEnable(GL_CULL_FACE)
		glEnable(GL_SCISSOR_TEST)
		
		glEnable(GL_NORMALIZE)
		
		glEnableClientState(GL_VERTEX_ARRAY)
		glEnableClientState(GL_COLOR_ARRAY)
		glEnableClientState(GL_NORMAL_ARRAY)
		
	End Function
	
End Type

Rem
bbdoc: Utility object
End Rem
Type TUtility

	Field instance:Byte Ptr
	
	Function IsObject:Byte Ptr( obj:TUtility )
	
		If obj=Null
			'DebugLog "Attempt to pass null object to function"
			Return Null
		Else
			Return obj.instance
		EndIf
	
	End Function
	
End Type

Rem
bbdoc: Blob entity
End Rem
Type TBlob Extends TEntity

	Method NewBlob:TBlob( inst:Byte Ptr )
	
		Local blob:TBlob=New TBlob
		entity_map.Insert( String(Long(inst)), blob )
		blob.instance=inst
		Return blob
		
	End Method
	
End Type

Rem
bbdoc: Brush
End Rem
Type TBrush Extends TUtility

	Global brush_map:TMap=New TMap
		
	Method NewBrush:TBrush( inst:Byte Ptr )
	
		Local brush:TBrush=New TBrush
		brush_map.Insert( String(Long(inst)), brush )
		brush.instance=inst
		Return brush
		
	End Method
	
	Method DeleteBrush( inst:Byte Ptr )
	
		brush_map.Remove( String(Long(inst)) )
	
	End Method
	
	Method BrushValue:TBrush( inst:Byte Ptr )
	
		Return TBrush( brush_map.ValueForKey( String(Long(inst)) ) )
	
	End Method
	
End Type

Rem
bbdoc: Camera entity
End Rem
Type TCamera Extends TEntity

	Method NewCamera:TCamera( inst:Byte Ptr )
	
		Local cam:TCamera=New TCamera
		entity_map.Insert( String(Long(inst)), cam )
		cam.instance=inst
		Return cam
		
	End Method
	
End Type

Rem
bbdoc: Entity
about: Contains @{Function CountAllChildren:Int( ent:TEntity, no_children:Int=0 )} 
and @{Method GetChildFromAll:TEntity( child_no:Int, no_children:Int Var, ent:TEntity=Null )}.
End Rem
Type TEntity Extends TUtility

	Global entity_map:TMap=New TMap
		
	Method NewEntity:TEntity( inst:Byte Ptr )

		Local ent:TEntity=New TEntity
		entity_map.Insert( String(Long(inst)), ent )
		ent.instance=inst
		Return ent
		
	End Method
	
	Method DeleteEntity( inst:Byte Ptr )
	
		entity_map.Remove( String(Long(inst)) )
	
	End Method
	
	Method EntityValue:TEntity( inst:Byte Ptr )
	
		Return TEntity( entity_map.ValueForKey( String(Long(inst)) ) )
	
	End Method
	
	' Recursively counts all children of an entity.
	Function CountAllChildren:Int( ent:TEntity, no_children:Int=0 )

		Local children%=CountChildren( ent )
		
		For Local id:Int=1 To children
			no_children=no_children+1
			no_children=CountAllChildren( GetChild( ent, id ), no_children)
		Next
		
		Return no_children
		
	End Function
	
	' Returns the specified child entity of a parent entity.
	Method GetChildFromAll:TEntity( child_no:Int, no_children:Int Var, ent:TEntity=Null )

		If ent=Null Then ent=Self
		
		Local ent2:TEntity=Null
		Local children%=CountChildren( ent )
		
		For Local id:Int=1 To children
			no_children=no_children+1
			If no_children=child_no Then Return GetChild( ent, id )
			
			If ent2=Null
				ent2=GetChildFromAll( child_no, no_children, GetChild( ent, id ) )
			EndIf
		Next
		
		Return ent2
		
	End Method
	
End Type

Rem
bbdoc: Fluid mesh entity
End Rem
Type TFluid Extends TMesh

	Method NewFluid:TFluid( inst:Byte Ptr )
	
		Local fluid:TFluid=New TFluid
		entity_map.Insert( String(Long(inst)), fluid )
		fluid.instance=inst
		Return fluid
		
	End Method
	
End Type

Rem
bbdoc: Geosphere terrain entity
End Rem
Type TGeosphere Extends TTerrain

	Method NewGeosphere:TGeosphere( inst:Byte Ptr )
	
		Local geo:TGeosphere=New TGeosphere
		entity_map.Insert( String(Long(inst)), geo )
		geo.instance=inst
		Return geo
		
	End Method
	
End Type

Rem
bbdoc: Hardware-info
about: Contains @{Function GetInfo()} and @{DisplayInfo(LogFile:Int=False)}.
End Rem
Type THardwareInfo

	' by klepto2
	Global ScreenWidth:Int = DesktopWidth() ' added
	Global ScreenHeight:Int = DesktopHeight()
	Global ScreenDepth:Int = DesktopDepth()
	Global ScreenHertz:Int = DesktopHertz()

	Global Vendor:String
	Global Renderer:String
	Global OGLVersion:String

	Global Extensions:String
	Global VBOSupport:Int		' Vertex Buffer Object
	Global GLTCSupport:Int		' OpenGL's TextureCompression
	Global S3TCSupport:Int		' S3's TextureCompression
	Global AnIsoSupport:Int		' An-Istropic Filtering
	Global MultiTexSupport:Int	' MultiTexturing
	Global TexBlendSupport:Int	' TextureBlend
	Global CubemapSupport:Int	' CubeMapping
	Global DepthmapSupport:Int	' DepthTexturing
	Global VPSupport:Int		' VertexProgram (ARBvp1.0)
	Global FPSupport:Int		' FragmentProgram (ARBfp1.0)
	Global ShaderSupport:Int	' glSlang Shader Program
	Global VSSupport:Int		' glSlang VertexShader
	Global FSSupport:Int		' glSlang FragmentShader
	Global SLSupport:Int		' OpenGL Shading Language 1.00

	Global MaxTextures:Int
	Global MaxTexSize:Int
	Global MaxLights:Int

	Function GetInfo()
	
		Local Extensions:String

		' Get HardwareInfo
		Vendor = String.FromCString(Byte Ptr(glGetString(GL_VENDOR)))
		Renderer = String.FromCString(Byte Ptr(glGetString(GL_RENDERER))) 
		OGLVersion = String.FromCString(Byte Ptr(glGetString(GL_VERSION)))

		' Get Extensions
		Extensions = String.FromCString(Byte Ptr(glGetString(GL_EXTENSIONS)))
		THardwareInfo.Extensions = Extensions

		' Check for Extensions
		THardwareInfo.VBOSupport = Extensions.Find("GL_ARB_vertex_buffer_object") > -1
		THardwareInfo.GLTCSupport = Extensions.Find("GL_ARB_texture_compression")
		THardwareInfo.S3TCSupport = Extensions.Find("GL_EXT_texture_compression_s3tc") > -1
		THardwareInfo.AnIsoSupport = Extensions.Find("GL_EXT_texture_filter_anisotropic")
		THardwareInfo.MultiTexSupport = Extensions.Find("GL_ARB_multitexture") > -1
		THardwareInfo.TexBlendSupport = Extensions.Find("GL_EXT_texture_env_combine") > -1
		If Not THardwareInfo.TexBlendSupport 'SMALLFIXES use the ARB version that works the same
			THardwareInfo.TexBlendSupport = Extensions.Find("GL_ARB_texture_env_combine") > -1
		EndIf
		THardwareInfo.CubemapSupport = Extensions.Find("GL_ARB_texture_cube_map") > -1
		THardwareInfo.DepthmapSupport = Extensions.Find("GL_ARB_depth_texture") > -1
		THardwareInfo.VPSupport = Extensions.Find("GL_ARB_vertex_program") > -1
		THardwareInfo.FPSupport = Extensions.Find("GL_ARB_fragment_program") > -1
		THardwareInfo.ShaderSupport = Extensions.Find("GL_ARB_shader_objects") > -1
		THardwareInfo.VSSupport = Extensions.Find("GL_ARB_vertex_shader") > -1
		THardwareInfo.FSSupport = Extensions.Find("GL_ARB_fragment_shader") > -1
		THardwareInfo.SLSupport = Extensions.Find("GL_ARB_shading_language_100") > - 1
		
		If THardwareInfo.VSSupport = False Or THardwareInfo.FSSupport = False
			THardwareInfo.ShaderSupport = False
		EndIf

		' Get some numerics
		glGetIntegerv(GL_MAX_TEXTURE_UNITS, Varptr(THardwareInfo.MaxTextures))
		glGetIntegerv(GL_MAX_TEXTURE_SIZE, Varptr(THardwareInfo.MaxTexSize))
		glGetIntegerv(GL_MAX_LIGHTS, Varptr(THardwareInfo.MaxLights))
		
	End Function

	Function DisplayInfo(LogFile:Int=False)
	
		Local position:Int, Space:Int, stream:TStream

		If LogFile
		
			stream = WriteStream("HardwareInfo.txt") 
			stream.WriteLine("Hardwareinfo:")
			stream.WriteLine("")

			' Display Desktopinfo
			stream.WriteLine("Width:  "+ScreenWidth)
			stream.WriteLine("Height: "+ScreenHeight)
			stream.WriteLine("Depth:  "+ScreenDepth)
			stream.WriteLine("Hertz:  "+ScreenHertz)
			stream.WriteLine("")
			
			' Display Driverinfo
			stream.WriteLine("Vendor:         "+Vendor)
			stream.WriteLine("Renderer:       "+Renderer)
			stream.WriteLine("OpenGL-Version: "+OGLVersion)
			stream.WriteLine("")

			' Display Hardwareranges
			stream.WriteLine("Max Texture Units: "+MaxTextures)
			stream.WriteLine("Max Texture Size:  "+MaxTexSize)
			stream.WriteLine("Max Lights:        "+MaxLights)
			stream.WriteLine("")

			' Display OpenGL-Extensions
			stream.WriteLine("OpenGL Extensions:")
			While position < Extensions.length
				Space = Extensions.Find(" ", position)
				If Space = -1 Then Exit
				stream.WriteLine(Extensions[position..Space])
				position = Space+1
			Wend

			stream.WriteLine("")
			stream.WriteLine("- Ready -")
			stream.Close()
			
		Else
		
			Print("Hardwareinfo:")
			Print("")
			
			' Display Desktopinfo
			Print("Width:  "+ScreenWidth)
			Print("Height: "+ScreenHeight)
			Print("Depth:  "+ScreenDepth)
			Print("Hertz:  "+ScreenHertz)
			Print("")
			
			' Display Driverinfo
			Print("Vendor:         "+Vendor)
			Print("Renderer:       "+Renderer)
			Print("OpenGL-Version: "+OGLVersion)
			Print("")

			' Display Hardwareranges
			Print("Max Texture Units: "+MaxTextures)
			Print("Max Texture Size:  "+MaxTexSize)
			Print("Max Lights:        "+MaxLights)
			Print("")

			' Display OpenGL-Extensions
			Print("OpenGL Extensions:")
			While position < Extensions.length
				Space = Extensions.Find(" ", position)
				If Space = -1 Then Exit
				Print(Extensions[position..Space])
				position = Space+1
			Wend

			Print("")
			Print("- Ready -")
			
		EndIf
		
	End Function
	
End Type

Rem
bbdoc: Light entity
End Rem
Type TLight Extends TEntity

	Method NewLight:TLight( inst:Byte Ptr )
	
		Local light:TLight=New TLight
		entity_map.Insert( String(Long(inst)), light )
		light.instance=inst
		Return light
		
	End Method
	
End Type

Rem
bbdoc: Material texture
End Rem
Type TMaterial Extends TTexture

	Method NewMaterial:TMaterial( inst:Byte Ptr )
	
		Local mat:TMaterial=New TMaterial
		tex_map.Insert( String(Long(inst)), mat )
		mat.instance=inst
		Return mat
		
	End Method
	
End Type

Rem
bbdoc: Mesh entity
End Rem
Type TMesh Extends TEntity
	
	Method NewMesh:TMesh( inst:Byte Ptr )
	
		Local mesh:TMesh=New TMesh
		entity_map.Insert( String(Long(inst)), mesh )
		mesh.instance=inst
		Return mesh
		
	End Method
	
End Type

Rem
bbdoc: Octree terrain entity
End Rem
Type TOcTree Extends TTerrain

	Method NewOcTree:TOcTree( inst:Byte Ptr )
	
		Local octree:TOcTree=New TOcTree
		entity_map.Insert( String(Long(inst)), octree )
		octree.instance=inst
		Return octree
		
	End Method
	
End Type

Rem
bbdoc: Pivot entity
End Rem
Type TPivot Extends TEntity

	Method NewPivot:TPivot( inst:Byte Ptr )
	
		Local piv:TPivot=New TPivot
		entity_map.Insert( String(Long(inst)), piv )
		piv.instance=inst
		Return piv
		
	End Method
	
End Type

Rem
bbdoc: Shader
End Rem
Type TShader Extends TUtility
	
	Method NewShader:TShader( inst:Byte Ptr )
	
		Local material:TShader=New TShader
		material.instance=inst
		Return material
		
	End Method
	
End Type

Rem
bbdoc: Shadow-object
End Rem
Type TShadowObject Extends TUtility

	Global shad_map:TMap=New TMap
	
	Method NewShadowObject:TShadowObject( inst:Byte Ptr )
	
		Local shad:TShadowObject=New TShadowObject
		shad_map.Insert( String(Long(inst)), shad )
		shad.instance=inst
		Return shad
		
	End Method
	
	Method DeleteShadowObject( inst:Byte Ptr )
	
		shad_map.Remove( String(Long(inst)) )
	
	End Method
	
End Type

Rem
bbdoc: Sprite mesh entity
End Rem
Type TSprite Extends TMesh

	Method NewSprite:TSprite( inst:Byte Ptr )
	
		Local sprite:TSprite=New TSprite
		entity_map.Insert( String(Long(inst)), sprite )
		sprite.instance=inst
		Return sprite
		
	End Method
	
End Type

Rem
bbdoc: Stencil
End Rem
Type TStencil Extends TUtility
	
	Method NewStencil:TStencil( inst:Byte Ptr )
	
		Local stencil:TStencil=New TStencil
		stencil.instance=inst
		Return stencil
		
	End Method
	
End Type

Rem
bbdoc: Surface
End Rem
Type TSurface Extends TUtility

	Global surf_map:TMap=New TMap
		
	Method NewSurface:TSurface( inst:Byte Ptr )
	
		Local surf:TSurface=New TSurface
		surf_map.Insert( String(Long(inst)), surf )
		surf.instance=inst
		Return surf
		
	End Method
	
	Method SurfaceValue:TSurface( inst:Byte Ptr )
	
		Return TSurface( surf_map.ValueForKey( String(Long(inst)) ) )
	
	End Method
	
End Type

Rem
bbdoc: Terrain entity
End Rem
Type TTerrain Extends TEntity

	Method NewTerrain:TTerrain( inst:Byte Ptr )
	
		Local terr:TTerrain=New TTerrain
		entity_map.Insert( String(Long(inst)), terr )
		terr.instance=inst
		Return terr
		
	End Method
	
End Type

Rem
bbdoc: Texture
End Rem
Type TTexture Extends TUtility

	Global tex_map:TMap=New TMap
	
	Method NewTexture:TTexture( inst:Byte Ptr )
	
		Local tex:TTexture=New TTexture
		tex_map.Insert( String(Long(inst)), tex )
		tex.instance=inst
		Return tex
		
	End Method
	
	Method DeleteTexture( inst:Byte Ptr )
	
		tex_map.Remove( String(Long(inst)) )
	
	End Method
	
	Method TextureValue:TTexture( inst:Byte Ptr )
	
		Return TTexture( tex_map.ValueForKey( String(Long(inst)) ) )
	
	End Method
	
End Type

Rem
bbdoc: Voxelsprite mesh entity
End Rem
Type TVoxelSprite Extends TMesh

	Method NewVoxelSprite:TVoxelSprite( inst:Byte Ptr )
	
		Local voxelspr:TVoxelSprite=New TVoxelSprite
		entity_map.Insert( String(Long(inst)), voxelspr )
		voxelspr.instance=inst
		Return voxelspr
		
	End Method
	
End Type
