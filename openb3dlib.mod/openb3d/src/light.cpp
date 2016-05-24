
#ifdef OPENB3D_GLEW
	#include "glew.h"
#else
	#ifdef linux
	#define GL_GLEXT_PROTOTYPES
	#include <GL/gl.h>
	#include <GL/glext.h>
	#include <GL/glu.h>
	#endif

	#ifdef WIN32
	#include <gl\GLee.h>
	#include <GL\glu.h>
	#endif

	#ifdef __APPLE__
	#include "GLee.h"
	#include <OpenGL/glu.h>
	#endif
#endif

/*
 *  light.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

//#define GLES2

#include "light.h"
#include "pick.h"

int Light::light_no=0;
int Light::no_lights=0;
int Light::max_lights=8;

#ifdef GLES2
	float Light::light_types[8];
	float Light::light_matrices[8][4][4];
	float Light::light_outercone[8];
	float Light::light_color[8][3];
#endif


#ifndef GLES2
int Light::gl_light[]={GL_LIGHT0,GL_LIGHT1,GL_LIGHT2,GL_LIGHT3,GL_LIGHT4,GL_LIGHT5,GL_LIGHT6,GL_LIGHT7};
#endif

vector<Light*> Light::light_list;


Light* Light::CopyEntity(Entity* parent_ent){

	// new light
	Light* light=new Light;
	
	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(light);
	}
	
	// lists
	
	// add parent, add to list
	light->AddParent(*parent_ent);
	entity_list.push_back(light);
	
	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(light);
	}
	
	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(light);
	}
	
	// update matrix
	if(light->parent){
		light->mat.Overwrite(light->parent->mat);
	}else{
		light->mat.LoadIdentity();
	}
	
	// copy entity info
	
	light->mat.Multiply(mat);
	
	light->px=px;
	light->py=py;
	light->pz=pz;
	light->sx=sx;
	light->sy=sy;
	light->sz=sz;
	light->rx=rx;
	light->ry=ry;
	light->rz=rz;
	light->qw=qw;
	light->qx=qx;
	light->qy=qy;
	light->qz=qz;

	light->name=name;
	light->class_name=class_name;
	light->order=order;
	light->hide=false;
	
	light->cull_radius=cull_radius;
	light->radius_x=radius_x;
	light->radius_y=radius_y;
	light->box_x=box_x;
	light->box_y=box_y;
	light->box_z=box_z;
	light->box_w=box_w;
	light->box_h=box_h;
	light->box_d=box_d;
	light->collision_type=collision_type;
	light->pick_mode=pick_mode;
	light->obscurer=obscurer;

	// copy light info
		
	light_list.push_back(light); // add new light to global light list
	
	light->cast_shadow=cast_shadow;
	light->light_type=light_type;
	light->range=range;
	light->red=red;
	light->green=green;
	light->blue=blue;
	light->inner_ang=inner_ang;
	light->outer_ang=outer_ang;
	
	return light;
	
}

void Light::FreeEntity(){

	Entity::FreeEntity();

#ifndef GLES2
	int erased=0;

	for (int i=0; i<no_lights;i++){
		glDisable(gl_light[i]);
		if (!erased && light_list[i]==this){
			light_list.erase(light_list.begin()+i);
			erased=1;
		}
	}

#endif
	no_lights=no_lights-1;
	
	delete this;
	
	return;

}

Light* Light::CreateLight(int l_type,Entity* parent_ent){

	if(no_lights>=max_lights) return NULL; // no more lights available, return and don't create

	Light* light=new Light;
	if (l_type>0){
		light->light_type=l_type;
	}else{
		light->light_type=-l_type;
		light->cast_shadow=0;			//if type is negative, light won't cast shadows
	}
	light->class_name="Light";
	
#ifndef GLES2
	// no of lights increased, enable additional gl light
	no_lights=no_lights+1;
	glEnable(gl_light[no_lights-1]);
		
	float white_light[]={1.0,1.0,1.0,1.0};
	glLightfv(gl_light[no_lights-1],GL_SPECULAR,white_light);
		
	// if point light or spotlight then set constant attenuation to 0
	if(light->light_type>1){
		float light_range[]={0.0};
		glLightfv(gl_light[no_lights-1],GL_CONSTANT_ATTENUATION,light_range);
	}
		
	// if spotlight then set exponent to 10.0 (controls fall-off of spotlight - roughly matches B3D)
	if(light->light_type==3){
		float exponent[]={10.0};
		glLightfv(gl_light[no_lights-1],GL_SPOT_EXPONENT,exponent);
	}
#else
	no_lights=no_lights+1;
#endif
	
	light_list.push_back(light);
	light->AddParent(*parent_ent);
	entity_list.push_back(light);

	// update matrix
	if(light->parent!=NULL){
		light->mat.Overwrite(light->parent->mat);
		light->UpdateMat();
	}else{
		light->UpdateMat(true);
	}
	
	return light;

}

void Light::LightRange(float light_range){
	
	range=1.0/light_range;
		
}
		
void Light::LightColor(float r,float g,float b){
	
	red=r/255.0;
	green=g/255.0;
	blue=b/255.0;
		
}
	
void Light::LightConeAngles(float inner,float outer){
	
	inner_ang=inner/2.0;
	outer_ang=outer/2.0;
		
}
	
void Light::Update(){
	light_no=light_no+1;
	if(light_no>no_lights) light_no=1;
	
	
#ifndef GLES2
	if(hide==true){
		glDisable(gl_light[light_no-1]);
		return;
	}else{
		glEnable(gl_light[light_no-1]);
	}
	
	/*glEnable(gl_light[light_no-1]);*/

	glPushMatrix();

	glMultMatrixf(&mat.grid[0][0]);
		
	float z=1.0;
	float w=0.0;
	if(light_type>1){
		z=0.0;
		w=1.0;
	}
		
	float rgba[]={red,green,blue,1.0};
	float pos[]={0.0,0.0,z,w};
		
	glLightfv(gl_light[light_no-1],GL_POSITION,pos);
	glLightfv(gl_light[light_no-1],GL_DIFFUSE,rgba);

	// point or spotlight, set attenuation
	if(light_type>1){
		
		float light_range[]={range};
			
		glLightfv(gl_light[light_no-1],GL_LINEAR_ATTENUATION,light_range);
		
	}

	// spotlight, set direction and range
	if(light_type==3){ 
		
		float dir[]={0.0,0.0,-1.0};
		float outer[]={outer_ang};
		
		glLightfv(gl_light[light_no-1],GL_SPOT_DIRECTION,dir);
		glLightfv(gl_light[light_no-1],GL_SPOT_CUTOFF,outer);
		
	}
		
	glPopMatrix();
#else

	light_color[light_no-1][0]=red;
	light_color[light_no-1][1]=green;
	light_color[light_no-1][2]=blue;

	//Matrix inv;
	//mat.GetInverse(inv);

	if(light_type==1){
		for (int x = 0;x < 3; x++){
			for (int y = 0;y <= 3; y++){
				light_matrices[light_no-1][x][y] = mat.grid[x][y];
			}
		}
		for (int y = 0;y <= 3; y++){
			light_matrices[light_no-1][y][3] = 0.0;
		}
	}else if (light_type==2){
		for (int i = 0;i <= 3; i++){
			light_matrices[light_no-1][3][i] = mat.grid[3][i];
		}
	}else if (light_type==3){
		for (int x = 0;x <= 3; x++){
			for (int y = 0;y <= 3; y++){
				light_matrices[light_no-1][x][y] = mat.grid[x][y];
			}
		}
		light_outercone[light_no-1]=cosdeg(outer_ang);

	}

	light_types[light_no-1]=light_type;

	/*if(light_no==no_lights) {
		for (int t=0;t<=8;t++){
			glUniformMatrix4fv(Global::ambient_shader_lightMat[no_lights][t], no_lights , 0, light_matrices[0][0] );
			glUniform1fv(Global::ambient_shader_lightType[no_lights][t], no_lights , light_types);
			glUniform3fv(Global::ambient_shader_lightColor[no_lights][t], no_lights , light_color[0]);
		}
	}*/

#endif
	
																	
}
