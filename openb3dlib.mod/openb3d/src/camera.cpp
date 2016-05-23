#ifdef linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glu.h>
#endif


/*
 *  camera.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

//#define GLES2


#include "global.h"
#include "entity.h"
#include "camera.h"
#include "light.h"
#include "sprite.h"
#include "sprite_batch.h"
#include "particle.h"
#include "pick.h"
#include "project.h"
//#include "misc.h"

list<Camera*> Camera::cam_list;
list<Mesh*> Camera::render_list;

float Camera::projected_x,Camera::projected_y,Camera::projected_z;

Camera* Camera::CopyEntity(Entity* parent_ent){

	// new cam
	Camera* cam=new Camera;
	
	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(cam);
	}
	
	// lists
	
	// add parent, add to list
	cam->AddParent(*parent_ent);
	entity_list.push_back(cam);
	
	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(cam);
	}
	
	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(cam);
	}
	
	// update matrix
	if(cam->parent){
		cam->mat.Overwrite(cam->parent->mat);
	}else{
		cam->mat.LoadIdentity();
	}
	
	// copy entity info
	
	cam->mat.Multiply(mat);
	
	cam->px=px;
	cam->py=py;
	cam->pz=pz;
	cam->sx=sx;
	cam->sy=sy;
	cam->sz=sz;
	cam->rx=rx;
	cam->ry=ry;
	cam->rz=rz;
	cam->qw=qw;
	cam->qx=qx;
	cam->qy=qy;
	cam->qz=qz;

	cam->name=name;
	cam->class_name=class_name;
	cam->order=order;
	cam->hide=false;
	
	cam->cull_radius=cull_radius;
	cam->radius_x=radius_x;
	cam->radius_y=radius_y;
	cam->box_x=box_x;
	cam->box_y=box_y;
	cam->box_z=box_z;
	cam->box_w=box_w;
	cam->box_h=box_h;
	cam->box_d=box_d;
	cam->collision_type=collision_type;
	cam->pick_mode=pick_mode;
	cam->obscurer=obscurer;

	// copy camera info
	
	cam_list.push_back(cam); // add new cam to global cam list
	
	cam->vx=vx;
	cam->vy=vy;
	cam->vwidth=vwidth;
	cam->vheight=vheight;
	cam->cls_r=cls_r;
	cam->cls_g=cls_g;
	cam->cls_b=cls_b;
	cam->cls_color=cls_color;
	cam->cls_zbuffer=cls_zbuffer;
	cam->range_near=range_near;
	cam->range_far=range_far;
	cam->zoom=zoom;
	cam->proj_mode=proj_mode;
	cam->fog_mode=fog_mode;
	cam->fog_r=fog_r;
	cam->fog_g=fog_g;
	cam->fog_b=fog_b;
	cam->fog_range_near=fog_range_near;
	cam->fog_range_far=fog_range_far;

	cam->UpdateProjMatrix();
	
	return cam;
	
}

void Camera::FreeEntity(){

	Entity::FreeEntity();
	
	cam_list.remove(this);
	
	delete this;
	
	return;

}

Camera* Camera::CreateCamera(Entity* parent_ent){
	
	Camera* cam=new Camera;
	
	cam->CameraViewport(0,0,Global::width,Global::height);
	
	cam->class_name="Camera";
	
	cam->AddParent(*parent_ent);
	entity_list.push_back(cam); // add to entity list
	cam_list.push_back(cam); // add to cam list
	
	// update matrix
	if(cam->parent){
		cam->mat.Overwrite(cam->parent->mat);
		cam->UpdateMat();
	}else{
		cam->UpdateMat(true);
	}
	
	cam->UpdateProjMatrix();

	return cam;
	
}

void Camera::CameraViewport(int x,int y,int w,int h){
	vx=x;
	vy=y;
	vwidth=w;
	vheight=h;
	UpdateProjMatrix();
}
	
void Camera::CameraClsColor(float r,float g,float b){

	cls_r=r/255.0;
	cls_g=g/255.0;
	cls_b=b/255.0;

}

void Camera::CameraClsMode(int color,int zbuffer){

	cls_color=color;
	cls_zbuffer=zbuffer;

}

void Camera::CameraRange(float Near,float Far){

	range_near=Near;
	range_far=Far;
	UpdateProjMatrix();

}

void Camera::CameraZoom(float zoom_val){

	zoom=zoom_val;
	UpdateProjMatrix();

}

void Camera::CameraProjMode(int mode){

	proj_mode=mode;
	
}

void Camera::CameraFogMode(int mode){

	fog_mode=mode;

}

void Camera::CameraFogColor(float r,float g,float b){

	fog_r=r/255.0;
	fog_g=g/255.0;
	fog_b=b/255.0;

}

void Camera::CameraFogRange(float Near,float Far){

	fog_range_near=Near;
	fog_range_far=Far;

}

void Camera::CameraProject(float x,float y,float z){

	project_enabled=true;

	float px=0.0;
	float py=0.0;
	float pz=0.0;

	gluProject(x,y,-z,&mod_mat[0],&proj_mat[0],&viewport[0],&px,&py,&pz);

	projected_x=-vx+px;
	projected_y=vy+vheight-py;
	projected_z=pz;

}

float Camera::ProjectedX(){
	
	return projected_x;
	
}
	
float Camera::ProjectedY(){

	return projected_y;
	
}
	
float Camera::ProjectedZ(){
	
	return projected_z;
	
}

float Camera::EntityInView(Entity* ent){

	if(dynamic_cast<Mesh*>(ent)){

		// get new mesh bounds if necessary
		dynamic_cast<Mesh*>(ent)->GetBounds();

	}
	
	return EntityInFrustum(ent);
	
}
	
void Camera::ExtractFrustum(){

	//float proj[16]={0.0};
	//float modl[16]={0.0};
	float clip[16]={0.0};
	float t=0.0;
	
	// Get the current PROJECTION matrix from OpenGL
	//glGetFloatv( GL_PROJECTION_MATRIX, proj );
	
	// Get the current MODELVIEW matrix from OpenGL
	//glGetFloatv( GL_MODELVIEW_MATRIX, modl );
	
	// Combine the two matrices (multiply projection by modelview)
	clip[ 0] = mod_mat[ 0] * proj_mat[ 0] + mod_mat[ 1] * proj_mat[ 4] + mod_mat[ 2] * proj_mat[ 8] + mod_mat[ 3] * proj_mat[12];
	clip[ 1] = mod_mat[ 0] * proj_mat[ 1] + mod_mat[ 1] * proj_mat[ 5] + mod_mat[ 2] * proj_mat[ 9] + mod_mat[ 3] * proj_mat[13];
	clip[ 2] = mod_mat[ 0] * proj_mat[ 2] + mod_mat[ 1] * proj_mat[ 6] + mod_mat[ 2] * proj_mat[10] + mod_mat[ 3] * proj_mat[14];
	clip[ 3] = mod_mat[ 0] * proj_mat[ 3] + mod_mat[ 1] * proj_mat[ 7] + mod_mat[ 2] * proj_mat[11] + mod_mat[ 3] * proj_mat[15];
	
	clip[ 4] = mod_mat[ 4] * proj_mat[ 0] + mod_mat[ 5] * proj_mat[ 4] + mod_mat[ 6] * proj_mat[ 8] + mod_mat[ 7] * proj_mat[12];
	clip[ 5] = mod_mat[ 4] * proj_mat[ 1] + mod_mat[ 5] * proj_mat[ 5] + mod_mat[ 6] * proj_mat[ 9] + mod_mat[ 7] * proj_mat[13];
	clip[ 6] = mod_mat[ 4] * proj_mat[ 2] + mod_mat[ 5] * proj_mat[ 6] + mod_mat[ 6] * proj_mat[10] + mod_mat[ 7] * proj_mat[14];
	clip[ 7] = mod_mat[ 4] * proj_mat[ 3] + mod_mat[ 5] * proj_mat[ 7] + mod_mat[ 6] * proj_mat[11] + mod_mat[ 7] * proj_mat[15];
	
	clip[ 8] = mod_mat[ 8] * proj_mat[ 0] + mod_mat[ 9] * proj_mat[ 4] + mod_mat[10] * proj_mat[ 8] + mod_mat[11] * proj_mat[12];
	clip[ 9] = mod_mat[ 8] * proj_mat[ 1] + mod_mat[ 9] * proj_mat[ 5] + mod_mat[10] * proj_mat[ 9] + mod_mat[11] * proj_mat[13];
	clip[10] = mod_mat[ 8] * proj_mat[ 2] + mod_mat[ 9] * proj_mat[ 6] + mod_mat[10] * proj_mat[10] + mod_mat[11] * proj_mat[14];
	clip[11] = mod_mat[ 8] * proj_mat[ 3] + mod_mat[ 9] * proj_mat[ 7] + mod_mat[10] * proj_mat[11] + mod_mat[11] * proj_mat[15];
	
	clip[12] = mod_mat[12] * proj_mat[ 0] + mod_mat[13] * proj_mat[ 4] + mod_mat[14] * proj_mat[ 8] + mod_mat[15] * proj_mat[12];
	clip[13] = mod_mat[12] * proj_mat[ 1] + mod_mat[13] * proj_mat[ 5] + mod_mat[14] * proj_mat[ 9] + mod_mat[15] * proj_mat[13];
	clip[14] = mod_mat[12] * proj_mat[ 2] + mod_mat[13] * proj_mat[ 6] + mod_mat[14] * proj_mat[10] + mod_mat[15] * proj_mat[14];
	clip[15] = mod_mat[12] * proj_mat[ 3] + mod_mat[13] * proj_mat[ 7] + mod_mat[14] * proj_mat[11] + mod_mat[15] * proj_mat[15];
	
	// Extract the numbers for the right plane
	frustum[0][0] = clip[ 3] - clip[ 0];
	frustum[0][1] = clip[ 7] - clip[ 4];
	frustum[0][2] = clip[11] - clip[ 8];
	frustum[0][3] = clip[15] - clip[12];
	
	// Normalize the result
	t = sqrt( frustum[0][0] * frustum[0][0] + frustum[0][1] * frustum[0][1] + frustum[0][2] * frustum[0][2] );
	frustum[0][0] /= t;
	frustum[0][1] /= t;
	frustum[0][2] /= t;
	frustum[0][3] /= t;
	
	// Extract the numbers for the left plane 
	frustum[1][0] = clip[ 3] + clip[ 0];
	frustum[1][1] = clip[ 7] + clip[ 4];
	frustum[1][2] = clip[11] + clip[ 8];
	frustum[1][3] = clip[15] + clip[12];
	
	// Normalize the result
	t = sqrt( frustum[1][0] * frustum[1][0] + frustum[1][1] * frustum[1][1] + frustum[1][2] * frustum[1][2] );
	frustum[1][0] /= t;
	frustum[1][1] /= t;
	frustum[1][2] /= t;
	frustum[1][3] /= t;
	
	// Extract the BOTTOM plane
	frustum[2][0] = clip[ 3] + clip[ 1];
	frustum[2][1] = clip[ 7] + clip[ 5];
	frustum[2][2] = clip[11] + clip[ 9];
	frustum[2][3] = clip[15] + clip[13];
	
	// Normalize the result
	t = sqrt( frustum[2][0] * frustum[2][0] + frustum[2][1] * frustum[2][1] + frustum[2][2] * frustum[2][2] );
	frustum[2][0] /= t;
	frustum[2][1] /= t;
	frustum[2][2] /= t;
	frustum[2][3] /= t;
	
	// Extract the TOP plane
	frustum[3][0] = clip[ 3] - clip[ 1];
	frustum[3][1] = clip[ 7] - clip[ 5];
	frustum[3][2] = clip[11] - clip[ 9];
	frustum[3][3] = clip[15] - clip[13];
	
	// Normalize the result
	t = sqrt( frustum[3][0] * frustum[3][0] + frustum[3][1] * frustum[3][1] + frustum[3][2] * frustum[3][2] );
	frustum[3][0] /= t;
	frustum[3][1] /= t;
	frustum[3][2] /= t;
	frustum[3][3] /= t;
	
	// Extract the FAR plane
	frustum[4][0] = clip[ 3] - clip[ 2];
	frustum[4][1] = clip[ 7] - clip[ 6];
	frustum[4][2] = clip[11] - clip[10];
	frustum[4][3] = clip[15] - clip[14];
	
	// Normalize the result
	t = sqrt( frustum[4][0] * frustum[4][0] + frustum[4][1] * frustum[4][1] + frustum[4][2] * frustum[4][2] );
	frustum[4][0] /= t;
	frustum[4][1] /= t;
	frustum[4][2] /= t;
	frustum[4][3] /= t;
	
	// Extract the NEAR plane
	frustum[5][0] = clip[ 3] + clip[ 2];
	frustum[5][1] = clip[ 7] + clip[ 6];
	frustum[5][2] = clip[11] + clip[10];
	frustum[5][3] = clip[15] + clip[14];

	// Normalize the result 
	t = sqrt( frustum[5][0] * frustum[5][0] + frustum[5][1] * frustum[5][1] + frustum[5][2] * frustum[5][2] );
	frustum[5][0] /= t;
	frustum[5][1] /= t;
	frustum[5][2] /= t;
	frustum[5][3] /= t;

}

float Camera::EntityInFrustum(Entity* ent){

	float x=ent->EntityX(true);
	float y=ent->EntityY(true);
	float z=ent->EntityZ(true);

	float radius=abs(ent->cull_radius); // use absolute value as cull_radius will be negative value if set by MeshCullRadius (manual cull)

	// if entity is mesh, we need to use mesh centre for culling which may be different from entity position
	if(dynamic_cast<Mesh*>(ent)){
	
		Mesh* mesh=dynamic_cast<Mesh*>(ent);
	
		// mesh centre
		x=mesh->min_x;
		y=mesh->min_y;
		z=mesh->min_z;
		x=x+(mesh->max_x-mesh->min_x)/2.0;
		y=y+(mesh->max_y-mesh->min_y)/2.0;
		z=z+(mesh->max_z-mesh->min_z)/2.0;
		
		// transform mesh centre into world space
		Entity::TFormPoint(x,y,z,ent,NULL);
		x=Entity::tformed_x;
		y=Entity::tformed_y;
		z=Entity::tformed_z;
		
		// radius - apply entity scale
		float rx=radius*ent->EntityScaleX(true);
		float ry=radius*ent->EntityScaleY(true);
		float rz=radius*ent->EntityScaleZ(true);
		if(rx>=ry && rx>=rz){
			radius=abs(rx);
		}else if(ry>=rx && ry>=rz){
			radius=abs(ry);
		}else{
			radius=abs(rz);
		}
	
	}
	
	// is sphere in frustum

	float d;
	for(int p=0;p<=5;p++){
		d = frustum[p][0] * x + frustum[p][1] * y + frustum[p][2] * -z + frustum[p][3];
		if(d <= -radius) return 0;
	}

	return d + radius;

}

void Camera::Update(){

	// viewport
	glViewport(vx,vy,vwidth,vheight);
	glScissor(vx,vy,vwidth,vheight);
	glClearColor(cls_r,cls_g,cls_b,1.0);
	
	// clear buffers
	if(cls_color==true && cls_zbuffer==true)
	{
		//glDepthMask(GL_TRUE); // must be set to true before glClear is called. default is true. always true at start of this func
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	}else{
		if(cls_color==true){
			glClear(GL_COLOR_BUFFER_BIT);
		}else{
			if(cls_zbuffer==true){
				//glDepthMask(GL_TRUE); // must be set to true before glClear is called. default is true. alway true at start of this func
				glClear(GL_DEPTH_BUFFER_BIT);
			}
		}
	}

	//fog

	static int fog=-1;
	static float fog_near=-1.0;
	static float fog_far=-1.0;
	static float fogr=-1.0;
	static float fogg=-1.0;
	static float fogb=-1.0;

#ifndef GLES2
	if(fog_mode>0){

		glEnable(GL_FOG);
		glFogf(GL_FOG_MODE,GL_LINEAR); // each render
		if(fog!=true){
			//glEnable(GL_FOG); // enable if disabled
			//if(fog==-1) glFogf(GL_FOG_MODE,GL_LINEAR); // once only
			fog=true;
			Global::fog_enabled=true; // used in mesh render
		}
		glFogf(GL_FOG_START,fog_range_near);
		if(abs(fog_near-fog_range_near)>0.0001){
			//glFogf(GL_FOG_START,fog_range_near);
			fog_near=fog_range_near;
		}
		glFogf(GL_FOG_END,fog_range_far);
		if(abs(fog_far-fog_range_far)>0.0001){
			//glFogf(GL_FOG_END,fog_range_far);
			fog_far=fog_range_far;
		}
		float rgb[]={fog_r,fog_g,fog_b};
		glFogfv(GL_FOG_COLOR,rgb);
		if(abs(fogr-fog_r)>0.0001||abs(fogg-fog_g)>0.0001||abs(fogb-fog_b)>0.0001){
			//float rgb[]={fog_r,fog_g,fog_b};
			//glFogfv(GL_FOG_COLOR,rgb);
			fogr=fog_r;
			fogg=fog_g;
			fogb=fog_b;
		}
		
	}else{

		glDisable(GL_FOG);
		if(fog!=false){
			//glDisable(GL_FOG);
			fog=false;
			Global::fog_enabled=false; // used in mesh render
		}
		
	}
#endif
	
	float ratio=(float(vwidth)/vheight);

	accPerspective(atan((1.0/(zoom*ratio)))*2.0,ratio,range_near,range_far,0.0,0.0,0.0,0.0,1.0);

	Matrix new_mat;
	mat.GetInverse(new_mat);
	//mat.Inverse(Camera::InverseMat);

	//glLoadMatrixf(&Camera::InverseMat.grid[0][0]);

#ifndef GLES2
	glLoadMatrixf(&new_mat.grid[0][0]);
#else
	Global::shader=0;

#endif
	
	mod_mat[0]=new_mat.grid[0][0];
	mod_mat[1]=new_mat.grid[0][1];
	mod_mat[2]=new_mat.grid[0][2];
	mod_mat[3]=new_mat.grid[0][3];
	mod_mat[4]=new_mat.grid[1][0];
	mod_mat[5]=new_mat.grid[1][1];
	mod_mat[6]=new_mat.grid[1][2];
	mod_mat[7]=new_mat.grid[1][3];
	mod_mat[8]=new_mat.grid[2][0];
	mod_mat[9]=new_mat.grid[2][1];
	mod_mat[10]=new_mat.grid[2][2];
	mod_mat[11]=new_mat.grid[2][3];
	mod_mat[12]=new_mat.grid[3][0];
	mod_mat[13]=new_mat.grid[3][1];
	mod_mat[14]=new_mat.grid[3][2];
	mod_mat[15]=new_mat.grid[3][3];

	if(project_enabled){ // only get these directly after a cameraproject/camerapick call, as they are expensive calls
	
		// get projection/model/viewport info - for use with cameraproject/camerapick
		//glGetFloatv(GL_MODELVIEW_MATRIX,&mod_mat[0]);
		//glGetFloatv(GL_PROJECTION_MATRIX,&proj_mat[0]);
		glGetIntegerv(GL_VIEWPORT,&viewport[0]);
		
		project_enabled=false;
	
	}
	
	ExtractFrustum();

}

void Camera::Render(){

	//int ms=Millisecs();

	Update();

	//update light, inbetween update cam and render cam
	
	vector<Light*>::iterator light_it;

	for(light_it=Light::light_list.begin();light_it!=Light::light_list.end();++light_it){

		Light &light=**light_it;

		light.Update(); // EntityHidden code inside Update

	}

	render_list.clear(); // clear render list

	// add meshes to render list
	Global::root_ent->UpdateAllEntities(UpdateEntityRender,this);
	
	// add every sprite batch mesh to render list
	list<SpriteBatch*>::iterator it;

	//cout << "Sprite batch list size: " << SpriteBatch::sprite_batch_list.size() << endl;

	for(it=SpriteBatch::sprite_batch_list.begin();it!=SpriteBatch::sprite_batch_list.end();it++){
		
		SpriteBatch* sprite_batch=*it;
		
		Mesh* mesh=sprite_batch->GetSpriteBatchMesh();
		
		// add mesh straight to render list - don't need to check if it's hidden, or get bounds or check frustrum - that was done on a sprite level
		if(mesh->Alpha()){
			mesh->alpha_order=EntityDistanceSquared(mesh);
		}else{
			mesh->alpha_order=0.0;
		}
		
		RenderListAdd(mesh);
		
	}

	// Draw everything in render list

	list<Mesh*>::iterator mesh_it;

	//cout << "Render list size: " << render_list.size() << endl;

	for(mesh_it=render_list.begin();mesh_it!=render_list.end();mesh_it++){
		
		Mesh &mesh=**mesh_it;

		mesh.Render();
		
	}
	
	// free sprite meshes
	SpriteBatch::Clear();

	//cout << "Render time: " << Millisecs()-ms << endl;

}

void UpdateEntityRender(Entity* ent,Entity* cam){

	ent->old_x=ent->EntityX(true);
	ent->old_y=ent->EntityY(true);
	ent->old_z=ent->EntityZ(true);
	/*ent->old_pitch=ent->mat.GetPitch();
	ent->old_yaw=ent->mat.GetYaw();
	ent->old_roll=ent->mat.GetRoll();*/
	ent->old_mat.Overwrite(ent->mat);
	
	Mesh* mesh=dynamic_cast<Mesh*>(ent);
	Terrain* terrain=dynamic_cast<Terrain*>(ent);

	if(mesh){

		if(mesh->Hidden()==true || mesh->brush.alpha==0.0) return;

		if(mesh->no_surfs==0) return; // don't render mesh if it doesn't contain surface info
		
		// get new bounds
		mesh->GetBounds();

		// Perform frustum cull
		
		int inview=dynamic_cast<Camera*>(cam)->EntityInFrustum(mesh);

		if(inview){
		
			Sprite* sprite=dynamic_cast<Sprite*>(ent);
		
			if(sprite){
	
				switch (sprite->render_mode){
					case (1):{
						dynamic_cast<Camera*>(cam)->UpdateSprite(*sprite);
						break;}

			
					case (2):{ // sprite batch rendering
						dynamic_cast<Camera*>(cam)->UpdateSprite(*sprite);

						Surface* surf=SpriteBatch::GetSpriteBatchSurface(sprite->brush.tex[0],sprite->brush.blend,sprite->order);
			
						dynamic_cast<Camera*>(cam)->AddTransformedSpriteToSurface(*sprite,surf);
				
						return;}
					case (3):{
						ParticleBatch* p=ParticleBatch::GetParticleBatch(sprite->brush.tex[0],sprite->brush.blend,sprite->order);
						Surface* surf=*p->surf_list.begin();
			
						surf->no_verts++;

						surf->vert_coords.push_back(sprite->mat.grid[3][0]);
						surf->vert_coords.push_back(sprite->mat.grid[3][1]);
						surf->vert_coords.push_back(sprite->mat.grid[3][2]);

						surf->vert_col.push_back(sprite->brush.red);
						surf->vert_col.push_back(sprite->brush.green);
						surf->vert_col.push_back(sprite->brush.blue);
						surf->vert_col.push_back(sprite->brush.alpha);

				
						return;}
					
					
				}  
				
			}
		
			if(mesh->Alpha()){
		
				mesh->alpha_order=cam->EntityDistanceSquared(mesh);
			
			}else{
			
				mesh->alpha_order=0.0;
			
			}
			
			dynamic_cast<Camera*>(cam)->RenderListAdd(mesh);
		
		}
		
	}
	else if(terrain){
		if(terrain->Hidden()==true || terrain->brush.alpha==0.0) return;
		terrain->eyepoint=dynamic_cast<Camera*>(cam);
		terrain->UpdateTerrain();
	}
	
}

void Camera::UpdateSprite(Sprite& sprite){

	float x=sprite.mat.grid[3][0];
	float y=sprite.mat.grid[3][1];
	float z=sprite.mat.grid[3][2];

	// face camera, roll with camera
	if(sprite.view_mode==1){

		sprite.mat.Overwrite(mat);
		sprite.mat.grid[3][0]=x;
		sprite.mat.grid[3][1]=y;
		sprite.mat.grid[3][2]=z;
	
	}
	
	// face camera, don't roll with camera
	if(sprite.view_mode==3){
	
		sprite.mat.LoadIdentity();
		sprite.mat.RotateYaw(EntityYaw(true));
		sprite.mat.RotatePitch(EntityPitch(true));
		sprite.mat.grid[3][0]=x;
		sprite.mat.grid[3][1]=y;
		sprite.mat.grid[3][2]=z;
		
	}

	// billboard - face camera, don't roll with camera and don't change pitch
	if(sprite.view_mode==4){
	
		sprite.mat.LoadIdentity();
		sprite.mat.RotateYaw(EntityYaw(true));
		sprite.mat.grid[3][0]=x;
		sprite.mat.grid[3][1]=y;
		sprite.mat.grid[3][2]=z;
	
	}
	
	sprite.mat_sp.Overwrite(sprite.mat);
	
	if(sprite.angle!=0.0){
		sprite.mat_sp.RotateRoll(sprite.angle);
	}
	
	if(sprite.scale_x!=1.0 || sprite.scale_y!=1.0){
		sprite.mat_sp.Scale(sprite.scale_x,sprite.scale_y,1.0);
	}
	
	if(sprite.handle_x!=0.0 || sprite.handle_y!=0.0){
		sprite.mat_sp.Translate(-sprite.handle_x,-sprite.handle_y,0.0);
	}

}

void Camera::AddTransformedSpriteToSurface(Sprite& sprite,Surface* surf){

	// transform four quad points
	
	Matrix mat;

	mat.Overwrite(sprite.mat_sp);
	mat.Translate(-1.0,-1.0,0.0);

	float x1=mat.grid[3][0];
	float y1=mat.grid[3][1];
	float z1=-mat.grid[3][2];

	mat.Overwrite(sprite.mat_sp);
	mat.Translate(-1.0,1.0,0.0);

	float x2=mat.grid[3][0];
	float y2=mat.grid[3][1];
	float z2=-mat.grid[3][2];	

	mat.Overwrite(sprite.mat_sp);
	mat.Translate(1.0,1.0,0.0);

	float x3=mat.grid[3][0];
	float y3=mat.grid[3][1];
	float z3=-mat.grid[3][2];

	mat.Overwrite(sprite.mat_sp);
	mat.Translate(1.0,-1.0,0.0);

	float x4=mat.grid[3][0];
	float y4=mat.grid[3][1];
	float z4=-mat.grid[3][2];	

	int v0=surf->AddVertex(x1,y1,z1);
	int v1=surf->AddVertex(x2,y2,z2);
	int v2=surf->AddVertex(x3,y3,z3);
	int v3=surf->AddVertex(x4,y4,z4);
	surf->AddTriangle(v0,v1,v2);
	surf->AddTriangle(v0,v2,v3);
	
	Surface* sprite_surf=sprite.GetSurface(1);

	surf->VertexTexCoords(v0,sprite_surf->VertexU(0),sprite_surf->VertexV(0));
	surf->VertexTexCoords(v1,sprite_surf->VertexU(1),sprite_surf->VertexV(1));
	surf->VertexTexCoords(v2,sprite_surf->VertexU(2),sprite_surf->VertexV(2));
	surf->VertexTexCoords(v3,sprite_surf->VertexU(3),sprite_surf->VertexV(3));
	
	// if entity fx 2 used (vertex colors), transfer those vertex colors, else transfer brush colors
	if(sprite.brush.fx&2){

		float a0=0.0;
		float a1=0.0;
		float a2=0.0;
		float a3=0.0;

		// if entity fx 32 used (vertex alpha), transfer vertex alpha, else transfer brush alpha
		if(sprite.brush.fx&32){

			a0=sprite_surf->VertexAlpha(0);
			a1=sprite_surf->VertexAlpha(1);
			a2=sprite_surf->VertexAlpha(2);
			a3=sprite_surf->VertexAlpha(3);
		
		}else{
	
			float a=sprite.brush.alpha;
			a0=a;
			a1=a;
			a2=a;
			a3=a;

		}

		surf->VertexColor(v0,sprite_surf->VertexRed(0),sprite_surf->VertexGreen(0),sprite_surf->VertexBlue(0),a0);
		surf->VertexColor(v1,sprite_surf->VertexRed(1),sprite_surf->VertexGreen(1),sprite_surf->VertexBlue(1),a1);
		surf->VertexColor(v2,sprite_surf->VertexRed(2),sprite_surf->VertexGreen(2),sprite_surf->VertexBlue(2),a2);
		surf->VertexColor(v3,sprite_surf->VertexRed(3),sprite_surf->VertexGreen(3),sprite_surf->VertexBlue(3),a3);
	
	}else{
	
		float r=sprite.brush.red*255.0;
		float g=sprite.brush.green*255.0;
		float b=sprite.brush.blue*255.0;
		float a=sprite.brush.alpha;
		
		surf->VertexColor(v0,r,g,b,a);
		surf->VertexColor(v1,r,g,b,a);
		surf->VertexColor(v2,r,g,b,a);
		surf->VertexColor(v3,r,g,b,a);

	}
			
}

// Adds mesh to a render list, and inserts mesh into correct position within list depending on order and alpha values
void Camera::RenderListAdd(Mesh* mesh){

	// if order>0, drawn first (will appear at back of scene)
	// if order<0, drawn last (will appear at front of scene)

	list<Mesh*>::iterator it;
	
	if(mesh->order>0){

		// --- add first ---
	
		// add entity to start of list
		// entites with order>0 should be added to the start of the list
	
		// cycle fowards through list until we've passed all entities with order>0, or if entity itself has order>0,
		// it's own position within entities with order>0
		
		it=render_list.begin();
		
		while(it!=render_list.end()){
		
			Entity& ent=**it;
			
			if(ent.order<=mesh->order){
			
				render_list.insert(it,mesh);
				return;
				
			}
			
			it++;
		}
		
		render_list.push_back(mesh);
		return;
			
	}else if(mesh->order<0){ // put entities with order<0 at back of list
	
		// --- add last ---

		// add entity to end of list
		// only entites with order<=0 should be added to the end of the list
	
		// cycle backwards through list until we've passed all entities with order<0, or if entity itself has order<0,
		// it's own position within entities with order<0
		
		it=render_list.end();
		
		while(it!=render_list.begin()){
		
			it--;
		
			Entity& ent=**it;
			
			if(ent.order>=mesh->order){
			
				it++;
				render_list.insert(it,mesh);
				return;
				
			}

		}
		
		render_list.push_front(mesh);
		return;
	
	}
	
	// order=0
	
	if(mesh->alpha_order>0.0){
	
		// add alpha entities to near end of list - before entities with order<0

		it=render_list.end();
		
		while(it!=render_list.begin()){
		
			it--;
		
			Entity& ent=**it;
			
			if(ent.order>=0){
			
				if(ent.alpha_order>=mesh->alpha_order || ent.alpha_order==0.0){
			
					it++;
					render_list.insert(it,mesh);
					return;
					
				}
				
			}
			
		}
		
		render_list.push_front(mesh);
		return;

	}else{
		
		// normal entities - add to list at start - after entities with order>0

		it=render_list.begin();
		
		while(it!=render_list.end()){
		
			Entity& ent=**it;
			
			if(ent.order<=0){
			
				render_list.insert(it,mesh);
				return;
				
			}
			
			it++;
		}
		
		render_list.push_back(mesh);
		return;
		
	}
	
	return;

}

void Camera::accPerspective(float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus){
	
	float fov2=0.0,left_=0.0,right_=0.0,bottom=0.0,top=0.0;
	fov2=fovy/2.0;
	
	top=zNear/(cos(fov2)/sin(fov2));
	bottom=-top;
	right_=top*aspect;
	left_=-right_;
	
	accFrustum(left_,right_,bottom,top,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus);
	
}

void Camera::accFrustum(float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus){
	
	//float xwsize=0.0,ywsize=0.0;
	//float dx=0.0,dy=0.0;
	
	//xwsize=right_-left_;
	//ywsize=top-bottom;
	//dx=(pixdx*xwsize/float(viewport[2])+eyedx*zNear/focus);
	//dy=-(pixdy*ywsize/float(viewport[3])+eyedy*zNear/focus);
	
#ifndef GLES2
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	if (proj_mode == 1) {
		glFrustum(left_,right_,bottom,top,zNear,zFar);
	}else if (proj_mode == 2){
		glOrtho(left_,right_,bottom,top,zNear,zFar);
	}
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
#endif
	
}

void Camera::UpdateProjMatrix(){
	float ratio=(float(vwidth)/vheight);

	float fov=atan((1.0/(zoom*ratio)));
	float top=range_near/(cos(fov)/sin(fov));
	float right_=top*ratio;

	if (proj_mode == 1) {
		proj_mat[0]=range_near/right_;
		proj_mat[1]=0;
		proj_mat[2]=0;
		proj_mat[3]=0;

		proj_mat[4]=0;
		proj_mat[5]=range_near/top;
		proj_mat[6]=0;
		proj_mat[7]=0;

		proj_mat[8]=0;
		proj_mat[9]=0;
		proj_mat[10]=-(range_far+range_near)/(range_far-range_near);
		proj_mat[11]=-1;

		proj_mat[12]=0;
		proj_mat[13]=0;
		proj_mat[14]=(-2*range_far*range_near)/(range_far-range_near);
		proj_mat[15]=0;
	}else if (proj_mode == 2){
		proj_mat[0]=1.0/right_;
		proj_mat[1]=0;
		proj_mat[2]=0;
		proj_mat[3]=0;

		proj_mat[4]=0;
		proj_mat[5]=1.0/top;
		proj_mat[6]=0;
		proj_mat[7]=0;

		proj_mat[8]=0;
		proj_mat[9]=0;
		proj_mat[10]=-2.0/(range_far-range_near);
		proj_mat[11]=0;

		proj_mat[12]=0;
		proj_mat[13]=0;
		proj_mat[14]=-(range_far+range_near)/(range_far-range_near);
		proj_mat[15]=1.0;
	}

}
