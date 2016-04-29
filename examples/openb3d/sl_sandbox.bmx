' sl_sandbox.bmx
' transforming glsl sandbox to 3d

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Timer

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235
CameraRange camera,0.1,100

Local light:TLight=CreateLight()
PositionEntity light,5,5,5

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3

Local shader:TShader=LoadShader("","../shaders/sandbox.vert.glsl","../shaders/sandbox.frag.glsl")
Local tex:TTexture=CreateTexture(64,64)
ShaderTexture(shader,tex,"tex0",0)
ShadeEntity(cube,shader)
SetFloat2(shader,"resolution",800,600)
SetFloat2(shader,"mouse",MouseX(),MouseY())
Local time#, framerate#=60.0, animspeed#=1
Local timer:TTimer=CreateTimer(framerate)
UseFloat(shader,"time",time)

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%


While Not KeyDown(KEY_ESCAPE)

	' turn cube
	If KeyDown(KEY_LEFT) Then TurnEntity cube,0,-0.5,0.1
	If KeyDown(KEY_RIGHT) Then TurnEntity cube,0,0.5,-0.1
	
	time=Float((TimerTicks(timer) / framerate) * animspeed)
	
	UpdateWorld
	RenderWorld
		
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"Left/Right: turn cube, time = "+time
	
	Flip

Wend
End
