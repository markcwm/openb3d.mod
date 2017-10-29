' load_b3d.bmx
' B3D loader from Minib3d (by Simon Harrison)
' loads meshes with multiple surfaces, reorientation should not be needed

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

Local minib3d:Int=1 ' set 0..5
Select minib3d

	Case 1 ' load zombie mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/zombie.b3d")
		
		debug="minib3d time="+(MilliSecs()-oldtime)
		
	Case 2 ' load Bird mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/Bird.b3d")
		
		debug="minib3d time="+(MilliSecs()-oldtime)
		
	Case 3 ' load castle1 mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/castle1.b3d")
		
		debug="minib3d time="+(MilliSecs()-oldtime)
		
	Case 4 ' load incbin mesh (texture must be applied manually)
		oldtime=MilliSecs()
		Local file:String = "incbin::../media/zombie.b3d"
		mesh=LoadMesh(file)
		file = "incbin::../media/Zombie.jpg"
		Local tex:TTexture=LoadTexture(file,9|TEX_STREAM)
		
		EntityTexture mesh,tex
		
		debug="incbin time="+(MilliSecs()-oldtime)
		
	Case 5 ' load zip mesh (texture must be applied manually)
		oldtime=MilliSecs()
		Local zipfile:String = "../media/zombie.zip"
		Local file:String = "zip::"+zipfile+"//zombie.b3d"
		mesh=LoadMesh(file)
		file = "zip::"+zipfile+"//Zombie.jpg"
		Local tex:TTexture=LoadTexture(file,9|TEX_STREAM)
		
		EntityTexture mesh,tex
		
		debug="zip time="+(MilliSecs()-oldtime)
		
	Default ' load openb3d mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/zombie.b3d",Null,False) ' disable usenative
		
		debug="openb3d time="+(MilliSecs()-oldtime)
EndSelect

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
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,20,"FPS: "+fps
	Text 0,40,"WSAD/Arrows: move camera, IKJL: turn mesh"
	Text 0,60,"mesh depth="+MeshDepth(mesh)+" height="+MeshHeight(mesh)
	Text 0,80,"mesh rot="+EntityPitch(mesh)+","+EntityYaw(mesh)+","+EntityRoll(mesh)
	
	Flip
Wend
End
