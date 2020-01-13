
Rem
bbdoc: Global
about: Renamed to fix conflict with BRL.Reflection.
End Rem
Type TGlobal3D

	Global width:Int Ptr
	Global height:Int Ptr
	Global Mode:Int Ptr
	Global depth:Int Ptr
	Global rate:Int Ptr
	
	Global ambient_red:Float Ptr ' 0.5
	Global ambient_green:Float Ptr ' 0.5
	Global ambient_blue:Float Ptr ' 0.5
	
	' vbo_enabled is set in GraphicsInit - set to true if the hardware supports vbos
	Global vbo_enabled:Int Ptr ' true
	Global vbo_min_tris:Int Ptr ' 0
	
	Global Shadows_enabled:Int Ptr ' false
	
	Global anim_speed:Float Ptr ' 1.0
	
	' fog_enabled keeps track of whether fog is enabled between camera update and mesh render
	Global fog_enabled:Int Ptr ' false
	
	Global root_ent:TPivot ' new
	Global camera_in_use:TCamera ' set in CreateCamera/ShowEntity
	Global ambient_shader:TShader ' openb3d - set in AmbientShader
	
	Global alpha_enable:Int Ptr ' -1
	Global blend_mode:Int Ptr ' -1
	Global fx1:Int Ptr ' -1
	Global fx2:Int Ptr ' -1
	
	Global pivots_exist:Int=0
	Global piv1o:TPivot
	Global piv1:TPivot
	Global piv11:TPivot
	Global piv111:TPivot
	Global piv2o:TPivot
	Global piv2:TPivot
	
	' minib3d: anti aliasing globs
	'Global aa:Int ' anti_alias true/false
	'Global ACSIZE:Int ' accum size
	'Global jitter:Int
	'Global j#[16,2]
	
	' wrapper
	Global gfx_obj:TGraphics
	Global txt_r:Byte=255, txt_g:Byte=255, txt_b:Byte=255 ' TextColor, in bytes
	
	Global Log_New:Int=False		' True to debug when new 3d object created
	Global Log_Del:Int=False		' True to debug when 3d object destroyed
	Global Log_3DS:Int=False		' True to debug 3DS chunks
	Global Log_B3D:Int=False		' True to debug B3D chunks
	Global Log_MD2:Int=False		' True to debug MD2 chunks
	Global Log_Assimp:Int=False		' True to debug Assimp
	
	Global GL_Version:Float=0		' current GL version
	Global Texture_Loader:Int=1		' 1=blitzmax, 2=library
	Global Mesh_Loader:Int=1		' 1=blitzmax, 2=library
	Global Mesh_Flags:Int=-1		' Assimp mesh flags
	Global Texture_Flags:Int=9		' LoadTexture flags
	Global Mesh_Transform:Int=False	' mesh transform vertices
	Global Loader_3DS2:Int=False	' alternative 3DS loader
	Global Cubemap_Frame:Int[12]
	Global Cubemap_Face:Int[12]
	Global Flip_Cubemap:Int=1		' flip cubic environment map orientation
	
	Global Matrix_3DS:TMatrix
	Global Matrix_B3D:TMatrix
	Global Matrix_MD2:TMatrix
	
	Function InitGlobals() ' Once per Graphics3D
	
		' int
		width=StaticInt_( GLOBAL_class,GLOBAL_width )
		height=StaticInt_( GLOBAL_class,GLOBAL_height )
		Mode=StaticInt_( GLOBAL_class,GLOBAL_mode )
		depth=StaticInt_( GLOBAL_class,GLOBAL_depth )
		rate=StaticInt_( GLOBAL_class,GLOBAL_rate )
		vbo_enabled=StaticInt_( GLOBAL_class,GLOBAL_vbo_enabled )
		vbo_min_tris=StaticInt_( GLOBAL_class,GLOBAL_vbo_min_tris )
		Shadows_enabled=StaticInt_( GLOBAL_class,GLOBAL_Shadows_enabled )
		fog_enabled=StaticInt_( GLOBAL_class,GLOBAL_fog_enabled )
		alpha_enable=StaticInt_( GLOBAL_class,GLOBAL_alpha_enable )
		blend_mode=StaticInt_( GLOBAL_class,GLOBAL_blend_mode )
		fx1=StaticInt_( GLOBAL_class,GLOBAL_fx1 )
		fx2=StaticInt_( GLOBAL_class,GLOBAL_fx2 )
		
		' float
		ambient_red=StaticFloat_( GLOBAL_class,GLOBAL_ambient_red )
		ambient_green=StaticFloat_( GLOBAL_class,GLOBAL_ambient_green )
		ambient_blue=StaticFloat_( GLOBAL_class,GLOBAL_ambient_blue )
		anim_speed=StaticFloat_( GLOBAL_class,GLOBAL_anim_speed )
		
		' pivot
		root_ent=TPivot.CreateObject( StaticPivot_( GLOBAL_class,GLOBAL_root_ent ) )
		
		' all other InitGlobals
		TCamera.InitGlobals()
		TEntity.InitGlobals()
		TLight.InitGlobals()
		TPick.InitGlobals()
		TShadowObject.InitGlobals()
		TTerrain.InitGlobals()
		TBatchSprite.InitGlobals()
		TTexture.InitGlobals()
		
		Matrix_3DS=NewMatrix()
		Matrix_3DS.LoadIdentity()
		Matrix_B3D=NewMatrix()
		Matrix_B3D.LoadIdentity()
		Matrix_MD2=NewMatrix()
		Matrix_MD2.LoadIdentity()
		LoaderMatrix "3ds", 1,0,0, 0,1,0, 0,0,-1 ' swap y/z - removed as wasn't working right on multi-mesh
		LoaderMatrix "b3d", 1,0,0, 0,1,0, 0,0,1 ' not implemented at all
		LoaderMatrix "md2", 1,0,0, 0,0,1, 0,-1,0 ' swap z/y and invert y
		
		TextureLoader "faces",0,1,2,3,4,5 ' lf-x, fr+z, rt+x, bk-z, up+y, dn-y
		TextureLoader "frames",0,1,2,3,4,5
		
	End Function
	
	Function DebugGlobals( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" Global: "
		
		' int
		If width<>Null Then DebugLog(pad+" width: "+width[0]) Else DebugLog(pad+" width: Null")
		If height<>Null Then DebugLog(pad+" height: "+height[0]) Else DebugLog(pad+" height: Null")
		If Mode<>Null Then DebugLog(pad+" Mode: "+Mode[0]) Else DebugLog(pad+" Mode: Null")
		If depth<>Null Then DebugLog(pad+" depth: "+depth[0]) Else DebugLog(pad+" depth: Null")
		If rate<>Null Then DebugLog(pad+" rate: "+rate[0]) Else DebugLog(pad+" rate: Null")
		If vbo_enabled<>Null Then DebugLog(pad+" vbo_enabled: "+vbo_enabled[0]) Else DebugLog(pad+" vbo_enabled: Null")
		If vbo_min_tris<>Null Then DebugLog(pad+" vbo_min_tris: "+vbo_min_tris[0]) Else DebugLog(pad+" vbo_min_tris: Null")
		If Shadows_enabled<>Null Then DebugLog(pad+" Shadows_enabled: "+Shadows_enabled[0]) Else DebugLog(pad+" Shadows_enabled: Null")
		If fog_enabled<>Null Then DebugLog(pad+" fog_enabled: "+fog_enabled[0]) Else DebugLog(pad+" fog_enabled: Null")
		If alpha_enable<>Null Then DebugLog(pad+" alpha_enable: "+alpha_enable[0]) Else DebugLog(pad+" alpha_enable: Null")
		If blend_mode<>Null Then DebugLog(pad+" blend_mode: "+blend_mode[0]) Else DebugLog(pad+" blend_mode: Null")
		If fx1<>Null Then DebugLog(pad+" fx1: "+fx1[0]) Else DebugLog(pad+" fx1: Null")
		If fx2<>Null Then DebugLog(pad+" fx2: "+fx2[0]) Else DebugLog(pad+" fx2: Null")

		' float
		If ambient_red<>Null Then DebugLog(pad+" ambient_red: "+ambient_red[0]) Else DebugLog(pad+" ambient_red: Null")
		If ambient_green<>Null Then DebugLog(pad+" ambient_green: "+ambient_green[0]) Else DebugLog(pad+" ambient_green: Null")
		If ambient_blue<>Null Then DebugLog(pad+" ambient_blue: "+ambient_blue[0]) Else DebugLog(pad+" ambient_blue: Null")
		If anim_speed<>Null Then DebugLog(pad+" anim_speed: "+anim_speed[0]) Else DebugLog(pad+" anim_speed: Null")
		
		' pivot
		DebugLog pad+" root_ent: "+StringPtr(TPivot.GetInstance(root_ent))
		If debug_subobjects And root_ent<>Null Then root_ent.DebugFields( debug_subobjects,debug_base_types )
		
		' camera
		DebugLog pad+" camera_in_use: "+StringPtr(TCamera.GetInstance(camera_in_use))
		If debug_subobjects And camera_in_use<>Null Then camera_in_use.DebugFields( debug_subobjects,debug_base_types )
		
		' shader
		DebugLog pad+" ambient_shader: "+StringPtr(TShader.GetInstance(ambient_shader))
		'If debug_subobjects And ambient_shader<>Null Then ambient_shader.DebugFields( debug_subobjects,debug_base_types )
		
		DebugLog ""
		
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
	
	' Extra
	
	Function CheckFramebufferStatus( target% )
	
		Local status:Int=glCheckFramebufferStatusEXT(target) ' check for framebuffer errors
		
		Select status
			Case GL_FRAMEBUFFER_COMPLETE_EXT
				DebugLog " FBO created"
			Case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT
				DebugLog " Incomplete attachment"
			Case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT
				DebugLog " Missing attachment"
			Case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT
				DebugLog " Incomplete dimensions"
			Case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT
				DebugLog " Incomplete formats"
			Case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT
				DebugLog " Incomplete draw buffer"
			Case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT
				DebugLog " Incomplete read buffer"
			Case GL_FRAMEBUFFER_UNSUPPORTED_EXT
				DebugLog " Type is not supported"
			Default
				DebugLog " FBO failed: "+status
		EndSelect
		
	End Function
	
	' Minib3d
	
	Function GraphicsInit()
	
		' save initial settings for Max2D
		glPushAttrib(GL_ALL_ATTRIB_BITS) ' save all states to attribute stack (set by glEnable and others)
		glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS) ' save client states to attribute stack (set by glEnableClientState)
		glMatrixMode(GL_MODELVIEW) ' specify the matrix stack to use
		glPushMatrix() ' save matrix stack
		glMatrixMode(GL_PROJECTION)
		glPushMatrix()
		glMatrixMode(GL_TEXTURE)
		glPushMatrix()
		glMatrixMode(GL_COLOR)
		glPushMatrix()
		
		' Global::Graphics
		glDepthFunc(GL_LEQUAL)
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL,0.5)
		'glAlphaFunc(GL_NOTEQUAL,0.0)
		
		glEnable(GL_LIGHTING)
		glEnable(GL_DEPTH_TEST)
		glDepthMask(GL_TRUE)
		'glDisable(GL_BLEND)
		
		glEnable(GL_FOG)
		glEnable(GL_CULL_FACE)
		glEnable(GL_SCISSOR_TEST)
		
		glEnable(GL_NORMALIZE)
		
		glEnableClientState(GL_VERTEX_ARRAY)
		glEnableClientState(GL_NORMAL_ARRAY)
		glEnableClientState(GL_COLOR_ARRAY)
		
		glEnable(GL_DEPTH_TEST)
		glDepthMask(GL_TRUE)
		glClearDepth(1.0)
		glDepthFunc(GL_LEQUAL)
		glEnable(GL_CULL_FACE)
		glEnable(GL_SCISSOR_TEST)
		glEnable(GL_BLEND)
		
		Local amb#[]=[0.5,0.5,0.5,1.0]
		Local flag#[]=[0.0]
		glLightModelfv(GL_LIGHT_MODEL_AMBIENT,Varptr amb[0])
		glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE,Varptr flag[0]) ' 0 For one sided, 1 for two sided
		
		TextureFilter("",1+8)
		
		glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR)
		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,GL_TRUE)
		
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
		glEnableClientState(GL_NORMAL_ARRAY) ' surface normals
		'glEnableClientState(GL_COLOR_ARRAY) ' don't enable vertex colors
		
	End Function
	
	Function Wireframe( enable:Int )
	
		Wireframe_( enable )
		
	End Function
	
	Function AmbientLight( r:Float,g:Float,b:Float )
	
		AmbientLight_( r,g,b )
	
	End Function
	
	Function FreeCollisionPivots()
	
		If pivots_exist=1
			pivots_exist=0
			If piv1.exists
				piv1.exists=0
				piv1.FreeEntityList()
			EndIf
			If piv11.exists
				piv11.exists=0
				piv11.FreeEntityList()
			EndIf
			If piv111.exists
				piv111.exists=0
				piv111.FreeEntityList()
			EndIf
			If piv2.exists
				piv2.exists=0
				piv2.FreeEntityList()
			EndIf
			If piv1o.exists
				piv1o.exists=0
				piv1o.FreeEntityList()
			EndIf
			If piv2o.exists
				piv2o.exists=0
				piv2o.FreeEntityList()
			EndIf
			
			FreeCollisionPivots_()
		EndIf
		
	End Function
	
	Function ClearCollisions()
	
		ClearCollisions_()
		
	End Function
	
	Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
	
		Collisions_( src_no,dest_no,method_no,response_no )
		
	End Function
	
	Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
	
		If entities
			FreeCollisionPivots()
			Local count:Int=CountList(TEntity.entity_list)
			FreeAllEntities(count)
			ClearList(TEntity.entity_list) ; TEntity.entity_list_id=0
			ClearList(TGlobal3D.root_ent.child_list) ; TGlobal3D.root_ent.child_list_id=0
			ClearList(TEntity.animate_list) ; TEntity.animate_list_id=0
			ClearList(TCamera.cam_list) ; TCamera.cam_list_id=0
			ClearList(TPick.ent_list) ; TPick.ent_list_id=0
			ClearCollisions()
		EndIf
		
		If brushes
			For Local brush:TBrush=EachIn TBrush.brush_list
				brush.FreeBrush()
			Next
			ClearList(TBrush.brush_list) ; TBrush.brush_list_id=0
		EndIf
		
		If textures
			For Local tex:TTexture=EachIn TTexture.tex_list
				tex.FreeTexture()
			Next
			ClearList(TTexture.tex_list) ; TTexture.tex_list_id=0
			ClearList(TTexture.tex_list_all) ; TTexture.tex_list_all_id=0
		EndIf
		
		'ClearWorld_( entities,brushes,textures )
		
	End Function
	
	Function FreeAllEntities( count:Int Var )
	
		For Local ent:TEntity=EachIn TEntity.entity_list
			If ent.parent=Null
				ent.FreeEntity()
			EndIf
		Next
		count:-1
		If count>=0 Then FreeAllEntities( count ) ' recursive
		
	End Function
	
	Function UpdateWorld( anim_speed:Float=1 )
	
		UpdateWorld_( anim_speed )
		
		If pivots_exist=0
			pivots_exist=1
			piv1o=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv1o ) )
			piv1=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv1 ) )
			piv11=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv11 ) )
			piv111=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv111 ) )
			piv2o=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv2o ) )
			piv2=TPivot.CreateObject( StaticPivot_( COLLISIONPAIR_class,COLLISIONPAIR_piv2 ) )
		EndIf
		
	End Function
	
	Function RenderWorld()
	
		RenderWorld_()
		
	End Function
	
	Function AntiAlias( samples:Int )
		
		AntiAlias_( samples )
		
	End Function
	
	Function MSAntiAlias( multisample:Int )
	
		MSAntiAlias_( multisample )
		
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
	' removed in Openb3d - called by Camera::Render (in RenderWorld)
	Function AutoFade( cam:TCamera,mesh:TMesh )

		

	End Function
	EndRem
	
End Type
