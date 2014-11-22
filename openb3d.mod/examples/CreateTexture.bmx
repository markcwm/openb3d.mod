' CreateTexture.bmx
' from Blitz3D help

Strict

Framework angros.b3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,5

' Create texture of size 256x256
Local tex:TTexture=CreateTexture(256,256)
	
BeginMax2D()

' Clear texture buffer with background white color
SetClsColor 255,255,255
Cls

' Draw text on texture
Local font:TImageFont=LoadImageFont("arial",24)
SetImageFont font
SetColor 0,0,0
DrawText "This texture",0,0
DrawText "was created using",0,40
SetColor 0,0,255
DrawText "CreateTexture()",0,80
SetColor 0,0,0
DrawText "and drawn to using",0,120
SetColor 0,0,255
DrawText "GrabPixmap() and BufferToTex()",0,160

EndMax2D()

Local pix:TPixmap=GrabPixmap(0,0,256,256)
If PixmapFormat(pix)<>PF_RGBA8888 Then pix=ConvertPixmap(pix,PF_RGBA8888)

BufferToTex(tex,PixmapPixelPtr(pix,0,0))

EntityTexture cube,tex


While Not KeyDown(KEY_ESCAPE)

	Local pitch#=0
	Local yaw#=0
	Local roll#=0

	If KeyDown( key_down )=True Then pitch#=-1	
	If KeyDown( key_up )=True Then pitch#=1
	If KeyDown( key_left )=True Then yaw#=-1
	If KeyDown( key_right )=True Then yaw#=1
	If KeyDown( key_z )=True Then roll#=-1
	If KeyDown( key_x )=True Then roll#=1

	TurnEntity cube,pitch#,yaw#,roll#
	
	RenderWorld
	Flip
Wend
End
