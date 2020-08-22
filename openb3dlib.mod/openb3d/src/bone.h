#ifndef BONE_H
#define BONE_H
/*
 *  bone.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "entity.h"
#include "animation_keys.h"

#include <iostream>
using namespace std;

class Bone : public Entity{

public:

	float n_px,n_py,n_pz,n_sx,n_sy,n_sz,n_rx,n_ry,n_rz,n_qw,n_qx,n_qy,n_qz;

	AnimationKeys* keys;

	// additional matrices used for animation purposes
	Matrix mat2;
	Matrix inv_mat; // set in TModel, when loading anim mesh
	Matrix tform_mat;

	float kx,ky,kz,kqw,kqx,kqy,kqz; // used to store current keyframe in AnimateMesh, for use with transition

	Bone(){

		n_px=n_py=n_pz=n_sx=n_sy=n_sz=n_rx=n_ry=n_rz=n_qw=n_qx=n_qy=n_qz=0.0;

		kx=ky=kz=kqw=kqx=kqy=kqz=0.0;

		keys=NULL;

	}

	static Bone* NewBone();
	Bone* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);

};

#endif
