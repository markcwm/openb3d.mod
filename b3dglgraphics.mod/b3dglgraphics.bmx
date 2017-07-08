' Copyright (c) 2014 Mark Mcvittie, Bruce A Henderson
'
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
'    1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
'
'    2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
'
'    3. This notice may not be removed or altered from any source
'    distribution.
'
SuperStrict

Rem
bbdoc: GLGraphics backend for B3D.
End Rem
Module Openb3d.B3dglgraphics

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: 2014 Mark Mcvittie, Bruce A Henderson"

ModuleInfo "History: 1.00 Initial Release"

Import Openb3d.Openb3d
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
		Case -3 ' alpha
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER
		Case -4 ' depth
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER
		Case -5 ' stencil
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_STENCILBUFFER
		Case -6 ' accum
			flags=GRAPHICS_BACKBUFFER|GRAPHICS_ACCUMBUFFER
		Default ' none
			flags=GRAPHICS_BACKBUFFER
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
bbdoc: Draw text, doesn't need Max2D.
EndRem
Function Text( x%,y%,txt$ )

	' set active texture to texture 0 so gldrawtext will work correctly
	If THardwareInfo.VBOSupport 'SMALLFIXES hack to keep non vbo GFX from crashing
		glActiveTextureARB(GL_TEXTURE0)
		glClientActiveTextureARB(GL_TEXTURE0)
	EndIf
	
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE) ' texture blend 0, do not blend
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
