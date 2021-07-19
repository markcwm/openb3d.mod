/*
 *  global.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "glew_glee.h" // glee or glew

#include "global.h"

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "sprite.h"
#include "animation.h"
#include "pick.h"
#include "collision2.h"
#include "shadow.h"
#include "particle.h"
#include "physics.h"
#include "actions.h"
#include "postfx.h"
#include "light.h"

#include <list>
#include <stdlib.h>

#include "shaders.h"

using namespace std;

float Global::ambient_red=0.5,Global::ambient_green=0.5,Global::ambient_blue=0.5;

Shader* Global::ambient_shader=0;

int Global::cubemap_face[12];

int Global::cubemap_frame[12];

int Global::flip_cubemap=1;

int Global::vbo_enabled=true,Global::vbo_min_tris=0;

float Global::anim_speed=1.0;

int Global::fog_enabled=false;

int Global::width=640,Global::height=480;

int Global::Shadows_enabled=false;

int Global::alpha_enable=-1;

int Global::blend_mode=-1;

int Global::fx1=-1;

int Global::fx2=-1;

int Global::aa=false;

int Global::ACSIZE;

int Global::jitter=0;

float Global::j_data[16][2];

const float Global::j2_data[]={
0.25,0.75,0.75,0.25
};
const float Global::j3_data[]={
0.5033922635,0.8317967229,0.7806016275,0.2504380877,0.2261828938,0.4131553612
};
const float Global::j4_data[]={
0.375,0.25,0.125,0.75,0.875,0.25,0.625,0.75
};
const float Global::j5_data[]={
0.5,0.5,0.3,0.1,0.7,0.9,0.9,0.3,0.1,0.7
};
const float Global::j6_data[]={
0.4646464646,0.4646464646,0.1313131313,0.7979797979,0.5353535353,0.8686868686,
0.8686868686,0.5353535353,0.7979797979,0.1313131313,0.2020202020,0.2020202020
};
const float Global::j8_data[]={
0.5625,0.4375,0.0625,0.9375,0.3125,0.6875,0.6875,0.8125,0.8125,0.1875,0.9375,0.5625,0.4375,0.0625,0.1875,0.3125
};
const float Global::j9_data[]={
0.5,0.5,0.1666666666,0.9444444444,0.5,0.1666666666,0.5,0.8333333333,0.1666666666,
0.2777777777,0.8333333333,0.3888888888,0.1666666666,0.6111111111,0.8333333333,0.7222222222,0.8333333333,0.0555555555
};
const float Global::j12_data[]={
0.4166666666,0.625,0.9166666666,0.875,0.25,0.375,0.4166666666,0.125,0.75,0.125,0.0833333333,0.125,
0.75,0.625,0.25,0.875,0.5833333333,0.375,0.9166666666,0.375,0.0833333333,0.625,0.5833333333,0.875
};
const float Global::j16_data[]={
0.375,0.4375,0.625,0.0625,0.875,0.1875,0.125,0.0625,0.375,0.6875,0.875,0.4375,0.625,0.5625,0.375,0.9375,
0.625,0.3125,0.125,0.5625,0.125,0.8125,0.375,0.1875,0.875,0.9375,0.875,0.6875,0.125,0.3125,0.625,0.8125
};

#ifdef GLES2
	Global::Program Global::shaders[9][9][2];
	Global::Program* Global::shader;

	Global::Program Global::shader_stencil;
	Global::Program Global::shader_particle;
	Global::Program Global::shader_voxel;

	GLuint Global::stencil_vbo;


#endif

Pivot* Global::root_ent=new Pivot();

Camera* Global::camera_in_use;

Mesh* Global::last_mesh=NULL;

void Global::Graphics(){

#ifndef GLES2
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
#else
/*	ambient_shader=Shader::CreateShaderMaterial("default");
	ambient_shader->AddShaderFromString(vert_shader, frag_shader);
	ambient_shader->ProgramAttriBegin();*/

	GLuint ambient_vert[9][2];
	GLuint ambient_frag[9][2];

	int compiled, linked;

	for (int f=0; f<=1; f++){

		for (int l=0;l<=8;l++){
			for (int t=0;t<=8;t++){
				shaders[l][t][f].ambient_program=glCreateProgram();
			}
		}

		for (int l=0;l<=8;l++){
			ambient_vert[l][f]=glCreateShader(GL_VERTEX_SHADER);
			const char* vshader[]={GLES2_Shader::version, GLES2_Shader::vert_flags[l], GLES2_Shader::fog_flags[f], GLES2_Shader::vert_shader};
			glShaderSource(ambient_vert[l][f],4, (const GLchar**)&vshader, 0);
			glCompileShader(ambient_vert[l][f]);

			glGetShaderiv(ambient_vert[l][f],GL_COMPILE_STATUS, &compiled);
		}

		for (int t=0;t<=8;t++){
			ambient_frag[t][f]=glCreateShader(GL_FRAGMENT_SHADER);
			const char* fshader[]={GLES2_Shader::version, GLES2_Shader::frag_flags[t], GLES2_Shader::fog_flags[f], GLES2_Shader::frag_shader};
			glShaderSource(ambient_frag[t][f],4, (const GLchar**)&fshader, 0);
			glCompileShader(ambient_frag[t][f]);

			glGetShaderiv(ambient_frag[t][f],GL_COMPILE_STATUS, &compiled);
		}

		for (int l=0;l<=8;l++){
			for (int t=0;t<=8;t++){
				shader=&shaders[l][t][f];
				glAttachShader(shader->ambient_program, ambient_vert[l][f]);
				glAttachShader(shader->ambient_program, ambient_frag[t][f]);

				glLinkProgram(shader->ambient_program);
				glValidateProgram(shader->ambient_program);

				glDetachShader(shader->ambient_program, ambient_vert[l][f]);
				glDetachShader(shader->ambient_program, ambient_frag[t][f]);

				glGetProgramiv(shader->ambient_program,GL_LINK_STATUS, &linked);

				shader->vposition=glGetAttribLocation(shader->ambient_program, "aVertexPosition");
				shader->vnormal=glGetAttribLocation(shader->ambient_program, "aVertexNormal");
				shader->tex_coords=glGetAttribLocation(shader->ambient_program, "aTextureCoord");
				shader->tex_coords2=glGetAttribLocation(shader->ambient_program, "aTextureCoord2");
				shader->color=glGetAttribLocation(shader->ambient_program, "aVertexColor");

				shader->shininess=glGetUniformLocation(shader->ambient_program, "uShine");
				shader->model=glGetUniformLocation(shader->ambient_program, "uMMatrix");
				shader->view=glGetUniformLocation(shader->ambient_program, "uVMatrix");
				shader->proj=glGetUniformLocation(shader->ambient_program, "uPMatrix");

				shader->amblight=glGetUniformLocation(shader->ambient_program, "AmbLight");

				shader->fogRange=glGetUniformLocation(shader->ambient_program, "fogRange");
				shader->fogColor=glGetUniformLocation(shader->ambient_program, "fogColor");

				if (l!=0){
					shader->lightMat=glGetUniformLocation(shader->ambient_program, "LightMatrix");
					shader->lightType=glGetUniformLocation(shader->ambient_program, "LightType");
					shader->lightOuterCone=glGetUniformLocation(shader->ambient_program, "LightOuterCone");
					shader->lightColor=glGetUniformLocation(shader->ambient_program, "LightColor");
				}

				if (t!=0){
					shader->texflag=glGetUniformLocation(shader->ambient_program, "texFlag");
					shader->texmat=glGetUniformLocation(shader->ambient_program, "texMat");
					shader->tex_coords_set=glGetUniformLocation(shader->ambient_program, "tex_coord_set");

					glUseProgram(shader->ambient_program);
					switch(t){
					case 8:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler7"), 7);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC7"), 15);
					case 7:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler6"), 6);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC6"), 14);
					case 6:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler5"), 5);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC5"), 13);
					case 5:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler4"), 4);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC4"), 12);
					case 4:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler3"), 3);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC3"), 11);
					case 3:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler2"), 2);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC2"), 10);
					case 2:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler1"), 1);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC1"), 9);
					case 1:
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSampler0"), 0);
						glUniform1i(glGetUniformLocation(shader->ambient_program, "uSamplerC0"), 8);
					}
				}
				/*uSamp=glGetUniformLocation(ambient_program[l][t], "uSampler2");
				glUniform1i(uSamp, 1);*/
			}
		}
	}


	GLuint v,f;
	//Special shader for particles
	v=glCreateShader(GL_VERTEX_SHADER);
	const char* vparticle[]={GLES2_Shader::version, GLES2_Shader::vert_particle};
	glShaderSource(v,2, (const GLchar**)&vparticle, 0);
	glCompileShader(v);
	glGetShaderiv(v,GL_COMPILE_STATUS, &compiled);

	f=glCreateShader(GL_FRAGMENT_SHADER);
	const char* fparticle[]={GLES2_Shader::version, GLES2_Shader::frag_particle};
	glShaderSource(f,2, (const GLchar**)&fparticle, 0);
	glCompileShader(f);
	glGetShaderiv(f,GL_COMPILE_STATUS, &compiled);

	shader_particle.ambient_program=glCreateProgram();

	glAttachShader(shader_particle.ambient_program, v);
	glAttachShader(shader_particle.ambient_program, f);

	glLinkProgram(shader_particle.ambient_program);
	glValidateProgram(shader_particle.ambient_program);

	glDetachShader(shader_particle.ambient_program, v);
	glDetachShader(shader_particle.ambient_program, f);

	glGetProgramiv(shader_particle.ambient_program,GL_LINK_STATUS, &linked);

	shader_particle.view=glGetUniformLocation(shader_particle.ambient_program, "uVMatrix");
	shader_particle.proj=glGetUniformLocation(shader_particle.ambient_program, "uPMatrix");

	shader_particle.vposition=glGetAttribLocation(shader_particle.ambient_program, "aVertexPosition");
	shader_particle.color=glGetAttribLocation(shader_particle.ambient_program, "aVertexColor");

	glUseProgram(shader_particle.ambient_program);
	glUniform1i(glGetUniformLocation(shader_particle.ambient_program, "uSampler0"), 0);
	shader_particle.texflag=glGetUniformLocation(shader_particle.ambient_program, "texFlag");

	//Special shader for voxels
	v=glCreateShader(GL_VERTEX_SHADER);
	const char* vvoxel[]={GLES2_Shader::version, GLES2_Shader::vert_voxel};
	glShaderSource(v,2, (const GLchar**)&vvoxel, 0);
	glCompileShader(v);
	glGetShaderiv(v,GL_COMPILE_STATUS, &compiled);

	f=glCreateShader(GL_FRAGMENT_SHADER);
	const char* fvoxel[]={GLES2_Shader::version, GLES2_Shader::frag_voxel};
	glShaderSource(f,2, (const GLchar**)&fvoxel, 0);
	glCompileShader(f);
	glGetShaderiv(f,GL_COMPILE_STATUS, &compiled);

	shader_voxel.ambient_program=glCreateProgram();

	glAttachShader(shader_voxel.ambient_program, v);
	glAttachShader(shader_voxel.ambient_program, f);

	glLinkProgram(shader_voxel.ambient_program);
	glValidateProgram(shader_voxel.ambient_program);

	glDetachShader(shader_voxel.ambient_program, v);
	glDetachShader(shader_voxel.ambient_program, f);

	glGetProgramiv(shader_voxel.ambient_program,GL_LINK_STATUS, &linked);

	shader_voxel.model=glGetUniformLocation(shader_voxel.ambient_program, "uMMatrix");
	shader_voxel.view=glGetUniformLocation(shader_voxel.ambient_program, "uVMatrix");
	shader_voxel.proj=glGetUniformLocation(shader_voxel.ambient_program, "uPMatrix");

	shader_voxel.vposition=glGetAttribLocation(shader_voxel.ambient_program, "aVertexPosition");
	shader_voxel.vnormal=glGetAttribLocation(shader_voxel.ambient_program, "aVertexNormal");

	glUseProgram(shader_voxel.ambient_program);
	glUniform1i(glGetUniformLocation(shader_voxel.ambient_program, "uSampler0"), 0);
	shader_voxel.texflag=glGetUniformLocation(shader_voxel.ambient_program, "texFlag");
	shader_voxel.tex_coords_set=glGetUniformLocation(shader_voxel.ambient_program, "slices");

	//Special shader for stencils
	v=glCreateShader(GL_VERTEX_SHADER);
	const char* vstencil[]={GLES2_Shader::version, GLES2_Shader::vert_stencil};
	glShaderSource(v,2, (const GLchar**)&vstencil, 0);
	glCompileShader(v);
	glGetShaderiv(v,GL_COMPILE_STATUS, &compiled);

	f=glCreateShader(GL_FRAGMENT_SHADER);
	const char* fstencil[]={GLES2_Shader::version, GLES2_Shader::frag_stencil};
	glShaderSource(f,2, (const GLchar**)&fstencil, 0);
	glCompileShader(f);
	glGetShaderiv(f,GL_COMPILE_STATUS, &compiled);

	shader_stencil.ambient_program=glCreateProgram();

	glAttachShader(shader_stencil.ambient_program, v);
	glAttachShader(shader_stencil.ambient_program, f);

	glLinkProgram(shader_stencil.ambient_program);
	glValidateProgram(shader_stencil.ambient_program);

	glDetachShader(shader_stencil.ambient_program, v);
	glDetachShader(shader_stencil.ambient_program, f);

	glGetProgramiv(shader_stencil.ambient_program,GL_LINK_STATUS, &linked);

	shader_stencil.vposition=glGetAttribLocation(shader_stencil.ambient_program, "aVertexPosition");
	shader_stencil.color=glGetUniformLocation(shader_stencil.ambient_program, "uColor");


	glGenBuffers(1, &stencil_vbo);
	glBindBuffer(GL_ARRAY_BUFFER, stencil_vbo);
	GLfloat q3[] = {1,1,-1,1,-1,-1,1,-1};
 
	glBufferData(GL_ARRAY_BUFFER,8*sizeof(float),q3,GL_STATIC_DRAW);


	//Program::ambient_current_program=shaders[0][0][0].ambient_program;
	glUseProgram(shaders[0][0][0].ambient_program);

	glEnable(GL_DEPTH_TEST);
	glDepthMask(GL_TRUE);
	glClearDepthf(1.0);			
	glDepthFunc(GL_LEQUAL);
	glEnable(GL_CULL_FACE);
	glEnable(GL_SCISSOR_TEST);
	glEnable(GL_BLEND);

#endif

	float amb[]={0.5,0.5,0.5,1.0};

	float flag[]={0.0};

#ifndef GLES2
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT,amb);
	glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE,flag); // 0 for one sided, 1 for two sided
#endif

	Texture::AddTextureFilter("",1+8);

#ifndef GLES2
	if (atof((char*)glGetString(GL_VERSION))<1.5){
		Global::vbo_enabled=false;
	}
#endif

	ambient_red=0.5;ambient_green=0.5;ambient_blue=0.5;
	ambient_shader=0;
	fog_enabled=false;
	Shadows_enabled=false;
	alpha_enable=-1;
	blend_mode=-1;
	fx1=-1;
	fx2=-1;

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
		FreeCollisionPivots();
		
		/*list<Entity*>::iterator it;
		for(it=Entity::entity_list.begin();it!=Entity::entity_list.end();it++){
			Entity* ent=*it;
			ent->FreeEntity();
		}*/
		//Global::root_ent->FreeEntity();
		//Entity::entity_list.clear();
		/*for(list<Entity*>::iterator it=Entity::entity_list.begin();it!=Entity::entity_list.end();it++){
			Entity* e=*it;
			e->FreeEntity();
			it=Entity::entity_list.begin();
			it--;
		}*/
		
		while(!Entity::entity_list.empty()){
			Entity* e=*Entity::entity_list.begin();
			e->FreeEntity();
		}
		
		Entity::animate_list.clear();
		Camera::cam_list.clear();
		ClearCollisions();
		Pick::ent_list.clear();
		
		/*for(list<Constraint*>::iterator it=Constraint::constraint_list.begin();it!=Constraint::constraint_list.end();it++){
			Constraint* c=*it;
			c->FreeConstraint();
			it=Constraint::constraint_list.begin();
			it--;
		}
		for(list<RigidBody*>::iterator it=RigidBody::rigidBody_list.begin();it!=RigidBody::rigidBody_list.end();it++){
			RigidBody* b=*it;
			b->FreeRigidBody();
			it=RigidBody::rigidBody_list.begin();
			it--;
		}*/

		while(!Constraint::constraint_list.empty()){
			Constraint* c=*Constraint::constraint_list.begin();
			c->FreeConstraint();
		}

		while(!RigidBody::rigidBody_list.empty()){
			RigidBody* b=*RigidBody::rigidBody_list.begin();
			b->FreeRigidBody();
		}

		for(list<Action*>::iterator it=Action::action_list.begin();it!=Action::action_list.end();it++){
			Action* act=*it;
			act->act=ACT_COMPLETED;
		}

	}
	
	if(brushes){
		while(!Brush::brush_list.empty()){
			Brush* brush=*Brush::brush_list.begin();
			brush->FreeBrush();
		}
		//Brush::brush_list.clear();
		
		while(!Shader::shader_list.empty()){
			Shader* s=*Shader::shader_list.begin();
			s->FreeShader();
		}
	}
	
	if(textures){
		while(!Texture::tex_list.empty()){
			Texture* tex=*Texture::tex_list.begin();
			tex->FreeTexture();
		}
		//Texture::tex_list.clear();
		//Texture::tex_list_all.clear();
	}
	
}

void Global::UpdateWorld(float anim_speed){
	Global::anim_speed=anim_speed;

	// particles
	list<ParticleEmitter*>::iterator it2;

	for(it2=ParticleEmitter::emitter_list.begin();it2!=ParticleEmitter::emitter_list.end();it2++){
		ParticleEmitter* emitter=*it2;
		emitter->Update();
	}

	// Actions
	Action::Update();

	// anim
	list<Entity*>::iterator it;

	for(it=Entity::animate_list.begin();it!=Entity::animate_list.end();it++){
		Mesh* mesh=dynamic_cast<Mesh*>(*it);
		UpdateEntityAnim(*mesh);
	}

	//Physics
	Constraint::Update();
	RigidBody::Update();

	// collision
	UpdateCollisions();


}

void Global::RenderWorld(){

	// if anti-aliasing enabled then call RenderWorldAA
	if(aa){
		RenderWorldAA();
		return;
	}
	
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

	list<PostFX*>::iterator it2;
	for(it2=PostFX::fx_list.begin();it2!=PostFX::fx_list.end();it2++){
		PostFX* fx=*it2;
		fx->Render();
	}

}

void Global::RenderWorldAA(){

	glClear(GL_ACCUM_BUFFER_BIT);
	for(jitter=0; jitter<ACSIZE; jitter++){
	
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
		
		glAccum(GL_ACCUM,1.0/ACSIZE);
	}
	jitter=0;
	glAccum(GL_RETURN,1.0);
	glFlush();
	
	list<PostFX*>::iterator it2;
	for(it2=PostFX::fx_list.begin();it2!=PostFX::fx_list.end();it2++){
		PostFX* fx=*it2;
		fx->Render();
	}
	
}

void Global::AntiAlias(int samples){

	aa=true;
	if(samples==false){
		aa=0;
		return;
	}
	
	switch (samples){
		case 1 : ACSIZE=2; break;
		case 2 : ACSIZE=2; break;
		case 3 : ACSIZE=3; break;
		case 4 : ACSIZE=4; break;
		case 5 : ACSIZE=5; break;
		case 6 : ACSIZE=6; break;
		case 8 : ACSIZE=8; break;
		case 9 : ACSIZE=9; break;
		case 12 : ACSIZE=12; break;
		case 16 : ACSIZE=16; break;
		default : aa=false; ACSIZE=0; return;
	}

	for(int i=0; i<samples; i++){
		int k=i*2;
		switch (samples){
			case 1 : j_data[i][0]=j2_data[k]; j_data[i][1]=j2_data[k+1]; break;
			case 2 : j_data[i][0]=j2_data[k]; j_data[i][1]=j2_data[k+1]; break;
			case 3 : j_data[i][0]=j3_data[k]; j_data[i][1]=j3_data[k+1]; break;
			case 4 : j_data[i][0]=j4_data[k]; j_data[i][1]=j4_data[k+1]; break;
			case 5 : j_data[i][0]=j5_data[k]; j_data[i][1]=j5_data[k+1]; break;
			case 6 : j_data[i][0]=j6_data[k]; j_data[i][1]=j6_data[k+1]; break;
			case 8 : j_data[i][0]=j8_data[k]; j_data[i][1]=j8_data[k+1]; break;
			case 9 : j_data[i][0]=j9_data[k]; j_data[i][1]=j9_data[k+1]; break;
			case 12 : j_data[i][0]=j12_data[k]; j_data[i][1]=j12_data[k+1]; break;
			case 16 : j_data[i][0]=j16_data[k]; j_data[i][1]=j16_data[k+1]; break;
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

void Global::TextureLoader( char* texid,int lf0,int fr1,int rt2,int bk3,int dn4,int up5 ){

	if (strcmp(texid,"frames") == 0){
		Global::cubemap_frame[0] = lf0;
		Global::cubemap_frame[1] = fr1;
		Global::cubemap_frame[2] = rt2;
		Global::cubemap_frame[3] = bk3;
		Global::cubemap_frame[4] = dn4;
		Global::cubemap_frame[5] = up5;
	}else if (strcmp(texid,"faces") == 0){
		Global::cubemap_face[lf0] = GL_TEXTURE_CUBE_MAP_NEGATIVE_X; // left (B3D layout)
		Global::cubemap_face[fr1] = GL_TEXTURE_CUBE_MAP_POSITIVE_Z; // front
		Global::cubemap_face[rt2] = GL_TEXTURE_CUBE_MAP_POSITIVE_X; // right
		Global::cubemap_face[bk3] = GL_TEXTURE_CUBE_MAP_NEGATIVE_Z; // back
		Global::cubemap_face[dn4] = GL_TEXTURE_CUBE_MAP_POSITIVE_Y; // up
		Global::cubemap_face[up5] = GL_TEXTURE_CUBE_MAP_NEGATIVE_Y; // down
	}else if (strcmp(texid,"noflipcubemap") == 0){
		Global::flip_cubemap = 0;
	}else if (strcmp(texid,"flipcubemap") == 0){
		Global::flip_cubemap = 1;
	}
	
}

bool CompareEntityOrder(Entity* ent1,Entity* ent2){

	if(ent1->order>ent2->order){
		return true;
	}else{
		return false;
	}

}
