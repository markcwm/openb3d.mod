/*
 *  pick.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef PICK_H
#define PICK_H

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "surface.h"
#include "collision.h"
#include "tree.h"
#include "geom.h"
#include "project.h"
#include "terrain.h"

#include <list>
#include <iostream>
using namespace std;

class Pick{

public:

	//EntityPickMode in TEntity

	static constexpr float EPSILON=0.0001;
	
	static list<Entity*> ent_list; // list containing pickable entities

	static float picked_x;
	static float picked_y;
	static float picked_z;
	static float picked_nx;
	static float picked_ny;
	static float picked_nz;
	static float picked_time;
	static Entity* picked_ent;
	static Surface* picked_surface;
	static int picked_triangle;

	Pick(){};

	static Entity* CameraPick(Camera* cam,float vx,float vy);
	static Entity* EntityPick(Entity* ent,float range);
	static Entity* LinePick(float x,float y,float z,float dx,float dy,float dz,float radius=0.0);
	static int EntityVisible(Entity* src_ent,Entity* dest_ent);
	static float PickedX();
	static float PickedY();
	static float PickedZ();
	static float PickedNX();
	static float PickedNY();
	static float PickedNZ();
	static float PickedTime();
	static Entity* PickedEntity();
	static Surface* PickedSurface();
	static int PickedTriangle();
	static Entity* PickMain(float ax,float ay,float az,float bx,float by,float bz,float radius=0.0);

};

#endif
