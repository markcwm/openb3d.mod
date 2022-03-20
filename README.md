
![OpenB3D](./media/openb3d_logo_512.png)

## Introduction
OpenB3D is a lightweight OpenGL 1.4+ 3D engine written in C++, this is the BlitzMax wrapper for it. OpenB3D is based on [MiniB3D](https://github.com/si-design/minib3d) which was based on [Blitz3D](https://github.com/blitz-research/blitz3d). Help might be found at the SyntaxBomb [MiniB3D Board](http://www.syntaxbomb.com/index.php/board,20.0.html) or the BlitzCoder [OpenB3D Board](https://www.blitzcoder.org/forum/topics.php?category=16).

## Features
* Works with [Legacy BRL BlitzMax](https://github.com/blitz-research/blitzmax) but is really supposed to be for [BlitzMax NG](https://github.com/bmx-ng/bmx-ng/releases) on Windows, Mac or Linux
* Object-oriented with methods and a procedural interface of functions, like MiniB3D
* Entities are objects (and not integer handles like Blitz3D) so you must specify their type
* Types are as in MiniB3D, but fields are all pointers, except Tlists which are the same
* Coordinate system is not OpenGL orientation, it is left-handed like Blitz3D
* Works with BRL.MaxGui like MiniB3D, this allows more control of windows
* BRL.Max2d provides 2D-in-3D rendering, along with BRL.Graphics this adds many 2D commands found in Blitz3D
* The STB Image library loads texture formats, this provides support for TGA, BMP, GIF and PSD
* BRL image loaders are used for PNG and JPG as they were more stable
* Support for DDS with compressed textures in video memory but this needs a module tweak to Max2D (now in latest NG)
* File streams for textures and meshes for Incbin and zip files with [Koriolis.Zipstream](https://github.com/maxmods/koriolis.mod)
* 3D model formats are 3DS, OBJ (no animation), B3D (skeletal animation) and MD2 (vertex interpolation)
* Several more 3D formats can be loaded with the Assimp wrapper but no animation yet
* Collision detection with Blitz3D's ellipsoid-to-something collisions, dynamic collisions are possible
* Realtime textures created with BackBufferToTex, CameraToTex and DepthBufferToTex
* Shader post-processing with either CameraToTex rendering to screen sprite or PostFX rendering to framebuffer
* Quaternions are used for rotations instead of Eulers like MiniB3D, avoids Gimbal lock
* Terrains are like Blitz3D, UpdateNormals replaces TerrainShading, alpha maps and shaders now work
* Vertex and Fragment shaders examples written to comply with GLSL 1.10 (GL 2.0)
* Shader effects include bump map, toon, per pixel lighting, anti alias, colorgrading, depth of field, bloom
* Dynamic lighting and linear fog with either fixed function or shaders
* Realtime volumetric stencil shadows with self-shadowing from multiple lights - no soft shadows
* Stencil commands for mirror and portal type effects
* CSG (constructive solid geometry) combine, subtract and intersect
* Event-based entity control system called Actions, triggered once and then automatically update
* Basic physics system consisting of constraints and rigid bodies
* Newton library wrapper has support for primitives but no vehicles, ragdolls, etc
* Sprites are all from a single surface, so very fast
* Particle emitter system with callback function for custom controls, uses sprites
* Particle Candy module for alternative particle system, not completed
* Software anti-alias like MiniB3D, multisample hardware anti-alias but only in Windows with a module tweak

## Status

I have very little spare time to work on the wrapper now but I will still try to look at pull requests and respond to issues that address bugs whether on Github or the boards.

## Installation
* Extract the zip to `BlitzMax/mod` folder
* Remove **-master** from the **openb3d** folder name - modules must end in **.mod**
* On Windows, you need a working version of the MinGW compiler
* On Mac, you need a compatible version of XCode installed
* On Linux, read this guide [How To: Install BlitzMax NG on Win/Mac/Ubuntu 64-bit](https://www.syntaxbomb.com/index.php/topic,61.0.html)
* To build with BRL Blitzmax, open Cmd, cd to `BlitzMax/bin` and type `bmk makemods -d openb3d`
* For Blitzmax NG in 64-bit use `bmk makemods -d -w -g x64 openb3d` - on Unix use `./bmk`
* Or from MaxIDE enable Quick Build, Debug, GUI App and Build Modules
* To syntax highlight the commands use `./makedocs` or MaxIDE's Rebuild Documentation

## License
The library is licensed with the GNU LGPL 2.1 or later with an exception to allow static linking and the wrapper is licensed with the permissive zlib license.

## Credits
The OpenB3D library was based iMiniB3D, other core parts were ported from Warner Engine and MiniB3D Extended.

* [Blitz3D](https://github.com/blitz-research/blitz3d) by Mark Sibly
* [MiniB3D](https://github.com/si-design) and iMiniB3D by Simon Harrison
* [OpenB3D](https://sourceforge.net/projects/minib3d/) by Angelo Rosina (Angros47)
* [Warner Engine](https://code.google.com/archive/p/warner-engine/) by Bram den Hond
* [MiniB3D Extended](https://code.google.com/archive/p/minib3dextended/) by Benjamin Rössig (klepto2)
* [bOGL 2](https://github.com/Leushenko/bOGL-2) by Alex Gilding (Leushenko)
* I am grateful to: [RonTek](https://www.blitzcoder.org/forum/), [Krischan](https://github.com/Krischan74), [KippyKip](https://github.com/Kippykip), [Spinduluz](https://github.com/Spinduluz), [DruggedBunny](https://github.com/DruggedBunny), [Hezkore](https://bitbucket.org/Hezkore/) for their coding help

