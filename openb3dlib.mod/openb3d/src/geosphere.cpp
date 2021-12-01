/*
 *  geosphere.cpp
 *  openb3d 
 *
 *
 */

#include "glew_glee.h" // glee or glew

#include "global.h"
#include "entity.h"
#include "camera.h"
#include "brush.h"
#include "geosphere.h"
#include "pick.h"
#include "light.h"

#include "stb_image.h"
#include "string_helper.h"
#include "file.h"
#include "tree.h"

#ifdef GLES2
#include "light.h"
#endif

static Line Ray;
static float radius;

//static vector<float> vertices;


Geosphere* Geosphere::CopyEntity(Entity* parent_ent){

	// new terr
	Geosphere* geo=new Geosphere;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(geo);
	}

	// lists

	// add parent, add to list
	geo->AddParent(parent_ent);
	entity_list.push_back(geo);

	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(geo);
	}

	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(geo);
	}

	// update matrix
	if(geo->parent){
		geo->mat.Overwrite(geo->parent->mat);
	}else{
		geo->mat.LoadIdentity();
	}

	// copy entity info

	geo->mat.Multiply(mat);

	geo->px=px;
	geo->py=py;
	geo->pz=pz;
	geo->sx=sx;
	geo->sy=sy;
	geo->sz=sz;
	geo->rx=rx;
	geo->ry=ry;
	geo->rz=rz;
	geo->qw=qw;
	geo->qx=qx;
	geo->qy=qy;
	geo->qz=qz;

	geo->name=name;
	geo->class_name=class_name;
	geo->order=order;
	geo->hide=false;

	geo->cull_radius=cull_radius;
	geo->radius_x=radius_x;
	geo->radius_y=radius_y;
	geo->box_x=box_x;
	geo->box_y=box_y;
	geo->box_z=box_z;
	geo->box_w=box_w;
	geo->box_h=box_h;
	geo->box_d=box_d;
	geo->collision_type=collision_type;
	geo->pick_mode=pick_mode;
	geo->obscurer=obscurer;

	//copy terrain info
	geo->brush=brush;

	geo->ShaderMat=ShaderMat;
	//geo->EqToToast=0;


	geo->size=size;
	geo->vsize=vsize;
	geo->hsize=hsize;
	for (int i = 0; i<= ROAM_LMAX+1; i++){
		geo->level2dzsize[i] = level2dzsize[i];
	}
	int tsize=size;
	geo->HeightMap=new float[(tsize+1)*(tsize+1)];
	for (int i = 0; i<= (tsize+1)*(tsize+1); i++){
		geo->HeightMap[i]=HeightMap[i];
	}
	geo->NormalsMap=new float[(tsize+1)*(tsize+1)*5];
	for (int i = 0; i<= (tsize+1)*(tsize+1)*5; i++){
		geo->NormalsMap[i]=NormalsMap[i];
	}

	mesh_info=C_NewMeshInfo();
	geo->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);

	terrain_list.push_back(geo);

#ifdef GLES2
	glGenBuffers(1,&geo->vbo_id);
#endif

	return geo;

}

Geosphere* Geosphere::CreateGeosphere(int tsize, Entity* parent_ent){

	Geosphere* geo=new Geosphere;

	for (int i = 0; i<= 20; i++){
		geo->level2dzsize[i] = 0;
	}
    int lmax=(int)(log(tsize)/log(2)-3.0);
	if (lmax>=ROAM_LMAX) lmax=ROAM_LMAX;

	const float LOD[20]={1700000,800000,40000,10000,5000,1000,200,10,1,0.1,0.005,
	0.001,0.0005,0.0002,0.0001,0.00005,0.00002,0.00001,0.000005,0.000002};

	for (int i = 0; i<= lmax; i++){
		geo->level2dzsize[i] = tsize*LOD[i];/*1000000000.0*(float)pow((float)tsize/8192 / sqrt((float)(1 << i)),2);	// <-------------terrain detail here*/
	}

	geo->ShaderMat=Global::ambient_shader;
	//geo->EqToToast=0;

	//terr->brush=new brush;
	mesh_info=C_NewMeshInfo();
	geo->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);
	geo->AddParent(parent_ent);
	terrain_list.push_back(geo);
	if (tsize!=0){
		geo->size=tsize/2;
		geo->hsize=tsize/4;

		geo->vsize=.05;
		geo->HeightMap=new float[(tsize+1)*(tsize+1)];
		geo->NormalsMap=new float[(tsize+1)*(tsize+1)*5];

		geo->EquirectangularToTOAST();

	}

#ifdef GLES2
	glGenBuffers(1,&geo->vbo_id);
#endif

	return geo;

}

void Geosphere::UpdateTerrain(){

#ifndef GLES2
	glBindBuffer(GL_ARRAY_BUFFER,0);

	RecreateGeoROAM();

	glDisable(GL_ALPHA_TEST);
#else
	RecreateGeoROAM();
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
			//glDisableClientState(GL_NORMAL_ARRAY);
			glDisable(GL_LIGHT0); // KippyKip - properly disabled lights, before only normal maps were disabled
			glDisable(GL_LIGHT1);
			glDisable(GL_LIGHT2);
			glDisable(GL_LIGHT3);
			glDisable(GL_LIGHT4);
			glDisable(GL_LIGHT5);
			glDisable(GL_LIGHT6);
			glDisable(GL_LIGHT7);
		}
		ambient_red  =1.0;
		ambient_green=1.0;
		ambient_blue =1.0;
	}else{
		if(Global::fx1!=false){
			Global::fx1=false;
			//glEnableClientState(GL_NORMAL_ARRAY);
			// Kippykip - re-enable and update all lights again
			vector<Light*>::iterator light_it;
			for(light_it=Light::light_list.begin();light_it!=Light::light_list.end();++light_it){
				Light &light=**light_it;
				//light.Update(); // Do hidden code manually so it doesn't break light rotations
				if(light.hide==true){
					glDisable(Light::gl_light[light.light_no-1]);
				}else{
					glEnable(Light::gl_light[light.light_no-1]);
				}
			}
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

	int DisableCubeSphereMapping=0;
#ifndef GLES2
	int tex_count=0;
#endif

	if(ShaderMat!=NULL){
		ShaderMat->TurnOn(mat, 0, this,&brush);
	}
	else
	{

#ifndef GLES2
		tex_count=brush.no_texs;
#endif

		for(int ix=0;ix<tex_count;ix++){

			if(brush.tex[ix]){

				// Main brush texture takes precedent over surface brush texture
				unsigned int texture=0;
				int tex_flags=0,tex_blend=0,tex_coords=0;
				float tex_u_scale=1.0,tex_v_scale=1.0,tex_u_pos=0.0,tex_v_pos=0.0,tex_ang=0.0;
				int tex_cube_mode=0;


				texture=brush.cache_frame[ix];
				tex_flags=brush.tex[ix]->flags;
				tex_blend=brush.tex[ix]->blend;
				tex_coords=brush.tex[ix]->coords;
				tex_u_scale=brush.tex[ix]->u_scale;
				tex_v_scale=brush.tex[ix]->v_scale;
				tex_u_pos=brush.tex[ix]->u_pos;
				tex_v_pos=brush.tex[ix]->v_pos;
				tex_ang=brush.tex[ix]->angle;
				tex_cube_mode=brush.tex[ix]->cube_mode;
				//frame=brush.tex_frame;

#ifndef GLES2
				glActiveTexture(GL_TEXTURE0+ix);
				glClientActiveTexture(GL_TEXTURE0+ix);
				glEnable(GL_TEXTURE_2D);
#else
				if(tex_flags&128){
					glActiveTexture(GL_TEXTURE0+ix+8);
				}else{
					glActiveTexture(GL_TEXTURE0+ix);
				}
#endif

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
				if(tex_coords==0){
					glTexCoordPointer(2,GL_FLOAT,8*sizeof(float),&vertices[6]);
				}else{
					glTexCoordPointer(2,GL_FLOAT,0,&tex_coords1[0]);
				}

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
	
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
				}

				tblendflags[ix][0]=tex_blend;
				tblendflags[ix][1]=tex_flags&(4|128);
				tcoords[ix]=0;
#endif


			}

		}

#ifndef GLES2
	}

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
	}
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

void Geosphere::RecreateGeoROAM(){

	/*xcf = eyepoint->EntityX();
	ycf = eyepoint->EntityY();
	zcf = -eyepoint->EntityZ();*/

	TFormPoint(eyepoint->EntityX(true), eyepoint->EntityY(true), eyepoint->EntityZ(true), 0, this);
	xcf = tformed_x;
	ycf = tformed_y;
	zcf = -tformed_z;

	//int i;

	float h1= (HeightMap[(int)hsize*(int)size+ (int)hsize]*vsize+1)*size;
	float h2= (HeightMap[(int) size*(int)size+ (int)hsize]*vsize+1)*size;
	float h3= (HeightMap[(int)hsize*(int)size+ (int) size]*vsize+1)*size;
	float h4=-(HeightMap[(int)    0*(int)size+ (int)hsize]*vsize+1)*size;
	float h5=-(HeightMap[(int)hsize*(int)size]*vsize+1)*size;
	float h6=-(HeightMap[0]*vsize+1)*size;


	float v[9][5]={
	{ 0,  h1,  0, hsize, hsize},

	{ h2,  0,  0, size, hsize},
	{ 0,  0,  h3, hsize, size},
	{ h4,  0,  0, 0, hsize},
	{ 0,  0,  h5, hsize, 1},

	{ 0,  h6,  0, size, size},
	{ 0,  h6,  0, 0, size},
	{ 0,  h6,  0, 0, 1},
	{ 0,  h6,  0, size, 1}};



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

	geosub( 0, v[0], v[1], v[2]);
	geosub( 0, v[0], v[2], v[3]);
	geosub( 0, v[0], v[3], v[4]);
	geosub( 0, v[0], v[4], v[1]);

	geosub( 0, v[2], v[1], v[5]);
	geosub( 0, v[3], v[2], v[6]);
	geosub( 0, v[4], v[3], v[7]);
	geosub( 0, v[1], v[4], v[8]);




}

void Geosphere::geosub(int l, float v2[], float v1[], float v0[]){

	float vc[3][5];			/* New (split) vertices */
	float ds;			/* maximum midpoint displacement */
	float dx,dy,dz;			/* difference vector */
	float rd;			/* squared sphere bound radius */
	float nx[3],ny[3], nz[3];
	float rc, rc0, rc1, rc2;	/* squared distance from vc To camera position */

	if (l < ROAM_LMAX) {
		ds = level2dzsize[l];

		/* compute radius of diamond bounding sphere (squared) */
		float x,y,z;
		x = (v0[0] + v1[0] + v2[0]) / 3;
		y = (v0[1] + v1[1] + v2[1]) / 3;
		z = (v0[2] + v1[2] + v2[2]) / 3;
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


		float vcx=x;
		float vcy=y;
		float vcz=-z;
		mat.TransformVec(vcx, vcy, vcz, 1);

		for (int i = 0 ;i<= 5; i++){
			float d = eyepoint->frustum[i][0] * vcx + eyepoint->frustum[i][1] * vcy - eyepoint->frustum[i][2] * vcz + eyepoint->frustum[i][3];
			if (d <= -rd) return;//{ds=ds/10; break;}
			//m = m << 1;
		}

		/* compute distance from split point To camera (squared) */
		/*dx = x - xcf;
		dy = y - ycf;
		dz = z - zcf;
		rc = dx*dx+dy*dy+dz*dz;*/
		nx[0]=(v0[0]+v1[0])/2;
		ny[0]=(v0[1]+v1[1])/2;
		nz[0]=(v0[2]+v1[2])/2;

		dx = nx[0] - xcf;
		dy = ny[0] - ycf;
		dz = nz[0] - zcf;
		rc0 = dx*dx+dy*dy+dz*dz;
		rc=rc0;

		nx[1]=(v1[0]+v2[0])/2;
		ny[1]=(v1[1]+v2[1])/2;
		nz[1]=(v1[2]+v2[2])/2;

		dx = nx[1] - xcf;
		dy = ny[1] - ycf;
		dz = nz[1] - zcf;
		rc1 = dx*dx+dy*dy+dz*dz;
		if (rc>rc1) {rc=rc1;}

		nx[2]=(v2[0]+v0[0])/2;
		ny[2]=(v2[1]+v0[1])/2;
		nz[2]=(v2[2]+v0[2])/2;

		dx = nx[2] - xcf;
		dy = ny[2] - ycf;
		dz = nz[2] - zcf;
		rc2 = dx*dx+dy*dy+dz*dz;
		if (rc>rc2) {rc=rc2;}



		/* If not error large on screen, recursively split */
		if (ds > rc) {/*<---------terrain detail here*/

			float d,h;
			/*float nx, ny, nz, d, h, ts;

			ts=size/(1<<l)*4.8;//size*size/l/l*11.973;
			ts*=ts;*/

			l++;

			/*nx=(v0[0]+v1[0])/2;
			ny=(v0[1]+v1[1])/2;
			nz=(v0[2]+v1[2])/2;

			dx = nx - xcf;
			dy = ny - ycf;
			dz = nz - zcf;
			rc = dx*dx+dy*dy+dz*dz+ts;*/


			vc[0][3]=(v0[3]+v1[3])/2; vc[0][4]=(v0[4]+v1[4])/2;
			h=HeightMap[(int)vc[0][3]*(int)size+ (int)vc[0][4]]*vsize+1;
			if (ds > rc0) {
				d=sqrt(nx[0]*nx[0]+ny[0]*ny[0]+nz[0]*nz[0])/(size)/h;
			}else{
				d=1;
			}
			vc[0][0]=nx[0]/d; vc[0][1]=ny[0]/d; vc[0][2]=nz[0]/d; 


			/*nx=(v1[0]+v2[0])/2;
			ny=(v1[1]+v2[1])/2;
			nz=(v1[2]+v2[2])/2;

			dx = nx - xcf;
			dy = ny - ycf;
			dz = nz - zcf;
			rc = dx*dx+dy*dy+dz*dz+ts;*/

			vc[1][3]=(v1[3]+v2[3])/2; vc[1][4]=(v1[4]+v2[4])/2;
			h=HeightMap[(int)vc[1][3]*(int)size+ (int)vc[1][4]]*vsize+1;
			if (ds > rc1) {
				d=sqrt(nx[1]*nx[1]+ny[1]*ny[1]+nz[1]*nz[1])/(size)/h;
			}else{
				d=1;
			}
			vc[1][0]=nx[1]/d; vc[1][1]=ny[1]/d; vc[1][2]=nz[1]/d; 


			/*nx=(v2[0]+v0[0])/2;
			ny=(v2[1]+v0[1])/2;
			nz=(v2[2]+v0[2])/2;

			dx = nx - xcf;
			dy = ny - ycf;
			dz = nz - zcf;
			rc = dx*dx+dy*dy+dz*dz+ts;*/

			vc[2][3]=(v2[3]+v0[3])/2; vc[2][4]=(v2[4]+v0[4])/2;
			h=HeightMap[(int)vc[2][3]*(int)size+ (int)vc[2][4]]*vsize+1;
			if (ds > rc2) {
				d=sqrt(nx[2]*nx[2]+ny[2]*ny[2]+nz[2]*nz[2])/(size)/h;
			}else{
				d=1;
			}
			vc[2][0]=nx[2]/d; vc[2][1]=ny[2]/d; vc[2][2]=nz[2]/d; 

			geosub(l, v0, vc[2], vc[0]);
			geosub(l, v1, vc[0], vc[1]);
			geosub(l, v2, vc[1], vc[2]);
			geosub(l, vc[2], vc[1], vc[0]);

			return;
		}

	 }

	float *n0, *n1, *n2;

	n0=&NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])];
	n1=&NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])];
	n2=&NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])];

	vertices.push_back(v0[0]); // v
	vertices.push_back(v0[1]); 
	vertices.push_back(v0[2]);
	vertices.push_back(n0[0]); // n
	vertices.push_back(n0[1]); 
	vertices.push_back(n0[2]);
	vertices.push_back(n0[3]); // t
	vertices.push_back(n0[4]);


	vertices.push_back(v1[0]); // v
	vertices.push_back(v1[1]); 
	vertices.push_back(v1[2]);
	vertices.push_back(n1[0]); // n
	vertices.push_back(n1[1]); 
	vertices.push_back(n1[2]);
	vertices.push_back(n1[3]); // t
	vertices.push_back(n1[4]);


	vertices.push_back(v2[0]); // v
	vertices.push_back(v2[1]); 
	vertices.push_back(v2[2]);
	vertices.push_back(n2[0]); // n
	vertices.push_back(n2[1]); 
	vertices.push_back(n2[2]);
	vertices.push_back(n2[3]); // t
	vertices.push_back(n2[4]);

	triangleindex++;


}


void Geosphere::TOASTsub(int l, float v2[], float v1[], float v0[]){

	float vc[3][5];	/* New (split) vertices */

	if (l > 0) {
		l--;
		float nx, ny, nz, d;

		nx=(v0[0]+v1[0])/2;
		ny=(v0[1]+v1[1])/2;
		nz=(v0[2]+v1[2])/2;

		vc[0][3]=(v0[3]+v1[3])/2; vc[0][4]=(v0[4]+v1[4])/2;
		d=sqrt(nx*nx+ny*ny+nz*nz);
		vc[0][0]=nx/d; vc[0][1]=ny/d; vc[0][2]=nz/d; 


		nx=(v1[0]+v2[0])/2;
		ny=(v1[1]+v2[1])/2;
		nz=(v1[2]+v2[2])/2;

		vc[1][3]=(v1[3]+v2[3])/2; vc[1][4]=(v1[4]+v2[4])/2;
		d=sqrt(nx*nx+ny*ny+nz*nz);
		vc[1][0]=nx/d; vc[1][1]=ny/d; vc[1][2]=nz/d; 


		nx=(v2[0]+v0[0])/2;
		ny=(v2[1]+v0[1])/2;
		nz=(v2[2]+v0[2])/2;

		vc[2][3]=(v2[3]+v0[3])/2; vc[2][4]=(v2[4]+v0[4])/2;
		d=sqrt(nx*nx+ny*ny+nz*nz);
		vc[2][0]=nx/d; vc[2][1]=ny/d; vc[2][2]=nz/d; 

		TOASTsub(l, v0, vc[2], vc[0]);
		TOASTsub(l, v1, vc[0], vc[1]);
		TOASTsub(l, v2, vc[1], vc[2]);
		TOASTsub(l, vc[2], vc[1], vc[0]);

		return;
	}

	/*float ax,ay,az,bx,by,bz;
	float nx,ny,nz,ns;
	float h0,h1,h2;

	h0=HeightMap[(int)v0[3]*(int)size+ (int)v0[4]]*vsize+1;
	h1=HeightMap[(int)v1[3]*(int)size+ (int)v1[4]]*vsize+1;
	h2=HeightMap[(int)v2[3]*(int)size+ (int)v2[4]]*vsize+1;

	ax = h1*v1[0]-h0*v0[0];
	ay = h1*v1[1]-h0*v0[1];
	az = h1*v1[2]-h0*v0[2];
	bx = h2*v2[0]-h1*v1[0];
	by = h2*v2[1]-h1*v1[1];
	bz = h2*v2[2]-h1*v1[2];
	nx = ( ay * bz ) - ( az * by );
	ny = ( az * bx ) - ( ax * bz );
	nz = ( ax * by ) - ( ay * bx );
	ns = sqrt( nx * nx + ny*ny + nz*nz );
	if (ns != 0) ns = 1;
	nx /= ns;
	ny /= ns;
	nz /= ns;
	NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])]=nx;
	NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])+1]=ny;
	NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])+2]=nz;

	NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])]=nx;
	NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])+1]=ny;
	NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])+2]=nz;

	NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])]=nx;
	NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])+1]=ny;
	NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])+2]=nz;*/


	float u,v;
	u=0.5f * (-1.0 +atan2( v0[2] , -v0[0] ) * (1 / M_PI ));
	v=acos( v0[1] ) * ( 1 / M_PI );
	NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])+3]=u*size;
	NormalsMap[5*(int)((int)v0[3]*(int)size+ v0[4])+4]=v*size;

	u=0.5f * (-1.0 +atan2( v1[2] , -v1[0] ) * (1 / M_PI ));
	v=acos( v1[1] ) * ( 1 / M_PI );
	NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])+3]=u*size;
	NormalsMap[5*(int)((int)v1[3]*(int)size+ v1[4])+4]=v*size;

	u=0.5f * (-1.0 +atan2( v2[2] , -v2[0] ) * (1 / M_PI ));
	v=acos( v2[1] ) * ( 1 / M_PI );
	NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])+3]=u*size;
	NormalsMap[5*(int)((int)v2[3]*(int)size+ v2[4])+4]=v*size;

}



void Geosphere::ModifyGeosphere (int x, int y, float new_height){
	/*int width=size*2;		//Most accurate approach: it wastes a lot of memory
	if (EqToToast==0){	//First time: must create a look-up map to convert equirectangular coords to TOAST coords
		EqToToast=new int[(int)(size+1)*width];
		for (int y=0;y<size;y++){
			for (int x=0;x<size;x++){
				int x1=-NormalsMap[5*(x*(int)size+ y)+3]*2;
				int y1=NormalsMap[5*(x*(int)size+ y)+4];

				//geo->HeightMap[x*(int)geo->size+y]=((float)*(buffer+x1+y1*width))/255.0;
				if (x1+y1*width<0) {
					x1=0; y1=0;
				}
				EqToToast[x1+y1*width]=x*(int)size+y;
			}
		}
	}

	HeightMap[EqToToast[x+y*width]]=new_height;*/


	//Less accurate approach: some lines might be distorted, but for little changes on a map should be good enough

	float r=sqrt((x % (int)hsize)*(x % (int)hsize)+(hsize-(x % (int)hsize))*(hsize-(x % (int)hsize)))/hsize;


	if (x<hsize){
		if (y<=hsize){

			r=(r*(hsize-y)+1*y)/hsize;
			y=y/r;

			x=x* y/hsize;
			y=y-x;
		}else{
			r=(r*(y-hsize)+1*(2*hsize-y))/hsize;
			y=2*hsize-(2*hsize-y)/r;

			x=y-(x*(y-2*hsize)/hsize)-hsize;
			y=y-x;
		}
	}else if (x<hsize*2){
		x=hsize*2-x;
		if (y<=hsize){

			r=(r*(hsize-y)+1*y)/hsize;
			y=y/r;

			x=x* y/hsize;
			y=x-y;
		}else{

			r=(r*(y-hsize)+1*(2*hsize-y))/hsize;
			y=2*hsize-(2*hsize-y)/r;


			x=y-(x*(y-2*hsize)/hsize)-hsize;
			y=x-y;
		}
	}else if (x<hsize*3){
		x=x-hsize*2;
		if (y<=hsize){

			r=(r*(hsize-y)+1*y)/hsize;
			y=y/r;

			x=-x* y/hsize;
			y=-y-x;
		}else{
			r=(r*(y-hsize)+1*(2*hsize-y))/hsize;
			y=2*hsize-(2*hsize-y)/r;

			x=(x*(y-2*hsize)/hsize)+hsize-y;
			y=-y-x;
		}
	}else{
		x=hsize*4-x;
		if (y<=hsize) {

			r=(r*(hsize-y)+1*y)/hsize;
			y=y/r;

			x=-x* y/hsize;
			y=x+y;
		}else{
			r=(r*(y-hsize)+1*(2*hsize-y))/hsize;
			y=2*hsize-(2*hsize-y)/r;

			x=(x*(y-2*hsize)/hsize)+hsize-y;
			y=x+y;
		}
	
	}
	x+=hsize;
	y+=hsize;
	HeightMap[x+y*(int)size]=new_height;
}

void Geosphere::EquirectangularToTOAST (){
	/*for (int x=0; x<size*2; x++){
		for (int y=0; y<size; y++){
			int x1=x, y1=y;
			EquirectangularToTOAST (x1, y1);

			NormalsMap[5*(x1*(int)size+ y1)+3]=x/2;
			NormalsMap[5*(x1*(int)size+ y1)+4]=y;
		}
	}*/
	float v[9][5]={
	{ 0,  1,  0, hsize, hsize},
	{ 1,  0,  0, size, hsize},
	{ 0,  0,  1, hsize, size},
	{-1,  0,  0, 0, hsize},
	{ 0,  0, -1, hsize, 1},

	{ 0, -1,  0, size, size},
	{ 0, -1,  0, 0, size},
	{ 0, -1,  0, 0, 1},
	{ 0, -1,  0, size, 1}};

	int l=(int)(log(hsize)/log(2));

	TOASTsub( l, v[0], v[1], v[2]);
	TOASTsub( l, v[0], v[2], v[3]);
	TOASTsub( l, v[0], v[3], v[4]);
	TOASTsub( l, v[0], v[4], v[1]);

	TOASTsub( l, v[2], v[1], v[5]);
	TOASTsub( l, v[3], v[2], v[6]);
	TOASTsub( l, v[4], v[3], v[7]);
	TOASTsub( l, v[1], v[4], v[8]);

}

void Geosphere::UpdateNormals (int preserve){
		for (int y=0;y<size;y++){
			for (int x=0;x<size;x++){
				float theta=-M_PI*(NormalsMap[5*(x*(int)size+ y)+3]-hsize)/size*2;
				float phi=M_PI*(NormalsMap[5*(x*(int)size+ y)+4])/size;
				if (preserve==0){
					NormalsMap[5*(x*(int)size+ y)]=-sin(phi) * cos(theta);
					NormalsMap[5*(x*(int)size+ y)+1]=cos(phi);
					NormalsMap[5*(x*(int)size+ y)+2]=-sin(phi) * sin(theta);
				}else{
					float a,b,c, d,e,f;
					a=-sin(phi) * cos(theta);
					b=cos(phi);
					c=-sin(phi) * sin(theta);

					d=NormalsMap[5*(x*(int)size+ y)];
					e=NormalsMap[5*(x*(int)size+ y)+1];
					f=NormalsMap[5*(x*(int)size+ y)+2];

					NormalsMap[5*(x*(int)size+ y)]=a*e+c*d;
					NormalsMap[5*(x*(int)size+ y)+1]=b*e+f;
					NormalsMap[5*(x*(int)size+ y)+2]=c*e-a*d;

				}
			}
		}
}

Geosphere* Geosphere::LoadGeosphere(string filename,Entity* parent_ent){
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

	Geosphere* geo;

	unsigned char* pixels;

	int width,height;

	pixels=stbi_load(filename.c_str(),&width,&height,0,1);   //Memory leak fixed by D.J.Peters

	short* tmpNormals=0;		//An equirectangular normal maps

	// all OK ?
	if (pixels!=NULL) {
		// work with a copy of the pixel pointer
		unsigned char* buffer=pixels;

		tmpNormals=new short[(width+1)*(height+1)*2];	// Build an equirectangular normals map, that will be used to build
								// the final normals map in TOAST projection.
		for (int x=1;x<=width;x++){
			for (int y=1;y<=height-2;y++){
				tmpNormals[2*(y*(int)width+x)]=((short)*(buffer+(x-1)+y*width)) - ((short)*(buffer+(x+1)+y*width));
				tmpNormals[2*(y*(int)width+x)+1]=((short)*(buffer+x+(y-1)*width)) - ((short)*(buffer+x+(y+1)*width));
			}
		}


		geo=Geosphere::CreateGeosphere(width, parent_ent);

		for (int y=0;y<geo->size;y++){
			for (int x=0;x<=geo->size;x++){
				int x1=geo->NormalsMap[5*(x*(int)geo->size+ y)+3]*2;
				int y1=geo->NormalsMap[5*(x*(int)geo->size+ y)+4];

				if (x1+y1*width<0) {
					x1=0; y1=0;
				}

				geo->HeightMap[x*(int)geo->size+y]=((float)*(buffer+x1+y1*width))/255.0;
				if (x<geo->size) {
					geo->NormalsMap[5*(x*(int)geo->size+ y)]=(float)tmpNormals[2*(y1*(int)width+x1)];
					geo->NormalsMap[5*(x*(int)geo->size+ y)+1]=256;
					geo->NormalsMap[5*(x*(int)geo->size+ y)+2]=(float)tmpNormals[2*(y1*(int)width+x1)+1];
				}
			}
		}
		stbi_image_free(pixels);
		pixels=NULL;
	} else {
		// create a dummy terrain only as a dirty fallback
		height =128;
		geo=Geosphere::CreateGeosphere(256, parent_ent);
		//geo->HeightMap=new float[(width+1)*(width+1)];
		for (int x=0;x<=geo->size;x++){
			for (int y=0;y<=geo->size;y++){
				geo->HeightMap[x*(int)geo->size+y]=0.0f;
			}
		}
	}


	geo->UpdateNormals(true);
	delete tmpNormals;

	return geo;
}

void Geosphere::TreeCheck(CollisionInfo* ci){
	Ray=ci->coll_line;
	radius=ci->radius;

	TFormPoint(Ray.o.x, Ray.o.y, Ray.o.z, 0, this);
	xcf = tformed_x;
	ycf = tformed_y;
	zcf = -tformed_z;


	//int i;
	float h1= (HeightMap[(int)hsize*(int)size+ (int)hsize]*vsize+1)*size;
	float h2= (HeightMap[(int) size*(int)size+ (int)hsize]*vsize+1)*size;
	float h3= (HeightMap[(int)hsize*(int)size+ (int) size]*vsize+1)*size;
	float h4=-(HeightMap[(int)    0*(int)size+ (int)hsize]*vsize+1)*size;
	float h5=-(HeightMap[(int)hsize*(int)size]*vsize+1)*size;
	float h6=-(HeightMap[0]*vsize+1)*size;


	float v[9][5]={
	{ 0,  h1,  0, hsize, hsize},

	{ h2,  0,  0, size, hsize},
	{ 0,  0,  h3, hsize, size},
	{ h4,  0,  0, 0, hsize},
	{ 0,  0,  h5, hsize, 1},

	{ 0,  h6,  0, size, size},
	{ 0,  h6,  0, 0, size},
	{ 0,  h6,  0, 0, 1},
	{ 0,  h6,  0, size, 1}};


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
	c_col_tree_geosub( 0, v[0], v[1], v[2]);
	c_col_tree_geosub( 0, v[0], v[2], v[3]);
	c_col_tree_geosub( 0, v[0], v[3], v[4]);
	c_col_tree_geosub( 0, v[0], v[4], v[1]);

	c_col_tree_geosub( 0, v[2], v[1], v[5]);
	c_col_tree_geosub( 0, v[3], v[2], v[6]);
	c_col_tree_geosub( 0, v[4], v[3], v[7]);
	c_col_tree_geosub( 0, v[1], v[4], v[8]);

	c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);



}

void Geosphere::c_col_tree_geosub(int l, float v2[], float v1[], float v0[]){

	float vc[3][5];	/* New (split) vertices */
	float ds;	/* maximum midpoint displacement */
	float dx,dy,dz;	/* difference vector */
	float rd;	/* squared sphere bound radius */
	float rc;	/* squared distance from vc To camera position */

	if (l < ROAM_LMAX) {
		ds = level2dzsize[l];

		/* compute radius of diamond bounding sphere (squared) */
		float x,y,z;
		x = (v0[0] + v1[0] + v2[0]) / 3;
		y = (v0[1] + v1[1] + v2[1]) / 3;
		z = (v0[2] + v1[2] + v2[2]) / 3;
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


		float vcx=x;
		float vcy=y;
		float vcz=-z;
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
		dx = x - xcf;
		dy = y - ycf;
		dz = z - zcf;
		rc = dx*dx+dy*dy+dz*dz;

		/* If not error large on screen, recursively split */
		if (ds > rc) {/*<---------terrain detail here*/
			l++;
			float nx, ny, nz, d, h;

			nx=(v0[0]+v1[0])/2;
			ny=(v0[1]+v1[1])/2;
			nz=(v0[2]+v1[2])/2;

			vc[0][3]=(v0[3]+v1[3])/2; vc[0][4]=(v0[4]+v1[4])/2;
			h=HeightMap[(int)vc[0][3]*(int)size+ (int)vc[0][4]]*vsize+1;
			d=sqrt(nx*nx+ny*ny+nz*nz)/(size)/h;

			vc[0][0]=nx/d; vc[0][1]=ny/d; vc[0][2]=nz/d; 


			nx=(v1[0]+v2[0])/2;
			ny=(v1[1]+v2[1])/2;
			nz=(v1[2]+v2[2])/2;

			vc[1][3]=(v1[3]+v2[3])/2; vc[1][4]=(v1[4]+v2[4])/2;
			h=HeightMap[(int)vc[1][3]*(int)size+ (int)vc[1][4]]*vsize+1;
			d=sqrt(nx*nx+ny*ny+nz*nz)/(size)/h;

			vc[1][0]=nx/d; vc[1][1]=ny/d; vc[1][2]=nz/d; 


			nx=(v2[0]+v0[0])/2;
			ny=(v2[1]+v0[1])/2;
			nz=(v2[2]+v0[2])/2;
			vc[2][3]=(v2[3]+v0[3])/2; vc[2][4]=(v2[4]+v0[4])/2;
			h=HeightMap[(int)vc[2][3]*(int)size+ (int)vc[2][4]]*vsize+1;
			d=sqrt(nx*nx+ny*ny+nz*nz)/(size)/h;

			vc[2][0]=nx/d; vc[2][1]=ny/d; vc[2][2]=nz/d; 

			c_col_tree_geosub(l, v0, vc[2], vc[0]);
			c_col_tree_geosub(l, v1, vc[0], vc[1]);
			c_col_tree_geosub(l, v2, vc[1], vc[2]);
			c_col_tree_geosub(l, vc[2], vc[1], vc[0]);

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

void Geosphere::FreeEntity(){

	delete[] HeightMap;
	delete[] NormalsMap;		
	//delete[] EqToToast;		

	terrain_list.remove(this);
	delete c_col_tree;

	Entity::FreeEntity();

	delete this;

	return;

}

