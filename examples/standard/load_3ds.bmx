' load_3ds.bmx
' Minib3d mesh loaders

Strict

Framework Openb3d.B3dglgraphics
Import Koriolis.Zipstream

Incbin "../media/rallycar1.3ds"
Incbin "../media/RALLYCAR.JPG"

Graphics3D DesktopWidth(),DesktopHeight()

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local zipfile:String = "../media/rallycar.zip"
Local rallycar:TMesh
Local debug:String, oldtime:Int

Local minib3d:Int=1 ' set 0..3
Select minib3d

	Case 1 ' load minib3d mesh
		oldtime=MilliSecs()
		rallycar=mbLoadMesh("../media/rallycar1.3ds")
		
		TMesh(GetChild(rallycar, 1)).PositionMesh(40,-120,-50)
		TMesh(GetChild(rallycar, 2)).PositionMesh(-40,-120,-50)
		TMesh(GetChild(rallycar, 3)).PositionMesh(-40,0,-50)
		TMesh(GetChild(rallycar, 4)).PositionMesh(40,0,-50)
		TMesh(GetChild(rallycar, 5)).PositionMesh(0,0,-50)
		
		For Local child:Int=1 To CountChildren(rallycar)
			TMesh(GetChild(rallycar, child)).RotateMesh(-90,0,0)
		Next
		
		PositionEntity rallycar,0,0,MeshDepth(rallycar)*3
		debug="minib3d time="+(MilliSecs()-oldtime)
		
	Case 2 ' load incbin mesh (and texture as file not found)
		oldtime=MilliSecs()
		Local file:String = "incbin::../media/rallycar1.3ds"
		rallycar = mbLoadMesh(file)
		file = "incbin::../media/RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9,True)
		
		TMesh(GetChild(rallycar, 1)).PositionMesh(40,-120,-50)
		TMesh(GetChild(rallycar, 2)).PositionMesh(-40,-120,-50)
		TMesh(GetChild(rallycar, 3)).PositionMesh(-40,0,-50)
		TMesh(GetChild(rallycar, 4)).PositionMesh(40,0,-50)
		TMesh(GetChild(rallycar, 5)).PositionMesh(0,0,-50)
		
		For Local child:Int=1 To CountChildren(rallycar)
			EntityTexture TMesh(GetChild(rallycar, child)),tex
			TMesh(GetChild(rallycar, child)).RotateMesh(-90,0,0)
		Next
		
		PositionEntity rallycar,0,0,MeshDepth(rallycar)*3
		debug="incbin time="+(MilliSecs()-oldtime)
		
	Case 3 ' load zip mesh (and texture as file not found)
		oldtime=MilliSecs()
		Local file:String = "zip::"+zipfile+"//rallycar1.3ds"
		rallycar = mbLoadMesh(file)
		file = "zip::"+zipfile+"//RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9,True)
		
		TMesh(GetChild(rallycar, 1)).PositionMesh(40,-120,-50)
		TMesh(GetChild(rallycar, 2)).PositionMesh(-40,-120,-50)
		TMesh(GetChild(rallycar, 3)).PositionMesh(-40,0,-50)
		TMesh(GetChild(rallycar, 4)).PositionMesh(40,0,-50)
		TMesh(GetChild(rallycar, 5)).PositionMesh(0,0,-50)
		
		For Local child:Int=1 To CountChildren(rallycar)
			EntityTexture TMesh(GetChild(rallycar, child)),tex
			TMesh(GetChild(rallycar, child)).RotateMesh(-90,0,0)
		Next
		
		PositionEntity rallycar,0,0,MeshDepth(rallycar)*3
		debug="zip time="+(MilliSecs()-oldtime)
		
	Default ' load openb3d mesh
		oldtime=MilliSecs()
		rallycar=LoadMesh("../media/rallycar1.3ds")
		
		rallycar.RotateMesh(-90,0,0)
		
		PositionEntity rallycar,0,0,MeshDepth(rallycar)
		debug="openb3d time="+(MilliSecs()-oldtime)
EndSelect


While Not KeyDown( KEY_ESCAPE )

	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	
	TurnEntity rallycar,0,0.5,0
	
	RenderWorld
	
	Text 0,20,"WSAD: move camera"
	Text 0,40,debug
	
	Flip
Wend
End
