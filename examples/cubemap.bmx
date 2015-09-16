' cubemap.bmx
' from Minib3d examples

Strict

Framework Openb3d.B3dglgraphics

Local width%=800,height%=600,depth%=0,Mode%=2

Graphics3D width,height,depth,Mode


Local cam:TCamera=CreateCamera()
PositionEntity cam,0,8,-10

' create separate camera for updating cube map - this allows us to avoid any confusion
Local cube_cam:TCamera=CreateCamera()
HideEntity cube_cam

Local light:TLight=CreateLight(2)
RotateEntity light,45,45,0
PositionEntity light,10,10,0
LightRange light,10

' load object we will apply cubemap to - the classic teapot
Local teapot:TMesh=LoadMesh("media/teapot.b3d")
ScaleEntity teapot,5,5,5
PositionEntity teapot,0,6,10

' ground
Local ground:TMesh=LoadMesh("media/grid.b3d")
ScaleEntity ground,1000,1,1000
EntityColor ground,168,133,55
Local ground_tex:TTexture=LoadTexture("media/sand.bmp")
ScaleTexture ground_tex,0.001,0.001
EntityTexture ground,ground_tex

' sky
Local sky:TMesh=CreateSphere(24)
ScaleEntity sky,500,500,500
FlipMesh sky
EntityFX sky,1
Local sky_tex:TTexture=LoadTexture("media/sky.bmp")
EntityTexture sky,sky_tex

' cactus
Local cactus:TMesh=LoadMesh("media/cactus2.b3d")
FitMesh cactus,-5,0,0,2,6,0.5

' camel
Local camel:TMesh=LoadMesh("media/camel.b3d")
FitMesh camel,5,0,0,6,5,4

' load ufo - to give us a dynamic moving object that the cubemap will be able to reflect
Local ufo_piv:TPivot=CreatePivot()
PositionEntity ufo_piv,0,10,10
Local ufo:TMesh=LoadMesh("media/green_ufo.b3d",ufo_piv)
PositionEntity ufo,0,0,10

' create texture with color + cubic environment map
Local tex:TTexture=CreateTexture(256,256,1+128)

' apply cubic environment map to teapot
EntityTexture teapot,tex

Local blendmode%, cubemode%=1

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyDown(KEY_ESCAPE)

	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' change cube mode: specular, diffuse
	If KeyHit(KEY_M)
		cubemode=cubemode+1
		If cubemode=3 Then cubemode=1
		SetCubeMode tex,cubemode
	EndIf
	
	' alpha blending
	If KeyHit(KEY_B) Then blendmode=Not blendmode
	If blendmode=0 Then EntityAlpha teapot,1.0
	If blendmode=1 Then EntityAlpha teapot,0.7
	
	' turn ufo pivot, causing child ufo mesh to spin around it (and teapot)
	TurnEntity ufo_piv,0,2,0
	TurnEntity teapot,0,0.5,-0.1
	
	' hide main camera before updating cube map - we don't need to render it when cube_cam is rendered
	HideEntity cam
	
	UpdateCubemap(tex,cube_cam,teapot)
	
	' show main camera again
	ShowEntity cam

	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"M: cubemode = "+cubemode+", B: blendmode = "+blendmode

	Flip

Wend


Function UpdateCubemap(tex:TTexture,camera:TCamera,entity:TEntity)

	Local tex_sz%=TextureWidth(tex)

	' show the camera we have specifically created for updating the cubemap
	ShowEntity camera
	
	' hide entity that will have cubemap applied to it.
	' This is so we can get cubemap from its position, without it blocking the view
	HideEntity entity

	' position camera where the entity is - this is where we will be rendering views from for cubemap
	PositionEntity camera,EntityX#(entity),EntityY#(entity),EntityZ#(entity)

	CameraClsMode camera,False,True
	
	' set the camera's viewport so it is the same size as our texture
	' - so we can fit entire screen contents into texture
	CameraViewport camera,0,0,tex_sz,tex_sz
	
	' update cubemap - Blitz3D uses CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

	' do left view	
	SetCubeFace tex,0
	RotateEntity camera,0,90,0
	RenderWorld
	BackBufferToTex tex
	
	' do forward view
	SetCubeFace tex,1
	RotateEntity camera,0,0,0
	RenderWorld
	BackBufferToTex tex
	
	' do right view	
	SetCubeFace tex,2
	RotateEntity camera,0,-90,0
	RenderWorld
	BackBufferToTex tex
	
	' do backward view
	SetCubeFace tex,3
	RotateEntity camera,0,180,0
	RenderWorld
	BackBufferToTex tex
	
	' do up view
	SetCubeFace tex,4
	RotateEntity camera,-90,0,0
	RenderWorld
	BackBufferToTex tex
	
	' do down view
	SetCubeFace tex,5
	RotateEntity camera,90,0,0
	RenderWorld
	BackBufferToTex tex
	
	' show entity again
	ShowEntity entity
	
	' hide the cubemap camera
	HideEntity camera
	
End Function
