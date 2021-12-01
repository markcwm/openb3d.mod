' TQuaternion is Float (Minib3d) and TQuatPtr is Float Ptr (Openb3d)

Rem 
bbdoc: Quaternion functions (Minib3d)
End Rem
Type TQuaternion

	Field w#,x#,y#,z#
	
	Rem
	bbdoc: Create a new TQuaternion from four float values, returns a Float quaternion
	EndRem
	Function Create:TQuaternion( w:Float=0,x:Float=0,y:Float=0,z:Float=0 )
	
		Local new_quat:TQuaternion=New TQuaternion
		new_quat.w=w
		new_quat.x=x
		new_quat.y=y
		new_quat.z=z
		Return new_quat
		
	End Function
	
	Rem
	bbdoc: Copy the given TQuatPtr, returns a new Float quaternion (like GetQuatPtr)
	EndRem
	Function CopyQuatPtr:TQuaternion( quat:TQuatPtr )
	
		Local new_quat:TQuaternion=New TQuaternion
		new_quat.w=quat.w[0]
		new_quat.x=quat.x[0]
		new_quat.y=quat.y[0]
		new_quat.z=quat.z[0]
		Return new_quat
		
	End Function
	
	Rem
	bbdoc: Returns a new TQuaternion object
	EndRem
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog "New TQuaternion"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog "Del TQuaternion"
		EndIf
	
	End Method
	
	Rem
	bbdoc: Overwrite self with the given TQuatPtr, returns nothing (like CopyQuatPtr)
	EndRem
	Method GetQuatPtr:TQuaternion( quat:TQuatPtr )
	
		w=quat.w[0]
		x=quat.x[0]
		y=quat.y[0]
		z=quat.z[0]
		
	End Method
	
	Rem
	bbdoc: Convert a quaternion to the given TMatrix
	EndRem
	Function QuatToMat( w#,x#,y#,z#,mat:TMatrix Var )
	
		Local q:Float[4]
		q[0]=w
		q[1]=x
		q[2]=y
		q[3]=z
		
		Local xx#=q[1]*q[1]
		Local yy#=q[2]*q[2]
		Local zz#=q[3]*q[3]
		Local xy#=q[1]*q[2]
		Local xz#=q[1]*q[3]
		Local yz#=q[2]*q[3]
		Local wx#=q[0]*q[1]
		Local wy#=q[0]*q[2]
		Local wz#=q[0]*q[3]
	
		mat.grid[0,0]=1-2*(yy+zz)
		mat.grid[0,1]=  2*(xy-wz)
		mat.grid[0,2]=  2*(xz+wy)
		mat.grid[1,0]=  2*(xy+wz)
		mat.grid[1,1]=1-2*(xx+zz)
		mat.grid[1,2]=  2*(yz-wx)
		mat.grid[2,0]=  2*(xz-wy)
		mat.grid[2,1]=  2*(yz+wx)
		mat.grid[2,2]=1-2*(xx+yy)
		mat.grid[3,3]=1
	
		For Local iy:Int=0 To 3
			For Local ix:Int=0 To 3
				xx#=mat.grid[ix,iy]
				If xx#<0.0001 And xx#>-0.0001 Then xx#=0
				mat.grid[ix,iy]=xx#
			Next
		Next
	
	End Function
	
	Rem
	bbdoc: Convert a quaternion to the given pitch, yaw, roll (Euler degrees)
	EndRem
	Function QuatToEuler( w#,x#,y#,z#,pitch# Var,yaw# Var,roll# Var )
	
		Local q:Float[4]
		q[0]=w
		q[1]=x
		q[2]=y
		q[3]=z
		
		Local xx#=q[1]*q[1]
		Local yy#=q[2]*q[2]
		Local zz#=q[3]*q[3]
		Local xy#=q[1]*q[2]
		Local xz#=q[1]*q[3]
		Local yz#=q[2]*q[3]
		Local wx#=q[0]*q[1]
		Local wy#=q[0]*q[2]
		Local wz#=q[0]*q[3]
	
		Local mat:TMatrix=New TMatrix
		
		mat.grid[0,0]=1-2*(yy+zz)
		mat.grid[0,1]=  2*(xy-wz)
		mat.grid[0,2]=  2*(xz+wy)
		mat.grid[1,0]=  2*(xy+wz)
		mat.grid[1,1]=1-2*(xx+zz)
		mat.grid[1,2]=  2*(yz-wx)
		mat.grid[2,0]=  2*(xz-wy)
		mat.grid[2,1]=  2*(yz+wx)
		mat.grid[2,2]=1-2*(xx+yy)
		mat.grid[3,3]=1
	
		For Local iy:Int=0 To 3
			For Local ix:Int=0 To 3
				xx#=mat.grid[ix,iy]
				If xx#<0.0001 And xx#>-0.0001 Then xx#=0
				mat.grid[ix,iy]=xx#
			Next
		Next
	
		pitch#=ATan2( mat.grid[2,1],Sqr( mat.grid[2,0]*mat.grid[2,0]+mat.grid[2,2]*mat.grid[2,2] ) )
		yaw#=ATan2(mat.grid[2,0],mat.grid[2,2])
		roll#=ATan2(mat.grid[0,1],mat.grid[1,1])
				
		'If pitch#=nan# Then pitch#=0
		'If yaw#  =nan# Then yaw#  =0
		'If roll# =nan# Then roll# =0
	
	End Function
	
	Rem
	bbdoc: Slerp two quaternions to the given quaternion
	EndRem
	Function Slerp:Int( Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx# Var,Cy# Var,Cz# Var,Cw# Var,t# )
	
		If Abs(ax-bx)<0.001 And Abs(ay-by)<0.001 And Abs(az-bz)<0.001 And Abs(aw-bw)<0.001
			cx#=ax
			cy#=ay
			cz#=az
			cw#=aw
			Return True
		EndIf
		
		Local cosineom#=Ax#*Bx#+Ay#*By#+Az#*Bz#+Aw#*Bw#
		Local scaler_w#
		Local scaler_x#
		Local scaler_y#
		Local scaler_z#
		
		If cosineom# <= 0.0
			cosineom#=-cosineom#
			scaler_w#=-Bw#
			scaler_x#=-Bx#
			scaler_y#=-By#
			scaler_z#=-Bz#
		Else
			scaler_w#=Bw#
			scaler_x#=Bx#
			scaler_y#=By#
			scaler_z#=Bz#
		EndIf
		
		Local scale0#
		Local scale1#
		
		If (1.0 - cosineom#)>0.0001
			Local omega#=ACos(cosineom#)
			Local sineom#=Sin(omega#)
			scale0#=Sin((1.0-t#)*omega#)/sineom#
			scale1#=Sin(t#*omega#)/sineom#
		Else
			scale0#=1.0-t#
			scale1#=t#
		EndIf
			
		cw#=scale0#*Aw#+scale1#*scaler_w#
		cx#=scale0#*Ax#+scale1#*scaler_x#
		cy#=scale0#*Ay#+scale1#*scaler_y#
		cz#=scale0#*Az#+scale1#*scaler_z#
		
	End Function
		
End Type

Rem
bbdoc: QuatPtr functions (Openb3d)
End Rem
Type TQuatPtr

	Field w:Float Ptr, x:Float Ptr, y:Float Ptr, z:Float Ptr
	
	' wrapper
	?bmxng
	Global quatptr_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global quatptr_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TQuatPtr( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TQuatPtr=New TQuatPtr
		?bmxng
		quatptr_map.Insert( inst,obj )
		?Not bmxng
		quatptr_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		quatptr_map.Remove( inst )
		?Not bmxng
		quatptr_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TQuatPtr( inst:Byte Ptr )
	
		?bmxng
		Return TQuatPtr( quatptr_map.ValueForKey( inst ) )
		?Not bmxng
		Return TQuatPtr( quatptr_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TQuatPtr ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		w=QuatPtrFloat_( GetInstance(Self),QUATPTR_w )
		x=QuatPtrFloat_( GetInstance(Self),QUATPTR_x )
		y=QuatPtrFloat_( GetInstance(Self),QUATPTR_y )
		z=QuatPtrFloat_( GetInstance(Self),QUATPTR_z )
		
	End Method
	
	Rem
	bbdoc: Create a new TQuatPtr from four float values, returns a Float Ptr quaternion
	EndRem
	Function Create:TQuatPtr( w:Float=0,x:Float=0,y:Float=0,z:Float=0 )
	
		Local inst:Byte Ptr=NewQuatPtr_()
		Local new_quat:TQuatPtr=CreateObject(inst)
		new_quat.w[0]=w
		new_quat.x[0]=x
		new_quat.y[0]=y
		new_quat.z[0]=z
		Return new_quat
		
	End Function
	
	Rem
	bbdoc: Copy the given TQuaternion, returns a new Float Ptr quaternion (like GetQuaternion)
	EndRem
	Function CopyQuaternion:TQuatPtr( quat:TQuaternion )
	
		Local inst:Byte Ptr=NewQuatPtr_()
		Local new_quat:TQuatPtr=CreateObject(inst)
		new_quat.w[0]=quat.w
		new_quat.x[0]=quat.x
		new_quat.y[0]=quat.y
		new_quat.z[0]=quat.z
		Return new_quat
		
	End Function
	
	Rem
	bbdoc: Returns a new TQuatPtr object
	EndRem
	Function NewQuatPtr:TQuatPtr()
	
		Local inst:Byte Ptr=NewQuatPtr_()
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TQuatPtr"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TQuatPtr"
		EndIf
	
	End Method
	
	Rem
	bbdoc: Overwrite self with the given TQuaternion, returns nothing (like CopyQuaternion)
	EndRem
	Method GetQuaternion:TQuatPtr( quat:TQuaternion )
	
		w[0]=quat.w
		x[0]=quat.x
		y[0]=quat.y
		z[0]=quat.z
		
	End Method
	
	' Openb3d
	
	Rem
	bbdoc: Convert a quaternion to the given TMatPtr
	EndRem
	Function QuatToMat( w:Float,x:Float,y:Float,z:Float,mat:TMatPtr )
	
		QuaternionToMat_( w,x,y,z,TMatPtr.GetInstance(mat) )
		
	End Function
	
	Rem
	bbdoc: Convert a quaternion to the given pitch, yaw, roll (Euler degrees)
	EndRem
	Function QuatToEuler( w:Float,x:Float,y:Float,z:Float,pitch:Float Var,yaw:Float Var,roll:Float Var )
	
		QuaternionToEuler_( w,x,y,z,Varptr pitch,Varptr yaw,Varptr roll )
		
	End Function
	
	Rem
	bbdoc: Slerp two quaternions to the given quaternion
	EndRem
	Function Slerp:Int( Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx:Float Var,Cy:Float Var,Cz:Float Var,Cw:Float Var,t# )
	
		QuaternionSlerp_( Ax,Ay,Az,Aw,Bx,By,Bz,Bw,Varptr Cx,Varptr Cy,Varptr Cz,Varptr Cw,t )
		
	End Function
		
End Type
