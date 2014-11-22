#ifndef MATHS_HELPER_H
#define MATHS_HELPER_H
/*
 *  maths_helper.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include <cmath>  // or <cmath> for C++

// Sombunall versions of math.h already define M_PI
#ifndef M_PI
// You can extend this approximation as far as you need to;
// this version was copied from the MINGW GCC headers
#define M_PI 3.14159265358979323846
#endif

#define DEG_CIRCLE 360
#define DEG_TO_RAD (M_PI / (DEG_CIRCLE / 2))
#define RAD_TO_DEG ((DEG_CIRCLE / 2) / M_PI)

// this assumes that your compiler supports C99 or C++
// otherwise, you can use macros to get the same result

inline double deg2rad(double degrees)
{
    return degrees * DEG_TO_RAD;
}

inline double rad2deg(double radians)
{
    return radians * RAD_TO_DEG;
}

double cosdeg(double);
double sindeg(double);
double tandeg(double);
double acosdeg(double);
double asindeg(double);
double atandeg(double);
double atan2deg(double,double);

#endif
