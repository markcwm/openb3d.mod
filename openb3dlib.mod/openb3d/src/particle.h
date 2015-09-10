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

	int trail;

	void Render();

	
	ParticleBatch(){
		no_surfs=1;
		
		c_col_tree=NULL;
		reset_col_tree=0;
		
		reset_bounds=true;

		trail=1;
		
		min_x=-999999999;;min_y=-999999999;;min_z=-999999999;;max_x=999999999;;max_y=999999999;;max_z=999999999;;
	};
	
	static ParticleBatch* GetParticleBatch(Texture* tex,int blend,int order){
	
		ParticleBatch* particle_batch=NULL;
	
		// check if particle batch already exists for specified texture, if so return it
		list<ParticleBatch*>::iterator it;
		for(it=particle_batch_list.begin();it!=particle_batch_list.end();it++){
			particle_batch=*it;
			if(particle_batch->brush.tex[0]==tex && particle_batch->brush.blend==blend && particle_batch->order==order){
				return particle_batch;		//*particle_batch->surf_list.begin();
			}
		}
		
		// if no particle batch surface exists, create new particle batch with new surface
		particle_batch=new ParticleBatch;
		Surface* surf=new Surface;
		surf->vbo_enabled=false;
		surf->ShaderMat=Global::ambient_shader;
		particle_batch->surf_list.push_back(surf);
		particle_batch->hide=false;
		entity_list.push_back(particle_batch);
		Global::root_ent->child_list.push_back(particle_batch);


		particle_batch->brush.tex[0]=tex;
		particle_batch->brush.blend=blend;
		particle_batch->order=order;
		particle_batch_list.push_back(particle_batch);
		return particle_batch;
		
	}



};

class ParticleEmitter: public Entity{

private:
	int rate_counter;

	struct ParticleData{
		Entity* ent;
		int particleLife;
		float vx,vy,vz;
	};

	list<ParticleData> particles;

public:
	static list<ParticleEmitter*> emitter_list;

	Entity* particle_base;


	int rate;
	int lifetime;

	float gx,gy,gz;		//Gravity
	float variance;
	float particleSpeed;

	void (*UpdateParticle)(Entity* ent, int life);

	void Update();

	ParticleEmitter(){
		rate=1;
		particleSpeed=1;
		rate_counter=0;
		lifetime=0;
		gx=0;gy=0;gz=0;
		variance=0;
		UpdateParticle=0;
	}

	ParticleEmitter* CopyEntity(Entity* parent_ent=NULL);
	static ParticleEmitter* CreateParticleEmitter(Entity* particle, Entity* parent_ent=NULL);
	void FreeEntity(void);

	void EmitterVector(float x, float y, float z);
	void EmitterRate (float r);
	void EmitterVariance (float v);
	void EmitterParticleLife (int l);
	void EmitterParticleSpeed (float s);
	void EmitterParticleFunction(void (*EmitterFunction)(Entity*, int));

	
};

#endif
