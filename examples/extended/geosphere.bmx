' geosphere.bmx
' freebasic.net/forum/viewtopic.php?p=198556#p198556

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraRange camera,0.00001,100
MoveEntity camera,0,0,-23

Local x:TGeosphere=LoadGeosphere("../media/srtm_ramp2.world.jpg") ' heightmap
'Local x:TTerrain=CreateGeosphere(2700)
ScaleEntity x,0.01,0.01,0.01

Local light:TLight=CreateLight()
MoveEntity light,10,10,10
PointEntity light,x

Local tex:TTexture=LoadTexture("../media/MapOfEarth.jpg") ' colormap
Local mapheight%=1350
ScaleTexture tex,mapheight,mapheight
EntityTexture x,tex

EntityPickMode x,2
Local sphere:TMesh=CreateSphere()
ScaleEntity sphere,0.1,0.1,0.1
EntityColor sphere,255,0,0

EntityType camera,1
EntityRadius camera,0.03
EntityType x,2
Collisions 1,2,2,2 ' set collisons: 2 = elipsoid-polygon method, 2 = full-slide reponse

Local wiretoggle%=-1


While Not KeyDown(KEY_ESCAPE)

	' zoom
	If KeyDown(KEY_A) Then MoveEntity camera,0,0,0.08
	If KeyDown(KEY_Z) Then MoveEntity camera,0,0,-0.08
	
	' move camera
	If KeyDown(KEY_UP) Then TurnEntity camera,-0.5,0,0,0
	If KeyDown(KEY_DOWN) Then TurnEntity camera,0.5,0,0,0
	If KeyDown(KEY_LEFT) Then TurnEntity camera,0,0.5,0,0
	If KeyDown(KEY_RIGHT) Then TurnEntity camera,0,-0.5,0,0
	
	' spin geosphere
	If KeyDown(KEY_SPACE) Then TurnEntity x,0,0.5,0
	
	' wireframe
	If KeyHit(KEY_W) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe True Else Wireframe False
	
	CameraPick camera,MouseX(),MouseY()
	PositionEntity sphere,PickedX(),PickedY(),PickedZ()
	
	UpdateWorld 1
	RenderWorld
	
	Text 0,0,"A/Z: zoom, Arrows: move camera, Space: spin geo, W: wireframe"
	Text 0,20,"x = "+EntityX(camera)+" y = "+EntityY(camera)+" z = "+EntityZ(camera)

	Flip

Wend
