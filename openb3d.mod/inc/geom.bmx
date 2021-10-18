' geom.bmx
' Geometry maths functions from Minib3d Extended (by klepto2)

Function Vec2:TVec2(x#=0.0,y#=0.0/0.0)
	Local t:TVec2=New TVec2
	If IsNan(y) y=x
	t.x=x
	t.y=y
	Return t
EndFunction

Function Vec3:TVec3( x#=0.0,y#=0.0/0.0,z#=0.0/0.0 )
	Local t:TVec3=New TVec3
	If IsNan(y) y=x
	If IsNan(z) z=y
	t.x=x
	t.y=y
	t.z=z
	Return t
EndFunction

Function Vec4:TVec4( x#=0.0,y#=0.0/0.0,z#=0.0/0.0,w#=0.0/0.0 )
	Local t:TVec4=New TVec4
	If IsNan(y) y=x
	If IsNan(z) z=y
	If IsNan(w) w=z
	t.x=x
	t.y=y
	t.z=z
	t.w=w
	Return t
EndFunction

Function Line:TLine( x#,y#,z#,dx#,dy#,dz# )
	Local t:TLine=New TLine
	t.x=x
	t.y=y
	t.z=z
	t.dx=dx
	t.dy=dy
	t.dz=dz
	Return t
EndFunction

Function Quat:TQuat( x#,y#,z#,w# )
	Local t:TQuat=New TQuat
	t.x=x
	t.y=y
	t.z=z
	t.w=w
	Return t
EndFunction

Function Plane:TPlane( nx#,ny#,nz#,d# )
	Local t:TPlane=New TPlane
	t.nx=nx
	t.ny=ny
	t.nz=nz
	t.d=d
	Return t
EndFunction

Function UlpsEqual( x#,y#,maxUlps=8 )
	Return DeltaUlps( x,y )<=maxUlps
EndFunction

Function DeltaUlps( x#,y# )
	Local ix=(Int Ptr Varptr x)[0]
	Local iy=(Int Ptr Varptr y)[0]
	If ix<0 ix=$80000000-ix
	If iy<0 iy=$80000000-iy
	Return Abs( ix-iy )
EndFunction

Function PointDistance#(p1:TVec3,p2:TVec3)
	Local dx#,dy#,dz#
	dx=p1.x-p2.x
	dy=p1.y-p2.y
	dz=p1.z-p2.z
	Return Sqr(dx*dx+dy*dy+dz*dz)
EndFunction

Function PointDistanceSqrd#(p1:TVec3,p2:TVec3)
	Local dx#,dy#,dz#
	dx=p1.x-p2.x
	dy=p1.y-p2.y
	dz=p1.z-p2.z
	Return dx*dx+dy*dy+dz*dz
EndFunction

Type TVec2
	Field x#,y#

	Method ToString$()
		Return "Vec3("+x+","+y+")"
	End Method

EndType

Type TVec3 {value}

	Field x#,y#,z# {attribute}
	
	Method Copy:TVec3()
		Return Vec3( x,y,z )
	End Method
	
	Method ToString$()
		Return "Vec3("+x+","+y+","+z+")"
	End Method
	
	Method ToVec4:TVec4()
		Return Vec4( x,y,z,1 )
	End Method
	
	Method ToField$()
		Return x+","+y+","+z
	End Method
	
	Method FromField:TVec3( t$ )
		Local bits$[]=t.Split( "," )
		If bits.length<>3 Throw "Format error"
		x=bits[0].ToFloat()
		y=bits[1].ToFloat()
		z=bits[2].ToFloat()
		Return Self
	End Method

	Method Pointer:Float Ptr()
		Return Varptr x
	EndMethod

	Method Length#()
		Return Sqr( x*x+y*y+z*z )
	End Method
	
	Method Dot#( v:TVec3 )
		Return x*v.x+y*v.y+z*v.z
	End Method
	
	Method Inverse:TVec3()
		Return Vec3( -x,-y,-z )
	End Method
	
	Method Reciprocal:TVec3()
		Return Vec3( 1/x,1/y,1/z )
	End Method
	
	Method Normalize:TVec3()
		Local t#=Sqr( x*x+y*y+z*z )
		If t=0.0 Return vec3(0.0,0.0,0.0)
		Return Vec3( x/t,y/t,z/t )
	End Method
	
	Method Scale:TVec3( scale# )
		Return Vec3( x*scale,y*scale,z*scale )
	End Method 
	
	Method DistanceTo#( v:TVec3 )
		Local dx#=x-v.x,dy#=y-v.y,dz#=z-v.z
		Return Sqr( dx*dx+dy*dy+dz*dz )
	End Method
	
	Method Plus:TVec3( v:TVec3 )
		Return Vec3( x+v.x,y+v.y,z+v.z )
	End Method
	
	Method Minus:TVec3( v:TVec3 )
		Return Vec3( x-v.x,y-v.y,z-v.z )
	End Method
	
	Method Times:TVec3( v:TVec3 )
		Return Vec3( x*v.x,y*v.y,z*v.z )
	End Method
	
	Method DividedBy:TVec3( v:TVec3 )
		Return Vec3( x/v.x,y/v.y,z/v.z )
	End Method
	
	Method Cross:TVec3( v:TVec3 )
		Return Vec3( y*v.z-z*v.y,z*v.x-x*v.z,x*v.y-y*v.x )
	End Method
	
	Method Blend:TVec3( v:TVec3,Alpha# )
		Local beta#=1-Alpha
		Return Vec3( x*beta+v.x*Alpha,y*beta+v.y*Alpha,z*beta+v.z*Alpha )
	End Method
	
	Method ToQuat:TQuat()
		Local c1#=Cos(-z/2)
		Local s1#=Sin(-z/2)
		Local c2#=Cos(-x/2)
		Local s2#=Sin(-x/2)
		Local c3#=Cos( y/2)
		Local s3#=Sin( y/2)
		Local c1_c2#=c1*c2
		Local s1_s2#=s1*s2
		Local t:TQuat=New TQuat
		t.x=c1*s2*c3 - s1*c2*s3;
		t.y=c1_c2*s3 + s1_s2*c3;
		t.z=s1*c2*c3 + c1*s2*s3;
		t.w=c1_c2*c3 - s1_s2*s3;
		Return t
	EndMethod
	
	Function FromQuat:TVec3(quat:TQuat)
		Return quat.toeuler()
	EndFunction
	
	Method Compare:Int(o:Object)
		Local t:TVec3=TVec3(o)
		If x<t.x Return -1
		If y<t.y Return -1
		If z<t.z Return -1
		If x>t.x Return 1
		If y>t.y Return 1
		If z>t.z Return 1
		Return 0
	EndMethod
	
EndType

Type TVec4' Extends TVec3

	Field x#,y#,z#,w# {attribute}
	
	Method Copy:TVec4()
		Return Vec4( x,y,z,w )
	End Method
	
	Method ToString$()
		Return "Vec4("+x+","+y+","+z+","+w+")"
	End Method
	
	Method ToVec3:TVec3()
		Return vec3(x,y,z)
	End Method
	
	Method XYZ:TVec3()
		Return vec3(x,y,z)
	EndMethod
	
	Method Plus:TVec4( v:TVec4 )
		Return Vec4( x+v.x,y+v.y,z+v.z,w+v.w )
	End Method

	Method Times:TVec4( v:TVec4 )
		Return Vec4( x*v.x,y*v.y,z*v.z,w*v.w )
	End Method	

	Method Pointer:Float Ptr()
		Return Varptr x
	EndMethod

EndType

Type TLine

	Field x#,y#,z#,dx#,dy#,dz# {attribute}
	
	Method Copy:TLine()
		Return Line( x,y,z,dx,dy,dz )
	End Method
	
	Method ToString$()
		Return "Line("+x+","+y+","+z+","+dx+","+dy+","+dz+")"
	End Method
	
	Method Origin:TVec3()
		Return Vec3( x,y,z )
	End Method
	
	Method Delta:TVec3()
		Return Vec3( dx,dy,dz )
	End Method
	
	Method EndPoint:TVec3()
		Return Vec3( x+dx,y+dy,z+dz )
	End Method
	
	Method Evaluate:TVec3( time# )
		Return Vec3( x+dx*time,y+dy*time,z+dz*time )
	End Method
	
	Method DistanceTo#( t:TLine )
		Local wx#=x-t.x
		Local wy#=y-t.y
		Local wz#=z-t.z
		Local a#=dx*dx+dy*dy+dz*dz
		Local b#=dx*t.dx+dy*t.dy+dz*t.dz
		Local c#=t.dx*t.dx+t.dy*t.dy+t.dz*t.dz
		Local d#=dx*wx+dy*wy+dz*wz
		Local e#=t.dx*wx+t.dy*wy+t.dz*wz
		Local q#=a*c-b*b
		Local st#=b*e-c*d
		Local tt#=a*e-b*d
		Local tx#=wx+(st*dx-tt*t.dx)/q
		Local ty#=wy+(st*dy-tt*t.dy)/q
		Local tz#=wz+(st*dz-tt*t.dz)/q
		Return Sqr( tx*tx+ty*ty+tz*tz )
	End Method

	Method Intersects:TVec3( t:TLine,tolerance#=0.001 )
		Local wx#=x-t.x
		Local wy#=y-t.y
		Local wz#=z-t.z
		Local a#=dx*dx+dy*dy+dz*dz
		Local b#=dx*t.dx+dy*t.dy+dz*t.dz
		Local c#=t.dx*t.dx+t.dy*t.dy+t.dz*t.dz
		Local d#=dx*wx+dy*wy+dz*wz
		Local e#=t.dx*wx+t.dy*wy+t.dz*wz
		Local q#=a*c-b*b
		Local st#=b*e-c*d
		Local tt#=a*e-b*d
		Local tx#=wx+(st*dx-tt*t.dx)/q
		Local ty#=wy+(st*dy-tt*t.dy)/q
		Local tz#=wz+(st*dz-tt*t.dz)/q
		If tolerance<>-1
			If tx*tx+ty*ty+tz*tz>=tolerance*tolerance Return
		EndIf	
		tx#=wx+(st*dx)/q
		ty#=wy+(st*dy)/q
		tz#=wz+(st*dz)/q
		Return vec3(tx,ty,tz).plus(vec3(t.x,t.y,t.z))
	EndMethod
	
	Function FromEndPoints:TLine( p0:TVec3,p1:TVec3 )
		Local t:TLine=New TLine
		t.x=p0.x;t.y=p0.y;t.z=p0.z
		t.dx=p1.x-p0.x;t.dy=p1.y-p0.y;t.dz=p1.z-p0.z;
		Return t
	EndFunction
	
EndType

Type TQuat

	Field x#,y#,z#,w#=1.0 {attribute}
	
	Method Copy:TQuat()
		Return Quat( x,y,z,w )
	End Method
	
	Method ToString$()
		Return "Quat("+x+","+y+","+z+","+w+")"
	End Method
	
	Method Inverse:TQuat()
		Return Quat( -x,-y,-z,w )
	End Method

	Method ToAngleAxis( angle# Var,axis:TVec3 Var )
		Local t#=ACos(w)
		angle=t*2
		If angle>0
			t=1/Sin(t)
			axis=Vec3( x*t,y*t,z*t )
		Else
			axis=Vec3(0,0,0)
		EndIf
	End Method
	
	Method Yaw#()
		Return ATan2( 2*y*w-2*z*x,1-2*y*y-2*x*x )
	End Method
	
	Method Pitch#()
		Return -ASin( 2*z*y+2*x*w )
	End Method
	
	Method Roll#()
		Return -ATan2( 2*z*w-2*y*x,1-2*z*z-2*x*x )
	End Method
	
	Method ToEuler:TVec3()
		Local x2#=x*x,y2#=y*y,z2#=z*z
		Local euler:TVec3=New TVec3
		euler.y#=ATan2( 2*y*w-2*z*x,1-2*y2-2*x2 )
		euler.x#=-ASin( 2*z*y+2*x*w )
		euler.z#=-ATan2( 2*z*w-2*y*x,1-2*z2-2*x2 )
		Return euler
	End Method
	
	Method Times:TQuat( q:TQuat )
		Local result:TQuat=New TQuat
		result.x#=w*q.x + x*q.w + y*q.z - z*q.y
		result.y#=w*q.y + y*q.w + z*q.x - x*q.z
		result.z#=w*q.z + z*q.w + x*q.y - y*q.x
		result.w#=w*q.w - x*q.x - y*q.y - z*q.z
		Return result
	EndMethod
	
	Method Slerp:TQuat( q:TQuat,a# )
		Local b#=1-a,f
		Local d#=x*q.x+y*q.y+z*q.z+w*q.w
		If d<0
			d=-d
			f=True
		EndIf
		If d<1
			Local om#=ACos( d )'-
			Local si#=Sin( om )'-
			a=Sin( a*om )/si'-
			b=Sin( b*om )/si'-
		EndIf
		If f a=-a
		Return Quat( x*b + q.x*a , y*b + q.y*a , z*b + q.z*a , w*b + q.w*a )
	EndMethod
	
	Method Normalize:TQuat()
		Local q:TQuat=New TQuat
		Local m#=Sqr(x*x+y*y+z*z+w*w)
		q.x=x/m
		q.y=y/m
		q.z=z/m
		q.w=w/m
		Return q
	EndMethod
	
	Function FromAngleAxis:TQuat( angle#,axis:TVec3 )
		angle:/2
		Local s#=Sin(angle)
		Local t:TQuat=New TQuat
		t.x=s*axis.x
		t.y=s*axis.y
		t.z=s*axis.z
		t.w=Cos(angle)
		Return t
	EndFunction
	
	Function FromEuler:TQuat(euler:TVec3)
		Return euler.toquat()
	EndFunction	

EndType

Type TPlane

	Field nx#,ny#,nz#,d# {attribute}
	
	Method Copy:TPlane()
		Return Plane( nx,ny,nz,d )
	End Method
	
	Method ToString$()
		Return "Plane("+nx+","+ny+","+nz+","+d+")"
	End Method
	
	Method MajorAxis()
		Local ax#=Abs(nx),ay#=Abs(ny),az#=Abs(nz)
		If ax>ay And ax>az Return 0
		If ay>az Return 1
		Return 2
	End Method
	
	Method SolveX:TVec3( p:TVec3 )
		Return Vec3( (p.y*ny+p.z*nz+d)/-nx,p.y,p.z )
	End Method
	
	Method SolveY:TVec3( p:TVec3 )
		Return Vec3( p.x,(p.x*nx+p.z*nz+d)/-ny,p.z )
	End Method
	
	Method SolveZ:TVec3( p:TVec3 )
		Return Vec3( p.x,p.y,(p.x*nx+p.y*ny+d)/-nz )
	End Method
	
	Method Inverse:TPlane()
		Return Plane( -nx,-ny,-nz,-d )
	End Method
	
	Method Normal:TVec3()
		Return Vec3( nx,ny,nz )
	End Method
	
	Method Normalize:TPlane()
		Local i#=1/Sqr(nx*nx+ny*ny+nz*nz)
		Return Plane( nx*i,ny*i,nz*i,d*i )
	End Method
	
	Method t_IntersectLine#( t:TLine )
		Return -DistanceToPoint( t.Origin() ) / Normal().Dot( t.Delta() )
	End Method
	
	Method IntersectsLine:TVec3(l:TLine)
		Local v:TVec3=New TVec3
		Local u#
		u#=(nx*l.x+ny*l.y+nz*l.z+d)/(nx*l.dx+ny*l.dy+nz*l.dz)
		v.x=l.x-l.dx*u
		v.y=l.y-l.dy*u
		v.z=l.z-l.dz*u
		Return v
	EndMethod
	
	Method DistanceToPoint#( p:TVec3 )
		Return nx*p.x+ny*p.y+nz*p.z+d
	End Method
	
	Function FromPointNormal:TPlane( p:TVec3,n:TVec3 )
		Return Plane( n.x,n.y,n.z,-p.Dot(n) )
	EndFunction
	
	Function FromTriangle:TPlane( v0:TVec3,v1:TVec3,v2:TVec3 )
		Local va:TVec3=v2.Minus(v1)
		Local vb:TVec3=v0.Minus(v1)
		Return FromPointNormal( v1,va.Cross(vb).Normalize() )
	EndFunction
	
	Function Ground:TPlane()
		Return Plane( 0,1,0,0 )
	EndFunction

EndType

Type TMat4

	Field ix#,iy#,iz#,iw# {attribute}
	Field jx#,jy#,jz#,jw# {attribute}
	Field kx#,ky#,kz#,kw# {attribute}
	Field tx#,ty#,tz#,tw# {attribute}

	Method Copy:TMat4()
		Local t:TMat4=New TMat4
		MemCopy t,Self,SizeOf Self
		Return t
	End Method
	
	Method ToString$()
		Local t$="Mat4{~n"
		t:+ix+","+iy+","+iz+","+iw+"~n"
		t:+jx+","+jy+","+jz+","+jw+"~n"
		t:+kx+","+ky+","+kz+","+kw+"~n"
		t:+tx+","+ty+","+tz+","+tw+"~n"
		Return t+"}~n"
	End Method
	
	Method Pointer:Float Ptr()
		Return Varptr ix
	EndMethod
	
	Method Translation:TVec3()
		Return Vec3(tx,ty,tz)
	End Method

	Rem
	Local sc:TVec3=Scale()
	Local iv:TVec3=Vec3(ix,iy,iz).Scale(1/sc.x)
	Local jv:TVec3=Vec3(jx,jy,jz).Scale(1/sc.y)
	Local kv:TVec3=Vec3(kx,ky,kz).Scale(1/sc.z)
	Local x#,y#,z#,w#
	Local t#=iv.x+jv.y+kv.z+1
	If t>0
		t=Sqr(t)*2
		x=(kv.y-jv.z)/t
		y=(iv.z-kv.x)/t
		z=(jv.x-iv.y)/t
		w=t/4
	Else If iv.x>jv.y And iv.x>kv.z
		t=Sqr(iv.x-jv.y-kv.z+1)*2.0
		x=t/4
		y=(jv.x+iv.y)/t
		z=(iv.z+kv.x)/t
		w=(kv.y-jv.z)/t
	Else If jv.y>kv.z
		t=Sqr(jv.y-kv.z-iv.x+1)*2.0
		x=(jv.x+iv.y)/t
		y=t/4
		z=(kv.y+jv.z)/t
		w=(iv.z-kv.x)/t
	Else
		t=Sqr(kv.z-jv.y-iv.x+1)*2.0
		x=(iv.z+kv.x)/t
		y=(kv.y+jv.z)/t
		z=t/4
		w=(jv.x-iv.y)/t
	EndIf
	Return Quat( x,y,z,w )
	EndRem
	
	Method Rotation:TQuat()
		Return normalize().Rotation2()
	EndMethod
	
	Method Rotation2:TQuat()	
		Local mult:Float
		Local x#,y#,z#,w#
		Local fourWSquaredMinus1:Float = +ix+jy+kz
		Local fourXSquaredMinus1:Float = +ix-jy-kz
		Local fourYSquaredMinus1:Float = +jy-ix-kz
		Local fourZSquaredMinus1:Float = +kz-ix-jy
		Local biggestIndex=0
		Local fourBiggestSquaredMinus1:Float=fourWSquaredMinus1
		If fourXSquaredMinus1 > fourBiggestSquaredMinus1
			fourBiggestSquaredMinus1 = fourXSquaredMinus1 
			biggestIndex=1
		EndIf
		If fourYSquaredMinus1 > fourBiggestSquaredMinus1
			fourBiggestSquaredMinus1 = fourYSquaredMinus1 
			biggestIndex=2
		EndIf
		If fourZSquaredMinus1 > fourBiggestSquaredMinus1
			fourBiggestSquaredMinus1 = fourZSquaredMinus1 
			biggestIndex=3
		EndIf
		Local biggestValue:Float=Sqr(fourBiggestSquaredMinus1+1.0)*0.5
		mult=0.25/biggestValue
		Select BiggestIndex
			Case 0
				w#=BiggestValue
				x#=(jz-ky)*mult
				y#=-(kx-iz)*mult
				z#=-(iy-jx)*mult
			Case 1
				x#=-BiggestValue
				w#=-( jz - ky )*mult
				y#=( iy + jx )*mult
				z#=( kx + iz )*mult
			Case 2
				y#=BiggestValue
				w#=-(kx-iz)*mult
				x#=-(iy+jx)*mult
				z#=(jz+ky)*mult
			Case 3
				z#=-BiggestValue
				w#=(iy-jx)*mult
				x#=(kx+iz)*mult
				y#=-(jz+ky)*mult
		EndSelect
		Return quat(-x,y,z,w)
	EndMethod
	
	
	Method Scale:TVec3()
		Return Vec3( Vec3(ix,iy,iz).Length(),Vec3(jx,jy,jz).Length(),Vec3(kx,ky,kz).Length() )
	End Method
	
	Method Times:TMat4( m:TMat4 )
		Local t:TMat4=New TMat4
		t.ix= ix*m.ix + jx*m.iy + kx*m.iz + tx*m.iw
		t.iy= iy*m.ix + jy*m.iy + ky*m.iz + ty*m.iw
		t.iz= iz*m.ix + jz*m.iy + kz*m.iz + tz*m.iw
		t.iw= iw*m.ix + jw*m.iy + kw*m.iz + tw*m.iw
		t.jx= ix*m.jx + jx*m.jy + kx*m.jz + tx*m.jw
		t.jy= iy*m.jx + jy*m.jy + ky*m.jz + ty*m.jw
		t.jz= iz*m.jx + jz*m.jy + kz*m.jz + tz*m.jw
		t.jw= iw*m.jx + jw*m.jy + kw*m.jz + tw*m.jw
		t.kx= ix*m.kx + jx*m.ky + kx*m.kz + tx*m.kw
		t.ky= iy*m.kx + jy*m.ky + ky*m.kz + ty*m.kw
		t.kz= iz*m.kx + jz*m.ky + kz*m.kz + tz*m.kw
		t.kw= iw*m.kx + jw*m.ky + kw*m.kz + tw*m.kw
		t.tx= ix*m.tx + jx*m.ty + kx*m.tz + tx*m.tw
		t.ty= iy*m.tx + jy*m.ty + ky*m.tz + ty*m.tw
		t.tz= iz*m.tx + jz*m.ty + kz*m.tz + tz*m.tw
		t.tw= iw*m.tx + jw*m.ty + kw*m.tz + tw*m.tw
		Return t
	End Method
	
	Method TimesPoint:TVec3( v:TVec3 )
'	Rem
		Return Vec3(..
			ix*v.x + jx*v.y + kx*v.z + tx,..
			iy*v.x + jy*v.y + ky*v.z + ty,..
			iz*v.x + jz*v.y + kz*v.z + tz )
'	End Rem
'		Local x#=ix*v.x + jx*v.y + kx*v.z + tx
'		Local y#=iy*v.x + jy*v.y + ky*v.z + ty
'		Local z#=iz*v.x + jz*v.y + kz*v.z + tz
'		Local w#=iw*v.x + jw*v.y + kw*v.z + tw
'		Return Vec3( x/w,y/w,z/w )
	End Method
	
	Method TimesVector:TVec3( v:TVec3 )
		Return Vec3(..
			ix*v.x + jx*v.y + kx*v.z,..
			iy*v.x + jy*v.y + ky*v.z,..
			iz*v.x + jz*v.y + kz*v.z )
	End Method

	Method TimesNormal:TVec3( v:TVec3 )
		Local m:TMat4=Inverse()
		Return Vec3(..
			m.ix*v.x + m.iy*v.y + m.iz*v.z,..
			m.jx*v.x + m.jy*v.y + m.jz*v.z,..
			m.kx*v.x + m.ky*v.y + m.kz*v.z )
	End Method
	
	Method TimesPlane:TPlane( p:TPlane )
		Local m:TMat4=Inverse()
		Return Plane(..
			m.ix*p.nx + m.iy*p.ny + m.iz*p.nz + m.iw*p.d,..
			m.jx*p.nx + m.jy*p.ny + m.jz*p.nz + m.jw*p.d,..
			m.kx*p.nx + m.ky*p.ny + m.kz*p.nz + m.kw*p.d,..
			m.tx*p.nx + m.ty*p.ny + m.tz*p.nz + m.tw*p.d ).Normalize()
	End Method
	
	Method TimesLine:TLine( t:TLine )
		Return TLine.FromEndPoints( TimesPoint( t.Origin() ),TimesPoint( t.EndPoint() ) )
	End Method
	
	Method Determinant#()
		Assert Abs(iw)<=.001 And Abs(jw)<=.001 And Abs(kw<=.001) And tw>=1-.001
		Return ix*(jy*kz-jz*ky) - iy*(jx*kz-jz*kx) + iz*(jx*ky-jy*kx)
	End Method
	
	Method I:TVec3()
		Return Vec3(ix,iy,iz)
	End Method
	
	Method J:TVec3()
		Return Vec3(jx,jy,jz)
	End Method
		
	Method K:TVec3()
		Return Vec3(kx,ky,kz)
	End Method
		
	Method Cofactor:TMat4()
		Local t:TMat4=New TMat4
		t.ix= (jy*kz-jz*ky) ; t.iy=-(jx*kz-jz*kx) ; 	t.iz= (jx*ky-jy*kx)
		t.jx=-(iy*kz-iz*ky) ; t.jy= (ix*kz-iz*kx) ; 	t.jz=-(ix*ky-iy*kx)
		t.kx= (iy*jz-iz*jy) ; t.ky=-(ix*jz-iz*jx) ; 	t.kz= (ix*jy-iy*jx)
		Return t
	End Method
	
	Method Inverse:TMat4()
		Local c#=1.0/Determinant()
		Local t:TMat4=New TMat4
		t.ix= c * ( jy*kz - jz*ky )
		t.iy=-c * ( iy*kz - iz*ky )
		t.iz= c * ( iy*jz - iz*jy )
		t.jx=-c * ( jx*kz - jz*kx )
		t.jy= c * ( ix*kz - iz*kx )
		t.jz=-c * ( ix*jz - iz*jx )
		t.kx= c * ( jx*ky - jy*kx )
		t.ky=-c * ( ix*ky - iy*kx )
		t.kz= c * ( ix*jy - iy*jx )
		t.tx=-( tx*t.ix + ty*t.jx + tz*t.kx )
		t.ty=-( tx*t.iy + ty*t.jy + tz*t.ky )
		t.tz=-( tx*t.iz + ty*t.jz + tz*t.kz )
		t.tw=1
		Return t
	End Method
	
	Method MyInverse:TMat4()
		Local t:TMat4=Transpose()
		t.iw=0
		t.jw=0
		t.kw=0
		t.tw=1
		t.tx=-( tx*t.ix + ty*t.jx + tz*t.kx )
		t.ty=-( tx*t.iy + ty*t.jy + tz*t.ky )
		t.tz=-( tx*t.iz + ty*t.jz + tz*t.kz )
		Return t
		'mat.tx = -( (ix * tx) + (grid[0,1] * ty) + (grid[0,2] * tz) )
		'mat.ty = -( (jx * tx) + (grid[1,1] * ty) + (grid[1,2] * tz) )
		'mat.tz = -( (kx * tx) + (grid[2,1] * ty) + (grid[2,2] * tz) )		
	EndMethod
	
	Method Transpose:TMat4()
		Local t:TMat4=New TMat4
		t.ix=ix ; t.iy=jx ; t.iz=kx ; t.iw=tx
		t.jx=iy ; t.jy=jy ; t.jz=ky ; t.jw=ty
		t.kx=iz ; t.ky=jz ; t.kz=kz ; t.kw=tz
		t.tx=iw ; t.ty=jw ; t.tz=kw ; t.tw=tw
		Return t
	End Method
	
	Function FromDirection:TMat4( dir:TVec3,up:TVec3=Null )
		If Not up up=Vec3(0,1,0)
		Local j:TVec3=up.Normalize()
		Local k:TVec3=dir.Normalize()
		Local i:TVec3=j.Cross(k).Normalize()
		j=k.Cross(i).Normalize()
		Local t:TMat4=New TMat4
		t.ix=i.x ; t.iy=i.y ; t.iz=i.z
		t.jx=j.x ; t.jy=j.y ; t.jz=j.z
		t.kx=k.x ; t.ky=k.y ; t.kz=k.z
		t.tw=1
		Return t
	EndFunction
	
	Function FromTranslation:TMat4( v:TVec3 )
		Local t:TMat4=New TMat4
		t.ix=1 ; t.jy=1 ;	t.kz=1
		t.tx=v.x ; t.ty=v.y ; t.tz=v.z
		t.tw=1
		Return t
	EndFunction
	
	Function FromRotation:TMat4( q:TQuat )
		Local t:TMat4=New TMat4
		Local xx#=q.x*q.x,yy#=q.y*q.y,zz#=q.z*q.z
		Local xy#=q.x*q.y,xz#=q.x*q.z,yz#=q.y*q.z
		Local wx#=q.w*q.x,wy#=q.w*q.y,wz#=q.w*q.z
		t.ix=1-2*(yy+zz) ; t.iy=  2*(xy-wz) ; t.iz=  2*(xz+wy)
		t.jx=  2*(xy+wz) ; t.jy=1.0-2*(xx+zz) ; t.jz=  2*(yz-wx)
		t.kx=  2*(xz-wy) ; t.ky=  2*(yz+wx) ; t.kz=1.0-2*(xx+yy)
		t.tw=1
		Return t
	EndFunction
	
	Function FromScale:TMat4( v:TVec3 )
		Local t:TMat4=New TMat4
		t.ix=v.x
		t.jy=v.y
		t.kz=v.z
		t.tw=1
		Return t
	EndFunction
	
	Function FromUniformScale:TMat4( sc# )
		Local t:TMat4=New TMat4
		t.ix=sc
		t.jy=sc
		t.kz=sc
		t.tw=1
		Return t
	EndFunction
	
	Function FromTransRotScale:TMat4( trans:TVec3,rot:TQuat,scale:TVec3 )
		Local t:TMat4
		If trans
			t=FromTranslation(trans)
			If rot t=t.Times(FromRotation(rot))
			If scale t=t.Times(FromScale(scale))
		Else If rot
			t=FromRotation(rot)
			If scale t=t.Times(FromScale(scale))
		Else If scale
			t=FromScale(scale)
		Else
			t=Identity()
		EndIf
		Return t
	EndFunction
	
	Function FromYaw:TMat4( yaw# )	'untested!
		Local t:TMat4=New TMat4
		Local s#=Sin(yaw),c#=Cos(yaw)
		t.ix=c  ; t.iz=s ; t.jy=1
		t.kx=-s ; t.kz=c ; t.tw=1
		Return t
	EndFunction
	
	Function FromPitch:TMat4( pitch# )	'untested!
		Local t:TMat4=New TMat4
		Local s#=Sin(pitch),c#=Cos(pitch)
		t.ix=1  ; t.jy=c ; t.jz=s
		t.ky=-s ; t.kz=c ; t.tw=1
		Return t
	EndFunction
	
	Function FromRoll:TMat4( roll# )	'untested!
		Local t:TMat4=New TMat4
		Local s#=Sin(roll),c#=Cos(roll)
		t.ix=c ; t.iy=s ; t.jx=-s
		t.jy=c ; t.kz=1 ; t.tw=1
		Return t
	EndFunction
	
	Function FromYawPitchRoll:TMat4( yaw#,pitch#,roll# )
		Local t:TMat4
		If yaw
			t=FromYaw(yaw)
			If pitch t=t.Times(FromPitch(pitch))
			If roll t=t.Times(FromRoll(roll))
		Else If pitch
			t=FromPitch(pitch)
			If roll t=t.Times(FromRoll(roll))
		Else If roll
			t=FromRoll(roll)
		Else
			t=Identity()
		EndIf
		Return t
	EndFunction
	
	Function FromOrtho:TMat4( l#,r#,b#,t#,n#,f# )
		Local q:TMat4=New TMat4
		q.ix=2/(r-l)
		q.tx=-(r+l)/(r-l)
		q.jy=2/(t-b)
		q.ty=-(t+b)/(t-b)
		q.kz=2/(f-n)
		q.tz=-(f+n)/(f-n)
		q.tw=1
		Return q
	EndFunction
	
	Function FromFrustum:TMat4( near_left#,near_right#,near_bottom#,near_top#,near#,far# )
		Local t:TMat4=New TMat4
		Local near2#=near*2
		Local w#=near_right-near_left
		Local h#=near_top-near_bottom
		Local d#=far-near
		t.ix=near2/w
		t.jy=near2/h
		t.kx=(near_right+near_left)/w
		t.ky=(near_top+near_bottom)/h
		t.kz=(far+near)/d
		t.kw=1
		t.tz=-(far*near2)/d
		Return t
	EndFunction
	
	Function FromInfiniteFrustum:TMat4( near_left#,near_right#,near_bottom#,near_top#,near# )
		Local t:TMat4=New TMat4
		Local near2#=near*2
		Local w#=near_right-near_left
		Local h#=near_top-near_bottom
		Local e#=.001
		t.ix=near2/w
		t.jy=near2/w
		t.kx=(near_right+near_left)/w
		t.ky=(near_top+near_bottom)/h
		t.kz=1-e
		t.kw=1
		t.tz=near*(e-1)
		Return t
	EndFunction

	Function Identity:TMat4()
		Local t:TMat4=New TMat4
		t.ix=1 ; t.jy=1 ; t.kz=1 ; t.tw=1
		Return t
	EndFunction
	
	Method Normalize:TMat4()
		Local mat:TMat4=New TMat4
		Local vec:TVec3
		vec=i().normalize()
		mat.ix=vec.x
		mat.iy=vec.y
		mat.iz=vec.z
		vec=j().normalize()
		mat.jx=vec.x
		mat.jy=vec.y
		mat.jz=vec.z
		vec=k().normalize()
		mat.kx=vec.x
		mat.ky=vec.y
		mat.kz=vec.z
		mat.tx=tx
		mat.ty=ty
		mat.tz=tz
		mat.tw=1.0
		Return mat
	EndMethod
	
EndType

Type TAABB
	
	Field x0#,y0#,z0#,x1#,y1#,z1#,cx#,cy#,cz#,w#,h#,d#,radius# { attribute }
	
	Method Reset()
		x0=0.0
		y0=0.0
		z0=0.0
		x1=0.0
		y1=0.0
		z1=0.0
		cx#=0.0
		cy#=0.0
		cz#=0.0
		w#=0.0
		h#=0.0
		d#=0.0
	EndMethod
	
	'Rem
	Method TForm:TAABB(src:TMat4,dst:TMat4)
		Local vec:TVec3
		
		Local aabb:TAABB
		aabb=New taabb
		
		vec=TFormPointm(vec3(x0,y0,z0),src,dst)
		aabb.x0=vec.x
		aabb.y0=vec.y
		aabb.z0=vec.z
		aabb.x1=vec.x
		aabb.y1=vec.y
		aabb.z1=vec.z
		
		vec=TFormPointm(vec3(x0,y0,z1),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)

		vec=TFormPointm(vec3(x0,y1,z0),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)

		vec=TFormPointm(vec3(x1,y0,z0),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)

		vec=TFormPointm(vec3(x1,y1,z0),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)

		vec=TFormPointm(vec3(x0,y1,z1),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)
		
		vec=TFormPointm(vec3(x1,y0,z1),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)

		vec=TFormPointm(vec3(x1,y1,z1),src,dst)
		aabb.x0=Min(aabb.x0,vec.x)
		aabb.y0=Min(aabb.y0,vec.y)
		aabb.z0=Min(aabb.z0,vec.z)
		aabb.x1=Max(aabb.x1,vec.x)
		aabb.y1=Max(aabb.y1,vec.y)
		aabb.z1=Max(aabb.z1,vec.z)
		
		aabb.Update()
		
		Return aabb
	EndMethod
	
	Method Update()
		w=x1-x0
		h=y1-y0
		d=z1-z0
		cx=x0+w*0.5
		cy=y0+h*0.5
		cz=z0+d*0.5
		UpdateRadius()
	EndMethod
	

	
	Method IntersectsPoint:Int(p:TVec3,radius#=0.0)
		If p.x<x0-radius Return False
		If p.y<y0-radius Return False
		If p.z<z0-radius Return False
		If p.x>x1+radius Return False
		If p.y>y1+radius Return False
		If p.z>z1+radius Return False
		Return True
	EndMethod

	Method IntersectsAABB:Int(aabb:TAABB)
		If aabb.x0>x1 Return False
		If aabb.y0>y1 Return False
		If aabb.z0>z1 Return False
		If aabb.x1<x0 Return False
		If aabb.y1<y0 Return False
		If aabb.z1<z0 Return False
		Return True
	EndMethod
	
	Function FromCloud:TAABB(vertex_count,vertex_cloud:Float Ptr)
		Local aabb:TAABB=New TAABB
		Local v:Int
		For v=0 To vertex_count-1
			If v=0 Or vertex_cloud[v*3+0]<aabb.x0 aabb.x0=vertex_cloud[v*3+0]
			If v=0 Or vertex_cloud[v*3+1]<aabb.y0 aabb.y0=vertex_cloud[v*3+1]
			If v=0 Or vertex_cloud[v*3+2]<aabb.z0 aabb.z0=vertex_cloud[v*3+2]
			If v=0 Or vertex_cloud[v*3+0]>aabb.x1 aabb.x1=vertex_cloud[v*3+0]
			If v=0 Or vertex_cloud[v*3+1]>aabb.y1 aabb.y1=vertex_cloud[v*3+1]
			If v=0 Or vertex_cloud[v*3+2]>aabb.z1 aabb.z1=vertex_cloud[v*3+2]
		Next
		aabb.Update()
		Return aabb
	EndFunction
	
	Method UpdateRadius()
		Local dx#,dy#,dz#
		dx=w*0.5
		dy=h*0.5
		dz=d*0.5
		radius=Sqr(dx*dx+dy*dy+dz*dz)
	EndMethod

	Method MinExtent:TVec3()
		Return vec3(x0,y0,z0)
	EndMethod
	
	Method MaxExtent:TVec3()
		Return vec3(x1,y1,z1)
	EndMethod
	
	Method Center:TVec3()
		Return vec3(cx,cy,cz)
	EndMethod
	
	Method Copy:TAABB()
		Local aabb:TAABB
		aabb=New TAABB
		aabb.x0=x0
		aabb.y0=y0
		aabb.z0=z0
		aabb.x1=x1
		aabb.y1=y1
		aabb.z1=z1
		aabb.cx=cx
		aabb.cy=cy
		aabb.cz=cz
		aabb.w=w
		aabb.h=h
		aabb.d=d
		aabb.radius=radius
		Return aabb
	EndMethod
	
	Method IntersectsPlane:Int(plane:TPlane)
		Local d#,n
		Local greater
		Local lesser
		Local p:TVec3
		For n=1 To 8
			Select n
				Case 1 p=vec3(x0,y0,z0)
				Case 2 p=vec3(x1,y0,z0)
				Case 3 p=vec3(x0,y1,z0)
				Case 4 p=vec3(x0,y0,z1)
				Case 5 p=vec3(x1,y1,z1)
				Case 6 p=vec3(x0,y1,z1)
				Case 7 p=vec3(x1,y0,z1)
				Case 8 p=vec3(x1,y1,z1)
			EndSelect
			d#=plane.DistanceToPoint(p)
			If d>0.0 greater=True
			If d<0.0 lesser=True
			If greater=True And lesser=True Return 0
		Next
		If greater=True Return 1
		If lesser=True Return -1
	EndMethod
	
	Method ToString$()
		Return x0+", "+y0+", "+z0+", "+x1+", "+y1+", "+z1+Chr(13)+Chr(10)+cx+", "+cy+", "+cz
	EndMethod
	
	Method Intersects:Int(aabb:TAABB,bias#=0.0)
		If x0>aabb.x1-bias Return
		If y0>aabb.y1-bias Return
		If z0>aabb.z1-bias Return
		If aabb.x0>x1-bias Return
		If aabb.y0>y1-bias Return
		If aabb.z0>z1-bias Return
		Return 1
	EndMethod
	
EndType

Function TFormPointm:TVec3(p:TVec3,mat1:TMat4,mat2:TMat4)
	Local mat:TMat4
	If mat1
		mat=mat1.times(TMat4.FromTranslation(p))
		p=mat.Translation()
	EndIf
	If mat2
		mat=mat2.inverse().times(TMat4.FromTranslation(p))
		p=mat.Translation()
	EndIf
	If mat1=Null And mat2=Null Return p.copy() Else Return p
EndFunction

Function TFormVectorm:TVec3(p:TVec3,mat1:TMat4,mat2:TMat4)
	Local mat:TMat4
	If mat1
		mat=mat1.copy()
		mat.tx=0.0 ; mat.ty=0.0 ; mat.tz=0.0
		mat=mat.times(TMat4.FromTranslation(p))
		p=mat.Translation()
	EndIf
	If mat2
		mat=mat2.inverse()
		mat.tx=0.0 ; mat.ty=0.0 ; mat.tz=0.0
		mat=mat.times(TMat4.FromTranslation(p))
		p=mat.Translation()
	EndIf
	If mat1=Null And mat2=Null Return p.copy() Else Return p
EndFunction

Function TFormNormalm:TVec3(p:TVec3,mat1:TMat4,mat2:TMat4)
	Return TFormVectorm(p,mat1,mat2).normalize()
EndFunction

Function TFormQuatm:TQuat(quat:TQuat,mat1:TMat4,mat2:TMat4)
	Local mat:TMat4
	If mat1
		mat=mat1.copy()
		mat.tx=0.0 ; mat.ty=0.0 ; mat.tz=0.0
		mat=mat.times(TMat4.FromRotation(quat))
		quat=mat.rotation()
	EndIf
	If mat2
		mat=mat2.inverse()
		mat.tx=0.0 ; mat.ty=0.0 ; mat.tz=0.0
		mat=mat.times(TMat4.FromRotation(quat))
		quat=mat.rotation().normalize()
	EndIf
	If mat1=Null And mat2=Null Return quat.copy() Else Return quat	
EndFunction

