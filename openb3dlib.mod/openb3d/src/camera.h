#ifndef CAMERA_H
#define CAMERA_H

/*
 *  camera.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "global.h"
#include "entity.h"
#include "mesh.h"
#include "sprite.h"

#include <vector>
#include <cmath>

using namespace std;

class Camera : public Entity{

public:

	static list<Camera*> cam_list;
	static list<Mesh*> render_list;

	int vx,vy,vwidth,vheight;
	float cls_r,cls_g,cls_b;
	bool cls_color,cls_zbuffer;

	float range_near,range_far;
	float zoom;

	int proj_mode;

	int fog_mode;
	float fog_r,fog_g,fog_b;
	float fog_range_near,fog_range_far;

	// used by CameraProject
	int project_enabled;
	float mod_mat[16];
	float proj_mat[16];
	int viewport[4];
	static float projected_x;
	static float projected_y;
	static float projected_z;

	float frustum[6][4];

	Camera(){

		vx=0,vy=0;
		vwidth=320,vheight=480;
		cls_r=0.0,cls_g=0.0,cls_b=0.0;

		cls_color=true,cls_zbuffer=true;

		range_near=1.0;
		range_far=1000.0;
		zoom=1.0;
		proj_mode=1;

		fog_mode=0;
		fog_r=0.0,fog_g=0.0,fog_b=0.0;
		fog_range_near=1.0,fog_range_far=1000.0;

		project_enabled=false;

	}

	Camera* CopyEntity(Entity* parent_ent);
	void FreeEntity(void);

	static Camera* CreateCamera(Entity* parent_ent=NULL);

	void CameraViewport(int,int,int,int);
	void CameraClsColor(float r,float g,float b);
	void CameraClsMode(int color,int zbuffer);
	void CameraRange(float near,float far);
	void CameraZoom(float zoom_val);
	void CameraProjMode(int mode=1);
	void CameraFogMode(int mode);
	void CameraFogColor(float r,float g,float b);
	void CameraFogRange(float near,float far);

	void CameraProject(float x,float y,float z);
	static float ProjectedX();
	static float ProjectedY();
	static float ProjectedZ();

	float EntityInView(Entity* ent);
	void ExtractFrustum();
	float EntityInFrustum(Entity* ent);

	void Update();
	void Render();

	void UpdateSprite(Sprite& sprite);
	void AddTransformedSpriteToSurface(Sprite& sprite,Surface* surf);

	void RenderListAdd(Mesh* mesh);

	void accPerspective(float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus);
	void accFrustum(float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus);
	void UpdateProjMatrix();

};

void UpdateEntityRender0(Entity* ent,Entity* cam=NULL);
void UpdateEntityRender(Entity* ent,Entity* cam=NULL);

#endif

