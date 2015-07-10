Rem
bbdoc: Pick
EndRem
Type TPick

	' EntityPickMode in TEntity

	Const EPSILON:Float=.0001
	
	Global ent_list:TList=New TList ' list containing pickable entities

	Global picked_x:Float,picked_y:Float,picked_z:Float
	Global picked_nx:Float,picked_ny:Float,picked_nz:Float
	Global picked_time:Float
	Global picked_ent:TEntity
	Global picked_surface:TSurface
	Global picked_triangle:Int

	Function CameraPick:TEntity(cam:TCamera,vx:Float,vy:Float)

		
	
	End Function

	Function EntityPick:TEntity(ent:TEntity,Range:Float)

		

	End Function
	
	Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
	
		Local instance:Byte Ptr=LinePick_( x,y,z,dx,dy,dz,radius )
		Return TEntity.GetObject(instance)
		
	End Function
	
	Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
	
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
	
		Local instance:Byte Ptr=PickedEntity_()
		Return TEntity.GetObject(instance)
		
	End Function
	
	Function PickedSurface:TSurface()
	
		Local instance:Byte Ptr=PickedSurface_()
		Local surf:TSurface=TSurface.GetObject(instance)
		If surf=Null And instance<>Null Then surf=TSurface.NewObject(instance)
		Return surf
		
	End Function
	
	Function PickedTriangle:Int()
	
		Return PickedTriangle_()
		
	End Function

	' requires two absolute positional values
	Function Pick:TEntity(ax:Float,ay:Float,az:Float,bx:Float,by:Float,bz:Float,radius:Float=0.0)

		

	End Function

End Type
