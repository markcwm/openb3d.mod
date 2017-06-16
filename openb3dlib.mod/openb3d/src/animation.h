/*
 *  animation.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef ANIMATION_H
#define ANIMATION_H

#include "mesh.h"

#include <iostream>
using namespace std;

class Animation{

public:

	static void AnimateMesh(Mesh* ent1,float framef,int start_frame,int end_frame);
	static void AnimateMesh2(Mesh* ent1,float framef,int start_frame,int end_frame);
	static void AnimateMesh3(Mesh* ent1);
	static void VertexDeform(Mesh* ent);
	//static void NormaliseWeights(Mesh* mesh);
	
};

#endif
