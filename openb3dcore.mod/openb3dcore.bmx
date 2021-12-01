' openb3dcore.bmx

Strict

Rem
bbdoc: OpenB3D core functions
about:
Core 3D functions and extra functions not in Blitz3D.
End Rem
Module Openb3d.Openb3dcore

ModuleInfo "Version: 1.26"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2021 Mark Mcvittie, Bruce A Henderson"
ModuleInfo "Copyright: Library - 2010-2021 Angelo Rosina"

Import Openb3d.Openb3dlib
Import Openb3d.DDSloader
Import Brl.GLMax2d			' imports BRL.Max2D, BRL.GLGraphics
Import Brl.GLGraphics		' imports BRL.Graphics, BRL.Pixmap, PUB.OpenGL
Import Brl.Retro			' imports BRL.Basic
Import Brl.Map

' *** Globals moved to TGlobal3D

Const GRAPHICS_MULTISAMPLE2X:Int=$40
Const GRAPHICS_MULTISAMPLE4X:Int=$80
Const GRAPHICS_MULTISAMPLE8X:Int=$100
Const GRAPHICS_MULTISAMPLE16X:Int=$200
Const GRAPHICS_HIDDEN:Int=$400

' Texture/Brush flags - flags 1024,2048,4096,8192,16384 seem to be unassigned
'Const TEX_COLOR:Int=1
'Const TEX_ALPHA:Int=2
'Const TEX_MASKED:Int=4
'Const TEX_MIPMAP:Int=8
'Const TEX_CLAMPU:Int=16
'Const TEX_CLAMPV:Int=32
'Const TEX_SPHEREMAP:Int=64
'Const TEX_CUBEMAP:Int=128
'Const TEX_VRAM:Int=256
'Const TEX_HIGHCOLOR:Int=512
'Const TEX_SECONDUV:Int=65536

' *** Wrapper functions

Rem
bbdoc: Old begin function as in Minib3d is 0, new begin function is 1 (default)
End Rem
Function BeginMax2D( version:Int=1 )
	TBlitz2D.BeginMax2D( version )
End Function

Rem
bbdoc: Old end function as in Minib3d is 0, new end function is 1 (default)
End Rem
Function EndMax2D( version:Int=1 )
	TBlitz2D.EndMax2D( version )
End Function

Rem
bbdoc: Copy a list or vector. To copy a field list use as a method
about: Use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
End Rem
Function CopyList( list:TList )
	TGlobal3D.CopyList( list )
End Function

'Rem
'bbdoc: Like using ListAddLast(list,value) in Minib3d, except ent parameter
'about: Only field lists currently supported, either mesh with surf_list, anim_surf_list, bones or ent with child_list.
'EndRem
'Function EntityListAdd( list:TList,value:Object,ent:TEntity )
'	TGlobal3D.EntityListAdd( list,value,ent )
'End Function

Rem
bbdoc: Add an existing surface to a mesh
End Rem
Function AddSurface( mesh:TMesh,surf:TSurface,anim_surf%=False )
	If anim_surf=False
		mesh.MeshListAdd( mesh.surf_list,surf )
	Else
		mesh.MeshListAdd( mesh.anim_surf_list,surf )
	EndIf
End Function

' *** Includes

' global
Include "inc/TGlobal3D.bmx"

' entity
Include "inc/TEntity.bmx"
Include "inc/TCamera.bmx"
Include "inc/TLight.bmx"
Include "inc/TPivot.bmx"
Include "inc/TMesh.bmx"
Include "inc/TSprite.bmx"
Include "inc/TBone.bmx"

' mesh structure
Include "inc/TSurface.bmx"
Include "inc/TTexture.bmx"
Include "inc/TBrush.bmx"
Include "inc/TAnimation.bmx"
Include "inc/TB3D.bmx"
Include "inc/TMD2.bmx"
Include "inc/T3DS.bmx"
Include "inc/T3DS2.bmx"
Include "inc/TOBJ.bmx"

' picking/collision
Include "inc/TPick.bmx"

' geom
Include "inc/TVector.bmx"
Include "inc/TMatrix.bmx"
Include "inc/TQuaternion.bmx"
Include "inc/BoxSphere.bmx"

' misc
Include "inc/TBlitz2D.bmx"
Include "inc/TUtility.bmx"
'Include "inc/TDebug.bmx"
Include "inc/TMeshLoader.bmx"

' extra
Include "inc/TTerrain.bmx"
Include "inc/TShader.bmx"
Include "inc/TShadowObject.bmx"
Include "inc/THardwareInfo.bmx"
Include "inc/TStencil.bmx"
Include "inc/TFluid.bmx"
Include "inc/TGeosphere.bmx"
Include "inc/TOcTree.bmx"
Include "inc/TVoxelSprite.bmx"
Include "inc/TAction.bmx"
Include "inc/TConstraint.bmx"
Include "inc/TParticleBatch.bmx"
Include "inc/TPostFX.bmx"
'Include "inc/geom.bmx"

' functions
Include "inc/functions_std.bmx"
Include "inc/functions.bmx"
