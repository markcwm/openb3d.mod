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
Module angros.b3dglgraphics

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: 2014 Mark Mcvittie, Bruce A Henderson"

ModuleInfo "History: 1.00 Initial Release"


Import angros.openb3d
Import Brl.GLMax2d

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online doc</a>
about: The flags argument sets the graphics buffers (back, alpha, depth, stencil and accum). 
The usecanvas argument is set to true if using maxgui with a canvas context.
End Rem
Function Graphics3D( width%, height%, depth%=0, Mode%=0, rate%=60, flags%=-1, usecanvas%=False )

	Select flags ' buffer values: back=2, alpha=4, depth=8, stencil=16, accum=32
		Case -1 flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
		Case -2 flags=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER ' 2+4
		Case -3 flags=GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER ' 2+8
		Case -4 flags=GRAPHICS_BACKBUFFER|GRAPHICS_STENCILBUFFER ' 2+16
		Case -5 flags=GRAPHICS_BACKBUFFER|GRAPHICS_ACCUMBUFFER ' 2+32
		Default flags=GRAPHICS_BACKBUFFER
	End Select
	
	SetGraphicsDriver( GLMax2DDriver(),flags ) ' mixed 2d/3d
	
	If usecanvas ' using a canvas context
		GraphicsResize( width,height )
	Else ' create gfx context
		Graphics( width,height,depth,rate,flags )
	EndIf
	
	TGlobal.GraphicsInit()
	
	Graphics3D_( width,height,depth,Mode,rate )
	
End Function

Rem
bbdoc: Draw text, does not need Max2D.
End Rem
Function Text( x%, y%, str$ )

	' set active texture to texture 0 so gldrawtext will work correctly
	If THardwareInfo.VBOSupport 'SMALLFIXES hack to keep non vbo GFX from crashing
		glActiveTextureARB(GL_TEXTURE0)
		glClientActiveTextureARB(GL_TEXTURE0)
	EndIf
		
	glDisable(GL_LIGHTING)
	glColor3f(1.0,1.0,1.0)
	
	' enable blend to hide text background
	glEnable(GL_BLEND)
	GLDrawText str,x,y
	
	glDisable(GL_BLEND)
	glEnable(GL_LIGHTING)
	
	' disable texture 2D - needed as gldrawtext enables it, but doesn't disable after use
	glDisable(GL_TEXTURE_2D)
	
End Function
