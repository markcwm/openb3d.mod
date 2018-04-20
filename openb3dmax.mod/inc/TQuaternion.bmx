
Rem
bbdoc: Quaternion functions
End Rem
Type TQuaternion

	Field x:Float Ptr, y:Float Ptr, z:Float Ptr, w:Float Ptr
	
	' wrapper
	?bmxng
	Global quaternion_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global quaternion_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TQuaternion( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TQuaternion=New TQuaternion
		?bmxng
		quaternion_map.Insert( inst,obj )
		?Not bmxng
		quaternion_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		quaternion_map.Remove( inst )
		?Not bmxng
		quaternion_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TQuaternion( inst:Byte Ptr )
	
		?bmxng
		Return TQuaternion( quaternion_map.ValueForKey( inst ) )
		?Not bmxng
		Return TQuaternion( quaternion_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TQuaternion ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		x=QuaternionFloat_( GetInstance(Self),QUATERNION_x )
		y=QuaternionFloat_( GetInstance(Self),QUATERNION_y )
		z=QuaternionFloat_( GetInstance(Self),QUATERNION_z )
		w=QuaternionFloat_( GetInstance(Self),QUATERNION_w )
		
	End Method
	
	Function NewQuaternion:TQuaternion()
	
		Local inst:Byte Ptr=NewQuaternion_()
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal.Log_New
			DebugLog "New TQuaternion"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal.Log_Del
			DebugLog "Del TQuaternion"
		EndIf
	
	End Method

	Function QuatToMat( w:Float,x:Float,y:Float,z:Float,mat:TMatrix )
	
		QuaternionToMat_( w,x,y,z,TMatrix.GetInstance(mat) )
		
	End Function
	
	Function QuatToEuler( w:Float,x:Float,y:Float,z:Float,pitch:Float Var,yaw:Float Var,roll:Float Var )
	
		QuaternionToEuler_( w,x,y,z,Varptr pitch,Varptr yaw,Varptr roll )
		
		Rem
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
		EndRem
	End Function
	
	Function Slerp:Int( Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx:Float Var,Cy:Float Var,Cz:Float Var,Cw:Float Var,t# )
	
		QuaternionSlerp_( Ax,Ay,Az,Aw,Bx,By,Bz,Bw,Varptr Cx,Varptr Cy,Varptr Cz,Varptr Cw,t )
		
		Rem
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
		EndRem
	End Function
		
End Type
