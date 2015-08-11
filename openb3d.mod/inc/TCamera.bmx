
Rem
bbdoc: Camera entity
End Rem
Type TCamera Extends TEntity

	Global cam_list:TList=CreateList() ' Camera list
	Global render_list:TList=CreateList() ' openb3d: Mesh list
	
	Field vx:Int Ptr,vy:Int Ptr,vwidth:Int Ptr,vheight:Int Ptr ' 0/0/320/480
	Field cls_r:Float Ptr,cls_g:Float Ptr,cls_b:Float Ptr ' 0.0/0.0/0.0
	Field cls_color:Byte Ptr,cls_zbuffer:Byte Ptr ' bool - true/true
	
	Field range_near:Float Ptr,range_far:Float Ptr ' 1.0/1000.0
	Field zoom:Float Ptr ' 1.0
	
	Field proj_mode:Int Ptr ' 1
	
	Field fog_mode:Int Ptr ' 0
	Field fog_r:Float Ptr,fog_g:Float Ptr,fog_b:Float Ptr ' 0.0/0.0/0.0
	Field fog_range_near:Float Ptr,fog_range_far:Float Ptr ' 1.0/1000.0
	
	' used by CameraProject
	Field project_enabled:Int Ptr ' openb3d - false
	Field mod_mat:Float Ptr ' array [16]
	Field proj_mat:Float Ptr ' array [16]
	Field Viewport:Int Ptr ' array [4]
	Global projected_x:Float Ptr
	Global projected_y:Float Ptr
	Global projected_z:Float Ptr
	
	Field frustum:Float Ptr ' array [6][4]
	
	Function CreateObject:TCamera( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TCamera=New TCamera
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		projected_x=StaticFloat_( CAMERA_class,CAMERA_projected_x )
		projected_y=StaticFloat_( CAMERA_class,CAMERA_projected_y )
		projected_z=StaticFloat_( CAMERA_class,CAMERA_projected_z )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' bool
		cls_color=CameraBool_( GetInstance(Self),CAMERA_cls_color )
		cls_zbuffer=CameraBool_( GetInstance(Self),CAMERA_cls_zbuffer )
		
		' int
		vx=CameraInt_( GetInstance(Self),CAMERA_vx )
		vy=CameraInt_( GetInstance(Self),CAMERA_vy )
		vwidth=CameraInt_( GetInstance(Self),CAMERA_vwidth )
		vheight=CameraInt_( GetInstance(Self),CAMERA_vheight )
		proj_mode=CameraInt_( GetInstance(Self),CAMERA_proj_mode )
		fog_mode=CameraInt_( GetInstance(Self),CAMERA_fog_mode )
		project_enabled=CameraInt_( GetInstance(Self),CAMERA_project_enabled )
		Viewport=CameraInt_( GetInstance(Self),CAMERA_viewport )
		
		' float
		cls_r=CameraFloat_( GetInstance(Self),CAMERA_cls_r )
		cls_g=CameraFloat_( GetInstance(Self),CAMERA_cls_g )
		cls_b=CameraFloat_( GetInstance(Self),CAMERA_cls_b )
		range_near=CameraFloat_( GetInstance(Self),CAMERA_range_near )
		range_far=CameraFloat_( GetInstance(Self),CAMERA_range_far )
		zoom=CameraFloat_( GetInstance(Self),CAMERA_zoom )
		fog_r=CameraFloat_( GetInstance(Self),CAMERA_fog_r )
		fog_g=CameraFloat_( GetInstance(Self),CAMERA_fog_g )
		fog_b=CameraFloat_( GetInstance(Self),CAMERA_fog_b )
		fog_range_near=CameraFloat_( GetInstance(Self),CAMERA_fog_range_near )
		fog_range_far=CameraFloat_( GetInstance(Self),CAMERA_fog_range_far )
		mod_mat=CameraFloat_( GetInstance(Self),CAMERA_mod_mat )
		proj_mat=CameraFloat_( GetInstance(Self),CAMERA_proj_mat )
		frustum=CameraFloat_( GetInstance(Self),CAMERA_frustum )
		
	End Method
	
	Function CopyList_( list:TList ) ' Global list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case cam_list
				For Local id:Int=0 To StaticListSize_( CAMERA_class,CAMERA_cam_list )-1
					inst=StaticIterListCamera_( CAMERA_class,CAMERA_cam_list )
					Local obj:TCamera=TCamera( GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TCamera.CreateObject(inst)
					ListAddLast list,obj
				Next
			Case render_list
				For Local id:Int=0 To StaticListSize_( CAMERA_class,CAMERA_render_list )-1
					inst=StaticIterListMesh_( CAMERA_class,CAMERA_render_list )
					Local obj:TMesh=TMesh( GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TMesh.CreateObject(inst)
					ListAddLast list,obj
				Next
		End Select
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TCamera"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TCamera"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateCamera:TCamera( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateCamera_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Method CameraViewport( x:Int,y:Int,width:Int,height:Int )
	
		CameraViewport_( GetInstance(Self),x,GraphicsHeight()-y-height,width,height ) ' inverted y
		
	End Method
	
	Method CameraClsColor( r:Float,g:Float,b:Float )
	
		CameraClsColor_( GetInstance(Self),r,g,b )
		
	End Method
	
	Method CameraClsMode( cls_depth:Int,cls_zbuffer:Int )
	
		CameraClsMode_( GetInstance(Self),cls_depth,cls_zbuffer )
		
	End Method
	
	Method CameraRange( nnear:Float,nfar:Float )
	
		CameraRange_( GetInstance(Self),nnear,nfar )
		
	End Method
	
	Method CameraZoom( zoom:Float )
	
		CameraZoom_( GetInstance(Self),zoom )
		
	End Method
	
	Method CameraProjMode( Mode:Int=1 )
	
		CameraProjMode_( GetInstance(Self),Mode )
		
	End Method
	
	Method CameraPick:TEntity( x:Float,y:Float ) ' same as function in TPick
	
		Local inst:Byte Ptr=CameraPick_( GetInstance(Self),x,GraphicsHeight()-y ) ' inverted y
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	Method CameraFogMode( Mode:Int )
	
		CameraFogMode_( GetInstance(Self),Mode )
		
	End Method
	
	Method CameraFogColor( r:Float,g:Float,b:Float )
	
		CameraFogColor_( GetInstance(Self),r,g,b )
		
	End Method
	
	Method CameraFogRange( nnear:Float,nfar:Float )
	
		CameraFogRange_( GetInstance(Self),nnear,nfar )
		
	End Method
	
    Method CameraProject( x:Float,y:Float,z:Float )
	
		CameraProject_( GetInstance(Self),x,y,z )
		
    End Method
	
	Function ProjectedX:Float()
	
		Return ProjectedX_()
	
	End Function
	
	Function ProjectedY:Float()

		Return ProjectedY_()
	
	End Function
	
	Function ProjectedZ:Float()
	
		Return ProjectedZ_()
	
	End Function
	
	Method EntityInView:Int( ent:TEntity )
	
		Return EntityInView_( GetInstance(ent),GetInstance(Self) )
		
	End Method
	
	' Internal (helper funcs)
	
	Method CopyEntity:TCamera( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	' called by Render
	Method Update()
	
		CameraUpdate_( GetInstance(Self) )
		
	End Method
	
	' Render camera - renders all meshes camera can see, called in RenderWorld
	Method Render()
	
		CameraRender_( GetInstance(Self) )
		
	End Method
	
	' called by UpdateEntityRender (in Render)
	Method UpdateSprite( sprite:TSprite )
	
		UpdateSprite_( GetInstance(Self),TSprite.GetInstance(sprite) )
		
	End Method
	
	' sprite batch rendering - called by UpdateEntityRender (in Render)
	Method AddTransformedSpriteToSurface( sprite:TSprite,surf:TSurface )
	
		AddTransformedSpriteToSurface_( GetInstance(Self),TSprite.GetInstance(sprite),TSurface.GetInstance(surf) )
		
	End Method
	
	' Adds mesh to a render list, and inserts mesh into correct position
	' within list depending on order and alpha values - called by Render
	Method RenderListAdd( mesh:TMesh ) ' moved from TGlobal.bmx
	
		RenderListAdd_( GetInstance(Self),TMesh.GetInstance(mesh) )
		
	End Method
	
	' extract camera's view frustrum - called by Update
	Method ExtractFrustum()
	
		ExtractFrustum_( GetInstance(Self) )
		
	End Method
	
	' called by EntityInView
	Method EntityInFrustum:Float( ent:TEntity )
	
		Return EntityInFrustum_( GetInstance(Self),TEntity.GetInstance(ent) )
		
	End Method
	
	' accum buffer version of gluPerspective - called by Update
	Method accPerspective( fovy:Float,aspect:Float,zNear:Float,zFar:Float,pixdx:Float,pixdy:Float,eyedx:Float,eyedy:Float,focus:Float )
		
		accPerspective_( GetInstance(Self),fovy,aspect,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus )
		
	End Method
	
	' accum buffer version of glFrustum - called in accPerspective
	Method accFrustum( left_:Float,right_:Float,bottom:Float,top:Float,zNear:Float,zFar:Float,pixdx:Float,pixdy:Float,eyedx:Float,eyedy:Float,focus:Float )
	
		accFrustum_( GetInstance(Self),left_,right_,bottom,top,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus )	
		
	End Method
	
	' called by CreateCamera, CameraViewport, etc.
	Method UpdateProjMatrix()
	
		UpdateProjMatrix_( GetInstance(Self) )
		
	End Method
	
	' called by Render
	Function UpdateEntityRender( ent:TEntity,cam:TCamera=Null )
	
		CameraUpdateEntityRender_( TEntity.GetInstance(ent),GetInstance(cam) )
		
	End Function
	
	Rem
	Method SphereInFrustum:Float(x#,y#,z#,radius#)
	
		
	
	End Method
	End Rem
	
	Rem	
	Method Update0()

		

	End Method
	End Rem
	
End Type
