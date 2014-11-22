#ifndef CSG_H
#define CSG_H

#include "mesh.h"
#include "surface.h"

class CSGTriangle{
public:
	static list<CSGTriangle*> CSGTriangle_list;

	//mesh ref.
	Mesh* mesh;
	Surface* surf;
	//vertex coords
	float x0,y0,z0,u0,v0;
	float x1,y1,z1,u1,v1;
	float x2,y2,z2,u2,v2;
	//plane normal/d
	float nx,ny,nz;
	float onx,ony,onz;
	float d;
	//flags
	int loop;
};

namespace CSG{
Mesh* MeshCSG(Mesh* m1, Mesh* m2, int method = 1);
}

#endif
