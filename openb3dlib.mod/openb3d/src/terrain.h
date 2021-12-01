/*
 *  terrain.h
 *  minib3d
 *
 *
 */

#ifndef TERRAIN_H
#define TERRAIN_H


#include <iostream>
#include <string>

#include "shadermat.h"


using namespace std;

const int ROAM_LMAX = 20; 		//<-----------terrain levels of detail, maximum is 20

class Terrain : public Entity{
private:
	float dradius;
	float* NormalsMapOld; // public
	float xcf,ycf,zcf; 			//used to store camera position

public:
	static list<Terrain*> terrain_list;
	//static int triangleindex;
	static MeshInfo* mesh_info;
	//static vector<float> vertices;
	static float Roam_Detail;
	
	float size; 				//terrainsize
	float vsize; 				//terrainheight
	float level2dzsize[ROAM_LMAX+1]; 	// Max midpoint displacement per level
	float* HeightMap; 				//heightmap
	
	MeshCollider* c_col_tree;
	Camera* eyepoint; 			//reference to camera
#ifdef GLES2
	unsigned int vbo_id;
#endif
	Shader* ShaderMat;
	
	vector<float> vertices;
	vector<float> tex_coords1;
	
	int triangleindex;
	int vertexindex;
	float* NormalsMap;
	
	float uscale0, vscale0, uscale1, vscale1;
	
	static Terrain* CreateTerrain(int tsize=0, Entity* parent_ent=NULL);
	static Terrain* LoadTerrain(string filename,Entity* parent_ent=NULL);
	Terrain* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);

	virtual void UpdateTerrain();
	void RecreateROAM();
	void drawsub(int l, float v0[], float v1[], float v2[]);
	void UpdateNormals();
	void ModifyTerrain (int x, int z, float height);
	virtual void TreeCheck(CollisionInfo* ci);
	void col_tree_sub(int l, float v0[], float v1[], float v2[]);
	float TerrainHeight (int x, int z);
	float TerrainX (float x, float y, float z);
	float TerrainY (float x, float y, float z);
	float TerrainZ (float x, float y, float z);
	void TerrainDetail(float detail_level);
	void ScaleTexCoords(float u_scale,float v_scale,int coords_set);
	
	Terrain(){
		size=0;
		ShaderMat=0;
		uscale0=1; vscale0=1; uscale1=1; vscale1=1;
	};



	


};

#endif
