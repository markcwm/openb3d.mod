/*
 *  tilt.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef TILT_H
#define TILT_H

#include "maths_helper.h"

#include <iostream>
using namespace std;

class Tilt{

public:

	static float x,y,z;

	Tilt(){
	
	};

	static void SetTilt(float tilt_x,float tilt_y,float tilt_z){
	
		x=tilt_x;
		y=tilt_y;
		z=tilt_z;
		
		return;
	
	}
	
	static float TiltX(){
	
		return x;
	
	}
	
	static float TiltY(){
	
		return y;
	
	}

	static float TiltZ(){
	
		return z;
	
	}

	static float TiltPitch(){
	
		return asindeg(x);
	
	}
	
	static float TiltYaw(){
	
		return asindeg(y);
	
	}

	static float TiltRoll(){
	
		if(z>1.0) z=1.0;
		if(z<-1.0) z=-1.0;
	
		return asindeg(z);
	
	}

};

#endif
