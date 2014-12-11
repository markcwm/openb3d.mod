' stencil_shadows.bmx
' code by KronosUK

Strict

Framework angros.b3dglgraphics
Import Brl.Random

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
PositionEntity camera,-20,10,0

Local light:TLight=CreateLight(2)
RotateEntity light,45,0,0
PositionEntity light,0,25,0

Local plane:TMesh=CreatePlane(16)
TranslateEntity plane,0,-1,0
PointEntity camera,plane

Local static%=0
Local num%=100
Local size%=200
Local cube:TMesh[num]
Local cylinder:TMesh[num]
Local shadow:TShadowObject[num]
Local shadow1:TShadowObject[num]

For Local i%=0 To num-1
	cube[i]=CreateCube()
	PositionEntity cube[i],Rnd(size),0,Rnd(size)
	shadow[i]=CreateShadow(cube[i],static)
	
	cylinder[i]=CreateCylinder()
	FitMesh cylinder[i],-1,-1,-1,2,5,2 ' Note: you can use ScaleMesh but not ScaleEntity
	PositionEntity cylinder[i],Rnd(size),0,Rnd(size)
	shadow1[i]=CreateShadow(cylinder[i],static)
Next

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%=0

Local wiretoggle%=-1


While Not KeyHit(KEY_ESCAPE) And Not AppTerminate()
	
	If KeyHit(KEY_SPACE) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe True Else Wireframe False
	
	If KeyDown(KEY_UP) Then MoveEntity camera,0,0,1
	If KeyDown(KEY_DOWN) Then MoveEntity camera,0,0,-1
	If KeyDown(KEY_LEFT) Then MoveEntity camera,-1,0,0
	If KeyDown(KEY_RIGHT) Then MoveEntity camera,1,0,0	
	
	UpdateWorld()
	RenderWorld()
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	
	Flip()
Wend
