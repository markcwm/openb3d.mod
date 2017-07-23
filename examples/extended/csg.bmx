' csg.bmx
' constructive solid geometry

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local cam:TCamera=CreateCamera()
MoveEntity cam,0,0,-5
CameraClsColor cam,70,180,235

Local light:TLight=CreateLight(1)
LightColor light,100,100,150

Local tube:TMesh=CreateCylinder(32)
PositionEntity tube,0.75,-0.75,0.75

Local tube2:TMesh=CreateCylinder(32)
HideEntity tube
HideEntity tube2

Local csg:TMesh=MeshCSG(tube,tube2,0) ' 0=subtract
Local csg2:TMesh=MeshCSG(tube,tube2,1) ' 1=add
Local csg3:TMesh=MeshCSG(tube,tube2,2) ' 2=intersect
HideEntity csg2
HideEntity csg3

Local meshmethod%, meshflip%


While Not KeyDown(KEY_ESCAPE)

	' change csg method
	If KeyHit(KEY_M)
		meshmethod:+1
		If meshmethod>2 Then meshmethod=0
		If meshmethod=0 Then HideEntity csg3 ; ShowEntity csg
		If meshmethod=1 Then HideEntity csg ; ShowEntity csg2
		If meshmethod=2 Then HideEntity csg2 ; ShowEntity csg3	
	EndIf
	
	If KeyHit(KEY_F)
		meshflip=Not meshflip
		FlipMesh csg
		FlipMesh csg2
		FlipMesh csg3
	EndIf
	
	TurnEntity csg,0,0.5,-0.1
	TurnEntity csg2,0,0.5,-0.1
	TurnEntity csg3,0,0.5,-0.1
	
	RenderWorld
	
	Text 0,20,"M: meshmethod = "+meshmethod+", F: meshflip = "+meshflip
	
	Flip

Wend
End
