/*
 *  sprite_batch.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *  
 *  Batch Sprites from Minib3d-Monkey by Adam Redwoods
 *
 */

#include "sprite_batch.h"
#include <stdio.h>

list<SpriteBatch*> SpriteBatch::sprite_batch_list;

float BatchSprite::b_min_x, BatchSprite::b_min_y, BatchSprite::b_min_z;
float BatchSprite::b_max_x, BatchSprite::b_max_y, BatchSprite::b_max_z;
vector<BatchSpriteMesh*> BatchSprite::mainsprite;
int BatchSprite::total_batch=0;
Matrix BatchSprite::temp_mat;

BatchSpriteMesh* BatchSpriteMesh::Create(Entity* parent_ent){
	
	BatchSpriteMesh* mesh=new BatchSpriteMesh;
	mesh->free_stack.push_back(0);
	
	mesh->AddParent(parent_ent);
	entity_list.push_back(mesh);
	
	// update matrix
	if(mesh->parent!=0){
		mesh->mat.Overwrite(mesh->parent->mat);
		mesh->UpdateMat();
	}else{
		mesh->UpdateMat(true);
	}
	
	mesh->surf = mesh->CreateSurface();
	mesh->surf->ClearSurface();
	//mesh->surf->vbo_dyn = true;
	mesh->num_sprites = 0;
	//mesh.free_stack = new IntStack
	mesh->EntityFX(1+2+32); // full bright + use vertex colors + alpha
	mesh->brush.shine=0.0;
	
	mesh->class_name="BatchSpriteMesh";
	//mesh->is_sprite=true; // no
	//mesh->is_update=true;
	mesh->cull_radius=-999999.0;
	
	// add invisible sprite to get camera info for batch
	mesh->cam_sprite=Sprite::CreateSprite(mesh);
	Surface* sf=dynamic_cast<Surface*>(mesh->cam_sprite->surf_list.front());
	mesh->cam_sprite->EntityFX(3+32);

	sf->VertexColor(0, 0, 0, 0, 0);
	sf->VertexColor(1, 0, 0, 0, 0);
	sf->VertexColor(2, 0, 0, 0, 0);
	sf->VertexColor(3, 0, 0, 0, 0);
	
	return mesh;
	
}

void BatchSpriteMesh::Render(){
	
	// wipe out rotation matrix
	mat.grid[0][0]=1.0; mat.grid[0][1]=0.0; mat.grid[0][2]=0.0;
	mat.grid[1][0]=0.0; mat.grid[1][1]=1.0; mat.grid[1][2]=0.0;
	mat.grid[2][0]=0.0; mat.grid[2][1]=0.0; mat.grid[2][2]=1.0;
	
	BatchSprite::b_min_x=999999999.0;
	BatchSprite::b_max_x=-999999999.0;
	BatchSprite::b_min_y=999999999.0;
	BatchSprite::b_max_y=-999999999.0;
	BatchSprite::b_min_z=999999999.0;
	BatchSprite::b_max_z=-999999999.0;
	
	list<BatchSprite*>::iterator it;
	for (it=sprite_list.begin();it!=sprite_list.end();it++){
		BatchSprite* ent=*it;
		
		ent->UpdateBatch(cam_sprite);
		surf->reset_vbo=surf->reset_vbo | 16;
	}
	
	// do our own bounds
	if (num_sprites>0){
		float width=BatchSprite::b_max_x - BatchSprite::b_min_x;
		float height=BatchSprite::b_max_y - BatchSprite::b_min_y;
		float depth=BatchSprite::b_max_z - BatchSprite::b_min_z;
		
		// get bounding sphere (cull_radius#) from AABB, only get cull radius (auto cull)
		// if cull radius hasn't been set to a negative no. by TEntity.MeshCullRadius (manual cull)
		if (width>=height && width>=depth){
			cull_radius=width;
		}else{
			if (height>=width && height>=depth)
				cull_radius=height;
			else
				cull_radius=depth;
		}
		cull_radius=cull_radius * 0.5;
		float crs=cull_radius * cull_radius;
		cull_radius=sqrt(crs + crs + crs);
		
		min_x = BatchSprite::b_min_x;
		min_y = BatchSprite::b_min_y;
		min_z = BatchSprite::b_min_z;
		max_x = BatchSprite::b_max_x;
		max_y = BatchSprite::b_max_y;
		max_z = BatchSprite::b_max_z;
		
		//if (brush.tex[0]) brush.tex[0].flags=brush.tex[0].flags | 16 | 32; // always clamp
		//if (surf.brush.tex[0]) surf.brush.tex[0].flags=surf.brush.tex[0].flags | 16 | 32; // always clamp
		
	}else{
		
		// no more sprites in batch, reduce overhead
		surf->ClearSurface();
		sprite_list.clear();
		free_stack.clear();
		//free_stack = [0]
	}
	
	Mesh::Render();
	
}

void BatchSprite::FreeEntity(){
	
	mainsprite[batch_id]->surf->VertexColor(vertex_id+0, 0, 0, 0, 0);
	mainsprite[batch_id]->surf->VertexColor(vertex_id+1, 0, 0, 0, 0);
	mainsprite[batch_id]->surf->VertexColor(vertex_id+2, 0, 0, 0, 0);
	mainsprite[batch_id]->surf->VertexColor(vertex_id+3, 0, 0, 0, 0);
	
	//mainsprite[batch_id]->free_stack.push_back(vertex_id);
	// stack push
	int st=mainsprite[batch_id]->free_stack.size();
	mainsprite[batch_id]->free_stack.resize(st+1);
	mainsprite[batch_id]->free_stack[st]=vertex_id;
	mainsprite[batch_id]->num_sprites-=1;
	
	list<BatchSprite*>::iterator it;
	for (it=mainsprite[batch_id]->sprite_list.begin();it!=mainsprite[batch_id]->sprite_list.end();it++){
		BatchSprite* ent=*it;
		if (ent==this){
			mainsprite[batch_id]->sprite_list.remove(this);
			break;
		}
	}
	
	// free self from parent's child_list
	if (parent!=NULL){
		list<Entity*>::iterator it2;
		for(it2=parent->child_list.begin();it2!=parent->child_list.end();it2++){
			Entity* ent=*it2;
			if (ent==this){
				parent->child_list.remove(this);
				break;
			}
		}
	}
	
	mat.LoadIdentity();
	//brush=NULL;
	
	Entity::FreeEntity();
	
}

void BatchSprite::BatchSpriteParent(int id, Entity* ent,int glob){
	
	if (id == 0) id = total_batch;
	if (id == 0) return;
	
	mainsprite[id]->EntityParent(ent, glob);
	
}

Entity* BatchSprite::BatchSpriteEntity(BatchSprite* batch_sprite){
	
	if (batch_sprite!=NULL) return mainsprite[batch_sprite->batch_id];
	if (mainsprite.size()>0) return mainsprite[total_batch];
	
}

void BatchSprite::BatchSpriteOrigin(float x,float y,float z){
	
	mainsprite[batch_id]->PositionEntity(x,y,z);
	
}

BatchSpriteMesh* BatchSprite::CreateBatchMesh(int batchid){
	
	while (total_batch < batchid || total_batch == 0){
		total_batch+=1;
		if (total_batch >= mainsprite.size()){
			mainsprite.resize(total_batch+5);
		}
		
		mainsprite[total_batch]=BatchSpriteMesh::Create();
		mainsprite[total_batch]->id=total_batch;
	}

	return mainsprite[total_batch];
	
}

BatchSprite* BatchSprite::CreateBatchSprite(Entity* parent_ent){

	// never added to entity_list
	// if idx=0 add to last created batch
	int idx=0;
	if (dynamic_cast<BatchSpriteMesh*>(parent_ent)!=NULL) idx=dynamic_cast<BatchSpriteMesh*>(parent_ent)->id;
	
	BatchSprite* sprite=new BatchSprite;
	sprite->class_name="BatchSprite";
	
	// update matrix
	if (sprite->parent!=NULL){
		sprite->mat.Overwrite(sprite->parent->mat);
		sprite->UpdateMat();
	}else{
		sprite->UpdateMat(true);
	}
	
	if (idx==0){
		sprite->batch_id=total_batch;
	}else{
		sprite->batch_id=idx;
	}
	if (sprite->batch_id==0) sprite->batch_id=1;
	int id=sprite->batch_id;
	
	// create main mesh
	BatchSpriteMesh* mesh;
	if (id>total_batch){
		mesh=CreateBatchMesh(id);
		if (id==0) id=1;
	}else{
		mesh=mainsprite[id];
	}
	
	// get vertex id
	int v, v0;
	if (mesh->free_stack.size()<1){
	
		mesh->num_sprites+=1;
		v=(mesh->num_sprites-1) * 4; // 4 vertex per quad
		mesh->surf->AddVertex(-1,-1, 0, 0, 1); // v0
		mesh->surf->AddVertex(-1, 1, 0, 0, 0);
		mesh->surf->AddVertex( 1, 1, 0, 1, 0);
		mesh->surf->AddVertex( 1,-1, 0, 1, 1);
		//v=(mesh->num_sprites-1) * 3; // 3 vertex per sprite
		//mesh->surf->AddVertex(-1,-3, 0, 0, 2); // v0
		//mesh->surf->AddVertex(-1,-1, 0, 0, 0);
		//mesh->surf->AddVertex( 3,-1, 0, 2, 0);
		
		// v isnt guaranteed to be v0, but seems to match up
		mesh->surf->AddTriangle(0+v, 1+v, 2+v);
		mesh->surf->AddTriangle(0+v, 2+v, 3+v);
		
		// since vbo expands, make sure to reset so we dont use subbuffer
		mesh->surf->reset_vbo=-1;
		
	}else{
		
		int st=mesh->free_stack.size();
		v=mesh->free_stack[st-1]; // pop stack
		mesh->free_stack.resize(st-1);
		mesh->num_sprites+=1;
		
	}	
	
	mesh->reset_bounds=false; // we control our own bounds
	sprite->vertex_id=v;
	mesh->sprite_list.push_back(sprite);
	
	if (dynamic_cast<BatchSpriteMesh*>(parent_ent)==NULL && parent_ent!=NULL){
		sprite->EntityParent(parent_ent);
		sprite->mat.Overwrite(parent_ent->mat);
	}
	
	return sprite;
	
}

BatchSpriteMesh* BatchSprite::LoadBatchTexture(string tex_file,int tex_flag,int id){

	// does not create sprite, just loads texture
	if (id<=0 || id>total_batch) id=total_batch;
	if (id==0) id=1;
	
	mainsprite.resize(10);
	
	CreateBatchMesh(id);
	
	Texture* tex=Texture::LoadTexture(tex_file, tex_flag);
	mainsprite[id]->EntityTexture(tex);
	
	// additive blend if sprite doesn't have alpha or masking flags set
	if ((tex_flag & 2)==0 && (tex_flag & 4)==0){
		mainsprite[id]->EntityBlend(3);
	}
	
	return mainsprite[id];
	
}

void BatchSprite::UpdateBatch(Sprite* cam_sprite){
	
	// invisible
	if (brush.alpha==0.0) return;
	
	if (view_mode!=2){
		
		// add in mainsprite position offset
		float x=mat.grid[3][0] - mainsprite[batch_id]->mat.grid[3][0];
		float y=mat.grid[3][1] - mainsprite[batch_id]->mat.grid[3][1];
		float z=mat.grid[3][2] - mainsprite[batch_id]->mat.grid[3][2];
		
		temp_mat.Overwrite(cam_sprite->mat);
		temp_mat.grid[3][0]=x;
		temp_mat.grid[3][1]=y;
		temp_mat.grid[3][2]=z;
		mat_sp.Overwrite(temp_mat);
		
		if (angle!=0.0){
			mat_sp.RotateRoll(angle);
		}
		if (scale_x!=1.0 || scale_y!=1.0){
			mat_sp.Scale(scale_x, scale_y, 1.0);
		}
		if (handle_x!=0.0 || handle_y!=0.0){
			mat_sp.Translate(-handle_x,-handle_y, 0.0);
		}
		
	}else{
		
		mat_sp.Overwrite(mat);
	
		if (scale_x!=1.0 || scale_y!=1.0){
			mat_sp.Scale(scale_x, scale_y, 1.0);
		}
		
	}
	
	// update main mesh
	// rotate each point corner offset to face the camera with cam_mat
	// use the mat.x.y.z for position and offset from that
	float p0[3], p1[3], p2[3], p3[3];
	//Matrix temp_mat=mat_sp.Copy(); //Inverse()
	float o[]={ mat_sp.grid[3][0], mat_sp.grid[3][1], mat_sp.grid[3][2] };
	
	float m00=mat_sp.grid[0][0];
	float m01=mat_sp.grid[0][1];
	float m10=mat_sp.grid[1][0];
	float m11=mat_sp.grid[1][1];
	float m02=mat_sp.grid[0][2];
	float m12=mat_sp.grid[1][2];
	
	//p0=mat_sp.TransformPoint(-1.0,-1.0, 0.0);
	//p1=mat_sp.TransformPoint(-1.0, 1.0, 0.0);
	//p2=mat_sp.TransformPoint(1.0, 1.0, 0.0);
	//p3=mat_sp.TransformPoint(1.0,-1.0, 0.0);
	p0[0]=-m00 + -m10 + o[0]; p0[1]=-m01 + -m11 + o[1]; p0[2]=m02 + m12 - o[2];
	p1[0]=-m00 + m10 + o[0]; p1[1]=-m01 + m11 + o[1]; p1[2]=m02 - m12 - o[2];
	p2[0]=m00 + m10 + o[0]; p2[1]=m01 + m11 + o[1]; p2[2]=-m02 - m12 - o[2];		
	p3[0]=m00 - m10 + o[0]; p3[1]=m01 - m11 + o[1]; p3[2]=-m02 + m12 - o[2];
	
	// 3 triangle sprite trick (does not work for all conditions, animated sprites)
	//p0={-m00 + -(m10+m10+m10) + o[0] , -m01 + -(m11+m11+m11) + o[1], m02 + m12+m12+m12 - o[2]};		
	//p1={-m00 + m10 + o[0] , -m01 + m11 + o[1], m02 - m12 - o[2]};
	//p2={m00+m00+m00 + m10 + o[0] , m01+m01+m01 + m11 + o[1], -(m02+m02+m02) - m12 - o[2]};
	//p3={0.0,0.0,0.0};
	
	mainsprite[batch_id]->surf->VertexCoords(vertex_id+0, p0[0], p0[1], p0[2]);
	mainsprite[batch_id]->surf->VertexCoords(vertex_id+1, p1[0], p1[1], p1[2]);
	mainsprite[batch_id]->surf->VertexCoords(vertex_id+2, p2[0], p2[1], p2[2]);
	mainsprite[batch_id]->surf->VertexCoords(vertex_id+3, p3[0], p3[1], p3[2]);
	
	float r=brush.red; //* brush.alpha
	float g=brush.green; //* brush.alpha
	float b=brush.blue; //* brush.alpha
	float a=brush.alpha; //* 0.5
	int vid=vertex_id * 4;
	
	mainsprite[batch_id]->surf->vert_col[vid]=r;
	mainsprite[batch_id]->surf->vert_col[vid+1]=g;
	mainsprite[batch_id]->surf->vert_col[vid+2]=b;
	mainsprite[batch_id]->surf->vert_col[vid+3]=a;
	vid=(vid+4);
	mainsprite[batch_id]->surf->vert_col[vid]=r;
	mainsprite[batch_id]->surf->vert_col[vid+1]=g;
	mainsprite[batch_id]->surf->vert_col[vid+2]=b;
	mainsprite[batch_id]->surf->vert_col[vid+3]=a;
	vid=(vid+4);
	mainsprite[batch_id]->surf->vert_col[vid]=r;
	mainsprite[batch_id]->surf->vert_col[vid+1]=g;
	mainsprite[batch_id]->surf->vert_col[vid+2]=b;
	mainsprite[batch_id]->surf->vert_col[vid+3]=a;
	vid=(vid+4);
	mainsprite[batch_id]->surf->vert_col[vid]=r;
	mainsprite[batch_id]->surf->vert_col[vid+1]=g;
	mainsprite[batch_id]->surf->vert_col[vid+2]=b;
	mainsprite[batch_id]->surf->vert_col[vid+3]=a;
	
	// mesh state has changed - update reset flags
	mainsprite[batch_id]->surf->reset_vbo=mainsprite[batch_id]->surf->reset_vbo | 8;
	
	// determine our own bounds
	b_min_x=Min5(p0[0], p1[0], p2[0], p3[0], b_min_x);
	b_min_y=Min5(p0[1], p1[1], p2[1], p3[1], b_min_y);
	b_min_z=Min5(p0[2], p1[2], p2[2], p3[2], b_min_z);
	
	b_max_x=Max5(p0[0], p1[0], p2[0], p3[0], b_max_x);
	b_max_y=Max5(p0[1], p1[1], p2[1], p3[1], b_max_y);
	b_max_z=Max5(p0[2], p1[2], p2[2], p3[2], b_max_z);
	
}

float BatchSprite::Min5(float a, float b, float c, float d, float e){
	float r=a;
	float t=c;
	
	if (b < r) r=b;
	if (d < t) t=d;
	if (t < r) r=t;
	
	if (r < e) return r;
	else return e;
}

float BatchSprite::Max5(float a, float b, float c, float d, float e){
	float r=a;
	float t=c;
	
	if (b > r) r=b;
	if (d > t) t=d;
	if (t > r) r=t;
	
	if (r > e) return r;
	else return e;
}
