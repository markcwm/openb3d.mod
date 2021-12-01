' b3dglgraphics.bmx

SuperStrict

Rem
bbdoc: GLGraphics backend
End Rem
Module Openb3d.B3dglgraphics

ModuleInfo "Version: 1.26"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2021 Mark Mcvittie, Bruce A Henderson"
ModuleInfo "Copyright: Library - 2010-2021 Angelo Rosina"

Import Openb3d.Openb3dcore
Import Openb3d.Stbimageloader' imports Brl.Pixmap, Brl.RamStream
Import Brl.JpgLoader			' imports Brl.Pixmap, Pub.LibJpeg
Import Brl.PngLoader			' imports Brl.Pixmap, Pub.LibPng
'Import Brl.BmpLoader			' imports Brl.Pixmap, Brl.EndianStream (deprecated)
'Import Brl.TgaLoader			' imports Brl.Pixmap, Brl.EndianStream (deprecated)

Include "TDebug.bmx"

Rem
bbdoc: Sets 3D Graphics mode
about: 
@Parameters: 

width - width of screen resolution

height - height of screen resolution

depth (optional) - colour depth of screen. Defaults to highest colour depth  available.

mode (optional) - mode of display. Defaults to 0.

0: windowed (if possible) in debug mode, fullscreen in non-debug mode

1: fullscreen always

2. windowed always

3: windowed/scaled always

rate (optional) - refresh rate of display in Hertz, defaults to 60

flags (optional) - sets the graphics buffers used (back, alpha, depth, stencil and accum), defaults to all

usecanvas (optional) - True if using maxgui with a canvas context, defaults to False

@Description: 

Sets 3D Graphics mode. This command must be executed before any other 3D command, otherwise programs will return an error.

Width and height set the resolution of the screen and common values are 640,480  and 800,600. The resolution must be compatible with the 3D card and monitor  being used.

Depth sets the colour mode of the screen. If this value is omitted or set to 0, then the highest available colour depth available will be used. Other values  usually available are 16, 24 and 32. 16-bit colour mode displays the least amount  of colours, 65536. 24-bit and 32-bit colour modes display over 16 million colours and as a result offer a better quality picture, although may result in slower programs than 16-bit.

See also: <a href=#Graphics>Graphics</a>, <a href=#EndGraphics>EndGraphics</a>.

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

	TGlobal3D.InitGlobals()
	TGlobal3D.width[0]=width
	TGlobal3D.height[0]=height
	TGlobal3D.depth[0]=depth
	TGlobal3D.mode[0]=mode
	TGlobal3D.rate[0]=rate
	
	SetGraphicsDriver( GLMax2DDriver(),flags ) ' mixed 2d/3d
	If usecanvas=False Then TGlobal3D.gfx_obj=Graphics( width,height,depth,rate,flags ) ' gfx object
	If usecanvas=False And (mode=2 Or (mode=0 And depth=0)) ' if fullsize windowed mode
		If GraphicsHeight()>0 Then height=GraphicsHeight() ' subtract titlebar height (fix for texture rendering in win32)
	EndIf
	
	glewInit() ' required for ARB funcs
	TGlobal3D.GraphicsInit() ' save initial settings for Max2D
	Graphics3D_( width,height,depth,mode,rate ) ' calls Global::Graphics
	
	' get hardware info and set vbo_enabled accordingly
	THardwareInfo.GetInfo()
	TGlobal3D.vbo_enabled[0]=THardwareInfo.VBOSupport ' vertex buffer objects
	TTexture.AnIsoSupport[0]=THardwareInfo.AnIsoSupport
	TGlobal3D.GL_Version=THardwareInfo.OGLVersion.ToFloat()
	
End Function

Rem
bbdoc: Prints a string at the designated screen coordinates, doesn't need BeginMax2D
about: 
@Parameters: 

x = starting x coordinate to print text

y = starting 4 coordinate to print text

string$ = string/text to print

center x = optional; true = center horizontally

center y = optional; true = center vertically 

@Description: 

Prints a string at the designated screen coordinates. You can center the  text on the coordiates by setting center x/center y to TRUE. This draws the  text in the current drawing color.

Note: Printing a space with text will NOT render a block - a space is an empty  value. So printing " " will not make a box appear.

End Rem
Function Text( x:Int,y:Int,txt:String )
	
	' set active texture to texture 0 so gldrawtext will work correctly
	glActiveTexture(GL_TEXTURE0)
	glClientActiveTexture(GL_TEXTURE0)
	
	glDisable(GL_LIGHTING)
	glColor3ub(TGlobal3D.txt_red,TGlobal3D.txt_green,TGlobal3D.txt_blue)
	
	' enable blend to hide text background
	glEnable(GL_BLEND)
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA) ' fixes text hidden when blend=2
	GLDrawText txt,x,y
	
	glDisable(GL_BLEND)
	glEnable(GL_LIGHTING)
	
	' disable texture 2D - needed as gldrawtext enables it, but doesn't disable after use
	glDisable(GL_TEXTURE_2D)
		
End Function

Rem
bbdoc: Draw text with a shadow, doesn't need BeginMax2D
EndRem
Function ShadowText:Int(msg:String, x:Int, y:Int)

	Local red:Int, green:Int, blue:Int
	
	GetColor red, green, blue
	
	SetColor 0, 0, 0
	DrawText msg, x + 1, y + 1
	
	SetColor 255, 255, 255
	DrawText msg, x, y
	
	SetColor red, green, blue
	
End Function

Rem
bbdoc: Set draw text color, in bytes
EndRem
Function TextColor( red:Byte,green:Byte,blue:Byte )

	TGlobal3D.txt_red=red
	TGlobal3D.txt_green=green
	TGlobal3D.txt_blue=blue
	
End Function
