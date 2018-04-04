#ifndef GLEW_GLEE_H
#define GLEW_GLEE_H

#ifdef _WIN32 // Glew in Win, also GLee, Win x86 untested!
	#if defined(__x86_64__) || defined(_M_X64) // x86 64-bit
		#define OPENB3D_GLEW
	#elif defined(__i386) || defined(_M_IX86) // x86 32-bit
		#define OPENB3D_GLEW
	#endif
#endif

#ifdef __APPLE__ // need Glew in newer/x64 Mac, GLee in older/x86 Mac, PPC not supported
	#if defined(__x86_64__) || defined(_M_X64) // x86 64-bit
		#define OPENB3D_GLEW
	#elif defined(__i386) || defined(_M_IX86) // x86 32-bit
		#define OPENB3D_GLEE
	#endif
#endif

#ifdef __linux__ // need Glew in Linux x64, Linux x86 untested!
	#if defined(__x86_64__) || defined(_M_X64) // x86 64-bit
		#define OPENB3D_GLEW
	#elif defined(__i386) || defined(_M_IX86) // x86 32-bit
		#define OPENB3D_GLEW
	#endif
#endif

#ifdef OPENB3D_GLEW
	#include "glew.h"
#elif OPENB3D_GLEE
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
