' lightmap.bmx
' lightmapped B3D

Strict

Framework Openb3d.B3dglgraphics
Import Koriolis.Zipstream

Incbin "../media/test/test.b3d"
Incbin "../media/test/shingle.bmp"
Incbin "../media/test/test_lm.bmp"

Local width%=DesktopWidth(),height%=DesktopHeight(),depth%=0,Mode%=2

Graphics3D width,height,depth,Mode

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,10,-15

Local light:TLight=CreateLight()

Local mesh:TMesh, debug:String, oldtime:Int

' load anim mesh
Local loader%=2
Select loader
	Case 1 ' load stream mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("../media/bath/RomanBath.b3d")
		
		debug="b3d time="+(MilliSecs()-oldtime)
		
	Case 2 ' load incbin mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("incbin::../media/test/test.b3d")
		
		debug="incbin time="+(MilliSecs()-oldtime)
		
	Case 3 ' load zip mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMeshStream("zip::../media/RomanBath.zip//RomanBath.b3d")
		
		debug="zip time="+(MilliSecs()-oldtime)
		
	Default ' load library mesh
		oldtime=MilliSecs()
		mesh=LoadAnimMesh("../media/bath/RomanBath.b3d")
		
		debug="lib time="+(MilliSecs()-oldtime)
EndSelect

' child entity variables
Local child_ent:TEntity ' this will store child entity of anim mesh
Local child_no%=1 ' used to select child entity
Local count_children%=TEntity.CountAllChildren(mesh) ' total no. of children belonging to entity

' marker entity. will be used to highlight selected child entity
Local marker_ent:TMesh=CreateSphere(8)
EntityColor marker_ent,255,255,0
ScaleEntity marker_ent,.25,.25,.25
EntityOrder marker_ent,-1

' used by fps code
Local old_ms%=MilliSecs()
Local renders%=0, fps%=0


While Not KeyDown(KEY_ESCAPE)		

	If KeyHit(KEY_ENTER) Then DebugStop

	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' select child entity
	If KeyHit(KEY_OPENBRACKET) Then child_no=child_no-1
	If KeyHit(KEY_CLOSEBRACKET) Then child_no=child_no+1
	If child_no<1 Then child_no=1
	If child_no>count_children Then child_no=count_children
	
	' get child entity
	Local count%=0 ' this is just a count variable needed by GetChildFromAll. must be set to 0.
	child_ent=mesh.GetChildFromAll(child_no,count) ' get child entity

	' position marker entity at child entity position
	If child_ent<>Null
		PositionEntity marker_ent,EntityX(child_ent,True),EntityY(child_ent,True),EntityZ(child_ent,True)
	EndIf
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,20,"FPS: "+fps+", Debug: "+debug
	Text 0,40,"[] to select different child entity (bone)"
	If child_ent<>Null
		Text 0,60,"Child Name: "+EntityName(child_ent)
		
		Local test:TEntity=FindChild(mesh,EntityName(child_ent))
		If test<>Null Then Text 0,80,"FindChild: "+EntityName(test)
	EndIf
	Text 0,100,"Children: "+count_children
	
	Flip
	
Wend
End
