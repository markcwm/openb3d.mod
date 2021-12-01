' openb3dstd.bmx

Strict

Rem
bbdoc: OpenB3D standard Blitz3D functions
about: 
Core 3D functions the same as in Blitz3D. Just a split module with no actual function.
Jump to: <a href=#AddAnimSeq>A</a> &nbsp;<a href=#BrushAlpha>B</a> &nbsp;<a href=#CameraClsColor>C</a> &nbsp;<a href=#DeltaPitch>D</a> &nbsp;<a href=#EntityAlpha>E</a> &nbsp;<a href=#FindChild>F</a> &nbsp;<a href=#GetBrushTexture>G</a> &nbsp;<a href=#HandleSprite>H</a> &nbsp;<a href=#LightColor>L</a> &nbsp;<a href=#MeshDepth>M</a> &nbsp;<a href=#NameEntity>N</a> &nbsp;<a href=#PaintEntity>P</a> &nbsp;<a href=#RenderWorld>R</a> &nbsp;<a href=#ScaleEntity>S</a> &nbsp;<a href=#TerrainHeight>T</a> &nbsp;<a href=#UpdateNormals>U</a> &nbsp;<a href=#VectorPitch>V</a> &nbsp;<a href=#Wireframe>W</a> &nbsp;
End Rem
Module Openb3d.Openb3dstd

ModuleInfo "Version: 1.26"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2021 Mark Mcvittie"
ModuleInfo "Copyright: Library - 2010-2021 Angelo Rosina"

Import Openb3d.Openb3dcore

' functions
Include "../openb3dcore.mod/inc/functions_std.bmx"
