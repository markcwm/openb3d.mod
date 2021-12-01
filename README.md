
![OpenB3D](./media/openb3d_logo_512.png)

## Introduction
OpenB3D is a lightweight OpenGL 1.4+ 3D engine written in C++, this is the BlitzMax wrapper for it. OpenB3D is based on [MiniB3D](https://github.com/si-design/minib3d) which was based on [Blitz3D](https://github.com/blitz-research/blitz3d). Since the standard commands are the same, the Blitz3d manual can be used as a reference. Help can be found at the SyntaxBomb [MiniB3D Board](http://www.syntaxbomb.com/index.php/board,20.0.html) or the BlitzCoder [OpenB3D Board](https://www.blitzcoder.org/forum/topics.php?category=16).

## Features
* Works with [Legacy/BRL BlitzMax](https://github.com/blitz-research/blitzmax) and [BlitzMax NG](https://github.com/bmx-ng/bmx-ng/releases) in 32-bit and 64-bit on Windows, Mac or Linux
* The wrapper is object-oriented with a procedural interface like in MiniB3D
* Since entities are objects (and not integer handles like in Blitz3D) you must specify their type at creation
* Object types are the same as in MiniB3D, but Type fields are pointers except for lists, also some field names were changed
* The coordinate system is not OpenGL orientation, it is left-handed like in Blitz3D
* Works with BRL.MaxGui like MiniB3D, which allows more control of application windows
* BRL.Max2d is used for 2D-in-3D rendering which along with BRL.Graphics is like 2D commands in Blitz3D
* The STB Image library is used to load texture formats, it supports TGA, BMP, GIF and PSD
* BRL image loaders are used for PNG and JPG as they are more stable
* DDS texture files support compressed textures in video memory - needs a tweak to Max2D (see docs/mod folder)
* File streams are supported for textures and meshes, allowing Incbin and [Koriolis.Zipstream](https://github.com/maxmods/koriolis.mod)
* Native 3D model formats are 3DS, OBJ (no animation), B3D (skeletal animation) and MD2 (vertex interpolation)
* Several more 3D formats can be loaded with the Assimp library wrapper - no animation
* Collision detection consists of Blitz3d's ellipsoid-to-something collisions, dynamic collisions are possible
* Realtime textures are created with BackBufferToTex (for cubemaps) or CameraToTex, also DepthBufferToTex
* Shader post-processing uses CameraToTex to render to screen sprites or PostFX framebuffer rendering
* Quaternions are used for rotations instead of Eulers in MiniB3D, this avoids Gimbal lock
* Terrains are similar to Blitz3D but UpdateNormals replaces TerrainShading, TerrainDetail takes a smaller value
* Vertex and Fragment shaders with examples written to comply with GLSL 1.10 (GL 2.0)
* Shader effects include bump map, toon, blur, anti alias, colorgrading, depth of field, bloom
* Dynamic lighting and linear fog with fixed function or programmable graphics (shaders)
* Realtime volumetric stencil shadows with self-shadowing from multiple lights - no soft shadows
* Stencil commands for rendering mirror or portal effects
* CSG (constructive solid geometry) creates a mesh from existing ones (combine, subtract, intersect)
* Actions use an event-based entity control system, triggered once and then automatically updated
* Basic physics system consisting of constraints and rigid bodies
* Newton library wrapper but only supports primitives
* Sprites are now all from a single surface
* Particle emitter system with callback function for custom controls, uses sprites
* Particle Candy port, an advanced single surface particle system
* Software anti-alias like in MiniB3D, also multisample hardware anti-alias - only Windows

## Status

The wrapper is still in development, there are still bugs and missing features. I maintain it in my spare time, issues and pull requests are welcome. The library has a working GLES2 (WebGL) version, the wrapper still doesn't support it but maybe later! It should work with BRL or NG BlitzMax (on testing with v1.29 release). Note: I had issues with C++11 GCC 7.x or Clang/LLVM 5.x versions, not sure but if you have these try using a more recent compiler.

## Installation
* Click on the Github Download zip link and extract to your `BlitzMax/mod` folder
* Remove **-master** from the **openb3d.mod-master** folder - modules must end in **.mod**
* On Windows, you need a working version of the MinGW compiler
* On Mac, you need a compatible version of XCode installed
* On Linux, read my guide: [How To: Install BlitzMax NG on Win/Mac/Ubuntu 64-bit](https://www.syntaxbomb.com/index.php/topic,61.0.html)
* To build for BRL Blitzmax, open Cmd, cd to `BlitzMax/bin` and type `bmk makemods -d openb3d`
* For Blitzmax NG in 64-bit use `bmk makemods -d -w -g x64 openb3d` - on Unix use `./bmk`
* Or from MaxIDE enable Quick Build, Debug, GUI App then Build Modules
* To syntax highlight commands use `./makedocs` or the MaxIDE option Rebuild Documentation

## License
The library is licensed with the GNU LGPL 2.1 or later with an exception to allow static linking. The wrapper is licensed with the zlib license and Assimp has the BSD-2-Clause license.

## Credits
The OpenB3D library is based on source from iMiniB3D, other core parts are from Warner Engine and MiniB3D Extended.

* [Blitz3D](https://github.com/blitz-research/blitz3d) by Mark Sibly
* [MiniB3D](https://github.com/si-design) and iMiniB3D by Simon Harrison
* [OpenB3D](https://sourceforge.net/projects/minib3d/) by Angelo Rosina (Angros47)
* [Warner Engine](https://code.google.com/archive/p/warner-engine/) by Bram den Hond
* [MiniB3D Extended](https://code.google.com/archive/p/minib3dextended/) by Benjamin Rössig (klepto2)
* [bOGL 2](https://github.com/Leushenko/bOGL-2) by Alex Gilding (Leushenko)
* Coding help: [RonTek](https://www.blitzcoder.org/forum/), [Krischan](https://github.com/Krischan74), [KippyKip](https://github.com/Kippykip), [Spinduluz](https://github.com/Spinduluz), [DruggedBunny](https://github.com/DruggedBunny), [Hezkore](https://bitbucket.org/Hezkore/)

