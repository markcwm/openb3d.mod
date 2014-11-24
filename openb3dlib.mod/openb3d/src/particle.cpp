
#include "glew.h"

/*
#ifdef linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#endif
#ifdef WIN32
#include "GLee.h"
#endif
#ifdef __APPLE__
#include "GLee.h"
#endif
*/

#include "camera.h"
#include "particle.h"
#include "surface.h"

list<ParticleBatch*> ParticleBatch::particle_batch_list;

void ParticleBatch::Render(){
	int depth_mask_disabled=false;

	Surface* surf=*surf_list.begin();

	glDisable(GL_ALPHA_TEST); // ?

	if(Global::fx1!=true){
		Global::fx1=true;
		glDisableClientState(GL_NORMAL_ARRAY);
	}

	if(Global::fx2!=true){
		Global::fx2=true;
		glEnableClientState(GL_COLOR_ARRAY);
		glEnable(GL_COLOR_MATERIAL);
	}

	if(surf->alpha_enable==true){
		if(Global::alpha_enable!=true){
			Global::alpha_enable=true;
			glEnable(GL_BLEND);
		}
		glDepthMask(GL_FALSE); // must be set to false every time, as it's always equal to true before it's called
		depth_mask_disabled=true; // set this to true to we know when to enable depth mask at bottom of function
	}else{
		if(Global::alpha_enable!=false){
			Global::alpha_enable=false;
			glDisable(GL_BLEND);
			//glDepthMask(GL_TRUE); already set to true
		}
	}

	if(brush.blend!=Global::blend_mode){
		Global::blend_mode=brush.blend;

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

	}


	glEnable( GL_POINT_SPRITE ); 

	float quadratic[] = {0,0,1};
	glPointParameterfv( GL_POINT_DISTANCE_ATTENUATION, quadratic );

	glEnable( GL_POINT_SMOOTH );
	glPointSize(brush.tex[0]->width * Global::camera_in_use->vheight*.5);
	glActiveTexture(GL_TEXTURE0);
	glEnable( GL_TEXTURE_2D );

	if(brush.tex[0]->flags&4){
		glEnable(GL_ALPHA_TEST);
	}

	switch(brush.tex[0]->blend){
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


	glTexEnvf(GL_POINT_SPRITE, GL_COORD_REPLACE, GL_TRUE);
	glBindTexture(GL_TEXTURE_2D, brush.tex[0]->texture);




	glColorPointer(4,GL_FLOAT,0,&surf->vert_col[0]);

	glVertexPointer(3,GL_FLOAT,0,&surf->vert_coords[0]);
	glDrawArrays(GL_POINTS,0,surf->no_verts);

	glDisable( GL_POINT_SPRITE ); 
	glDisable( GL_POINT_SMOOTH );

	// enable depth mask again if it was disabled when blend was enabled
	if(depth_mask_disabled==true){
		glDepthMask(GL_TRUE);
		depth_mask_disabled=false; // set to false again for when we repeat loop
	}



	//Trails

	for(int i=0;i<=surf->no_verts-1;i++){
		surf->vert_col[i*4+3]*=.99;
		surf->vert_coords[i*3]+=0;
		surf->vert_coords[i*3+1]+=.1;
		surf->vert_coords[i*3+2]+=0;

	}


int del_trail_points=surf->no_verts/1;//3000;

	if (del_trail_points!=0){
		surf->vert_tex_coords0.clear();
		surf->vert_tex_coords1.clear();
		if (surf->no_verts<=del_trail_points){
			surf->vert_coords.clear();
			surf->vert_col.clear();
			surf->no_verts=0;
		}else{
			surf->vert_coords.erase(surf->vert_coords.begin(),surf->vert_coords.begin()+del_trail_points*3);
			surf->vert_col.erase(surf->vert_col.begin(),surf->vert_col.begin()+del_trail_points*4);
			surf->no_verts-=del_trail_points;
		}
	}

}
