CC = g++
CFLAGS = -Wall -O3 -m32

OBJECTS = model.o string_helper.o surface.o bank.o bone.o brush.o collision.o entity.o \
	functions.o geom.o global.o light.o matrix.o pick.o pivot.o project.o sprite.o tilt.o \
	touch.o texture_filter.o tree.o animation.o animation_keys.o collision2.o maths_helper.o \
	quaternion.o sprite_batch.o camera.o file.o mesh.o texture.o terrain.o stb_image.o 3ds.o \
	collidetri.o shadow.o material.o stencil.o csg.o voxel.o x.o octree.o geosphere.o \
	md2.o particle.o metaball.o GLee.o


main : $(OBJECTS)
ifeq ($(shell uname), Linux)
	$(CC) $(CFLAGS) -shared -o libopenb3d.so $(OBJECTS)  -lGL -lGLU
endif
ifeq ($(shell uname), Darwin)
	$(CC) $(CFLAGS) -shared -o libopenb3d.dylib $(OBJECTS)  -framework CoreFoundation -framework OpenGL
endif
ifeq "$(OS)" "Windows_NT"
	$(CC) $(CFLAGS) -shared -o libopenb3d.dll $(OBJECTS)  -lopengl32 -lglu32 -lGDI32
endif

archive : $(OBJECTS)
ifeq ($(shell uname), Linux)
	ar -cvq libopenb3d-lin.a $(OBJECTS)
endif
ifeq ($(shell uname), Darwin)
	ar -cvq libopenb3d-mac.a $(OBJECTS)
endif
ifeq "$(OS)" "Windows_NT"
	ar -cvq libopenb3d-win.a $(OBJECTS)
endif


3ds.o : 3ds.cpp 3ds.h
	$(CC) $(CFLAGS) -c 3ds.cpp -o 3ds.o
	
md2.o  : md2.cpp md2.h
	$(CC) $(CFLAGS) -c md2.cpp -o md2.o

bank.o : bank.cpp bank.h
	$(CC) $(CFLAGS) -c bank.cpp -o bank.o

bone.o : bone.cpp bone.h
	$(CC) $(CFLAGS) -c bone.cpp -o bone.o

brush.o : brush.cpp brush.h
	$(CC) $(CFLAGS) -c brush.cpp -o brush.o

camera.o : camera.cpp camera.h
	$(CC) $(CFLAGS) -c camera.cpp -o camera.o

collision.o : collision.cpp collision.h
	$(CC) $(CFLAGS) -c collision.cpp -o collision.o

entity.o : entity.cpp entity.h
	$(CC) $(CFLAGS) -c entity.cpp -o entity.o

file.o : file.cpp file.h
	$(CC) $(CFLAGS) -c file.cpp -o file.o

functions.o : functions.cpp
	$(CC) $(CFLAGS) -c functions.cpp -o functions.o	

geom.o : geom.cpp geom.h
	$(CC) $(CFLAGS) -c geom.cpp -o geom.o
	
geosphere.o : geosphere.cpp geosphere.h
	$(CC) $(CFLAGS) -c geosphere.cpp -o geosphere.o

global.o : global.cpp global.h
	$(CC) $(CFLAGS) -c global.cpp -o global.o

light.o : light.cpp light.h
	$(CC) $(CFLAGS) -c light.cpp -o light.o

matrix.o : matrix.cpp matrix.h
	$(CC) $(CFLAGS) -c matrix.cpp -o matrix.o

mesh.o : mesh.cpp mesh.h
	$(CC) $(CFLAGS) -c mesh.cpp -o mesh.o

model.o : model.cpp model.h
	$(CC) $(CFLAGS) -c model.cpp -o model.o

pick.o : pick.cpp pick.h
	$(CC) $(CFLAGS) -c pick.cpp -o pick.o

pivot.o : pivot.cpp pivot.h
	$(CC) $(CFLAGS) -c pivot.cpp -o pivot.o

project.o : project.cpp project.h
	$(CC) $(CFLAGS) -c project.cpp -o project.o

sprite.o : sprite.cpp sprite.h
	$(CC) $(CFLAGS) -c sprite.cpp -o sprite.o

surface.o : surface.cpp surface.h
	$(CC) $(CFLAGS) -c surface.cpp -o surface.o

terrain.o : terrain.cpp terrain.h stb_image.c
	$(CC) $(CFLAGS) -c terrain.cpp -o terrain.o

texture.o : texture.cpp texture.h stb_image.c
	$(CC) $(CFLAGS) -c texture.cpp -o texture.o

tilt.o : tilt.cpp tilt.h
	$(CC) $(CFLAGS) -c tilt.cpp -o tilt.o

touch.o : touch.cpp touch.h
	$(CC) $(CFLAGS) -c touch.cpp -o touch.o

string_helper.o : string_helper.cpp string_helper.h
	$(CC) $(CFLAGS) -c string_helper.cpp -o string_helper.o

texture_filter.o : texture_filter.cpp texture_filter.h
	$(CC) $(CFLAGS) -c texture_filter.cpp -o texture_filter.o

tree.o : tree.cpp tree.h
	$(CC) $(CFLAGS) -c tree.cpp -o tree.o

animation.o : animation.cpp animation.h
	$(CC) $(CFLAGS) -c animation.cpp -o animation.o

animation_keys.o : animation_keys.cpp animation_keys.h
	$(CC) $(CFLAGS) -c animation_keys.cpp -o animation_keys.o

collision2.o : collision2.cpp collision2.h
	$(CC) $(CFLAGS) -c collision2.cpp -o collision2.o

material.o : material.cpp 
	$(CC) $(CFLAGS) -c material.cpp -o material.o

maths_helper.o : maths_helper.cpp maths_helper.h
	$(CC) $(CFLAGS) -c maths_helper.cpp -o maths_helper.o
	
particle.o : particle.cpp particle.h
	$(CC) $(CFLAGS) -c particle.cpp -o particle.o

quaternion.o : quaternion.cpp quaternion.h
	$(CC) $(CFLAGS) -c quaternion.cpp -o quaternion.o

shadow.o : shadow.cpp shadow.h
	$(CC) $(CFLAGS) -c shadow.cpp -o shadow.o

sprite_batch.o : sprite_batch.cpp sprite_batch.h
	$(CC) $(CFLAGS) -c sprite_batch.cpp -o sprite_batch.o

stb_image.o	: stb_image.c
	gcc $(CFLAGS) -c stb_image.c -o stb_image.o

stencil.o : stencil.cpp stencil.h
	$(CC) $(CFLAGS) -c stencil.cpp -o stencil.o

csg.o : csg.cpp csg.h
	$(CC) $(CFLAGS) -c csg.cpp -o csg.o
	
metaball.o : metaball.cpp metaball.h
	$(CC) $(CFLAGS) -c metaball.cpp -o metaball.o

octree.o : octree.cpp octree.h
	$(CC) $(CFLAGS) -c octree.cpp -o octree.o

voxel.o : voxel.cpp voxel.h
	$(CC) $(CFLAGS) -c voxel.cpp -o voxel.o

x.o : x.cpp x.h
	$(CC) $(CFLAGS) -c x.cpp -o x.o

collidetri.o : collidetri.c
	gcc $(CFLAGS) -c collidetri.c -o collidetri.o

GLee.o : GLee.c
	gcc $(CFLAGS) -c GLee.c -o GLee.o


clean :
ifeq "$(OS)" "Windows_NT"
	del $(OBJECTS) libopenb3d.dll libopenb3d.dylib libopenb3d.so libopenb3d-win.a libopenb3d-mac.a libopenb3d-lin.a
else
	rm -rf $(OBJECTS) libopenb3d.dll libopenb3d.dylib libopenb3d.so libopenb3d-win.a libopenb3d-mac.a libopenb3d-lin.a
endif
