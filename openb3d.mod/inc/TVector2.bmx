
Type TVector2

	Field x:Float Ptr,y:Float Ptr,z:Float Ptr
	
	Const EPSILON:Float=0.0001
	
	' wrapper
	Global vector_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TVector2( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVector2=New TVector2
		vector_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		vector_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TVector2( inst:Byte Ptr )
	
		Return TVector2( vector_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TVector2 ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		x=VectorFloat_( GetInstance(Self),VECTOR_x )
		y=VectorFloat_( GetInstance(Self),VECTOR_y )
		z=VectorFloat_( GetInstance(Self),VECTOR_z )
		
	End Method
	
	' Openb3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TVector"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TVector"
		EndIf
	
	End Method

	Function Create:TVector(x#,y#,z#)
	
		
		
	End Function
	
	Method Copy:TVector()
	
		
	
	End Method
	
	Method Add:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Subtract:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Multiply:TVector(val#)
	
		
	
	End Method
	
	Method Divide:TVector(val#)
	
		
	
	End Method
	
	Method Dot:Float(vec:TVector)
	
		
	
	End Method
	
	Method Cross:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Normalize()
	
		
		
	End Method
	
	Method Length#()
			
		

	End Method
	
	Method SquaredLength#()
	
		

	End Method
	
	Method SetLength#(val#)
	
		

	End Method
	
	Method Compare:Int( with:Object )
	
		
		
	End Method
	
	Function VectorYaw#(vx#,vy#,vz#) ' Function by patmaba

		
	
	End Function
	
	Function VectorPitch#(vx#,vy#,vz#) ' Function by patmaba

		
	
	End Function
	
End Type
