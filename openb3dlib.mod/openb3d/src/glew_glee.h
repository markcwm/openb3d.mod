#ifndef GLEW_GLEE_H
#define GLEW_GLEE_H

#ifdef _WIN32 // Win x86 untested!
	#define OPENB3D_GLEW 1
#elif defined(_WIN64) // x86 and x64
	#define OPENB3D_GLEW 1
#endif

#ifdef __APPLE__ // PPC not supported
	#if (__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ > MAC_OS_X_VERSION_10_6) // Mac x64 if OSX > 10.6
		#define OPENB3D_GLEW 1
	#else // x86
		#define OPENB3D_GLEE 2
	#endif
#endif

#ifdef __linux__ // Linux x86 untested!
	#if defined(__x86_64__) || defined(__ia64__) // x64, itanium
		#define OPENB3D_GLEW 1
	#else // x86
		#define OPENB3D_GLEW 1
	#endif
#endif

#ifdef OPENB3D_GLEW
	#include "glew.h"
#elif defined(OPENB3D_GLEE)
	#ifdef __linux__
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
