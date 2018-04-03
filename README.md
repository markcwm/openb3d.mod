
![Openb3d](./examples/media/openb3d_logo_512.png)

## Introduction

Openb3d is an OpenGL 2.0+ 3d engine for BlitzMax that is based on [Minib3d](https://github.com/si-design/minib3d) which is itself based on Blitz3D. Since the standard commands are the same, the Blitz3d manual can be used as a partial reference. Help can be found at the SyntaxBomb [MiniB3d Board](http://www.syntaxbomb.com/index.php/board,20.0.html).

## Features 

* Works with [BlitzMax NG](https://github.com/bmx-ng/bmx-ng/releases) in 32-bit or 64-bit on Windows, Mac or Linux (currently no mobile platforms)
* The wrapper is object-oriented with a procedural interface as in Minib3d
* Minib3d types are the same but all fields are pointers apart from lists, also variable names may not be the same
* Since entities are objects not integer handles as in Blitz3D you need to specify their type at creation
* The coordinate system is flipped from OpenGL orientation to be left-handed as in Blitz3d and Minib3d
* Works with BRL.MaxGUI as in Minib3d, for control of application windows
* BRL.Max2D is used for 2D-in-3D rendering which along with BRL.Graphics is like Blitz3d's graphics commands
* Image loading is done by the STB image library which supports JPG, PNG, TGA, BMP, GIF and others
* The wrapper loads DDS files with mipmaps or compressed textures
* The wrapper supports streams like Incbin and Zipstream with BRL image loaders and BlitzMax model loaders (WIP)
* Model formats include 3DS (currently no animation), B3D (skeletal animation) and MD2 (vertex interpolation)
* Several more formats can be loaded using the Assimp library wrapper (currently no animation)
* Collision detection is as in Minib3d and consists of Blitz3d's ellipsoid-to-something collisions
* Dynamic textures are created with BackBufferToTex (cubemapping) or CameraToTex for use in post-processing effects
* Quaternions are used for rotations instead of Eulers as in Minib3d, this avoids gimbal lock
* Terrains are much like Blitz3D's but UpdateNormals replaces TerrainShading and TerrainDetail is a constant
* Vertex and Fragment shaders are supported with examples written to comply with GLSL 1.10 (GL 2.0) syntax
* Shader effects currently include bump mapping, toon shading, blur and water
* Dynamic lighting and linear fog either with fixed function or programmable graphics pipelines (ie. shaders)
* Realtime volumetric stencil shadows with self-shadowing from multiple lights
* Stencil commands for rendering mirror or portal effects
* Particle emitter system with support for custom effects by using a callback function
* CSG (constructive solid geometry) creates a new mesh from existing ones (combine, subtract or intersect)
* Actions are an event-based entity control system, they are triggered once and then automatically updated
* Physics system consisting of constraints and rigid bodies
* Also includes geospheres (spherical terrains) and metaballs (fluids)

## Status

After giving up coding for a year (due to lack of time and enthusiasm) I returned to work on this wrapper in my spare time with the goal of getting it into a finished, bug-free state. When I left it, the last commit was sort-of broken due to a failed attempt to move to GLES. Since Angros now has a working WebGL/GLES2 version I will try to add Android support using NG. It should work with the latest NG source, if not then try the latest release (currently 0.87).

## License

The library is licensed with the GNU LGPL 2.1 or later with an exception to allow static linking. The wrapper is licensed with the zlib license and one module with the BSD-2-Clause license.

