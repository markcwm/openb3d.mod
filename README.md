openb3d.mod
===========

BlitzMax wrapper for Openb3d library version 1.1, an OpenGL 2.0-ready 3d engine based on Minib3d which is itself based on Blitz3D. As a result the documentation mainly uses the online Blitz3d manual and help is always available at the www.blitzmax.com boards.

The wrapper is object-oriented and also has a procedural interface like Blitz3D, so syntax is not identical but the types are documented. The Max2D module is used for 2d-in-3d rendering which replaces the core of the 2d language set in Blitz3d, other modules cover the rest. The coordinate system is flipped from the OpenGL orientation to be like Blitz3d so porting code will be easier.

Several examples are included to get you started and extra features built in include: terrains, stencil shadows, particles, md2 animation, shaders and post processing shaders.

License
=======

OpenB3D is licensed under the GNU LGPLv2 or later, with an exception to allow static linking.

