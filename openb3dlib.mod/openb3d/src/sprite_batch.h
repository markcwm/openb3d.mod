/*
 *  sprite_batch.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef SPRITE_BATCH_H
#define SPRITE_BATCH_H

#include "mesh.h"
#include "global.h"
#include "surface.h"
#include "texture.h"
#include "sprite.h"

#include <iostream>
using namespace std;

class SpriteBatch{

public:

	static list<SpriteBatch*> sprite_batch_list;
	Surface* surf;
	Mesh* mesh;
	Texture* texture;
	int blend;
	int order;
	
	SpriteBatch(){
	
		surf=NULL;
		mesh=NULL;
		texture=NULL;
		blend=0;
		order=0;
	
	};
	
	static Surface* GetSpriteBatchSurface(Texture* tex,int blend,int order){
	
		SpriteBatch* sprite_batch=NULL;
	
		// check if sprite batch already exists for specified texture, if so return it
		list<SpriteBatch*>::iterator it;
		for(it=sprite_batch_list.begin();it!=sprite_batch_list.end();it++){
			sprite_batch=*it;
			if(sprite_batch->texture==tex && sprite_batch->blend==blend && sprite_batch->order==order){
				return sprite_batch->surf;
			}
		}
		
		// if no sprite batch surface exists, create new sprite batch with new surface
		sprite_batch=new SpriteBatch;
		sprite_batch->surf=new Surface;
#ifndef GLES2
		sprite_batch->surf->vbo_enabled=false;
#endif
		sprite_batch->surf->ShaderMat=Global::ambient_shader;
		sprite_batch->texture=tex;
		sprite_batch->blend=blend;
		sprite_batch->order=order;
		sprite_batch_list.push_back(sprite_batch);
		return sprite_batch->surf;
		
	}

	Mesh* GetSpriteBatchMesh(){

		mesh=new Mesh();
	
		mesh->surf_list.push_back(surf);
	
		mesh->no_surfs=mesh->no_surfs+1;
	
		// new mesh surface - update reset flags
		mesh->reset_bounds=true;
		mesh->reset_col_tree=true;
		
		mesh->brush.tex[0]=texture;
		mesh->brush.cache_frame[0]=texture->texture;

		mesh->brush.no_texs=1;
		mesh->brush.blend=blend;
		mesh->brush.fx=35;
		
		mesh->order=order;

		return mesh;
	
	}
	
	static void Clear(){

		list<SpriteBatch*>::iterator it;
		for(it=sprite_batch_list.begin();it!=sprite_batch_list.end();it++){
			SpriteBatch* sprite_batch=*it;
			delete sprite_batch->mesh;
			delete sprite_batch->surf;
			delete sprite_batch;
		}
		sprite_batch_list.clear();
	
	}

};

class BatchSprite;

class BatchSpriteMesh : public Mesh{

public:
	Surface* surf; 
	vector<int> free_stack; // list of available vertex
	int num_sprites;
	list<BatchSprite*> sprite_list;
	int id;
	Sprite* cam_sprite; // use this to get cam info
	
	static BatchSpriteMesh* Create(Entity* parent_ent=NULL);
	void Update() {};
	void Render();
	
	BatchSpriteMesh(){
	
		num_sprites=0; id=0;
		free_stack.push_back(0);
		
	}

};

class BatchSprite : public Sprite{

public:
	int batch_id; // ids start at 1
	int vertex_id;
	//Field sprite_link:TLink
	static float b_min_x, b_min_y, b_max_x, b_max_y, b_min_z, b_max_z;
	static vector<BatchSpriteMesh*> mainsprite;
	static int total_batch;
	static Matrix temp_mat;

	void FreeEntity(void);
	static void BatchSpriteParent(int id=0, Entity* ent=NULL,int glob=true);
	static Entity* BatchSpriteEntity(BatchSprite* batch_sprite=NULL);
	void BatchSpriteOrigin(float x,float y,float z);
	static BatchSpriteMesh* CreateBatchMesh( int batchid );
	static BatchSprite* CreateSprite(Entity* parent_ent=NULL);
	static BatchSpriteMesh* LoadBatchTexture(string tex_file,int tex_flag=1,int id=0);
	void UpdateBatch(Sprite* cam_sprite);
	static float Min5(float a, float b, float c, float d, float e);
	static float Max5(float a, float b, float c, float d, float e);

	BatchSprite(){
	
	}

};

#endif
