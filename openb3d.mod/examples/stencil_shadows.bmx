' stencil_shadows.bmx
' dynamic stencil shadows

Strict

Framework angros.b3dglgraphics
Import Brl.Random

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
PositionEntity camera,-20,10,0

Local lightmode%=2
Local light:TLight=CreateLight(lightmode)

Local light_piv:TPivot=CreatePivot()
PositionEntity light_piv,100,0,100

Local sphere:TMesh=CreateSphere(8,light_piv)
PositionEntity sphere,0,25,50
ScaleEntity sphere,2,2,2
EntityColor sphere,255,0,0

Local plane:TMesh=CreatePlane(16)
MoveEntity plane,0,-1,0
EntityColor plane,100,200,100

PointEntity camera,plane
PositionEntity camera,-60,30,90

Local static%=0 ' note: static shadows are not currently working, they have detached shadows
Local num%=50
Local size%=200
Local cube:TMesh[num]
Local cylinder:TMesh[num]
Local shadow:TShadowObject[num]
Local shadow1:TShadowObject[num]

For Local i%=0 To num-1
	cube[i]=CreateCube()
	PositionEntity cube[i],Rnd(size),0,Rnd(size)
	shadow[i]=CreateShadow(cube[i],static)
	EntityColor cube[i],Rnd(255),Rnd(255),Rnd(255)
	
	cylinder[i]=CreateCylinder()
	FitMesh cylinder[i],-1,-1,-1,2,5,2 ' note: use ScaleMesh/FitMesh but not ScaleEntity
	'ScaleEntity cylinder[i],2,5,2
	PositionEntity cylinder[i],Rnd(size),2.5,Rnd(size)
	shadow1[i]=CreateShadow(cylinder[i],static)
	EntityColor cylinder[i],Rnd(255),Rnd(255),Rnd(255)
Next

Local wiretoggle%=-1,lightmove%=1,cylindermove%=1

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%=0


While Not KeyHit(KEY_ESCAPE) And Not AppTerminate()
	
	If KeyHit(KEY_SPACE) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe True Else Wireframe False
	
	If KeyDown(KEY_UP) Then MoveEntity camera,0,0,1
	If KeyDown(KEY_DOWN) Then MoveEntity camera,0,0,-1
	If KeyDown(KEY_LEFT) Then MoveEntity camera,-1,0,0
	If KeyDown(KEY_RIGHT) Then MoveEntity camera,1,0,0	
	
	If KeyHit(KEY_L) Then lightmove=-lightmove
	If lightmove=1 Then TurnEntity light_piv,0,1,0
	
	If KeyHit(KEY_C) Then cylindermove=-cylindermove
	For Local j%=0 To num-1
		If cylindermove=1 Then TurnEntity cylinder[j],0,0.25,-2.5
	Next
	
	PositionEntity light,EntityX(sphere,1),EntityY(sphere,1),EntityZ(sphere,1)
	PointEntity light,plane
	
	UpdateWorld
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"L: stop light movement, C: stop cylinder movement, lightmode = "+lightmode
	
	Flip
	
Wend
