' load_dds.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()
PositionEntity camera,0,2,-7

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

Local dxt1:TMesh=CreateCube()
Local dxt3:TMesh=CreateCube()
Local dxt5:TMesh=CreateCube()
Local rgba:TMesh=CreateCube()

PositionEntity dxt1,-5,0,0
PositionEntity dxt3,5,0,0
PositionEntity dxt5,0,0,0
PositionEntity rgba,0,5,0

Local dxt1_tex:TTexture=LoadTexture("../media/dxt1.dds")
Local dxt3_tex:TTexture=LoadTexture("../media/dxt3.dds")
Local dxt5_tex:TTexture=LoadTexture("../media/dxt5.dds")
Local rgba_tex:TTexture=LoadTexture("../media/dds_rgba.dds") ' uncompressed DDS

EntityTexture dxt1,dxt1_tex
EntityTexture dxt3,dxt3_tex
EntityTexture dxt5,dxt5_tex
EntityTexture rgba,rgba_tex


While Not KeyHit(KEY_ESCAPE)

	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	
	TurnEntity dxt1,0,1,0
	TurnEntity dxt3,0,1,0
	TurnEntity dxt5,0,1,0
	TurnEntity rgba,0,1,0
	
	UpdateWorld
	RenderWorld
	
	Text 0,20,"WSAD: move camera"
	
	Flip
	
Wend

FreeTexture dxt1_tex
FreeTexture dxt3_tex
FreeTexture dxt5_tex
FreeTexture rgba_tex

End
