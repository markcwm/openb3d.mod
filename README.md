
![OpenB3DMax](./media/openb3d_logo_512.png)

## Introduction

OpenB3DMax is an OpenGL 1.4+ 3D engine for BlitzMax which is based on [Minib3d](https://github.com/si-design/minib3d) which was based on [Blitz3D](https://github.com/blitz-research/blitz3d). Since the standard commands are the same, the Blitz3d manual should be used as a partial reference. Help can be found at the SyntaxBomb [Minib3d Board](http://www.syntaxbomb.com/index.php/board,20.0.html) or the BlitzCoder [Openb3dmax Board](https://www.blitzcoder.org/forum/topics.php?category=16).

## Features

* Works with [BRL BlitzMax](https://github.com/blitz-research/blitzmax) and [BlitzMax NG](https://github.com/bmx-ng/bmx-ng/releases) in 32-bit or 64-bit on Windows, Mac or Linux (no mobile platforms)
* The wrapper is object-oriented with a procedural interface like in Minib3d
* Since entities are objects and not integer handles like in Blitz3D, you must specify their type at creation
* Minib3d types are the same but Type fields are pointers except for lists, also variable names may not be the same
* The coordinate system is not OpenGL orientation, it is left-handed like in Blitz3d and Minib3d
* Works with BRL.MaxGui like in Minib3d, allowing more control of application windows
* BRL.Max2d is used for 2D-in-3D rendering which along with BRL.Graphics is similar to Blitz3d's 2D commands
* The STB Image library is used to load many formats, it supports TGA, BMP, GIF and PSD (also PNG and JPG)
* BRL image loaders are used with PNG and JPG as they are the most complete
* DDS files can also be loaded with support for compressed textures, mipmaps and cubemaps
* File streams are supported by image and mesh loaders, allowing Incbin and [Koriolis.Zipstream](https://github.com/maxmods/koriolis.mod)
* Native 3D model formats are 3DS (no animation), B3D (skeletal animation) and MD2 (vertex interpolation)
* Several more 3D formats can be loaded using the Assimp library wrapper (but no animation)
* Collision detection consists of Blitz3d's ellipsoid-to-something collisions, dynamic collisions are also possible
* Realtime textures are created with BackBufferToTex (for cubemaps) or CameraToTex, also DepthBufferToTex
* Shader post-processing using CameraToTex to render to screen sprites or with PostFX render functions
* Quaternions are used for rotations instead of Eulers as Minib3d uses, this avoids the gimbal lock bug
* Terrains are similar to Blitz3D but UpdateNormals replaces TerrainShading (and TerrainDetail is a constant)
* Vertex and Fragment shaders are supported with examples written to comply with GLSL 1.10 (GL 2.0) syntax
* Shader effects available include bump map, toon, blur, anti alias, colorgrading, depth of field, god rays, bloom
* Dynamic lighting and linear fog either with fixed function or programmable graphics pipelines (shaders)
* Realtime volumetric stencil shadows with self-shadowing from multiple lights (no soft shadows)
* Stencil commands for rendering mirror or portal effects
* CSG (constructive solid geometry) creates a new mesh from existing ones (combine, subtract, intersect)
* Actions using an event-based entity control system, triggered once and then automatically updated
* Basic physics system consisting of constraints and rigid bodies
* Particle emitter system with callback function to allow complete control
* Alternative particle system using batch sprites from Monkey-Minib3d
* Software anti-alias like in Minib3d, also multisample hardware anti-alias (only Windows)
* 3D sound module using Brl.Audio, similar to Blitz3D but sounds can be qued, stopped, paused and resumed per entity

## Status

This wrapper is in a late beta stage of development, so there are still some bugs and missing features. The library has a working GLES2 (WebGL) version but the wrapper doesn't support this yet. The latest version should work with BRL or NG BlitzMax (currently tested with 0.99 release) but you should note that there is an issue with C++11 compilers like GCC 7.x (or Clang/LLVM 5.x) so for now you will probably need an older compiler.

## Installation
* Click on the Github Download zip link, then extract contents to your `BlitzMax/mod` folder
* Remove **-master** from the main **openb3dmax.mod-master** folder (module names must end in **.mod**)
* Also, check the contents of **openb3dmax.mod** contains several different folders with **b3d** in the name
* If on Windows, make sure you have a working version of the MinGW compiler
* If on Mac, make sure you have an appropriate version of XCode installed
* If on Linux, read this guide: [How To: Install BlitzMax NG on Win/Mac/Ubuntu 64-bit](https://www.syntaxbomb.com/index.php/topic,61.0.html)
* To build the mod for BRL Blitzmax, open Command/Terminal, cd to `BlitzMax/bin` and type `bmk makemods -d openb3dmax`
* For Blitzmax NG in 64-bit you use `bmk makemods -d -w -g x64 openb3dmax` (on Mac/Linux you need `./bmk`)
* Or from MaxIDE make sure Quick Build, Debug, GUI App are on, then click Programs > Build Modules

## License

The library is licensed with the GNU LGPL 2.1 or later with an exception by the author to allow static linking. The wrapper is licensed with the zlib license and one module has the BSD-2-Clause license.

## Credits

The OpenB3D library is based on source from iMiniB3D with other core parts from Warner Engine and MiniB3D Extended.

* [Blitz3D](https://github.com/blitz-research/blitz3d) by Mark Sibly
* [MiniB3D](https://github.com/si-design) and iMiniB3D by Simon Harrison
* [OpenB3D](https://sourceforge.net/projects/minib3d/) by Angelo Rosina (Angros47)
* [Warner Engine](https://code.google.com/archive/p/warner-engine/) by Bram den Hond
* [MiniB3D Extended](https://code.google.com/archive/p/minib3dextended/) by Benjamin Rössig (klepto2)
* [bOGL 2](https://github.com/Leushenko/bOGL-2) by Alex Gilding (Leushenko)
* Code contributors: [RonTek](https://www.blitzcoder.org/forum/), [KippyKip](https://github.com/Kippykip), [Krischan](https://github.com/Krischan74), [Hezkore](https://bitbucket.org/Hezkore/), [DruggedBunny](https://github.com/DruggedBunny), [Spinduluz](https://github.com/Spinduluz), RustiKristi

