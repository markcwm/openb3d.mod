
Rem
bbdoc: Entity
End Rem
Type TEntity
	
	Global entity_list:TList=CreateList() ' Entity list
	Field child_list:TList=CreateList() ' Entity list
	Field parent:TEntity ' returned by GetParent - NULL
	
	' transform
	Field mat:TMatrix2 ' returned by EntityX/Y/Z (global) - LoadIdentity
	Field rotmat:TMatrix2 ' openb3d: used in EntityPitch/Yaw/Roll (global) - LoadIdentity
	Field px:Float Ptr,py:Float Ptr,pz:Float Ptr ' returned by EntityX/Y/Z (local) - 0.0/0.0/0.0
	Field sx:Float Ptr,sy:Float Ptr,sz:Float Ptr ' returned by EntityScaleX/Y/Z (local) - 1.0/1.0/1.0
	Field rx:Float Ptr,ry:Float Ptr,rz:Float Ptr ' rotation - 0.0/0.0/0.0
	Field qw:Float Ptr,qx:Float Ptr,qy:Float Ptr,qz:Float Ptr ' quaternion - 1.0/0.0/0.0/0.0
	
	' material
	Field brush:TBrush
	
	' visibility
	Field order:Int Ptr ' set in EntityOrder - 0
	Field alpha_order:Float Ptr ' distance from camera - 0.0
	Field hide:Int Ptr ' set in Hide/ShowEntity - false
	Field cull_radius:Float Ptr ' set in MeshCullRadius - 0.0
	
	' properties
	Field name:Byte Ptr ' string returned by EntityName - ""
	Field class_name:Byte Ptr ' string returned by EntityClass - ""
	
	' anim
	Global animate_list:TList=CreateList() ' openb3d: Entity list (currently animating)
	Field anim:Int Ptr ' true if mesh contains anim data - false
	Field anim_render:Int Ptr ' true to render as anim mesh - false
	Field anim_mode:Int Ptr ' 0
	Field anim_time:Float Ptr ' 0.0
	Field anim_speed:Float Ptr ' 0.0
	Field anim_seq:Int Ptr ' 0
	Field anim_trans:Int Ptr ' 0
	Field anim_dir:Int Ptr ' 1=forward, -1=backward - 1
	Field anim_seqs_first:Int Ptr ' vector animation frame sequences
	Field anim_seqs_last:Int Ptr ' vector
	Field no_seqs:Int Ptr ' 0
	Field anim_update:Int Ptr ' 0
	Field anim_list:Int Ptr ' openb3d: entity in animate_list - false
	
	' collisions
	Field collision_type:Int Ptr ' returned by GetEntityType - 0
	Field radius_x:Float Ptr,radius_y:Float Ptr ' set in EntityRadius - 1.0/1.0
	Field box_x:Float Ptr,box_y:Float Ptr,box_z:Float Ptr ' set in EntityBox - -1.0/-1.0/-1.0
	Field box_w:Float Ptr,box_h:Float Ptr,box_d:Float Ptr ' set in EntityBox - 2.0/2.0/2.0
	Field no_collisions:Int Ptr ' returned by CountCollisions - 0
	Field collision:TList=CreateList() ' CollisionImpact vector used in CollisionX/Y/Z/NX/NY/NZ/Time/Entity/Surface/Triangle
	Field old_x:Float Ptr,old_y:Float Ptr,old_z:Float Ptr ' used by Collisions - 0.0/0.0/0.0
	Field old_pitch:Float Ptr,old_yaw:Float Ptr,old_roll:Float Ptr ' openb3d
	Field new_x:Float Ptr,new_y:Float Ptr,new_z:Float Ptr ' openb3d - 0.0/0.0/0.0
	Field new_no:Int Ptr ' openb3d - 0
	
	Field old_mat:TMatrix2 ' openb3d - LoadIdentity
	Field dynamic:Int Ptr ' openb3d - false
	Field dynamic_x:Float Ptr,dynamic_y:Float Ptr,dynamic_z:Float Ptr ' openb3d - 0.0/0.0/0.0
	Field dynamic_yaw:Float Ptr,dynamic_pitch:Float Ptr,dynamic_roll:Float Ptr ' openb3d - 0.0/0.0/0.0
	
	' picking
	Field pick_mode:Int Ptr ' set in EntityPickMode - 0
	Field obscurer:Int Ptr ' set in EntityPickMode - false
	
	' tform
	Global tformed_x:Float Ptr ' returned by TFormedX - 0.0
	Global tformed_y:Float Ptr ' returned by TFormedY - 0.0
	Global tformed_z:Float Ptr ' returned by TFormedZ - 0.0
	
	' minib3d
	'Field auto_fade:Int,fade_near#,fade_far#,fade_alpha# ' EntityAutoFade
	'Field link:TLink ' entity_list tlink, for quick removal of entity from list (not used)
	
	' wrapper
	Global ent_map:TMap=New TMap
	Field instance:Byte Ptr
	
	'Method CopyEntity:TEntity( parent_ent:TEntity=Null ) Abstract ' these conflicted with CreateObject
	'Method Update() Abstract
	
	Function CreateObject:TEntity( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TEntity=New TEntity
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		ent_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TEntity( inst:Byte Ptr )
	
		Return TEntity( ent_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TEntity ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		tformed_x=StaticFloat_( ENTITY_class,ENTITY_tformed_x )
		tformed_y=StaticFloat_( ENTITY_class,ENTITY_tformed_y )
		tformed_z=StaticFloat_( ENTITY_class,ENTITY_tformed_z )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		order=EntityInt_( GetInstance(Self),ENTITY_order )
		hide=EntityInt_( GetInstance(Self),ENTITY_hide )
		anim=EntityInt_( GetInstance(Self),ENTITY_anim )
		anim_render=EntityInt_( GetInstance(Self),ENTITY_anim_render )
		anim_mode=EntityInt_( GetInstance(Self),ENTITY_anim_mode )
		anim_seq=EntityInt_( GetInstance(Self),ENTITY_anim_seq )
		anim_trans=EntityInt_( GetInstance(Self),ENTITY_anim_trans )
		anim_dir=EntityInt_( GetInstance(Self),ENTITY_anim_dir )
		anim_seqs_first=EntityInt_( GetInstance(Self),ENTITY_anim_seqs_first )
		anim_seqs_last=EntityInt_( GetInstance(Self),ENTITY_anim_seqs_last )
		no_seqs=EntityInt_( GetInstance(Self),ENTITY_no_seqs )
		anim_update=EntityInt_( GetInstance(Self),ENTITY_anim_update )
		anim_list=EntityInt_( GetInstance(Self),ENTITY_anim_list )
		collision_type=EntityInt_( GetInstance(Self),ENTITY_collision_type )
		no_collisions=EntityInt_( GetInstance(Self),ENTITY_no_collisions )
		new_no=EntityInt_( GetInstance(Self),ENTITY_new_no )
		dynamic=EntityInt_( GetInstance(Self),ENTITY_dynamic )
		pick_mode=EntityInt_( GetInstance(Self),ENTITY_pick_mode )
		obscurer=EntityInt_( GetInstance(Self),ENTITY_obscurer )
		
		' float
		px=EntityFloat_( GetInstance(Self),ENTITY_px )
		py=EntityFloat_( GetInstance(Self),ENTITY_py )
		pz=EntityFloat_( GetInstance(Self),ENTITY_pz )
		sx=EntityFloat_( GetInstance(Self),ENTITY_sx )
		sy=EntityFloat_( GetInstance(Self),ENTITY_sy )
		sz=EntityFloat_( GetInstance(Self),ENTITY_sz )
		rx=EntityFloat_( GetInstance(Self),ENTITY_rx )
		ry=EntityFloat_( GetInstance(Self),ENTITY_ry )
		rz=EntityFloat_( GetInstance(Self),ENTITY_rz )
		qw=EntityFloat_( GetInstance(Self),ENTITY_qw )
		qx=EntityFloat_( GetInstance(Self),ENTITY_qx )
		qy=EntityFloat_( GetInstance(Self),ENTITY_qy )
		qz=EntityFloat_( GetInstance(Self),ENTITY_qz )
		alpha_order=EntityFloat_( GetInstance(Self),ENTITY_alpha_order )
		cull_radius=EntityFloat_( GetInstance(Self),ENTITY_cull_radius )
		anim_time=EntityFloat_( GetInstance(Self),ENTITY_anim_time )
		anim_speed=EntityFloat_( GetInstance(Self),ENTITY_anim_speed )
		radius_x=EntityFloat_( GetInstance(Self),ENTITY_radius_x )
		radius_y=EntityFloat_( GetInstance(Self),ENTITY_radius_y )
		box_x=EntityFloat_( GetInstance(Self),ENTITY_box_x )
		box_y=EntityFloat_( GetInstance(Self),ENTITY_box_y )
		box_z=EntityFloat_( GetInstance(Self),ENTITY_box_z )
		box_w=EntityFloat_( GetInstance(Self),ENTITY_box_w )
		box_h=EntityFloat_( GetInstance(Self),ENTITY_box_h )
		box_d=EntityFloat_( GetInstance(Self),ENTITY_box_d )
		old_x=EntityFloat_( GetInstance(Self),ENTITY_old_x )
		old_y=EntityFloat_( GetInstance(Self),ENTITY_old_y )
		old_z=EntityFloat_( GetInstance(Self),ENTITY_old_z )
		old_pitch=EntityFloat_( GetInstance(Self),ENTITY_old_pitch )
		old_yaw=EntityFloat_( GetInstance(Self),ENTITY_old_yaw )
		old_roll=EntityFloat_( GetInstance(Self),ENTITY_old_roll )
		new_x=EntityFloat_( GetInstance(Self),ENTITY_new_x )
		new_y=EntityFloat_( GetInstance(Self),ENTITY_new_y )
		new_z=EntityFloat_( GetInstance(Self),ENTITY_new_z )
		dynamic_x=EntityFloat_( GetInstance(Self),ENTITY_dynamic_x )
		dynamic_y=EntityFloat_( GetInstance(Self),ENTITY_dynamic_y )
		dynamic_z=EntityFloat_( GetInstance(Self),ENTITY_dynamic_z )
		dynamic_yaw=EntityFloat_( GetInstance(Self),ENTITY_dynamic_yaw )
		dynamic_pitch=EntityFloat_( GetInstance(Self),ENTITY_dynamic_pitch )
		dynamic_roll=EntityFloat_( GetInstance(Self),ENTITY_dynamic_roll )
		
		' string
		name=EntityString_( GetInstance(Self),ENTITY_name )
		class_name=EntityString_( GetInstance(Self),ENTITY_class_name )
		
		' entity
		Local inst:Byte Ptr=EntityEntity_( GetInstance(Self),ENTITY_parent )
		parent=CreateObject(inst)
		
		' matrix
		inst=EntityMatrix_( GetInstance(Self),ENTITY_mat )
		mat=TMatrix2.CreateObject(inst)
		inst=EntityMatrix_( GetInstance(Self),ENTITY_rotmat )
		rotmat=TMatrix2.CreateObject(inst)
		inst=EntityMatrix_( GetInstance(Self),ENTITY_old_mat )
		old_mat=TMatrix2.CreateObject(inst)
		
		' brush
		inst=EntityBrush_( GetInstance(Self),ENTITY_brush )
		brush=TBrush.CreateObject(inst)
		
	End Method
	
	Method CopyList( list:TList ) ' Field list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case child_list
				For Local id:Int=0 To EntityListSize_( GetInstance(Self),ENTITY_child_list )-1
					inst=EntityIterListEntity_( GetInstance(Self),ENTITY_child_list )
					Local obj:TEntity=GetObject(inst)
					If obj=Null And inst<>Null Then obj=CreateObject(inst)
					ListAddLast list,obj
				Next
			Case collision
				For Local id:Int=0 To EntityListSize_( GetInstance(Self),ENTITY_collision )-1
					inst=EntityIterVectorCollisionImpact_( GetInstance(Self),ENTITY_collision )
					Local obj:TCollisionImpact=TCollisionImpact.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TCollisionImpact.CreateObject(inst)
					ListAddLast list,obj
				Next
			End Select
			
	End Method
	
	Function CopyList_( list:TList ) ' Global list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case entity_list
				For Local id:Int=0 To StaticListSize_( ENTITY_class,ENTITY_entity_list )-1
					inst=StaticIterListEntity_( ENTITY_class,ENTITY_entity_list )
					Local obj:TEntity=GetObject(inst)
					If obj=Null And inst<>Null Then obj=CreateObject(inst)
					ListAddLast list,obj
				Next
			Case animate_list
				For Local id:Int=0 To StaticListSize_( ENTITY_class,ENTITY_animate_list )-1
					inst=StaticIterListEntity_( ENTITY_class,ENTITY_animate_list )
					Local obj:TEntity=GetObject(inst)
					If obj=Null And inst<>Null Then obj=CreateObject(inst)
					ListAddLast list,obj
				Next
		End Select
		
	End Function
	
	' Openb3d
	
	Method AddAnimSeq:Int( length:Int )
	
		Return AddAnimSeq_( GetInstance(Self),length )
		
	End Method
	
	Method SetAnimKey( frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
	
		SetAnimKey_( GetInstance(Self),frame,pos_key,rot_key,scale_key )
		
	End Method
	
	' Aligns an entity axis to a vector
	Method AlignToVector( x:Float,y:Float,z:Float,axis:Int,rate:Float=1 )
	
		AlignToVector_( GetInstance(Self),x,y,z,axis,rate )
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TEntity"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TEntity"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		FreeObject( GetInstance(Self) )
		FreeEntity_( GetInstance(Self) )
		
	End Method

	' Entity movement (position)
	
	Method PositionEntity( x:Float,y:Float,z:Float,glob:Int=False )
	
		PositionEntity_( GetInstance(Self),x,y,z,glob )
		
	End Method
	
	Method MoveEntity( x:Float,y:Float,z:Float )
	
		MoveEntity_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method TranslateEntity( x:Float,y:Float,z:Float,glob:Int=False )
	
		TranslateEntity_( GetInstance(Self),x,y,z,glob )
		
	End Method
	
	Method ScaleEntity( x:Float,y:Float,z:Float,glob:Int=False )
	
		ScaleEntity_( GetInstance(Self),x,y,z,glob )
		
	End Method
	
	Method RotateEntity( x:Float,y:Float,z:Float,glob:Int=False )
	
		RotateEntity_( GetInstance(Self),-x,y,z,glob ) ' inverted pitch
		
	End Method
	
	Method TurnEntity( x:Float,y:Float,z:Float,glob:Int=False )
	
		TurnEntity_( GetInstance(Self),-x,y,z,glob ) ' inverted pitch
		
	End Method
	
	Method PointEntity( target_ent:TEntity,roll:Float=0 ) ' Function by mongia2
	
		PointEntity_( GetInstance(Self),GetInstance(target_ent),roll )
		
	End Method
	
	' Entity animation
	
	' load anim seq - copies anim data from mesh to self
	Method LoadAnimSeq:Int( file:String )
	
		Local cString:Byte Ptr=file.ToCString()
		Local seqnum:Int=LoadAnimSeq_( GetInstance(Self),cString )
		MemFree cString
		Return seqnum
		
	End Method
	
	Method ExtractAnimSeq:Int( first_frame:Int,last_frame:Int,seq:Int=0 )
	
		Return ExtractAnimSeq_( GetInstance(Self),first_frame,last_frame,seq )
		
	End Method
	
	Method Animate( Mode:Int=1,speed:Float=1,seq:Int=0,trans:Int=0 )
	
		Animate_( GetInstance(Self),Mode,speed,seq,trans )
		
	End Method
	
	' Updates:
	' 30/01/06 - updated to make anim_time return wrapped value
	Method SetAnimTime( time:Float,seq:Int=0 )
	
		If time<>0.0 Then SetAnimTime_( GetInstance(Self),time,seq ) ' munch: if zero crash fix
		
	End Method
	
	Method AnimSeq:Int()
	
		Return AnimSeq_( GetInstance(Self) )
		
	End Method
	
	Method AnimLength:Int()
	
		Return AnimLength_( GetInstance(Self) )
		
	End Method
	
	Method AnimTime:Float()
	
		Return AnimTime_( GetInstance(Self) )
		
	End Method
	
	Method Animating:Int()
	
		Return Animating_( GetInstance(Self) )
		
	End Method
	
	' Entity control (material)
	
	Method EntityColor( red:Float,green:Float,blue:Float )
	
		EntityColor_( GetInstance(Self),red,green,blue )
		
	End Method
	
	Method EntityAlpha( alpha:Float )
	
		EntityAlpha_( GetInstance(Self),alpha )
		
	End Method
	
	Method EntityShininess( shine:Float )
	
		EntityShininess_( GetInstance(Self),shine )
		
	End Method
	
	Method EntityTexture( tex:TTexture,frame:Int=0,index:Int=0 )
	
		EntityTexture_( GetInstance(Self),TTexture.GetInstance(tex),frame,index )
		
	End Method
	
	Method EntityBlend( blend:Int )
	
		EntityBlend_( GetInstance(Self),blend )
		
	End Method
	
	Method EntityFX( fx:Int )
	
		EntityFX_( GetInstance(Self),fx )
		
	End Method
	
	Method PaintEntity( brush:TBrush )
	
		PaintEntity_( GetInstance(Self),TBrush.GetInstance(brush) )
		
	End Method
	
	Method GetEntityBrush:TBrush() ' same as function in TBrush
	
		Local inst:Byte Ptr=GetEntityBrush_( GetInstance(Self) )
		Local brush:TBrush=TBrush.GetObject(inst)
		If brush=Null And inst<>Null Then brush=TBrush.CreateObject(inst)
		Return brush
		
	End Method
	
	' visibility
	
	Method EntityOrder( order:Int )
	
		EntityOrder_( GetInstance(Self),order )
		
	End Method
	
	Method ShowEntity()
	
		ShowEntity_( GetInstance(Self) )
		
	End Method
	
	Method HideEntity()
	
		HideEntity_( GetInstance(Self) )
		
	End Method
	
	' properties
	
	Method NameEntity( name:String )
	
		Local cString:Byte Ptr=name.ToCString()
		NameEntity_( GetInstance(Self),cString )
		MemFree cString
		
	End Method
	
	' relations
	
	Method EntityParent( parent_ent:TEntity,glob:Int=True )
	
		EntityParent_( GetInstance(Self),GetInstance(parent_ent),glob )
		
	End Method
	
	Method GetParent:TEntity()
	
		Local inst:Byte Ptr=GetParentEntity_( GetInstance(Self) )
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	' Entity state (position)
	
	Method EntityX:Float( glob:Int=False )
	
		Return EntityX_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityY:Float( glob:Int=False )
	
		Return EntityY_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityZ:Float( glob:Int=False )
	
		Return EntityZ_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityPitch:Float( glob:Int=False )
	
		Return -EntityPitch_( GetInstance(Self),glob ) ' inverted pitch
		
	End Method
	
	Method EntityYaw:Float( glob:Int=False )
	
		Return EntityYaw_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityRoll:Float( glob:Int=True )
	
		Return EntityRoll_( GetInstance(Self),glob )
		
	End Method
	
	' properties
	
	Method EntityClass:String()
	
		Return String.FromCString( EntityClass_( GetInstance(Self) ) )
		
	End Method
	
	Method EntityName:String()
		
		Return String.FromCString( EntityName_( GetInstance(Self) ) )
		
	End Method
	
	' relations
	
	Method CountChildren:Int()
	
		Return CountChildren_( GetInstance(Self) )
		
	End Method
	
	Method GetChild:TEntity( child_no:Int )
	
		Local inst:Byte Ptr=GetChild_( GetInstance(Self),child_no )
		Local child:TEntity=GetObject(inst)
		If child=Null And inst<>Null Then child=CreateObject(inst)
		Return child
		
	End Method
	
	Method FindChild:TEntity( child_name:String )
	
		Local cString:Byte Ptr=child_name.ToCString()
		Local inst:Byte Ptr=FindChild_( GetInstance(Self),cString )
		Local child:TEntity=GetObject(inst)
		If child=Null And inst<>Null Then child=CreateObject(inst)
		MemFree cString
		Return child
		
	End Method
	
	' picking
	
	Method EntityPick:TEntity( Range:Float ) ' same as function in TPick
	
		Local inst:Byte Ptr=EntityPick_( GetInstance(Self),Range )
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	' same as function in TPick
	Method LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
	
		Local inst:Byte Ptr=LinePick_( x,y,z,dx,dy,dz,radius )
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	Method EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity ) ' same as function in TPick
	
		Return EntityVisible_( GetInstance(src_ent),GetInstance(dest_ent) )
		
	End Method
	
	' distance
	
	Method EntityDistance:Float( ent2:TEntity )
	
		Return EntityDistance_( GetInstance(Self),GetInstance(ent2) )
		
	End Method
	
	Method DeltaYaw:Float( ent2:TEntity ) ' Function by Vertex
	
		Return DeltaYaw_( GetInstance(Self),GetInstance(ent2) )
		
	End Method
	
	Method DeltaPitch:Float( ent2:TEntity ) ' Function by Vertex
	
		Return -DeltaPitch_( GetInstance(Self),GetInstance(ent2) ) ' inverted pitch
		
	End Method
	
	' tform
	
	Function TFormPoint( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	
		TFormPoint_( x,y,z,GetInstance(src_ent),GetInstance(dest_ent) )
		
	End Function
	
	Function TFormVector( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	
		TFormVector_( x,y,z,GetInstance(src_ent),GetInstance(dest_ent) )
		
	End Function
	
	Function TFormNormal( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	
		TFormNormal_( x,y,z,GetInstance(src_ent),GetInstance(dest_ent) )
		
	End Function
	
	Function TFormedX:Float()
	
		Return TFormedX_()
		
	End Function
	
	Function TFormedY:Float()
	
		Return TFormedY_()
		
	End Function
	
	Function TFormedZ:Float()
	
		Return TFormedZ_()
		
	End Function
	
	Method GetMatElement:Float( row:Int,col:Int )
	
		'Return GetMatElement_( GetInstance(Self),row,col )
		Return mat.grid[(4*row)+col]
		
	End Method
	
	' Entity collision
	
	Method ResetEntity()
	
		ResetEntity_( GetInstance(Self) )
		
	End Method
	
	Method EntityRadius( radius_x:Float,radius_y:Float=0 )
	
		EntityRadius_( GetInstance(Self),radius_x,radius_y )
		
	End Method
	
	Method EntityBox( x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
	
		EntityBox_( GetInstance(Self),x,y,z,w,h,d )
		
	End Method
	
	Method EntityType( type_no:Int,recursive:Int=False )
	
		EntityType_( GetInstance(Self),type_no,recursive )
		
	End Method
	
	' picking
	
	Method EntityPickMode( pick_mode:Int,obscurer:Int=True )
	
		EntityPickMode_( GetInstance(Self),pick_mode,obscurer )
			
	End Method
	
	' collisions
	
	Method EntityCollided:TEntity( type_no:Int )
	
		Local inst:Byte Ptr=EntityCollided_( GetInstance(Self),type_no )
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	Method CountCollisions:Int()
	
		Return CountCollisions_( GetInstance(Self) )
		
	End Method
	
	Method CollisionX:Float( index:Int )
	
		Return CollisionX_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionY:Float( index:Int )
	
		Return CollisionY_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionZ:Float( index:Int )
	
		Return CollisionZ_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionNX:Float( index:Int )
	
		Return CollisionNX_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionNY:Float( index:Int )
	
		Return CollisionNY_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionNZ:Float( index:Int )
	
		Return CollisionNZ_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionTime:Float( index:Int )
	
		Return CollisionTime_( GetInstance(Self),index )
		
	End Method
	
	Method CollisionEntity:TEntity( index:Int )
	
		Local inst:Byte Ptr=CollisionEntity_( GetInstance(Self),index )
		Local ent:TEntity=GetObject(inst)
		If ent=Null And ent<>Null Then ent=CreateObject(inst)
		Return ent
		
	End Method
	
	Method CollisionSurface:TSurface( index:Int )
	
		Local inst:Byte Ptr=CollisionSurface_( GetInstance(Self),index )
		Local surf:TSurface=TSurface.GetObject(inst)
		If surf=Null And inst<>Null Then surf=TSurface.CreateObject(inst)
		Return surf
		
	End Method
	
	Method CollisionTriangle:Int( index:Int )
	
		Return CollisionTriangle_( GetInstance(Self),index )
		
	End Method
	
	Method GetEntityType:Int()
	
		Return GetEntityType_( GetInstance(Self) )
		
	End Method
	
	' Sets an entity's mesh cull radius
	Method MeshCullRadius( radius:Float )
	
		MeshCullRadius_( GetInstance(Self),radius )
		
	End Method
	
	' position
	
	Method EntityScaleX:Float( glob:Int=False )
	
		Return EntityScaleX_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityScaleY:Float( glob:Int=False )
	
		Return EntityScaleY_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityScaleZ:Float( glob:Int=False )
	
		Return EntityScaleZ_( GetInstance(Self),glob )
		
	End Method
	
	' Internal - not recommended for general use (helper funcs)
	
	Method CopyEntity:TEntity( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
	' Returns if an entity or it's parent is hidden
	Method Hidden:Int()
	
		Return Hidden_( GetInstance(Self) )
		
	End Method
	
	' Recursively counts all children of an entity
	Function CountAllChildren:Int( ent:TEntity,no_children:Int=0 )
	
		Return CountAllChildren_( GetInstance(ent),no_children )
		
	End Function
	
	' Returns the specified child entity of a parent entity
	Method GetChildFromAll:TEntity( child_no:Int,no_children:Int Var,ent:TEntity=Null )
	
		Local inst:Byte Ptr=GetChildFromAll_( GetInstance(Self),child_no,Varptr(no_children),GetInstance(ent) )
		Local ent2:TEntity=GetObject(inst)
		If ent2=Null And inst<>Null Then ent2=CreateObject(inst)
		Return ent2
		
	End Method
	
	Function CountAllChildren2:Int( ent:TEntity,no_children:Int=0 ) ' bmx version
	
		Local children:Int=ent.CountChildren()
		
		For Local id:Int=1 To children
			no_children=no_children+1
			no_children=CountAllChildren( ent.GetChild(id),no_children )
		Next
		
		Return no_children
		
	End Function
	
	Method GetChildFromAll2:TEntity( child_no:Int,no_children:Int Var,ent:TEntity=Null ) ' bmx version
	
		If ent=Null Then ent=Self
		
		Local ent2:TEntity=Null
		Local children:Int=ent.CountChildren()
		
		For Local id:Int=1 To children
			no_children=no_children+1
			If no_children=child_no Then Return ent.GetChild(id)
			
			If ent2=Null
				ent2=GetChildFromAll( child_no,no_children,ent.GetChild(id) )
			EndIf
		Next
		
		Return ent2
		
	End Method
	
	' update entity matrix - calls MQ_Update
	Method UpdateMat( load_identity:Byte=False )
	
		UpdateMat_( GetInstance(Self),load_identity )
		
	End Method
	
	' add parent to entity
	Method AddParent( parent_ent:TEntity )
	
		AddParent_( GetInstance(Self),GetInstance(parent_ent) )
		
	End Method
	
	' update matrix for all child entities - calls UpdateMat
	Function UpdateChildren( ent_p:TEntity )
	
		UpdateChildren_( GetInstance(ent_p) )
		
	End Function
	
	' square of entity distance - called by EntityDistance
	Method EntityDistanceSquared:Float( ent2:TEntity ) ' optimised
	
		Return EntityDistanceSquared_( GetInstance(Self),GetInstance(ent2) )
		
	End Method
	
	' update matrix quaternion - calls MQ_GetMatrix
	Method MQ_Update()
	
		MQ_Update_( GetInstance(Self) )
		
	End Method
	
	' inverted matrix - called in RotateEntity, TFormPoint/Vector
	Method MQ_GetInvMatrix( mat0:TMatrix2 )
		
		MQ_GetInvMatrix_( GetInstance(Self),TMatrix2.GetInstance(mat0) )
		
	End Method
	
	' global position/rotation - called in EntityParent, EntityPitch/Yaw/Roll, TFormPoint/Vector
	Method MQ_GetMatrix( mat3:TMatrix2 )
		
		MQ_GetMatrix_( GetInstance(Self),TMatrix2.GetInstance(mat3) )
		
	End Method
	
	' scaling - called in EntityParent
	Method MQ_GetScaleXYZ( width:Float Var,height:Float Var,depth:Float Var )
		
		MQ_GetScaleXYZ_( GetInstance(Self),Varptr(width),Varptr(height),Varptr(depth) )
		
	End Method
	
	' called in TurnEntity
	Method MQ_Turn( ang:Float,vx:Float,vy:Float,vz:Float,glob:Int=False )
		
		MQ_Turn_( GetInstance(Self),ang,vx,vy,vz,glob )
		
	End Method
	
	Rem
	' removed due to having lots of checks per entity - alternative is octrees
	Method EntityAutoFade( near:Float,far:Float )
	
		EntityAutoFade_( GetInstance(Self),near,far )
		
	End Method
	EndRem
	
	Rem
	' Returns an entity's bounding sphere
	Method BoundingSphere:TSphere()
	
		

	End Method
	EndRem
	
	Rem
	' Returns an entity's bounding sphere
	Method BoundingSphereNew(sx# Var,sy# Var,sz# Var,sr# Var)

		

	End Method
	EndRem
	
	Rem
	' unoptimised, unused
	Method EntityDistanceSquared0:Float( ent2:TEntity )

		
		
	End Method
	EndRem
	
	Rem
	Method EntityListAdd(list:TList)
	
		

	End Method
	EndRem
	
End Type
