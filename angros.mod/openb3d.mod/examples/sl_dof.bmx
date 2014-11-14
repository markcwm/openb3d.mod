' sl_dof.bmx

Import Angros.Openb3d

Strict

Local width%=800,height%=600

Graphics3D width,height,0,2


ClearTextureFilters

Local camera:TCamera=CreateCamera()

Local plan_cam:TCamera=CreateCamera()
Local tex_size%=256
CameraViewport plan_cam,0,GraphicsHeight()-tex_size,tex_size,tex_size ' y is inverted
CameraClsColor plan_cam,0,0,0

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,2,0

Local t_sphere:TMesh=CreateSphere( 8 )
EntityShininess t_sphere,0.2
Local sphere:TEntity[], inc%, temp%

For temp=0 To 359 Step 36
	sphere=sphere[..inc+1]
	sphere[inc]=CopyEntity(t_sphere,pivot)
	EntityColor sphere[inc],Rnd(256),Rnd(256),Rnd(256)
	TurnEntity sphere[inc],0,temp,0
	MoveEntity sphere[inc],0,0,10
	inc:+1
Next
FreeEntity t_sphere

Local colorbuf:TTexture=CreateTexture(tex_size,tex_size)
Local depthbuf:TTexture=CreateTexture(tex_size,tex_size)

Local shader:TShader=LoadShader("","shaders/dof.vert.glsl","shaders/dof.frag.glsl")
ShaderTexture(shader,colorbuf,"bb_ColorBuffer",0)
ShaderTexture(shader,depthbuf,"bb_DepthBuffer",1)
SetFloat(shader,"bright",1.0)
SetFloat(shader,"bb_zNear",1.0)
SetFloat(shader,"bb_zFar",1000.0)
SetFloat2(shader,"resolution",width,width)
SetFloat(shader,"yoffset",(width-height)/2-5)

Local cube:TMesh=CreateCube()
PositionEntity cube,0,7,0
ScaleEntity cube,3,3,3

Local cube2:TMesh=CreateCube()
ShadeEntity(cube2,shader)

Local d#=-20,hide%
PositionEntity plan_cam,0,7+0.2,0
MoveEntity plan_cam,0,0,d

' used by fps code
Local old_ms%=MilliSecs()
Local renders%=0, fps%=0


While Not KeyHit(KEY_ESCAPE)

	If KeyDown(KEY_A) d=d+1
	If KeyDown(KEY_Z) d=d-1
	If KeyDown(KEY_LEFT) TurnEntity camera,0,-3,0
	If KeyDown(KEY_RIGHT) TurnEntity camera,0,+3,0
	
	If KeyHit(KEY_SPACE) Then hide=Not hide
	
	PositionEntity camera,0,7,0
	MoveEntity camera,0,0,d
	
	TurnEntity cube,0.1,0.2,0.3
	TurnEntity pivot,0,1,0
	
	UpdateWorld
	
	ShowEntity cube
	For temp=0 To inc-1
		ShowEntity sphere[temp]
	Next
	HideEntity camera
	ShowEntity plan_cam
	RenderWorld
	
	BackBufferToTex colorbuf
	DepthBufferToTex depthbuf
	
	If hide
		HideEntity cube
		For temp=0 To inc-1
			HideEntity sphere[temp]
		Next
	EndIf
	ShowEntity camera
	HideEntity plan_cam
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"Space: hide objects = "+hide
	
	Flip
Wend
