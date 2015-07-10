Rem
bbdoc: Entity
End Rem
Type TEntity

	Global entity_list:TList=CreateList()

	Field child_list:TList=CreateList()

	Field parent:TEntity
	
	Field mat:TMatrix=New TMatrix
	Field px#,py#,pz#,sx#=1.0,sy#=1.0,sz#=1.0,rx#,ry#,rz#,qw#,qx#,qy#,qz#
	
	Field name$
	Field class$
	Field hide:Int=False
	Field order:Int,alpha_order#
	Field auto_fade:Int,fade_near#,fade_far#,fade_alpha#

	Field brush:TBrush=New TBrush
	
	Field cull_radius#
	
	Field radius_x#=1.0,radius_y#=1.0
	Field box_x#=-1.0,box_y#=-1.0,box_z#=-1.0,box_w#=2.0,box_h#=2.0,box_d#=2.0
	Field collision_type:Int
	Field no_collisions:Int,collision:TCollisionImpact[]
	Field pick_mode:Int,obscurer:Int

	Field anim:Int ' true if mesh contains anim data
	Field anim_render:Int ' true to render as anim mesh
	Field anim_mode:Int
	Field anim_time#
	Field anim_speed#
	Field anim_seq:Int
	Field anim_trans:Int
	Field anim_dir:Int=1 ' 1=forward, -1=backward
	Field anim_seqs_first:Int[1]
	Field anim_seqs_last:Int[1]
	Field no_seqs:Int=0
	Field anim_update:Int
	
	Global tformed_x#
	Global tformed_y#
	Global tformed_z#
	
	' used by TCollisions
	Field old_x#
	Field old_y#
	Field old_z#
	
	Field link:TLink ' entity_list tlink, stored for quick removal of entity from list ***note*** not currently used to remove entity from list
	
	Global ent_map:TMap=New TMap
	Field instance:Byte Ptr
	
	'Method CopyEntity:TEntity( parent_ent:TEntity=Null ) Abstract
	'Method Update() Abstract
	
	' Create and map object from C++ instance
	Function NewObject:TEntity( inst:Byte Ptr )
	
		Local obj:TEntity=New TEntity
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	' Delete object from C++ instance
	Function DeleteObject( inst:Byte Ptr )
	
		ent_map.Remove( String(Long(inst)) )
		
	End Function
	
	' Get object from C++ instance
	Function GetObject:TEntity( inst:Byte Ptr )
	
		Return TEntity( ent_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TEntity )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Recursively counts all children of an entity.
	Function CountAllChildren:Int( ent:TEntity,no_children:Int=0 )
	
		Local children%=ent.CountChildren()
		
		For Local id:Int=1 To children
			no_children=no_children+1
			no_children=CountAllChildren( ent.GetChild(id),no_children)
		Next
		
		Return no_children
		
	End Function
	
	' Returns the specified child entity of a parent entity.
	Method GetChildFromAll:TEntity( child_no:Int,no_children:Int Var,ent:TEntity=Null )
	
		If ent=Null Then ent=Self
		
		Local ent2:TEntity=Null
		Local children%=ent.CountChildren()
		
		For Local id:Int=1 To children
			no_children=no_children+1
			If no_children=child_no Then Return ent.GetChild(id)
			
			If ent2=Null
				ent2=GetChildFromAll( child_no,no_children,ent.GetChild(id) )
			EndIf
		Next
		
		Return ent2
		
	End Method
	
	Method AddAnimSeq:Int( length:Int )
	
		Return AddAnimSeq_( GetInstance(Self),length )
		
	End Method
	
	Method SetAnimKey( frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
	
		SetAnimKey_( GetInstance(Self),frame,pos_key,rot_key,scale_key )
		
	End Method
	
	' moved from TBrush.bmx
	Method GetEntityBrush:TBrush()
	
		Local instance:Byte Ptr=GetEntityBrush_( GetInstance(Self) )
		Local brush:TBrush=TBrush.GetObject(instance)
		If brush=Null And instance<>Null Then brush=TBrush.NewObject(instance)
		Return brush
		
	End Method
	
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
	
	Method CopyEntity:TEntity( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Method FreeEntity()
	
		DeleteObject( GetInstance(Self) )
		FreeEntity_( GetInstance(Self) )
		
	End Method

	' Entity movement
	
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
	
	' Function by mongia2
	Method PointEntity( target_ent:TEntity,roll:Float=0 )
	
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
	
	' Entity control
	
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
	
	Method EntityAutoFade( near:Float,far:Float )
	
		EntityAutoFade_( GetInstance(Self),near,far )
		
	End Method
	
	Method PaintEntity( brush:TBrush )
	
		PaintEntity_( GetInstance(Self),TBrush.GetInstance(brush) )
		
	End Method
	
	Method EntityOrder( order:Int )
	
		EntityOrder_( GetInstance(Self),order )
		
	End Method
	
	Method ShowEntity()
	
		ShowEntity_( GetInstance(Self) )
		
	End Method
	
	Method HideEntity()
	
		HideEntity_( GetInstance(Self) )
		
	End Method
	
	Method Hidden:Int()
	
		
	
	End Method
	
	Method NameEntity( name:String )
	
		Local cString:Byte Ptr=name.ToCString()
		NameEntity_( GetInstance(Self),cString )
		MemFree cString
		
	End Method
	
	Method EntityParent( parent_ent:TEntity,glob:Int=True )
	
		EntityParent_( GetInstance(Self),GetInstance(parent_ent),glob )
		
	End Method
	
	Method GetParent:TEntity()
	
		Local instance:Byte Ptr=GetParentEntity_( GetInstance(Self) )
		Return GetObject(instance)
		
	End Method
	
	' Entity state
	
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
	
	Method EntityClass:String()
	
		Return String.FromCString( EntityClass_( GetInstance(Self) ) )
		
	End Method
	
	Method EntityName:String()
		
		Return String.FromCString( EntityName_( GetInstance(Self) ) )
		
	End Method
	
	Method CountChildren:Int()
	
		Return CountChildren_( GetInstance(Self) )
		
	End Method
	
	Method GetChild:TEntity( child_no:Int )
	
		Local instance:Byte Ptr=GetChild_( GetInstance(Self),child_no )
		Local child:TEntity=GetObject(instance)
		If child=Null And instance<>Null Then child=NewObject(instance)
		Return child
		
	End Method
	
	Method FindChild:TEntity( child_name:String )
	
		Local cString:Byte Ptr=child_name.ToCString()
		Local instance:Byte Ptr=FindChild_( GetInstance(Self),cString )
		Local child:TEntity=GetObject(instance)
		If child=Null And instance<>Null Then child=NewObject(instance)
		MemFree cString
		Return child
		
	End Method
	
	' Calls function in TPick
	Method EntityPick:TEntity( Range:Float )
	
		Local instance:Byte Ptr=EntityPick_( GetInstance(Self),Range )
		Return GetObject(instance)
		
	End Method
	
	Rem
	' moved to TPick.bmx
	Method LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
	
		
		
	End Method
	EndRem
	
	Rem
	' moved to TPick.bmx
	Method EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
	
		
		
	End Method
	EndRem
	
	Method EntityDistance:Float( ent2:TEntity )
	
		Return EntityDistance_( GetInstance(Self),GetInstance(ent2) )
		
	End Method
	
	' Function by Vertex
	Method DeltaYaw:Float( ent2:TEntity )
	
		Return DeltaYaw_( GetInstance(Self),GetInstance(ent2) )
		
	End Method
	
	' Function by Vertex
	Method DeltaPitch:Float( ent2:TEntity )
	
		Return -DeltaPitch_( GetInstance(Self),GetInstance(ent2) ) ' inverted pitch
		
	End Method
	
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
	
		Return GetMatElement_( GetInstance(Self),row,col )
		
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
	
	Method EntityPickMode( pick_mode:Int,obscurer:Int=True )
	
		EntityPickMode_( GetInstance(Self),pick_mode,obscurer )
			
	End Method
	
	Method EntityCollided:TEntity( type_no:Int )
	
		Local instance:Byte Ptr=EntityCollided_( GetInstance(Self),type_no )
		Return GetObject(instance)
		
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
	
		Local instance:Byte Ptr=CollisionEntity_( GetInstance(Self),index )
		Return GetObject(instance)
		
	End Method
	
	Method CollisionSurface:TSurface( index:Int )
	
		Local instance:Byte Ptr=CollisionSurface_( GetInstance(Self),index )
		Local surf:TSurface=TSurface.GetObject(instance)
		If surf=Null And instance<>Null Then surf=TSurface.NewObject(instance)
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
	
	Method EntityScaleX:Float( glob:Int=False )
	
		Return EntityScaleX_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityScaleY:Float( glob:Int=False )
	
		Return EntityScaleY_( GetInstance(Self),glob )
		
	End Method
	
	Method EntityScaleZ:Float( glob:Int=False )
	
		Return EntityScaleZ_( GetInstance(Self),glob )
		
	End Method
	
	Rem
	' Returns an entity's bounding sphere
	Method BoundingSphere:TSphere()
	
		

	End Method
	End Rem

	' Returns an entity's bounding sphere
	Method BoundingSphereNew(sx# Var,sy# Var,sz# Var,sr# Var)

		

	End Method
	
	' Internal - not recommended for general use

	Method UpdateMat(load_identity:Int=False)

		
	
	End Method
	
	Method AddParent(parent_ent:TEntity)
	
		
		
	End Method
	
	Function UpdateChildren(ent_p:TEntity)
	
		
	
	End Function

	' unoptimised, unused
	Method EntityDistanceSquared0:Float(ent2:TEntity)

		
		
	End Method
	
	' optimised
	Method EntityDistanceSquared:Float(ent2:TEntity)

		
		
	End Method

	Method EntityListAdd(list:TList)
	
		

	End Method
	
End Type
