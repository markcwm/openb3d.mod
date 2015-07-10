Rem
bbdoc: Global
End Rem
Type TGlobal

	Global width:Int,height:Int,Mode:Int,depth:Int,rate:Int
	Global ambient_red#=0.5,ambient_green#=0.5,ambient_blue#=0.5

	Global vbo_enabled_:Int=False ' this is set in GraphicsInit - will be set to true if USE_VBO is true and the hardware supports vbos

	' anti aliasing globs
	Global aa:Int ' anti_alias true/false
	Global ACSIZE:Int ' accum size
	Global jitter:Int
	Global j#[16,2]
	
	Const ALPHA_ENABLE:Int=1, FX1:Int=2, FX2:Int=3, VBO_ENABLED:Int=4
	
	Function Graphics3D( w:Int,h:Int,d:Int=0,m:Int=0,r:Int=60,flags:Int=-1,usecanvas:Int=False )
	
		Select flags ' buffer values: back=2|alpha=4|depth=8|stencil=16|accum=32
			Case -1 ' 2+4+8+16+32
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
			Case -2 ' 2+4
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER
			Case -3 ' 2+8
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER
			Case -4 ' 2+16
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_STENCILBUFFER
			Case -5 ' 2+32
				flags=GRAPHICS_BACKBUFFER|GRAPHICS_ACCUMBUFFER
			Default ' 2
				flags=GRAPHICS_BACKBUFFER
		End Select
		
		width=w
		height=h
		depth=d
		Mode=m
		rate=r
		
		SetGraphicsDriver( GLMax2DDriver(),flags ) ' mixed 2d/3d
		
		If usecanvas ' using a canvas context
			GraphicsResize( width,height )
		Else ' create gfx context
			Graphics( width,height,depth,rate,flags )
		EndIf
		
		GraphicsInit()
		
		Graphics3D_( width,height,depth,Mode,rate )
		
	End Function
	
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
		glHint(GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL,0.5)
		
	End Function
	
	Function AntiAlias( samples:Int )
	
		AntiAlias_( samples )
		
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
	
	' Same as RenderWorld but with anti-aliasing
	Function RenderWorldAA()
	
		
	
	End Function

	' Render camera - renders all meshes camera can see
	Function RenderCamera(cam:TCamera)

		

	End Function
	
	Function AutoFade(cam:TCamera,mesh:TMesh)

		

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
	
	' Adds mesh to a render list, and inserts mesh into correct position within list depending on order and alpha values
	Function RenderListAdd(mesh:TMesh,List:TList)
	
		
		
	End Function

	Function UpdateSprites(cam:TCamera,list:TList)

		
	
	End Function
				
End Type
