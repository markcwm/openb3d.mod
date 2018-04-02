#ifndef GLEW_GLEE_H
#define GLEW_GLEE_H

#ifdef OPENB3D_GLEW // use Glew in linux
	
#include "glew.h"
	
#else // use GLee in Win and Mac
	
#ifdef __linux__ // GLee not building in linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glu.h>
#endif
	
#ifdef _WIN32
#include "GLee.h"
#include <GL\glu.h>
#endif
	
#ifdef __APPLE__
#include "GLee.h"
#include <OpenGL/glu.h>
#endif
	
#endif

#endif
