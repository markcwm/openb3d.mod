/*
 *  pivot.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "pivot.h"
#include "pick.h"

Pivot* Pivot::CopyEntity(Entity* parent_ent){

	if(parent_ent==NULL) parent_ent=Global::root_ent;

	// new piv
	Pivot* piv=new Pivot;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(piv);
	}
	
	// lists
	
	// add parent, add to list
	piv->AddParent(*parent_ent);
	entity_list.push_back(piv);
	
	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(piv);
	}
	
	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(piv);
	}
	
	// update matrix
	if(piv->parent){
		piv->mat.Overwrite(piv->parent->mat);
	}else{
		piv->mat.LoadIdentity();
	}
	
	// copy entity info
	
	piv->mat.Multiply(mat);
	
	piv->px=px;
	piv->py=py;
	piv->pz=pz;
	piv->sx=sx;
	piv->sy=sy;
	piv->sz=sz;
	piv->rx=rx;
	piv->ry=ry;
	piv->rz=rz;
	piv->qw=qw;
	piv->qx=qx;
	piv->qy=qy;
	piv->qz=qz;

	piv->name=name;
	piv->class_name=class_name;
	piv->order=order;
	piv->hide=false;
	
	piv->cull_radius=cull_radius;
	piv->radius_x=radius_x;
	piv->radius_y=radius_y;
	piv->box_x=box_x;
	piv->box_y=box_y;
	piv->box_z=box_z;
	piv->box_w=box_w;
	piv->box_h=box_h;
	piv->box_d=box_d;
	piv->pick_mode=pick_mode;
	piv->obscurer=obscurer;

	return piv;
	
}

void Pivot::FreeEntity(){

	Entity::FreeEntity();
	
	delete this;
	
	return;

}

Pivot* Pivot::CreatePivot(Entity* parent_ent){

	if(parent_ent==NULL) parent_ent=Global::root_ent;

	Pivot* piv=new Pivot;
	piv->class_name="Pivot";
		
	piv->AddParent(*parent_ent);
	entity_list.push_back(piv);

	// update matrix
	if(piv->parent!=NULL){
		piv->mat.Overwrite(piv->parent->mat);
		piv->UpdateMat();
	}else{
		piv->UpdateMat(true);
	}
	
	return piv;

}

void Pivot::Update(){

}
