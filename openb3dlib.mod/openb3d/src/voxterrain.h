#ifndef VOXTERRAIN_H
#define VOXTERRAIN_H

#include "terrain.h"
#include "metaball.h"

class VoxelTerrain : public Terrain{

private:
	float ***tbuffer;

	void MarchingCube(float x, float y, float z, float x1, float y1, float z1, float F[8]);
	float MiddlePoint (float A, float B, float C, float D);
	void BuildCubeGrid (float x, float y, float z, float l,
		float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8);


public:

	static VoxelTerrain* CreateVoxelTerrain(int w=1, int h=1, int d=1, Entity* parent_ent=0);
	static VoxelTerrain* LoadVoxelTerrain(string filename, Entity* parent_ent=0);
	VoxelTerrain* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);

	void RecreateOctree();
	void UpdateTerrain();

	void TreeCheck(CollisionInfo* ci);

};

#endif
