' b3dglsdlgraphics.bmx

SuperStrict

Rem
bbdoc: SDL GLGraphics backend for B3D.
End Rem
Module Openb3d.B3dglsdlgraphics

ModuleInfo "Version: 1.12"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2017 Mark Mcvittie, Bruce A Henderson"
ModuleInfo "Copyright: Library - 2010-2017 Angelo Rosina"

Import Openb3d.Openb3d
?opengles
Import Sdl.GlsdlMax2d
?
Import Brl.BmpLoader		' imports Brl.Pixmap, Brl.EndianStream
Import Brl.PngLoader		' imports Brl.Pixmap, Pub.LibPng
Import Brl.JpgLoader		' imports Brl.Pixmap, Pub.LibJpeg

Include "TDebug.bmx"

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online doc</a>
about: The flags argument sets the graphics buffers (back, alpha, depth, stencil and accum). 
Set usecanvas to true if using maxgui with a canvas context.
End Rem
Function Graphics3D( width%,height%,depth%=0,mode%=0,rate%=60,flags%=-1,usecanvas%=False )

	Select flags ' back=2|alpha=4|depth=8|stencil=16|accum=32
		Case -1 ' all
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
		Case -2 ' all except accum
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER
	End Select
	
	' change depth values so Graphics3D will behave in the same way as Blitz3D
	Select mode
		Case 0 ' 0: windowed in debug mode, fullscreen in non-debug mode 
		?debug
			depth=0
		?
		?Not debug
			If depth=0 Then depth=DesktopDepth()
		?
		Case 1 ' 1: fullscreen always
			If depth=0 Then depth=DesktopDepth()
		Case 2 ' 2: windowed always
			depth=0
		Default
			depth=0
	End Select
?linux ' prevent fullscreen if in desktop resolution due to random hangs when exiting (ubuntu)
	If width=DesktopWidth() And height=DesktopHeight() Then depth=0
?

	TGlobal.InitGlobals()
	TGlobal.width[0]=width
	TGlobal.height[0]=height
	TGlobal.depth[0]=depth
	TGlobal.mode[0]=mode
	TGlobal.rate[0]=rate
	
	SetGraphicsDriver( GLMax2DDriver(),flags ) ' mixed 2d/3d
	If usecanvas=False Then TGlobal.gfx=Graphics( width,height,depth,rate,flags ) ' gfx context
	
	TGlobal.GraphicsInit()
	Graphics3D_( width,height,depth,mode,rate )
	
End Function

Rem
bbdoc: Draw text, doesn't need Max2D. Updated to work with DrawText.
EndRem
Function Text( x%,y%,txt$ )

	' set active texture to texture 0 so gldrawtext will work correctly
	If THardwareInfo.VBOSupport 'SMALLFIXES hack to prevent crash when vbo is not supported by GFX
		glActiveTextureARB(GL_TEXTURE0)
		glClientActiveTextureARB(GL_TEXTURE0)
	EndIf
	
	' Tell OpenGL you want to use texture combiners (non vbo)
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE)
	' Tell OpenGL which combiner you want to use (Modulate for RGB values)
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_DECAL) 'GL_MODULATE
	' Tell OpenGL To use texture unit 0's color values for Arg0
	glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_TEXTURE0)
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR)
	
	glDisable(GL_LIGHTING)
	glColor3f(1.0,1.0,1.0)
	
	' enable blend to hide text background
	glEnable(GL_BLEND)
	GLDrawText txt,x,y
	
	glDisable(GL_BLEND)
	glEnable(GL_LIGHTING)
	
	' disable texture 2D - needed as gldrawtext enables it, but doesn't disable after use
	glDisable(GL_TEXTURE_2D)
	
End Function
