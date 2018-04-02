
#include "glew_glee.h" // glee or glew

#include "stencil.h"
#include "mesh.h"
#include "global.h"

int Stencil::midStencilVal;

Stencil* Stencil::CreateStencil(){

	int StencilBits;
	glGetIntegerv(GL_STENCIL_BITS, &StencilBits);
	midStencilVal = (StencilBits - 1)^2;

	Stencil* stencil=new Stencil;
	return stencil;
}

void Stencil::StencilMesh(Mesh* mesh, int mode){
	if (mesh->parent != 0) {
		mesh->parent->child_list.remove(mesh);
	}else{
		Global::root_ent->child_list.remove(mesh);
	}
	StencilMesh_list.push_back(mesh);
	StencilMode_list.push_back(mode);

}

void Stencil::StencilClsColor(float r,float g,float b){

	cls_r=r/255.0;
	cls_g=g/255.0;
	cls_b=b/255.0;

}

void Stencil::StencilClsMode(int color,int zbuffer){

	cls_color=color;
	cls_zbuffer=zbuffer;

}

void Stencil::StencilAlpha(float a){
	alpha=a;
}

void Stencil::StencilMode(int m, int o){
	stencil_mode=m;
	stencil_operator=o;
}


void Stencil::UseStencil(){
	//glEnable(GL_POLYGON_OFFSET_FILL);
	//glPolygonOffset(0.0, 4.0);

	glClearStencil(midStencilVal);
	glClear(GL_STENCIL_BUFFER_BIT);
	//glDepthMask(GL_FALSE);
	glColorMask( GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE );

	glEnable(GL_STENCIL_TEST);
	glStencilFunc(GL_ALWAYS, 1, 1);                // Always Passes, 1 Bit Plane, 1 As Mask
	glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);              // We Set The Stencil Buffer To 1 Where We Draw Any Polygon

	//glDisable(GL_DEPTH_TEST);
	list<Mesh*>::iterator it;
	list<int>::iterator it2;
	it2=StencilMode_list.begin();

	for(it=StencilMesh_list.begin();it!=StencilMesh_list.end();it++){
		Mesh* mesh=*it;
		int mode=*it2;
		switch(mode){
		case 1:
			glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
			break;
		case -1:
			glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
			break;
		case 2:
			glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
			glCullFace(GL_FRONT);
			mesh->UpdateShadow();
			glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
			glCullFace(GL_BACK);
			break;
		case -2:
			glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
			glCullFace(GL_FRONT);
			mesh->UpdateShadow();
			glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
			glCullFace(GL_BACK);
			break;

		}

		mesh->UpdateShadow();
		it2++;
	}
	//glEnable(GL_DEPTH_TEST);
	//glClear(GL_DEPTH_BUFFER_BIT);

	if (cls_color!=0) {
		glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	}else{
		glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_TRUE);
	}

	switch (stencil_operator){
	case 0:
		glStencilFunc(GL_NOTEQUAL, stencil_mode + midStencilVal, 0xffffffff);  // We Draw Only Where The Stencil Is Not Equal to stencil_mode
		break;
	case 1:
		glStencilFunc(GL_EQUAL, stencil_mode + midStencilVal, 0xffffffff);     // We Draw Only Where The Stencil Is Equal to stencil_mode
		break;
	case 2:
		glStencilFunc(GL_LEQUAL, stencil_mode + midStencilVal, 0xffffffff);    // We Draw Only Where The Stencil Is Smaller or Equal to stencil_mode
		break;
	case 3:
		glStencilFunc(GL_GEQUAL, stencil_mode + midStencilVal, 0xffffffff);    // We Draw Only Where The Stencil Is Greater or Equal to stencil_mode
		break;
	}
	glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);                 // Don't Change The Stencil Buffer

	//glDisable(GL_POLYGON_OFFSET_FILL);

	glPushMatrix();
		glLoadIdentity();
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glLoadIdentity();
		glOrtho(0 , 1 , 1 , 0 , 0 , 1);

		//float no_mat[]={0.0,0.0};

		float mat_ambient[]={cls_r,cls_g,cls_b,alpha};
		float mat_diffuse[]={0,0,0,0.5};
		float mat_specular[]={0,0,0,0.5};
		float mat_shininess[]={0.0}; // upto 128

		glMaterialfv(GL_FRONT,GL_AMBIENT,mat_ambient);
		glMaterialfv(GL_FRONT,GL_DIFFUSE,mat_diffuse);
		glMaterialfv(GL_FRONT,GL_SPECULAR,mat_specular);
		glMaterialfv(GL_FRONT,GL_SHININESS,mat_shininess);

		if (alpha<1){
			glEnable(GL_BLEND);
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
		}

		if (cls_zbuffer!=0){
			glDepthRange(1,1);
			glDepthFunc(GL_ALWAYS);
			glColor4f(0.0, 0.0, 0.0, 1.0);
		}else{
			glDisable(GL_DEPTH_TEST);
		}

		/*glBegin(GL_QUADS);
			glVertex2i(0, 0);
			glVertex2i(0, 1);
			glVertex2i(1, 1);
			glVertex2i(1, 0);
		glEnd();*/
		if(Global::fx1!=true){
			Global::fx1=true;
			glDisableClientState(GL_NORMAL_ARRAY);
		}
		if(Global::fx2!=false){
			Global::fx2=false;
			glDisableClientState(GL_COLOR_ARRAY);
		}

		GLfloat q3[] = {0,0,0,1,1,1,1,0};
	 
		glVertexPointer(2, GL_FLOAT, 0, q3);
		glDrawArrays(GL_TRIANGLE_FAN,0,4);


		if (cls_zbuffer!=0){
			glDepthRange(0,1);
			glDepthFunc(GL_LEQUAL);
		}else{
			glEnable(GL_DEPTH_TEST);
		}

		glPopMatrix();
		// NOTE: is it the projektion matrix ?
		glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
	if (cls_color==0) {
		glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	}




}

