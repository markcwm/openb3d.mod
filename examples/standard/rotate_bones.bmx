' rotate_bones.bmx
' using manual animation mode

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight()

SetMeshLoader 2 ' 1 for streams (default), 2 for library

Local camera:TCamera=CreateCamera()
Local anim_ent:TMesh=LoadAnimMesh("../media/zombie.b3d")

PositionEntity camera,0,10,-30
'Animate anim_ent,1,0.1

Local joint1:TEntity = FindChild(anim_ent,"Joint8")
Local joint2:TEntity = FindChild(anim_ent,"Joint10")
Local anim_time#=0, joint1_y#, joint2_y#


While Not KeyHit(KEY_ESCAPE)

	If KeyDown(KEY_A) Then joint1_y:-1
	If KeyDown(KEY_D) Then joint1_y:+1
	If KeyDown(KEY_Q) Then joint2_y:-1
	If KeyDown(KEY_E) Then joint2_y:+1
	
	' unlike Blitz3d, animated meshes are deformed by UpdateWorld so to manipulate bones we must use manual animation
	anim_time:+0.25
	If anim_time>20 Then anim_time=2
	SetAnimTime anim_ent,anim_time ' set animation frame, also disables mode
	Animate anim_ent,4 ' set mode: 1=loop, 2=ping-pong, 3=one-time, 4=manual
	
	' move bones before UpdateWorld
	If joint1<>Null Then RotateEntity joint1,0,joint1_y,0
	If joint2<>Null Then RotateEntity joint2,0,joint2_y,0
	
	UpdateWorld
	
	RenderWorld
	
	Text 0,20,"+/- to animate, anim_time: "+anim_time
	Text 0,40,"Q/E: rotate joint1, A/D: rotate joint2"
	
	Flip
Wend
End
