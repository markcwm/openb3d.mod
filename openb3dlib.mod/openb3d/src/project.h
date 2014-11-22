/*
 * Mesa 3-D graphics library
 * Version:  3.3
 * Copyright (C) 1995-2000  Brian Paul
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef PROJECT_H
#define PROJECT_H

//#import <OpenGLES/ES1/gl.h>
#ifdef linux
#include <GL/gl.h>
#endif
#ifdef WIN32
#include <GL\gl.h>
#endif
#ifdef __APPLE__
#include <OpenGL/gl.h>
#endif

#ifdef PC_HEADER
#include "all.h"
#else
#include <stdio.h>
#include <string.h>
#include <math.h>
//#include "gluP.h"
#endif

#include <iostream>
using namespace std;

// !!! static void transform_point(GLfloat out[4], const GLfloat m[16], const GLfloat in[4]);
// !!! static void matmul(GLfloat * product, const GLfloat * a, const GLfloat * b);
// !!! static GLboolean invert_matrix(const GLfloat * m, GLfloat * out);
GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,const GLfloat model[16], const GLfloat proj[16],const GLint viewport[4],GLfloat * winx, GLfloat * winy, GLfloat * winz);
GLint gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,const GLfloat model[16], const GLfloat proj[16],const GLint viewport[4],GLfloat * objx, GLfloat * objy, GLfloat * objz);
//GLint gluUnProject4(GLfloat winx, GLfloat winy, GLfloat winz, GLfloat clipw,const GLfloat modelMatrix[16],const GLfloat projMatrix[16],const GLint viewport[4],GLclampd nearZ, GLclampd farZ,GLfloat * objx, GLfloat * objy, GLfloat * objz,GLfloat * objw);

#endif
