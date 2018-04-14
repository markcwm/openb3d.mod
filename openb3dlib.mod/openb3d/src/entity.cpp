/*
 *  entity.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "model.h"
#include "animation.h"
#include "pick.h"
#include "maths_helper.h"
#include <string.h>

list<Entity*> Entity::entity_list;
list<Entity*> Entity::animate_list;

float Entity::tformed_x=0.0;
float Entity::tformed_y=0.0;
float Entity::tformed_z=0.0;

void Entity::FreeEntity(void){

	entity_list.remove(this);

	// remove from animate list
	if(anim_update){
		animate_list.remove(this);
		anim_update=false;
	}

	// remove from collision entity lists
	if(collision_type!=0) CollisionPair::ent_lists[collision_type].remove(this);

	// remove from pick entity list
	if(pick_mode!=0){
		Pick::ent_list.remove(this);
	}

	// free self from parent's child_list
	if(parent!=NULL){
		parent->child_list.remove(this);
	}else{
		Global::root_ent->child_list.remove(this);
	}

	// free child entities
	list<Entity*>::iterator it;

	for(it=child_list.begin();it!=child_list.end();it++){
		if(child_list.size()){
			Entity* ent=*it;
			ent->FreeEntity();
			it=child_list.begin();
			it--;
		}else{
			break;
		}
	}
}

// relations
void Entity::EntityParent(Entity* parent_ent,int glob){

	float orgx=0.0f,orgy=0.0f,orgz=0.0f;
	float orgw,orgh,orgd;
	float neww,newh,newd;
	Matrix m1;
	Matrix m2;

	//get global position/rotation
	if (glob != 0) {
		TFormPoint(0, 0, 0, this, 0);
		orgx = tformed_x;
		orgy = tformed_y;
		orgz = tformed_z;
		MQ_GetMatrix(m1);
		m1.grid[3][0] = 0; //remove translation
		m1.grid[3][1] = 0;
		m1.grid[3][2] = 0;
		//get scaling
		MQ_GetScaleXYZ(orgw,orgh,orgd);
	}

	//remove parent
	if (parent != 0) {
		parent->child_list.remove(this);
		parent = 0;
	}else{
		Global::root_ent->child_list.remove(this);
	}

	//retain global position/rotation

	if (glob != 0){
		//transform global position into parent
		if (parent_ent != 0){
			TFormPoint(orgx, orgy, orgz, 0, parent_ent);
			orgx = tformed_x;
			orgy = tformed_y;
			orgz = tformed_z;
		}
		//set position
		px = orgx;
		py = orgy;
		pz = orgz;
		//get parent inverted rotation matrix
		if (parent_ent == 0) {
			m2.LoadIdentity(); //no parent
		}else{
			parent_ent->MQ_GetInvMatrix(m2);
			m2.grid[3][0] = 0; //remove translation
			m2.grid[3][1] = 0;
			m2.grid[3][2] = 0;
		}
		//apply rotation matrix
		m1.Multiply2(m2);
		rotmat.Overwrite(m1);
	}

	if (parent_ent == 0) {
		parent = 0;
		Global::root_ent->child_list.push_back(this); 
	}else{
		//set parent
		parent = parent_ent;
		parent->child_list.push_back(this);
	}

	//get scaling
	MQ_GetScaleXYZ(neww,newh,newd);
	if (neww != 0) {sx = sx * orgw / neww;}
	if (newh != 0) {sy = sy * orgh / newh;}
	if (newd != 0) {sz = sz * orgd / newd;}

	MQ_Update();
}

Entity* Entity::GetParent(){
	return parent;
}

int Entity::CountChildren(){
	int no_children=0;
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		no_children=no_children+1;
	}
	return no_children;
	//return child_list.size();
}

Entity* Entity::GetChild(int child_no){
	int no_children=0;
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		no_children=no_children+1;
		if(no_children==child_no)
		  return ent;
	}
	return NULL;
}

Entity* Entity::FindChild(string child_name){
	Entity* cent;
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		if(ent->EntityName()==child_name)
		  return ent;

		cent=ent->FindChild(child_name);
		if(cent!=NULL)
		  return cent;
	}
	return NULL;
}

int Entity::CountAllChildren(int no_children){
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent2=*it;
		no_children=no_children+1;
		no_children=ent2->CountAllChildren(no_children);
	}
	return no_children;
}

Entity* Entity::GetChildFromAll(int child_no,int &no_children,Entity* ent){
	if(ent==NULL)
	  ent=this;

	Entity* ent3=NULL;

	list<Entity*>::iterator it;

	for(it=ent->child_list.begin();it!=ent->child_list.end();it++){
		Entity* ent2=*it;
		no_children=no_children+1;
		if(no_children==child_no)
		  return ent2;

		if(ent3==NULL){
			ent3=GetChildFromAll(child_no,no_children,ent2);
		}
	}

	return ent3;
}

void Entity::UpdateAllEntities(void(Update)(Entity* ent,Entity* ent2),Entity* ent2){
	if(Hidden())
	  return;

	list<Entity*>::iterator it;

	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* child_ent=*it;
		Update(child_ent,ent2);
		child_ent->UpdateAllEntities(Update,ent2);
	}
}

// transform

void Entity::PositionEntity(float x,float y,float z,int global){
	if (global==true){
		//transform global position into parent
		if (parent != 0){
			TFormPoint(x, y, z, 0, parent);
			x = tformed_x;
			y = tformed_y;
			z = tformed_z;
		}
	}

	px = x;
	py = y;
	pz = z;

	MQ_Update();

}

void Entity::MoveEntity(float mx,float my,float mz){
	rotmat.TransformVec(mx,my,mz); //transform point by internal matrix
	px = px + mx; //add to position
	py = py + my;
	pz = pz + mz;
	MQ_Update();
}

void Entity::TranslateEntity(float tx,float ty,float tz,int glob){
	TFormVector(tx, ty, tz, 0, this);
	rotmat.TransformVec(tformed_x,tformed_x,tformed_x); //transform point by internal matrix
	px = px + tx; //add to position
	py = py + ty;
	pz = pz + tz;
	MQ_Update();
}

void Entity::ScaleEntity(float x,float y,float z,int glob){
	if (glob != 0 && parent != 0) { // scale root parent (global)
			float esx = parent->EntityScaleX(true);
			float esy = parent->EntityScaleY(true);
			float esz = parent->EntityScaleZ(true);
			
			if (esx != 0) {x = x / esx;}
			if (esy != 0) {y = y / esy;}
			if (esz != 0) {z = z / esz;}
	}
	
	sx = x; // scale (local)
	sy = y;
	sz = z;
	
	MQ_Update(); // scale children
}

void Entity::RotateEntity(float x,float y,float z,int global){
	rotmat.LoadIdentity();
	rotmat.Rotate(x, y, z);

	if (global != 0) {
		//get parent inverted rotation matrix
		if (parent != 0) {
			Matrix m2;
			parent->MQ_GetInvMatrix(m2);
			m2.grid[3][0] = 0; //remove translation
			m2.grid[3][1] = 0;
			m2.grid[3][2] = 0;
			m2.Scale(parent->sx, parent->sy, parent->sz);
			//apply rotation matrix
			rotmat.Multiply2(m2);
		}
	}

	MQ_Update();
}

void Entity::TurnEntity(float x,float y,float z,int glob){
	if (x != 0) {MQ_Turn(x, 1, 0, 0, glob);}
	if (y != 0) {MQ_Turn(y, 0, 1, 0, glob);}
	if (z != 0) {MQ_Turn(z, 0, 0, 1, glob);}
	MQ_Update();

}

void Entity::PointEntity(Entity* target_ent,float roll){
	float x=target_ent->EntityX(true);
	float y=target_ent->EntityY(true);
	float z=target_ent->EntityZ(true);

	float xdiff=this->EntityX(true)-x;
	float ydiff=-(this->EntityY(true)-y);
	float zdiff=this->EntityZ(true)-z;

	float dist22=sqrt((xdiff*xdiff)+(zdiff*zdiff));
	float pitch=atan2deg(ydiff,dist22);
	float yaw=atan2deg(xdiff,-zdiff);

	this->RotateEntity(pitch,yaw,roll,true);

}

float Entity::EntityX(int global){
	if(global==false){
		return px;
	}else{
		return mat.grid[3][0];
	}
}

float Entity::EntityY(int global){
	if(global==false){
		return py;
	}else{
		return mat.grid[3][1];
	}
}

float Entity::EntityZ(int global){
	if(global==false){
		return pz;
	}else{
		return -mat.grid[3][2];
	}
}

float Entity::EntityPitch(int global){
	if(global==true){
		if(parent != 0){
			Entity* ent=this;
			Matrix m;
			m.Overwrite(rotmat);
			do{
				m.Multiply2(parent->rotmat);
				ent=ent->parent;
			}while(ent->parent);
			return m.GetPitch();
		}

	}
	return rotmat.GetPitch();
}

float Entity::EntityYaw(int global){
	if(global==true){
		if(parent != 0){
			Entity* ent=this;
			Matrix m;
			m.Overwrite(rotmat);
			do{
				m.Multiply2(parent->rotmat);
				ent=ent->parent;
			}while(ent->parent);
			return m.GetYaw();
		}

	}
	return rotmat.GetYaw();
}

float Entity::EntityRoll(int global){
	if(global==true){
		if(parent != 0){
			Entity* ent=this;
			Matrix m;
			m.Overwrite(rotmat);
			do{
				m.Multiply2(parent->rotmat);
				ent=ent->parent;
			}while(ent->parent);
			return m.GetRoll();
		}

	}
	return rotmat.GetRoll();
}

float Entity::EntityScaleX(int glob){
	if(glob==true){
		if(parent != 0){
			Entity* ent=this;
			float x=sx;
			do{
				x=x*ent->parent->sx;
				ent=ent->parent;
			}while(ent->parent);
			return x;
		}
	}
	return sx;
}

float Entity::EntityScaleY(int glob){
	if(glob==true){
		if(parent != 0){
			Entity* ent=this;
			float y=sy;
			do{
				y=y*ent->parent->sy;
				ent=ent->parent;
			}while(ent->parent);
			return y;
		}
	}
	return sy;
}

float Entity::EntityScaleZ(int glob){
	if(glob==true){
		if(parent != 0){
			Entity* ent=this;
			float z=sz;
			do{
				z=z*ent->parent->sz;
				ent=ent->parent;
			}while(ent->parent);
			return z;
		}
	}
	return sz;
}

// material
void Entity::EntityColor(float r,float g,float b,float a,int recursive){
	brush.red  =r/255.0;
	brush.green=g/255.0;
	brush.blue =b/255.0;
	brush.alpha=a;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityColor(r,g,b,a,true);
		}
	}
}

void Entity::EntityColor(float r,float g,float b,int recursive){
	brush.red  =r/255.0;
	brush.green=g/255.0;
	brush.blue =b/255.0;

	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityColor(r,g,b,true);
		}
	}
}

void Entity::EntityRed(float r,int recursive){
	brush.red=r/255.0;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityRed(r,true);
		}
	}
}

void Entity::EntityGreen(float g,int recursive){
	brush.green=g/255.0;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityGreen(g,true);
		}
	}
}

void Entity::EntityBlue(float b,int recursive){
	brush.blue=b/255.0;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityBlue(b,true);
		}
	}
}

void Entity::EntityAlpha(float a,int recursive){
	brush.alpha=a;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityAlpha(a,true);
		}
	}
}

void Entity::EntityShininess(float s,int recursive){
	brush.shine=s;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityShininess(s,true);
		}
	}
}

void Entity::EntityBlend(int blend_no,int recursive){
	brush.blend=blend_no;
	if(dynamic_cast<Mesh*>(this)){
		Mesh* mesh=dynamic_cast<Mesh*>(this);
		// overwrite surface blend modes with master blend mode
		list<Surface*>::iterator it;
		for(it=mesh->surf_list.begin();it!=mesh->surf_list.end();it++){
			Surface &surf=**it;
			//if(surf.brush!=NULL){
			surf.brush->blend=brush.blend;
			//}
		}
	}

	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityBlend(blend_no,true);
		}
	}
}

void Entity::EntityFX(int fx_no,int recursive){
	brush.fx=fx_no;
	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityFX(fx_no,true);
		}
	}
}

void Entity::EntityTexture(Texture* texture,int frame,int index,int recursive){
	brush.tex[index]=texture;
	brush.cache_frame[index]=texture->texture;
	if(index+1>brush.no_texs)
	  brush.no_texs=index+1;

	if (texture->no_frames>2){
		if(frame<0) frame=0;
		if(frame>texture->no_frames-1) frame=texture->no_frames-1;
		brush.cache_frame[index]=texture->frames[frame];
    // brush.tex[index]=texture;
	}

	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityTexture(texture,frame,index,true);
		}
	}
}

void Entity::PaintEntity(Brush& bru,int recursive){
	brush.no_texs=bru.no_texs;
	brush.name=bru.name;
	brush.red=bru.red;
	brush.green=bru.green;
	brush.blue=bru.blue;
	brush.alpha=bru.alpha;
	brush.shine=bru.shine;
	brush.blend=bru.blend;
	brush.fx=bru.fx;
	for(int i=0;i<=7;i++){
		brush.tex[i]=bru.tex[i];
		brush.cache_frame[i]=bru.cache_frame[i];
	}
}

Brush* Entity::GetEntityBrush(){
	return brush.Copy();
}

// visibility
void Entity::EntityOrder(int order_no,int recursive){
	order=order_no;
	if(recursive==true){
  	list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityOrder(order,true);
		}
	}
}

void Entity::ShowEntity(){
	hide=false;
}

void Entity::HideEntity(){
	hide=true;
}

int Entity::Hidden(){
	if(hide==true)
	  return true;

	Entity* ent=parent;
	while(ent){
		if(ent->hide==true) return true;
		ent=ent->parent;
	}
	return false;
}

// properties
void Entity::NameEntity(string e_name){
	name=e_name;
}

string Entity::EntityName(){
	return name;
}

string Entity::EntityClass(){
	return class_name;
}

// anim
void Entity::Animate(int mode,float speed,int seq,int trans){
	anim_mode=mode;
	anim_speed=speed;
	anim_seq=seq;
	anim_trans=trans;
	anim_time=anim_seqs_first[seq];
	anim_update=true; // update anim for all modes (including 0)

	if(trans>0){
		anim_time=0;
	}

	// add to animate list if not already in list
	if(anim_list==false){
		anim_list=true;
		animate_list.push_back(this);
	}

}

void Entity::SetAnimTime(float time,int seq){

	anim_mode=-1; // use a mode of -1 for setanimtime
	anim_speed=0.0;
	anim_seq=seq;
	anim_trans=0;
	anim_time=time;
	anim_update=false; // set anim_update to false so UpdateWorld won't animate entity

	int first=anim_seqs_first[anim_seq];
	int last=anim_seqs_last[anim_seq];
	int first2last=anim_seqs_last[anim_seq]-anim_seqs_first[anim_seq];

	time=time+first; // offset time so that anim time of 0 will equal first frame of sequence

	if(time>last && first2last>0){ // check that first2last>0 to prevent infinite loop
		do{
			time=time-first2last;
		}while(time>last);
	}
	if(time<first && first2last>0){ // check that first2last>0 to prevent infinite loop
		do{
			time=time+first2last;
		}while(time<first);
	}

	if(dynamic_cast<Mesh*>(this)!=NULL){
		Animation::AnimateMesh(dynamic_cast<Mesh*>(this),time,first,last);
	}

	anim_time=time; // update anim_time# to equal time#

}

int Entity::AnimLength(){

	return anim_seqs_last[anim_seq]-anim_seqs_first[anim_seq]; // no of frames in anim sequence

}

float Entity::AnimTime(){
	if (anim_trans>0) return 0;

	// for animate and setanimtime we want to return anim_time starting from 0 and ending at no. of frames in sequence
	if (anim_mode!=0){
		return anim_time-anim_seqs_first[anim_seq];
	}

	return 0;

}


int Entity::ExtractAnimSeq(int first_frame,int last_frame,int seq){

	no_seqs=no_seqs+1;

	// expand anim_seqs array
	anim_seqs_first.push_back(0);
	anim_seqs_last.push_back(0);

	// if seq specifed then extract anim sequence from within existing sequnce
	int offset=0;
	if(seq!=0){
		offset=anim_seqs_first[seq];
	}

	anim_seqs_first[no_seqs]=first_frame+offset;
	anim_seqs_last[no_seqs]=last_frame+offset;

	return no_seqs;

}

int Entity::LoadAnimSeq(string filename){
	// mesh that we will load anim seq from
	Mesh* mesh=LoadAnimB3D(filename);
	if (anim==false || mesh->anim==false){	//' mesh or self contains no anim data
		mesh->FreeEntity();
		return 0; 
	}
	no_seqs=no_seqs+1;

	// expand anim_seqs array
	anim_seqs_first.push_back(0);
	anim_seqs_last.push_back(0);

	// update anim_seqs array
	anim_seqs_first[no_seqs]=anim_seqs_last[0];
	anim_seqs_last[no_seqs]=anim_seqs_last[0]+mesh->anim_seqs_last[0];

	// update anim_seqs_last[0] - sequence 0 is for all frames, so this needs to be increased
	// must be done after updating anim_seqs array above
	anim_seqs_last[0]=anim_seqs_last[0]+mesh->anim_seqs_last[0];

	if (mesh){
		// go through all bones belonging to self

		vector<Bone*>::iterator it;

		Mesh* m1=dynamic_cast<Mesh*>(this);
		for(it=m1->bones.begin();it!=m1->bones.end();it++){

			Bone& bone=**it;

			// find bone in mesh that matches bone in self - search based on bone name
			Bone* mesh_bone=dynamic_cast<Bone*>(mesh->FindChild(bone.name));

			if (mesh_bone){
				// resize self arrays first so the one empty element at the end is removed
				bone.keys->flags.pop_back();
				bone.keys->px.pop_back();
				bone.keys->py.pop_back();
				bone.keys->pz.pop_back();
				bone.keys->sx.pop_back();
				bone.keys->sy.pop_back();
				bone.keys->sz.pop_back();
				bone.keys->qw.pop_back();
				bone.keys->qx.pop_back();
				bone.keys->qy.pop_back();
				bone.keys->qz.pop_back();

				// add mesh bone key arrays to self bone key arrays
				bone.keys->frames=anim_seqs_last[0];
				bone.keys->flags.insert(bone.keys->flags.end(),mesh_bone->keys->flags.begin(),mesh_bone->keys->flags.end());
				bone.keys->px.insert(bone.keys->px.end(), mesh_bone->keys->px.begin(), mesh_bone->keys->px.end());
				bone.keys->py.insert(bone.keys->py.end(), mesh_bone->keys->py.begin(), mesh_bone->keys->py.end());
				bone.keys->pz.insert(bone.keys->pz.end(), mesh_bone->keys->pz.begin(), mesh_bone->keys->pz.end());
				bone.keys->sx.insert(bone.keys->sx.end(), mesh_bone->keys->sx.begin(), mesh_bone->keys->sx.end());
				bone.keys->sy.insert(bone.keys->sy.end(), mesh_bone->keys->sy.begin(), mesh_bone->keys->sy.end());
				bone.keys->sz.insert(bone.keys->sz.end(), mesh_bone->keys->sz.begin(), mesh_bone->keys->sz.end());
				bone.keys->qw.insert(bone.keys->qw.end(), mesh_bone->keys->qw.begin(), mesh_bone->keys->qw.end());
				bone.keys->qx.insert(bone.keys->qx.end(), mesh_bone->keys->qx.begin(), mesh_bone->keys->qx.end());
				bone.keys->qy.insert(bone.keys->qy.end(), mesh_bone->keys->qy.begin(), mesh_bone->keys->qy.end());
				bone.keys->qz.insert(bone.keys->qz.end(), mesh_bone->keys->qz.begin(), mesh_bone->keys->qz.end());
			}
		}
	}
	mesh->FreeEntity();
	return no_seqs;
}

void Entity::SetAnimKey(float frame, int pos_key, int rot_key, int scale_key){
	if(dynamic_cast<Mesh*>(this)){
		if (anim==1){			//Bone based animation

			Mesh* mesh=dynamic_cast<Mesh*>(this);
			vector<Bone*>::iterator it;

			int iframe=frame;

			for(it=mesh->bones.begin();it!=mesh->bones.end();it++){

				Bone& bone=**it;
				bone.keys->flags[iframe]=0;

				if (rot_key){
					bone.keys->flags[iframe] |= 4;
					float q1_x, q1_y, q1_z, q1_w;
					bone.rotmat.ToQuat(q1_x, q1_y, q1_z, q1_w);
					bone.keys->qw[iframe]=-q1_w;
					bone.keys->qx[iframe]=q1_x;
					bone.keys->qy[iframe]=q1_y;
					bone.keys->qz[iframe]=q1_z;
				}

				if (pos_key){
					bone.keys->flags[iframe] |= 1;
					bone.keys->px[iframe]=bone.px;
					bone.keys->py[iframe]=bone.py;
					bone.keys->pz[iframe]=-bone.pz;
				}

				if (scale_key){
					bone.keys->flags[iframe] |= 2;
					bone.keys->sx[iframe]=bone.sx;
					bone.keys->sy[iframe]=bone.sy;
					bone.keys->sz[iframe]=bone.sz;
				}
			}



		}
		else if (anim==2){		//Vertex based animation

			Mesh* mesh=dynamic_cast<Mesh*>(this);

			list<Surface*>::iterator surf_it;
			surf_it=mesh->surf_list.begin();

			list<Surface*>::iterator anim_surf_it;


			// cycle through all surfs
			for(anim_surf_it=mesh->anim_surf_list.begin();anim_surf_it!=mesh->anim_surf_list.end();anim_surf_it++){

				Surface& anim_surf=**anim_surf_it;

				Surface& surf=**surf_it;

				unsigned int t=anim_surf.vert_weight4.size();

				for(unsigned int i=0;i<=anim_surf.vert_weight4.size();i++){
					if (anim_surf.vert_weight4[i]>=frame){
						t=i;
						break;
					}
				}
				anim_surf.vert_weight4.insert(anim_surf.vert_weight4.begin()+t, frame);

				t*=anim_surf.no_verts*3;

				for(int i=0;i<anim_surf.no_verts;i++){
					float x=surf.vert_coords[i*3];
					float y=surf.vert_coords[i*3+1];
					float z=surf.vert_coords[i*3+2];
					if (pos_key){
						x+=px;
						y+=py;
						z-=pz;
					}
					if (scale_key){
						x*=sx;
						y*=sy;
						z*=sz;
					}
					if (rot_key){
						rotmat.TransformVec(x,y,z);
					}
					surf.vert_coords.insert(surf.vert_coords.begin()+i*3+t, x);
					surf.vert_coords.insert(surf.vert_coords.begin()+i*3+1+t, y);
					surf.vert_coords.insert(surf.vert_coords.begin()+i*3+2+t, z);

				}
				surf_it++;

			}
		}
	}

}

int Entity::AddAnimSeq(int length){

	if (anim==false){
		if(dynamic_cast<Mesh*>(this)){

			Mesh* mesh=dynamic_cast<Mesh*>(this);

			anim=2;
			anim_render=true;

			//mesh->frames=a_frames
			anim_seqs_first[0]=0;
			anim_seqs_last[0]=length;

			// create anim surfs, copy vertex coords array, add to anim_surf_list

			list<Surface*>::iterator it;


			for(it=mesh->surf_list.begin();it!=mesh->surf_list.end();it++){
				Surface& surf=**it;

				Surface* anim_surf=new Surface();

				mesh->anim_surf_list.push_back(anim_surf);
				anim_surf->no_verts=surf.no_verts;

				//First frame
				anim_surf->vert_coords=surf.vert_coords;
				anim_surf->vert_weight4.push_back(0);

				//Last frame
				surf.vert_coords.insert(surf.vert_coords.end(), anim_surf->vert_coords.begin(),anim_surf->vert_coords.end());
				anim_surf->vert_weight4.push_back(length);

				/*anim_surf->vert_bone1_no.resize(surf.no_verts+1);
				anim_surf->vert_bone2_no.resize(surf.no_verts+1);
				anim_surf->vert_bone3_no.resize(surf.no_verts+1);
				anim_surf->vert_bone4_no.resize(surf.no_verts+1);
				anim_surf->vert_weight1.resize(surf.no_verts+1);
				anim_surf->vert_weight2.resize(surf.no_verts+1);
				anim_surf->vert_weight3.resize(surf.no_verts+1);
				anim_surf->vert_weight4.resize(surf.no_verts+1);*/

				// transfer vmin/vmax values for using with TrimVerts func after
				anim_surf->vmin=surf.vmin;
				anim_surf->vmax=surf.vmax;
			}
		}

	}else{
		no_seqs=no_seqs+1;

		// expand anim_seqs array
		anim_seqs_first.push_back(anim_seqs_last[0]);
		anim_seqs_last.push_back(anim_seqs_last[0]+length);

		anim_seqs_last[0]=anim_seqs_last[0]+length;

		if (anim==1){			//Bone based animation
			Mesh* mesh=dynamic_cast<Mesh*>(this);
			vector<Bone*>::iterator it;

			for(it=mesh->bones.begin();it!=mesh->bones.end();it++){

				Bone& bone=**it;
				bone.keys->frames=anim_seqs_last[0];;
				bone.keys->flags.resize(anim_seqs_last[0]+1);
				bone.keys->px.resize(anim_seqs_last[0]+1);
				bone.keys->py.resize(anim_seqs_last[0]+1);
				bone.keys->pz.resize(anim_seqs_last[0]+1);
				bone.keys->sx.resize(anim_seqs_last[0]+1);
				bone.keys->sy.resize(anim_seqs_last[0]+1);
				bone.keys->sz.resize(anim_seqs_last[0]+1);
				bone.keys->qw.resize(anim_seqs_last[0]+1);
				bone.keys->qx.resize(anim_seqs_last[0]+1);
				bone.keys->qy.resize(anim_seqs_last[0]+1);
				bone.keys->qz.resize(anim_seqs_last[0]+1);


			}

		}else if (anim==2){		//Vertex based animation

			Mesh* mesh=dynamic_cast<Mesh*>(this);
			list<Surface*>::iterator it;

			for(it=mesh->anim_surf_list.begin();it!=mesh->anim_surf_list.end();it++){
				Surface& anim_surf=**it;

				anim_surf.vert_weight4.back()=anim_seqs_last[0];
			}
		}

	}
	return no_seqs;
}

// collision
void Entity::EntityType(int type_no,int recursive){

	// if type_no is negative, collision checking is dynamic
	if (type_no<0){
		type_no=-type_no;
		dynamic=true;
	}

	// add to collision entity list if new type no<>0 and not previously added
	if(collision_type==0 && type_no!=0){
		CollisionPair::ent_lists[type_no].push_back(this);
	}

	// remove from collision entity list if new type no=0 and previously added
	if(collision_type!=0 && type_no==0){
		CollisionPair::ent_lists[type_no].remove(this);
	}

	collision_type=type_no;

	old_x=EntityX(true);
	old_y=EntityY(true);
	old_z=EntityZ(true);

	if(recursive==true){
		list<Entity*>::iterator it;
		for(it=child_list.begin();it!=child_list.end();it++){
			Entity& ent=**it;
			ent.EntityType(type_no,true);
		}
	}
}

int Entity::GetEntityType(){
	return collision_type;
}

void Entity::EntityRadius(float rx,float ry){
	radius_x=rx;
	if(ry==0.0){
		radius_y=rx;
	}else{
		radius_y=ry;
	}
}

void Entity::EntityBox(float x,float y,float z,float w,float h,float d){
	box_x=x;
	box_y=y;
	box_z=z;
	box_w=w;
	box_h=h;
	box_d=d;
}

void Entity::ResetEntity(){
	no_collisions=0;
	for(unsigned int ix=0;ix<collision.size();ix++){
		delete collision[ix];
	}
	collision.clear();

	old_x=EntityX(true);
	old_y=EntityY(true);
	old_z=EntityZ(true);
}

Entity* Entity::EntityCollided(int type_no){

	// if self is source entity and type_no is dest entity
	for(int i=1;i<=CountCollisions();i++){
		if(CollisionEntity(i)->collision_type==type_no) return CollisionEntity(i);
	}

	// if self is dest entity and type_no is src entity
	list<Entity*>::iterator it;

	for(it=CollisionPair::ent_lists[type_no].begin();it!=CollisionPair::ent_lists[type_no].end();it++){
		Entity* ent=*it;
		for(int i=1;i<=ent->CountCollisions();i++){
			if(CollisionEntity(i)==this) return ent;
		}
	}
	return NULL;
}

int Entity::CountCollisions(){
	return no_collisions;
}

float Entity::CollisionX(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->x;
	}
	return 0.0;
}

float Entity::CollisionY(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->y;
	}
	return 0.0;
}

float Entity::CollisionZ(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->z;
	}
	return 0.0;
}

float Entity::CollisionNX(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->nx;
	}
	return 0.0;
}

float Entity::CollisionNY(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->ny;
	}
	return 0.0;
}

float Entity::CollisionNZ(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->nz;
  }
	return 0.0;
}

float Entity::CollisionTime(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->time;
	}
	return 0.0;
}

Entity* Entity::CollisionEntity(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->ent;
	}
	return NULL;
}

Surface* Entity::CollisionSurface(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->surf;
	}
	return NULL;
}

int Entity::CollisionTriangle(int index){
	if(index>0 && index<=no_collisions){
		return collision[index-1]->tri;
	}
	return 0;
}

// picking
void Entity::EntityPickMode(int no,int obscure){
	// add to pick entity list if new mode no<>0 and not previously added
	if( (pick_mode==0) && (no!=0)){
		Pick::ent_list.push_back(this);
	}

	// remove from pick entity list if new mode no=0 and previously added
	if( (pick_mode!=0) && (no==0)){
		Pick::ent_list.remove(this);
	}
	pick_mode=no;
	obscurer=obscure;
}

// distance
float Entity::EntityDistance(Entity* ent2){
	return sqrt(EntityDistanceSquared(ent2));
}


float Entity::DeltaYaw(Entity* ent2){
	float x=ent2->EntityX(true)-this->EntityX(true);
	//float y=ent2->EntityY(true)-this->EntityY(true);
	float z=ent2->EntityZ(true)-this->EntityZ(true);
	return -atan2deg(x,z)-EntityYaw(true);
}

float Entity::DeltaPitch(Entity* ent2){
	float x=ent2->EntityX(true)-this->EntityX(true);
	float y=ent2->EntityY(true)-this->EntityY(true);
	float z=ent2->EntityZ(true)-this->EntityZ(true);
	return -atan2deg(-y,sqrt(x*x+z*z))-EntityPitch(true);
}

void Entity::AlignToVector(float x,float y,float z, int axis=3, float rate=1){
	if (axis<1 || axis>3)
	  return;

	Matrix m;

	//normalize
	float dd = sqrt( x*x + y*y + z*z );
	if (dd < 0.000001)
	  return;

	x = x / dd;
	y = y / dd;
	z = z / dd;

	//get original axis
	float ax = (axis==1);
	float ay = (axis==2);
	float az = (axis==3);
	TFormNormal (ax, ay, az, this, 0);
	ax =  TFormedX();
	ay =  TFormedY();
	az =  TFormedZ();

 	//get transformation matrix from org. axis to new one
	m.FromToRotation(ax,ay,-az, x,y,-z);

	//interpolate
	if (rate < 1.0){
		InterpolateMatrix(m, m, rate);
	}

     //apply matrix
	this->rotmat.Multiply2(m);
	this->MQ_Update();


}


// tform
void Entity::TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent){
	//Matrix mat1;
	Matrix mat2;

	/*if(src_ent != 0){
		src_ent->MQ_GetMatrix(mat1);
	}*/

	if(dest_ent != 0){
		dest_ent->MQ_GetInvMatrix(mat2);
	}

	if (dest_ent != 0) {mat2.TransformVec(x, y, z, 1);}//global to mesh
	if (src_ent  != 0) {src_ent->mat.TransformVec(x, y, z, 1);}//mesh to global

	tformed_x=x;
	tformed_y=y;
	tformed_z=z;

}

void Entity::TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent){

	Matrix mat1;
	Matrix mat2;

	//get src matrix
	if(src_ent != 0){
		//src_ent->MQ_GetMatrix(mat1);
		mat1.Overwrite(src_ent->mat);
		mat1.grid[3][0] = 0; //remove translation
		mat1.grid[3][1] = 0;
		mat1.grid[3][2] = 0;
	}

	//get dest matrix
	if(dest_ent != 0){
		dest_ent->MQ_GetInvMatrix(mat2);
		mat2.grid[3][0] = 0; //remove translation
		mat2.grid[3][1] = 0;
		mat2.grid[3][2] = 0;
	}

	//transform point by matrix
	if (dest_ent != 0) {mat2.TransformVec(x, y, z, 1);}//global to mesh
	if (src_ent  != 0) {mat1.TransformVec(x, y, z, 1);}//mesh to global

	tformed_x=x;
	tformed_y=y;
	tformed_z=z;
}

void Entity::TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent){
	TFormVector(x,y,z,src_ent,dest_ent);
	float uv=sqrt((tformed_x*tformed_x)+(tformed_y*tformed_y)+(tformed_z*tformed_z));
	tformed_x/=uv;
	tformed_y/=uv;
	tformed_z/=uv;
}

float Entity::TFormedX(){
	return tformed_x;
}

float Entity::TFormedY(){
	return tformed_y;
}

float Entity::TFormedZ(){
	return tformed_z;
}

// helper funcs
/*void Entity::UpdateMat(bool load_identity){
	MQ_Update();
}*/

void Entity::UpdateMat(bool load_identity){
	
	if (load_identity==true){
		mat.LoadIdentity();
		MQ_Update();
		//mat.Translate(px,py,pz);
		//mat.Rotate(rx,ry,rz);
		//mat.Scale(sx,sy,sz);
	}else{
		MQ_Update();
		//mat.Translate(px,py,pz);
		//mat.Rotate(rx,ry,rz);
		//mat.Scale(sx,sy,sz);
	}
	
}

void Entity::AddParent(Entity &parent_ent){
	// self.parent = parent_ent
	parent=&parent_ent;

	//add self to parent_ent child list
	if(parent!=NULL){
		mat.Overwrite(parent->mat);
		parent->child_list.push_back(this);
	}else{
		Global::root_ent->child_list.push_back(this);
	}
}

void Entity::UpdateChildren(Entity* ent_p){
	list<Entity*>::iterator it;
	for(it=ent_p->child_list.begin();it!=ent_p->child_list.end();it++){
		Entity* p=*it;
		//p->mat.Overwrite(ent_p->mat);
		p->MQ_Update();
		//UpdateChildren(p);//fixes
	}
}

float Entity::EntityDistanceSquared(Entity* ent2){
	float xd = ent2->mat.grid[3][0]-mat.grid[3][0];
	float yd = ent2->mat.grid[3][1]-mat.grid[3][1];
	float zd = -ent2->mat.grid[3][2]+mat.grid[3][2];
	return xd*xd + yd*yd + zd*zd;
}

void Entity::MQ_GetInvMatrix(Matrix &mat0){
	Matrix mat3;
	mat3.LoadIdentity();
	Matrix mat2;
	mat2.LoadIdentity();
	Matrix mat1;

	if (parent != 0) {
		//transform by parent matrix
		parent->MQ_GetInvMatrix(mat0);
	}else{
		mat0.LoadIdentity();
	}


	//get inverted rotation matrix
	mat1.Overwrite(rotmat);
	mat1.Transpose();

	//scale
	if (sx != 0 && sy != 0 && sz != 0) {mat3.Scale(1 / sx, 1 / sy, 1 / sz);}
	//position
	mat2.SetTranslate(-px,-py, pz);

	//combine
	mat1.Multiply2(mat3);
	mat2.Multiply2(mat1);
	mat0.Multiply2(mat2);

	return;
}

void Entity::MQ_GetMatrix(Matrix &mat3){
	mat3.LoadIdentity();
	Matrix mat2;
	mat2.LoadIdentity();
	//Matrix mat1;
	//float ipz;

	//scale
	mat3.Scale(sx, sy, sz);
	//position
	mat2.SetTranslate(px, py, -pz);
	//rotation
	//mat1.Overwrite(rotmat);

	mat3.Multiply2(rotmat);
	mat3.Multiply2(mat2);

	if (parent != 0) {
		//transform by parent matrix
		/*Matrix m;
		parent->MQ_GetMatrix(m, scale);*/
		mat3.Multiply2(parent->mat);
	}

	return;

}

void Entity::MQ_Turn( float ang, float vx, float vy, float vz, int glob ){
	float q1_x, q1_y, q1_z, q1_w;
	Quaternion_FromAngleAxis( ang, vx,vy,vz, q1_x, q1_y, q1_z, q1_w ); //create quaternion
	Matrix m;
	m.LoadIdentity();
	m.FromQuaternion(q1_x, q1_y, q1_z, q1_w); //convert to matrix
	if (glob != 0){
		rotmat.Multiply2(m);//apply internal matrix to new matrix
	}else{
		m.Multiply2(rotmat);//apply new matrix to internal matrix
		rotmat.Overwrite(m);//'MatOverwrite(mat, m)
	}
}

void Entity::MQ_GetScaleXYZ(float &width, float &height, float &depth){
	Matrix m;

	MQ_GetMatrix(m);

	float xx=1,xy=0,xz=0;
	float yx=0,yy=1,yz=0;
	float zx=0,zy=0,zz=1;

	m.TransformVec(xx,xy,xz);
	m.TransformVec(yx,yy,yz);
	m.TransformVec(zx,zy,zz);

	width  = sqrt((xx*xx)+(xy*xy)+(xz*xz));
	height = sqrt((yx*yx)+(yy*yy)+(yz*yz));
	depth  = sqrt((zx*zx)+(zy*zy)+(zz*zz));

}

void Entity::MQ_ApplyNewtonTransform( const float* newtonMatrix ){
	
		/* Overwrite the entity matrix with 'inputMatrix' from Newton.
		 * Hopefully this works straight away. */

		memcpy( mat.grid, newtonMatrix, 64 );
		
		//mat.Overwrite( inputMatrix );
		//memcpy( mat.grid, &inputMatrix, 64 );
		
		/* Update the px,py,pz and sx,sy,sz and rotmat properties.
		 * We shouldn't use the PositionEntity etc. functions because they call
		 * for MQ_Update() and it could mess with this overwriting process. */
		
		/* px, py, pz.
		 * These seem to be the local position of the entity, in other words
		 * the position of the entity considering its parent as the origin. */
		
		float tempPX, tempPY, tempPZ;
		tempPX = mat.grid[3][0];
		tempPY = mat.grid[3][1];
		tempPZ = mat.grid[3][2];
		if ( parent != NULL )
			parent->mat.TransformVec( tempPX, tempPY, tempPZ, 1 ); // Taken from TFormPoint.
		px	= tempPX;
		py	= tempPY;
		pz	= -tempPZ; // Not sure if the Z flipping is necessary, need to test.

// ----------------------------------------------------------------------------
// Not needed? Possibly need to re-enable for scaling entities... no FPS change
// ----------------------------------------------------------------------------

		/* sx, sy, sz.
		 * Code taken from MQ_GetScaleXYZ.
		 * Maybe it's not even necessary to retrieve these, since the scale
		 * of the entity is not expected to change during the game\simulation.
		 * Later, test commenting this part and seeing if it still works. */

/*
		float xx=1.0, xy=0.0, xz=0.0;
		float yx=0.0, yy=1.0, yz=0.0;
		float zx=0.0, zy=0.0, zz=1.0;

		mat.TransformVec(xx,xy,xz);
		mat.TransformVec(yx,yy,yz);
		mat.TransformVec(zx,zy,zz);

		sx = sqrt((xx*xx)+(xy*xy)+(xz*xz));
		sy = sqrt((yx*yx)+(yy*yy)+(yz*yz));
		sz = sqrt((zx*zx)+(zy*zy)+(zz*zz));
*/
		
		/* rotmat.
		 * It seems to be a Matrix object with just rotation vectors (no scale).
		 * Since we know the scale of the vectors from the previous step we can
		 * divide the rotation vectors by that to get clean 1.0 length vectors, but
		 * this might introduce some imprecision. 		
		 * This part should work even if you comment the previous one out. */
	
/*
		// Pitch (X vector).
		if ( sx != 0.0 )
		{
			rotmat.grid[0][0] = mat.grid[0][0] / sx;
			rotmat.grid[0][1] = mat.grid[0][1] / sx;
			rotmat.grid[0][2] = mat.grid[0][2] / sx;
		}
		// Yaw (Y vector).
		if ( sy != 0.0 )
		{
			rotmat.grid[1][0] = mat.grid[1][0] / sy;
			rotmat.grid[1][1] = mat.grid[1][1] / sy;
			rotmat.grid[1][2] = mat.grid[1][2] / sy;
		}
		// Roll (Z vector).
		if ( sz != 0.0 )
		{
			rotmat.grid[2][0] = mat.grid[2][0] / sz;
			rotmat.grid[2][1] = mat.grid[2][1] / sz;
			rotmat.grid[2][2] = mat.grid[2][2] / sz;
		}
*/

// ----------------------------------------------------------------------------

}

void Entity::MQ_Update(){
	MQ_GetMatrix(mat);

	//update child_list
	list<Entity*>::iterator it;

	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->MQ_Update();
	}
}
