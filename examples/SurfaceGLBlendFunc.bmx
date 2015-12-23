' SurfaceGLBlendFunc.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


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
Local tex1:TTexture=LoadTexture("media/alpha_map.png")
EntityTexture cube,tex1

Local brush:TBrush=CreateBrush()
Local surf:TSurface=GetSurface(cube,1)
Local t_blend% = 3

Select t_blend
	Case 1
		SurfaceGLBlendFunc(surf,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA) 'alpha
	Case 2
		SurfaceGLBlendFunc(surf,GL_DST_COLOR,GL_ZERO) 'multiply
	Case 3
		SurfaceGLBlendFunc(surf,GL_SRC_ALPHA,GL_ONE) 'add
	Default
		BrushTexture brush,tex1
		BrushBlend brush,1
		'BrushColor brush,255,255,255
		BrushAlpha brush,0.9
		PaintMesh cube,brush
EndSelect

If t_blend>0
	surf.brush.fx[0]=32
	surf.brush.alpha[0]=0.9 ' if alpha<1 it overrides fx
	'SurfaceGLColor(surf,1,1,1,1) ' surf.brush.red/green/blue/alpha[0]
EndIf

' tranlucency - from single image with alpha channel
Local tex2:TTexture=LoadTexture("media/alpha_map.png")
EntityTexture(cube2,tex2)
EntityFX(cube2,32)
EntityAlpha(cube2,0.9)

Local efx%=1,ealpha%=1


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
			surf.brush.fx[0]=32 ; EntityFX(cube2,32)
		Else
			surf.brush.fx[0]=0 ; EntityFX(cube2,0)
		EndIf
	EndIf
	
	If KeyHit(KEY_A)
		ealpha=Not ealpha
		If ealpha
			surf.brush.alpha[0]=1 ; EntityAlpha(cube2,1)
		Else
			surf.brush.alpha[0]=0 ; EntityAlpha(cube2,0)
		EndIf
	EndIf
	
	RenderWorld
	
	Text 0,0,"Left/Right: turn cubes"+", B: EntityFX blending = "+efx+", A: EntityAlpha = "+ealpha
	
	Flip
	
Wend
End
