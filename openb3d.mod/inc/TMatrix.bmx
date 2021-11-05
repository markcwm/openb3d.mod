' TMatrix is 4x4 Float (Minib3d) and TMatPtr is Float Ptr (Openb3d)

Rem
bbdoc: Matrix functions (Minib3d)
End Rem
Type TMatrix

	Field grid#[4,4]
	
	Rem
	bbdoc: Create a new TMatrix object, returns a new 4x4 Float matrix
	EndRem
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog "New TMatrix"
		EndIf

	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog "Del TMatrix"
		EndIf

	End Method
	
	Rem
	bbdoc: Convert into identity matrix
	EndRem
	Method LoadIdentity()
	
		grid[0,0]=1.0
		grid[1,0]=0.0
		grid[2,0]=0.0
		grid[3,0]=0.0
		grid[0,1]=0.0
		grid[1,1]=1.0
		grid[2,1]=0.0
		grid[3,1]=0.0
		grid[0,2]=0.0
		grid[1,2]=0.0
		grid[2,2]=1.0
		grid[3,2]=0.0
		
		grid[0,3]=0.0
		grid[1,3]=0.0
		grid[2,3]=0.0
		grid[3,3]=1.0
	
	End Method
	
	Rem
	bbdoc: Create new copy and returns it
	EndRem
	Method Copy:TMatrix()
	
		Local mat:TMatrix=New TMatrix
	
		mat.grid[0,0]=grid[0,0]
		mat.grid[1,0]=grid[1,0]
		mat.grid[2,0]=grid[2,0]
		mat.grid[3,0]=grid[3,0]
		mat.grid[0,1]=grid[0,1]
		mat.grid[1,1]=grid[1,1]
		mat.grid[2,1]=grid[2,1]
		mat.grid[3,1]=grid[3,1]
		mat.grid[0,2]=grid[0,2]
		mat.grid[1,2]=grid[1,2]
		mat.grid[2,2]=grid[2,2]
		mat.grid[3,2]=grid[3,2]
		
		' do not remove
		mat.grid[0,3]=grid[0,3]
		mat.grid[1,3]=grid[1,3]
		mat.grid[2,3]=grid[2,3]
		mat.grid[3,3]=grid[3,3]
		
		Return mat
	
	End Method
	
	Rem
	bbdoc: Overwrites self with matrix passed as parameter
	EndRem
	Method Overwrite(mat:TMatrix)
	
		grid[0,0]=mat.grid[0,0]
		grid[1,0]=mat.grid[1,0]
		grid[2,0]=mat.grid[2,0]
		grid[3,0]=mat.grid[3,0]
		grid[0,1]=mat.grid[0,1]
		grid[1,1]=mat.grid[1,1]
		grid[2,1]=mat.grid[2,1]
		grid[3,1]=mat.grid[3,1]
		grid[0,2]=mat.grid[0,2]
		grid[1,2]=mat.grid[1,2]
		grid[2,2]=mat.grid[2,2]
		grid[3,2]=mat.grid[3,2]
		
		grid[0,3]=mat.grid[0,3]
		grid[1,3]=mat.grid[1,3]
		grid[2,3]=mat.grid[2,3]
		grid[3,3]=mat.grid[3,3]
		
	End Method
	
	Rem
	bbdoc: Returns the inverse of a matrix
	EndRem
	Method Inverse:TMatrix()

		Local mat:TMatrix=New TMatrix
	
		Local tx#=0
		Local ty#=0
		Local tz#=0
	
	  	' The rotational part of the matrix is simply the transpose of the
	  	' original matrix.
	  	mat.grid[0,0] = grid[0,0]
	  	mat.grid[1,0] = grid[0,1]
	  	mat.grid[2,0] = grid[0,2]
	
		mat.grid[0,1] = grid[1,0]
		mat.grid[1,1] = grid[1,1]
		mat.grid[2,1] = grid[1,2]
	
		mat.grid[0,2] = grid[2,0]
		mat.grid[1,2] = grid[2,1]
		mat.grid[2,2] = grid[2,2]
	
		' The right column vector of the matrix should always be [ 0 0 0 1 ]
		' in most cases. . . you don't need this column at all because it'll 
		' never be used in the program, but since this code is used with GL
		' and it does consider this column, it is here.
		mat.grid[0,3] = 0 
		mat.grid[1,3] = 0
		mat.grid[2,3] = 0
		mat.grid[3,3] = 1
	
		' The translation components of the original matrix.
		tx = grid[3,0]
		ty = grid[3,1]
		tz = grid[3,2]
	
		' Result = -(Tm * Rm) To get the translation part of the inverse
		mat.grid[3,0] = -( (grid[0,0] * tx) + (grid[0,1] * ty) + (grid[0,2] * tz) )
		mat.grid[3,1] = -( (grid[1,0] * tx) + (grid[1,1] * ty) + (grid[1,2] * tz) )
		mat.grid[3,2] = -( (grid[2,0] * tx) + (grid[2,1] * ty) + (grid[2,2] * tz) )
	
		Return mat

	End Method
	
	Rem
	bbdoc: Multiply matrix with the given matrix
	EndRem
	Method Multiply(mat:TMatrix)
	
		Local m00# = grid#[0,0]*mat.grid#[0,0] + grid#[1,0]*mat.grid#[0,1] + grid#[2,0]*mat.grid#[0,2] + grid#[3,0]*mat.grid#[0,3]
		Local m01# = grid#[0,1]*mat.grid#[0,0] + grid#[1,1]*mat.grid#[0,1] + grid#[2,1]*mat.grid#[0,2] + grid#[3,1]*mat.grid#[0,3]
		Local m02# = grid#[0,2]*mat.grid#[0,0] + grid#[1,2]*mat.grid#[0,1] + grid#[2,2]*mat.grid#[0,2] + grid#[3,2]*mat.grid#[0,3]
		'Local m03# = grid#[0,3]*mat.grid#[0,0] + grid#[1,3]*mat.grid#[0,1] + grid#[2,3]*mat.grid#[0,2] + grid#[3,3]*mat.grid#[0,3]
		Local m10# = grid#[0,0]*mat.grid#[1,0] + grid#[1,0]*mat.grid#[1,1] + grid#[2,0]*mat.grid#[1,2] + grid#[3,0]*mat.grid#[1,3]
		Local m11# = grid#[0,1]*mat.grid#[1,0] + grid#[1,1]*mat.grid#[1,1] + grid#[2,1]*mat.grid#[1,2] + grid#[3,1]*mat.grid#[1,3]
		Local m12# = grid#[0,2]*mat.grid#[1,0] + grid#[1,2]*mat.grid#[1,1] + grid#[2,2]*mat.grid#[1,2] + grid#[3,2]*mat.grid#[1,3]
		'Local m13# = grid#[0,3]*mat.grid#[1,0] + grid#[1,3]*mat.grid#[1,1] + grid#[2,3]*mat.grid#[1,2] + grid#[3,3]*mat.grid#[1,3]
		Local m20# = grid#[0,0]*mat.grid#[2,0] + grid#[1,0]*mat.grid#[2,1] + grid#[2,0]*mat.grid#[2,2] + grid#[3,0]*mat.grid#[2,3]
		Local m21# = grid#[0,1]*mat.grid#[2,0] + grid#[1,1]*mat.grid#[2,1] + grid#[2,1]*mat.grid#[2,2] + grid#[3,1]*mat.grid#[2,3]
		Local m22# = grid#[0,2]*mat.grid#[2,0] + grid#[1,2]*mat.grid#[2,1] + grid#[2,2]*mat.grid#[2,2] + grid#[3,2]*mat.grid#[2,3]
		'Local m23# = grid#[0,3]*mat.grid#[2,0] + grid#[1,3]*mat.grid#[2,1] + grid#[2,3]*mat.grid#[2,2] + grid#[3,3]*mat.grid#[2,3]
		Local m30# = grid#[0,0]*mat.grid#[3,0] + grid#[1,0]*mat.grid#[3,1] + grid#[2,0]*mat.grid#[3,2] + grid#[3,0]*mat.grid#[3,3]
		Local m31# = grid#[0,1]*mat.grid#[3,0] + grid#[1,1]*mat.grid#[3,1] + grid#[2,1]*mat.grid#[3,2] + grid#[3,1]*mat.grid#[3,3]
		Local m32# = grid#[0,2]*mat.grid#[3,0] + grid#[1,2]*mat.grid#[3,1] + grid#[2,2]*mat.grid#[3,2] + grid#[3,2]*mat.grid#[3,3]
		'Local m33# = grid#[0,3]*mat.grid#[3,0] + grid#[1,3]*mat.grid#[3,1] + grid#[2,3]*mat.grid#[3,2] + grid#[3,3]*mat.grid#[3,3]
	
		grid[0,0]=m00
		grid[0,1]=m01
		grid[0,2]=m02
		'grid[0,3]=m03
		grid[1,0]=m10
		grid[1,1]=m11
		grid[1,2]=m12
		'grid[1,3]=m13
		grid[2,0]=m20
		grid[2,1]=m21
		grid[2,2]=m22
		'grid[2,3]=m23
		grid[3,0]=m30
		grid[3,1]=m31
		grid[3,2]=m32
		'grid[3,3]=m33
		
	End Method
	
	Rem
	bbdoc: Translate (move) matrix
	EndRem
	Method Translate(x#,y#,z#)
	
		grid[3,0] = grid#[0,0]*x# + grid#[1,0]*y# + grid#[2,0]*z# + grid#[3,0]
		grid[3,1] = grid#[0,1]*x# + grid#[1,1]*y# + grid#[2,1]*z# + grid#[3,1]
		grid[3,2] = grid#[0,2]*x# + grid#[1,2]*y# + grid#[2,2]*z# + grid#[3,2]

	End Method
	
	Rem
	bbdoc: Scale matrix (set the diagonal elements to x, y, z)
	EndRem
	Method Scale(x#,y#,z#)
	
		grid[0,0] = grid#[0,0]*x#
		grid[0,1] = grid#[0,1]*x#
		grid[0,2] = grid#[0,2]*x#

		grid[1,0] = grid#[1,0]*y#
		grid[1,1] = grid#[1,1]*y#
		grid[1,2] = grid#[1,2]*y#

		grid[2,0] = grid#[2,0]*z#
		grid[2,1] = grid#[2,1]*z#
		grid[2,2] = grid#[2,2]*z# 
	
	End Method
	
	Rem
	bbdoc: Rotate matrix (Euler degrees)
	EndRem
	Method Rotate(rx#,ry#,rz#)
	
		Local cos_ang#,sin_ang#
	
		' yaw
	
		cos_ang#=Cos(ry#)
		sin_ang#=Sin(ry#)
	
		Local m00# = grid#[0,0]*cos_ang + grid#[2,0]*-sin_ang#
		Local m01# = grid#[0,1]*cos_ang + grid#[2,1]*-sin_ang#
		Local m02# = grid#[0,2]*cos_ang + grid#[2,2]*-sin_ang#

		grid[2,0] = grid#[0,0]*sin_ang# + grid#[2,0]*cos_ang
		grid[2,1] = grid#[0,1]*sin_ang# + grid#[2,1]*cos_ang
		grid[2,2] = grid#[0,2]*sin_ang# + grid#[2,2]*cos_ang

		grid[0,0]=m00#
		grid[0,1]=m01#
		grid[0,2]=m02#
		
		' pitch
		
		cos_ang#=Cos(rx#)
		sin_ang#=Sin(rx#)
	
		Local m10# = grid#[1,0]*cos_ang + grid#[2,0]*sin_ang
		Local m11# = grid#[1,1]*cos_ang + grid#[2,1]*sin_ang
		Local m12# = grid#[1,2]*cos_ang + grid#[2,2]*sin_ang

		grid[2,0] = grid#[1,0]*-sin_ang + grid#[2,0]*cos_ang
		grid[2,1] = grid#[1,1]*-sin_ang + grid#[2,1]*cos_ang
		grid[2,2] = grid#[1,2]*-sin_ang + grid#[2,2]*cos_ang

		grid[1,0]=m10
		grid[1,1]=m11
		grid[1,2]=m12
		
		' roll
		
		cos_ang#=Cos(rz#)
		sin_ang#=Sin(rz#)

		m00# = grid#[0,0]*cos_ang# + grid#[1,0]*sin_ang#
		m01# = grid#[0,1]*cos_ang# + grid#[1,1]*sin_ang#
		m02# = grid#[0,2]*cos_ang# + grid#[1,2]*sin_ang#

		grid[1,0] = grid#[0,0]*-sin_ang# + grid#[1,0]*cos_ang#
		grid[1,1] = grid#[0,1]*-sin_ang# + grid#[1,1]*cos_ang#
		grid[1,2] = grid#[0,2]*-sin_ang# + grid#[1,2]*cos_ang#

		grid[0,0]=m00#
		grid[0,1]=m01#
		grid[0,2]=m02#
	
	End Method
	
	Rem
	bbdoc: Rotate matrix about the x axis (Euler degrees)
	EndRem
	Method RotatePitch(ang#)
	
		Local cos_ang#=Cos(ang#)
		Local sin_ang#=Sin(ang#)
	
		Local m10# = grid#[1,0]*cos_ang + grid#[2,0]*sin_ang
		Local m11# = grid#[1,1]*cos_ang + grid#[2,1]*sin_ang
		Local m12# = grid#[1,2]*cos_ang + grid#[2,2]*sin_ang

		grid[2,0] = grid#[1,0]*-sin_ang + grid#[2,0]*cos_ang
		grid[2,1] = grid#[1,1]*-sin_ang + grid#[2,1]*cos_ang
		grid[2,2] = grid#[1,2]*-sin_ang + grid#[2,2]*cos_ang

		grid[1,0]=m10
		grid[1,1]=m11
		grid[1,2]=m12

	End Method
	
	Rem
	bbdoc: Rotate matrix about the y axis (Euler degrees)
	EndRem
	Method RotateYaw(ang#)
	
		Local cos_ang#=Cos(ang#)
		Local sin_ang#=Sin(ang#)
	
		Local m00# = grid#[0,0]*cos_ang + grid#[2,0]*-sin_ang#
		Local m01# = grid#[0,1]*cos_ang + grid#[2,1]*-sin_ang#
		Local m02# = grid#[0,2]*cos_ang + grid#[2,2]*-sin_ang#

		grid[2,0] = grid#[0,0]*sin_ang# + grid#[2,0]*cos_ang
		grid[2,1] = grid#[0,1]*sin_ang# + grid#[2,1]*cos_ang
		grid[2,2] = grid#[0,2]*sin_ang# + grid#[2,2]*cos_ang

		grid[0,0]=m00#
		grid[0,1]=m01#
		grid[0,2]=m02#

	End Method
	
	Rem
	bbdoc: Rotate matrix about the z axis (Euler degrees)
	EndRem
	Method RotateRoll(ang#)
	
		Local cos_ang#=Cos(ang#)
		Local sin_ang#=Sin(ang#)

		Local m00# = grid#[0,0]*cos_ang# + grid#[1,0]*sin_ang#
		Local m01# = grid#[0,1]*cos_ang# + grid#[1,1]*sin_ang#
		Local m02# = grid#[0,2]*cos_ang# + grid#[1,2]*sin_ang#

		grid[1,0] = grid#[0,0]*-sin_ang# + grid#[1,0]*cos_ang#
		grid[1,1] = grid#[0,1]*-sin_ang# + grid#[1,1]*cos_ang#
		grid[1,2] = grid#[0,2]*-sin_ang# + grid#[1,2]*cos_ang#

		grid[0,0]=m00#
		grid[0,1]=m01#
		grid[0,2]=m02#

	End Method
		
End Type

Rem
bbdoc: MatPtr functions (Openb3d)
End Rem
Type TMatPtr

	Field grid:Float Ptr ' array [4,4] - LoadIdentity
	
	' wrapper
	?bmxng
	Global matptr_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global matptr_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TMatPtr( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TMatPtr=New TMatPtr
		?bmxng
		matptr_map.Insert( inst,obj )
		?Not bmxng
		matptr_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		matptr_map.Remove( inst )
		?Not bmxng
		matptr_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TMatPtr( inst:Byte Ptr )
	
		?bmxng
		Return TMatPtr( matptr_map.ValueForKey( inst ) )
		?Not bmxng
		Return TMatPtr( matptr_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TMatPtr ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' float
		grid=MatPtrFloat_( GetInstance(Self),MATPTR_grid )
		
	End Method
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" Matrix instance: "+StringPtr(GetInstance(Self))
		
		' float
		DebugLog pad+" grid[0,0] = "+grid[0]+" [0,1] = "+grid[1]+" [0,2] = "+grid[2]+" [0,3] = "+grid[3]
		DebugLog pad+" grid[1,0] = "+grid[4]+" [1,1] = "+grid[5]+" [1,2] = "+grid[6]+" [1,3] = "+grid[7]
		DebugLog pad+" grid[2,0] = "+grid[8]+" [2,1] = "+grid[9]+" [2,2] = "+grid[10]+" [2,3] = "+grid[11]
		DebugLog pad+" grid[3,0] = "+grid[12]+" [3,1] = "+grid[13]+" [3,2] = "+grid[14]+" [3,3] = "+grid[15]
		
		DebugLog ""
		
	End Method
	
	Rem
	bbdoc: Create a new TMatPtr object, returns a new Float Ptr matrix
	EndRem
	Function NewMatPtr:TMatPtr()
	
		Local inst:Byte Ptr=NewMatPtr_() ' calls LoadIdentity
		Return CreateObject(inst)
		
	End Function
	
	Rem
	bbdoc: Create a new TMatPtr object, returns a new Float Ptr matrix
	EndRem
	Function Create:TMatPtr()
	
		Local inst:Byte Ptr=NewMatPtr_()
		Return CreateObject(inst)
		
	End Function
	
	' Extra
	
	Rem
	bbdoc: Set matrix identity (3x3 Float)
	EndRem
	Method SetIdentity( xx#,xy#,xz#,yx#,yy#,yz#,zx#,zy#,zz# )
	
		grid[(4*0)+0] = xx
		grid[(4*0)+1] = xy
		grid[(4*0)+2] = xz
		grid[(4*0)+3] = 0
		
		grid[(4*1)+0] = yx
		grid[(4*1)+1] = yy
		grid[(4*1)+2] = yz
		grid[(4*1)+3] = 0
		
		grid[(4*2)+0] = zx
		grid[(4*2)+1] = zy
		grid[(4*2)+2] = zz
		grid[(4*2)+3] = 0
		
		grid[(4*3)+0] = 0
		grid[(4*3)+1] = 0
		grid[(4*3)+2] = 0
		grid[(4*3)+3] = 1
		
	End Method
	
	' Warner
	
	Rem
	bbdoc: Get scale (magnitude) of a matrix, returns a new vector
	EndRem
	Method GetMatrixScale:TVecPtr()
	
		Local s:TVecPtr=TVecPtr.Create()
		s.x[0] = TVecPtr.Magnitude(grid[(4*0)+0], grid[(4*0)+1], grid[(4*0)+2])
		s.y[0] = TVecPtr.Magnitude(grid[(4*1)+0], grid[(4*1)+1], grid[(4*1)+2])
		s.z[0] = TVecPtr.Magnitude(grid[(4*2)+0], grid[(4*2)+1], grid[(4*2)+2])
		Return s
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TMatPtr"
		EndIf
		
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TMatPtr"
		EndIf

	End Method
	
	Rem
	bbdoc: Convert into identity matrix
	EndRem
	Method LoadIdentity()
	
		MatrixLoadIdentity_( GetInstance(Self) )
		
	End Method
	
	Rem
	bbdoc: Create new copy and returns it
	EndRem
	Method Copy:TMatPtr()
	
		Local inst:Byte Ptr=MatrixCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
	Rem
	bbdoc: Overwrites self with matrix passed as parameter
	EndRem
	Method Overwrite( mat:TMatPtr )
	
		MatrixOverwrite_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	
	Rem
	bbdoc: Returns an inverse transformation
	EndRem
	Method GetInverse:TMatPtr( mat:TMatPtr )
	
		Local inst:Byte Ptr=MatrixGetInverse_( GetInstance(Self),GetInstance(mat) )	
		Return GetObject(inst) ' no CreateObject
		
	End Method
	
	' from minib3d
	
	Rem
	bbdoc: Returns the inverse of a matrix
	EndRem
	Method Inverse:TMatPtr()
	
		Local mat:TMatPtr=Create()
		Local tx#=0, ty#=0, tz#=0
		
	  	' The rotational part of the matrix is simply the transpose of the original matrix.
	  	mat.grid[(4*0)+0] = grid[(4*0)+0]
	  	mat.grid[(4*1)+0] = grid[(4*0)+1]
	  	mat.grid[(4*2)+0] = grid[(4*0)+2]
		mat.grid[(4*0)+1] = grid[(4*1)+0]
		mat.grid[(4*1)+1] = grid[(4*1)+1]
		mat.grid[(4*2)+1] = grid[(4*1)+2]
		mat.grid[(4*0)+2] = grid[(4*2)+0]
		mat.grid[(4*1)+2] = grid[(4*2)+1]
		mat.grid[(4*2)+2] = grid[(4*2)+2]
		
		' The right column vector of the matrix should always be [ 0 0 0 1 ]
		' in most cases. . . you don't need this column at all because it'll 
		' never be used in the program, but since this code is used with GL
		' and it does consider this column, it is here.
		mat.grid[(4*0)+3] = 0 
		mat.grid[(4*1)+3] = 0
		mat.grid[(4*2)+3] = 0
		mat.grid[(4*3)+3] = 1
		
		' The translation components of the original matrix.
		tx = grid[(4*3)+0]
		ty = grid[(4*3)+1]
		tz = grid[(4*3)+2]
		
		' Result = -(Tm * Rm) To get the translation part of the inverse
		mat.grid[(4*3)+0] = -( (grid[(4*0)+0] * tx) + (grid[(4*0)+1] * ty) + (grid[(4*0)+2] * tz) )
		mat.grid[(4*3)+1] = -( (grid[(4*1)+0] * tx) + (grid[(4*1)+1] * ty) + (grid[(4*1)+2] * tz) )
		mat.grid[(4*3)+2] = -( (grid[(4*2)+0] * tx) + (grid[(4*2)+1] * ty) + (grid[(4*2)+2] * tz) )
		
		Return mat
		
	End Method
	
	Rem
	bbdoc: Multiply matrix with the given matrix
	EndRem
	Method Multiply( mat:TMatPtr )
	
		MatrixMultiply_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	Rem
	bbdoc: Translate (move) matrix
	EndRem
	Method Translate( x:Float,y:Float,z:Float )
	
		MatrixTranslate_( GetInstance(Self),x,y,z )
		
	End Method
	
	Rem
	bbdoc: Scale matrix (set the diagonal elements to x, y, z)
	EndRem
	Method Scale( x:Float,y:Float,z:Float )
	
		MatrixScale_( GetInstance(Self),x,y,z )
		
	End Method
	
	Rem
	bbdoc: Rotate matrix (Euler degrees)
	EndRem
	Method Rotate( rx:Float,ry:Float,rz:Float )
	
		MatrixRotate_( GetInstance(Self),rx,ry,rz )
		
	End Method
	
	Rem
	bbdoc: Rotate matrix about the x axis (Euler degrees)
	EndRem
	Method RotatePitch( ang:Float )
	
		MatrixRotatePitch_( GetInstance(Self),ang )
		
	End Method
	
	Rem
	bbdoc: Rotate matrix about the y axis (Euler degrees)
	EndRem
	Method RotateYaw( ang:Float )
	
		MatrixRotateYaw_( GetInstance(Self),ang )
		
	End Method
	
	Rem
	bbdoc: Rotate matrix about the z axis (Euler degrees)
	EndRem
	Method RotateRoll( ang:Float )
	
		MatrixRotateRoll_( GetInstance(Self),ang )
		
	End Method
	
	' Openb3d
	
	Rem
	bbdoc: Converts a quaternion to a rotation matrix
	EndRem
	Method FromQuaternion( x:Float,y:Float,z:Float,w:Float )
	
		MatrixFromQuaternion_( GetInstance(Self),x,y,z,w )
		
	End Method
	
	Rem
	bbdoc: Transforms the given vector by this matrix
	EndRem
	Method TransformVec( rx:Float Var,ry:Float Var,rz:Float Var,addTranslation:Int=0 )
	
		MatrixTransformVec_( GetInstance(Self),Varptr rx,Varptr ry,Varptr rz,addTranslation )
		
	End Method
	
	Rem
	bbdoc: Transpose matrix
	EndRem
	Method Transpose()
	
		MatrixTranspose_( GetInstance(Self) )
		
	End Method
	
	Rem
	bbdoc: Set the matrix to translate
	EndRem
	Method SetTranslate( x:Float,y:Float,z:Float )
	
		MatrixSetTranslate_( GetInstance(Self),x,y,z )
		
	End Method
	
	Rem
	bbdoc: Multiply matrix with the given matrix
	EndRem
	Method Multiply2( mat:TMatPtr )
	
		MatrixMultiply2_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	Rem
	bbdoc: Inverse transformation on the given matrix
	EndRem
	Method GetInverse2( mat:TMatPtr )
	
		MatrixGetInverse2_( GetInstance(Self),GetInstance(mat) )
		
	End Method
	
	Rem
	bbdoc: Returns x rotation of matrix
	EndRem
	Method GetPitch:Float()
	
		Return MatrixGetPitch_( GetInstance(Self) )
		
	End Method
	
	Rem
	bbdoc: Returns y rotation of matrix
	EndRem
	Method GetYaw:Float()
	
		Return MatrixGetYaw_( GetInstance(Self) )
		
	End Method
	
	Rem
	bbdoc: Returns z rotation of matrix
	EndRem
	Method GetRoll:Float()
	
		Return MatrixGetRoll_( GetInstance(Self) )
		
	End Method
		
	Rem
	bbdoc: Creates a transformation matrix that rotates a vector to another
	EndRem
	Method FromToRotation( ix:Float,iy:Float,iz:Float,jx:Float,jy:Float,jz:Float )
	
		MatrixFromToRotation_( GetInstance(Self),ix,iy,iz,jx,jy,jz )
		
	End Method
	
	Rem
	bbdoc: Convert matrix to quaternion
	EndRem
	Method ToQuat( qx:Float Var,qy:Float Var,qz:Float Var,qw:Float Var )
	
		MatrixToQuat_( GetInstance(Self),Varptr qx,Varptr qy,Varptr qz,Varptr qw )
		
	End Method
	
	
	Rem
	bbdoc: Return magnitude (length) of vector
	EndRem
	Function Magnitude:Float( x:Float,y:Float,z:Float )
	
		Return Sqr( x*x + y*y + z*z )
		
	End Function
	
	Rem
	bbdoc: Creates a quaternion from an angle and an axis
	EndRem
	Function Quaternion_FromAngleAxis( angle:Float,ax:Float,ay:Float,az:Float,rx:Float Var,ry:Float Var,rz:Float Var,rw:Float Var )
	
		MatrixQuaternion_FromAngleAxis_( angle,ax,ay,az,Varptr rx,Varptr ry,Varptr rz,Varptr rw )
		
	End Function
	
	Rem
	bbdoc: Multiplies a quaternion
	EndRem
	Function Quaternion_MultiplyQuat( x1:Float,y1:Float,z1:Float,w1:Float,x2:Float,y2:Float,z2:Float,w2:Float,rx:Float Var,ry:Float Var,rz:Float Var,rw:Float Var )
	
		MatrixQuaternion_MultiplyQuat_( x1,y1,z1,w1,x2,y2,z2,w2,Varptr rx,Varptr ry,Varptr rz,Varptr rw )
			
	End Function
	
	Rem
	bbdoc: Interpolates two matrices at a relative value - called in AlignToVector
	EndRem
	Function InterpolateMatrix( m:TMatPtr,a:TMatPtr,alpha:Float )
	
		MatrixInterpolateMatrix_( TMatPtr.GetInstance(m),TMatPtr.GetInstance(a),alpha )
		
	End Function
	
End Type
