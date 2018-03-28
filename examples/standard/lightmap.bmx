' lightmap.bmx
' lightmapped B3D, use LoadB3D to load from streams

Strict

Framework Openb3d.B3dglgraphics

Local width%=DesktopWidth(),height%=DesktopHeight(),depth%=0,Mode%=2

Graphics3D width,height,depth,Mode

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,10,-15

Local light:TLight=CreateLight()

' load anim mesh
Local ent:TMesh=Null
Local loader%=1
Select loader
	Case 1
		ent=LoadAnimMesh("../media/bath/RomanBath.b3d")
		
	Default ' load library mesh
		ent=LoadAnimMeshLib("../media/bath/RomanBath.b3d")
EndSelect

' child entity variables
Local child_ent:TEntity ' this will store child entity of anim mesh
Local child_no%=1 ' used to select child entity
Local count_children%=TEntity.CountAllChildren(ent) ' total no. of children belonging to entity

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
	child_ent=ent.GetChildFromAll(child_no,count) ' get child entity

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
	
	Text 0,20,"FPS: "+fps
	Text 0,40,"[] to select different child entity (bone)"
	If child_ent<>Null
		Text 0,60,"Child Name: "+EntityName(child_ent)
		
		Local test:TEntity=FindChild(ent,EntityName(child_ent))
		If test<>Null Then Text 0,80,"FindChild: "+EntityName(test)
	EndIf
	Text 0,100,"Children: "+count_children
	
	Flip
	
Wend
End
