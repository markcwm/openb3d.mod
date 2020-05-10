' openb3dmax.newtonb3d

SuperStrict

'Rem

Rem
bbdoc: OpenB3DMax Newton wrapper
about:
The wrapper using declarations from Newton.Dynamics module
End Rem
Module Openb3dmax.Newtonb3d

ModuleInfo "Version: 1.00"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Newton Dynamics - 2003-2011 Julio Jerez and Alain Suero"
ModuleInfo "Copyright: Newton Wrapper - 2015-2016 Bruce A Henderson"
ModuleInfo "Copyright: NewtonB3D Wrapper - 2016 James Boyd (HiToro/DruggedBunny)"

'EndRem

Import Openb3dmax.B3dglgraphics
Import Newton.Dynamics

Include "inc/newtonbody.bmx"
Include "inc/newtonground.bmx"
Include "inc/newtoncube.bmx"
Include "inc/newtonsphere.bmx"
Include "inc/functions.bmx"
