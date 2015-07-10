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

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online doc</a>
about: The flags argument sets the graphics buffers (back, alpha, depth, stencil and accum). 
Set usecanvas to true if using maxgui with a canvas context.
End Rem
Function Graphics3D( width:Int,height:Int,depth:Int=0,Mode:Int=0,rate:Int=60,flags:Int=-1,usecanvas:Int=False )
	TGlobal.Graphics3D( width,height,depth,Mode,rate,flags,usecanvas )
End Function

Rem
bbdoc: Draw text, does not need Max2D.
End Rem
Function Text( x:Int,y:Int,Text:String )
	TBlitz2D.Text( x,y,Text )
End Function
