' sl_multitex.bmx
' multitexturing

Strict

Framework angros.b3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235

Local light:TLight=CreateLight()

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,4

Local cube2:TMesh=CreateCube()
PositionEntity cube2,1.5,0,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

' texture blending from value
Local shader:TShader=LoadShader("","shaders/multitex.vert.glsl","shaders/multitex.frag.glsl")
ShaderTexture(shader,LoadTexture("media/tex1.jpg"),"myTexture1",0)
ShaderTexture(shader,LoadTexture("media/tex2.jpg"),"myTexture2",1)
ShadeEntity(cube,shader)

' texture blending based on alpha map
Local shader2:TShader=LoadShader("","shaders/multitex2.vert.glsl","shaders/multitex2.frag.glsl")
ShaderTexture(shader2,LoadTexture("media/tex1.jpg"),"Texture0",0)
ShaderTexture(shader2,LoadTexture("media/tex2.jpg"),"Texture1",1)
ShaderTexture(shader2,LoadTexture("media/spark.png"),"Texture2",2) ' alpha map
ShadeEntity(cube2,shader2)


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
	
	RenderWorld
	
	Text 0,0,"Left/Right: turn cubes"
	
	Flip

Wend
End
