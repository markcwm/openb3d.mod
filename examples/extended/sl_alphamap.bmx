' sl_alphamap.bmx
' using alpha maps for transparency - note more than one visible surface is needed for alpha to work

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
Local shader:TShader=LoadShader("","../shaders/alphamap.vert.glsl","../shaders/alphamap.frag.glsl")
ShaderTexture(shader,LoadTexture("../media/colorkey.jpg"),"tex",0)
ShaderTexture(shader,LoadTexture("../media/spark.png"),"alphatex",1)
ShadeEntity(cube,shader)
EntityFX(cube,32)

' tranlucency - from single image with alpha channel
Local shader2:TShader=LoadShader("","../shaders/alphamap.vert.glsl","../shaders/alphamap2.frag.glsl")
ShaderTexture(shader2,LoadTexture("../media/alpha_map.png"),"tex",0)
ShadeEntity(cube2,shader2)
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
	
	Text 0,20,"Left/Right: turn cubes"+", B: alpha blending = "+efx
	
	Flip

Wend
End
