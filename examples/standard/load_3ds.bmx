' load_3ds.bmx
' 3DS loader from Warner engine (by Bramdenhond)
' loads meshes with single surface, pretransforms vertices but may need reorientation

Strict

Framework Openb3d.B3dglgraphics
Import Koriolis.Zipstream

Incbin "../media/rallycar1.3ds"
Incbin "../media/RALLYCAR.JPG"

Graphics3D DesktopWidth(),DesktopHeight()

Local camera:TCamera=CreateCamera()
PositionEntity camera,0,35,-35

Local light:TLight=CreateLight()
RotateEntity light,45,45,0

Local mesh:TMesh, debug:String, oldtime:Int

Local loader:Int=5 ' set 0..5
Select loader

	Case 1 ' load rallycar1 mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/rallycar1.3ds")
		
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 2 ' load mak_robotic mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/mak_robotic.3ds")
		
		mesh.RotateAnimMesh(0,-90,0)
		mesh.ScaleAnimMesh(0.5,0.5,0.5)
		
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 3 ' load phineas4 mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/phineas4.3ds")
		
		mesh.RotateAnimMesh(0,-90,-45)
		mesh.PositionAnimMesh(0,10,0)
		
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 4 ' load incbin mesh (texture must be applied manually)
		oldtime=MilliSecs()
		Local file:String = "incbin::../media/rallycar1.3ds"
		mesh=LoadMesh3DS(file)
		file = "incbin::../media/RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9|TEX_STREAM)
		
		For Local child:Int=1 To CountChildren(mesh)
			EntityTexture TMesh(GetChild(mesh, child)),tex
		Next
		
		debug="3DS incbin time="+(MilliSecs()-oldtime)
		
	Case 5 ' load zip mesh (texture must be applied manually)
		oldtime=MilliSecs()
		Local zipfile:String = "../media/rallycar.zip"
		Local file:String = "zip::"+zipfile+"//rallycar1.3ds"
		mesh=LoadMesh3DS(file)
		file = "zip::"+zipfile+"//RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9|TEX_STREAM)
		
		For Local child:Int=1 To CountChildren(mesh)
			EntityTexture TMesh(GetChild(mesh, child)),tex
		Next
		
		debug="3DS zip time="+(MilliSecs()-oldtime)
		
	Default ' load openb3d mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/rallycar1.3ds")
		
		mesh.RotateMesh(-90,0,0)
		mesh.ScaleMesh(0.05, 0.05, 0.05)
		
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
