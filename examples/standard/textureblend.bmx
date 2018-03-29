' textureblend.bmx
' using BrushGLBlendFunc, TextureGLTexEnv and BrushGLColor, experimental

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

Local tex0:TTexture=LoadTexture("../media/spark.png",1+2)
EntityTexture cube,tex0,0,0
Local tex1:TTexture=LoadTexture("../media/tex1.jpg",1)
EntityTexture cube,tex1,0,1
Local tex2:TTexture=LoadTexture("../media/tex2.jpg",1)
EntityTexture cube,tex2,0,2

Local brush:TBrush=CreateBrush()
Local surf:TSurface=GetSurface(cube,1)
'BrushFX(surf.brush,32)
'BrushBlend(surf.brush,1)

'TextureBlend(tex1,8) ' interpolate
'TextureMultitex(tex1,0.75)

Local tex3:TTexture=LoadTexture("../media/alpha_map.png",1)
EntityTexture cube2,tex3
'EntityFX(cube2,32)

Local efx%=0,eblend%=2,etexenv%=2,multitexfactor#=0.5,scalefactor#=0


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
	
	' alpha blending, alpha / nothing
	If KeyHit(KEY_A)
		efx=Not efx
		If efx
			BrushFX(surf.brush,32) ; EntityFX(cube2,32)
		Else
			BrushFX(surf.brush,0) ; EntityFX(cube2,0)
		EndIf
	EndIf
	
	' blend function, 1-3
	If KeyHit(KEY_B)
		eblend:+1
		If eblend>3 Then eblend=1
		If eblend=1 ' 1: alpha
			surf.brush.BrushGLBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
		ElseIf eblend=2 ' 2: multiply (default)
			surf.brush.BrushGLBlendFunc(GL_DST_COLOR,GL_ZERO)
		ElseIf eblend=3 ' 3: add
			surf.brush.BrushGLBlendFunc(GL_SRC_ALPHA,GL_ONE)
		EndIf
	EndIf
	
	If KeyDown(KEY_LSHIFT) ' LShift + 0-8 key to blend texture 2 or 0-8 key to blend texture 1
	
		If KeyHit(KEY_0) ' 0: do not blend
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=0 ' clear TexEnv arrays, once only
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)
		EndIf
		If KeyHit(KEY_1) ' 1: blend
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=1
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)
		EndIf
		If KeyHit(KEY_2) ' 2: multiply (default)
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=2
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
		EndIf
		If KeyHit(KEY_3) ' 3: add
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=3
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_ADD)
		EndIf
		If KeyHit(KEY_4) ' 4: dot3
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=4
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_EXT)
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB_EXT, GL_DOT3_RGB_EXT)
		EndIf
		If KeyHit(KEY_5) ' 5: multiply2 (scale of 2 or 4)
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=5
			scalefactor:+1
			If scalefactor>16 Then scalefactor=0
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE)
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_MODULATE)
			tex2.TextureGLTexEnvf(GL_TEXTURE_ENV,GL_RGB_SCALE,scalefactor) ' float
		EndIf
		If KeyHit(KEY_6) ' 6: blend (invert)
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=6
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND)
		EndIf
		If KeyHit(KEY_7) ' 7: subtract
			tex2.TextureGLTexEnvf(0, 0, 0) ; etexenv=7
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE)
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_SUBTRACT)
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS)
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE)
		EndIf
		If KeyHit(KEY_8) ' 8: interpolate
			tex2.TextureGLTexEnvi(0, 0, 0) ; etexenv=8
			multitexfactor:-0.1
			If multitexfactor<0.05 Then multitexfactor=1
			tex2.TextureGLTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, multitexfactor) ' float
			tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_INTERPOLATE)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_TEXTURE)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_PREVIOUS)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE2_RGB, GL_CONSTANT)
    		tex2.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND2_RGB, GL_SRC_ALPHA)
		EndIf
	
	Else
	
		If KeyHit(KEY_0) ' 0: do not blend
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=0 ' clear TexEnv arrays, once only
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)
		EndIf
		If KeyHit(KEY_1) ' 1: blend
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=1
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)
		EndIf
		If KeyHit(KEY_2) ' 2: multiply (default)
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=2
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
		EndIf
		If KeyHit(KEY_3) ' 3: add
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=3
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_ADD)
		EndIf
		If KeyHit(KEY_4) ' 4: dot3
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=4
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_EXT)
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB_EXT, GL_DOT3_RGB_EXT)
		EndIf
		If KeyHit(KEY_5) ' 5: multiply2 (scale of 2 or 4)
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=5
			scalefactor:+1
			If scalefactor>16 Then scalefactor=0
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE)
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_MODULATE)
			tex1.TextureGLTexEnvf(GL_TEXTURE_ENV,GL_RGB_SCALE,scalefactor) ' float
		EndIf
		If KeyHit(KEY_6) ' 6: blend (invert)
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=6
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND)
		EndIf
		If KeyHit(KEY_7) ' 7: subtract
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=7
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE)
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_SUBTRACT)
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS)
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE)
		EndIf
		If KeyHit(KEY_8) ' 8: interpolate
			tex1.TextureGLTexEnvi(0, 0, 0) ; etexenv=8
			multitexfactor:-0.1
			If multitexfactor<0.05 Then multitexfactor=1
			tex1.TextureGLTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, multitexfactor) ' float
			tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_INTERPOLATE)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_TEXTURE)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_PREVIOUS)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_SOURCE2_RGB, GL_CONSTANT)
    		tex1.TextureGLTexEnvi(GL_TEXTURE_ENV, GL_OPERAND2_RGB, GL_SRC_ALPHA)
		EndIf
		
	EndIf
	
	RenderWorld
	
	Text 0,20,"A: EntityFX blend = "+efx+", B: BlendFunc = "+eblend+", LShift and/or 0-8 key: TexEnv="+etexenv
	Text 0,40,"8 key: Interpolate multitexfactor="+multitexfactor+", 5 key: Multiply2 scalefactor="+scalefactor
	
	Flip
	
Wend
End
