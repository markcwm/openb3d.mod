/*
 *  quaternion.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "quaternion.h"

#include "matrix.h"
#include "maths_helper.h"

void QuatToMat(float w,float x,float y,float z,Matrix& mat){

	float q[4];
	q[0]=w;
	q[1]=x;
	q[2]=y;
	q[3]=z;
	
	float xx=q[1]*q[1];
	float yy=q[2]*q[2];
	float zz=q[3]*q[3];
	float xy=q[1]*q[2];
	float xz=q[1]*q[3];
	float yz=q[2]*q[3];
	float wx=q[0]*q[1];
	float wy=q[0]*q[2];
	float wz=q[0]*q[3];

	mat.grid[0][0]=1-2*(yy+zz);
	mat.grid[0][1]=  2*(xy-wz);
	mat.grid[0][2]=  2*(xz+wy);
	mat.grid[1][0]=  2*(xy+wz);
	mat.grid[1][1]=1-2*(xx+zz);
	mat.grid[1][2]=  2*(yz-wx);
	mat.grid[2][0]=  2*(xz-wy);
	mat.grid[2][1]=  2*(yz+wx);
	mat.grid[2][2]=1-2*(xx+yy);
	mat.grid[3][3]=1;

	for(int iy=0;iy<3;iy++){
		for(int ix=0;ix<3;ix++){
			xx=mat.grid[ix][iy];
			if(xx<0.0001 && xx>-0.0001) xx=0;
			mat.grid[ix][iy]=xx;
		}
	}

}

void QuatToEuler(float w,float x,float y,float z,float &pitch,float &yaw,float &roll){

	float q[4];
	q[0]=w;
	q[1]=x;
	q[2]=y;
	q[3]=z;
	
	float xx=q[1]*q[1];
	float yy=q[2]*q[2];
	float zz=q[3]*q[3];
	float xy=q[1]*q[2];
	float xz=q[1]*q[3];
	float yz=q[2]*q[3];
	float wx=q[0]*q[1];
	float wy=q[0]*q[2];
	float wz=q[0]*q[3];

	Matrix mat;
	
	mat.grid[0][0]=1-2*(yy+zz);
	mat.grid[0][1]=  2*(xy-wz);
	mat.grid[0][2]=  2*(xz+wy);
	mat.grid[1][0]=  2*(xy+wz);
	mat.grid[1][1]=1-2*(xx+zz);
	mat.grid[1][2]=  2*(yz-wx);
	mat.grid[2][0]=  2*(xz-wy);
	mat.grid[2][1]=  2*(yz+wx);
	mat.grid[2][2]=1-2*(xx+yy);
	mat.grid[3][3]=1;

	for(int iy=0;iy<3;iy++){
		for(int ix=0;ix<3;ix++){
			xx=mat.grid[ix][iy];
			if(xx<0.0001 && xx>-0.0001) xx=0;
			mat.grid[ix][iy]=xx;
		}
	}

	pitch=atan2deg( mat.grid[2][1],sqrt( mat.grid[2][0]*mat.grid[2][0]+mat.grid[2][2]*mat.grid[2][2] ) );
	yaw=atan2deg(mat.grid[2][0],mat.grid[2][2]);
	roll=atan2deg(mat.grid[0][1],mat.grid[1][1]);
			
	//(if pitch=NAN) pitch=0;
	//(if yaw  =NAN) yaw  =0;
	//(if roll =NAN) roll =0;

}

void Slerp(float Ax,float Ay,float Az,float Aw,float Bx,float By,float Bz,float Bw,float& Cx,float& Cy,float& Cz,float& Cw,float t){
	
	if(abs(Ax-Bx)<0.001 && abs(Ay-By)<0.001 && abs(Az-Bz)<0.001 && abs(Aw-Bw)<0.001){
		Cx=Ax;
		Cy=Ay;
		Cz=Az;
		Cw=Aw;
		return;// true;
	}
	
	float cosineom=Ax*Bx+Ay*By+Az*Bz+Aw*Bw;
	float scaler_w=0.0;
	float scaler_x=0.0;
	float scaler_y=0.0;
	float scaler_z=0.0;
	
	if(cosineom <= 0.0){
		cosineom=-cosineom;
		scaler_w=-Bw;
		scaler_x=-Bx;
		scaler_y=-By;
		scaler_z=-Bz;
	}else{
		scaler_w=Bw;
		scaler_x=Bx;
		scaler_y=By;
		scaler_z=Bz;
	}
	
	float scale0=0.0;
	float scale1=0.0;
	
	if((1.0 - cosineom)>0.0001){
		float omega=acosdeg(cosineom);
		float sineom=sindeg(omega);
		scale0=sindeg((1.0-t)*omega)/sineom;
		scale1=sindeg(t*omega)/sineom;
	}else{
		scale0=1.0-t;
		scale1=t;
	}
		
	Cw=scale0*Aw+scale1*scaler_w;
	Cx=scale0*Ax+scale1*scaler_x;
	Cy=scale0*Ay+scale1*scaler_y;
	Cz=scale0*Az+scale1*scaler_z;
		
}
