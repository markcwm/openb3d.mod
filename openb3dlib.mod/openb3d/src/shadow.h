/*
 *  shadow.h
 *  minib3d
 *
 *
 */

#ifndef SHADOW_H
#define SHADOW_H

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "surface.h"


class ShadowTriangle{
public:
	int surf;
	int tris;
	float v1x, v1y, v1z;
	float v2x, v2y, v2z;
	float v3x, v3y, v3z;
	float tf_v1x, tf_v1y, tf_v1z;
	float tf_v2x, tf_v2y, tf_v2z;
	float tf_v3x, tf_v3y, tf_v3z;
	float nx, ny, nz;
	int cull;
	int ta, tb, tc;
	ShadowTriangle* id_ta;
	ShadowTriangle* id_tb;
	ShadowTriangle* id_tc;

};

class Edge{
	Surface* surf;
	float data[7];
	
	Edge* Copy(){
		Edge* C = new Edge;
		C->surf = surf;
		for (int i=0;i<=6;i++){
			C->data[i] = data[i];
		}
		return C;
	}
};

class ShadowObject{
public:
	static list<ShadowObject*> shadow_list;

	Mesh* Parent;
	int cnt_tris;
	vector<ShadowTriangle*> Tri;
	Mesh*  ShadowMesh;
	Surface* ShadowVolume;
	Surface* ShadowCap;
	char Render;
	char Static;
	char VCreated;

	static float VolumeLength;
	
	static char top_caps;
	static int parallel;

	static float light_x;
	static float light_y;
	static float light_z;
	static int midStencilVal;
	static float ShadowRed;
	static float ShadowGreen;
	static float ShadowBlue;
	static float ShadowAlpha;
	/*static int Time;
	static int Frame;*/
	static int RenderedVolumes;

	void FreeShadow();
	static ShadowObject* Create(Mesh* Parent, char Static = false);
	void SetShadowColor(int R = 0,int G = 0, int B = 0, int A = 0.5);
	static void ShadowInit();
	void RemoveShadowfromMesh(Mesh* M);
	static void Update(Camera* Cam);
	static void RenderVolume();
	void UpdateAnim();
	void Init();
	void InitShadow();
	void UpdateCaster();
	static void ShadowRenderWorldZFail();
};

#endif

