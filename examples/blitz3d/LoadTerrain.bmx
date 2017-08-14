' LoadTerrain.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight()

Local size:Int=256, vsize:Float=30, maxheight:Float=10
Local camx:Float=size / 2, camz:Float=-size / 2

Local camera:TCamera=CreateCamera()
CameraClsColor camera,150,200,250
PositionEntity camera,camx,maxheight + 1,camz
TurnEntity camera,0,45,0

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local sphere:TMesh=CreateSphere()
PositionEntity sphere,camx,maxheight,camz

Local terrain:TTerrain=LoadTerrain("../media/heightmap_256.BMP") ' path case-sensitive on Linux
ScaleEntity terrain,1,(1*maxheight)/vsize,1 ' set height
terrain.UpdateNormals() ' correct lighting

' Texture terrain
Local grass_tex:TTexture=LoadTexture( "../media/terrain-1.jpg" )
EntityTexture terrain,grass_tex
ScaleTexture grass_tex,10,10


While Not KeyDown( KEY_ESCAPE )

	If KeyDown( KEY_RIGHT )=True Then TurnEntity camera,0,-1,0
	If KeyDown( KEY_LEFT )=True Then TurnEntity camera,0,1,0
	If KeyDown( KEY_DOWN )=True Then MoveEntity camera,0,0,-0.25
	If KeyDown( KEY_UP )=True Then MoveEntity camera,0,0,0.25
	
	UpdateWorld
	RenderWorld
	
	Text 0,20,"Use cursor keys to move about the terrain"
	Text 0,40,"X="+EntityX(camera)+", Z="+EntityZ(camera)
	
	Flip
Wend
End
