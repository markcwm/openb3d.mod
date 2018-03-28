' load_md2.bmx
' vertex interpolated animations

Strict

Framework Openb3d.B3dglgraphics

Local width%=DesktopWidth(),height%=DesktopHeight(),depth%=0,Mode%=2

Graphics3D width,height,depth,Mode

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,10,-60

Local light:TLight=CreateLight()

Local ent:TMesh=LoadAnimMeshLib("../media/tris.md2")
RotateEntity ent,-90,180,0

Local tex:TTexture=LoadTexture("../media/skin.jpg")
EntityTexture ent,tex

Local anim_time#=0.0

' used by fps code
Local old_ms%=MilliSecs()
Local renders%=0, fps%=0


While Not KeyDown(KEY_ESCAPE)

	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' change anim time values
	If KeyDown(KEY_MINUS) Then anim_time=anim_time-0.1
	If KeyDown(KEY_EQUALS) Then anim_time=anim_time+0.1
	
	If ent Then SetAnimTime(ent,anim_time)
	
	If KeyHit(KEY_F) And ent
		FreeEntity(ent) 
		ent=Null
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
	
	Text 0,20,"FPS: "+fps
	Text 0,40,"+/-: animate, F: free entity"
	Text 0,60,"Arrows: turn camera, WSAD: move camera"
	
	Flip
	
Wend
End
