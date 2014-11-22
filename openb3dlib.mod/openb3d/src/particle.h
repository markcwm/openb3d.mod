#ifndef PARTICLE_H
#define PARTICLE_H

#include "mesh.h"
#include "global.h"
#include "surface.h"
#include "texture.h"

#include <iostream>
using namespace std;

/*class Particle : public Mesh{
	public:

	void Render();

};*/



class ParticleBatch: public Mesh{

public:

	static list<ParticleBatch*> particle_batch_list;

	void Render();

	
	ParticleBatch(){
		no_surfs=1;
		no_bones=0;
		
		c_col_tree=NULL;
		reset_col_tree=0;
		
		reset_bounds=true;
		
		min_x=-999999999;;min_y=-999999999;;min_z=-999999999;;max_x=999999999;;max_y=999999999;;max_z=999999999;;
	};
	
	static Surface* GetParticleBatchSurface(Texture* tex,int blend,int order){
	
		ParticleBatch* particle_batch=NULL;
	
		// check if particle batch already exists for specified texture, if so return it
		list<ParticleBatch*>::iterator it;
		for(it=particle_batch_list.begin();it!=particle_batch_list.end();it++){
			particle_batch=*it;
			if(particle_batch->brush.tex[0]==tex && particle_batch->brush.blend==blend && particle_batch->order==order){
				return *particle_batch->surf_list.begin();
			}
		}
		
		// if no particle batch surface exists, create new particle batch with new surface
		particle_batch=new ParticleBatch;
		Surface* surf=new Surface;
		surf->vbo_enabled=false;
		surf->ShaderMat=0;
		particle_batch->surf_list.push_back(surf);
		particle_batch->hide=false;
		entity_list.push_back(particle_batch);
		Global::root_ent->child_list.push_back(particle_batch);


		particle_batch->brush.tex[0]=tex;
		particle_batch->brush.blend=blend;
		particle_batch->order=order;
		particle_batch_list.push_back(particle_batch);
		return surf;
		
	}

/*	Mesh* GetParticleBatchMesh(){

		mesh=new Particle();
	
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

		list<ParticleBatch*>::iterator it;
		for(it=particle_batch_list.begin();it!=particle_batch_list.end();it++){
			ParticleBatch* particle_batch=*it;
			delete particle_batch->mesh;
			delete particle_batch->surf;
			delete particle_batch;
		}
		particle_batch_list.clear();
	
	}*/

};


#endif
