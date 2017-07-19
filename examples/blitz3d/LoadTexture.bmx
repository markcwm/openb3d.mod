' LoadTexture.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight()

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,5

' Load texture
Local tex:TTexture=LoadTexture("../media/b3dlogo.jpg")

' Texture cube with texture
EntityTexture cube,tex


While Not KeyDown( KEY_ESCAPE )

	Local pitch#=0
	Local yaw#=0
	Local roll#=0

	If KeyDown( KEY_DOWN )=True Then pitch#=-1	
	If KeyDown( KEY_UP )=True Then pitch#=1
	If KeyDown( KEY_LEFT )=True Then yaw#=-1
	If KeyDown( KEY_RIGHT )=True Then yaw#=1
	If KeyDown( KEY_X )=True Then roll#=-1
	If KeyDown( KEY_Z )=True Then roll#=1

	TurnEntity cube,pitch#,yaw#,roll#
	
	RenderWorld
	Flip

Wend

End
