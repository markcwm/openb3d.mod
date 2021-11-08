/*
 *  matrix.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "maths_helper.h"

#include <cmath>
using namespace std;

#ifndef MATRIX_H
#define MATRIX_H

class Matrix{

public:

	float grid[4][4];

	Matrix(){

		LoadIdentity();

	}

	void LoadIdentity(){

		grid[0][0]=1.0;
		grid[1][0]=0.0;
		grid[2][0]=0.0;
		grid[3][0]=0.0;
		grid[0][1]=0.0;
		grid[1][1]=1.0;
		grid[2][1]=0.0;
		grid[3][1]=0.0;
		grid[0][2]=0.0;
		grid[1][2]=0.0;
		grid[2][2]=1.0;
		grid[3][2]=0.0;

		grid[0][3]=0.0;
		grid[1][3]=0.0;
		grid[2][3]=0.0;
		grid[3][3]=1.0;

	}

	// copy - create new copy and returns it

	Matrix* Copy(){

		Matrix* mat=new Matrix();

		mat->grid[0][0]=grid[0][0];
		mat->grid[1][0]=grid[1][0];
		mat->grid[2][0]=grid[2][0];
		mat->grid[3][0]=grid[3][0];
		mat->grid[0][1]=grid[0][1];
		mat->grid[1][1]=grid[1][1];
		mat->grid[2][1]=grid[2][1];
		mat->grid[3][1]=grid[3][1];
		mat->grid[0][2]=grid[0][2];
		mat->grid[1][2]=grid[1][2];
		mat->grid[2][2]=grid[2][2];
		mat->grid[3][2]=grid[3][2];

		// do not remove
		mat->grid[0][3]=grid[0][3];
		mat->grid[1][3]=grid[1][3];
		mat->grid[2][3]=grid[2][3];
		mat->grid[3][3]=grid[3][3];

		return mat;

	}

	// overwrite - overwrites self with matrix passed as parameter

	void Overwrite(Matrix &mat){

		grid[0][0]=mat.grid[0][0];
		grid[1][0]=mat.grid[1][0];
		grid[2][0]=mat.grid[2][0];
		grid[3][0]=mat.grid[3][0];
		grid[0][1]=mat.grid[0][1];
		grid[1][1]=mat.grid[1][1];
		grid[2][1]=mat.grid[2][1];
		grid[3][1]=mat.grid[3][1];
		grid[0][2]=mat.grid[0][2];
		grid[1][2]=mat.grid[1][2];
		grid[2][2]=mat.grid[2][2];
		grid[3][2]=mat.grid[3][2];

		grid[0][3]=mat.grid[0][3];
		grid[1][3]=mat.grid[1][3];
		grid[2][3]=mat.grid[2][3];
		grid[3][3]=mat.grid[3][3];

	}

	void GetInverse(Matrix &mat){

		float tx=0;
		float ty=0;
		float tz=0;

	  	// the rotational part of the matrix is simply the transpose of the original matrix.
	  	mat.grid[0][0] = grid[0][0];
	  	mat.grid[1][0] = grid[0][1];
	  	mat.grid[2][0] = grid[0][2];

		mat.grid[0][1] = grid[1][0];
		mat.grid[1][1] = grid[1][1];
		mat.grid[2][1] = grid[1][2];

		mat.grid[0][2] = grid[2][0];
		mat.grid[1][2] = grid[2][1];
		mat.grid[2][2] = grid[2][2];

		// The right column vector of the matrix should always be [ 0 0 0 1 ]
		// in most cases. . . you don't need this column at all because it'll
		// never be used in the program, but since this code is used with GL
		// and it does consider this column, it is here.
		mat.grid[0][3] = 0;
		mat.grid[1][3] = 0;
		mat.grid[2][3] = 0;
		mat.grid[3][3] = 1;

		// The translation components of the original matrix.
		tx = grid[3][0];
		ty = grid[3][1];
		tz = grid[3][2];

		// result = -(Tm * Rm) To get the translation part of the inverse
		mat.grid[3][0] = -( (grid[0][0] * tx) + (grid[0][1] * ty) + (grid[0][2] * tz) );
		mat.grid[3][1] = -( (grid[1][0] * tx) + (grid[1][1] * ty) + (grid[1][2] * tz) );
		mat.grid[3][2] = -( (grid[2][0] * tx) + (grid[2][1] * ty) + (grid[2][2] * tz) );
		
	}
	
	// GetInverse used in collision2.cpp
	void GetInverse2(Matrix &mat){
		
		float det=grid[0][0] * (grid[1][1] * grid[2][2] - grid[2][1] * grid[1][2])
						- grid[0][1] * (grid[1][0] * grid[2][2] - grid[1][2] * grid[2][0])
						+ grid[0][2] * (grid[1][0] * grid[2][1] - grid[1][1] * grid[2][0]);

		float m00 = grid[1][1]*grid[2][2] - grid[2][1]*grid[1][2];
		float m01 = grid[0][2]*grid[2][1] - grid[0][1]*grid[2][2];
		float m02 = grid[0][1]*grid[1][2] - grid[0][2]*grid[1][1];

		float m10 = grid[1][2]*grid[2][0] - grid[1][0]*grid[2][2];
		float m11 = grid[0][0]*grid[2][2] - grid[0][2]*grid[2][0];
		float m12 = grid[1][0]*grid[0][2] - grid[0][0]*grid[1][2];

		float m20 = grid[1][0]*grid[2][1] - grid[2][0]*grid[1][1];
		float m21 = grid[2][0]*grid[0][1] - grid[0][0]*grid[2][1];
		float m22 = grid[0][0]*grid[1][1] - grid[1][0]*grid[0][1];

		mat.grid[0][0]=m00/det;
		mat.grid[0][1]=m01/det;
		mat.grid[0][2]=m02/det;

		mat.grid[1][0]=m10/det;
		mat.grid[1][1]=m11/det;
		mat.grid[1][2]=m12/det;

		mat.grid[2][0]=m20/det;
		mat.grid[2][1]=m21/det;
		mat.grid[2][2]=m22/det;
		//grid[2][3]=m23;
		 
		/*grid[3][0]=m30;
		grid[3][1]=m31;
		grid[3][2]=m32;
		grid[3][3]=m33;*/
		
	}
	
	void Multiply(Matrix &mat){

		float m00 = grid[0][0]*mat.grid[0][0] + grid[1][0]*mat.grid[0][1] + grid[2][0]*mat.grid[0][2] + grid[3][0]*mat.grid[0][3];
		float m01 = grid[0][1]*mat.grid[0][0] + grid[1][1]*mat.grid[0][1] + grid[2][1]*mat.grid[0][2] + grid[3][1]*mat.grid[0][3];
		float m02 = grid[0][2]*mat.grid[0][0] + grid[1][2]*mat.grid[0][1] + grid[2][2]*mat.grid[0][2] + grid[3][2]*mat.grid[0][3];
		float m03 = grid[0][3]*mat.grid[0][0] + grid[1][3]*mat.grid[0][1] + grid[2][3]*mat.grid[0][2] + grid[3][3]*mat.grid[0][3];
		float m10 = grid[0][0]*mat.grid[1][0] + grid[1][0]*mat.grid[1][1] + grid[2][0]*mat.grid[1][2] + grid[3][0]*mat.grid[1][3];
		float m11 = grid[0][1]*mat.grid[1][0] + grid[1][1]*mat.grid[1][1] + grid[2][1]*mat.grid[1][2] + grid[3][1]*mat.grid[1][3];
		float m12 = grid[0][2]*mat.grid[1][0] + grid[1][2]*mat.grid[1][1] + grid[2][2]*mat.grid[1][2] + grid[3][2]*mat.grid[1][3];
		float m13 = grid[0][3]*mat.grid[1][0] + grid[1][3]*mat.grid[1][1] + grid[2][3]*mat.grid[1][2] + grid[3][3]*mat.grid[1][3];
		float m20 = grid[0][0]*mat.grid[2][0] + grid[1][0]*mat.grid[2][1] + grid[2][0]*mat.grid[2][2] + grid[3][0]*mat.grid[2][3];
		float m21 = grid[0][1]*mat.grid[2][0] + grid[1][1]*mat.grid[2][1] + grid[2][1]*mat.grid[2][2] + grid[3][1]*mat.grid[2][3];
		float m22 = grid[0][2]*mat.grid[2][0] + grid[1][2]*mat.grid[2][1] + grid[2][2]*mat.grid[2][2] + grid[3][2]*mat.grid[2][3];
		float m23 = grid[0][3]*mat.grid[2][0] + grid[1][3]*mat.grid[2][1] + grid[2][3]*mat.grid[2][2] + grid[3][3]*mat.grid[2][3];
		float m30 = grid[0][0]*mat.grid[3][0] + grid[1][0]*mat.grid[3][1] + grid[2][0]*mat.grid[3][2] + grid[3][0]*mat.grid[3][3];
		float m31 = grid[0][1]*mat.grid[3][0] + grid[1][1]*mat.grid[3][1] + grid[2][1]*mat.grid[3][2] + grid[3][1]*mat.grid[3][3];
		float m32 = grid[0][2]*mat.grid[3][0] + grid[1][2]*mat.grid[3][1] + grid[2][2]*mat.grid[3][2] + grid[3][2]*mat.grid[3][3];
		float m33 = grid[0][3]*mat.grid[3][0] + grid[1][3]*mat.grid[3][1] + grid[2][3]*mat.grid[3][2] + grid[3][3]*mat.grid[3][3];

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		grid[0][3]=m03;
		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;
		grid[1][3]=m13;
		grid[2][0]=m20;
		grid[2][1]=m21;
		grid[2][2]=m22;
		grid[2][3]=m23;
		grid[3][0]=m30;
		grid[3][1]=m31;
		grid[3][2]=m32;
		grid[3][3]=m33;

	}

	void Translate(float x,float y,float z){

		grid[3][0] = grid[0][0]*x + grid[1][0]*y + grid[2][0]*z + grid[3][0];
		grid[3][1] = grid[0][1]*x + grid[1][1]*y + grid[2][1]*z + grid[3][1];
		grid[3][2] = grid[0][2]*x + grid[1][2]*y + grid[2][2]*z + grid[3][2];

	}

	void Scale(float x,float y,float z){

		grid[0][0] = grid[0][0]*x;
		grid[0][1] = grid[0][1]*x;
		grid[0][2] = grid[0][2]*x;

		grid[1][0] = grid[1][0]*y;
		grid[1][1] = grid[1][1]*y;
		grid[1][2] = grid[1][2]*y;

		grid[2][0] = grid[2][0]*z;
		grid[2][1] = grid[2][1]*z;
		grid[2][2] = grid[2][2]*z;

	}

	void Rotate(float rx,float ry,float rz){

		float cos_ang,sin_ang;

		// yaw

		cos_ang=cosdeg(ry);
		sin_ang=sindeg(ry);

		float m00 = grid[0][0]*cos_ang + grid[2][0]*-sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[2][1]*-sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[2][2]*-sin_ang;

		grid[2][0] = grid[0][0]*sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[0][1]*sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[0][2]*sin_ang + grid[2][2]*cos_ang;

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;

		// pitch

		cos_ang=cosdeg(rx);
		sin_ang=sindeg(rx);

		float m10 = grid[1][0]*cos_ang + grid[2][0]*sin_ang;
		float m11 = grid[1][1]*cos_ang + grid[2][1]*sin_ang;
		float m12 = grid[1][2]*cos_ang + grid[2][2]*sin_ang;

		grid[2][0] = grid[1][0]*-sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[1][1]*-sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[1][2]*-sin_ang + grid[2][2]*cos_ang;

		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;

		// roll

		cos_ang=cosdeg(rz);
		sin_ang=sindeg(rz);

		m00 = grid[0][0]*cos_ang + grid[1][0]*sin_ang;
		m01 = grid[0][1]*cos_ang + grid[1][1]*sin_ang;
		m02 = grid[0][2]*cos_ang + grid[1][2]*sin_ang;

		grid[1][0] = grid[0][0]*-sin_ang + grid[1][0]*cos_ang;
		grid[1][1] = grid[0][1]*-sin_ang + grid[1][1]*cos_ang;
		grid[1][2] = grid[0][2]*-sin_ang + grid[1][2]*cos_ang;

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;

	}

	void RotatePitch(float ang){

		// pitch

		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);

		float m10 = grid[1][0]*cos_ang + grid[2][0]*sin_ang;
		float m11 = grid[1][1]*cos_ang + grid[2][1]*sin_ang;
		float m12 = grid[1][2]*cos_ang + grid[2][2]*sin_ang;

		grid[2][0] = grid[1][0]*-sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[1][1]*-sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[1][2]*-sin_ang + grid[2][2]*cos_ang;

		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;

	}

	void RotateYaw(float ang){

		// yaw

		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);

		float m00 = grid[0][0]*cos_ang + grid[2][0]*-sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[2][1]*-sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[2][2]*-sin_ang;

		grid[2][0] = grid[0][0]*sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[0][1]*sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[0][2]*sin_ang + grid[2][2]*cos_ang;

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;

	}

	void RotateRoll(float ang){

		// roll

		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);

		float m00 = grid[0][0]*cos_ang + grid[1][0]*sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[1][1]*sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[1][2]*sin_ang;

		grid[1][0] = grid[0][0]*-sin_ang + grid[1][0]*cos_ang;
		grid[1][1] = grid[0][1]*-sin_ang + grid[1][1]*cos_ang;
		grid[1][2] = grid[0][2]*-sin_ang + grid[1][2]*cos_ang;

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;

	}
	void FromQuaternion(float x,float y,float z, float w){

		float tx = 2*x;
		float ty = 2*y;
		float tz = 2*z;
		float twx = tx*w;
		float twy = ty*w;
		float twz = tz*w;
		float txx = tx*x;
		float txy = ty*x;
		float txz = tz*x;
		float tyy = ty*y;
		float tyz = tz*y;
		float tzz = tz*z;

		grid[0][0] = 1.0-(tyy+tzz);
		grid[1][0] = txy-twz;
		grid[2][0] = txz+twy;
		grid[3][0] = 0;
		grid[0][1] = txy+twz;
		grid[1][1] = 1.0-(txx+tzz);
		grid[2][1] = tyz-twx;
		grid[3][1] = 0;
		grid[0][2] = txz-twy;
		grid[1][2] = tyz+twx;
		grid[2][2] = 1.0-(txx+tyy);
		grid[3][2] = 0;
		grid[0][3] = 0;
		grid[1][3] = 0;
		grid[2][3] = 0;
		grid[3][3] = 1;
	}

	void TranslateVec(float &rx,float &ry,float &rz,int addTranslation = 0 ){

		float  w = 1.0/ ( grid[0][3] + grid[1][3] + grid[2][3] + grid[3][3] );

		addTranslation = addTranslation & 1;

		rx =  ( ( grid[0][0] ) + ( grid[1][0] ) + ( grid[2][0] ) + grid[3][0] * addTranslation ) * w;
		ry =  ( ( grid[0][1] ) + ( grid[1][1] ) + ( grid[2][1] ) + grid[3][1] * addTranslation ) * w;
		rz = -( ( grid[0][2] ) + ( grid[1][2] ) + ( grid[2][2] ) + grid[3][2] * addTranslation ) * w;
	}

	void TransformVec(float &rx,float &ry,float &rz,int addTranslation = 0 ){

		float  w = 1.0/ ( grid[0][3] + grid[1][3] + grid[2][3] + grid[3][3] );
		float  ix = rx;
		float  iy = ry;
		float  iz = -rz;

		addTranslation = addTranslation & 1;

		rx =  ( ( grid[0][0]*ix ) + ( grid[1][0]*iy ) + ( grid[2][0]*iz ) + grid[3][0] * addTranslation ) * w;
		ry =  ( ( grid[0][1]*ix ) + ( grid[1][1]*iy ) + ( grid[2][1]*iz ) + grid[3][1] * addTranslation ) * w;
		rz = -( ( grid[0][2]*ix ) + ( grid[1][2]*iy ) + ( grid[2][2]*iz ) + grid[3][2] * addTranslation ) * w;
	}

	void Transpose(){

		int x,y;

		float a[4][4];

		for (x = 0;x <= 3; x++){
			for (y = 0;y <= 3; y++){
				a[y][x] = grid[x][y];
			}
		}

		for (x = 0;x <= 3; x++){
			for (y = 0;y <= 3; y++){
				grid[x][y] = a[x][y];
			}
		}
	}

	void SetTranslate(float x, float y, float z ){
		grid[3][0] = x;
		grid[3][1] = y;
		grid[3][2] = z;
	}

	void Multiply2(Matrix &mat){

		float m00 = grid[0][0]*mat.grid[0][0] + grid[0][1]*mat.grid[1][0] + grid[0][2]*mat.grid[2][0] + grid[0][3]*mat.grid[3][0];
		float m01 = grid[0][0]*mat.grid[0][1] + grid[0][1]*mat.grid[1][1] + grid[0][2]*mat.grid[2][1] + grid[0][3]*mat.grid[3][1];
		float m02 = grid[0][0]*mat.grid[0][2] + grid[0][1]*mat.grid[1][2] + grid[0][2]*mat.grid[2][2] + grid[0][3]*mat.grid[3][2];
		float m03 = grid[0][0]*mat.grid[0][3] + grid[0][1]*mat.grid[1][3] + grid[0][2]*mat.grid[2][3] + grid[0][3]*mat.grid[3][3];

		float m10 = grid[1][0]*mat.grid[0][0] + grid[1][1]*mat.grid[1][0] + grid[1][2]*mat.grid[2][0] + grid[1][3]*mat.grid[3][0];
		float m11 = grid[1][0]*mat.grid[0][1] + grid[1][1]*mat.grid[1][1] + grid[1][2]*mat.grid[2][1] + grid[1][3]*mat.grid[3][1];
		float m12 = grid[1][0]*mat.grid[0][2] + grid[1][1]*mat.grid[1][2] + grid[1][2]*mat.grid[2][2] + grid[1][3]*mat.grid[3][2];
		float m13 = grid[1][0]*mat.grid[0][3] + grid[1][1]*mat.grid[1][3] + grid[1][2]*mat.grid[2][3] + grid[1][3]*mat.grid[3][3];

		float m20 = grid[2][0]*mat.grid[0][0] + grid[2][1]*mat.grid[1][0] + grid[2][2]*mat.grid[2][0] + grid[2][3]*mat.grid[3][0];
		float m21 = grid[2][0]*mat.grid[0][1] + grid[2][1]*mat.grid[1][1] + grid[2][2]*mat.grid[2][1] + grid[2][3]*mat.grid[3][1];
		float m22 = grid[2][0]*mat.grid[0][2] + grid[2][1]*mat.grid[1][2] + grid[2][2]*mat.grid[2][2] + grid[2][3]*mat.grid[3][2];
		float m23 = grid[2][0]*mat.grid[0][3] + grid[2][1]*mat.grid[1][3] + grid[2][2]*mat.grid[2][3] + grid[2][3]*mat.grid[3][3];

		float m30 = grid[3][0]*mat.grid[0][0] + grid[3][1]*mat.grid[1][0] + grid[3][2]*mat.grid[2][0] + grid[3][3]*mat.grid[3][0];
		float m31 = grid[3][0]*mat.grid[0][1] + grid[3][1]*mat.grid[1][1] + grid[3][2]*mat.grid[2][1] + grid[3][3]*mat.grid[3][1];
		float m32 = grid[3][0]*mat.grid[0][2] + grid[3][1]*mat.grid[1][2] + grid[3][2]*mat.grid[2][2] + grid[3][3]*mat.grid[3][2];
		float m33 = grid[3][0]*mat.grid[0][3] + grid[3][1]*mat.grid[1][3] + grid[3][2]*mat.grid[2][3] + grid[3][3]*mat.grid[3][3];

		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		grid[0][3]=m03;
		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;
		grid[1][3]=m13;
		grid[2][0]=m20;
		grid[2][1]=m21;
		grid[2][2]=m22;
		grid[2][3]=m23;
		grid[3][0]=m30;
		grid[3][1]=m31;
		grid[3][2]=m32;
		grid[3][3]=m33;

	}

	float GetPitch(){

		float x = grid[2][0];
		float y = grid[2][1];
		float z = grid[2][2];
		return -atan2deg( y, sqrt( x*x+z*z ) );

	}

	float GetYaw(){

		float x = grid[2][0];
		float z = grid[2][2];
		return atan2deg( x,z );

	}

	float GetRoll(){

		float iy = grid[0][1];
		float jy = grid[1][1];
		return atan2deg( iy, jy );

	}

	void FromToRotation(float ix, float iy, float iz, float jx, float jy, float jz){

		float hvx, hvz, hvxy, hvxz, hvyz;
		float dotu, dotv, dotuv;
		float u[3], v[3];
		float c1,c2,c3;
		float x0,x1,x2;
		float e, h;
		//int i, j;

		//v = cross(from, To)
		v[0] = iy * jz - iz * jy;
		v[1] = iz * jx - ix * jz;
		v[2] = ix * jy - iy * jx;

		//e = DOT(from, To);
		e = ix * jx + iy * jy + iz * jz;

		if (abs(e) > 1.0 - 0.000001) {     /* "from" And "to"-vector almost parallel */

			x0 = abs(ix);
		 	x1 = abs(iy);
			x2 = abs(iz);

			if (x0 < x1){
				if (x0 < x2){
					x0 = 1.0;
					x1 = 0.0;
					x2 = 0.0;
				}else{
					x2 = 1.0;
					x0 = 0.0;
					x1 = 0.0;
				}
			}else{
				if (x1 < x2){
					x1 = 1.0;
					x0 = 0.0;
					x2 = 0.0;
				}else{
					x2 = 1.0;
					x0 = 0.0;
					x1 = 0.0;
				}
			}

			u[0] = x0 - ix;
			u[1] = x1 - iy;
			u[2] = x2 - iz;

			v[0] = x0 - jx;
			v[1] = x1 - jy;
			v[2] = x2 - jz;

			dotu  = u[0] * u[0] + u[1] * u[1] + u[2] * u[2];
			dotv  = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
			dotuv = u[0] * v[0] + u[1] * v[1] + u[2] * v[2];

			if (dotu != 0) {c1 = 2.0 / dotu;} else {c1 = 10000;}
			if (dotv != 0) {c2 = 2.0 / dotv;} else {c2 = 10000;}
			c3 = c1 * c2 * dotuv;

			for (int i = 0; i <= 2; i++){
				for (int j = 0; j <= 2; j++){
				   grid[j][i] = - c1 * u[i] * u[j] - c2 * v[i] * v[j] + c3 * v[i] * u[j];
				}
				grid[i][i] = grid[i][i] + 1.0;
			}

		}else{  /* the most common Case, unless "from"="to", Or "from"=-"to" */

			h = 1.0/(1.0 + e);      /* optimization by Gottfried Chen */
			hvx = h * v[0];
			hvz = h * v[2];
			hvxy = hvx * v[1];
			hvxz = hvx * v[2];
			hvyz = hvz * v[1];
			grid[0][0] = e + hvx * v[0];
			grid[1][0] = hvxy - v[2];
			grid[2][0] = hvxz + v[1];

			grid[0][1] = hvxy + v[2];
			grid[1][1] = e + h * v[1] * v[1];
			grid[2][1] = hvyz - v[0];

			grid[0][2] = hvxz - v[1];
			grid[1][2] = hvyz + v[0];
			grid[2][2] = e + hvz * v[2];

		}

		grid[3][0] = 0;
		grid[3][1] = 0;
		grid[3][2] = 0;
		grid[0][3] = 0;
		grid[1][3] = 0;
		grid[2][3] = 0;
		grid[3][3] = 1;

	}

	void ToQuat( float &qx, float &qy, float &qz, float &qw){

		float trace = grid[0][0] + grid[1][1] + grid[2][2] + 1.0;
		float s;

		if( trace > 0.0001 ) {
			s = 0.5 / sqrt(trace);
			qw = 0.25 / s;
			qx = ( grid[1][2] - grid[2][1] ) * s;
			qy = ( grid[2][0] - grid[0][2] ) * s;
			qz = ( grid[0][1] - grid[1][0] ) * s;
		}else{
			if (( grid[0][0] > grid[1][1]) && (grid[0][0] > grid[2][2])) {
				s = 2.0 * sqrt( 1.0 + grid[0][0] - grid[1][1] - grid[2][2]);
				qw = (grid[1][2] - grid[2][1] ) / s;
				qx = 0.25 * s;
				qy = (grid[1][0] + grid[0][1] ) / s;
				qz = (grid[2][0] + grid[0][2] ) / s;
			}else if (grid[1][1] > grid[2][2]) {
				s = 2.0 * sqrt( 1.0 + grid[1][1] - grid[0][0] - grid[2][2]);
				qw = (grid[2][0] - grid[0][2]) / s;
				qx = (grid[1][0] + grid[0][1] ) / s;
				qy = 0.25 * s;
				qz = (grid[2][1] + grid[1][2] ) / s;
			}else{
				s = 2.0 * sqrt( 1.0 + grid[2][2] - grid[0][0] - grid[1][1] );
				qw = (grid[0][1] - grid[1][0] ) / s;
				qx = (grid[2][0] + grid[0][2] ) / s;
				qy = (grid[2][1] + grid[1][2] ) / s;
				qz = 0.25 * s;
			}
		}

	}


};

void Quaternion_FromAngleAxis( float angle, float ax, float ay, float az, float &rx, float &ry, float &rz, float &rw);
void Quaternion_MultiplyQuat( float x1, float y1, float z1, float w1, float x2, float y2, float z2, float w2, float &rx, float &ry, float &rz, float &rw );
void InterpolateMatrix(Matrix &m, Matrix &a, float alpha);
#endif

