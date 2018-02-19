' alphamap.bmx
' using alpha maps for transparency

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,4

Local cube2:TMesh=CreateCube()
PositionEntity cube2,1.5,0,4

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

' transparency - from two images
' this works in Blitz3d but not Openb3d so use LoadTextureAlpha, which sets alpha channel from another color
Local tex0:TTexture=LoadAlphaTexture("../media/colorkey.jpg",1,$FF)
Local tex1:TTexture=LoadAlphaTexture("../media/spark.png",1,$FF)
EntityTexture cube,tex0,0,0
EntityTexture cube,tex1,0,1
TextureBlend tex0,1
TextureBlend tex1,2
EntityFX cube,32

' tranlucency - from single image with alpha channel
Local tex2:TTexture=LoadTexture("../media/alpha_map.png")
EntityTexture(cube2,tex2)
EntityFX(cube2,32)

Local efx%=1


While Not KeyDown(KEY_ESCAPE)

	' turn cubes
	If KeyDown(KEY_LEFT)
		TurnEntity cube,0,-0.5,0.1
		TurnEntity cube2,0,0.5,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity cube,0,0.5,-0.1
		TurnEntity cube2,0,-0.5,0.1
	EndIf
	
	' alpha blending: alpha / nothing
	If KeyHit(KEY_B)
		efx=Not efx
		If efx
			EntityFX(cube,32) ; EntityFX(cube2,32)
		Else
			EntityFX(cube,0) ; EntityFX(cube2,0)
		EndIf
	EndIf
	
	RenderWorld
	
	Text 20,TGlobal.height[0]-40,"Left/Right: turn cubes"+", B: alpha blending = "+efx
	
	BeginMax2D()
	SetBlend ALPHABLEND
	SetColor 0,255,0
	GLDrawText "Testing Max2d",TGlobal.width[0]-TextWidth("Testing Max2d  "),TGlobal.height[0]-40
	EndMax2D()
	
	Flip
	
Wend
End
