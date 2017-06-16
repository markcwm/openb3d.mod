#ifndef ANIMATION_KEYS_H
#define ANIMATION_KEYS_H

/*
 *  animation_keys.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */


#include <vector>
using namespace std;

class AnimationKeys{

public:

	int frames;
	vector<int> flags;
	vector<float> px;
	vector<float> py;
	vector<float> pz;
	vector<float> sx;
	vector<float> sy;
	vector<float> sz;
	vector<float> qw;
	vector<float> qx;
	vector<float> qy;
	vector<float> qz;

	AnimationKeys(){
    frames=0;
	}

	AnimationKeys* Copy(){

		AnimationKeys* keys=new AnimationKeys;

		keys->frames=frames;
		keys->flags=flags;
		keys->px=px;
		keys->py=py;
		keys->pz=pz;
		keys->sx=sx;
		keys->sy=sy;
		keys->sz=sz;
		keys->qw=qw;
		keys->qx=qx;
		keys->qy=qy;
		keys->qz=qz;

		return keys;

	}

};

#endif
