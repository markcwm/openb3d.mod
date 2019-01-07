#ifdef EMSCRIPTEN
#include <GLES2/gl2.h>
#define GLES2
#endif

#include "glew_glee.h" // glee or glew

#include "shadow.h"
#include "light.h"
#include "mesh.h"
#include "global.h"


float ShadowObject::ShadowRed   =0;
float ShadowObject::ShadowGreen =0;
float ShadowObject::ShadowBlue  =0;
float ShadowObject::ShadowAlpha =.5;

list<ShadowObject*> ShadowObject::shadow_list;

float ShadowObject::light_x, ShadowObject::light_y, ShadowObject::light_z;
char ShadowObject::top_caps=true;
float ShadowObject::VolumeLength=1000;
int ShadowObject::parallel;
int ShadowObject::midStencilVal;
//int ShadowObject::RenderedVolumes;
//int ShadowObject::Frame;
//int ShadowObject::Time;

void ShadowObject::FreeShadow() {
	shadow_list.remove(this);
	ShadowMesh->FreeEntity();

	vector<ShadowTriangle*>::iterator it;
	for(it=Tri.begin();it!=Tri.end();it++){
		delete *it;
	}
	if (shadow_list.size()==0) Global::Shadows_enabled=0;

}

void ShadowObject::SetShadowColor(int R, int G, int B, int A){
	ShadowRed   = R/255.0;
	ShadowGreen = G/255.0;
	ShadowBlue  = B/255.0;
	ShadowAlpha = A/255.0;
}

void ShadowObject::ShadowInit(){
		int StencilBits;
		glGetIntegerv(GL_STENCIL_BITS, &StencilBits);
		midStencilVal = (StencilBits - 1)^2;
		glClearStencil(midStencilVal);
}

ShadowObject* ShadowObject::Create(Mesh* Parent, char Static){
		ShadowObject* S = new ShadowObject;
		S->ShadowMesh=Mesh::CreateMesh();
		Global::root_ent->child_list.remove(S->ShadowMesh);
		S->ShadowMesh->EntityBlend(0);
		S->ShadowMesh->EntityAlpha (0.2);
		S->ShadowMesh->EntityColor  (255, 0, 0);
		S->ShadowMesh->EntityFX (17);
		S->ShadowVolume = S->ShadowMesh->CreateSurface();
		S->Parent = Parent;
		S->Static = Static;
		S->VCreated=0;
		shadow_list.push_back(S);
		S->Init();
		return S;
}

void ShadowObject::RemoveShadowfromMesh(Mesh* M) {
	list<ShadowObject*>::iterator it;
	for(it=shadow_list.begin();it!=shadow_list.end();it++){
		ShadowObject* S=*it;
		if (S->Parent == M){
			shadow_list.remove(S);
			return;
		}
	}
}

void ShadowObject::Update(Camera* Cam){
	//RenderedVolumes = 0;
	//Global::RenderWorld();
		/*If TGlobal.Buffer <> Null
				Cam.SaveViewport()
				Cam.vx=0
				Cam.vy=0
				Cam.vwidth = TGlobal.Buffer.W
				Cam.vheight = TGlobal.Buffer.H
				TGlobal.Buffer.Setbuffer()
		End If*/
	vector<Light*>::iterator it;
	for(it=Light::light_list.begin();it!=Light::light_list.end();++it){
		Light* Light=*it;
		if (Light->hide==true || Light->cast_shadow==false) continue;

		light_x = Light->EntityX(true) * (1 + parallel * 1);
		light_y = Light->EntityY(true) * (1 + parallel * 1);
		light_z = Light->EntityZ(true) * (1 + parallel * 1);

		Cam->CameraClsMode(false,false);
		Cam->Update();

		list<ShadowObject*>::iterator it2;
		for(it2=shadow_list.begin();it2!=shadow_list.end();it2++){
			ShadowObject* S=*it2;
			if (S->Parent->hide==false && Light->EntityDistance(S->Parent)<1/Light->range){
				VolumeLength=(Cam->range_far-S->Parent->EntityDistance(Cam))/(S->Parent->EntityDistance(Light)+abs(S->Parent->cull_radius));
				S->ShadowMesh->reset_bounds = true;
				S->ShadowMesh->GetBounds();
				S->UpdateCaster();
				S->Render = true;
			}else{
				S->Render = false;
			}
			//RenderedVolumes++;
		}

		Cam->CameraClsMode(false,false);

		ShadowRenderWorldZFail();

	}
	Cam->CameraClsMode(true , true) ;
	/*	If TGlobal.Buffer <> Null Then
			TGLobal.Buffer.UnSetBuffer()
			Cam.RestoreViewPort()
		End If

	Frame++;*/
}

void ShadowObject::RenderVolume(){
	glEnable(GL_POLYGON_OFFSET_FILL);
	glPolygonOffset(0.0, 4.0);
	list<ShadowObject*>::iterator it;
	for(it=shadow_list.begin();it!=shadow_list.end();it++){
		ShadowObject* S=*it;
		if (S->Render == true) {S->ShadowMesh->UpdateShadow();}
	}
	glDisable(GL_POLYGON_OFFSET_FILL);
}

void ShadowObject::UpdateAnim(){
	Surface* surf;// = Parent->GetSurface(1);
	Surface* anim_surf;

	list<Surface*>::iterator surf_it;
	surf_it=Parent->surf_list.begin();

	list<Surface*>::iterator an_it;
	an_it=Parent->anim_surf_list.begin();

	vector<ShadowTriangle*>::iterator it;

	int cnt;
	int cnt_surf = Parent->CountSurfaces();
	it=Tri.begin();
  // for(it=Tri.begin();it!=Tri.end();it++){

	for (int s = 1; s<= cnt_surf;s++){
		surf = *surf_it;
		anim_surf = *an_it;
		cnt = surf->CountTriangles() - 1;

		for (int v = 0;v<=cnt;v++){
			ShadowTriangle* T=*it;
			int vert0 = surf->TriangleVertex(T->tris, 0);
			int vert1 = surf->TriangleVertex(T->tris, 1);
			int vert2 = surf->TriangleVertex(T->tris, 2);
			T->v1x = anim_surf->VertexX(vert0);
			T->v1y = anim_surf->VertexY(vert0);
			T->v1z = anim_surf->VertexZ(vert0);
			T->v2x = anim_surf->VertexX(vert1);
			T->v2y = anim_surf->VertexY(vert1);
			T->v2z = anim_surf->VertexZ(vert1);
			T->v3x = anim_surf->VertexX(vert2);
			T->v3y = anim_surf->VertexY(vert2);
			T->v3z = anim_surf->VertexZ(vert2);
			it++;
		}
		surf_it++;
		an_it++;
	}
}

void ShadowObject::Init(){
	int cnt = -1;
	cnt_tris = - 1;
	int cnt_surf = Parent->CountSurfaces();

	for (int s = 1; s<= cnt_surf;s++){
		Surface* surf = Parent->GetSurface(s);
		cnt = surf->CountTriangles() - 1;

		for (int v = 0;v<=cnt;v++){
			cnt_tris = cnt_tris + 1;
			/*if (cnt+1 > Tri.size){
					tri = tri[..tri.length + 1]
			}*/
			ShadowTriangle* etet = new ShadowTriangle;
			Tri.push_back(etet);
			etet->tris = v;
			int vert0 = surf->TriangleVertex(v, 0);
			int vert1 = surf->TriangleVertex(v, 1);
			int vert2 = surf->TriangleVertex(v, 2);
			etet->v1x = surf->VertexX(vert0);
			etet->v1y = surf->VertexY(vert0);
			etet->v1z = surf->VertexZ(vert0);
			etet->v2x = surf->VertexX(vert1);
			etet->v2y = surf->VertexY(vert1);
			etet->v2z = surf->VertexZ(vert1);
			etet->v3x = surf->VertexX(vert2);
			etet->v3y = surf->VertexY(vert2);
			etet->v3z = surf->VertexZ(vert2);
			etet->ta = -1;
			etet->tb = -1;
			etet->tc = -1;
		}
	}
	//int cnt_tris = cnt_tris
	float v1a_x, v1a_y, v1a_z, v1b_x, v1b_y, v1b_z, v1c_x, v1c_y, v1c_z;

	bool v1a_v2a, v1a_v2b, v1a_v2c, v1b_v2a, v1b_v2b, v1b_v2c, v1c_v2a, v1c_v2b, v1c_v2c;

	for (int a = 0;a<= cnt_tris;a++){
		ShadowTriangle* at = Tri[a];
		v1a_x  = at->v1x;
		v1a_y  = at->v1y;
		v1a_z  = at->v1z;
		v1b_x  = at->v2x;
		v1b_y  = at->v2y;
		v1b_z  = at->v2z;
		v1c_x  = at->v3x;
		v1c_y  = at->v3y;
		v1c_z  = at->v3z;
		for (int b = a + 1;b<= cnt_tris; b++){
			ShadowTriangle* bt = Tri[b];
			v1a_v2a = (v1a_x == bt->v1x && v1a_y == bt->v1y && v1a_z == bt->v1z);
			v1a_v2b = (v1a_x == bt->v2x && v1a_y == bt->v2y && v1a_z == bt->v2z);
			v1a_v2c = (v1a_x == bt->v3x && v1a_y == bt->v3y && v1a_z == bt->v3z);
			v1b_v2a = (v1b_x == bt->v1x && v1b_y == bt->v1y && v1b_z == bt->v1z);
			v1b_v2b = (v1b_x == bt->v2x && v1b_y == bt->v2y && v1b_z == bt->v2z);
			v1b_v2c = (v1b_x == bt->v3x && v1b_y == bt->v3y && v1b_z == bt->v3z);
			v1c_v2a = (v1c_x == bt->v1x && v1c_y == bt->v1y && v1c_z == bt->v1z);
			v1c_v2b = (v1c_x == bt->v2x && v1c_y == bt->v2y && v1c_z == bt->v2z);
			v1c_v2c = (v1c_x == bt->v3x && v1c_y == bt->v3y && v1c_z == bt->v3z);

			if (bt->ta==-1){
				if (v1a_v2b!=0 && v1b_v2a!=0 && at->ta==-1){
					at->ta = b;
					bt->ta = a;}
				else if (v1b_v2b!=0 && v1c_v2a!=0 && at->tb==-1){
					at->tb = b;
					bt->ta = a;}
				else if (v1c_v2b!=0 && v1a_v2a!=0 && at->ta==-1){
					at->tc = b;
					bt->ta = a;}
			}
			if (bt->tb==-1){
				if (v1a_v2c!=0 && v1b_v2b!=0 && at->ta==-1){
					at->ta = b;
					bt->tb = a;}
				else if (v1b_v2c!=0 && v1c_v2b!=0 && at->tb==-1){
					at->tb = b;
					bt->tb = a;}
				else if (v1c_v2c!=0 && v1a_v2b!=0 && at->tc==-1){
					at->tc = b;
					bt->tb = a;}
			}
			if (bt->tc==-1){
				if (v1a_v2a!=0 && v1b_v2c!=0 && at->ta==-1){
					at->ta = b;
					bt->tc = a;}
				else if (v1b_v2a!=0 && v1c_v2c!=0 && at->tb==-1){
					at->tb = b;
					bt->tc = a;}
				else if (v1c_v2a!=0 && v1a_v2c!=0 && at->tc==-1){
					at->tc = b;
					bt->tc = a;
				}
			}
		}

	}
	InitShadow();
}

void ShadowObject::InitShadow(){
	if (Global::Shadows_enabled==0){
	  Global::Shadows_enabled=true;
	  ShadowInit();
	}
	for (int v = 0;v<=cnt_tris;v++){
		ShadowTriangle* etet = Tri[v];
		if (etet->ta > -1) etet->id_ta = Tri[etet->ta];
		if (etet->tb > -1) etet->id_tb = Tri[etet->tb];
		if (etet->tc > -1) etet->id_tc = Tri[etet->tc];
	}
}

void ShadowObject::UpdateCaster(){
	if (Static!=0 && VCreated!=0) return;
	VCreated = true;
	if (ShadowVolume!=0) {ShadowVolume->ClearSurface();}
	if (Parent->anim!=0) {UpdateAnim();}

	float e0x, e0y, e0z, e1x, e1y, e1z;

	float normlight_x, normlight_y, normlight_z;

	float r1x, r1y, r1z, r2x, r2y, r2z, r3x, r3y, r3z;

	int vert1, vert2, vert3, vert4;

	char check1=0;
	char check2=0;
	char check3=0;

	/*Matrix mat1;
	Parent->MQ_GetMatrix(mat1, true);*/

	vector<ShadowTriangle*>::iterator it;


/*	for (int v = 0;v<=cnt_tris;v++){
		ShadowTriangle* etet = Tri[v];

		Entity::TFormPoint (etet->v1x, etet->v1y, etet->v1z, Parent, 0);
		etet->tf_v1x= Entity::TFormedX();
		etet->tf_v1y= Entity::TFormedY();
		etet->tf_v1z= Entity::TFormedZ();
		Entity::TFormPoint (etet->v2x, etet->v2y, etet->v2z, Parent, 0);
		etet->tf_v2x= Entity::TFormedX();
		etet->tf_v2y= Entity::TFormedY();
		etet->tf_v2z= Entity::TFormedZ();
		Entity::TFormPoint (etet->v3x, etet->v3y, etet->v3z, Parent, 0);
		etet->tf_v3x= Entity::TFormedX();
		etet->tf_v3y= Entity::TFormedY();
		etet->tf_v3z= Entity::TFormedZ();
		*/
	for(it=Tri.begin();it!=Tri.end();it++){
		ShadowTriangle* etet = *it;

		etet->tf_v1x= etet->v1x;
		etet->tf_v1y= etet->v1y;
		etet->tf_v1z= etet->v1z;
		Parent->mat.TransformVec(etet->tf_v1x, etet->tf_v1y, etet->tf_v1z, 1);

		etet->tf_v2x= etet->v2x;
		etet->tf_v2y= etet->v2y;
		etet->tf_v2z= etet->v2z;
		Parent->mat.TransformVec(etet->tf_v2x, etet->tf_v2y, etet->tf_v2z, 1);

		etet->tf_v3x= etet->v3x;
		etet->tf_v3y= etet->v3y;
		etet->tf_v3z= etet->v3z;
		Parent->mat.TransformVec(etet->tf_v3x, etet->tf_v3y, etet->tf_v3z, 1);

		e0x= etet->tf_v3x - etet->tf_v2x;
		e0y= etet->tf_v3y - etet->tf_v2y;
		e0z= etet->tf_v3z - etet->tf_v2z;
		e1x= etet->tf_v2x - etet->tf_v1x;
		e1y= etet->tf_v2y - etet->tf_v1y;
		e1z= etet->tf_v2z - etet->tf_v1z;
		normlight_x  = (etet->tf_v1x  - light_x ) * (e0y  * e1z  - e0z  * e1y );
		normlight_y  = (etet->tf_v1y  - light_y ) * (e0z  * e1x  - e0x  * e1z );
		normlight_z  = (etet->tf_v1z  - light_z ) * (e0x  * e1y  - e0y  * e1x );
		etet->cull = (normlight_x  + normlight_y  + normlight_z  > 0);
	}

//	for (int v = 0;v<=cnt_tris;v++){
//		ShadowTriangle* etet = Tri[v];
	for(it=Tri.begin();it!=Tri.end();it++){
		ShadowTriangle* etet = *it;
		r1x  = etet->tf_v1x  + (etet->tf_v1x  - light_x ) * VolumeLength;
		r1y  = etet->tf_v1y  + (etet->tf_v1y  - light_y ) * VolumeLength;
		r1z  = etet->tf_v1z  + (etet->tf_v1z  - light_z ) * VolumeLength;
		r2x  = etet->tf_v2x  + (etet->tf_v2x  - light_x ) * VolumeLength;
		r2y  = etet->tf_v2y  + (etet->tf_v2y  - light_y ) * VolumeLength;
		r2z  = etet->tf_v2z  + (etet->tf_v2z  - light_z ) * VolumeLength;
		r3x  = etet->tf_v3x  + (etet->tf_v3x  - light_x ) * VolumeLength;
		r3y  = etet->tf_v3y  + (etet->tf_v3y  - light_y ) * VolumeLength;
		r3z  = etet->tf_v3z  + (etet->tf_v3z  - light_z ) * VolumeLength;



		if (etet->cull == 0) {
			if (etet->ta > -1) {check1 = etet->id_ta->cull;} else {check1 = 1;}
			if (etet->tb > -1) {check2 = etet->id_tb->cull;} else {check2 = 1;}
			if (etet->tc > -1) {check3 = etet->id_tc->cull;} else {check3 = 1;}

			if (check1!=0){
				vert1 = ShadowVolume->AddVertex(etet->tf_v1x , etet->tf_v1y , etet->tf_v1z);
				vert2 = ShadowVolume->AddVertex(etet->tf_v2x , etet->tf_v2y , etet->tf_v2z);
				vert3 = ShadowVolume->AddVertex(r1x , r1y , r1z);
				vert4 = ShadowVolume->AddVertex(r2x , r2y , r2z);
				ShadowVolume->AddTriangle (vert1, vert3, vert4);
				ShadowVolume->AddTriangle (vert1, vert4, vert2);
			}
			if (check2!=0){
				vert1 = ShadowVolume->AddVertex(etet->tf_v2x , etet->tf_v2y , etet->tf_v2z);
				vert2 = ShadowVolume->AddVertex(etet->tf_v3x , etet->tf_v3y , etet->tf_v3z);
				vert3 = ShadowVolume->AddVertex(r2x , r2y , r2z);
				vert4 = ShadowVolume->AddVertex(r3x , r3y , r3z);
				ShadowVolume->AddTriangle (vert1, vert3, vert4);
				ShadowVolume->AddTriangle (vert1, vert4, vert2);
			}
			if (check3!=0){
				vert1 = ShadowVolume->AddVertex(etet->tf_v1x , etet->tf_v1y , etet->tf_v1z);
				vert2 = ShadowVolume->AddVertex(etet->tf_v3x , etet->tf_v3y , etet->tf_v3z);
				vert3 = ShadowVolume->AddVertex(r1x , r1y , r1z);
				vert4 = ShadowVolume->AddVertex(r3x , r3y , r3z);
				ShadowVolume->AddTriangle (vert1, vert4, vert3);
				ShadowVolume->AddTriangle (vert1, vert2, vert4);
			}
			if (top_caps!=0){
				vert1 = ShadowVolume->AddVertex(etet->tf_v1x , etet->tf_v1y , etet->tf_v1z);
				vert2 = ShadowVolume->AddVertex(etet->tf_v2x , etet->tf_v2y , etet->tf_v2z);
				vert3 = ShadowVolume->AddVertex(etet->tf_v3x , etet->tf_v3y , etet->tf_v3z);

				ShadowVolume->AddTriangle (vert1, vert2, vert3);
			}
		/*} else */
			if (parallel == 0){
				vert1 = ShadowVolume->AddVertex(r1x , r1y , r1z);
				vert2 = ShadowVolume->AddVertex(r2x , r2y , r2z);
				vert3 = ShadowVolume->AddVertex(r3x , r3y , r3z);
				ShadowVolume->AddTriangle (vert1, vert3, vert2);
			}
		}
	}
}

void ShadowObject::ShadowRenderWorldZFail(){
	glEnable(GL_STENCIL_TEST);
	/*Pass 1 Ambient Pass
	 First clear the stencil Buffer */
	glClearStencil(midStencilVal);

	glClear(GL_STENCIL_BUFFER_BIT);

	glDepthMask(GL_FALSE);
	glColorMask( GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE );
	// we wanted the first ambient pass above in the Color Buffer but we don't want the volumes in
	// there ..removing the above line is fun though :P
	glEnable( GL_CULL_FACE );
	glEnable( GL_STENCIL_TEST );

	// Render the shadow volume And increment the stencil every where a front
	// facing polygon is rendered.

	// Incrementing the stencil Buffer when back face depth fails
	glStencilFunc( GL_ALWAYS, midStencilVal, 0xffffffff); // ~0 is like 0xFFFFFFFF Or something :P
	glStencilOp( GL_KEEP, GL_INCR_WRAP, GL_KEEP ); // incrementing on the depth fail
	glCullFace( GL_BACK   ); // cull front facing polys For this pass

	RenderVolume();

	// Render the shadow volume And decrement the stencil every where a back
	// facing polygon is rendered.
	glStencilOp( GL_KEEP, GL_DECR_WRAP, GL_KEEP ); // decrementing on the depth fail
	glCullFace( GL_FRONT   ); // And now culling back facing polys

	RenderVolume();

	// When done, set the states back To something more typical.
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
#ifndef GLES2
	glEnable(GL_LIGHTING);
#endif
	glDepthMask(GL_TRUE);

	glColorMask( GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE );
	glStencilOp( GL_KEEP, GL_KEEP, GL_KEEP );

	//
	// Render the lit part...
	//
	glStencilFunc( GL_EQUAL, midStencilVal, 0xffffffff); // again with the ~0 :P
	// When done, set the states back To something more typical.
	glEnable(GL_DEPTH_TEST);
	glCullFace( GL_BACK   ); // cull front facing polys For this pass

	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
#ifndef GLES2
	glEnable(GL_LIGHTING);
#endif
	glDepthMask(GL_TRUE);

	glCullFace(GL_BACK);
	glStencilFunc(GL_NOTEQUAL, midStencilVal, 0xffffff);
	glStencilOp(GL_KEEP , GL_KEEP , GL_KEEP);

// NOTE: is it the projektion matrix ?
#ifndef GLES2
	glPushMatrix();
	  glLoadIdentity();
	  glMatrixMode(GL_MODELVIEW);
	  glPushMatrix();
	    glLoadIdentity();
	    glOrtho(0 , 1 , 1 , 0 , 0 , 1);

	    //float no_mat[]={0.0,0.0};
	    float mat_ambient[]={ShadowRed,ShadowGreen,ShadowBlue,1.0};
	    float mat_diffuse[]={0,0,0,ShadowAlpha};
	    float mat_specular[]={0,0,0,0.5};
	    float mat_shininess[]={0.0}; // upto 128

	    glMaterialfv(GL_FRONT,GL_AMBIENT,mat_ambient);
	    glMaterialfv(GL_FRONT,GL_DIFFUSE,mat_diffuse);
	    glMaterialfv(GL_FRONT,GL_SPECULAR,mat_specular);
	    glMaterialfv(GL_FRONT,GL_SHININESS,mat_shininess);

	    glEnable(GL_BLEND);
	    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	    glDisable(GL_DEPTH_TEST);
	    glColor4f(0.0, 0.0, 0.0, 1.0);

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


	    glEnable(GL_DEPTH_TEST);
	  glPopMatrix();
	  // NOTE: is it the projektion matrix ?
	  glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
#else
	Global::shader=&Global::shader_stencil;
	glUseProgram(Global::shader->ambient_program);

	glBindBuffer(GL_ARRAY_BUFFER, Global::stencil_vbo);

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_DEPTH_TEST);

	glVertexAttribPointer(Global::shader->vposition, 2, GL_FLOAT, GL_FALSE, 0, 0);
	glUniform4f(Global::shader->color,ShadowRed,ShadowGreen,ShadowBlue,.5);
	glEnableVertexAttribArray(Global::shader->vposition);
 
	glDrawArrays(GL_TRIANGLE_FAN,0,4);

#endif

	glCullFace( GL_BACK   ); // cull front facing polys For this pass
	glDisable(GL_STENCIL_TEST);

}


