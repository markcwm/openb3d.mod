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
	static ParticleBatch* GetParticleBatch(Texture* tex,int blend,int order);
	
	ParticleBatch(){
		no_surfs=1;
		
		c_col_tree=NULL;
		reset_col_tree=0;
		
		reset_bounds=true;

		trail=1;
		
		min_x=-999999999;;min_y=-999999999;;min_z=-999999999;;max_x=999999999;;max_y=999999999;;max_z=999999999;;
	};
	
};

class ParticleEmitter: public Entity{

private:
	int rate_counter;
	
public:
	struct ParticleData{
		Entity* ent;
		int particleLife;
		float vx,vy,vz;
		float fgx,fgy,fgz,lgx,lgy,lgz; // gravity
	};

	list<ParticleData> particles;

//public:
	static list<ParticleEmitter*> emitter_list;

	Entity* particle_base;


	int rate;
	int firstlife,midlife,lastlife,initlife;

	float firstgx,firstgy,firstgz,lastgx,lastgy,lastgz;		// gravity
	float variance;
	float firstspeed,lastspeed;
	float firsta,lasta,halfa,midlifea; //alpha
	float firstr,firstg,firstb,lastr,lastg,lastb,halfr,halfg,halfb,midlifec; // color
	float firstsx,firstsy,lastsx,lastsy,halfsx,halfsy,midlifes; // scale
	float firstrt,lastrt,halfrt,midlifert; // rotation
	
	void (*UpdateParticle)(Entity* ent, int life);

	void Update();

	ParticleEmitter(){
		rate=1;
		firstspeed=0.005;lastspeed=0;
		rate_counter=0;
		firstlife=0;midlife=0;lastlife=0;initlife=0;
		firstgx=0;firstgy=0;firstgz=0;lastgx=0;lastgy=0;lastgz=0;
		variance=0;
		UpdateParticle=0;
		firsta=0;lasta=0;halfa=0;midlifea=0;
		firstr=255;firstg=255;firstb=255;
		lastr=255;lastg=255;lastb=255;
		halfr=255;halfg=255;halfb=255;midlifec=0;
		firstsx=1;firstsy=1;lastsx=1;lastsy=1;halfsx=1;halfsy=1;midlifes=0;
		firstrt=0;lastrt=0;halfrt=0;midlifert=0;
	}

	ParticleEmitter* CopyEntity(Entity* parent_ent=NULL);
	static ParticleEmitter* CreateParticleEmitter(Entity* particle, Entity* parent_ent=NULL);
	void FreeEntity(void);

	void EmitterVector(float startx, float starty, float startz, float endx, float endy, float endz);
	void EmitterRate (float r);
	void EmitterVariance (float v);
	void EmitterParticleLife (int startl, int endl, int randl=0);
	void EmitterParticleSpeed (float starts, float ends=0);
	void EmitterParticleFunction(void (*EmitterFunction)(Entity*, int));
	void EmitterParticleAlpha(float starta, float enda, float mida=0, int midlife=0);
	void EmitterParticleScale(float startsx, float startsy, float endsx, float endsy, float midsx=0, float midsy=0, int midlife=0);
	void EmitterParticleColor(float startr, float startg, float startb, float endr, float endg, float endb, float midr=0, float midg=0, float midb=0, int midlife=0);
	void EmitterParticleRotate(float startr, float endr, float midr=0, int midlife=0);

};

#endif
