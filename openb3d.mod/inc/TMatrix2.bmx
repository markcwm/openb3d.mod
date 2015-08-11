
Type TMatrix2

	Field grid:Float Ptr ' array [4,4] - LoadIdentity
	
	' wrapper
	Global matrix_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TMatrix2( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TMatrix2=New TMatrix2
		matrix_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		matrix_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TMatrix2( inst:Byte Ptr )
	
		Return TMatrix2( matrix_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TMatrix2 ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		grid=MatrixFloat_( GetInstance(Self),MATRIX_grid )
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TMatrix2"
		EndIf

	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TMatrix2"
		EndIf

	End Method
	
	' converts matrix into an identity matrix
	Method LoadIdentity()
	
		MatrixLoadIdentity_( GetInstance(Self) )
		
	End Method
	
	' copy - create new copy and returns it
	Method Copy:TMatrix2()
	
		Local inst:Byte Ptr=MatrixCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
	' overwrite - overwrites self with matrix passed as parameter
	Method Overwrite( mat:TMatrix2 )
	
		MatrixOverwrite_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	' returns an inverse transformation
	Method GetInverse:TMatrix2( mat:TMatrix2 )
	
		Local inst:Byte Ptr=MatrixGetInverse_( GetInstance(Self),GetInstance(mat) )	
		Return GetObject(inst)
		Local mat2:TMatrix2=GetObject(inst)
		If mat2=Null And mat2<>Null Then mat2=CreateObject(inst)
		Return mat2
		
	End Method
	
	Rem
	' minib3d
	Method Inverse:TMatrix()
	
	End Method
	EndRem
	
	' multiply matrix with the specified matrix
	Method Multiply( mat:TMatrix2 )
	
		MatrixMultiply_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	' move/translate matrix
	Method Translate( x:Float,y:Float,z:Float )
	
		MatrixTranslate_( GetInstance(Self),x,y,z )
		
	End Method
	
	' scale matrix (set the diagonal elements to x, y, z)
	Method Scale( x:Float,y:Float,z:Float )
	
		MatrixScale_( GetInstance(Self),x,y,z )
		
	End Method
	
	' rotate matrix
	Method Rotate( rx:Float,ry:Float,rz:Float )
	
		MatrixRotate_( GetInstance(Self),rx,ry,rz )
		
	End Method
	
	' rotate matrix about the x axis (ang in degrees)
	Method RotatePitch( ang:Float )
	
		MatrixRotatePitch_( GetInstance(Self),ang )
		
	End Method
	
	' rotate matrix about the y axis (ang in degrees)
	Method RotateYaw( ang:Float )
	
		MatrixRotateYaw_( GetInstance(Self),ang )
		
	End Method
	
	' rotate matrix about the z axis (ang in degrees)
	Method RotateRoll( ang:Float )
	
		MatrixRotateRoll_( GetInstance(Self),ang )
		
	End Method
	
	' Openb3d
	
	' converts a quaternion to a rotation matrix
	Method FromQuaternion( x:Float,y:Float,z:Float,w:Float )
	
		MatrixFromQuaternion_( GetInstance(Self),x,y,z,w )
		
	End Method
	
	' transforms the specified vector by this matrix
	Method TransformVec( rx:Float Var,ry:Float Var,rz:Float Var,addTranslation:Int=0 )
	
		MatrixTransformVec_( GetInstance(Self),Varptr(rx),Varptr(ry),Varptr(rz),addTranslation )
		
	End Method
	
	' transpose matrix
	Method Transpose()
	
		MatrixTranspose_( GetInstance(Self) )
		
	End Method
	
	' set the matrix to translate
	Method SetTranslate( x:Float,y:Float,z:Float )
	
		MatrixSetTranslate_( GetInstance(Self),x,y,z )
		
	End Method
	
	' multiply matrix with the specified matrix
	Method Multiply2( mat:TMatrix2 )
	
		MatrixMultiply2_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	' returns x rotation of matrix
	Method GetPitch:Float()
	
		Return MatrixGetPitch_( GetInstance(Self) )
		
	End Method
	
	' returns y rotation of matrix
	Method GetYaw:Float()
	
		Return MatrixGetYaw_( GetInstance(Self) )
		
	End Method
	
	' returns z rotation of matrix
	Method GetRoll:Float()
	
		Return MatrixGetRoll_( GetInstance(Self) )
		
	End Method
	
	' creates a transformation matrix that rotates a vector to another
	Method FromToRotation( ix:Float,iy:Float,iz:Float,jx:Float,jy:Float,jz:Float )
	
		MatrixFromToRotation_( GetInstance(Self),ix,iy,iz,jx,jy,jz )
		
	End Method
	
	' convert matrix to quaternion
	Method ToQuat( qx:Float Var,qy:Float Var,qz:Float Var,qw:Float Var )
	
		MatrixToQuat_( GetInstance(Self),Varptr(qx),Varptr(qy),Varptr(qz),Varptr(qw) )
		
	End Method
	
End Type

' Openb3d

' Creates a quaternion from an angle and an axis
Function Quaternion_FromAngleAxis( angle:Float,ax:Float,ay:Float,az:Float,rx:Float Var,ry:Float Var,rz:Float Var,rw:Float Var )

	MatrixQuaternion_FromAngleAxis( angle,ax,ay,az,Varptr(rx),Varptr(ry),Varptr(rz),Varptr(rw) )
	
End Function

' Multiplies a quaternion
Function Quaternion_MultiplyQuat( x1:Float,y1:Float,z1:Float,w1:Float,x2:Float,y2:Float,z2:Float,w2:Float,rx:Float Var,ry:Float Var,rz:Float Var,rw:Float Var )

	MatrixQuaternion_MultiplyQuat( x1,y1,z1,w1,x2,y2,z2,w2,Varptr(rx),Varptr(ry),Varptr(rz),Varptr(rw) )
	
End Function

' interpolates two matrices at a relative value - called in AlignToVector
Function InterpolateMatrix( m:TMatrix2,a:TMatrix2,alpha:Float )

	MatrixInterpolateMatrix( TMatrix2.GetInstance(m),TMatrix2.GetInstance(a),alpha )
	
End Function
