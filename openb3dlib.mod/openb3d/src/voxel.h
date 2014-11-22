#ifndef VOXEL_H
#define VOXEL_H

#include "mesh.h"

#include <iostream>
using namespace std;

class VoxelSprite : public Mesh{

public:

	Material* material[8];
	int no_mats;

	int LOD[16*3];

	static VoxelSprite* CreateVoxelSprite(int slices=64, Entity* parent_ent=NULL);
	void VoxelSpriteMaterial(Material* mat);
	void Render();

};

#endif
