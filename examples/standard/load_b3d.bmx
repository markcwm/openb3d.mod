' load_b3d.bmx
' loads meshes with multiple surfaces

Strict

Framework Openb3d.B3dglgraphics
Import Koriolis.Zipstream

Incbin "../media/zombie.b3d"
Incbin "../media/Zombie.jpg"

Graphics3D DesktopWidth(),DesktopHeight()

Local camera:TCamera=CreateCamera()
PositionEntity camera,0,35,-35

Local light:TLight=CreateLight()
RotateEntity light,45,45,0

Local mesh:TMesh, debug:String, oldtime:Int

Local loader:Int=5 ' 0 to 5
Select loader

	Case 1 ' load stream mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("../media/zombie.b3d")
		
		debug="b3d time="+(MilliSecs()-oldtime)
		
	Case 2 ' load Bird mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("../media/Bird.b3d")
		
		debug="b3d time="+(MilliSecs()-oldtime)
		
	Case 3 ' load castle1 mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("../media/castle1.b3d")
		
		debug="b3d time="+(MilliSecs()-oldtime)
		
	Case 4 ' load incbin mesh
		oldtime=MilliSecs()
		Local file:String = "incbin::../media/zombie.b3d"
		mesh=LoadAnimMeshStream(file)
		
		debug="incbin time="+(MilliSecs()-oldtime)
		
	Case 5 ' load zip mesh
		oldtime=MilliSecs()
		Local zipfile:String = "../media/zombie.zip"
		Local file:String = "zip::"+zipfile+"//zombie.b3d"
		mesh=LoadAnimMeshStream(file)
		
		debug="zip time="+(MilliSecs()-oldtime)
		
	Default ' load library mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMesh("../media/zombie.b3d")
		
		debug="lib time="+(MilliSecs()-oldtime)
EndSelect

Local anim_time#=0.0

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%

If MeshHeight(mesh)<100 Then PointEntity camera,mesh


While Not KeyDown( KEY_ESCAPE )

	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	If KeyDown(KEY_I) Then TurnEntity mesh,0.5,0,0
	If KeyDown(KEY_K) Then TurnEntity mesh,-0.5,0,0
	If KeyDown(KEY_J) Then TurnEntity mesh,0,2.5,0
	If KeyDown(KEY_L) Then TurnEntity mesh,0,-2.5,0
	
	' change anim time values
	If KeyDown(KEY_MINUS) Then anim_time=anim_time-0.1
	If KeyDown(KEY_EQUALS) Then anim_time=anim_time+0.1
	
	If mesh Then SetAnimTime(mesh,anim_time)
	
	If KeyHit(KEY_F) And mesh
		FreeEntity(mesh) 
		mesh=Null
	EndIf
	
	UpdateWorld
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,20,"FPS: "+fps+", Debug: "+debug
	Text 0,40,"+/-: animate, F: free entity"
	Text 0,60,"WSAD/Arrows: move camera, IKJL: turn mesh"
	If mesh
		Text 0,80,"mesh depth="+MeshDepth(mesh)+" height="+MeshHeight(mesh)
		Text 0,100,"mesh rot="+EntityPitch(mesh)+","+EntityYaw(mesh)+","+EntityRoll(mesh)
	EndIf
	
	Flip
Wend
End
