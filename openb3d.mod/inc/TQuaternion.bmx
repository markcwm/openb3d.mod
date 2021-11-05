' TQuaternion is Float (Minib3d) and TQuatPtr is Float Ptr (Openb3d)

Rem
bbdoc: Quaternion functions (Minib3d)
End Rem
Type TQuaternion

	Field w#,x#,y#,z#
	
	Rem
	bbdoc: Create a new TQuaternion object, returns a new Float quaternion
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
	bbdoc: Convert Quaternion to Matrix
	EndRem
	Function QuatToMat(w#,x#,y#,z#,mat:TMatrix Var)
	
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
	bbdoc: Convert Quaternion to Euler
	EndRem
	Function QuatToEuler(w#,x#,y#,z#,pitch# Var,yaw# Var,roll# Var)
	
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
	bbdoc: Slerp two quaternions
	EndRem
	Function Slerp:Int(Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx# Var,Cy# Var,Cz# Var,Cw# Var,t#)
	
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

	Field x:Float Ptr, y:Float Ptr, z:Float Ptr, w:Float Ptr
	
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
	
		x=QuatPtrFloat_( GetInstance(Self),QUATPTR_x )
		y=QuatPtrFloat_( GetInstance(Self),QUATPTR_y )
		z=QuatPtrFloat_( GetInstance(Self),QUATPTR_z )
		w=QuatPtrFloat_( GetInstance(Self),QUATPTR_w )
		
	End Method
	
	Rem
	bbdoc: Create a new TQuatPtr object, returns a new Float Ptr quaternion
	EndRem
	Function NewQuatPtr:TQuatPtr()
	
		Local inst:Byte Ptr=NewQuatPtr_()
		Return CreateObject(inst)
		
	End Function
	
	Rem
	bbdoc: Create a new TQuatPtr from four float values, returns a new Float Ptr quaternion
	EndRem
	Function Create:TQuatPtr( x:Float=0,y:Float=0,z:Float=0,w:Float=0 )
	
		Local inst:Byte Ptr=NewQuatPtr_()
		Local new_quat:TQuatPtr=CreateObject(inst)
		new_quat.x[0]=x
		new_quat.y[0]=y
		new_quat.z[0]=z
		new_quat.w[0]=w
		Return new_quat
		
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
	bbdoc: Convert Quaternion to Euler (alternative version)
	EndRem
	Function QuatToEuler2( w:Float,x:Float,y:Float,z:Float,pitch:Float Var,yaw:Float Var,roll:Float Var )
	
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
	
		Local mat:TMatPtr=TMatPtr.Create()
		
		mat.grid[(4*0)+0]=1-2*(yy+zz)
		mat.grid[(4*0)+1]=  2*(xy-wz)
		mat.grid[(4*0)+2]=  2*(xz+wy)
		mat.grid[(4*1)+0]=  2*(xy+wz)
		mat.grid[(4*1)+1]=1-2*(xx+zz)
		mat.grid[(4*1)+2]=  2*(yz-wx)
		mat.grid[(4*2)+0]=  2*(xz-wy)
		mat.grid[(4*2)+1]=  2*(yz+wx)
		mat.grid[(4*2)+2]=1-2*(xx+yy)
		mat.grid[(4*3)+3]=1
	
		For Local iy:Int=0 To 3
			For Local ix:Int=0 To 3
				xx#=mat.grid[(4*ix)+iy]
				If xx#<0.0001 And xx#>-0.0001 Then xx#=0
				mat.grid[(4*ix)+iy]=xx#
			Next
		Next
	
		pitch#=ATan2( mat.grid[(4*2)+1],Sqr( mat.grid[(4*2)+0]*mat.grid[(4*2)+0]+mat.grid[(4*2)+2]*mat.grid[(4*2)+2] ) )
		yaw#=ATan2(mat.grid[(4*2)+0],mat.grid[(4*2)+2])
		roll#=ATan2(mat.grid[(4*0)+1],mat.grid[(4*1)+1])
				
		'If pitch#=nan# Then pitch#=0
		'If yaw#  =nan# Then yaw#  =0
		'If roll# =nan# Then roll# =0
		
	End Function
	
	Rem
	bbdoc: Slerp two quaternions (alternative version)
	EndRem
	Function Slerp2:Int( Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx:Float Var,Cy:Float Var,Cz:Float Var,Cw:Float Var,t# )
	
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
	
	' Openb3d
	
	Rem
	bbdoc: Convert Quaternion to Matrix
	EndRem
	Function QuatToMat( w:Float,x:Float,y:Float,z:Float,mat:TMatPtr )
	
		QuaternionToMat_( w,x,y,z,TMatPtr.GetInstance(mat) )
		
	End Function
	
	Rem
	bbdoc: Convert Quaternion to Euler
	EndRem
	Function QuatToEuler( w:Float,x:Float,y:Float,z:Float,pitch:Float Var,yaw:Float Var,roll:Float Var )
	
		QuaternionToEuler_( w,x,y,z,Varptr pitch,Varptr yaw,Varptr roll )
		
	End Function
	
	Rem
	bbdoc: Slerp two quaternions
	EndRem
	Function Slerp:Int( Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx:Float Var,Cy:Float Var,Cz:Float Var,Cw:Float Var,t# )
	
		QuaternionSlerp_( Ax,Ay,Az,Aw,Bx,By,Bz,Bw,Varptr Cx,Varptr Cy,Varptr Cz,Varptr Cw,t )
		
	End Function
		
End Type
