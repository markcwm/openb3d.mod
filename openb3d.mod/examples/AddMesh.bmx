' AddMesh.bmx
' from Blitz3D help

Strict

Framework Angros.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
PositionEntity camera,0,0,-10

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

' Create tree mesh (upper half)
Local tree:TMesh=CreateCone()
Local green_br:TBrush=LoadBrush("media/Envwall.bmp")
'Local green_br:TBrush=CreateBrush(0,255,0)
PaintMesh tree,green_br
ScaleMesh tree,2,2,2
PositionMesh tree,0,1.5,0

' Create trunk mesh
Local trunk:TMesh=CreateCylinder()
Local brown_br:TBrush=LoadBrush("media/sand.bmp")
'Local brown_br:TBrush=CreateBrush(128,64,0)
PaintMesh trunk,brown_br
PositionMesh trunk,0,-1.5,0

' Add trunk mesh to tree mesh, to form one whole tree
AddMesh trunk,tree

' Free trunk mesh - we don't need it anymore
FreeEntity trunk

While Not KeyDown(KEY_ESCAPE)

	TurnEntity tree,1,1,1
	
	RenderWorld
	Flip
	
Wend
End
