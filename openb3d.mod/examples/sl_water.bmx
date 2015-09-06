' sl_water.bmx
' simple water effect, with cubemap and stencil reflections

Strict

Framework angros.b3dglgraphics
Import Brl.Timer

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235
PositionEntity camera,0,15,30
RotateEntity camera,30,180,0

' create separate camera for updating cube map - this allows us to avoid any confusion
Local cube_cam:TCamera=CreateCamera()
HideEntity cube_cam

Local lighttype%=1
Local light:TLight=CreateLight(lighttype)
RotateEntity light,33,0,0
PositionEntity light,0,10,0
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

' cactus
Local cactus:TMesh=LoadMesh("media/cactus2.b3d")
FitMesh cactus,-5,0,0,2,6,0.5

Local cactuscopy:TMesh=CopyMesh(cactus)
FitMesh cactuscopy,-5,0,0,2,-6,0.5
FlipMesh cactuscopy

' camel
Local camel:TMesh=LoadMesh("media/camel.b3d")
FitMesh camel,5,0,0,6,5,4

Local camelcopy:TMesh=CopyMesh(camel)
FitMesh camelcopy,5,0,0,6,-5,4
FlipMesh camelcopy

' load ufo - to give us a dynamic moving object that the cubemap will be able to reflect
Local ufo_piv:TPivot=CreatePivot()
PositionEntity ufo_piv,0,0,5
Local ufo:TMesh=LoadMesh("media/green_ufo.b3d",ufo_piv)
PositionEntity ufo,0,10,15

Local ufocopy:TMesh=CopyMesh(ufo,ufo_piv)
ScaleEntity ufocopy,1,-1,1
FlipMesh ufocopy
PositionEntity ufocopy,0,-Abs(EntityY(ufo)-EntityY(ground)),15

' water
Local gridsize#=50 ' actual size
Local uvscale#=0.03

' parameters = x/z mesh dimensions, quad size, x/y/z center pos, u/v tex size
Local water:TMesh=CreateFlatMesh(gridsize,gridsize,2.0,0,0,0,uvscale,uvscale)
PositionEntity water,0,1,0

Local watercopy:TMesh=CopyMesh(water)
PositionEntity watercopy,0,1,0

' pool walls
Local wall:TMesh=CreateCube()
ScaleEntity wall,gridsize/2,1,1
PositionEntity wall,0,1,gridsize/2
Local wall2:TMesh=CreateCube()
ScaleEntity wall2,gridsize/2,1,1
PositionEntity wall2,0,1,-gridsize/2
Local wall3:TMesh=CreateCube()
ScaleEntity wall3,1,1,gridsize/2
PositionEntity wall3,gridsize/2,1,0
Local wall4:TMesh=CreateCube()
ScaleEntity wall4,1,1,gridsize/2
PositionEntity wall4,-gridsize/2,1,0

' shaders vars
Local waveAlpha:Float=0.9
Local waveWidth:Float=0.3
Local waveHeight:Float=0.2
Local waveLength:Float=0.9
Local udrag:Float, vdrag:Float ' waveTime / uvratio
Local uratio:Float=1000,vratio:Float=200 ' smaller is faster

Local waveTime#, framerate#=60.0, animspeed#=2
Local timer:TTimer=CreateTimer(framerate)

Local tex:TTexture=LoadTexture("media/water.bmp")
Local cubetex:TTexture=CreateTexture(256,256,1+2+128)

' non lit/ambient shader
Local shader:TShader=LoadShader("","shaders/water.vert.glsl","shaders/water.frag.glsl")
ShaderTexture(shader,tex,"color_texture",0)
ShaderTexture(shader,cubetex,"Env",1)
UseFloat(shader,"alpha",waveAlpha)
UseFloat2(shader,"uvdrag",udrag,vdrag)
UseFloat(shader,"vdrag",vdrag)
UseFloat(shader,"waveTime",waveTime)
UseFloat(shader,"waveWidth",waveWidth)
UseFloat(shader,"waveHeight",waveHeight)
UseFloat(shader,"waveLength",waveLength)
SetFloat4(shader,"texmix",0.8,0.2,0,0) ' multi-texturing (cubemap,tex) value between 0..1

' pixel lit shader
Local shader2:TShader=LoadShader("","shaders/water2.vert.glsl","shaders/water2.frag.glsl")
ShaderTexture(shader2,tex,"color_texture",0)
ShaderTexture(shader2,cubetex,"Env",1)
UseFloat(shader2,"alpha",waveAlpha)
UseFloat2(shader2,"uvdrag",udrag,vdrag)
UseFloat(shader2,"waveTime",waveTime)
UseFloat(shader2,"waveWidth",waveWidth)
UseFloat(shader2,"waveHeight",waveHeight)
UseFloat(shader2,"waveLength",waveLength)
SetFloat4(shader2,"texmix",0.4,0.2,0.4,0) ' multi-texturing (cubemap,tex,light) value between 0..1
SetInteger(shader2,"lighttype",lighttype)

ShadeEntity(water,shader2)
EntityFX(water,32)

' stencil
Local stencil:TStencil=CreateStencil()
StencilMesh stencil,watercopy,1
StencilMode stencil,1,1

CameraToTex cubetex,cube_cam ' needed for cubemaps to work on some Win setups

Local wiretoggle%=-1
Local blendmode%=1
Local pixellight%=1, lightmode%

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%


While Not KeyDown(KEY_ESCAPE)

	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	If KeyHit(KEY_SPACE) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe(True) Else Wireframe(False)
	
	' wave size
	If KeyHit(KEY_Y) Then waveWidth:-0.1
	If KeyHit(KEY_H) Then waveWidth:+0.1
	
	If KeyHit(KEY_U) Then waveHeight:-0.1
	If KeyHit(KEY_J) Then waveHeight:+0.1
	
	If KeyHit(KEY_I) Then waveLength:-0.1
	If KeyHit(KEY_K) Then waveLength:+0.1
	
	' enable blending: alpha / nothing
	If KeyHit(KEY_B)
		blendmode=Not blendmode
		If blendmode Then EntityFX(water,32) Else EntityFX(water,0)
	EndIf
	
	' enable pixel lighting
	If KeyHit(KEY_P)
		pixellight:+1 ; If pixellight=2 Then pixellight=0
		lightmode=1
	EndIf
	If lightmode
		lightmode=0
		If pixellight=0 Then ShadeEntity(water,shader)
		If pixellight=1 Then ShadeEntity(water,shader2)
	EndIf
	
	TurnEntity ufo_piv,0,2,0
	
	' hide main camera before updating cube map - we don't need to render it when cube_cam is rendered
	HideEntity camera
	HideEntity camel ' objects in water are hidden to prevent big reflections
	HideEntity cactus
	HideEntity wall ; HideEntity wall2 ; HideEntity wall3 ; HideEntity wall4
	HideEntity ufo
	
	UpdateCubemap(cubetex,cube_cam,water)
	
	ShowEntity camera
	ShowEntity camel
	ShowEntity cactus
	ShowEntity wall ; ShowEntity wall2 ; ShowEntity wall3 ; ShowEntity wall4
	ShowEntity ufo
	
	' disable reflections, so they will be clipped outside their stencil surface
	UseStencil Null
	CameraClsMode camera,1,1
	HideEntity ufocopy
	HideEntity camelcopy
	
	UpdateWorld
	RenderWorld
	
	waveTime=Float((TimerTicks(timer) / framerate) * animspeed)
	udrag=waveTime / uratio
	vdrag=waveTime / vratio
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	' enable reflections, don't clear camera buffers so we can draw over rest of the scene
	UseStencil stencil
	CameraClsMode camera,0,0
	HideEntity ground ' stencil reflection objects are below ground so we need to hide it to see them
	ShowEntity ufocopy
	ShowEntity camelcopy
	
	RenderWorld
	
	' disable reflections again, for normal rendering state
	UseStencil Null
	CameraClsMode camera,1,1
	ShowEntity ground
	HideEntity ufocopy
	HideEntity camelcopy
	
	Text 0,0,"FPS: "+fps+", WSAD and Arrows: move camera, Space: wireframe"
	Text 0,20,"B: blending = "+blendmode+", P: pixellight = "+pixellight
	Text 0,40,"Y/H: waveWidth = "+waveWidth+", U/J: waveHeight = "+waveHeight+", I/K: waveLength = "+waveLength
	
	Flip
	
Wend
End


Function UpdateCubemap( tex:TTexture,camera:TCamera,entity:TEntity )

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

Function CreateFlatMesh:TMesh( Xlen#,Zlen#,Size#,Xpos#,Ypos#,Zpos#,UScale#=1,VScale#=1 )
	'Xlen/Zlen=mesh dimensions, Size=quad size, Xpos/Ypos/Zpos=xyz center, UScale/VScale=uv size
	
	Local mesh:TMesh,surf:TSurface,xnum%,znum%,ix%,iz%,ptx#,ptz#,iv%
	
	mesh=CreateMesh()
	surf=CreateSurface(mesh)
	xnum=Xlen/Size 'number of vertices on axis
	znum=Zlen/Size
	
	'Create grid vertices, centered And offset
	For iz=0 To znum
		For ix=0 To xnum
			ptx=(ix*Size)-(xnum*Size*0.5) 'ipos-midpos
			ptz=(iz*Size)-(znum*Size*0.5)
			AddVertex(surf,ptx+Xpos,Ypos,ptz+Zpos) 'pos+offset
			iv=ix+(iz*(xnum+1)) 'iv=x+(z*x1)
			VertexTexCoords(surf,iv,ix*UScale,iz*VScale)
			VertexNormal(surf,iv,0.0,1.0,0.0)
		Next
	Next

	'fill in quad triangles, created in "reverse z" order
	For iz=0 To znum-1
		For ix=0 To xnum-1
			iv=ix+(iz*(xnum+1)) 'iv=x+(z*x1)
			AddTriangle(surf,iv,iv+xnum+1,iv+xnum+2) '0,x1,x2
			AddTriangle(surf,iv+xnum+2,iv+1,iv) 'x2,1,0
		Next
	Next
	
	UpdateNormals mesh 'set normals, for cubemaps and lighting
	Return mesh
	
End Function
