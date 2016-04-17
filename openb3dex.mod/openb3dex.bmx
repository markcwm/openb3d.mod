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
bbdoc: OpenB3D extended functions
about: Descriptions and some extra information.
End Rem
Module Openb3d.Openb3dex

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: 2014 Mark Mcvittie, Bruce A Henderson"

ModuleInfo "History: 1.00 Initial Release"


Import Openb3d.Openb3d

' *** Wrapper functions

Rem
bbdoc: Begin using Max2D functions.
End Rem
Function BeginMax2D()
	TBlitz2D.BeginMax2D()
End Function

Rem
bbdoc: End using Max2D functions.
End Rem
Function EndMax2D()
	TBlitz2D.EndMax2D()
End Function

Rem
bbdoc: Copy a list or vector. To copy a field list use as a method.
about: Use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
End Rem
Function CopyList( list:TList )
	TGlobal.CopyList( list )
End Function

Rem
bbdoc: Like using ListAddLast(list,value) in Minib3d, except ent parameter.
about: Only field lists supported, use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
EndRem
Function ListPushBack( list:TList,value:Object,ent:TEntity )
	TGlobal.ListPushBack( list,value,ent )
End Function

Rem
bbdoc: Add an existing surface to a mesh.
End Rem
Function AddSurface( mesh:TMesh,surf:TSurface,anim_surf%=False )
	If anim_surf=False
		mesh.ListPushBack( mesh.surf_list,surf )
	Else
		mesh.ListPushBack( mesh.anim_surf_list,surf )
	EndIf
End Function

' *** Includes

' functions
Include "functionsex.bmx"
