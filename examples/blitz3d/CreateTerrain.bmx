' CreateTerrain.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight()

Local size:Int=256, vsize:Float=30, maxheight:Float=10
Local camx:Float=size/2, camz:Float=-size/2

Local camera:TCamera=CreateCamera()
CameraClsColor camera,150,200,250
PositionEntity camera,camx,maxheight+1,camz
TurnEntity camera,0,50,0

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local sphere:TMesh=CreateSphere()
PositionEntity sphere,camx,maxheight,camz

' Create terrain
Local terrain:TTerrain=CreateTerrain(size)

Local map:TPixmap=LoadPixmap("../media/heightmap_256.bmp")
For Local iy%=0 To PixmapWidth(map)-1
	For Local ix%=0 To PixmapHeight(map)-1
		Local height:Float=ReadPixel(map,ix,iy) & $FF
		height=height/255 ' 255 to 1, 1=30M
		ModifyTerrain terrain,ix,iy,(height/vsize)*maxheight
	Next
Next

' Correct lighting
terrain.UpdateNormals()

' Texture terrain
Local grass_tex:TTexture=LoadTexture( "../media/terrain-1.jpg" )
EntityTexture terrain,grass_tex
ScaleTexture grass_tex,10,10

While Not KeyDown( KEY_ESCAPE )

	If KeyDown( KEY_RIGHT )=True Then TurnEntity camera,0,-1,0
	If KeyDown( KEY_LEFT )=True Then TurnEntity camera,0,1,0
	If KeyDown( KEY_DOWN )=True Then MoveEntity camera,0,0,-0.5
	If KeyDown( KEY_UP )=True Then MoveEntity camera,0,0,0.5
	
	RenderWorld
	
	Text 0,20,"Use cursor keys to move about the terrain"
	Text 0,40,"X="+EntityX(camera)+", Y="+EntityY(camera)+", Z="+EntityZ(camera)
	
	Flip
Wend
End
