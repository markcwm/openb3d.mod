
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
	Global ambient_shader:TShader ' openb3d - set in AmbientShader
	
	' vbo_enabled is set in GraphicsInit - set to true if USE_VBO is true and the hardware supports vbos
	Global vbo_enabled:Int Ptr ' true
	Global vbo_min_tris:Int Ptr ' 0
	
	Global Shadows_enabled:Int Ptr ' false
	
	Global anim_speed:Float Ptr ' 1.0
	
	' fog_enabled keeps track of whether fog is enabled between camera update and mesh render
	Global fog_enabled:Int Ptr ' false
	
	Global root_ent:TPivot ' new
	
	Global camera_in_use:TCamera ' set in CreateCamera/ShowEntity
	
	Global alpha_enable:Int Ptr ' -1
	Global blend_mode:Int Ptr ' -1
	Global fx1:Int Ptr ' -1
	Global fx2:Int Ptr ' -1
	
	' minib3d: anti aliasing globs
	'Global aa:Int ' anti_alias true/false
	'Global ACSIZE:Int ' accum size
	'Global jitter:Int
	'Global j#[16,2]
	
	' wrapper
	Global gfx:TGraphics
	
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
		
		alpha_enable=StaticInt_( GLOBAL_class,GLOBAL_alpha_enable )
		blend_mode=StaticInt_( GLOBAL_class,GLOBAL_blend_mode )
		fx1=StaticInt_( GLOBAL_class,GLOBAL_fx1 )
		fx2=StaticInt_( GLOBAL_class,GLOBAL_fx2 )
		
		' all other InitGlobals
		TCamera.InitGlobals()
		TEntity.InitGlobals()
		TLight.InitGlobals()
		TPick.InitGlobals()
		TShadowObject.InitGlobals()
		TTerrain.InitGlobals()
		
		LoaderMatrix("3ds", 1,0,0, 0,0,1, 0,1,0) ' swap z/y axis
		
	End Function
	
	Function CopyList( list:TList )
	
		Select list
			Case TCamera.cam_list
				TCamera.CopyList_( TCamera.cam_list )
			Case TEntity.entity_list
				TEntity.CopyList_( TEntity.entity_list )
			Case TEntity.animate_list
				TEntity.CopyList_( TEntity.animate_list )
			Case TLight.light_list
				TLight.CopyList_( TLight.light_list )
			Case TPick.ent_list
				TPick.CopyList_( TPick.ent_list )
			Case TShadowObject.shadow_list
				TShadowObject.CopyList_( TShadowObject.shadow_list )
			Case TTerrain.terrain_list
				TTerrain.CopyList_( TTerrain.terrain_list )
			Case TTexture.tex_list
				TTexture.CopyList_( TTexture.tex_list )
			Case TTexture.tex_list_all
				TTexture.CopyList_( TTexture.tex_list_all )
		End Select
		
	End Function
	
	Function EntityListAdd( list:TList,value:Object,ent:TEntity )
	
		Local mesh:TMesh=TMesh(ent)
		If mesh
			mesh.MeshListAdd( list,value )
		Else
			ent.EntityListAdd( list,value )
		EndIf
		
	End Function
	
	' Extra
	
	Function CheckFramebufferStatus( target% )
	
		Local status:Int=glCheckFramebufferStatusEXT(target) ' check for framebuffer errors
		
		Select status
			Case GL_FRAMEBUFFER_COMPLETE_EXT
				DebugLog "FBO created"
			Case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT
				DebugLog "Incomplete attachment"
			Case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT
				DebugLog "Missing attachment"
			Case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT
				DebugLog "Incomplete dimensions"
			Case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT
				DebugLog "Incomplete formats"
			Case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT
				DebugLog "Incomplete draw buffer"
			Case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT
				DebugLog "Incomplete read buffer"
			Case GL_FRAMEBUFFER_UNSUPPORTED_EXT
				DebugLog "Type is not Supported"
			Default
				DebugLog "FBO unsuccessful: "+status
		EndSelect
		
	End Function
	
	Function TrisRendered:Int()
	
		Return TrisRendered_()
		
	End Function
	
	' Minib3d
	
	Function GraphicsInit()
	
		TextureFilter("",9)
		?Not opengles
		glewInit() ' required for ARB funcs
		?
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
	
		If entities
			ClearList(TGlobal.root_ent.child_list) ; TGlobal.root_ent.child_list_id=0
			ClearList(TEntity.entity_list) ; TEntity.entity_list_id=0
			ClearList(TEntity.animate_list) ; TEntity.animate_list_id=0
			ClearList(TCamera.cam_list) ; TCamera.cam_list_id=0
			ClearList(TPick.ent_list) ; TPick.ent_list_id=0
		EndIf
		
		If textures
			For Local tex:TTexture=EachIn TTexture.tex_list
				TTexture.FreeObject( TTexture.GetInstance(tex) ) ' no FreeEntity
			Next
			ClearList(TTexture.tex_list) ; TTexture.tex_list_id=0
			ClearList(TTexture.tex_list_all) ; TTexture.tex_list_all_id=0
		EndIf
		
		ClearWorld_( entities,brushes,textures )
		
	End Function
	
	Function UpdateWorld( anim_speed:Float=1 )
	
		UpdateWorld_( anim_speed )
		
	End Function
	
	Function RenderWorld()
	
		RenderWorld_()
		
	End Function
	
	' Internal
	
	' renders all meshes camera can see (same as method in TCamera)
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
