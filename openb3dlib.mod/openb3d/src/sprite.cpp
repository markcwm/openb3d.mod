/*
 *  sprite.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "sprite.h"

#include "entity.h"
#include "surface.h"
#include "pick.h"
#include "texture.h"

Sprite* Sprite::NewSprite(){
	Sprite* spr=new Sprite();
	return spr;
}

Sprite* Sprite::CopyEntity(Entity* parent_ent){

	// new sprite
	Sprite* sprite=new Sprite;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(sprite);
	}

	// lists

	// add parent, add to list
	sprite->AddParent(parent_ent);
	entity_list.push_back(sprite);

	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(sprite);
	}

	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(sprite);
	}

	// update matrix
	if(sprite->parent){
		sprite->mat.Overwrite(sprite->parent->mat);
	}else{
		sprite->mat.LoadIdentity();
	}

	// copy entity info

	sprite->mat.Multiply(mat);

	sprite->px=px;
	sprite->py=py;
	sprite->pz=pz;
	sprite->sx=sx;
	sprite->sy=sy;
	sprite->sz=sz;
	sprite->rx=rx;
	sprite->ry=ry;
	sprite->rz=rz;
	sprite->qw=qw;
	sprite->qx=qx;
	sprite->qy=qy;
	sprite->qz=qz;

	sprite->name=name;
	sprite->class_name=class_name;
	sprite->order=order;
	sprite->hide=false;

	sprite->brush=brush;

	sprite->cull_radius=cull_radius;
	sprite->radius_x=radius_x;
	sprite->radius_y=radius_y;
	sprite->box_x=box_x;
	sprite->box_y=box_y;
	sprite->box_z=box_z;
	sprite->box_w=box_w;
	sprite->box_h=box_h;
	sprite->box_d=box_d;
	sprite->collision_type=collision_type;
	sprite->pick_mode=pick_mode;
	sprite->obscurer=obscurer;

	// copy mesh info

	sprite->no_surfs=no_surfs;
	sprite->surf_list=surf_list; // pointer to surf list

	// copy sprite info

	sprite->mat_sp.Overwrite(mat_sp);
	sprite->angle=angle;
	sprite->scale_x=scale_x;
	sprite->scale_y=scale_y;
	sprite->handle_x=handle_x;
	sprite->handle_y=handle_y;
	sprite->view_mode=view_mode;
	sprite->render_mode=render_mode;

	return sprite;

}

void Sprite::FreeEntity(){

	Mesh::FreeEntity();

	delete this;

	return;

}

Sprite* Sprite::CreateSprite(Entity* parent_ent){

	Sprite* sprite=new Sprite;
	sprite->class_name="Sprite";

	sprite->AddParent(parent_ent);
	Entity::entity_list.push_back(sprite);

	// update matrix
	if(sprite->parent!=NULL){
		sprite->mat.Overwrite(sprite->parent->mat);
		sprite->UpdateMat();
	}else{
		sprite->UpdateMat(true);
	}

	Surface* surf=sprite->CreateSurface();
	surf->AddVertex(-1,-1,0, 0, 1);
	surf->AddVertex(-1, 1,0, 0, 0);
	surf->AddVertex( 1, 1,0, 1, 0);
	surf->AddVertex( 1,-1,0, 1, 1);
	surf->AddTriangle(0,1,2);
	surf->AddTriangle(0,2,3);

	sprite->EntityFX(1);

	return sprite;

}

Sprite* Sprite::LoadSprite(string tex_file,int tex_flag,Entity* parent_ent){

	Sprite* sprite=CreateSprite(parent_ent);

	Texture* tex=Texture::LoadTexture(tex_file,tex_flag);
	sprite->EntityTexture(tex);

	// additive blend if sprite doesn't have alpha or masking flags set
	int x=tex_flag&2;
	int y=tex_flag&4;
	if((!x) && (!y)){
		sprite->EntityBlend(3);
	}

	return sprite;

}

void Sprite::RotateSprite(float ang){
	angle=ang;
}

void Sprite::ScaleSprite(float s_x,float s_y){
	scale_x=s_x;
	scale_y=s_y;
}

void Sprite::HandleSprite(float h_x,float h_y){
	handle_x=h_x;
	handle_y=h_y;
}

void Sprite::SpriteViewMode(int mode){
	view_mode=mode;
}

void Sprite::SpriteRenderMode(int mode){
	render_mode=mode;
}

void Sprite::SpriteTexCoords(int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set){
	float u1=float(cell_x)/float(tex_w);
	float v1=float(cell_y)/float(tex_h);
	float u2=float((cell_x+cell_w))/float(tex_w);
	float v2=float((cell_y+cell_h))/float(tex_h);
	float swap=v1;
	v1=v2;
	v2=swap;
	//cout << " U1: " << u1 << " U2: " << u2 << " V1: " << v1 << " V2: " << v2 << endl;
	Surface* surf=GetSurface(1);
	surf->VertexTexCoords(0,u1,v1,0,uv_set);
	surf->VertexTexCoords(1,u1,v2,0,uv_set);
	surf->VertexTexCoords(2,u2,v2,0,uv_set);
	surf->VertexTexCoords(3,u2,v1,0,uv_set);
}

void Sprite::SpriteVertexColor(int v,float r,float g,float b){
	Surface* surf=GetSurface(1);
	surf->VertexColor(v,r,g,b);
}
