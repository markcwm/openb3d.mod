/*
 *  global.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "global.h"

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "sprite.h"
#include "animation.h"
#include "pick.h"
#include "collision2.h"
#include "shadow.h"

#include <list>
#include <stdlib.h>

using namespace std;

float Global::ambient_red=0.5,Global::ambient_green=0.5,Global::ambient_blue=0.5;

int Global::vbo_enabled=true,Global::vbo_min_tris=0;

float Global::anim_speed=1.0;

int Global::fog_enabled=false;

int Global::width=640,Global::height=480;

int Global::Shadows_enabled=false;

int Global::alpha_enable=-1;

int Global::blend_mode=-1;

int Global::fx1=-1;

int Global::fx2=-1;



Pivot* Global::root_ent=new Pivot();

Camera* Global::camera_in_use;

void Global::Graphics(){

	glDepthFunc(GL_LEQUAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

	glAlphaFunc(GL_GEQUAL,0.5);
	//glAlphaFunc(GL_NOTEQUAL,0.0);

	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glDepthMask(GL_TRUE);

	//glDisable(GL_BLEND);

	glEnable(GL_FOG);
	glEnable(GL_CULL_FACE);
	glEnable(GL_SCISSOR_TEST);

	glEnable(GL_NORMALIZE);


	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);


	float amb[]={0.5,0.5,0.5,1.0};

	float flag[]={0.0};

	glLightModelfv(GL_LIGHT_MODEL_AMBIENT,amb);
	glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE,flag); // 0 for one sided, 1 for two sided

	Texture::AddTextureFilter("",9);

	if (atof((char*)glGetString(GL_VERSION))<1.5){
		Global::vbo_enabled=false;
	}

}

void Global::AmbientLight(float r,float g,float b){
	ambient_red  =r/255.0;
	ambient_green=g/255.0;
	ambient_blue =b/255.0;
}

void Global::ClearCollisions(){
	list<CollisionPair*>::iterator it;
	for(it=CollisionPair::cp_list.begin();it!=CollisionPair::cp_list.end();it++){
		CollisionPair* cp=*it;
		delete cp;
	}
	CollisionPair::cp_list.clear();
}

void Global::Collisions(int src_no,int dest_no,int method_no,int response_no){

	CollisionPair* cp=new CollisionPair;
	cp->src_type=src_no;
	cp->des_type=dest_no;
	cp->col_method=method_no;
	cp->response=response_no;

	// check to see if same collision pair already exists
	list<CollisionPair*>::iterator it;

	for(it=CollisionPair::cp_list.begin();it!=CollisionPair::cp_list.end();it++){
		CollisionPair* cp2=*it;
		if(cp2->src_type==cp->src_type){
			if(cp2->des_type==cp->des_type){
				// overwrite old method and response values
				cp2->col_method=cp->col_method;
				cp2->response=cp->response;
   			return;
			}
		}
	}

	CollisionPair::cp_list.push_back(cp);

}

void Global::ClearWorld(int entities,int brushes,int textures){

	if(entities){
		//list<Entity*>::iterator it;
		//for(it=Entity::entity_list.begin();it!=Entity::entity_list.end();it++){
		//	Entity* ent=*it;
		//	ent->FreeEntity();
		//}
		Global::root_ent->FreeEntity();
		Entity::entity_list.clear();
		Entity::animate_list.clear();
		Camera::cam_list.clear();
		ClearCollisions();
		Pick::ent_list.clear();
	}

	if(textures){
		list<Texture*>::iterator it;
		for(it=Texture::tex_list.begin();it!=Texture::tex_list.end();it++){
			Texture* tex=*it;
			tex->FreeTexture();
			it=Texture::tex_list.begin();
			it--;
		}
		Texture::tex_list.clear();
	}
}

void Global::UpdateWorld(float anim_speed){
	Global::anim_speed=anim_speed;
	// collision
	UpdateCollisions();

	// anim
	list<Entity*>::iterator it;

	for(it=Entity::animate_list.begin();it!=Entity::animate_list.end();it++){
		Mesh* mesh=dynamic_cast<Mesh*>(*it);
		UpdateEntityAnim(*mesh);
	}
}

void Global::RenderWorld(){
	Camera::cam_list.sort(CompareEntityOrder); // sort cam list based on entity order
	list<Camera*>::iterator it;
	for(it=Camera::cam_list.begin();it!=Camera::cam_list.end();it++){
		//Camera* cam=*it;
		camera_in_use=*it;
		if(camera_in_use->Hidden()==true) continue;
		camera_in_use->Render();
	}

	if (Shadows_enabled==true){
		for(it=Camera::cam_list.begin();it!=Camera::cam_list.end();it++){
			//Camera* cam=*it;
			camera_in_use=*it;
			if(camera_in_use->Hidden()==true) continue;
			ShadowObject::Update(camera_in_use);
		}
	}
}

void Global::UpdateEntityAnim(Mesh& mesh){
	if (mesh.anim && mesh.anim_update==true) {
		int first=mesh.anim_seqs_first[mesh.anim_seq];
		int last=mesh.anim_seqs_last[mesh.anim_seq];
		int anim_start=false;

		if(mesh.anim_trans>0){
			mesh.anim_trans=mesh.anim_trans-1;
			if(mesh.anim_trans==1) anim_start=true;
		}

		if(mesh.anim_trans>0){

			float r=1.0-mesh.anim_time;
			r=r/mesh.anim_trans;
			mesh.anim_time=mesh.anim_time+r;

			Animation::AnimateMesh2(&mesh,mesh.anim_time,first,last);

			if(anim_start==true) mesh.anim_time=first;

		}else{
			if(mesh.anim_mode==4){	//Manual mode
				Animation::AnimateMesh3(&mesh);
				return;
			}

			Animation::AnimateMesh(&mesh,mesh.anim_time,first,last);

			if(mesh.anim_mode==0) mesh.anim_update=false; // after updating animation so that animation is in final 'stop' pose - don't update again

			if(mesh.anim_mode==1){

				mesh.anim_time=mesh.anim_time+(mesh.anim_speed*anim_speed);
				if(mesh.anim_time>last){
					mesh.anim_time=first+(mesh.anim_time-last);
				}
				return;

			}

			if(mesh.anim_mode==2){

				if(mesh.anim_dir==1){
					mesh.anim_time=mesh.anim_time+(mesh.anim_speed*anim_speed);
					if(mesh.anim_time>last){
						mesh.anim_time=mesh.anim_time-(mesh.anim_speed*anim_speed);
						mesh.anim_dir=-1;
					}
				}

				if(mesh.anim_dir==-1){
					mesh.anim_time=mesh.anim_time-(mesh.anim_speed*anim_speed);
					if(mesh.anim_time<first){
						mesh.anim_time=mesh.anim_time+(mesh.anim_speed*anim_speed);
						mesh.anim_dir=1;
					}
				}
				return;

			}

			if(mesh.anim_mode==3){

				mesh.anim_time=mesh.anim_time+(mesh.anim_speed*anim_speed);
				if(mesh.anim_time>last){
					mesh.anim_time=last;
					mesh.anim_mode=0;
				}

			}

		}

	}

}

bool CompareEntityOrder(Entity* ent1,Entity* ent2){

	if(ent1->order>ent2->order){
		return true;
	}else{
		return false;
	}

}
