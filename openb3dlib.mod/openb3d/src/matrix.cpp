/*
 *  matrix.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "matrix.h"

float Magnitude( float x, float y, float z ){
	return sqrt( x*x + y*y + z*z );
}

// bbdoc: Creates a quaternion from an angle and an axis
void Quaternion_FromAngleAxis( float angle, float ax, float ay, float az, float &rx, float &ry, float &rz, float &rw){
	
	float ha = .5*angle;
	float sn = sindeg( ha );
	
	rw = cosdeg( ha );
	rx = sn * ax;
	ry = sn * ay;
	rz = sn * az;
	
}

// bbdoc: Multiplies a quaternion
void Quaternion_MultiplyQuat( float x1, float y1, float z1, float w1, float x2, float y2, float z2, float w2, float &rx, float &ry, float &rz, float &rw ){
	
	rw = w1*w2 - x1*x2 - y1*y2 - z1*z2;
	rx = w1*x2 - x1*w2 - y1*z2 - z1*y2;
	ry = w1*y2 - y1*w2 - z1*x2 - x1*z2;
	rz = w1*z2 - z1*w2 - x1*y2 - y1*x2;
	
}

Matrix* InterpolateMatrix(Matrix* a, float alpha){

	Matrix* m=new Matrix();
	m->LoadIdentity();
	float q1_x, q1_y, q1_z, q1_w;
	float dd;
	
	a->ToQuat(q1_x, q1_y, q1_z, q1_w);
	if (q1_w == 0) return a->Copy();

	//normalize
	if (q1_w > 1) {
		dd = (q1_x*q1_x + q1_y*q1_y + q1_z*q1_z + q1_w*q1_w);
		if (dd != 0){
			q1_x = q1_x / dd;
			q1_y = q1_y / dd;
			q1_z = q1_z / dd;
			q1_w = q1_w / dd;
		}
	}
	
	float s;
	float angle,x,y,z;
	
	angle = 2 * acosdeg(q1_w);
	s = sqrt(1 - q1_w * q1_w);

	if (s < 0.001) {
		x = q1_x;
		y = q1_y;
		z = q1_z;
	}else{
		x = q1_x / s;
		y = q1_y / s;
		z = q1_z / s;
	}

	angle = angle * alpha;
	Quaternion_FromAngleAxis(angle, x,y,z, q1_x, q1_y, q1_z, q1_w);
	m->FromQuaternion(q1_x, q1_y, q1_z, q1_w);
	
	return m;
	
}
