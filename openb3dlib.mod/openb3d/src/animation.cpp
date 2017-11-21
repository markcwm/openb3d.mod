/*
 *  animation.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "animation.h"

#include "mesh.h"
#include "bone.h"
#include "quaternion.h"
#include "stdio.h"

#include <list>
#include <vector>
#include <iostream>
using namespace std;

void Animation::AnimateMesh(Mesh* ent1,float framef,int start_frame,int end_frame){
	//if(dynamic_cast<Mesh*>(ent1)!=NULL){
	if(ent1->anim!=1) {			//Not a bone based animation

		if(ent1->anim<=0) return; // mesh contains no anim data

		if(ent1->anim==64) { // repeated mesh: every frame has its own surface
			ent1->anim_render=true;
			//ent1->surf_list.size();
			list<Surface*>::iterator dst_surf_it;
			dst_surf_it=ent1->anim_surf_list.begin();

			list<Surface*>::iterator src_surf_it;
			src_surf_it=ent1->anim_surf_list.begin();

			//Locate correct frame
			for(unsigned int i=0;i<(int)framef*ent1->surf_list.size();i++){
				src_surf_it++;
			}

			list<Surface*>::iterator surf_it;
			surf_it=ent1->surf_list.begin();

			// cycle through all surfs
			for(surf_it=ent1->surf_list.begin();surf_it!=ent1->surf_list.end();surf_it++){

				*dst_surf_it=*src_surf_it;
				src_surf_it++;
				dst_surf_it++;
			}

			return;
		}

		//Vertex deform animation
		ent1->anim_render=true;

		list<Surface*>::iterator surf_it;
		surf_it=ent1->surf_list.begin();

		list<Surface*>::iterator anim_surf_it;

		// cycle through all surfs
		for(anim_surf_it=ent1->anim_surf_list.begin();anim_surf_it!=ent1->anim_surf_list.end();anim_surf_it++){

			Surface& anim_surf=**anim_surf_it;

			Surface& surf=**surf_it;

			anim_surf.reset_vbo=anim_surf.reset_vbo|1;

			int t0, t1;
			t0=0;

			for(unsigned int i=0;i<=anim_surf.vert_weight4.size();i++){
				if (anim_surf.vert_weight4[i]>=framef){
					t1=i; t0=i-1;
					if(i==0) t0=anim_surf.vert_weight4.size()-1; // last frame
					break;
				}
			}

			float md=anim_surf.vert_weight4[t1]-anim_surf.vert_weight4[t0];
			if(md==0.0) md=1.0; // avoid divide by zero
			float m1=(framef-anim_surf.vert_weight4[t0])/md;
			float m0=1.0-m1;

			t0*=anim_surf.no_verts*3;
			t1*=anim_surf.no_verts*3;

			for(int i=0;i<=anim_surf.no_verts*3;i++){
				anim_surf.vert_coords[i]=surf.vert_coords[i+t0]*m0+surf.vert_coords[i+t1]*m1;

			}

			surf_it++;
		}

		return;
	}

	ent1->anim_render=true;

	// cap framef values
	if(framef>end_frame) framef=end_frame;
	if(framef<start_frame) framef=start_frame;

	int frame=framef; // float to int

	vector<Bone*>::iterator bone_it;

	for(bone_it=ent1->bones.begin();bone_it!=ent1->bones.end();bone_it++){
		Bone& bent=**bone_it;
		int i=0;
		int ii=0;
		float fd1=0.0; // anim time since last key
		float fd2=0.0; // anim time until next key
		int found=false;
		int no_keys=false;
		float w1=0.0;
		float x1=0.0;
		float y1=0.0;
		float z1=0.0;
		float w2=0.0;
		float x2=0.0;
		float y2=0.0;
		float z2=0.0;

  	int flag=0;
		// position

	  // backwards
		i=frame+1;
		do{
			i=i-1;
			flag=bent.keys->flags[i]&1;
			if(flag){
				x1=bent.keys->px[i];
				y1=bent.keys->py[i];
				z1=bent.keys->pz[i];
				fd1=framef-i;
				found=true;
			}
			if(i<=start_frame){
				i=end_frame+1;
				ii=ii+1;
			}
		} while( (found!=true) && (ii<2) );

		if(found==false)
		  no_keys=true;

		found=false;
		ii=0;

		// forwards
		i=frame;
		do{
			i=i+1;
			if(i>end_frame){
				i=start_frame;
				ii=ii+1;
			}
			flag=bent.keys->flags[i]&1;
			if(flag){
				x2=bent.keys->px[i];
				y2=bent.keys->py[i];
				z2=bent.keys->pz[i];
				fd2=i-framef;
				found=true;
			}
		} while( (found!=true) && (ii<2) );

		if(found==false)
		  no_keys=true;

		found=false;
		ii=0;

		float px3=0;
		float py3=0;
		float pz3=0;

		if(no_keys==true){ // no keyframes
		  px3=bent.n_px;
			py3=bent.n_py;
			pz3=bent.n_pz;
		} else {
  		if(fd1+fd2==0.0){ // one keyframe
				// if only one keyframe, fd1+fd2 will equal 0 resulting in division error and garbage positional values (which can affect children)
				// so we check for this, and if true then positional values equals x1,y1,z1 (same as x2,y2,z2)
				px3=x1;
				py3=y1;
				pz3=z1;
			} else { // more than one keyframe
				px3=(((x2-x1)/(fd1+fd2))*fd1)+x1;
				py3=(((y2-y1)/(fd1+fd2))*fd1)+y1;
				pz3=(((z2-z1)/(fd1+fd2))*fd1)+z1;
			}
		}
		no_keys=false;

		// store current keyframe for use with transitions
		bent.kx=px3;
		bent.ky=py3;
		bent.kz=pz3;

		// rotation
		i=frame+1;
		do{
			i=i-1;
			flag=bent.keys->flags[i]&4;
			if(flag){
				w1=bent.keys->qw[i];
				x1=bent.keys->qx[i];
				y1=bent.keys->qy[i];
				z1=bent.keys->qz[i];
				fd1=framef-i;
				found=true;
			}
			if(i<=start_frame){
				i=end_frame+1;
				ii=ii+1;
			}
		} while ( (found!=true) && (ii<2));

		if(found==false)
		  no_keys=true;

		found=false;
		ii=0;
		// forwards
		i=frame;
		do{
			i=i+1;
			if(i>end_frame){
				i=start_frame;
				ii=ii+1;
			}
			flag=bent.keys->flags[i]&4;
			if(flag){
				w2=bent.keys->qw[i];
				x2=bent.keys->qx[i];
				y2=bent.keys->qy[i];
				z2=bent.keys->qz[i];
				fd2=i-framef;
				found=true;
			}
		} while( (found!=true) && (ii<2) );

		if(found==false)
		  no_keys=true;

		found=false;
		ii=0;

		// interpolate keys
		float w3=0.0;
		float x3=0.0;
		float y3=0.0;
		float z3=0.0;
		if(no_keys==true){ // no keyframes
			w3=bent.n_qw;
			x3=bent.n_qx;
			y3=bent.n_qy;
			z3=bent.n_qz;
		}else{
			if(fd1+fd2==0.0){ // one keyframe
				// if only one keyframe, fd1+fd2 will equal 0 resulting in division error and garbage rotational values (which can affect children)
				// so we check for this, and if true then rotational values equals w1,x1,y1,z1 (same as w2,x2,y2,z2)
				w3=w1;
				x3=x1;
				y3=y1;
				z3=z1;
			}else{ // more than one keyframe
				float t=(1.0/(fd1+fd2))*fd1;
				Slerp(x1,y1,z1,w1,x2,y2,z2,w2,x3,y3,z3,w3,t); // interpolate between prev and next rotations
			}
		}
		no_keys=false;

		// store current keyframe for use with transitions
		bent.kqw=w3;
		bent.kqx=x3;
		bent.kqy=y3;
		bent.kqz=z3;

		QuatToMat(w3,x3,y3,z3,bent.rotmat);

		/*bent.mat.grid[3][0]=px3;
		bent.mat.grid[3][1]=py3;
		bent.mat.grid[3][2]=pz3;

		// store local position/rotation values. will be needed to maintain bone positions when positionentity etc is called
		float pitch=0.0;
		float yaw=0.0;
		float roll=0.0;
		QuatToEuler(w3,x3,y3,z3,pitch,yaw,roll);
		bent.rx=-pitch;
		bent.ry=yaw;
		bent.rz=roll;*/

		bent.px=px3;
		bent.py=py3;
		bent.pz=-pz3;

		// set mat2 to equal mat
		bent.mat2.Overwrite(bent.rotmat);
		bent.mat2.grid[3][0]=px3;
		bent.mat2.grid[3][1]=py3;
		bent.mat2.grid[3][2]=pz3;


		// set mat - includes root parent transformation
		// mat is used for store global bone positions, needed when displaying actual bone positions and attaching entities to bones
		/*if(bent.parent!=NULL){
			Matrix* new_mat=bent.parent->mat.Copy();
			new_mat->Multiply(bent.mat);
			bent.mat.Overwrite(*new_mat);
			delete new_mat;
		}*/

		// set mat2 - does not include root parent transformation
		// mat2 is used to store local bone positions, and is needed for vertex deform
		if(dynamic_cast<Bone*>(bent.parent)!=NULL){
			Matrix new_mat;
			new_mat.Overwrite(dynamic_cast<Bone*>(bent.parent)->mat2);
			new_mat.Multiply(bent.mat2);
			bent.mat2.Overwrite(new_mat);
		}

		// set tform mat
		// A tform mat is needed to transform vertices, and is basically the bone mat multiplied by the inverse reference pose mat
		bent.tform_mat.Overwrite(bent.mat2);
		bent.tform_mat.Multiply(bent.inv_mat);

		// update bone children
		//if(bent.child_list.size()!=0) Entity::UpdateChildren(&bent);
		//bent.MQ_Update();
	}

	ent1->MQ_Update();

	// --- vertex deform ---
	VertexDeform(ent1);

}

// AnimateMesh2, used to animate transitions between animations, very similar to AnimateMesh except it
// interpolates between current animation pose (via saved keyframe) and first keyframe of new animation.
// framef:Float interpolates between 0 and 1

void Animation::AnimateMesh2(Mesh* ent1,float framef,int start_frame,int end_frame){

	//if(dynamic_cast<Mesh*>(ent1)!=NULL){

	if(ent1->anim!=1) {			//Not a bone based animation

		if(ent1->anim==2) { 
			//Vertex deform animation
			ent1->anim_render=true;

			list<Surface*>::iterator surf_it;
			surf_it=ent1->surf_list.begin();

			list<Surface*>::iterator anim_surf_it;


			// cycle through all surfs
			for(anim_surf_it=ent1->anim_surf_list.begin();anim_surf_it!=ent1->anim_surf_list.end();anim_surf_it++){

				Surface& anim_surf=**anim_surf_it;

				Surface& surf=**surf_it;

				anim_surf.reset_vbo=anim_surf.reset_vbo|1;

				int t0=0;
				for(unsigned int i=0;i<=anim_surf.vert_weight4.size();i++){
					if (anim_surf.vert_weight4[i]>=start_frame){
						t0=i;
						break;
					}
				}


				t0*=anim_surf.no_verts*3;

				float m0=1.0/ent1->anim_trans;
				float m1=1.0-m0;

				for(int i=0;i<=anim_surf.no_verts*3;i++){
					anim_surf.vert_coords[i]=surf.vert_coords[i+t0]*m0+anim_surf.vert_coords[i]*m1;

				}




				surf_it++;

			}
			
		}
		return;

	}

		ent1->anim_render=true;

		//int frame=framef; // float to int

		vector<Bone*>::iterator it;

		for(it=ent1->bones.begin();it!=ent1->bones.end();it++){

			Bone& bent=**it;

			int i=0;
			int ii=0;
			float fd1=framef; // fd1 always between 0 and 1 for this function
			float fd2=1.0-fd1; // fd1+fd2 always equals 0 for this function
			int found=false;
			int no_keys=false;
			float w1=0.0;

			// get current keyframe
			float x1=bent.kx;
			float y1=bent.ky;
			float z1=bent.kz;

			float w2=0.0;
			float x2=0.0;
			float y2=0.0;
			float z2=0.0;

			int flag=0;

			// position

			// forwards
			//i=frame
			i=start_frame-1;
			do{
				i=i+1;
				if(i>end_frame){
					i=start_frame;
					ii=ii+1;
				}
				flag=bent.keys->flags[i]&1;
				if(flag){
					x2=bent.keys->px[i];
					y2=bent.keys->py[i];
					z2=bent.keys->pz[i];
					//fd2=i-framef
					found=true;
				}
			}while(found==true && ii<2);
			if(found==false) no_keys=true;
			found=false;
			ii=0;

			float px3=0.0;
			float py3=0.0;
			float pz3=0.0;
			if(no_keys==true){ // no keyframes
				px3=bent.n_px;
				py3=bent.n_py;
				pz3=bent.n_pz;
			}else{
				if(fd1+fd2==0.0){ // one keyframe
					// if only one keyframe, fd1+fd2 will equal 0 resulting in division error and garbage positional values (which can affect children)
					// so we check for this, and if true then positional values equals x1,y1,z1 (same as x2,y2,z2)
					px3=x1;
					py3=y1;
					pz3=z1;
				}else{ // more than one keyframe
					px3=(((x2-x1)/(fd1+fd2))*fd1)+x1;
					py3=(((y2-y1)/(fd1+fd2))*fd1)+y1;
					pz3=(((z2-z1)/(fd1+fd2))*fd1)+z1;
				}
			}
			no_keys=false;

			// get current keyframe
			w1=bent.kqw;
			x1=bent.kqx;
			y1=bent.kqy;
			z1=bent.kqz;

			// rotation

			// forwards
			//i=frame
			i=start_frame-1;
			do{
				i=i+1;
				if(i>end_frame){
					i=start_frame;
					ii=ii+1;
				}
				flag=bent.keys->flags[i]&4;
				if(flag){
					w2=bent.keys->qw[i];
					x2=bent.keys->qx[i];
					y2=bent.keys->qy[i];
					z2=bent.keys->qz[i];
					//fd2=i-framef
					found=true;
				}
			}while(found==true && ii<2);
			if(found==false) no_keys=true;
			found=false;
			ii=0;

			// interpolate keys

			float w3=0.0;
			float x3=0.0;
			float y3=0.0;
			float z3=0.0;
			if(no_keys==true){ // no keyframes
				w3=bent.n_qw;
				x3=bent.n_qx;
				y3=bent.n_qy;
				z3=bent.n_qz;
			}else{
				if(fd1+fd2==0.0){ // one keyframe
					// if only one keyframe, fd1+fd2 will equal 0 resulting in division error and garbage rotational values (which can affect children)
					// so we check for this, and if true then rotational values equals w1,x1,y1,z1 (same as w2,x2,y2,z2)
					w3=w1;
					x3=x1;
					y3=y1;
					z3=z1;
				}else{ // more than one keyframe
					float t=(1.0/(fd1+fd2))*fd1;
					Slerp(x1,y1,z1,w1,x2,y2,z2,w2,x3,y3,z3,w3,t); // interpolate between prev and next rotations
				}
			}
			no_keys=false;

			QuatToMat(w3,x3,y3,z3,bent.rotmat);

			/*bent.mat.grid[3][0]=px3;
			bent.mat.grid[3][1]=py3;
			bent.mat.grid[3][2]=pz3;

			// store local position/rotation values. will be needed to maintain bone positions when positionentity etc is called
			float pitch=0;
			float yaw=0;
			float roll=0;
			QuatToEuler(w3,x3,y3,z3,pitch,yaw,roll);
			bent.rx=-pitch;
			bent.ry=yaw;
			bent.rz=roll;*/

			bent.px=px3;
			bent.py=py3;
			bent.pz=-pz3;

			// set mat2 to equal mat
			bent.mat2.Overwrite(bent.rotmat);
			bent.mat2.grid[3][0]=px3;
			bent.mat2.grid[3][1]=py3;
			bent.mat2.grid[3][2]=pz3;

			// set mat - includes root parent transformation
			// mat is used for store global bone positions, needed when displaying actual bone positions and attaching entities to bones
			/*if(bent.parent!=NULL){
				Matrix* new_mat=bent.parent->mat.Copy();
				new_mat->Multiply(bent.mat);
				bent.mat.Overwrite(*new_mat);
				delete new_mat;
			}*/

			// set mat2 - does not include root parent transformation
			// mat2 is used to store local bone positions, and is needed for vertex deform
			if(dynamic_cast<Bone*>(bent.parent)!=NULL){
				Matrix new_mat;
				new_mat.Overwrite(dynamic_cast<Bone*>(bent.parent)->mat2);
				new_mat.Multiply(bent.mat2);
				bent.mat2.Overwrite(new_mat);
			}

			// set tform mat
			// A tform mat is needed to transform vertices, and is basically the bone mat multiplied by the inverse reference pose mat
			bent.tform_mat.Overwrite(bent.mat2);
			bent.tform_mat.Multiply(bent.inv_mat);

			// update bone children
			//if(bent.child_list.size()!=0) Entity::UpdateChildren(&bent);
			//bent.MQ_Update();

		}

		ent1->MQ_Update();

		// --- vertex deform ---
		VertexDeform(ent1);

	//}

}

void Animation::AnimateMesh3(Mesh* ent1){
	if(ent1->anim!=1) return; // mesh contains no anim data

		ent1->anim_render=true;

		//int frame=framef; // float to int

		vector<Bone*>::iterator it;

		for(it=ent1->bones.begin();it!=ent1->bones.end();it++){

			Bone& bent=**it;

			// set mat2 to equal mat
			bent.mat2.Overwrite(bent.rotmat);

			bent.mat2.grid[3][0]=bent.px;
			bent.mat2.grid[3][1]=bent.py;
			bent.mat2.grid[3][2]=-bent.pz;

			// store current keyframe for use with transitions

			bent.rotmat.ToQuat(bent.kqx, bent.kqy, bent.kqz, bent.kqw);
			bent.kqw=-bent.kqw;

			bent.kx=bent.px;
			bent.ky=bent.py;
			bent.kz=-bent.pz;




			// mat2 is used to store local bone positions, and is needed for vertex deform
			if(dynamic_cast<Bone*>(bent.parent)!=NULL){
				Matrix new_mat;
				new_mat.Overwrite(dynamic_cast<Bone*>(bent.parent)->mat2);
				new_mat.Multiply(bent.mat2);
				bent.mat2.Overwrite(new_mat);
			}


			// set tform mat
			// A tform mat is needed to transform vertices, and is basically the bone mat multiplied by the inverse reference pose mat
			bent.tform_mat.Overwrite(bent.mat2);

			bent.tform_mat.Multiply(bent.inv_mat);


		}

		ent1->MQ_Update();

		// --- vertex deform ---
		VertexDeform(ent1);

	//}

}

void Animation::VertexDeform(Mesh* ent){

	float ovx=0.0,ovy=0.0,ovz=0.0; // original vertex positions
	float x=0.0,y=0.0,z=0.0;

	//Bone* bone;
	float weight=0.0;

	list<Surface*>::iterator surf_it;
	surf_it=ent->surf_list.begin();

	list<Surface*>::iterator anim_surf_it;

	// cycle through all surfs
	for(anim_surf_it=ent->anim_surf_list.begin();anim_surf_it!=ent->anim_surf_list.end();anim_surf_it++){

		Surface& anim_surf=**anim_surf_it;

		Surface& surf=**surf_it;

		// mesh shape will be changed, update reset_vbo flag (1=vertices move)
		anim_surf.reset_vbo=anim_surf.reset_vbo|1;

		int vid=0;
		int vid3=0;

		for(vid=0;vid<=anim_surf.no_verts;vid++){

			vid3=vid*3;

			// BONE 1

			if(anim_surf.vert_bone1_no[vid]!=0){

				// get original vertex position
				ovx=surf.vert_coords[vid3+0];//VertexX(vid)
				ovy=surf.vert_coords[vid3+1];//VertexY(vid)
				ovz=surf.vert_coords[vid3+2];//VertexZ(vid)

				Bone& bone=*ent->bones[anim_surf.vert_bone1_no[vid]-1];
				weight=anim_surf.vert_weight1[vid];

				// transform vertex position with transform mat
				x= ( bone.tform_mat.grid[0][0]*ovx + bone.tform_mat.grid[1][0]*ovy + bone.tform_mat.grid[2][0]*ovz + bone.tform_mat.grid[3][0] ) * weight;
				y= ( bone.tform_mat.grid[0][1]*ovx + bone.tform_mat.grid[1][1]*ovy + bone.tform_mat.grid[2][1]*ovz + bone.tform_mat.grid[3][1] ) * weight;
				z= ( bone.tform_mat.grid[0][2]*ovx + bone.tform_mat.grid[1][2]*ovy + bone.tform_mat.grid[2][2]*ovz + bone.tform_mat.grid[3][2] ) * weight;

				// BONE 2

				if(anim_surf.vert_bone2_no[vid]!=0){

					Bone& bone=*ent->bones[anim_surf.vert_bone2_no[vid]-1];
					weight=anim_surf.vert_weight2[vid];

					// transform vertex position with transform mat
					x=x+ ( bone.tform_mat.grid[0][0]*ovx + bone.tform_mat.grid[1][0]*ovy + bone.tform_mat.grid[2][0]*ovz + bone.tform_mat.grid[3][0] ) * weight;
					y=y+ ( bone.tform_mat.grid[0][1]*ovx + bone.tform_mat.grid[1][1]*ovy + bone.tform_mat.grid[2][1]*ovz + bone.tform_mat.grid[3][1] ) * weight;
					z=z+ ( bone.tform_mat.grid[0][2]*ovx + bone.tform_mat.grid[1][2]*ovy + bone.tform_mat.grid[2][2]*ovz + bone.tform_mat.grid[3][2] ) * weight;

					// BONE 3

					if(anim_surf.vert_bone3_no[vid]!=0){

						Bone& bone=*ent->bones[anim_surf.vert_bone3_no[vid]-1];
						weight=anim_surf.vert_weight3[vid];

						// transform vertex position with transform mat
						x=x+ ( bone.tform_mat.grid[0][0]*ovx + bone.tform_mat.grid[1][0]*ovy + bone.tform_mat.grid[2][0]*ovz + bone.tform_mat.grid[3][0] ) * weight;
						y=y+ ( bone.tform_mat.grid[0][1]*ovx + bone.tform_mat.grid[1][1]*ovy + bone.tform_mat.grid[2][1]*ovz + bone.tform_mat.grid[3][1] ) * weight;
						z=z+ ( bone.tform_mat.grid[0][2]*ovx + bone.tform_mat.grid[1][2]*ovy + bone.tform_mat.grid[2][2]*ovz + bone.tform_mat.grid[3][2] ) * weight;

						// BONE 4

						if(anim_surf.vert_bone4_no[vid]!=0){

							Bone& bone=*ent->bones[anim_surf.vert_bone4_no[vid]-1];
							weight=anim_surf.vert_weight4[vid];

							// transform vertex position with transform mat
							x=x+ ( bone.tform_mat.grid[0][0]*ovx + bone.tform_mat.grid[1][0]*ovy + bone.tform_mat.grid[2][0]*ovz + bone.tform_mat.grid[3][0] ) * weight;
							y=y+ ( bone.tform_mat.grid[0][1]*ovx + bone.tform_mat.grid[1][1]*ovy + bone.tform_mat.grid[2][1]*ovz + bone.tform_mat.grid[3][1] ) * weight;
							z=z+ ( bone.tform_mat.grid[0][2]*ovx + bone.tform_mat.grid[1][2]*ovy + bone.tform_mat.grid[2][2]*ovz + bone.tform_mat.grid[3][2] ) * weight;

						}

					}

				}

				// update vertex position
				//anim_surf.VertexCoords(vid,x,y,z)
				anim_surf.vert_coords[vid3]=x;
				anim_surf.vert_coords[vid3+1]=y;
				anim_surf.vert_coords[vid3+2]=z;

			}

		}

		surf_it++;

	}

}

/*

' this function will normalise weights if their sum doesn't equal 1.0 (unused)
Function NormaliseWeights(mesh:TMesh)

	' cycle through all surfs
	For Local anim_surf:TSurface=EachIn mesh.anim_surf_list

		For Local vid=0 Until anim_surf.no_verts

			' normalise weights

			Local w1:Float=anim_surf.vert_weight1[vid]
			Local w2:Float=anim_surf.vert_weight2[vid]
			Local w3:Float=anim_surf.vert_weight3[vid]
			Local w4:Float=anim_surf.vert_weight4[vid]

			Local wt:Float=w1+w2+w3+w4

			' normalise weights if sum of them <> 1.0

			If wt<0.99 Or wt>1.01

				Local wm:Float
				If wt<>0.0
					wm=1.0/wt
				Else
					wm=1.0
				EndIf
				w1=w1*wm
				w2=w2*wm
				w3=w3*wm
				w4=w4*wm

				anim_surf.vert_weight1[vid]=w1
				anim_surf.vert_weight2[vid]=w2
				anim_surf.vert_weight3[vid]=w3
				anim_surf.vert_weight4[vid]=w4

			EndIf

		Next

	Next

End Function

*/

