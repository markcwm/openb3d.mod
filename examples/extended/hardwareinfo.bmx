' hardwareinfo.bmx

Strict

Framework Openb3d.B3dglgraphics

Local width%=DesktopWidth(),height%=DesktopHeight(),depth%=0,hertz%=60

SetGraphicsDriver GLMax2DDriver() ' needed before init in Windows

Graphics width,height,depth,hertz ' get context

THardwareInfo.GetInfo()
THardwareInfo.DisplayInfo(0) ' True to write to HardwareInfo.txt

EndGraphics

Graphics3D DesktopWidth()/1.1,DesktopHeight()/1.1,depth,2,DesktopHertz()

Local cam:TCamera=CreateCamera()

Local light:TLight=CreateLight(2)
PositionEntity light,0,1000,-1000

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3

While Not KeyDown(KEY_ESCAPE)		

	RenderWorld
	
	TurnEntity cube,0.0,0.5,-0.1
	
	Flip
	
Wend
End
