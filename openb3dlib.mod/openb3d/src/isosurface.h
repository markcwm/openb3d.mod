#ifndef METABALL_H
#define METABALL_H

#include "mesh.h"

#include <iostream>
using namespace std;

class Blob;
class FieldArray;

class Fluid : public Mesh{
friend class VoxelTerrain;

private:
	int* buffercenter;
	float ***xzbuffer;
	float ***xybuffer;
	float ***yzbuffer;

	void ResetBuffers();

	void MarchingCube(float x, float y, float z, float x1, float y1, float z1, float F[8]);

	float MiddlePoint (float A, float B, float C, float D);

	void BuildCubeGrid (float x, float y, float z, float l,
		float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8);

	float (*ScalarField)(float x, float y, float z);
public:
	list<Blob*> metaball_list;

	int render_mode;

	FieldArray* fieldarray;

	void FluidFunction(float (*FieldFunction)(float, float, float));
	void FluidArray(float* Array, int w, int h, int d);

	float threshold;

	int* cells;

	static Fluid* CreateFluid();

	void FreeEntity(void);

	void Render();

};


class Blob : public Entity{
 
public:

	float charge;
	Fluid* fluid;
	
	Blob(){};
	
	Blob* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);
	
	static Blob* CreateBlob(Fluid* fluid, float radius, Entity* parent_ent=NULL);
	void Update(){}
 
 };

class FieldArray : public Entity{
 
public:

	float* data;

	int width, height, depth;
	
	FieldArray(){};
	
	FieldArray* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);
	
	void Update(){}
 
 };

#endif
