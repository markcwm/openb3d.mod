/*
 *  stencil.h
 *  minib3d
 *
 *
 */

#ifndef STENCIL_H
#define STENCIL_H

#include "entity.h"
#include "camera.h"
#include "mesh.h"
//#include "surface.h"

class Stencil{
	public:

	static int midStencilVal;

	list<Mesh*> StencilMesh_list;
	list<int> StencilMode_list;

	float cls_r,cls_g,cls_b;
	bool cls_color,cls_zbuffer;

	float alpha;
	int stencil_mode;
	int stencil_operator;

	Stencil(){
		cls_r=0;cls_g=0;cls_b=0;
		cls_color=true;cls_zbuffer=true;
		alpha=1;
		stencil_mode=1;
		stencil_operator=1;
	}

	static Stencil* CreateStencil();
	void StencilMesh(Mesh* mesh, int mode=1);
	void StencilClsColor(float r,float g,float b);
	void StencilClsMode(int color,int zbuffer);
	void StencilAlpha(float a);
	void StencilMode(int m, int o=1);

	void UseStencil();
	
};




#endif

