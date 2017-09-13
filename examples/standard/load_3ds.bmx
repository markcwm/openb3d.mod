' load_3ds.bmx
' 3DS loader from Warner engine (by Bramdenhond)
' loads meshes with single surface, pretransforms vertices but orientation usually needs a tweak

Strict

Framework Openb3d.B3dglgraphics
Import Koriolis.Zipstream

Incbin "../media/rallycar1.3ds"
Incbin "../media/RALLYCAR.JPG"

Graphics3D DesktopWidth(),DesktopHeight()

Local size:Int=256, vsize:Float=30, maxheight:Float=10
Local camx:Float=size/2, camz:Float=-size/2

Local camera:TCamera=CreateCamera()
PositionEntity camera,camx,maxheight+5,camz-30

Local light:TLight=CreateLight()
RotateEntity light,45,45,0

Local terrain:TTerrain=LoadTerrain("../media/heightmap_256.BMP") ' path case-sensitive on Linux
ScaleEntity terrain,1,(1*maxheight)/vsize,1 ' set height
terrain.UpdateNormals() ' correct lighting

' Texture terrain
Local grass_tex:TTexture=LoadTexture( "../media/terrain-1.jpg" )
EntityTexture terrain,grass_tex
ScaleTexture grass_tex,10,10

Local mesh:TMesh, debug:String, oldtime:Int

Local loader:Int=1 ' set 0..5
Select loader

	Case 1 ' load rallycar1 mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/rallycar1.3ds")
		
		PositionEntity mesh,camx,maxheight,camz
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 2 ' load mak_robotic mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/mak_robotic.3ds")
		
		mesh.RotateAnimMesh(0,-90,0)
		mesh.ScaleAnimMesh(0.5,0.5,0.5)
		
		PositionEntity mesh,camx,maxheight,camz
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 3 ' load phineas4 mesh
		oldtime=MilliSecs()
		mesh=LoadMesh3DS("../media/phineas4.3ds")
		
		mesh.RotateAnimMesh(0,-90,-45)
		mesh.PositionAnimMesh(0,10,0)
		
		PositionEntity mesh,camx,maxheight,camz
		debug="3DS time="+(MilliSecs()-oldtime)
		
	Case 4 ' load incbin mesh (and texture as file not found)
		oldtime=MilliSecs()
		Local file:String = "incbin::../media/rallycar1.3ds"
		mesh=LoadMesh3DS(file)
		file = "incbin::../media/RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9,True)
		
		For Local child:Int=1 To CountChildren(mesh)
			EntityTexture TMesh(GetChild(mesh, child)),tex
		Next
		
		PositionEntity mesh,camx,maxheight,camz
		debug="3DS incbin time="+(MilliSecs()-oldtime)
		
	Case 5 ' load zip mesh (and texture as file not found)
		oldtime=MilliSecs()
		Local zipfile:String = "../media/rallycar.zip"
		Local file:String = "zip::"+zipfile+"//rallycar1.3ds"
		mesh=LoadMesh3DS(file)
		file = "zip::"+zipfile+"//RALLYCAR.JPG"
		Local tex:TTexture=LoadTexture(file,9,True)
		
		For Local child:Int=1 To CountChildren(mesh)
			EntityTexture TMesh(GetChild(mesh, child)),tex
		Next
		
		PositionEntity mesh,camx,maxheight,camz
		debug="3DS zip time="+(MilliSecs()-oldtime)
		
	Default ' load openb3d mesh
		oldtime=MilliSecs()
		mesh=LoadMesh("../media/rallycar1.3ds")
		
		mesh.RotateMesh(-90,0,0)
		mesh.ScaleMesh(0.05, 0.05, 0.05)
		
		PositionEntity mesh,camx,maxheight,camz
		debug="openb3d time="+(MilliSecs()-oldtime)
EndSelect


While Not KeyDown( KEY_ESCAPE )

	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	
	If KeyDown(KEY_UP) Then TurnEntity mesh,0.5,0,0
	If KeyDown(KEY_DOWN) Then TurnEntity mesh,-0.5,0,0
	If KeyDown(KEY_LEFT) Then TurnEntity mesh,0,1,0
	If KeyDown(KEY_RIGHT) Then TurnEntity mesh,0,-1,0
	
	RenderWorld
	
	Text 0,20,"WSAD: move camera, Arrows: turn mesh"
	Text 0,40,"mesh pos="+EntityX(mesh)+","+EntityY(mesh)+","+EntityZ(mesh)
	Text 0,60,"mesh rot="+EntityPitch(mesh)+","+EntityYaw(mesh)+","+EntityRoll(mesh)
	
	Flip
Wend
End
