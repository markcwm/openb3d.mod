' LoadAnimTexture.bmx

Strict

Framework Openb3d.B3dglgraphics

Incbin "../media/boomstrip.bmp"

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local cube:TMesh=CreateCube()
PositionEntity cube,-2,0,5

Local cube2:TMesh=CreateCube()
PositionEntity cube2,2,0,5

Local tex:TTexture=LoadTextureStream("../media/b3dlogo.jpg")
EntityTexture cube2,tex

' Load anim texture
Local oldtime%=MilliSecs()
Local anim_tex:TTexture=LoadAnimTextureStream( "incbin::../media/boomstrip.bmp",49,64,64,0,39 )
Local debug$="incbin time="+(MilliSecs()-oldtime)

Local frame%
Local pitch#,yaw#,roll#

While Not KeyDown(KEY_ESCAPE)

	' Cycle through anim frame values. 100 represents Delay, 39 represents no. of  anim frames
	frame=MilliSecs()/100 Mod 39
	
	' Texture cube with anim texture frame
	EntityTexture cube,anim_tex,frame
	
	pitch#=0
	yaw#=0
	roll#=0
	
	If KeyDown(KEY_DOWN)=True Then pitch#=-1
	If KeyDown(KEY_UP)=True Then pitch#=1
	If KeyDown(KEY_LEFT)=True Then yaw#=-1
	If KeyDown(KEY_RIGHT)=True Then yaw#=1
	If KeyDown(KEY_X)=True Then roll#=-1
	If KeyDown(KEY_Z)=True Then roll#=1
	
	TurnEntity cube,pitch#,yaw#,roll#
	TurnEntity cube2,pitch#,-yaw#,roll#
	
	RenderWorld
	
	Text 0,20,"Arrows: turn cubes, anim texture frame="+frame+", Debug: "+debug
	
	Flip
Wend
End
