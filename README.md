![alt text](https://raw.githubusercontent.com/markcwm/openb3d.mod/examples/media/openb3d_logo_512.png)

BlitzMax wrapper for Openb3d library version 1.1, an OpenGL 2.0-capable 3d engine based on Minib3d which is itself based on Blitz3D. As a result the documentation mainly uses the online Blitz3d manual and help can be found at the www.blitzmax.com boards.

The wrapper is object-oriented and also has a procedural interface like Blitz3D, so syntax is not identical but the types are documented and are the same as in Minib3d. The Max2D module is used for 2d-in-3d rendering which replaces the core of the 2d language set in Blitz3d, other modules such as Brl.Math cover the rest. The coordinate system is flipped from the OpenGL orientation to be like Blitz3d so porting code will be easier. Image loading is done by the STB image library instead of Brl image loaders so Pixmaps are not used in textures. Also, Quaternions are used instead of Eulers which prevents gimbal lock.

Several examples are included for testing and extra features include: particles, stencil tests for shadows and clipping, terrains, B3D and MD2 animation, shaders with post processing.

Status
======

After a year-long break from coding I have returned to work on this wrapper in my spare time. I left this project with a broken latest version which was due to a failed attempt to move to GLES. It has now been reverted to desktop/GL only and will probably stay that way since I am not familiar with GLES. I do intend for it to be compatible with BlitzMax NG, the current version it works with is 0.77. Updates should be small but fairly frequent.

License
=======

OpenB3D is licensed under the GNU LGPLv2 or later, with an exception to allow static linking.

