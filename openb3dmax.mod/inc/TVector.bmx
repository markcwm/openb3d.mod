
Rem
bbdoc: Vector functions
End Rem
Type TVector

	Field x:Float Ptr, y:Float Ptr, z:Float Ptr
	
	Const EPSILON:Float=0.0001
	
	' wrapper
	?bmxng
	Global vector_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global vector_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TVector( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVector=New TVector
		?bmxng
		vector_map.Insert( inst,obj )
		?Not bmxng
		vector_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		vector_map.Remove( inst )
		?Not bmxng
		vector_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TVector( inst:Byte Ptr )
	
		?bmxng
		Return TVector( vector_map.ValueForKey( inst ) )
		?Not bmxng
		Return TVector( vector_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TVector ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		x=VectorFloat_( GetInstance(Self),VECTOR_x )
		y=VectorFloat_( GetInstance(Self),VECTOR_y )
		z=VectorFloat_( GetInstance(Self),VECTOR_z )
		
	End Method
	
	Function NewVector:TVector()
	
		Local inst:Byte Ptr=NewVector_()
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TVector"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TVector"
		EndIf
	
	End Method
	
	' float=TVector.VectorYaw(x,y,z)
	Function VectorYaw:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Yaw()
	
		Return ATan2(-vx,vz)
		
	End Function
	
	' float=TVector.VectorPitch(x,y,z)
	Function VectorPitch:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Pitch()
	
		Local ang:Float=ATan2(Sqr(vx*vx + vz*vz), vy)-90.0
		If ang<=EPSILON And ang>=-EPSILON Then ang=0
		Return ang
		
	End Function
	
	Rem
	bbdoc: Create a new vector from three float values, returns a new vector
	about: new_vec=TVector.Create(x,y,z)
	EndRem
	Function Create:TVector( x:Float,y:Float,z:Float )
	
		Local new_vec:TVector=NewVector()
		new_vec.x[0]=x
		new_vec.y[0]=y
		new_vec.z[0]=z
		Return new_vec
		
	End Function
	
	Rem
	bbdoc: Magnitude (or length) of a vector from three float values, returns a float
	about: float=TVector.Magnitude(x,y,z)
	EndRem
	Function Magnitude:Float( v0:Float,v1:Float,v2:Float )
	
		Return Sqr(v0*v0 + v1*v1 + v2*v2)
		
	End Function
	
	' Openb3d
	
	Rem
	bbdoc: Copy a vector, returns a new vector
	about: new_vec=vec.Copy()
	EndRem
	Method Copy:TVector()
	
		Local inst:Byte Ptr=VectorCopy_( GetInstance(Self) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Negate a vector, returns a new vector
	about: new_vec=vec.Negate(vec2)
	EndRem
	Method Negate:TVector()
	
		Local inst:Byte Ptr=VectorNegate_( GetInstance(Self) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Add a vector to another vector, returns a new vector
	about: new_vec=vec.Add(vec2)
	EndRem
	Method Add:TVector( vec2:TVector )
	
		Local inst:Byte Ptr=VectorAdd_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Subtract another vector from a vector, returns a new vector
	about: new_vec=vec.Subtract(vec2)
	EndRem
	Method Subtract:TVector( vec2:TVector )
	
		Local inst:Byte Ptr=VectorSubtract_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Multiply a vector by a float, returns a new vector
	about: new_vec=vec.Multiply(scale)
	EndRem
	Method Multiply:TVector( scale:Float )
	
		Local inst:Byte Ptr=VectorMultiply_( GetInstance(Self),scale )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Multiply a vector by another vector, returns a new vector
	about: new_vec=vec.Multiply2(vec2)
	EndRem
	Method Multiply2:TVector( vec2:TVector )
	
		Local inst:Byte Ptr=VectorMultiply2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a vector by a float, returns a new vector
	about: new_vec=vec.Divide(scale)
	EndRem
	Method Divide:TVector( scale:Float )
	
		Local inst:Byte Ptr=VectorDivide_( GetInstance(Self),scale )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a vector by another vector, returns a new vector
	about: new_vec=vec.Divide2(vec2)
	EndRem
	Method Divide2:TVector( vec2:TVector )
	
		Local inst:Byte Ptr=VectorDivide2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Dot product (or squared length) of two vectors, returns a new vector
	about: float=vec.Dot(vec2)
	EndRem
	Method Dot:Float( vec2:TVector )
	
		Return VectorDot_( GetInstance(Self),GetInstance(vec2) )
	
	End Method
	
	Rem
	bbdoc: Cross product of two vectors, returns a new vector
	about: new_vec=vec.Cross(vec2)
	EndRem
	Method Cross:TVector( vec2:TVector )
	
		Local inst:Byte Ptr=VectorCross_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Length (or magnitude) of a vector, returns a float
	about: float=vec.Length()
	EndRem
	Method Length:Float()
		
		Return VectorLength_( GetInstance(Self) )

	End Method
	
	Rem
	bbdoc: Distance between two vectors, returns a float
	about: float=vec.Distance(vec2)
	EndRem
	Method Distance:Float( vec2:TVector )
			
		Return VectorDistance_( GetInstance(Self),GetInstance(vec2) )

	End Method
	
	Rem
	bbdoc: Normalize a vector, returns a new vector
	about: new_vec=vec.Normalized()
	EndRem
	Method Normalized:TVector()
	
		Local inst:Byte Ptr=VectorNormalized_( GetInstance(Self) )
		Local new_vec:TVector=TVector.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Normalize a vector, returns nothing
	about: vec.Normalize()
	EndRem
	Method Normalize()
	
		VectorNormalize_( GetInstance(Self) )
		
	End Method
	
	Rem
	bbdoc: Yaw (or y angle) in degrees of a vector, returns a float
	about: float=vec.Yaw()
	EndRem
	Method Yaw:Float()

		Return VectorYaw_( x[0],y[0],z[0] )
		
	End Method
	
	Rem
	bbdoc: Pitch (or x angle) in degrees of a vector, returns a float
	about: float=vec.Pitch()
	EndRem
	Method Pitch:Float()
	
		Return -VectorPitch_( x[0],y[0],z[0] ) ' inverted pitch
		
	End Method
	
	Rem
	bbdoc: Clear a vectors values, returns nothing
	about: vec.Clear()
	EndRem
	Method Clear()
	
		VectorClear_( GetInstance(Self) )
		
	End Method
	
End Type
