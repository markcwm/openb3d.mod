' sl_dof.bmx

Import Angros.Openb3d

Strict

Graphics3D 800,600,0,2


ClearTextureFilters

Local camera:TCamera=CreateCamera()

Local plan_cam:TCamera=CreateCamera()
TurnEntity plan_cam,90,0,0
PositionEntity plan_cam,0,20,0
CameraViewport plan_cam,0,GraphicsHeight()-128,128,128 ' y is inverted
CameraClsColor plan_cam,0,0,0

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,2,0

Local t_sphere:TMesh=CreateSphere( 8 )
EntityShininess t_sphere,0.2

For Local t%=0 To 359 Step 36
	Local sphere:TEntity=CopyEntity(t_sphere,pivot)
	EntityColor sphere,Rnd(256),Rnd(256),Rnd(256)
	TurnEntity sphere,0,t,0
	MoveEntity sphere,0,0,10
Next
FreeEntity t_sphere

Local colorbuf:TTexture=CreateTexture(128,128)
Local depthbuf:TTexture=CreateTexture(128,128)

Local shader:TShader=LoadShader("","shaders/dof.vert.glsl","shaders/dof.frag.glsl")
ShaderTexture(shader,colorbuf,"bb_ColorBuffer",0)
ShaderTexture(shader,depthbuf,"bb_DepthBuffer",1)
SetFloat(shader,"bright",1.0)
SetFloat(shader,"bb_zNear",1.0)
SetFloat(shader,"bb_zFar",1000.0)

Local cube:TMesh=CreateCube()
PositionEntity cube,0,7,0
ScaleEntity cube,3,3,3

ShadeEntity(cube,shader)

Local d#=-20


While Not KeyHit(KEY_ESCAPE)

	If KeyDown(KEY_A) d=d+1
	If KeyDown(KEY_Z) d=d-1
	If KeyDown(KEY_LEFT) TurnEntity camera,0,-3,0
	If KeyDown(KEY_RIGHT) TurnEntity camera,0,+3,0
	
	PositionEntity camera,0,7,0
	MoveEntity camera,0,0,d
	
	TurnEntity cube,0.1,0.2,0.3
	TurnEntity pivot,0,1,0
	
	UpdateWorld
	
	HideEntity camera
	ShowEntity plan_cam
	RenderWorld
	
	BackBufferToTex colorbuf
	DepthBufferToTex depthbuf
	
	ShowEntity camera
	HideEntity plan_cam
	
	RenderWorld
	
	Flip
Wend
