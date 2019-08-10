#ifndef COLLISION2_H
#define COLLISION2_H

/*
 *  collision2.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "entity.h"
#include "surface.h"
//#include "pivot.h"

#include <list>
#include <iostream>
using namespace std;

const int MAX_TYPES=100;

class Entity;
class Pivot;

class CollisionPair{

public:

	static list<CollisionPair*> cp_list;
	static list<Entity*> ent_lists[MAX_TYPES];
	
	static int pivots_exist;
	static Pivot* piv1o;
	static Pivot* piv1;
	static Pivot* piv11;
	static Pivot* piv111;
	static Pivot* piv2o;
	static Pivot* piv2;
	
	int src_type;
	int des_type;
	int col_method;
	int response;

	CollisionPair(){

		src_type=0;
		des_type=0;
		col_method=0;
		response=0;

	}

};

class CollisionImpact{

public:

	float x,y,z;
	float nx,ny,nz;
	float time;
	Entity* ent;
	Surface* surf;
	int tri;

	CollisionImpact(){

		x=y=z=nx=ny=nz=time=0.0;
		ent=NULL;
		surf=NULL;
		tri=0;

	}

};

// collision methods - already defined in collision
//const int COLLISION_METHOD_SPHERE=1;
//const int COLLISION_METHOD_POLYGON=2;
//const int COLLISION_METHOD_BOX=3;

// collision actions
//const int COLLISION_RESPONSE_NONE=0;
//const int COLLISION_RESPONSE_STOP=1;
//const int COLLISION_RESPONSE_SLIDE=2;
//const int COLLISION_RESPONSE_SLIDEXZ=3;

void UpdateCollisions();
void ClearStaticCollisions();
void UpdateStaticCollisions();
void UpdateDynamicCollisions();
void clearCollisions();
int PositionEntities(int update_old=true,int add_to_new=false);
int QuickCheck(Entity& ent,Entity& ent2);
void LoadCollisionPivots();
void FreeCollisionPivots();

#endif
