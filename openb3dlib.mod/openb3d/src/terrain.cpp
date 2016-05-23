
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
#endif

#ifdef __APPLE__
#include "GLee.h"
#endif
#endif

/*
 *  terrain.cpp
 *  minib3d
 *
 *
 */



#include "global.h"
#include "entity.h"
#include "camera.h"
#include "brush.h"
#include "terrain.h"
#include "pick.h"


#include "stb_image.h"
#include "string_helper.h"
#include "file.h"
#include "tree.h"

//#define GLES2
#ifdef GLES2
#include "light.h"
#endif

int Terrain::triangleindex;

static Line Ray;
static float radius;


static vector<float> vertices;


MeshInfo* Terrain::mesh_info;
list<Terrain*> Terrain::terrain_list;

Terrain* Terrain::CopyEntity(Entity* parent_ent){

	// new terr
	Terrain* terr=new Terrain;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(terr);
	}

	// lists

	// add parent, add to list
	terr->AddParent(*parent_ent);
	entity_list.push_back(terr);

	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(terr);
	}

	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(terr);
	}

	// update matrix
	if(terr->parent){
		terr->mat.Overwrite(terr->parent->mat);
	}else{
		terr->mat.LoadIdentity();
	}

	// copy entity info

	terr->mat.Multiply(mat);

	terr->px=px;
	terr->py=py;
	terr->pz=pz;
	terr->sx=sx;
	terr->sy=sy;
	terr->sz=sz;
	terr->rx=rx;
	terr->ry=ry;
	terr->rz=rz;
	terr->qw=qw;
	terr->qx=qx;
	terr->qy=qy;
	terr->qz=qz;

	terr->name=name;
	terr->class_name=class_name;
	terr->order=order;
	terr->hide=false;

	terr->cull_radius=cull_radius;
	terr->radius_x=radius_x;
	terr->radius_y=radius_y;
	terr->box_x=box_x;
	terr->box_y=box_y;
	terr->box_z=box_z;
	terr->box_w=box_w;
	terr->box_h=box_h;
	terr->box_d=box_d;
	terr->collision_type=collision_type;
	terr->pick_mode=pick_mode;
	terr->obscurer=obscurer;

	//copy terrain info
	terr->brush=brush;

	terr->ShaderMat=ShaderMat;

	terr->size=size;
	terr->vsize=vsize;
	for (int i = 0; i<= ROAM_LMAX+1; i++){
		terr->level2dzsize[i] = level2dzsize[i];
	}
	int tsize=size;
	terr->height=new float[(tsize+1)*(tsize+1)];
	for (int i = 0; i<= (tsize+1)*(tsize+1); i++){
		terr->height[i]=height[i];
	}
	terr->NormalsMap=new float[(tsize+1)*(tsize+1)*3];
	for (int i = 0; i<= (tsize+1)*(tsize+1)*3; i++){
		terr->NormalsMap[i]=NormalsMap[i];
	}

	mesh_info=C_NewMeshInfo();
	terr->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);

	terrain_list.push_back(terr);

#ifdef GLES2
	glGenBuffers(1,&terr->vbo_id);
#endif

	return terr;

}


Terrain* Terrain::CreateTerrain(int tsize, Entity* parent_ent){

	Terrain* terr=new Terrain;

	for (int i = 0; i<= ROAM_LMAX; i++){
		terr->level2dzsize[i] = 0;
	}
        int lmax=tsize/100+10;
	if (lmax>=ROAM_LMAX) lmax=ROAM_LMAX;

	for (int i = 0; i<= lmax; i++){
		terr->level2dzsize[i] = (float)pow((float)tsize/2048 / sqrt((float)(1 << i)),2);	// <-------------terrain detail here
	}

	terr->ShaderMat=Global::ambient_shader;

	//terr->brush=new brush;
	mesh_info=C_NewMeshInfo();
	terr->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);
	terr->AddParent(*parent_ent);
	terrain_list.push_back(terr);
	if (tsize!=0){
		terr->size=tsize;
		terr->vsize=30;
		terr->height=new float[(tsize+1)*(tsize+1)];
		terr->NormalsMap=new float[(tsize+1)*(tsize+1)*3];

	}

#ifdef GLES2
	glGenBuffers(1,&terr->vbo_id);
#endif

	return terr;

}

void Terrain::UpdateTerrain(){

#ifndef GLES2
	glBindBuffer(GL_ARRAY_BUFFER,0);

	RecreateROAM();

	glDisable(GL_ALPHA_TEST);
#else
	RecreateROAM();
	if (triangleindex==0) return;
#endif

	if (order!=0){
		glDisable(GL_DEPTH_TEST);
		glDepthMask(GL_FALSE);
	}else{
		glEnable(GL_DEPTH_TEST);
		glDepthMask(GL_TRUE);
	}

	switch(brush.blend){
		case 0:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
			break;
		case 1:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
			break;
		case 2:
			glBlendFunc(GL_DST_COLOR,GL_ZERO); // multiply
			break;
		case 3:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE); // additive and alpha
			break;
		}

	float ambient_red,ambient_green,ambient_blue;

#ifndef GLES2
	// fx flag 1 - full bright ***todo*** disable all lights?
	if (brush.fx & 1){
		if(Global::fx1!=true){
			Global::fx1=true;
			glDisableClientState(GL_NORMAL_ARRAY);
		}
		ambient_red  =1.0;
		ambient_green=1.0;
		ambient_blue =1.0;
	}else{
		if(Global::fx1!=false){
			Global::fx1=false;
			glEnableClientState(GL_NORMAL_ARRAY);
		}
		ambient_red  =Global::ambient_red;
		ambient_green=Global::ambient_green;
		ambient_blue =Global::ambient_blue;
	}

	// fx flag 2 - vertex colours
	/*if(brush.fx&2){

			glEnable(GL_COLOR_MATERIAL);
	}else{
			glDisable(GL_COLOR_MATERIAL);
	}*/
	if(Global::fx2!=false){
		Global::fx2=false;
		glDisableClientState(GL_COLOR_ARRAY);
		glDisable(GL_COLOR_MATERIAL);
	}


	// fx flag 4 - flatshaded
	if(brush.fx&4){
		glShadeModel(GL_FLAT);
	}else{
		glShadeModel(GL_SMOOTH);
	}

	// fx flag 8 - disable fog
	if(brush.fx&8){
		if(Global::fog_enabled==true){ // only disable if fog enabled in camera update
			glDisable(GL_FOG);
		}
	}

	// fx flag 16 - disable backface culling
	if(brush.fx&16){
		glDisable(GL_CULL_FACE);
	}else{
		glEnable(GL_CULL_FACE);
	}

	// light + material color

	float ambient[]={ambient_red,ambient_green,ambient_blue};
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT,ambient);

	float mat_ambient[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_diffuse[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_specular[]={brush.shine,brush.shine,brush.shine,brush.shine};
	float mat_shininess[]={100.0}; // upto 128

	glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,mat_ambient);
	glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,mat_diffuse);
	glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,mat_specular);
	glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS,mat_shininess);
#else
	int tex_count=0;
	tex_count=brush.no_texs;
	int tblendflags[8][2];
	float tmatrix[8][9];
	float tcoords[8];

	if (&Global::shaders[Light::no_lights][tex_count][Global::camera_in_use->fog_mode]!=Global::shader){
		Global::shader=&Global::shaders[Light::no_lights][tex_count][Global::camera_in_use->fog_mode];
		glUseProgram(Global::shader->ambient_program);
		glUniformMatrix4fv(Global::shader->view, 1 , 0, &Global::camera_in_use->mod_mat[0] );
		glUniformMatrix4fv(Global::shader->proj, 1 , 0, &Global::camera_in_use->proj_mat[0] );

		glUniformMatrix4fv(Global::shader->lightMat, Light::no_lights , 0, Light::light_matrices[0][0] );
		glUniform1fv(Global::shader->lightType, Light::no_lights , Light::light_types);
		glUniform1fv(Global::shader->lightOuterCone, Light::no_lights , Light::light_outercone);
		glUniform3fv(Global::shader->lightColor, Light::no_lights , Light::light_color[0]);

		glUniform3f(Global::shader->fogColor, Global::camera_in_use->fog_r, Global::camera_in_use->fog_g, Global::camera_in_use->fog_b);
		glUniform2f(Global::shader->fogRange, Global::camera_in_use->fog_range_near, Global::camera_in_use->fog_range_far);
	}

	if(brush.fx&1){
		if(Global::fx1!=true){
			Global::fx1=true;
		}
		ambient_red  =1.0;
		ambient_green=1.0;
		ambient_blue =1.0;
	}else{
		if(Global::fx1!=false){
			Global::fx1=false;
		}
		ambient_red  =Global::ambient_red;
		ambient_green=Global::ambient_green;
		ambient_blue =Global::ambient_blue;
	}

	if(brush.fx&16){
		glDisable(GL_CULL_FACE);
	}else{
		glEnable(GL_CULL_FACE);
	}

	glUniform3f(Global::shader->amblight, ambient_red,ambient_green,ambient_blue);

	glUniform1f(Global::shader->shininess, brush.shine);

	float mat_ambient[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_diffuse[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_specular[]={brush.shine,brush.shine,brush.shine,brush.shine};
	float mat_shininess[]={100.0}; // upto 128

#endif

	// textures

#ifndef GLES2
	int tex_count=0;
#endif
	if(ShaderMat!=NULL){
		ShaderMat->TurnOn(mat, 0, &vertices);
	}

#ifndef GLES2
	tex_count=brush.no_texs;
#endif

	int DisableCubeSphereMapping=0;
	for(int ix=0;ix<tex_count;ix++){

		if(brush.tex[ix]){

			// Main brush texture takes precedent over surface brush texture
			unsigned int texture=0;
			int tex_flags=0,tex_blend=0;
			float tex_u_scale=1.0,tex_v_scale=1.0,tex_u_pos=0.0,tex_v_pos=0.0,tex_ang=0.0;
			int tex_cube_mode=0;


			texture=brush.cache_frame[ix];
			tex_flags=brush.tex[ix]->flags;
			tex_blend=brush.tex[ix]->blend;
			//tex_coords=brush.tex[ix]->coords;
			tex_u_scale=brush.tex[ix]->u_scale;
			tex_v_scale=brush.tex[ix]->v_scale;
			tex_u_pos=brush.tex[ix]->u_pos;
			tex_v_pos=brush.tex[ix]->v_pos;
			tex_ang=brush.tex[ix]->angle;
			tex_cube_mode=brush.tex[ix]->cube_mode;
			//frame=brush.tex_frame;

			glActiveTexture(GL_TEXTURE0+ix);
#ifndef GLES2
			glClientActiveTexture(GL_TEXTURE0+ix);
#endif

			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D,texture); // call before glTexParameteri

#ifndef GLES2
			// masked texture flag
			if(tex_flags&4){
				glEnable(GL_ALPHA_TEST);
			}else{
				glDisable(GL_ALPHA_TEST);
			}
#endif

			// mipmapping texture flag
			if(tex_flags&8){
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
			}else{
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
			}

			// clamp u flag
			if(tex_flags&16){
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
			}else{
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
			}

			// clamp v flag
			if(tex_flags&32){
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
			}else{
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
			}

#ifndef GLES2
			// ***!ES***

			// spherical environment map texture flag
			if(tex_flags&64){
				glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
				glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
				glEnable(GL_TEXTURE_GEN_S);
				glEnable(GL_TEXTURE_GEN_T);
				DisableCubeSphereMapping=1;
			}/*else{
				glDisable(GL_TEXTURE_GEN_S);
				glDisable(GL_TEXTURE_GEN_T);
			}*/

				// cubic environment map texture flag
				if(tex_flags&128){

					glEnable(GL_TEXTURE_CUBE_MAP);
					glBindTexture(GL_TEXTURE_CUBE_MAP,texture); // call before glTexParameteri

					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_R,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);

					glEnable(GL_TEXTURE_GEN_S);
					glEnable(GL_TEXTURE_GEN_T);
					glEnable(GL_TEXTURE_GEN_R);
					//glEnable(GL_TEXTURE_GEN_Q)

					if(tex_cube_mode==1){
						glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
						glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
						glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
					}

					if(tex_cube_mode==2){
						glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
						glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
						glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
					}
					DisableCubeSphereMapping=1;

				}else  if (DisableCubeSphereMapping!=0){

					glDisable(GL_TEXTURE_CUBE_MAP);

					// only disable tex gen s and t if sphere mapping isn't using them
					if((tex_flags & 64)==0){
						glDisable(GL_TEXTURE_GEN_S);
						glDisable(GL_TEXTURE_GEN_T);
					}

					glDisable(GL_TEXTURE_GEN_R);
					//glDisable(GL_TEXTURE_GEN_Q)

				}


			switch(tex_blend){
				case 0: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE);
				break;
				case 1: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
				break;
				case 2: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
				//case 2 glTexEnvf(GL_TEXTURE_ENV,GL_COMBINE_RGB_EXT,GL_MODULATE);
				break;
				case 3: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_ADD);
				break;
				case 4:
					glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_EXT);
					glTexEnvf(GL_TEXTURE_ENV, GL_COMBINE_RGB_EXT, GL_DOT3_RGB_EXT);
					break;
				case 5:
					glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE);
					glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_MODULATE);
					glTexEnvi(GL_TEXTURE_ENV,GL_RGB_SCALE,2.0);
					break;
				default: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
			}

			glEnableClientState(GL_TEXTURE_COORD_ARRAY);
			glTexCoordPointer(2,GL_FLOAT,8*sizeof(float),&vertices[6]);


			// reset texture matrix
			glMatrixMode(GL_TEXTURE);
			glLoadIdentity();

			if(tex_u_pos!=0.0 || tex_v_pos!=0.0){
				glTranslatef(tex_u_pos,tex_v_pos,0.0);
			}
			if(tex_ang!=0.0){
				glRotatef(tex_ang,0.0,0.0,1.0);
			}
			if(tex_u_scale!=1.0 || tex_v_scale!=1.0){
				glScalef(tex_u_scale,tex_v_scale,1.0);
			}

			// ***!ES***
			// if spheremap flag=true then flip tex
			if(tex_flags&64){
				glScalef(1.0,-1.0,-1.0);
			}

			// if cubemap flag=true then manipulate texture matrix so that cubemap is displayed properly
			if(tex_flags&128){

				glScalef(1.0,-1.0,-1.0);

				// get current modelview matrix (set in last camera update)
				float mod_mat[16];
				glGetFloatv(GL_MODELVIEW_MATRIX,&mod_mat[0]);

				// get rotational inverse of current modelview matrix
				Matrix new_mat;
				new_mat.LoadIdentity();

				new_mat.grid[0][0] = mod_mat[0];
				new_mat.grid[1][0] = mod_mat[1];
				new_mat.grid[2][0] = mod_mat[2];

				new_mat.grid[0][1] = mod_mat[4];
				new_mat.grid[1][1] = mod_mat[5];
				new_mat.grid[2][1] = mod_mat[6];

				new_mat.grid[0][2] = mod_mat[8];
				new_mat.grid[1][2] = mod_mat[9];
				new_mat.grid[2][2] = mod_mat[10];

				glMultMatrixf(&new_mat.grid[0][0]);

			}
#else

					tmatrix[ix][0]= 1.0; tmatrix[ix][1]= 0.0; tmatrix[ix][2]= 0.0;
					tmatrix[ix][3]= 0.0; tmatrix[ix][4]= 1.0; tmatrix[ix][5]= 0.0;
					tmatrix[ix][6]= 0.0; tmatrix[ix][7]= 0.0; tmatrix[ix][8]= 1.0;

					if(tex_u_pos!=0.0 || tex_v_pos!=0.0){
						tmatrix[ix][6]= tex_u_pos; tmatrix[ix][7]= tex_v_pos;
					}
					if(tex_ang!=0.0){
						float cos_ang=cosdeg(tex_ang);
						float sin_ang=sindeg(tex_ang);
						tmatrix[ix][0]= cos_ang; tmatrix[ix][1]= sin_ang; 
						tmatrix[ix][3]=-sin_ang; tmatrix[ix][4]= cos_ang; 

					}
					if(tex_u_scale!=1.0 || tex_v_scale!=1.0){
						tmatrix[ix][0]*= tex_u_scale; tmatrix[ix][1]*= tex_v_scale; 
						tmatrix[ix][3]*= tex_u_scale; tmatrix[ix][4]*= tex_v_scale; 
					}

					if(tex_flags&128){
	
						glEnable(GL_TEXTURE_CUBE_MAP);
						glBindTexture(GL_TEXTURE_CUBE_MAP,texture); // call before glTexParameteri
	
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_R,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
						tex_blend+=128;
					}

					tblendflags[ix][0]=tex_blend;
					tblendflags[ix][1]=tex_flags&(4|128);
					tcoords[ix]=0;
#endif


		}

	}

#ifndef GLES2
	// draw tris
	glMatrixMode(GL_MODELVIEW);

	glPushMatrix();
	glMultMatrixf(&mat.grid[0][0]);
	glVertexPointer(3,GL_FLOAT,8*sizeof(float),&vertices[0]);
	glNormalPointer(GL_FLOAT,8*sizeof(float),&vertices[3]);
#else
	glUniform2iv(Global::shader->texflag, tex_count , tblendflags[0]);
	glUniformMatrix3fv(Global::shader->texmat, tex_count, 0, tmatrix[0]);
	glUniform1fv(Global::shader->tex_coords_set, tex_count , tcoords);

	glBindBuffer(GL_ARRAY_BUFFER,vbo_id);
	glBufferData(GL_ARRAY_BUFFER,(triangleindex*3*8*sizeof(float)),&vertices[0],GL_STREAM_DRAW);
	glVertexAttribPointer(Global::shader->vposition, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)0);
	glEnableVertexAttribArray(Global::shader->vposition);
	glVertexAttribPointer(Global::shader->vnormal, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)(3*sizeof(float)));
	glEnableVertexAttribArray(Global::shader->vnormal);
	glVertexAttribPointer(Global::shader->tex_coords, 2, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)(6*sizeof(float)));
	glEnableVertexAttribArray(Global::shader->tex_coords);
	glDisableVertexAttribArray(Global::shader->tex_coords2);

	glUniformMatrix4fv(Global::shader->model, 1 , 0, &mat.grid[0][0] );

	glDisableVertexAttribArray(Global::shader->color);
	glVertexAttrib4f(Global::shader->color, brush.red,brush.green,brush.blue,brush.alpha);

#endif

	glDrawArrays(GL_TRIANGLES, 0, triangleindex*3);
#ifndef GLES2
	glPopMatrix();

	// disable all texture layers
	for(int ix=0;ix<tex_count;ix++){

		glActiveTexture(GL_TEXTURE0+ix);
		glClientActiveTexture(GL_TEXTURE0+ix);

		// reset texture matrix
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();

		glDisable(GL_TEXTURE_2D);

		// ***!ES***
		if (DisableCubeSphereMapping!=0){
			glDisable(GL_TEXTURE_CUBE_MAP);
			glDisable(GL_TEXTURE_GEN_S);
			glDisable(GL_TEXTURE_GEN_T);
			glDisable(GL_TEXTURE_GEN_R);
			//DisableCubeSphereMapping=0;
		}

	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);


	if (brush.fx&8 && Global::fog_enabled==true){
		glEnable(GL_FOG);
	}

	if(ShaderMat!=NULL){
		ShaderMat->TurnOff();
	}
#else
	glDisableVertexAttribArray(Global::shader->vposition);
#endif

}

void Terrain::RecreateROAM(){

	/*xcf = eyepoint->EntityX();
	ycf = eyepoint->EntityY();
	zcf = -eyepoint->EntityZ();*/

	TFormPoint(eyepoint->EntityX(true), eyepoint->EntityY(true), eyepoint->EntityZ(true), 0, this);
	xcf = tformed_x;
	ycf = tformed_y;
	zcf = -tformed_z;

	//int i;
	float v[4][3];


	v[0][0] = 0.0; 		v[0][2] = size;
	v[0][1] = height[(int)size] * vsize;

	v[1][0] = size; 	v[1][2] = size;
	v[1][1] = height[(int)(size*(size+1))] * vsize;

	v[2][0] = size; 	v[2][2] = 0;
	v[2][1] = height[(int)(size*size)] * vsize;

	v[3][0] = 0.0; 		v[3][2] = 0;
	v[3][1] = height[0] * vsize;

	// diamond radius - apply entity scale
	float rx=EntityScaleX(true);
	float ry=EntityScaleY(true);
	float rz=EntityScaleZ(true);
	if(rx>=ry && rx>=rz){
		dradius=abs(rx);
	}else if(ry>=rx && ry>=rz){
		dradius=abs(ry);
	}else{
		dradius=abs(rz);
	}


	//MQ_GetMatrix(tmat, true);



	triangleindex = 0;

	vertices.clear();

	/* recurse on the two base triangles */
	drawsub(0, v[0], v[1], v[2]);
	drawsub(0, v[2], v[3], v[0]);


}

void Terrain::drawsub(int l, float v0[], float v1[], float v2[]){

	float vc[3]; 	/* New (split) vertex */
	float ds;	/* maximum midpoint displacement */
	float dx,dy,dz;	/* difference vector */
	float rd;	/* squared sphere bound radius */
	float rc;	/* squared distance from vc To camera position */

	if (l < ROAM_LMAX) {
		/* compute split point of base edge */
		vc[0] = (v0[0] + v2[0]) / 2;
		vc[2] = (v0[2] + v2[2]) / 2;
		vc[1] = height[(int)(vc[0]*size+ vc[2])] * vsize;


		ds = level2dzsize[l];

		/* compute radius of diamond bounding sphere (squared) */
		float x,y,z;
		x = vc[0];
		y = vc[1];
		z = vc[2];
		rd = 0.0;
		dx = v0[0] - x;
		dy = v0[1] - y;
		dz = v0[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		dx = v1[0] - x;
		dy = v1[1] - y;
		dz = v1[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		dx = v2[0] - x;
		dy = v2[1] - y;
		dz = v2[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		rd = sqrt(rd)*dradius;

		//int m = 1;

		/*TFormPoint(vc[0],vc[1],vc[2],this,0);
		float vcx=tformed_x;
		float vcy=tformed_y;
		float vcz=tformed_z;*/

		float vcx=vc[0];
		float vcy=vc[1];
		float vcz=-vc[2];
		mat.TransformVec(vcx, vcy, vcz, 1);

		for (int i = 0 ;i<= 5; i++){
			float d = eyepoint->frustum[i][0] * vcx + eyepoint->frustum[i][1] * vcy - eyepoint->frustum[i][2] * vcz + eyepoint->frustum[i][3];
			if (d <= -rd) return;//{ds=ds/10; break;}
			//m = m << 1;
		}

		/* compute distance from split point To camera (squared) */
		dx = vc[0] - xcf;
		dy = vc[1] - ycf;
		dz = vc[2] - zcf;
		rc = dx*dx+dy*dy+dz*dz;

		/* If not error large on screen, recursively split */
		if (ds > (rc * 0.000000003)) {/*<---------terrain detail here*/
			drawsub(l + 1, v1, vc, v0);
			drawsub(l + 1, v2, vc, v1);
			return;
		}

	 }
	vertices.push_back(v0[0]); vertices.push_back(v0[1]); vertices.push_back(v0[2]);
	vertices.push_back(NormalsMap[3*(int)(v0[0]*size+ v0[2])+0]);
	vertices.push_back(NormalsMap[3*(int)(v0[0]*size+ v0[2])+1]);
	vertices.push_back(NormalsMap[3*(int)(v0[0]*size+ v0[2])+2]);
	vertices.push_back(v0[0]);
	vertices.push_back(v0[2]);


	vertices.push_back(v1[0]); vertices.push_back(v1[1]); vertices.push_back(v1[2]);
	vertices.push_back(NormalsMap[3*(int)(v1[0]*size+ v1[2])+0]);
	vertices.push_back(NormalsMap[3*(int)(v1[0]*size+ v1[2])+1]);
	vertices.push_back(NormalsMap[3*(int)(v1[0]*size+ v1[2])+2]);
	vertices.push_back(v1[0]);
	vertices.push_back(v1[2]);


	vertices.push_back(v2[0]); vertices.push_back(v2[1]); vertices.push_back(v2[2]);
	vertices.push_back(NormalsMap[3*(int)(v2[0]*size+ v2[2])+0]);
	vertices.push_back(NormalsMap[3*(int)(v2[0]*size+ v2[2])+1]);
	vertices.push_back(NormalsMap[3*(int)(v2[0]*size+ v2[2])+2]);
	vertices.push_back(v2[0]);
	vertices.push_back(v2[2]);

	triangleindex++;

}


void Terrain::UpdateNormals(){
	//float v0[3],v1[3],v2[3];
	for (int x=1;x<=size-1;x++){
		for (int y=1;y<=size-1;y++){
			NormalsMap[3*(x*(int)size+y)]=height[(x-1)*(int)size+y] - height[(x+1)*(int)size+y];
			NormalsMap[3*(x*(int)size+y)+1]=2*vsize/size;
			NormalsMap[3*(x*(int)size+y)+2]=height[x*(int)size+y-1] - height[x*(int)size+y+1];
		}
	}
	for (int i=0;i<=size;i++){
		NormalsMap[3*i+1]=2*vsize/size;
		if (i<=size){
			NormalsMap[3*((int)size*i)+1]=2*vsize/size;
			NormalsMap[3*((int)size*i+(int)size-1)+1]=2*vsize/size;
		}
		NormalsMap[3*(i+((int)size-1)*(int)size-1)+1]=2*vsize/size;

	}

}


Terrain* Terrain::LoadTerrain(string filename,Entity* parent_ent){
	//filename=Strip(filename); // get rid of path info

	filename=File::ResourceFilePath(filename);
	/*if(File::ResourceFilePath(filename)==""){
		cout << "Error: Cannot Find Terrain: " << filename << endl;
		return NULL;
	}*/

	string filename_left=Left(filename,Len(filename)-4);
	string filename_right=Right(filename,3);

	//const char* c_filename_left=filename_left.c_str();
	//const char* c_filename_right=filename_right.c_str();

	Terrain* terr;

	unsigned char* pixels;

	int width,height;

	pixels=stbi_load(filename.c_str(),&width,&height,0,1);   //Memory leak fixed by D.J.Peters

	// all OK ?
	if (pixels!=NULL) {
		// work with a copy of the pixel pointer
		unsigned char* buffer=pixels;
		terr=Terrain::CreateTerrain(width, parent_ent);

		terr->vsize=30;
		terr->size=width;
		terr->height=new float[(width+1)*(width+1)];
		for (int x=0;x<=terr->size-1;x++){
			for (int y=0;y<=terr->size-1;y++){
				terr->height[x*(int)terr->size+y]=((float)*buffer)/255.0;
				buffer++;
			}
		}
		stbi_image_free(pixels);
		pixels=NULL;
	} else {
		// create a dummy terrain only as a dirty fallback
		width =128;
		terr=Terrain::CreateTerrain(width, parent_ent);
		terr->vsize=30;
		terr->size=width;
		terr->height=new float[(width+1)*(width+1)];
		for (int x=0;x<=terr->size-1;x++){
			for (int y=0;y<=terr->size-1;y++){
				terr->height[x*(int)terr->size+y]=0.0f;
			}
		}
	}


	terr->UpdateNormals();

	return terr;
}

void Terrain::ModifyTerrain (int x, int z, float new_height){
	height[x*(int)size+z]=new_height;
}

void Terrain::TreeCheck(CollisionInfo* ci){
	Ray=ci->coll_line;
	radius=ci->radius;

	TFormPoint(Ray.o.x, Ray.o.y, Ray.o.z, 0, this);
	xcf = tformed_x;
	ycf = tformed_y;
	zcf = -tformed_z;

	/*TFormVector(Ray.d.x, Ray.d.y, -Ray.d.z, 0, this);
	Ray.d.x = tformed_x;
	Ray.d.y = tformed_y;
	Ray.d.z = -tformed_z;*/


	//int i;
	float v[4][3];


	v[0][0] = 0.0; 		v[0][2] = size;
	v[1][0] = size; 	v[1][2] = size;
	v[2][0] = size; 	v[2][2] = 0;
	v[3][0] = 0.0; 		v[3][2] = 0;

	// diamond radius - apply entity scale
	float rx=EntityScaleX(true);
	float ry=EntityScaleY(true);
	float rz=EntityScaleZ(true);
	if(rx>=ry && rx>=rz){
		dradius=abs(rx);
	}else if(ry>=rx && ry>=rz){
		dradius=abs(ry);
	}else{
		dradius=abs(rz);
	}


	//MQ_GetMatrix(tmat, true);



	if(c_col_tree!=NULL){
		C_DeleteColTree(c_col_tree);
		c_col_tree=NULL;
	}

	mesh_info=C_NewMeshInfo();
	triangleindex = 0;


	/* recurse on the two base triangles */
	col_tree_sub(0, v[0], v[1], v[2]);
	col_tree_sub(0, v[2], v[3], v[0]);

	c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);



}

void Terrain::col_tree_sub(int l, float v0[], float v1[], float v2[]){

	float vc[3]; 	/* New (split) vertex */
	float ds;	/* maximum midpoint displacement */
	float dx,dy,dz;	/* difference vector */
	float rd;	/* squared sphere bound radius */
	float rc;	/* squared distance from vc To camera position */

	if (l < ROAM_LMAX) {
		/* compute split point of base edge */
		vc[0] = (v0[0] + v2[0]) / 2;
		vc[2] = (v0[2] + v2[2]) / 2;
		vc[1] = height[(int)(vc[0]*size+ vc[2])] * vsize;


		ds = level2dzsize[l];

		/* compute radius of diamond bounding sphere (squared) */
		float x,y,z;
		x = vc[0];
		y = vc[1];
		z = vc[2];
		rd = 0.0;
		dx = v0[0] - x;
		dy = v0[1] - y;
		dz = v0[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		dx = v1[0] - x;
		dy = v1[1] - y;
		dz = v1[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		dx = v2[0] - x;
		dy = v2[1] - y;
		dz = v2[2] - z;
		rc = dx * dx + dy * dy + dz * dz;
		if (rc > rd) {rd = rc;}
		rd = sqrt(rd)*dradius;

		//int m = 1;

		/*TFormPoint(vc[0],vc[1],vc[2],this,0);
		float vcx=tformed_x;
		float vcy=tformed_y;
		float vcz=tformed_z;*/

		float vcx=vc[0];
		float vcy=vc[1];
		float vcz=-vc[2];
		mat.TransformVec(vcx, vcy, vcz, 1);


		/*Is triangle on the collision line?*/

		Vector Sphere;
		Sphere.x=vcx;
		Sphere.y=vcy;
		Sphere.z=vcz;
		Line dst( Sphere-Ray.o,Ray.d );

		float a=dst.d.dot(dst.d);
		if( !a ) return;
		float b=dst.o.dot(dst.d)*2;
		float c=dst.o.dot(dst.o)-rd*rd;
		float d=b*b-4*a*c;

		if (d<0) return;


		/* compute distance from split point To camera (squared) */
		dx = vc[0] - xcf;
		dy = vc[1] - ycf;
		dz = vc[2] - zcf;
		rc = dx*dx+dy*dy+dz*dz;

		/* If not error large on screen, recursively split */
		if (ds > (rc * 0.000000003)) {/*<---------terrain detail here*/
			col_tree_sub(l + 1, v1, vc, v0);
			col_tree_sub(l + 1, v2, vc, v1);
			return;
		}

	 }


	//add to collisiontree
	C_AddVertex(mesh_info,v0[0],v0[1],-v0[2],0);
	C_AddVertex(mesh_info,v1[0],v1[1],-v1[2],0);
	C_AddVertex(mesh_info,v2[0],v2[1],-v2[2],0);
	C_AddTriangle(mesh_info, triangleindex, triangleindex*3+2, triangleindex*3+1, triangleindex*3+0, 0);
	triangleindex++;
}

float Terrain::TerrainHeight (int x, int z){
	return height[x*(int)size+z];
}

float Terrain::TerrainX (float x, float y, float z){
	TFormPoint(x, y, z, 0, this);
	return tformed_x;
}

float Terrain::TerrainY (float x, float y, float z){
	TFormPoint(x, y, z, 0, this);
	float p0[3],p1[3],p2[3];
	p0[0]=(int)tformed_x;
	p0[2]=(int)tformed_z;
	p0[1]=height[(int)((int)tformed_x*size-tformed_z)] * vsize;

	p2[0]=(int)tformed_x+1;
	p2[2]=(int)tformed_z;
	p2[1]=height[(int)(((int)(tformed_x+1)*size)- tformed_z)] * vsize;

	if (tformed_x-floor(tformed_x)-tformed_z+floor(tformed_z)<.5){
		p1[0]=(int)tformed_x;
		p1[2]=(int)tformed_z+1;
		p1[1]=height[(int)(((int)tformed_x*size)- tformed_z-1)] * vsize;
	}else
	{
		p1[0]=(int)tformed_x+1;
		p1[2]=(int)tformed_z+1;
		p1[1]=height[(int)(((int)(tformed_x+1)*size)- tformed_z-1)] * vsize;
	}


	float A = p0[1] *(p1[2] - p2[2]) + p1[1] *(p2[2] - p0[2]) + p2[1] *(p0[2] - p1[2]);
	float B = p0[2] *(p1[0] - p2[0]) + p1[2] *(p2[0] - p0[0]) + p2[2] *(p0[0] - p1[0]);
	float C = p0[0] *(p1[1] - p2[1]) + p1[0] *(p2[1] - p0[1]) + p2[0] *(p0[1] - p1[1]);
	float D = -(p0[0] *(p1[1] * p2[2] - p2[1] * p1[2]) + p1[0] *(p2[1]* p0[2] - p0[1]* p2[2]) + p2[0] *(p0[1] *p1[2] - p1[1] *p0[2]));
	if (B==0.0) B=0.0001;
	return -(D+A*tformed_x+C*tformed_z)/B;
}


float Terrain::TerrainZ (float x, float y, float z){
	TFormPoint(x, y, z, 0, this);
	return tformed_z;
}

void Terrain::FreeEntity(){

	delete[] height;
	delete[] NormalsMap;		

	terrain_list.remove(this);
	delete c_col_tree;

	Entity::FreeEntity();

	delete this;

	return;

}

