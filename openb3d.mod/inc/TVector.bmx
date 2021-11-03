' TVector and TVector3D
' TVector is Float and TVector3D is Float Ptr, compatible with Openb3d functions

Rem
bbdoc: TVector functions, 3 x Float
End Rem
Type TVector

	Field x#,y#,z#
	
	Const EPSILON:Float=.0001
	
	Rem
	bbdoc: Create a new TVector object, returns a new Float vector
	about: new_vec=TVector.Create(x,y,z)
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
	about: new_vec=TVector.Create(x,y,z)
	EndRem
	Function Create:TVector(x#,y#,z#)
	
		Local vec:TVector=New TVector
		vec.x=x
		vec.y=y
		vec.z=z
		
		Return vec
		
	End Function
	
	Method Copy:TVector()
	
		Local vec:TVector=New TVector
	
		vec.x=x
		vec.y=y
		vec.z=z
	
		Return vec
	
	End Method
	
	Method Add:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x+vec.x
		new_vec.y=y+vec.y
		new_vec.z=z+vec.z
		
		Return new_vec
	
	End Method
	
	Method Subtract:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x-vec.x
		new_vec.y=y-vec.y
		new_vec.z=z-vec.z
		
		Return new_vec
	
	End Method
	
	Method Multiply:TVector(val#)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x*val#
		new_vec.y=y*val#
		new_vec.z=z*val#
		
		Return new_vec
	
	End Method
	
	Method Divide:TVector(val#)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=x/val#
		new_vec.y=y/val#
		new_vec.z=z/val#
		
		Return new_vec
	
	End Method
	
	Method Dot:Float(vec:TVector)
	
		Return (x#*vec.x#)+(y#*vec.y#)+(z#*vec.z#)
	
	End Method
	
	Method Cross:TVector(vec:TVector)
	
		Local new_vec:TVector=New TVector
		
		new_vec.x=(y*vec.z)-(z*vec.y)
		new_vec.y=(z*vec.x)-(x*vec.z)
		new_vec.z=(x*vec.y)-(y*vec.x)
		
		Return new_vec
	
	End Method
	
	Method Normalize()
	
		Local d#=1/Sqr(x*x+y*y+z*z)
		x:*d
		y:*d
		z:*d
		
	End Method
	
	Method Length#()
			
		Return Sqr(x*x+y*y+z*z)

	End Method
	
	Method SquaredLength#()
	
		Return x*x+y*y+z*z

	End Method
	
	Method SetLength#(val#)
	
		Normalize()
		x=x*val
		y=y*val
		z=z*val

	End Method
	
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
bbdoc: TVector3D functions, 3 x Float Ptr
End Rem
Type TVector3D

	Field x:Float Ptr, y:Float Ptr, z:Float Ptr
	
	Const EPSILON:Float=0.0001
	
	' wrapper
	?bmxng
	Global vector3d_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global vector3d_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TVector3D( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVector3D=New TVector3D
		?bmxng
		vector3d_map.Insert( inst,obj )
		?Not bmxng
		vector3d_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		vector3d_map.Remove( inst )
		?Not bmxng
		vector3d_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TVector3D( inst:Byte Ptr )
	
		?bmxng
		Return TVector3D( vector3d_map.ValueForKey( inst ) )
		?Not bmxng
		Return TVector3D( vector3d_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TVector3D ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		x=Vector3DFloat_( GetInstance(Self),VECTOR3D_x )
		y=Vector3DFloat_( GetInstance(Self),VECTOR3D_y )
		z=Vector3DFloat_( GetInstance(Self),VECTOR3D_z )
		
	End Method
	
	Rem
	bbdoc: Create a new TVector3D object, returns a new Float Ptr vector
	about: vec=TVector3D.NewVector3D()
	EndRem
	Function NewVector3D:TVector3D()
	
		Local inst:Byte Ptr=NewVector3D_()
		Return CreateObject(inst)
		
	End Function
	
	Rem
	bbdoc: Create a new TVector3D from three float values, returns a new Float Ptr vector
	about: new_vec=TVector3D.Create(x,y,z)
	EndRem
	Function Create:TVector3D( x:Float=0,y:Float=0,z:Float=0 )
	
		Local inst:Byte Ptr=NewVector3D_()
		Local new_vec:TVector3D=CreateObject(inst)
		new_vec.x[0]=x
		new_vec.y[0]=y
		new_vec.z[0]=z
		Return new_vec
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TVector3D"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TVector3D"
		EndIf
	
	End Method
	
	' float=TVector3D.VectorYaw(x,y,z)
	Function VectorYaw:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Yaw()
	
		Return ATan2(-vx,vz)
		
	End Function
	
	' float=TVector3D.VectorPitch(x,y,z)
	Function VectorPitch:Float( vx:Float,vy:Float,vz:Float ) ' by Patmaba, same as Pitch()
	
		Local ang:Float=ATan2(Sqr(vx*vx + vz*vz), vy)-90.0
		If ang<=EPSILON And ang>=-EPSILON Then ang=0
		Return ang
		
	End Function
	
	Rem
	bbdoc: Magnitude (or length) of a TVector3D from three float values, returns a float
	about: float=TVector3D.Magnitude(x,y,z)
	EndRem
	Function Magnitude:Float( v0:Float,v1:Float,v2:Float )
	
		Return Sqr(v0*v0 + v1*v1 + v2*v2)
		
	End Function
	
	' Openb3d
	
	Rem
	bbdoc: Copy a TVector3D, returns a new vector
	about: new_vec=vec.Copy()
	EndRem
	Method Copy:TVector3D()
	
		Local inst:Byte Ptr=Vector3DCopy_( GetInstance(Self) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Negate a TVector3D, returns a new vector
	about: new_vec=vec.Negate(vec2)
	EndRem
	Method Negate:TVector3D()
	
		Local inst:Byte Ptr=Vector3DNegate_( GetInstance(Self) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Add a TVector3D to another TVector3D, returns a new vector
	about: new_vec=vec.Add(vec2)
	EndRem
	Method Add:TVector3D( vec2:TVector3D )
	
		Local inst:Byte Ptr=Vector3DAdd_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Subtract another TVector3D from a TVector3D, returns a new vector
	about: new_vec=vec.Subtract(vec2)
	EndRem
	Method Subtract:TVector3D( vec2:TVector3D )
	
		Local inst:Byte Ptr=Vector3DSubtract_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Multiply a TVector3D by a float, returns a new vector
	about: new_vec=vec.Multiply(scale)
	EndRem
	Method Multiply:TVector3D( scale:Float )
	
		Local inst:Byte Ptr=Vector3DMultiply_( GetInstance(Self),scale )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
	
	End Method
	
	Rem
	bbdoc: Multiply a TVector3D by another TVector3D, returns a new vector
	about: new_vec=vec.Multiply2(vec2)
	EndRem
	Method Multiply2:TVector3D( vec2:TVector3D )
	
		Local inst:Byte Ptr=Vector3DMultiply2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a TVector3D by a float, returns a new vector
	about: new_vec=vec.Divide(scale)
	EndRem
	Method Divide:TVector3D( scale:Float )
	
		Local inst:Byte Ptr=Vector3DDivide_( GetInstance(Self),scale )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Divide a TVector3D by another TVector3D, returns a new vector
	about: new_vec=vec.Divide2(vec2)
	EndRem
	Method Divide2:TVector3D( vec2:TVector3D )
	
		Local inst:Byte Ptr=Vector3DDivide2_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Dot product (or squared length) of two TVector3Ds, returns a new vector
	about: float=vec.Dot(vec2)
	EndRem
	Method Dot:Float( vec2:TVector3D )
	
		Return Vector3DDot_( GetInstance(Self),GetInstance(vec2) )
	
	End Method
	
	Rem
	bbdoc: Cross product of two TVector3Ds, returns a new vector
	about: new_vec=vec.Cross(vec2)
	EndRem
	Method Cross:TVector3D( vec2:TVector3D )
	
		Local inst:Byte Ptr=Vector3DCross_( GetInstance(Self),GetInstance(vec2) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Length (or magnitude) of a TVector3D, returns a float
	about: float=vec.Length()
	EndRem
	Method Length:Float()
		
		Return Vector3DLength_( GetInstance(Self) )

	End Method
	
	Rem
	bbdoc: Distance between two TVector3Ds, returns a float
	about: float=vec.Distance(vec2)
	EndRem
	Method Distance:Float( vec2:TVector3D )
			
		Return Vector3DDistance_( GetInstance(Self),GetInstance(vec2) )

	End Method
	
	Rem
	bbdoc: Normalize a TVector3D, returns a new vector
	about: new_vec=vec.Normalized()
	EndRem
	Method Normalized:TVector3D()
	
		Local inst:Byte Ptr=Vector3DNormalized_( GetInstance(Self) )
		Local new_vec:TVector3D=TVector3D.GetObject(inst)
		If new_vec=Null And inst<>Null Then new_vec=TVector3D.CreateObject(inst)
		Return new_vec
		
	End Method
	
	Rem
	bbdoc: Normalize a TVector3D, returns nothing
	about: vec.Normalize()
	EndRem
	Method Normalize()
	
		Vector3DNormalize_( GetInstance(Self) )
		
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
	bbdoc: Clear a TVector3Ds values, returns nothing
	about: vec.Clear()
	EndRem
	Method Clear()
	
		Vector3DClear_( GetInstance(Self) )
		
	End Method
	
End Type
