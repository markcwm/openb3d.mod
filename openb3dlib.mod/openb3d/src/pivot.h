/*
 *  pivot.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */
 
#ifndef PIVOT_H
#define PIVOT_H

#include "entity.h"

#include <vector>
#include <cmath>
using namespace std;

class Pivot : public Entity{
 
public:
	
	Pivot(){};
	
	Pivot* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);
	
	static Pivot* CreatePivot(Entity* parent_ent=NULL);
	void Update();
 
 };
 
 #endif
