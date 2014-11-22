/*
 *  maths_helper.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "maths_helper.h"

double cosdeg(double degrees)
{
	return cos(deg2rad(degrees));
}

double sindeg(double degrees)
{
	return sin(deg2rad(degrees));
}

double tandeg(double degrees)
{
	return tan(deg2rad(degrees));
}

double acosdeg(double val)
{
	return rad2deg(acos(val));
}

double asindeg(double val)
{
	return rad2deg(asin(val));
}

double atandeg(double val)
{
	return rad2deg(atan(val));
}

double atan2deg(double val,double val2)
{
	return rad2deg(atan2(val,val2));
}
