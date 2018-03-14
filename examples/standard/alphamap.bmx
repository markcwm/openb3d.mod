' alphamap.bmx
' using alpha maps for transparency; texture blending with entity or surface brush

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,4
'EntityAlpha cube,0.99 ' alpha<1 overrides fx flag

Local mesh:TMesh=LoadMesh("../media/Bird.b3d")
ScaleMesh mesh,0.25,0.25,0.25
TurnEntity mesh,0,-90,20
PositionEntity mesh,1.5,0,4
Local brush2:TBrush=GetSurface(mesh,1).brush ' find surface brush
'BrushAlpha brush2,0.99

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

Local tex0:TTexture=LoadTexture("../media/colorkey.jpg",1+2) ' color and alpha flags
Local tex1:TTexture=LoadTexture("../media/spark.png",1+2) ' try no alpha flag for tex[1]
EntityTexture cube,tex0,0,0
EntityTexture cube,tex1,0,1
TextureBlend tex0,1
TextureBlend tex1,2
EntityFX cube,32

Local tex0b:TTexture=LoadTexture("../media/Ball.bmp",1+2)
Local tex1b:TTexture=LoadTexture("../media/Envroll.bmp",1+2)
BrushTexture brush2,tex0b,0,0 ' overwrite Bird_Skin.png slot with Ball.bmp
BrushTexture brush2,tex1b,0,1
TextureBlend tex0b,1
TextureBlend tex1b,2
BrushFX brush2,32

Local efx%=1


While Not KeyDown(KEY_ESCAPE)

	' turn cubes
	If KeyDown(KEY_LEFT)
		TurnEntity cube,0,-0.5,0.1
		TurnEntity mesh,0,0.5,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity cube,0,0.5,-0.1
		TurnEntity mesh,0,-0.5,0.1
	EndIf
	
	TurnEntity camera,KeyDown(KEY_S)-KeyDown(KEY_W),KeyDown(KEY_A)-KeyDown(KEY_D),0
	
	' hide/show meshes
	If KeyDown(KEY_LSHIFT)
		If KeyDown(KEY_Z)
			ShowEntity cube
		EndIf
		If KeyDown(KEY_X)
			ShowEntity mesh
		EndIf
		If KeyDown(KEY_C)
			ShowEntity cone
		EndIf
		If KeyDown(KEY_V)
			ShowEntity plane
		EndIf
	Else
		If KeyDown(KEY_Z)
			HideEntity cube
		EndIf
		If KeyDown(KEY_X)
			HideEntity mesh
		EndIf
		If KeyDown(KEY_C)
			HideEntity cone
		EndIf
		If KeyDown(KEY_V)
			HideEntity plane
		EndIf
	EndIf
	
	' alpha blending: alpha / nothing
	If KeyHit(KEY_B)
		efx=Not efx
		If efx
			EntityFX(cube,32) ; BrushFX(brush2,32)
		Else
			EntityFX(cube,0) ; BrushFX(brush2,0)
		EndIf
	EndIf
	
	' texture blending
	If KeyDown(KEY_LSHIFT)
		If KeyHit(KEY_0)
			TextureBlend tex1,0
			TextureBlend tex1b,0
		EndIf
		If KeyHit(KEY_1)
			TextureBlend tex1,1
			TextureBlend tex1b,1
		EndIf
		If KeyHit(KEY_2)
			TextureBlend tex1,2
			TextureBlend tex1b,2
		EndIf
		If KeyHit(KEY_3)
			TextureBlend tex1,3
			TextureBlend tex1b,3
		EndIf
	Else
		If KeyHit(KEY_0)
			TextureBlend tex0,0
			TextureBlend tex0b,0
		EndIf
		If KeyHit(KEY_1)
			TextureBlend tex0,1
			TextureBlend tex0b,1
		EndIf
		If KeyHit(KEY_2)
			TextureBlend tex0,2
			TextureBlend tex0b,2
		EndIf
		If KeyHit(KEY_3)
			TextureBlend tex0,3
			TextureBlend tex0b,3
		EndIf
	EndIf
	
	RenderWorld
	
	Text 20,20,"Left/Right: turn meshes"+", B: alpha blending = "+efx
	Text 20,40,"Z/X/C/V: hide cube/mesh/cone/plane, LShift + Z/X/C/V: show, TrisRendered="+TrisRendered()
	Text 20,60,"0/1/2/3: tex[0] blending, LShift + 0/1/2/3: tex[1] blending"
	Text 20,80,"cube.brush.tex[0].blend="+cube.brush.tex[0].blend[0]+" mesh.surf.brush.tex[0].blend="+brush2.tex[0].blend[0]
	Text 20,100,"cube.brush.tex[1].blend="+cube.brush.tex[1].blend[0]+" mesh.surf.brush.tex[1].blend="+brush2.tex[1].blend[0]
	
	BeginMax2D()
	SetBlend ALPHABLEND
	SetColor 0,255,0
	GLDrawText "Testing Max2d",20,DesktopHeight()-40
	EndMax2D()
	
	Flip
	
Wend
End
