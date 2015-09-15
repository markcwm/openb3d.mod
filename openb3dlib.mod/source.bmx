' Copyright (c) 2014 Mark Mcvittie, Angelo Rosina, Bruce A Henderson
'
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
'    1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
'
'    2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
'
'    3. This notice may not be removed or altered from any source
'    distribution.
'
SuperStrict

Import "../../pub.mod/glew.mod/GL/*.h"

Import "openb3d/src/*.h"

Import "openb3d/src/3ds.cpp"
Import "openb3d/src/actions.cpp" ' 1.1
Import "openb3d/src/animation.cpp"
Import "openb3d/src/animation_keys.cpp"
Import "openb3d/src/bank.cpp"
Import "openb3d/src/bone.cpp"
Import "openb3d/src/brush.cpp"
Import "openb3d/src/camera.cpp"
Import "openb3d/src/collision.cpp"
Import "openb3d/src/collision2.cpp"
Import "openb3d/src/csg.cpp"
Import "openb3d/src/entity.cpp"
Import "openb3d/src/file.cpp"
Import "openb3d/src/functions.cpp"
Import "openb3d/src/geom.cpp"
Import "openb3d/src/geosphere.cpp" ' 0.8
Import "openb3d/src/global.cpp"
Import "openb3d/src/isosurface.cpp" ' was metaball 0.9
Import "openb3d/src/light.cpp"
Import "openb3d/src/material.cpp"
Import "openb3d/src/maths_helper.cpp"
Import "openb3d/src/matrix.cpp"
Import "openb3d/src/md2.cpp" ' 0.9
Import "openb3d/src/mesh.cpp"
Import "openb3d/src/model.cpp"
Import "openb3d/src/octree.cpp"
Import "openb3d/src/particle.cpp" ' 0.9
Import "openb3d/src/physics.cpp" ' 1.1
Import "openb3d/src/pick.cpp"
Import "openb3d/src/pivot.cpp"
Import "openb3d/src/project.cpp"
Import "openb3d/src/quaternion.cpp"
Import "openb3d/src/shadow.cpp"
Import "openb3d/src/sprite.cpp"
Import "openb3d/src/sprite_batch.cpp"
Import "openb3d/src/stencil.cpp"
Import "openb3d/src/string_helper.cpp"
Import "openb3d/src/surface.cpp"
Import "openb3d/src/terrain.cpp"
Import "openb3d/src/texture.cpp"
Import "openb3d/src/texture_filter.cpp"
Import "openb3d/src/tilt.cpp"
Import "openb3d/src/touch.cpp"
Import "openb3d/src/tree.cpp"
'Import "openb3d/src/turn.cpp" ' deprecated
Import "openb3d/src/voxel.cpp"
Import "openb3d/src/x.cpp"

Import "openb3d/src/collidetri.c"
Import "openb3d/src/stb_image.c"

Import "methods.cpp" ' must be imported in this file on Mac
Import "data.cpp"
