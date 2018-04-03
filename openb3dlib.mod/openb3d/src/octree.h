#ifndef OCTREE_H
#define OCTREE_H

#include "terrain.h"
#include "mesh.h"

using namespace std;

class OcTreeChild{

public:
	OcTreeChild* child[8];
	int isBlock;
	float x, y, z, width, height, depth;
	float node_near, node_far;
	Mesh* mesh;


	void AddToOctree(Mesh* mesh1, int level, float X, float Y, float Z, float Near, float Far, int block);
	void FreeChild();
	OcTreeChild* CopyChild();
	//void FreeOctreeNode(int level, float X, float Y, float Z);
	void RenderChild();
	void Coll_Child();
};

class OcTree : public Terrain{

public:
	OcTreeChild child;

	list<Mesh*> Rendered_Blocks;
	list<Mesh*> Rendered_Meshes;

	static OcTree* CreateOcTree(float w=1, float h=1, float d=1, Entity* parent_ent=0);
	OcTree* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);


	void OctreeMesh(Mesh* mesh, int level, float X, float Y, float Z, float Near=0.0, float Far=1000.0);
	void OctreeBlock(Mesh* mesh, int level, float X, float Y, float Z, float Near=0.0, float Far=1000.0);
	void TreeCheck(CollisionInfo* ci);
	void UpdateTerrain();

};

#endif
