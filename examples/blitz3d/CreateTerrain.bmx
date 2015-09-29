' CreateTerrain.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600


Local camera:TCamera=CreateCamera()
PositionEntity camera,130,1,-130
TurnEntity camera,0,50,0

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

' Create terrain
Local terrain:TTerrain=CreateTerrain(128)

' Texture terrain
Local grass_tex:TTexture=LoadTexture( "../media/Moss.bmp" )
EntityTexture terrain,grass_tex

While Not KeyDown( KEY_ESCAPE )

	If KeyDown( KEY_RIGHT )=True Then TurnEntity camera,0,-1,0
	If KeyDown( KEY_LEFT )=True Then TurnEntity camera,0,1,0
	If KeyDown( KEY_DOWN )=True Then MoveEntity camera,0,0,-0.05
	If KeyDown( KEY_UP )=True Then MoveEntity camera,0,0,0.05
	
	RenderWorld
	
	Text 0,0,"Use cursor keys to move about the terrain"+EntityX(camera)+" "+EntityZ(camera)
	
	Flip
Wend
End
