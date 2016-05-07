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
Strict

Rem
bbdoc: OpenB3D Blitz3D functions
about: Online Blitz3D documentation links.
End Rem
Module Openb3d.Openb3d

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: 2014 Mark Mcvittie, Bruce A Henderson"

ModuleInfo "History: 1.00 Initial Release"

Import Openb3d.Openb3dlib	' imports PUB.Glew, PUB.OpenGL
Import Brl.GLMax2d			' imports BRL.Max2D, BRL.GLGraphics
Import Brl.GLGraphics		' imports BRL.Graphics, BRL.Pixmap, PUB.OpenGL
Import Brl.BmpLoader		' imports BRL.Pixmap, BRL.EndianStream
Import Brl.PngLoader		' imports BRL.Pixmap, PUB.LibPNG
Import Brl.JpgLoader		' imports BRL.Pixmap, PUB.LibJPEG
Import Brl.Retro			' imports BRL.Basic
Import Brl.Map

' *** Types

' global
Type TGlobal
End Type

' entity
Type TEntity
End Type
Type TCamera
End Type
Type TLight
End Type
Type TPivot
End Type
Type TMesh
End Type
Type TSprite
End Type
Type TBone
End Type

' mesh structure
Type TSurface
End Type
Type TTexture
End Type
Type TBrush
End Type
Type TAnimation
End Type

' picking/collision
Type TPick
End Type

' geom
'Type TVector
'End Type
'Type TMatrix
'End Type
'Type TQuaternion
'End Type

' misc
'Type TBuffer
'End Type
Type TTerrain
End Type
Type TShader
End Type
Type TShadowObject
End Type
Type THardwareInfo
End Type

' *** Includes

' functions
Include "functions.bmx"
