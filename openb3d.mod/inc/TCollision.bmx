
Const MAX_TYPES:Int=100

' collision methods - used in Collisions
Const COLLISION_METHOD_SPHERE:Int=1
Const COLLISION_METHOD_POLYGON:Int=2
Const COLLISION_METHOD_BOX:Int=3

' collision actions
Const COLLISION_RESPONSE_NONE:Int=0
Const COLLISION_RESPONSE_STOP:Int=1
Const COLLISION_RESPONSE_SLIDE:Int=2
Const COLLISION_RESPONSE_SLIDEXZ:Int=3

Type TCollisionPair
	
	Global cp_list:TList=CreateList() ' openb3d: CollisionPair list
	Global ent_lists:TList[MAX_TYPES] ' Entity list array
	
	Field src_type:Int Ptr ' 0
	Field des_type:Int Ptr ' 0
	Field col_method:Int Ptr ' 0
	Field response:Int Ptr ' 0
	
	' minib3d
	'Global list:TList=New TList
	
	' wrapper
	Global pair_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TCollisionPair( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TCollisionPair=New TCollisionPair
		pair_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		pair_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TCollisionPair( inst:Byte Ptr )
	
		Return TCollisionPair( pair_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TCollisionPair ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		For Local id:Int=0 To MAX_TYPES-1
			If ent_lists[id]=Null Then ent_lists[id]=CreateList() ' check if Graphics3D called again
		Next
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		src_type=CollisionPairInt_( GetInstance(Self),COLLISIONPAIR_src_type )
		des_type=CollisionPairInt_( GetInstance(Self),COLLISIONPAIR_des_type )
		col_method=CollisionPairInt_( GetInstance(Self),COLLISIONPAIR_col_method )
		response=CollisionPairInt_( GetInstance(Self),COLLISIONPAIR_response )
		
	End Method
	
	Function CopyList_( list:TList,listarray:TList[]=Null ) ' Global list and listarray
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case cp_list
				For Local id:Int=0 To StaticListSize_( COLLISIONPAIR_class,COLLISIONPAIR_cp_list )-1
					inst=StaticIterListCollisionPair_( COLLISIONPAIR_class,COLLISIONPAIR_cp_list )
					Local obj:TCollisionPair=GetObject(inst)
					If obj=Null And inst<>Null Then obj=CreateObject(inst)
					ListAddLast list,obj
				Next
			Case Null ' If first parameter Null
				Select listarray
					Case ent_lists
					For Local id:Int=0 To MAX_TYPES-1
						ClearList listarray[id]
						For Local id:Int=0 To StaticListSizeArray_( COLLISIONPAIR_class,COLLISIONPAIR_ent_lists,id )-1
							inst=StaticIterListEntityArray_( COLLISIONPAIR_class,COLLISIONPAIR_ent_lists,id )
							Local obj:TEntity=TEntity.GetObject(inst)
							If obj=Null And inst<>Null Then obj=TEntity.CreateObject(inst)
							ListAddLast listarray[id],obj
						Next
					Next
				End Select
		End Select
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TCollisionPair"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TCollisionPair"
		EndIf
	
	End Method

End Type

Type TCollisionImpact

	Field x:Float Ptr,y:Float Ptr,z:Float Ptr ' 0.0/0.0/0.0
	Field nx:Float Ptr,ny:Float Ptr,nz:Float Ptr ' 0.0/0.0/0.0
	Field time:Float Ptr ' 0.0
	Field ent:TEntity ' NULL
	Field surf:TSurface ' NULL
	Field tri:Int Ptr ' 0
	
	' wrapper
	Global impact_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TCollisionImpact( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TCollisionImpact=New TCollisionImpact
		impact_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		impact_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TCollisionImpact( inst:Byte Ptr )
	
		Return TCollisionImpact( impact_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TCollisionImpact ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		tri=CollisionImpactInt_( GetInstance(Self),COLLISIONIMPACT_tri )
		
		' float
		x=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_x )
		y=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_y )
		z=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_z )
		nx=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_nx )
		ny=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_ny )
		nz=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_nz )
		time=CollisionImpactFloat_( GetInstance(Self),COLLISIONIMPACT_time )
		
		' entity
		Local inst:Byte Ptr=CollisionImpactEntity_( GetInstance(Self),COLLISIONIMPACT_ent )
		ent=TEntity.GetObject(inst)
		If ent=Null And inst<>Null Then ent=TEntity.CreateObject(inst)
		
		' surface
		inst=CollisionImpactSurface_( GetInstance(Self),COLLISIONIMPACT_surf )
		surf=TSurface.GetObject(inst)
		If surf=Null And inst<>Null Then surf=TSurface.CreateObject(inst)
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TCollisionImpact"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TCollisionImpact"
		EndIf
	
	End Method
	
End Type

' updates static and dynamic collisions - called in UpdateWorld
Function UpdateCollisions()

	CollisionUpdateCollisions_()
	
End Function

' dynamic to static - called by UpdateCollisions
Function UpdateStaticCollisions()

	CollisionUpdateStaticCollisions_()
	
End Function

' dynamic to dynamic - called by UpdateCollisions
Function UpdateDynamicCollisions()

	CollisionUpdateDynamicCollisions_()
	
End Function

' like ClearCollisions but deletes CollisionImpact data rather than CollisionPair data (unused)
Function ClearCollisions2()

	CollisionclearCollisions_()
	
End Function

' set positions for all CollisionPair entities (unused)
Function PositionEntities:Int( update_old:Int=True,add_to_new:Int=False )

	Return CollisionPositionEntities_( update_old,add_to_new )
	
End Function

' perform quick check to see whether it is possible that ent and ent 2 are intersecting (unused)
Function QuickCheck:Int( ent:TEntity,ent2:TEntity )

	Return CollisionQuickCheck_( TEntity.GetInstance(ent),TEntity.GetInstance(ent2) )

End Function
