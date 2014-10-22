' sl_cubemap.bmx
' cubemapping with per-pixel lighting

Import Angros.Openb3d

Strict

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235
PositionEntity camera,0,8,-10
'CameraRange camera,0.1,100

' create separate camera for updating cube map - this allows us to avoid any confusion
Local cube_cam:TCamera=CreateCamera()
HideEntity cube_cam

Local light:TLight=CreateLight(1)
RotateEntity light,45,45,0
PositionEntity light,10,10,0
LightRange light,10

' sky
Local sky:TMesh=CreateSphere(24)
ScaleEntity sky,500,500,500
FlipMesh sky
EntityFX sky,1
Local sky_tex:TTexture=LoadTexture("media/sky.bmp")
EntityTexture sky,sky_tex

' ground
Local ground:TMesh=LoadMesh("media/grid.b3d")
ScaleEntity ground,1000,1,1000
EntityColor ground,168,133,55
Local ground_tex:TTexture=LoadTexture("media/sand.bmp")
ScaleTexture ground_tex,0.001,0.001
EntityTexture ground,ground_tex
'PositionEntity(ground,0,-1.0,0)

' cactus
Local cactus:TMesh=LoadMesh("media/cactus2.b3d")
FitMesh cactus,-5,0,0,2,6,.5

' camel
Local camel:TMesh=LoadMesh("media/camel.b3d")
FitMesh camel,5,0,0,6,5,4

' load ufo to give us a dynamic moving object that the cubemap will be able to reflect
Local ufo_piv:TPivot=CreatePivot()
PositionEntity ufo_piv,0,10,10
Local ufo:TMesh=LoadMesh("media/green_ufo.b3d",ufo_piv)
PositionEntity ufo,0,0,10

Local teapot:TMesh=LoadMesh("media/teapot.b3d")
'Local teapot:TMesh=CreateSphere()
ScaleEntity teapot,5,5,5
PositionEntity(teapot,0,6,10)

Local cubetex:TTexture=CreateTexture(256,256,1+2+128)
Local lighttype%=1, alpha#=0.7

Local shader:TShader=LoadShader("","shaders/cubemap.vert.glsl","shaders/cubemap.frag.glsl")
ShaderTexture(shader,cubetex,"Env",0)
ShadeEntity(teapot,shader)
SetFloat(shader,"alpha",alpha)

Local shader2:TShader=LoadShader("","shaders/cubemap2.vert.glsl","shaders/cubemap2.frag.glsl")
ShaderTexture(shader2,cubetex,"Env",0)
SetFloat(shader2,"alpha",alpha)

Local shader3:TShader=LoadShader("","shaders/cubemap3.vert.glsl","shaders/cubemap3.frag.glsl")
ShaderTexture(shader3,cubetex,"Env",0)
SetFloat(shader3,"alpha",alpha)
SetInteger(shader3,"lighttype",lighttype)

Local shader4:TShader=LoadShader("","shaders/cubemap4.vert.glsl","shaders/cubemap4.frag.glsl")
ShaderTexture(shader4,cubetex,"Env",0)
SetFloat(shader4,"alpha",alpha)
SetInteger(shader4,"lighttype",lighttype)

' set initial cube mode value
Local cubemode%=1, blendmode%, pixellight%, lmkey%

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%


While Not KeyDown(KEY_ESCAPE)

	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' enable pixel lighting
	If KeyHit(KEY_P)
		pixellight:+1 ; If pixellight=2 Then pixellight=0
		lmkey=1
	EndIf
	
	' cube mode: specular / diffuse
	If KeyHit(KEY_M)
		cubemode:+1 ; If cubemode=3 Then cubemode=1
		lmkey=1
	EndIf
	If lmkey
		lmkey=0
		If cubemode=1 And pixellight=0 Then ShadeEntity(teapot,shader)
		If cubemode=2 And pixellight=0 Then ShadeEntity(teapot,shader2)
		If cubemode=1 And pixellight=1 Then ShadeEntity(teapot,shader3)
		If cubemode=2 And pixellight=1 Then ShadeEntity(teapot,shader4)
	EndIf
	
	' enable blending: alpha / nothing
	If KeyHit(KEY_B)
		blendmode=Not blendmode
		If blendmode Then EntityFX(teapot,32) Else EntityFX(teapot,0)
	EndIf
	
	TurnEntity(teapot,0,0.5,-0.1)
	
	TurnEntity ufo_piv,0,2,0
	
	' hide main camera before updating cube map - we don't need to render it when cube_cam is rendered
	HideEntity camera

	' update cubemap
	If ticks=0 Then UpdateCubemap(cubetex,cube_cam,teapot)
	ticks:+1 ; If ticks>=2 Then ticks=0 ' once every 3 ticks
	
	ShowEntity camera

	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"M: cubemode = "+cubemode+", B: blendmode = "+blendmode+", P: pixellight = "+pixellight
	
	Flip

Wend
End


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
	CameraViewport camera,0,GraphicsHeight()-tex_sz,tex_sz,tex_sz ' y is inverted
	
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
