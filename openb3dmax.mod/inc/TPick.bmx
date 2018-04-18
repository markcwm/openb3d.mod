
Rem
bbdoc: Pick
EndRem
Type TPick

	'Const EPSILON:Float=0.0001 'not used
	
	Global ent_list:TList=CreateList() ' Entity list containing pickable entities - set in EntityPickMode
	
	Global picked_x:Float Ptr
	Global picked_y:Float Ptr
	Global picked_z:Float Ptr
	Global picked_nx:Float Ptr
	Global picked_ny:Float Ptr
	Global picked_nz:Float Ptr
	Global picked_time:Float Ptr
	Global picked_ent:TEntity
	Global picked_surface:TSurface
	Global picked_triangle:Int Ptr
	
	' wrapper
	Global ent_list_id:Int=0
	
	Function InitGlobals() ' Once per Graphics3D
	
		picked_x=StaticFloat_( PICK_class,PICK_picked_x )
		picked_y=StaticFloat_( PICK_class,PICK_picked_y )
		picked_z=StaticFloat_( PICK_class,PICK_picked_z )
		picked_nx=StaticFloat_( PICK_class,PICK_picked_nx )
		picked_ny=StaticFloat_( PICK_class,PICK_picked_ny )
		picked_nz=StaticFloat_( PICK_class,PICK_picked_nz )
		picked_time=StaticFloat_( PICK_class,PICK_picked_time )
		
		picked_triangle=StaticInt_( PICK_class,PICK_picked_triangle )
		
	End Function
	
	Function AddList_( list:TList ) ' Global list
	
		Select list
			Case ent_list
				If StaticListSize_( PICK_class,PICK_ent_list )
					Local inst:Byte Ptr=StaticIterListEntity_( PICK_class,PICK_ent_list,Varptr ent_list_id )
					Local obj:TEntity=TEntity.GetObject(inst) ' no CreateObject
					If obj And ListContains( list,obj )=0 Then ListAddLast( list,obj )
				EndIf
		End Select
		
	End Function
	
	Function CopyList_( list:TList ) ' Global list (unused)
	
		ClearList list
		
		Select list
			Case ent_list
				ent_list_id=0
				For Local id:Int=0 To StaticListSize_( PICK_class,PICK_ent_list )-1
					Local inst:Byte Ptr=StaticIterListEntity_( PICK_class,PICK_ent_list,Varptr ent_list_id )
					Local obj:TEntity=TEntity.GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
		End Select
		
	End Function
	
	' Minib3d
	
	Function CameraPick:TEntity( cam:TCamera,x:Float,y:Float ) ' same as method in TCamera
	
		Local inst:Byte Ptr=CameraPick_( TCamera.GetInstance(cam),x,GraphicsHeight()-y ) ' inverted y
		Return TCamera.GetObject(inst)
		
	End Function
	
	Function EntityPick:TEntity( ent:TEntity,Range:Float ) ' same as method in TEntity
	
		Local inst:Byte Ptr=EntityPick_( TEntity.GetInstance(ent),Range )
		Return TEntity.GetObject(inst)
		
	End Function
	
	' same as method in TEntity
	Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
	
		Local inst:Byte Ptr=LinePick_( x,y,z,dx,dy,dz,radius )
		Return TEntity.GetObject(inst)
		
	End Function
	
	Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity ) ' same as method in TEntity
	
		Return EntityVisible_( TEntity.GetInstance(src_ent),TEntity.GetInstance(dest_ent) )
		
	End Function

	Function PickedX:Float()
	
		Return PickedX_()
		
	End Function
	
	Function PickedY:Float()
	
		Return PickedY_()
		
	End Function
	
	Function PickedZ:Float()
	
		Return PickedZ_()
		
	End Function
	
	Function PickedNX:Float()
	
		Return PickedNX_()
		
	End Function
	
	Function PickedNY:Float()
	
		Return PickedNY_()
		
	End Function
	
	Function PickedNZ:Float()
	
		Return PickedNZ_()
		
	End Function
	
	Function PickedTime:Float()
	
		Return PickedTime_()
		
	End Function
	
	Function PickedEntity:TEntity()
	
		Local inst:Byte Ptr=PickedEntity_()
		TPick.picked_ent=TEntity.GetObject( StaticEntity_( PICK_class,PICK_picked_ent ) )
		Return TEntity.GetObject(inst)
		
	End Function
	
	Function PickedSurface:TSurface()
	
		Local inst:Byte Ptr=PickedSurface_()
		TPick.picked_surface=TSurface.GetObject( StaticSurface_( PICK_class,PICK_picked_surface ) )
		Return TSurface.GetObject(inst) ' no CreateObject
		
	End Function
	
	Function PickedTriangle:Int()
	
		Return PickedTriangle_()
		
	End Function
	
	' Internal
	
	' requires two absolute positional values
	Function Pick:TEntity( ax:Float,ay:Float,az:Float,bx:Float,by:Float,bz:Float,radius:Float=0.0 )
	
		Local inst:Byte Ptr=PickMain_( ax,ay,az,bx,by,bz,radius )
		Return TEntity.GetObject(inst)
		
	End Function
	
End Type
