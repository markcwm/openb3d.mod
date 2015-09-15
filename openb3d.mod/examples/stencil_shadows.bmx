' stencil_shadows.bmx
' static and dynamic stencil shadows

Strict

Framework Angros.B3dglgraphics
Import Brl.Random

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
PositionEntity camera,-20,10,0
CameraClsColor camera,0,0,255

' set light mode
Local lightmode%=2
Local light:TLight=CreateLight(lightmode)
Local light2:TLight=CreateLight(lightmode)
'CopyList(TLight.light_list)

Local light_piv:TPivot=CreatePivot()
PositionEntity light_piv,50,0,50
Local light_piv2:TPivot=CreatePivot()
PositionEntity light_piv2,50,0,50

Local sphere:TMesh=CreateSphere(8,light_piv)
PositionEntity sphere,0,25,50
EntityColor sphere,255,0,0

Local sphere2:TMesh=CreateSphere(8,light_piv2)
PositionEntity sphere2,0,25,50
EntityColor sphere2,0,255,0

Local plane:TMesh=CreatePlane(16)
MoveEntity plane,0,-1,0
Local tex:TTexture=LoadTexture("media/Moss.bmp")
EntityTexture plane,tex

PointEntity camera,plane
PositionEntity camera,-40,25,55

' set shadow vars
Local static%=1 ' global static or dynamic shadows
Local numtypes%=25 ' number of cubes or cylinders
Local size%=100 ' size of area
Local scolor:Int[]=[75,75,75,0] ' global shadow colors

Local numshadows%=0
Global lightcasters:TMesh[] ' all shadow casters
Global light1shadows:TShadowObject[] ' all lights if dynamic
Global light2shadows:TShadowObject[] ' second shadow array for static shadows

' load anim mesh
Local anim_time#=0
Local animmode%=1
Local ent:TMesh=LoadAnimMesh("media/zombie.b3d")
PositionEntity ent,55,0,50

lightcasters=lightcasters[..numshadows+1] ' resize
light1shadows=light1shadows[..numshadows+1]
light2shadows=light2shadows[..numshadows+1]

lightcasters[numshadows]=ent ' anim at index 0
light1shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
If static=1
	light2shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
EndIf
numshadows:+1 ' increment array index

' load cubes - static shadows need a separate shadow array for each light
For Local i%=0 To numtypes-1
	lightcasters=lightcasters[..numshadows+1]
	light1shadows=light1shadows[..numshadows+1]
	light2shadows=light2shadows[..numshadows+1]
	
	lightcasters[numshadows]=CreateCube()
	PositionEntity lightcasters[numshadows],Rnd(size),0,Rnd(size)
	EntityColor lightcasters[numshadows],Rnd(255),Rnd(255),Rnd(255)
	light1shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
	light1shadows[numshadows].SetShadowColor(scolor[0],scolor[1],scolor[2],scolor[3])
	If static=1
		light2shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
		light2shadows[numshadows].SetShadowColor(scolor[0],scolor[1],scolor[2],scolor[3])
	EndIf
	
	numshadows:+1
Next

' load cylinders
For Local i%=0 To numtypes-1
	lightcasters=lightcasters[..numshadows+1]
	light1shadows=light1shadows[..numshadows+1]
	light2shadows=light2shadows[..numshadows+1]
	
	lightcasters[numshadows]=CreateCylinder()
	PositionEntity lightcasters[numshadows],Rnd(size),1.5,Rnd(size)
	EntityColor lightcasters[numshadows],Rnd(255),Rnd(255),Rnd(255)
	FitMesh lightcasters[numshadows],-1,-1,-1,2,5,2 ' use ScaleMesh/FitMesh but not ScaleEntity
	'ScaleEntity cylinder[i],2,5,2
	light1shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
	light1shadows[numshadows].SetShadowColor(scolor[0],scolor[1],scolor[2],scolor[3])
	If static=1
		light2shadows[numshadows]=CreateShadow(lightcasters[numshadows],static)
		light2shadows[numshadows].SetShadowColor(scolor[0],scolor[1],scolor[2],scolor[3])
	EndIf
	
	numshadows:+1
Next

' initial static shadows render
TurnEntity light_piv2,0,-90,0
PositionEntity light,EntityX(sphere,1),EntityY(sphere,1),EntityZ(sphere,1)	
PositionEntity light2,EntityX(sphere2,1),EntityY(sphere2,1),EntityZ(sphere2,1)
If static=1 Then CastStaticShadows(numshadows,camera,light,light2)

Local wiretoggle%=-1
Local lightmove%=1
Local cylindermove%=1
Local hidelight1%=0
Local hidelight2%=0

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%=0


While Not KeyHit(KEY_ESCAPE) And Not AppTerminate()
	
	If KeyHit(KEY_SPACE) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe True Else Wireframe False
	
	' move camera
	If KeyDown(KEY_PAGEUP) Then TranslateEntity camera,1,0,0
	If KeyDown(KEY_PAGEDOWN) Then TranslateEntity camera,-1,0,0
	If KeyDown(KEY_UP) Then MoveEntity camera,0,0,1
	If KeyDown(KEY_DOWN) Then MoveEntity camera,0,0,-1
	If KeyDown(KEY_LEFT) Then MoveEntity camera,-1,0,0
	If KeyDown(KEY_RIGHT) Then MoveEntity camera,1,0,0	
	
	' start/stop light movement
	If KeyHit(KEY_L) Then lightmove=-lightmove
	If lightmove=1 Then TurnEntity light_piv,0,1,0 ; TurnEntity light_piv2,0,-1,0
	
	' start/stop cylinder movement
	If KeyHit(KEY_C) Then cylindermove=-cylindermove
	If static=0 '  static shadows only work for static casters - causes 'wrong' casting on casters
		For Local j%=1 To numshadows-1
			If cylindermove=1 Then TurnEntity lightcasters[j],0,0.25,-2.5
		Next
	EndIf
	
	' reset static shadows
	If KeyDown(KEY_R)
		If static=1 Then CastStaticShadows(numshadows,camera,light,light2)
	EndIf
		
	' hide/show light1 - hide unwanted static shadows by freeing/re-creating
	If KeyHit(KEY_1)
		hidelight1=Not hidelight1
		If hidelight1
			HideEntity light
			HideEntity sphere
			If static=1
				For Local i%=0 To numshadows-1
					FreeShadow(light1shadows[i])
				Next
				CastStaticShadows(numshadows,camera,light,light2)
			EndIf
		Else
			ShowEntity light
			ShowEntity sphere
			If static=1
				For Local i%=0 To numshadows-1
					light1shadows[i]=CreateShadow(lightcasters[i],static)
				Next
				CastStaticShadows(numshadows,camera,light,light2)
			EndIf
		EndIf
	EndIf
	
	' hide/show light2
	If KeyHit(KEY_2)
		hidelight2=Not hidelight2
		If hidelight2
			HideEntity light2
			HideEntity sphere2
			If static=1
				For Local i%=0 To numshadows-1
					FreeShadow(light2shadows[i])
				Next
				CastStaticShadows(numshadows,camera,light,light2)
			EndIf
		Else
			ShowEntity light2
			ShowEntity sphere2
			If static=1
				For Local i%=0 To numshadows-1
					light2shadows[i]=CreateShadow(lightcasters[i],static)
				Next
				CastStaticShadows(numshadows,camera,light,light2)
			EndIf
		EndIf
	EndIf
	
	' anim mode
	If KeyHit(KEY_A) Then animmode=Not animmode
	If animmode=1 Then anim_time#:+-0.5
	SetAnimTime(ent,anim_time#)
	
	If static=1 And animmode=1 ' shows dynamic with static shadows - anim is just set at array index 0
		CastAnimStaticShadows(numshadows,camera,light,light2)
	EndIf
	
	PositionEntity light,EntityX(sphere,1),EntityY(sphere,1),EntityZ(sphere,1)
	PointEntity light,plane
	PositionEntity light2,EntityX(sphere2,1),EntityY(sphere2,1),EntityZ(sphere2,1)
	PointEntity light2,plane
	
	If static=1 ' must have only one light on for main render or get doubled static shadows
		If hidelight1=1 Then HideEntity light ' light1 off
		If hidelight2=1 Then HideEntity light2 ' light2 off
		If hidelight1=0 And hidelight2=0 Then HideEntity light2 ' light1 on, light2 on - so hide light2
	EndIf
	
	RenderWorld
	
	If static=1
		If hidelight1=1 Then ShowEntity light ' light1 off
		If hidelight2=1 Then ShowEntity light2 ' light2 off
		If hidelight1=0 And hidelight2=0 Then ShowEntity light2 ' light1 on, light2 on
	EndIf
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"Arrows: move camera, L: light movement, C: cylinder movement"
	Text 0,40,"R: reset static shadows, 1/2: hide lights, light mode = "+lightmode
	Text 0,60,"camera position = "+EntityX(camera)+" "+EntityY(camera)+" "+EntityZ(camera)
	
	Flip
	
Wend

Function CastStaticShadows( numshadows,camera:TCamera,light:TLight,light2:TLight )

	Local currdist#, maxdist#=0
	Local light1hid%=light.hide[0]
	Local light2hid%=light2.hide[0]
	
	For Local i%=0 To numshadows-1 ' calculate furthest caster from camera to set camera range
		currdist=EntityDistance(camera,lightcasters[i])
		If currdist>maxdist Then maxdist=currdist
	Next
	
	CameraRange camera,1,maxdist+100 ' shorthen camera range to cap any 'detached' static shadows
	
	If light2hid=0 And light1hid=0 ' light2 on, light1 on - 2 lights, 3 possible states
		ShowEntity light2
		HideEntity light
		For Local i%=1 To numshadows-1
			light2shadows[i].ResetShadow()
		Next
		RenderWorld
		
		HideEntity light2
		ShowEntity light
		For Local i%=1 To numshadows-1
			light1shadows[i].ResetShadow()
		Next
		RenderWorld
		
		ShowEntity light
		ShowEntity light2
	EndIf
	
	If light2hid=1 And light1hid=0 ' light2 off, light1 on
		HideEntity light2
		ShowEntity light
		For Local i%=1 To numshadows-1
			light1shadows[i].ResetShadow()
		Next
		RenderWorld
		
		ShowEntity light
	EndIf
	
	If light2hid=0 And light1hid=1 ' light2 on, light1 off
		ShowEntity light2
		HideEntity light
		For Local i%=1 To numshadows-1
			light2shadows[i].ResetShadow()
		Next
		RenderWorld
		
		ShowEntity light2
	EndIf
	
	CameraRange camera,1,1000
	
End Function

Function CastAnimStaticShadows( numshadows,camera:TCamera,light:TLight,light2:TLight )

	Local currdist#, maxdist#=0
	Local light1hid%=light.hide[0]
	Local light2hid%=light2.hide[0]
	
	For Local i%=0 To numshadows-1 ' calculate furthest caster from camera to set camera range
		currdist=EntityDistance(camera,lightcasters[i])
		If currdist>maxdist Then maxdist=currdist
	Next
	
	CameraRange camera,1,maxdist+100 ' shorthen camera range to cap any 'detached' static shadows
	
	If light2hid=0 And light1hid=0 ' light2 on, light1 on - 2 lights, 3 possible states
		ShowEntity light2
		HideEntity light
		light2shadows[0].ResetShadow()
		RenderWorld
		
		HideEntity light2
		ShowEntity light
		light1shadows[0].ResetShadow()
		RenderWorld
		
		ShowEntity light
		ShowEntity light2
	EndIf
	
	If light2hid=1 And light1hid=0 ' light2 off, light1 on
		HideEntity light2
		ShowEntity light
		light1shadows[0].ResetShadow()
		RenderWorld
		
		ShowEntity light
	EndIf
	
	If light2hid=0 And light1hid=1 ' light2 on, light1 off
		ShowEntity light2
		HideEntity light
		light2shadows[0].ResetShadow()
		RenderWorld
		
		ShowEntity light2
	EndIf
	
	CameraRange camera,1,1000
	
End Function

