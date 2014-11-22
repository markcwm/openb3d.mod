' cameraprojmode.bmx
' from minib3d examples

Strict

Framework angros.b3dglgraphics

Graphics3D 800,600


Local camera:TCamera=CreateCamera()
PositionEntity camera,0,0,-10

Local light:TLight=CreateLight()
RotateEntity light,0,0,0

' create cube 1, near to camera
Local cube1:TMesh=CreateCube()
EntityColor cube1,255,0,0
PositionEntity cube1,0,0,0

' create cube 2, same size as cube 1 but further away
Local cube2:TMesh=CreateCube()
EntityColor cube2,0,255,0
PositionEntity cube2,5,5,5

' camera proj mode value
Local Mode%=1, zoom#


While Not KeyDown(KEY_ESCAPE)

	' If spacebar pressed then change mode value
	If KeyHit(KEY_SPACE)=True Then Mode=Mode+1 ; If Mode=3 Then Mode=0
	
	' If mode value = 2 (orthagraphic), then reduce zoom value To 0.1
	If Mode=2 Then zoom=0.1 Else zoom=1
	
	' set camera projection mode using mode value
	CameraProjMode camera,Mode
	
	' set camera zoom using zoom value
	CameraZoom camera,zoom
	
	RenderWorld
	
	Text 0,0,"Press spacebar to change the camera project mode"
	Text 0,20,"CameraProjMode camera,"+Mode
	Text 0,40,"CameraZoom camera,"+zoom
	
	Flip

Wend
End
