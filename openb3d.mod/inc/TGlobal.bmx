
Rem
bbdoc: Global
End Rem
Type TGlobal

	Global width:Int Ptr
	Global height:Int Ptr
	Global Mode:Int Ptr
	Global depth:Int Ptr
	Global rate:Int Ptr
	
	Global ambient_red:Float Ptr ' 0.5
	Global ambient_green:Float Ptr ' 0.5
	Global ambient_blue:Float Ptr ' 0.5
	'Global ambient_shader:TShader ' *todo* openb3d
	
	' vbo_enabled is set in GraphicsInit - set to true if USE_VBO is true and the hardware supports vbos
	Global vbo_enabled:Int Ptr ' true
	Global vbo_min_tris:Int Ptr ' 0
	
	Global Shadows_enabled:Int Ptr ' false
	
	Global anim_speed:Float Ptr ' 1.0
	
	' fog_enabled keeps track of whether fog is enabled between camera update and mesh render
	Global fog_enabled:Int Ptr ' false
	
	Global root_ent:TPivot ' new
	
	Global camera_in_use:TCamera
	
	Global alpha_enable:Int Ptr ' -1
	Global blend_mode:Int Ptr ' -1
	Global fx1:Int Ptr ' -1
	Global fx2:Int Ptr ' -1
	
	' minib3d: anti aliasing globs
	'Global aa:Int ' anti_alias true/false
	'Global ACSIZE:Int ' accum size
	'Global jitter:Int
	'Global j#[16,2]
	
	Function InitGlobals() ' Once per Graphics3D
	
		width=StaticInt_( GLOBAL_class,GLOBAL_width )
		height=StaticInt_( GLOBAL_class,GLOBAL_height )
		Mode=StaticInt_( GLOBAL_class,GLOBAL_mode )
		depth=StaticInt_( GLOBAL_class,GLOBAL_depth )
		rate=StaticInt_( GLOBAL_class,GLOBAL_rate )
	
		ambient_red=StaticFloat_( GLOBAL_class,GLOBAL_ambient_red )
		ambient_green=StaticFloat_( GLOBAL_class,GLOBAL_ambient_green )
		ambient_blue=StaticFloat_( GLOBAL_class,GLOBAL_ambient_blue )
	
		vbo_enabled=StaticInt_( GLOBAL_class,GLOBAL_vbo_enabled )
		vbo_min_tris=StaticInt_( GLOBAL_class,GLOBAL_vbo_min_tris )
	
		Shadows_enabled=StaticInt_( GLOBAL_class,GLOBAL_Shadows_enabled )
	
		anim_speed=StaticFloat_( GLOBAL_class,GLOBAL_anim_speed )
	
		fog_enabled=StaticInt_( GLOBAL_class,GLOBAL_fog_enabled )
	
		root_ent=TPivot.CreateObject( StaticPivot_( GLOBAL_class,GLOBAL_root_ent ) )
		
		camera_in_use=TCamera.CreateObject( StaticCamera_( GLOBAL_class,GLOBAL_camera_in_use ) )
		
		alpha_enable=StaticInt_( GLOBAL_class,GLOBAL_alpha_enable )
		blend_mode=StaticInt_( GLOBAL_class,GLOBAL_blend_mode )
		fx1=StaticInt_( GLOBAL_class,GLOBAL_fx1 )
		fx2=StaticInt_( GLOBAL_class,GLOBAL_fx2 )
		
		' all other InitGlobals
		TCamera.InitGlobals()
		TCollisionPair.InitGlobals()
		TEntity.InitGlobals()
		TLight.InitGlobals()
		TPick.InitGlobals()
		TShadowObject.InitGlobals()
		
	End Function
	
	' Minib3d
	
	Function Graphics3D( w:Int,h:Int,d:Int=0,m:Int=0,r:Int=60,flags:Int=-1,usecanvas:Int=False )
	
		Select flags ' back=2|alpha=4|depth=8|stencil=16|accum=32
			Case -1 ' all
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
			Case -2 ' all except accum
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER
			Case -3 ' alpha
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER
			Case -4 ' depth
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER
			Case -5 ' stencil
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_STENCILBUFFER
			Case -6 ' accum
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ACCUMBUFFER
			Default ' none
				flags=GRAPHICS_BACKBUFFER
		End Select
		
		InitGlobals()
		
		width[0]=w
		height[0]=h
		depth[0]=d
		Mode[0]=m
		rate[0]=r
		
		SetGraphicsDriver( GLMax2DDriver(),flags ) ' mixed 2d/3d
		
		If usecanvas=False Then Graphics( w,h,d,r,flags ) ' create gfx context
		
		GraphicsInit()
		
		Graphics3D_( w,h,d,m,r )
		
	End Function
	
	Function GraphicsInit()
	
		TextureFilter("",9)
		
		glewInit() ' required for ARB funcs
		
		' get hardware info and set vbo_enabled accordingly
		THardwareInfo.GetInfo()
		vbo_enabled[0]=THardwareInfo.VBOSupport ' vertex buffer objects
		
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
		glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL,0.5)
		
	End Function
	
	' enable rendering states
	Function EnableStates()
	
		glEnable(GL_LIGHTING)
   		glEnable(GL_DEPTH_TEST)
		glEnable(GL_FOG)
		glEnable(GL_CULL_FACE)
		glEnable(GL_SCISSOR_TEST)
		
		glEnable(GL_NORMALIZE)
		
		glEnableClientState(GL_VERTEX_ARRAY) ' vertex coordinates
		glEnableClientState(GL_COLOR_ARRAY) ' vertex colors
		glEnableClientState(GL_NORMAL_ARRAY) ' surface normals
	
	End Function
	
	Function Wireframe( enable:Int )
	
		Wireframe_( enable )
		
	End Function
	
	Function AmbientLight( r:Float,g:Float,b:Float )
	
		AmbientLight_( r,g,b )
	
	End Function
	
	Function ClearCollisions()
	
		ClearCollisions_()
		
	End Function
	
	Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
	
		Collisions_( src_no,dest_no,method_no,response_no )
	
	End Function
	
	Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
	
		ClearWorld_( entities,brushes,textures )
		
	End Function
	
	Function UpdateWorld( anim_speed:Float=1 )
	
		UpdateWorld_( anim_speed )
		
	End Function
	
	Function RenderWorld()
	
		RenderWorld_()
		
	End Function
	
	' Internal
	
	' Render camera - renders all meshes camera can see (same as method in TCamera)
	Function RenderCamera( cam:TCamera )
	
		CameraRender_( TCamera.GetInstance(cam) )
		
	End Function
	
	' called in UpdateWorld
	Function UpdateEntityAnim( mesh:TMesh )
	
		UpdateEntityAnim_( TMesh.GetInstance(mesh) )
		
	End Function
	
	Rem
	' Adds mesh to a render list, and inserts mesh into correct position
	' within list depending on order and alpha values
	Function RenderListAdd( mesh:TMesh,list:TList ) ' moved to TCamera.bmx
	
		
		
	End Function
	EndRem
	
	Rem
	' renamed in Openb3d to UpdateEntityRender/UpdateSprite - called by Camera::Render (in RenderWorld)
	Function UpdateSprites( cam:TCamera,list:TList )

		
	
	End Function
	EndRem
	
	Rem
	' removed in Openb3d since it was too slow and used the accum buffer
	Function AntiAlias( samples:Int )
	
		AntiAlias_( samples )
		
	End Function
	EndRem
	
	Rem
	' removed in Openb3d - same as RenderWorld but with anti-aliasing
	Function RenderWorldAA()
	
		
	
	End Function
	EndRem
	
	Rem
	' removed in Openb3d - called by Camera::Render (in RenderWorld)
	Function AutoFade( cam:TCamera,mesh:TMesh )

		

	End Function
	EndRem
	
End Type
