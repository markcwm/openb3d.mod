/*
 *  bone.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "bone.h"

#include "global.h"

Bone* Bone::NewBone(){
	Bone* bone=new Bone();
	//bone->keys=new AnimationKeys();
	return bone;
}

Bone* Bone::CopyEntity(Entity* parent_ent){

	// new bone
	Bone* bone=new Bone;
	
	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(bone);
	}
	
	// add parent, add to list
	bone->AddParent(parent_ent);
	entity_list.push_back(bone);
	
	// update matrix
	if(bone->parent){
		bone->mat.Overwrite(bone->parent->mat);
	}else{
		bone->mat.LoadIdentity();
	}
	
	// copy entity info
	
	bone->mat.Multiply(mat);

	bone->px=px;
	bone->py=py;
	bone->pz=pz;
	bone->sx=sx;
	bone->sy=sy;
	bone->sz=sz;
	bone->rx=rx;
	bone->ry=ry;
	bone->rz=rz;
	bone->qw=qw;
	bone->qx=qx;
	bone->qy=qy;
	bone->qz=qz;
	
	bone->name=name;
	bone->class_name=class_name;
	bone->order=order;
	bone->hide=false;
	
	// copy bone info
	
	bone->n_px=n_px;
	bone->n_py=n_py;
	bone->n_pz=n_pz;
	bone->n_sx=n_sx;
	bone->n_sy=n_sy;
	bone->n_sz=n_sz;
	bone->n_rx=n_rx;
	bone->n_ry=n_ry;
	bone->n_rz=n_rz;
	bone->n_qw=n_qw;
	bone->n_qx=n_qx;
	bone->n_qy=n_qy;
	bone->n_qz=n_qz;

	bone->keys=keys->Copy();
	
	bone->kx=kx;
	bone->ky=ky;
	bone->kz=kz;
	bone->kqw=kqw;
	bone->kqx=kqx;
	bone->kqy=kqy;
	bone->kqz=kqz;
	
	bone->mat2=mat2;
	bone->inv_mat=inv_mat;
	bone->tform_mat=tform_mat;

	return bone;

}

void Bone::FreeEntity(){

	if (keys){
		keys->flags.clear();
		keys->px.clear();
		keys->py.clear();
		keys->pz.clear();
		keys->sx.clear();
		keys->sy.clear();
		keys->sz.clear();
		keys->qw.clear();
		keys->qx.clear();
		keys->qy.clear();
		keys->qz.clear();
		delete keys;
	}

	Entity::FreeEntity();
	
	delete this;
	
	return;

}
