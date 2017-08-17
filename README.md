
<img src="examples/media/openb3d_logo_512.png" align="left" />

Openb3d library wrapper v1.12 for BlitzMax, an OpenGL 2.0+ 3d engine based on Minib3d which was based on Blitz3D. As a result the documentation partly uses the online Blitz3d manual but this will soon be an offline reference. Help can be found at the SyntaxBomb <a href="http://www.syntaxbomb.com/index.php/board,20.0.html">MiniB3d board</a>.

The wrapper is object-oriented but has a procedural interface like Blitz3D, syntax is not identical but the types are documented and are the same as Minib3d. Max2D is used for 2d-in-3d rendering which replaces the core of the 2d language in Blitz3d, other modules like BRL.Math cover most of the rest. The coordinate system is flipped from OpenGL orientation to be like Blitz3d so porting code is easier. Image loading is done internally by the STB image library instead of BRL image loaders so Pixmaps are not used in textures. Quaternions are used instead of Eulers which prevents gimbal lock.

Many examples are available for testing and extra features include: shaders, stencils for shadows and mirrors, terrains, MD2 animation, particles and DDS textures.

Status
======

After a year off from coding I decided to return to work on this wrapper in my spare time. I left it in a sort-of broken state due to a failed attempt to move to GLES. It is now desktop/GL-only again but since Angros has a working GLES version I will attempt to add Android support using NG. It should work with the latest NG source and if not then try the latest release (currently v0.87). Updates should be fairly frequent.

License
=======

The library is licensed with the GNU LGPL v2.1 or later with an exception to allow static linking. The wrapper is licensed with the zlib license and one module with the BSD-2-Clause license.

