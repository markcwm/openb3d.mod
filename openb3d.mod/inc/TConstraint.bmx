
Rem
bbdoc: Constraint
End Rem
Type TConstraint
	
	Field instance:Byte Ptr
	
	Function CreateObject:TConstraint( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TConstraint=New TConstraint
		obj.instance=inst
		Return obj
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TConstraint ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Function CreateConstraint:TConstraint( p1:TEntity,p2:TEntity,l:Float )
	
		Local inst:Byte Ptr=CreateConstraint_( TEntity.GetInstance(p1),TEntity.GetInstance(p2),l )
		Return CreateObject(inst)
		
	End Function
	
End Type

Rem
bbdoc: Rigid Body
End Rem
Type TRigidBody
	
	Field instance:Byte Ptr
	
	Function CreateObject:TRigidBody( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TRigidBody=New TRigidBody
		obj.instance=inst
		Return obj
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TRigidBody ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Function CreateRigidBody:TRigidBody( body:TEntity,p1:TEntity,p2:TEntity,p3:TEntity,p4:TEntity )
	
		Local inst:Byte Ptr=CreateRigidBody_( TEntity.GetInstance(body),TEntity.GetInstance(p1),TEntity.GetInstance(p2),TEntity.GetInstance(p3),TEntity.GetInstance(p4) )
		Return CreateObject(inst)
		
	End Function
	
End Type
