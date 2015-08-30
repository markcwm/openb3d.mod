' sl_water.bmx
' simple water effect

Strict

Framework angros.b3dglgraphics
Import Brl.Timer

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235
PositionEntity camera,0,15,30
RotateEntity camera,40,180,0

' create separate camera for updating cube map - this allows us to avoid any confusion
Local cube_cam:TCamera=CreateCamera()
HideEntity cube_cam

Local light:TLight=CreateLight()
PositionEntity light,5,5,5

' sky
Local sky:TMesh=CreateSphere(12)
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

' camel
Local camel:TMesh=LoadMesh("media/camel.b3d")
FitMesh camel,5,0,0,6,5,4

' load ufo to give us a dynamic moving object that the cubemap will be able to reflect
Local ufo_piv:TPivot=CreatePivot()
PositionEntity ufo_piv,0,10,10
Local ufo:TMesh=LoadMesh("media/green_ufo.b3d",ufo_piv)
PositionEntity ufo,0,0,10

Local gridsize#=50 ' actual size
Local alpha#=0.9
Local texmix#=0.8 ' texture mixing ratio, value between 0..1
Local uvscale#=0.03

Local water:TMesh=CreateFlatMesh(gridsize,gridsize,2,0,0,0,uvscale,uvscale)
PositionEntity water,0,1,0

' walls
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


Local shader:TShader=LoadShader("","shaders/water.vert.glsl","shaders/water.frag.glsl")

Local tex:TTexture=LoadTexture("media/water.bmp")
ShaderTexture(shader,tex,"color_texture",0)

Local cubetex:TTexture=CreateTexture(512,512,1+2+128)
ShaderTexture(shader,cubetex,"Env",1)

Local wiretoggle%=-1
Local blendmode%=1

Local waveWidth:Float=0.66
Local waveHeight:Float=0.33
Local uvdrag:Float ' time value
Local uvratio:Float=100 ' dividing value, smaller is faster

Local time#, framerate#=60.0, animspeed#=2
Local timer:TTimer=CreateTimer(framerate)

UseFloat(shader,"alpha",alpha)
UseFloat(shader,"uvdrag",uvdrag)
UseFloat(shader,"texmix",texmix)
UseFloat(shader,"waveTime",time)
UseFloat(shader,"waveWidth",waveWidth)
UseFloat(shader,"waveHeight",waveHeight)

ShadeEntity(water,shader)
EntityFX(water,32)

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%


While Not KeyDown(KEY_ESCAPE)

	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	If KeyHit(KEY_SPACE) Then wiretoggle=-wiretoggle
	If wiretoggle=1 Then Wireframe True Else Wireframe False
	
	If KeyHit(KEY_Y) Then waveWidth:-0.1
	If KeyHit(KEY_H) Then waveWidth:+0.1
	
	If KeyHit(KEY_U) Then waveHeight:-0.1
	If KeyHit(KEY_J) Then waveHeight:+0.1
	
	If KeyHit(KEY_I) Then texmix:-0.1
	If KeyHit(KEY_K) Then texmix:+0.1
	
	' enable blending: alpha / nothing
	If KeyHit(KEY_B)
		blendmode=Not blendmode
		If blendmode Then EntityFX(water,32) Else EntityFX(water,0)
	EndIf
	
	TurnEntity ufo_piv,0,2,0
	
	time=Float((TimerTicks(timer) / framerate) * animspeed)
	uvdrag=time / uvratio
	
	' hide main camera before updating cube map - we don't need to render it when cube_cam is rendered
	HideEntity camera
	HideEntity camel ' objects in water are hidden to prevent big reflections
	HideEntity cactus
	HideEntity wall ; HideEntity wall2 ; HideEntity wall3 ; HideEntity wall4
	MoveEntity ufo,0,10,0 ' moved away a bit to reduce reflection size
	
	UpdateCubemap(cubetex,cube_cam,water)
	
	ShowEntity camera
	ShowEntity camel
	ShowEntity cactus
	ShowEntity wall ; ShowEntity wall2 ; ShowEntity wall3 ; ShowEntity wall4
	MoveEntity ufo,0,-10,0
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
	Text 0,20,"WSAD and Arrows: move camera, Space: wireframe, B: blending"
	Text 0,40,"Y/H: waveWidth, U/J: waveHeight, I/K: texmix"
	Text 0,60,"time = "+time+", waveWidth = "+waveWidth+", waveHeight = "+waveHeight+", texmix = "+texmix
	
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
	'Xlen/Zlen=mesh dimensions, Size=quad size
	'Xpos/Ypos/Zpos=xyz center, UScale/VScale=uv size
	
	Local hmesh:TMesh,hsurf:TSurface,xnum%,znum%,ix%,iz%,ptx#,ptz#,iv%
	
	hmesh=CreateMesh()
	hsurf=CreateSurface(hmesh)
	xnum=Xlen/Size 'number of vertices on axis
	znum=Zlen/Size
	
	'Create grid vertices, centered And offset
	For iz=0 To znum
		For ix=0 To xnum
			ptx=(ix*Size)-(xnum*Size*0.5) 'ipos-midpos
			ptz=(iz*Size)-(znum*Size*0.5)
			AddVertex(hsurf,ptx+Xpos,Ypos,ptz+Zpos) 'pos+offset
			iv=ix+(iz*(xnum+1)) 'iv=x+(z*x1)
			VertexTexCoords(hsurf,iv,ix*UScale,iz*VScale)
			VertexNormal(hsurf,iv,0.0,1.0,0.0)
		Next
	Next

	'fill in quad triangles, created in "reverse z" order
	For iz=0 To znum-1
		For ix=0 To xnum-1
			iv=ix+(iz*(xnum+1)) 'iv=x+(z*x1)
			AddTriangle(hsurf,iv,iv+xnum+1,iv+xnum+2) '0,x1,x2
			AddTriangle(hsurf,iv+xnum+2,iv+1,iv) 'x2,1,0
		Next
	Next
	
	UpdateNormals hmesh 'set normals, for cubemaps and lighting
	Return hmesh
	
End Function
