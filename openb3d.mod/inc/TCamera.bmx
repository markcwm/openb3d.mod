Rem
bbdoc: Camera entity
End Rem
Type TCamera Extends TEntity

	Global cam_list:TList=CreateList()

	Field vx:Int,vy:Int,vwidth:Int,vheight:Int
	Field cls_r#=0.0,cls_g#=0.0,cls_b#=0.0
	Field cls_color:Int=True,cls_zbuffer:Int=True
	
	Field range_near#=1.0,range_far#=1000.0
	Field zoom#=1.0
	
	Field proj_mode:Int=1
	
	Field fog_mode:Int
	Field fog_r#,fog_g#,fog_b#
	Field fog_range_near#=1.0,fog_range_far#=1000.0
	
	' used by CameraProject
	Field mod_mat:Double[16]
	Field proj_mat:Double[16]
    Field Viewport:Int[4]
	Global projected_x#
	Global projected_y#
	Global projected_z#
	
	Field frustum#[6,4]
	
	' Create and map object from C++ instance
	Function NewObject:TCamera( inst:Byte Ptr )
	
		Local obj:TCamera=New TCamera
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
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
	
	Method CopyEntity:TCamera( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateCamera:TCamera( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateCamera_( GetInstance(parent) )
		Return NewObject(instance)
		
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
	
	' Calls function in TPick
	Method CameraPick:TEntity( x:Float,y:Float )
	
		Local instance:Byte Ptr=CameraPick_( GetInstance(Self),x,GraphicsHeight()-y ) ' inverted y
		Return GetObject(instance)
		
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
	
	Method ExtractFrustum()

		

	End Method
	
	Method EntityInFrustum:Float(ent:TEntity)
	
		
	
	End Method
	
	Rem
	Method SphereInFrustum:Float(x#,y#,z#,radius#)
	
		
	
	End Method
	End Rem
	
	' Helper funcs
	Rem	
	Method Update0()

		

	End Method
	End Rem
	
	Method accPerspective(fovy#,aspect#,zNear#,zFar#,pixdx#,pixdy#,eyedx#,eyedy#,focus#)
	
		
	
	End Method

	Method accFrustum(left_#,right_#,bottom#,top#,zNear#,zFar#,pixdx#,pixdy#,eyedx#,eyedy#,focus#)
	
		
		
	End Method
	
End Type
