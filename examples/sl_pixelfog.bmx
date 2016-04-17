' sl_pixelfog.bmx
' per pixel lighting and per pixel fog

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
Local fogmode%=1,fogrange#=100
Local fogr#=94, fogg#=95, fogb#=110
CameraFogMode camera,fogmode
CameraFogRange camera, 1, fogrange
CameraFogColor camera, fogr, fogg, fogb
CameraClsColor camera, fogr, fogg, fogb

Local lighttype%=2
Local light:TLight=CreateLight(lighttype)
RotateEntity light,45,45,0
PositionEntity light,10,10,-2
LightRange light,15

Local sphere:TMesh=CreateSphere()
PositionEntity sphere,-1.5,0,4

Local sphere2:TMesh=CreateSphere()
PositionEntity sphere2,1.5,0,4

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,40,0.1,40
MoveEntity plane,0,-1.5,0

Local tex0:TTexture=LoadTexture("media/07_DIFFUSE.jpg",1)
EntityTexture sphere,tex0

Local shader:TShader=LoadShader("","shaders/pixelfog.vert.glsl","shaders/pixelfog.frag.glsl")
ShaderTexture(shader,tex0,"tex",0)
SetInteger(shader,"lighttype",lighttype)
SetFloat4(shader,"fogColor", fogr/255, fogg/255, fogb/255, 1.0)
Local density#=1
UseFloat(shader,"density",density)
ShadeEntity(sphere2,shader)

Local efx%=1
Local max2dmode%=0


While Not KeyDown(KEY_ESCAPE)

	density=EntityDistance(camera,sphere2)/(fogrange*0.5) ' calculate fog density
	If Not fogmode Then density=0
	
	' move camera
	If KeyDown(KEY_S) Then MoveEntity(camera, 0, 0, -1)
	If KeyDown(KEY_W) Then MoveEntity(camera, 0, 0, 1)
	If KeyDown(KEY_A)  Then MoveEntity(camera, -1, 0, 0)
	If KeyDown(KEY_D) Then MoveEntity(camera, 1, 0, 0)
	
	' turn spheres
	If KeyDown(KEY_LEFT)
		TurnEntity sphere,0,-0.5,0.1
		TurnEntity sphere2,0,0.5,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity sphere,0,0.5,-0.1
		TurnEntity sphere2,0,-0.5,0.1
	EndIf
	
	' max2d mode
	If KeyHit(KEY_M) Then max2dmode=Not max2dmode
	
	' fog mode
	If KeyHit(KEY_F)
		fogmode=Not fogmode
		CameraFogMode camera,fogmode
	EndIf
	
	RenderWorld
	
	Text 0,0,"WSAD: move camera, Arrows: turn spheres, M: Max2d mode = "+max2dmode+", F: fog mode = "+fogmode
	Text 0,20,"density="+density
	
	If max2dmode
		BeginMax2D()
		DrawText "Testing Max2d",0,40
		EndMax2D()
	EndIf
	
	Flip
	
Wend
End
