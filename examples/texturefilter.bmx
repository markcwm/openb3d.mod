' texturefilter.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()

ClearTextureFilters
TextureFilter "crate",1 ' no mipmaps

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,3
Local tex1:TTexture=LoadTexture("media/crate.bmp")
EntityTexture cube,tex1

Local cube2:TMesh=LoadMesh("media/wcrate.3ds")
ScaleEntity cube2,0.05,0.05,0.05
RotateEntity cube2,0,180,0
PositionEntity cube2,1.5,0,4
Local tex2:TTexture=LoadTexture("media/wcrate.jpg")
EntityTexture cube2,tex2

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

Local eflag%=1


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
	
	' texture filter flag is 8 - nearest/no mipmap or linear/mipmap
	If KeyHit(KEY_T)
		eflag=Not eflag
		If eflag
			TextureFlags cube.brush.tex[0],1
			TextureFlags cube2.brush.tex[0],1
		Else
			TextureFlags cube.brush.tex[0],1+8
			TextureFlags cube2.brush.tex[0],1+8
		EndIf
	EndIf
	RenderWorld
	
	Text 0,0,"Left/Right: turn cubes"+", T: texture flags = "+eflag
	
	Flip
	
Wend
End
