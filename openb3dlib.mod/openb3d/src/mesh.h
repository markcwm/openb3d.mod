/*
 *  mesh.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef MESH_H
#define MESH_H

#include "entity.h"
#include "bone.h"
#include "surface.h"
#include "brush.h"
#include "texture.h"
#include "tree.h"

#include <iostream>
#include <vector>
#include <list>

extern "C" {
int tri_tri_intersect(float V0[3],float V1[3],float V2[3], float U0[3],float U1[3],float U2[3]);
}



using namespace std;

class MeshCollider;

class Mesh : public Entity{
	
public:

	int no_surfs;
	
	list<Surface*> surf_list;
	list<Surface*> anim_surf_list; // only used if mesh contains anim info, only contains vertex coords array, initialised upon loading b3d
	
	//int no_bones;
	vector<Bone*> bones;
	
	Matrix mat_sp; // mat_sp used in TMesh's Update to provide necessary additional transform matrix for sprites
		
	MeshCollider* c_col_tree;
	int reset_col_tree;

	// reset flags - these are set when mesh shape is changed by various commands in TMesh
	int reset_bounds;
		
	float min_x,min_y,min_z,max_x,max_y,max_z;
	
	// extra
	int shared_surf,shared_anim_surf; // FreeEntity
	
	Mesh(){

		no_surfs=0;
		//no_bones=0;
		
		c_col_tree=NULL;
		reset_col_tree=0;
		
		reset_bounds=true;
		
		min_x=0.0;min_y=0.0;min_z=0.0;max_x=0.0;max_y=0.0;max_z=0.0;
		
		shared_surf=0;shared_anim_surf=0;
	}
	
	// Extra
	static Mesh* NewMesh();
	//Surface* NewSurface();
	//Bone* NewBone();
	void ShadeMesh(Shader* material);
	static void LightMesh(Mesh* m,float red,float green,float blue,float range,float light_x,float light_y,float light_z);

	Mesh* CopyEntity(Entity* ent=NULL);
	void FreeEntity(void);
	static Mesh* CreateMesh(Entity* parent_ent=NULL);
	Surface* CreateSurface(Brush* Bru=NULL);
	Bone* CreateBone(Entity* parent_ent=NULL);
	static Mesh* LoadMesh(string filename,Entity* parent_ent=NULL);
	static Mesh* LoadAnimMesh(string filename,Entity* parent_ent=NULL);
	static Mesh* CreateQuad(Entity* parent_ent=NULL);
	static Mesh* CreatePlane(int divs=1, Entity* parent_ent=NULL);
	static Mesh* CreateCube(Entity* parent_ent=NULL);
	static Mesh* CreateSphere(int segments=8,Entity* parent_ent=NULL);
	static Mesh* CreateCylinder(int verticalsegments=8,int solid=true,Entity* parent_ent=NULL);
	static Mesh* CreateCone(int segments=8,int solid=true,Entity* parent_ent=NULL);
	Mesh* CopyMesh(Entity* parent_ent=NULL);
	Mesh* RepeatMesh(Entity* parent_ent=NULL);
	void AddMesh(Mesh* mesh2);
	void FlipMesh();
	void PaintMesh(Brush* bru);
	void MeshColor(float r,float g,float b,float a);
	void MeshColor(float r,float g,float b);
	void MeshRed(float r);
	void MeshGreen(float g);
	void MeshBlue(float b);
	void MeshAlpha(float a);
	void FitMesh(float x,float y,float z,float width,float height,float depth,int uniform=false);
	void ScaleMesh(float sx,float sy,float sz);
	void RotateMesh(float pitch,float yaw,float roll);
	void PositionMesh(float px,float py,float pz);
	void UpdateNormals();
	float MeshWidth();
	float MeshHeight();
	float MeshDepth();
	int CountSurfaces();
	Surface* GetSurface(int surf_no_get);
	void SkinMesh(int surf_no_get, int vid, int bone1, float weight1=1.0, int bone2=0, float weight2=0, int bone3=0, float weight3=0, int bone4=0, float weight4=0);

	static void CopyBonesList(Entity* ent,vector<Bone*>& bones);
	Mesh* CollapseAnimMesh(Mesh* mesh=NULL);
	Mesh* CollapseChildren(Entity* ent0,Mesh* mesh=NULL);
	void TransformMesh(Matrix& mat);
	void GetBounds();
	int Alpha();
	void TreeCheck();
	int MeshesIntersect(Mesh* mesh2);
	Mesh* MeshCSG(Mesh* mesh2, int method);
	void Update() {};
	void Render();
	void UpdateShadow();
	
};

#endif
