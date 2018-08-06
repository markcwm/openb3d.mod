/*
 *  voxterrain.cpp
 *  openb3d
 *
 *
 */

#include "glew_glee.h" // glee or glew

#include "global.h"
#include "entity.h"
#include "camera.h"
#include "brush.h"
#include "voxterrain.h"
#include "pick.h"


#include "stb_image.h"
#include "string_helper.h"
#include "file.h"
#include "tree.h"

//static int _terrSize;

static vector<float> vertices;


VoxelTerrain* VoxelTerrain::CreateVoxelTerrain(int xsize, int ysize, int zsize, Entity* parent_ent){

	VoxelTerrain* terr=new VoxelTerrain;

	terr->ShaderMat=0;

	//terr->brush=new brush;
	mesh_info=C_NewMeshInfo();
	terr->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);
	terr->AddParent(parent_ent);
	terrain_list.push_back(terr);
	if (xsize!=0){
		terr->size=xsize;

		terr->tbuffer=new float**[xsize];

		for (int i=0;i<xsize;i++){
			terr->tbuffer[i]=new float*[ysize];
			for (int i1=0;i1<ysize;i1++){
				terr->tbuffer[i][i1]=new float[zsize];
			}

		}



	}



	return terr;

}

void VoxelTerrain::UpdateTerrain(){

	glBindBuffer(GL_ARRAY_BUFFER,0);

	RecreateOctree();

	glDisable(GL_ALPHA_TEST);

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

	// textures

	int tex_count=0;

	if(ShaderMat!=NULL){
		ShaderMat->TurnOn(mat, 0, &vertices);
	}

	tex_count=brush.no_texs;

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
			glClientActiveTexture(GL_TEXTURE0+ix);

			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D,texture); // call before glTexParameteri

			// masked texture flag
			if(tex_flags&4){
				glEnable(GL_ALPHA_TEST);
			}else{
				glDisable(GL_ALPHA_TEST);
			}

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
			glTexCoordPointer(2,GL_FLOAT,32,&vertices[6]);


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


		}

	}

	// draw tris
	glMatrixMode(GL_MODELVIEW);

	glPushMatrix();
	glMultMatrixf(&mat.grid[0][0]);
	glVertexPointer(3,GL_FLOAT,32,&vertices[0]);
	glNormalPointer(GL_FLOAT,32,&vertices[3]);

	glDrawArrays(GL_TRIANGLES, 0, triangleindex*3);
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
			DisableCubeSphereMapping=0;
		}

	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);


	if (brush.fx&8 && Global::fog_enabled==true){
		glEnable(GL_FOG);
	}

	if(ShaderMat!=NULL){
		ShaderMat->TurnOff();
	}

}

void VoxelTerrain::RecreateOctree(){
	TFormPoint(eyepoint->EntityX(true), eyepoint->EntityY(true), eyepoint->EntityZ(true), 0, this);
	xcf = tformed_x;
	ycf = tformed_y;
	zcf = -tformed_z;

	BuildCubeGrid (Xcf, Ycf, Zcf, eyepoint->range_far,0,0,0,0,0,0,0,0);

}

void VoxelTerrain::MarchingCube(float x, float y, float z, float x1, float y1, float z1, float F[8]){

	float EdgeX[12], EdgeY[12], EdgeZ[12];

	Surface* surf=*surf_list.begin();

	unsigned char cubeIndex=0;
	
	if(F[6] < .5)
		cubeIndex |= 1;
	if(F[7] < .5)
		cubeIndex |= 2;
	if(F[3] < .5)
		cubeIndex |= 4;
	if(F[2] < .5)
		cubeIndex |= 8;
	if(F[4] < .5)
		cubeIndex |= 16;
	if(F[5] < .5)
		cubeIndex |= 32;
	if(F[1] < .5)
		cubeIndex |= 64;
	if(F[0] < .5)
		cubeIndex |= 128;

	//look this value up in the edge table to see which edges to interpolate along
	int usedEdges=edgeTable[cubeIndex];

	//if the cube is entirely within/outside surface, no faces			
	if(usedEdges==0 || usedEdges==255)
		return;

	if(usedEdges & 1){
		float Ratio = ( .5 - F[6] )/( F[7] - F[6] );

		EdgeX[0] = x  + Ratio*(x1 - x );
		EdgeY[0] = y1 + Ratio*(y1 - y1);
		EdgeZ[0] = z1 + Ratio*(z1 - z1);


	}
	if(usedEdges & 2){
		float Ratio = ( .5 - F[7] )/( F[3] - F[7] );

		EdgeX[1] = x1 + Ratio*(x1 - x1);
		EdgeY[1] = y1 + Ratio*(y1 - y1);
		EdgeZ[1] = z1 + Ratio*(z  - z1);

	}
	if(usedEdges & 4){
		float Ratio = ( .5 - F[3] )/( F[2] - F[3] );

		EdgeX[2] = x1 + Ratio*(x  - x1);
		EdgeY[2] = y1 + Ratio*(y1 - y1);
		EdgeZ[2] = z  + Ratio*(z  - z );

	}
	if(usedEdges & 8){
		float Ratio = ( .5 - F[2] )/( F[6] - F[2] );

		EdgeX[3] = x  + Ratio*(x  - x );
		EdgeY[3] = y1 + Ratio*(y1 - y1);
		EdgeZ[3] = z  + Ratio*(z1 - z );

	}


	if(usedEdges & 16){
		float Ratio = ( .5 - F[4] )/( F[5] - F[4] );

		EdgeX[4] = x  + Ratio*(x1 - x );
		EdgeY[4] = y  + Ratio*(y  - y );
		EdgeZ[4] = z1 + Ratio*(z1 - z1);

	}
	if(usedEdges & 32){
		float Ratio = ( .5 - F[5] )/( F[1] - F[5] );

		EdgeX[5] = x1 + Ratio*(x1 - x1);
		EdgeY[5] = y  + Ratio*(y  - y );
		EdgeZ[5] = z1 + Ratio*(z  - z1);

	}
	if(usedEdges & 64){
		float Ratio = ( .5 - F[1] )/( F[0] - F[1] );

		EdgeX[6] = x1 + Ratio*(x  - x1);
		EdgeY[6] = y  + Ratio*(y  - y );
		EdgeZ[6] = z  + Ratio*(z  - z );

	}
	if(usedEdges & 128){
		float Ratio = ( .5 - F[0] )/( F[4] - F[0] );

		EdgeX[7] = x  + Ratio*(x  - x );
		EdgeY[7] = y  + Ratio*(y  - y );
		EdgeZ[7] = z  + Ratio*(z1 - z );
	}


	if(usedEdges & 256){
		float Ratio = ( .5 - F[4] )/( F[6] - F[4] );

		EdgeX[8] = x  + Ratio*(x  - x );
		EdgeY[8] = y  + Ratio*(y1 - y );
		EdgeZ[8] = z1 + Ratio*(z1 - z1);
	}
	if(usedEdges & 512){
		float Ratio = ( .5 - F[5] )/( F[7] - F[5] );

		EdgeX[9] = x1 + Ratio*(x1 - x1);
		EdgeY[9] = y  + Ratio*(y1 - y );
		EdgeZ[9] = z1 + Ratio*(z1 - z1);
	}
	if(usedEdges & 1024){
		float Ratio = ( .5 - F[1] )/( F[3] - F[1] );

		EdgeX[10] = x1 + Ratio*(x1 - x1);
		EdgeY[10] = y  + Ratio*(y1 - y );
		EdgeZ[10] = z  + Ratio*(z  - z );
	}
	if(usedEdges & 2048){
		float Ratio = ( .5 - F[0] )/( F[2] - F[0] );

		EdgeX[11] = x  + Ratio*(x  - x );
		EdgeY[11] = y  + Ratio*(y1 - y );
		EdgeZ[11] = z  + Ratio*(z  - z );
	}

	for(int k=0; triTable[cubeIndex][k]!=-1; k+=3){



		vertices.push_back( EdgeX[triTable[cubeIndex][k+0]]);
		vertices.push_back( EdgeY[triTable[cubeIndex][k+0]]);
		vertices.push_back(-EdgeZ[triTable[cubeIndex][k+0]]);

		vertices.push_back( EdgeX[triTable[cubeIndex][k+1]]);
		vertices.push_back( EdgeY[triTable[cubeIndex][k+1]]);
		vertices.push_back(-EdgeZ[triTable[cubeIndex][k+1]]);

		vertices.push_back( EdgeX[triTable[cubeIndex][k+2]]);
		vertices.push_back( EdgeY[triTable[cubeIndex][k+2]]);
		vertices.push_back(-EdgeZ[triTable[cubeIndex][k+2]]);

		if(brush.fx&4){
			float ax,ay,az,bx,by,bz;
			float nx,ny,nz;
			ax = EdgeX[triTable[cubeIndex][k+1]]-EdgeX[triTable[cubeIndex][k+0]];
			ay = EdgeY[triTable[cubeIndex][k+1]]-EdgeY[triTable[cubeIndex][k+0]];
			az = EdgeZ[triTable[cubeIndex][k+1]]-EdgeZ[triTable[cubeIndex][k+0]];
			bx = EdgeX[triTable[cubeIndex][k+2]]-EdgeX[triTable[cubeIndex][k+1]];
			by = EdgeY[triTable[cubeIndex][k+2]]-EdgeY[triTable[cubeIndex][k+1]];
			bz = EdgeZ[triTable[cubeIndex][k+2]]-EdgeZ[triTable[cubeIndex][k+1]];
			nx = ( ay * bz ) - ( az * by );
			ny = ( az * bx ) - ( ax * bz );
			nz = ( ax * by ) - ( ay * bx );


			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
		}else{

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]]+1,EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]])-ScalarField(EdgeX[triTable[cubeIndex][k+0]]-1,EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]]+1,EdgeZ[triTable[cubeIndex][k+0]])-ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]]-1,EdgeZ[triTable[cubeIndex][k+0]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]-1));

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]]+1,EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]])-ScalarField(EdgeX[triTable[cubeIndex][k+1]]-1,EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]]+1,EdgeZ[triTable[cubeIndex][k+1]])-ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]]-1,EdgeZ[triTable[cubeIndex][k+1]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]-1));

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]]+1,EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]])-ScalarField(EdgeX[triTable[cubeIndex][k+2]]-1,EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]]+1,EdgeZ[triTable[cubeIndex][k+2]])-ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]]-1,EdgeZ[triTable[cubeIndex][k+2]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]-1));
		}





/*surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);*/

		surf->no_verts+=3;

	}





}


float VoxelTerrain::MiddlePoint (float A, float B, float C, float D){

	unsigned char sideIndex=0;
	
	if(A < .5)
		sideIndex |= 1;
	if(B < .5)
		sideIndex |= 2;
	if(C < .5)
		sideIndex |= 4;
	if(D < .5)
		sideIndex |= 8;

	switch (sideIndex){
		case 9:
		case 14:
		case 1:{
			float c1=(.5-A) / (C - A);
			float c2=(.5-A) / (B - A);
			return (.5-A) / (2*(c1*c2) / (c1+c2))+A;
			}
		case 2:
		case 13:
		case 6:{
			float c1=(.5-B) / (A - B);
			float c2=(.5-B) / (D - B);
			return (.5-B) / (2*(c1*c2) / (c1+c2))+B;
			}
		case 12:
		case 3:{
			float m=(.5-A) / (C - A) + (.5-B) / (D - B);
			if (m<1)
				{
					float m2=(A+B)/2;
					return (.5-m2)/m +m2;
				}else{
					float m2=(C+D)/2;
					return (.5-m2)/(2-m) +m2;
				}
			}
		case 11:
		case 4:{
			float c1=(.5-C) / (A - C);
			float c2=(.5-C) / (D - C);
			return (.5-C) / (2*(c1*c2) / (c1+c2))+C;
			}
		case 10:
		case 5:{
			float m=(.5-A) / (B - A) + (.5-C) / (D - C);
			if (m<1)
				{
					float m2=(A+C)/2;
					return (.5-m2)/m +m2;
				}else{
					float m2=(B+D)/2;
					return (.5-m2)/(2-m) +m2;
				}
			}
		case 7:
		case 8:{
			float c1=(.5-D) / (C - D);
			float c2=(.5-D) / (B - D);
			return (.5-D) / (2*(c1*c2) / (c1+c2))+D;
			}
		default:
			return (A+B+C+D)/4;
	}
	
}


void VoxelTerrain::BuildCubeGrid(float x, float y, float z, float l, float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8){

	float vcx=x;
	float vcy=y;
	float vcz=-z;
	tmat.TransformVec(vcx, vcy, vcz, 1);

	for (int i = 0 ;i<= 5; i++){
		float d = eyepoint->frustum[i][0] * vcx + eyepoint->frustum[i][1] * vcy - eyepoint->frustum[i][2] * vcz + eyepoint->frustum[i][3];
		if (d <= -l*sqrt(6)) return;//{ds=ds/10; break;}
	}


	float dx,dy,dz;	
	float rc;	

	/* compute distance from node To camera (approximated for speed, don't need to be exact) */
	dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);
	rc = dx+dy+dz;

	if (rc*.1<=3*l){

		float F[27];
		F[0] =tbuffer[(int)(x-l)][(int)(y-l)][(int)(z-l)];
		F[1] =tbuffer[(int)(x)][(int)(y-l)][(int)(z-l)];
		F[2] =tbuffer[(int)(x+l)][(int)(y-l)][(int)(z-l)];
		F[3] =tbuffer[(int)(x-l)][(int)(y)][(int)(z-l)];
		F[4] =tbuffer[(int)(x)][(int)(y)][(int)(z-l)];
		F[5] =tbuffer[(int)(x+l)][(int)(y)][(int)(z-l)];
		F[6] =tbuffer[(int)(x-l)][(int)(y+l)][(int)(z-l)];
		F[7] =tbuffer[(int)(x)][(int)(y+l)][(int)(z-l)];
		F[8] =tbuffer[(int)(x+l)][(int)(y+l)][(int)(z-l)];

		F[9] =tbuffer[(int)(x-l)][(int)(y-l)][(int)(z)];
		F[10]=tbuffer[(int)(x)][(int)(y-l)][(int)(z)];
		F[11]=tbuffer[(int)(x+l)][(int)(y-l)][(int)(z)];
		F[12]=tbuffer[(int)(x-l)][(int)(y)][(int)(z)];
		F[13]=tbuffer[(int)(x)][(int)(y)][(int)(z)];
		F[14]=tbuffer[(int)(x+l)][(int)(y)][(int)(z)];
		F[15]=tbuffer[(int)(x-l)][(int)(y+l)][(int)(z)];
		F[16]=tbuffer[(int)(x)][(int)(y+l)][(int)(z)];
		F[17]=tbuffer[(int)(x+l)][(int)(y+l)][(int)(z)];

		F[18]=tbuffer[(int)(x-l)][(int)(y-l)][(int)(z+l)];
		F[19]=tbuffer[(int)(x)][(int)(y-l)][(int)(z+l)];
		F[20]=tbuffer[(int)(x+l)][(int)(y-l)][(int)(z+l)];
		F[21]=tbuffer[(int)(x-l)][(int)(y)][(int)(z+l)];
		F[22]=tbuffer[(int)(x)][(int)(y)][(int)(z+l)];
		F[23]=tbuffer[(int)(x+l)][(int)(y)][(int)(z+l)];
		F[24]=tbuffer[(int)(x-l)][(int)(y+l)][(int)(z+l)];
		F[25]=tbuffer[(int)(x)][(int)(y+l)][(int)(z+l)];
		F[26]=tbuffer[(int)(x+l)][(int)(y+l)][(int)(z+l)];

		//fix cracks

		dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);	//Back
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
			F[3] = (f1+f3)/2;
			F[4] = MiddlePoint(f1,f2,f3,f4);
			F[5] = (f2+f4)/2;
			F[7] = (f3+f4)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);	//Front
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[19] = (f5+f6)/2;
			F[21] = (f5+f7)/2;
			F[22] = MiddlePoint(f5,f6,f7,f8);
			F[23] = (f6+f8)/2;
			F[25] = (f7+f8)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);	//Left
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[3] = (f1+f3)/2;
			F[9] = (f1+f5)/2;
			F[12] = MiddlePoint(f1,f3,f5,f7);
			F[15] = (f3+f7)/2;
			F[21] = (f5+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);	//Right
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[5] = (f2+f4)/2;
			F[11] = (f2+f6)/2;
			F[14] = MiddlePoint(f2,f4,f6,f8);
			F[17] = (f4+f8)/2;
			F[23] = (f6+f8)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);	//Up
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
			F[9] = (f1+f5)/2;
			F[10] = MiddlePoint(f1,f2,f5,f6);
			F[11] = (f2+f6)/2;
			F[19] = (f5+f6)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);	//Down
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[7] = (f3+f4)/2;
			F[15] = (f3+f7)/2;
			F[16] = MiddlePoint(f3,f4,f7,f8);
			F[17] = (f4+f8)/2;
			F[25] = (f7+f8)/2;
		}

		//Edges
		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[7] = (f3+f4)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[19] = (f5+f6)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[25] = (f7+f8)/2;
		}


		dx = abs(x - 2 * l - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[9] = (f1+f5)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[11] = (f2+f6)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[15] = (f3+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[17] = (f4+f8)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[3] = (f1+f3)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[5] = (f2+f4)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[21] = (f5+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[23] = (f6+f8)/2;
		}


		l=l/2;
		level+=1;

		BuildCubeGrid (x-l, y-l, z-l,l,  F[0], F[1], F[3], F[4], F[9], F[10], F[12], F[13]);
		BuildCubeGrid (x+l, y-l, z-l,l,  F[1], F[2], F[4], F[5], F[10], F[11], F[13], F[14]);
		BuildCubeGrid (x-l, y+l, z-l,l,  F[3], F[4], F[6], F[7], F[12], F[13], F[15], F[16]);
		BuildCubeGrid (x+l, y+l, z-l,l,  F[4], F[5], F[7], F[8], F[13], F[14], F[16], F[17]);
		BuildCubeGrid (x-l, y-l, z+l,l,  F[9], F[10], F[12], F[13], F[18], F[19], F[21], F[22]);
		BuildCubeGrid (x+l, y-l, z+l,l,  F[10], F[11], F[13], F[14], F[19], F[20], F[22], F[23]);
		BuildCubeGrid (x-l, y+l, z+l,l,  F[12], F[13], F[15], F[16], F[21], F[22], F[24], F[25]);
		BuildCubeGrid (x+l, y+l, z+l,l,  F[13], F[14], F[16], F[17], F[22], F[23], F[25], F[26]);

		level-=1;
	} else {
		float F[8];
		F[0] =f1;
		F[1] =f2;
		F[2] =f3;
		F[3] =f4;
		F[4] =f5;
		F[5] =f6;
		F[6] =f7;
		F[7] =f8;


		MarchingCube (x-l, y-l, z-l,x+l,y+l,z+l, F);
	}

}

