' hardwareinfo.bmx

Import Angros.Openb3d

Strict

Local width%=320,height%=240,depth%=0,hertz%=60

Graphics width,height,depth,hertz ' get context

THardwareInfo.GetInfo
THardwareInfo.DisplayInfo 0 ' true for logfile

EndGraphics

Graphics3D THardwareInfo.ScreenWidth,THardwareInfo.ScreenHeight,depth,2,THardwareInfo.ScreenHertz

Local cam:TCamera=CreateCamera()

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3

While Not KeyDown(KEY_ESCAPE)		

	RenderWorld
	
	TurnEntity cube,0.0,0.5,-0.1
	
	Flip
	
Wend
End
