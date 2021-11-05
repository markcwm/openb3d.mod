' TVector is Float (Minib3d) and TVecPtr is Float Ptr (Openb3d)

Rem
bbdoc: TVector functions (Minib3d)
End Rem
Type TVector

	Field x#,y#,z#
	
	Const EPSILON:Float=.0001
	
	Rem
	bbdoc: Create a new TVector object, returns a new Float vector
	EndRem
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog "New TVector"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog "Del TVector"
		EndIf
	
	End Method

	Rem
	bbdoc: Create a new TVector from three float values, returns a new Float vector
	EndRem
	Function Create:TVector(x#,y#,z#)
	
		Local vec:TVector=New TVector
		vec.x=x
		vec.y=y
		vec.z=z
		
		Return vec
		
	End Function
	
	Rem
	bbdoc: Copy a TVector, returns a new vector
	EndRem
	Method Copy:TVector()
	
		Local vec:TVector=New TVector
	
		vec.x=x
		vec.y=y
		vec.z=z
	
		Return vec
	
	End Method
	
	Rem
	bbdoc: Add a TVector to another TVector, returns a new vector
	EndRem
	Method Add:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x+vec.x
		new_vec.y=y+vec.y
		new_vec.z=z+vec.z
		
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Subtract a TVector from another TVector, returns a new vector
	EndRem
	Method Subtract:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x-vec.x
		new_vec.y=y-vec.y
		new_vec.z=z-vec.z
		
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Multiply a TVector by a float, returns a new vector
	EndRem
	Method Multiply:TVector(val#)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x*val#
		new_vec.y=y*val#
		new_vec.z=z*val#
		
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Divide a TVector by a float, returns a new vector
	EndRem
	Method Divide:TVector(val#)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x/val#
		new_vec.y=y/val#
		new_vec.z=z/val#
		
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Dot product (or squared length) of two TVectors, returns a new vector
	EndRem
	Method Dot:Float(vec:TVector)
	
		Return (x#*vec.x#)+(y#*vec.y#)+(z#*vec.z#)
	
	End Method
	
	Rem
	bbdoc: Cross product of two TVectors, returns a new vector
	EndRem
	Method Cross:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=(y*vec.z)-(z*vec.y)
		new_vec.y=(z*vec.x)-(x*vec.z)
		new_vec.z=(x*vec.y)-(y*vec.x)
		
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Normalize a TVector, returns nothing
	EndRem
	Method Normalize()
	
		Local d#=1/Sqr(x*x+y*y+z*z)
		x:*d
		y:*d
		z:*d
		
	End Method
	
	Rem
	bbdoc: Length (or magnitude) of a TVector, returns a float
	EndRem
	Method Length#()
			
		Return Sqr(x*x+y*y+z*z)

	End Method
	
	Rem
	bbdoc: Squared length of a TVector, returns a float
	EndRem
	Method SquaredLength#()
	
		Return x*x+y*y+z*z

	End Method
	
	Rem
	bbdoc: Set normalized length of a TVector, returns a float
	EndRem
	Method SetLength#(val#)
	
		Normalize()
		x=x*val
		y=y*val
		z=z*val

	End Method
	
	Rem
	bbdoc: Compare a TVector with another TVector, returns 1 or -1
	EndRem
	Method Compare:Int( with:Object )
		Local q:TVector=TVector(with)
		If x-q.x>EPSILON Return 1
		If q.x-x>EPSILON Return -1
		If y-q.y>EPSILON Return 1
		If q.y-y>EPSILON Return -1
		If z-q.z>EPSILON Return 1
		If q.z-z>EPSILON Return -1
		Return 0
	End Method

	' Function by patmaba
	Function VectorYaw#(vx#,vy#,vz#)

		Return ATan2(-vx#,vz#)
	
	End Function

	' Function by patmaba
	Function VectorPitch#(vx#,vy#,vz#)

		Local ang#=ATan2(Sqr(vx#*vx#+vz#*vz#),vy#)-90.0

		If ang#<=0.0001 And ang#>=-0.0001 Then ang#=0
	
		Return ang#
	
	End Function

End Type

Rem
bbdoc: TVecPtr functions (Openb3d)
End Rem
Type TVecPtr

	Field x:Float Ptr, y:Float Ptr, z:Float Ptr
	
	Const EPSILON:Float=0.0001
	
	' wrapper
	?bmxng
	Global vecptr_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global vecptr_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TVecPtr( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVecPtr=New TVecPtr
		?bmxng
		vecptr_map.Insert( inst,obj )
		?Not bmxng
		vecptr_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		vecptr_map.Remove( inst )
		?Not bmxng
		vecptr_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TVecPtr( inst:Byte Ptr )
	
		?bmxng
		Return TVecPtr( vecptr_map.ValueForKey( inst ) )
		?Not bmxng
		Return TVecPtr( vecptr_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TVecPtr ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		x=VecPtrFloat_( GetInstance(Self),VECPTR_x )
		y=VecPtrFloat_( GetInstance(Self),VECPTR_y )
		z=VecPtrFloat_( GetInstance(Self),VECPTR_z )
		
	End Method
	
	Rem
	bbdoc: Create a new TVecPtr object, returns a new Float Ptr vector
	about: vec=TVecPtr.NewVecPtr()
	EndRem
	Function NewVecPtr:TVecPtr()
	
		Local inst:Byte Ptr=NewVecPtr_()
		Return CreateObject(inst)
		
	End Function
	
	Rem
	bbdoc: Create a new TVecPtr from three float values, returns a new Float Ptr vector
	about: new_vec=TVecPtr.Create(x,y,z)
	EndRem
	Function Create:TVecPtr( x:Float=0,y:Float=0,z:Float=0 )
	
		Local inst:Byte Ptr=NewVecPtr_()
		Local new_vec:TVecPtr=CreateObject(inst)
		new_vec.x[0]=x
		new_vec.y[0]=y
		new_vec.z[0]=z
		Return new_vec
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TVecPtr"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TVecPtr"
		EndIf
	
	End Method
	
	' float=TVecPtr.VectorYaw(x,y,z)
	Function VectorYaw:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Yaw()
	
		Return ATan2(-vx,vz)
		
	End Function
	
	' float=TVecPtr.VectorPitch(x,y,z)
	Function VectorPitch:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Pitch()
	
		Local ang:Float=ATan2(Sqr(vx*vx + vz*vz), vy)-90.0
		If ang<=EPSILON And ang>=-EPSILON Then ang=0
		Return ang
		
	End Function
	
	Rem
	bbdoc: Magnitude (or length) of a TVecPtr from three float values, returns a float
	about: float=TVecPtr.Magnitude(x,y,z)
	EndRem
	Function Magnitude:Float( v0:Float,v1:Float,v2:Float )
	
		Return Sqr(v0*v0 + v1*v1 + v2*v2)
		
	End Function
	
	' Openb3d
	
	Rem
	bbdoc: Copy a TVecPtr, returns a new vector
	about: new_vec=vec.Copy()
	EndRem
	Method Copy:TVecPtr()
	
		Local inst:Byte Ptr=VecPtrCopy_( GetInstance(Self) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Negate a TVecPtr, returns a new vector
	about: new_vec=vec.Negate(vec2)
	EndRem
	Method Negate:TVecPtr()
	
		Local inst:Byte Ptr=VecPtrNegate_( GetInstance(Self) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Add a TVecPtr to another TVecPtr, returns a new vector
	about: new_vec=vec.Add(vec2)
	EndRem
	Method Add:TVecPtr( vec2:TVecPtr )
	
		Local inst:Byte Ptr=VecPtrAdd_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Subtract a TVecPtr from another TVecPtr, returns a new vector
	about: new_vec=vec.Subtract(vec2)
	EndRem
	Method Subtract:TVecPtr( vec2:TVecPtr )
	
		Local inst:Byte Ptr=VecPtrSubtract_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Multiply a TVecPtr by a float, returns a new vector
	about: new_vec=vec.Multiply(scale)
	EndRem
	Method Multiply:TVecPtr( scale:Float )
	
		Local inst:Byte Ptr=VecPtrMultiply_( GetInstance(Self),scale )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Multiply a TVecPtr by another TVecPtr, returns a new vector
	about: new_vec=vec.Multiply2(vec2)
	EndRem
	Method Multiply2:TVecPtr( vec2:TVecPtr )
	
		Local inst:Byte Ptr=VecPtrMultiply2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a TVecPtr by a float, returns a new vector
	about: new_vec=vec.Divide(scale)
	EndRem
	Method Divide:TVecPtr( scale:Float )
	
		Local inst:Byte Ptr=VecPtrDivide_( GetInstance(Self),scale )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a TVecPtr by another TVecPtr, returns a new vector
	about: new_vec=vec.Divide2(vec2)
	EndRem
	Method Divide2:TVecPtr( vec2:TVecPtr )
	
		Local inst:Byte Ptr=VecPtrDivide2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Dot product (or squared length) of two TVecPtrs, returns a new vector
	about: float=vec.Dot(vec2)
	EndRem
	Method Dot:Float( vec2:TVecPtr )
	
		Return VecPtrDot_( GetInstance(Self),GetInstance(vec2) )
	
	End Method
	
	Rem
	bbdoc: Cross product of two TVecPtrs, returns a new vector
	about: new_vec=vec.Cross(vec2)
	EndRem
	Method Cross:TVecPtr( vec2:TVecPtr )
	
		Local inst:Byte Ptr=VecPtrCross_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Length (or magnitude) of a TVecPtr, returns a float
	about: float=vec.Length()
	EndRem
	Method Length:Float()
		
		Return VecPtrLength_( GetInstance(Self) )

	End Method
	
	Rem
	bbdoc: Distance between two TVecPtrs, returns a float
	about: float=vec.Distance(vec2)
	EndRem
	Method Distance:Float( vec2:TVecPtr )
			
		Return VecPtrDistance_( GetInstance(Self),GetInstance(vec2) )

	End Method
	
	Rem
	bbdoc: Normalize a TVecPtr, returns a new vector
	about: new_vec=vec.Normalized()
	EndRem
	Method Normalized:TVecPtr()
	
		Local inst:Byte Ptr=VecPtrNormalized_( GetInstance(Self) )
		Local new_vec:TVecPtr=TVecPtr.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVecPtr.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Normalize a TVecPtr, returns nothing
	about: vec.Normalize()
	EndRem
	Method Normalize()
	
		VecPtrNormalize_( GetInstance(Self) )
		
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
	bbdoc: Clear a TVecPtrs values, returns nothing
	about: vec.Clear()
	EndRem
	Method Clear()
	
		VecPtrClear_( GetInstance(Self) )
		
	End Method
	
End Type
