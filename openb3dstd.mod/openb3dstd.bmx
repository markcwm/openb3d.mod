' openb3dstd.bmx

Strict

Rem
bbdoc: OpenB3D standard functions, as in Blitz3D
about: 
Jump to: <a href=#AddAnimSeq>A</a> &nbsp;<a href=#BrushAlpha>B</a> &nbsp;<a href=#CameraClsColor>C</a> &nbsp;<a href=#DeltaPitch>D</a> &nbsp;<a href=#EntityAlpha>E</a> &nbsp;<a href=#FindChild>F</a> &nbsp;<a href=#GetBrushTexture>G</a> &nbsp;<a href=#HandleSprite>H</a> &nbsp;<a href=#LightColor>L</a> &nbsp;<a href=#MeshDepth>M</a> &nbsp;<a href=#NameEntity>N</a> &nbsp;<a href=#PaintEntity>P</a> &nbsp;<a href=#RenderWorld>R</a> &nbsp;<a href=#ScaleEntity>S</a> &nbsp;<a href=#TerrainHeight>T</a> &nbsp;<a href=#UpdateNormals>U</a> &nbsp;<a href=#VectorPitch>V</a> &nbsp;<a href=#Wireframe>W</a> &nbsp;
End Rem
Module Openb3d.Openb3dstd

ModuleInfo "Version: 1.26"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2021 Mark Mcvittie"
ModuleInfo "Copyright: Library - 2010-2021 Angelo Rosina"

' *** Types

' global
Type TGlobal3D
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
