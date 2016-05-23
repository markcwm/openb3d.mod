#ifdef OPENB3D_GLEW
#include "glew.h"
#else
#ifdef linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glu.h>
#endif

#ifdef WIN32
#include <gl\GLee.h>
#endif

#ifdef __APPLE__
#include "GLee.h"
#endif
#endif

#include "isosurface.h"
#include "global.h"
#include "camera.h"
#include "pick.h"

//#define GLES2
#ifdef GLES2
#include "light.h"
#endif


static float Xcf, Ycf, Zcf;

static list<Blob*> render_blobs;

static FieldArray* data_array;

static int level;


/*extern*/ const int edgeTable[256]={
0x0  , 0x109, 0x203, 0x30a, 0x406, 0x50f, 0x605, 0x70c,
0x80c, 0x905, 0xa0f, 0xb06, 0xc0a, 0xd03, 0xe09, 0xf00,
0x190, 0x99 , 0x393, 0x29a, 0x596, 0x49f, 0x795, 0x69c,
0x99c, 0x895, 0xb9f, 0xa96, 0xd9a, 0xc93, 0xf99, 0xe90,
0x230, 0x339, 0x33 , 0x13a, 0x636, 0x73f, 0x435, 0x53c,
0xa3c, 0xb35, 0x83f, 0x936, 0xe3a, 0xf33, 0xc39, 0xd30,
0x3a0, 0x2a9, 0x1a3, 0xaa , 0x7a6, 0x6af, 0x5a5, 0x4ac,
0xbac, 0xaa5, 0x9af, 0x8a6, 0xfaa, 0xea3, 0xda9, 0xca0,
0x460, 0x569, 0x663, 0x76a, 0x66 , 0x16f, 0x265, 0x36c,
0xc6c, 0xd65, 0xe6f, 0xf66, 0x86a, 0x963, 0xa69, 0xb60,
0x5f0, 0x4f9, 0x7f3, 0x6fa, 0x1f6, 0xff , 0x3f5, 0x2fc,
0xdfc, 0xcf5, 0xfff, 0xef6, 0x9fa, 0x8f3, 0xbf9, 0xaf0,
0x650, 0x759, 0x453, 0x55a, 0x256, 0x35f, 0x55 , 0x15c,
0xe5c, 0xf55, 0xc5f, 0xd56, 0xa5a, 0xb53, 0x859, 0x950,
0x7c0, 0x6c9, 0x5c3, 0x4ca, 0x3c6, 0x2cf, 0x1c5, 0xcc ,
0xfcc, 0xec5, 0xdcf, 0xcc6, 0xbca, 0xac3, 0x9c9, 0x8c0,
0x8c0, 0x9c9, 0xac3, 0xbca, 0xcc6, 0xdcf, 0xec5, 0xfcc,
0xcc , 0x1c5, 0x2cf, 0x3c6, 0x4ca, 0x5c3, 0x6c9, 0x7c0,
0x950, 0x859, 0xb53, 0xa5a, 0xd56, 0xc5f, 0xf55, 0xe5c,
0x15c, 0x55 , 0x35f, 0x256, 0x55a, 0x453, 0x759, 0x650,
0xaf0, 0xbf9, 0x8f3, 0x9fa, 0xef6, 0xfff, 0xcf5, 0xdfc,
0x2fc, 0x3f5, 0xff , 0x1f6, 0x6fa, 0x7f3, 0x4f9, 0x5f0,
0xb60, 0xa69, 0x963, 0x86a, 0xf66, 0xe6f, 0xd65, 0xc6c,
0x36c, 0x265, 0x16f, 0x66 , 0x76a, 0x663, 0x569, 0x460,
0xca0, 0xda9, 0xea3, 0xfaa, 0x8a6, 0x9af, 0xaa5, 0xbac,
0x4ac, 0x5a5, 0x6af, 0x7a6, 0xaa , 0x1a3, 0x2a9, 0x3a0,
0xd30, 0xc39, 0xf33, 0xe3a, 0x936, 0x83f, 0xb35, 0xa3c,
0x53c, 0x435, 0x73f, 0x636, 0x13a, 0x33 , 0x339, 0x230,
0xe90, 0xf99, 0xc93, 0xd9a, 0xa96, 0xb9f, 0x895, 0x99c,
0x69c, 0x795, 0x49f, 0x596, 0x29a, 0x393, 0x99 , 0x190,
0xf00, 0xe09, 0xd03, 0xc0a, 0xb06, 0xa0f, 0x905, 0x80c,
0x70c, 0x605, 0x50f, 0x406, 0x30a, 0x203, 0x109, 0x0   };

//gives which vertices to join to form triangles for the surface
extern const int triTable[256][16] =
{{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 1, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 8, 3, 9, 8, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 2, 10, 0, 2, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{2, 8, 3, 2, 10, 8, 10, 9, 8, -1, -1, -1, -1, -1, -1, -1},
{3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 11, 2, 8, 11, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 9, 0, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 11, 2, 1, 9, 11, 9, 8, 11, -1, -1, -1, -1, -1, -1, -1},
{3, 10, 1, 11, 10, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, -1},
{3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, -1},
{9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1},
{9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1},
{2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, -1},
{8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, -1},
{9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1},
{4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, -1},
{3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, -1},
{1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, -1},
{4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, -1},
{4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, -1},
{9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1},
{5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, -1},
{2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, -1},
{9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1},
{0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1},
{2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, -1},
{10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1},
{4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, -1},
{5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, -1},
{5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1},
{9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, -1},
{0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, -1},
{1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, -1},
{10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, -1},
{8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, -1},
{2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1},
{7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1},
{9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, -1},
{2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, -1},
{11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, -1},
{9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, -1},
{5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, -1},
{11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, -1},
{11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1},
{1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, -1},
{9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, -1},
{5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, -1},
{2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1},
{0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1},
{5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, -1},
{6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, -1},
{3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, -1},
{6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, -1},
{5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, -1},
{1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1},
{10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, -1},
{6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, -1},
{8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, -1},
{7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, -1},
{3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1},
{5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, -1},
{0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1},
{9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, -1},
{8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, -1},
{5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, -1},
{0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, -1},
{6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, -1},
{10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1},
{10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, -1},
{8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, -1},
{1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, -1},
{3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, -1},
{0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1},
{10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, -1},
{3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, -1},
{6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, -1},
{9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, -1},
{8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, -1},
{3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, -1},
{6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, -1},
{0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, -1},
{10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, -1},
{10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, -1},
{2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, -1},
{7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, -1},
{7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, -1},
{2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, -1},
{1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, -1},
{11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, -1},
{8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, -1},
{0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, -1},
{7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1},
{10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1},
{2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1},
{6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, -1},
{7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, -1},
{2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, -1},
{1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, -1},
{10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, -1},
{10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, -1},
{0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, -1},
{7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, -1},
{6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, -1},
{8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, -1},
{9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, -1},
{6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, -1},
{4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, -1},
{10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, -1},
{8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1},
{0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, -1},
{1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, -1},
{8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, -1},
{10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, -1},
{4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, -1},
{10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1},
{5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1},
{11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, -1},
{9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1},
{6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, -1},
{7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, -1},
{3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, -1},
{7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, -1},
{9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, -1},
{3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, -1},
{6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, -1},
{9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, -1},
{1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, -1},
{4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, -1},
{7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, -1},
{6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1},
{3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, -1},
{0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, -1},
{6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, -1},
{0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, -1},
{11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, -1},
{6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, -1},
{5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, -1},
{9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, -1},
{1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, -1},
{1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, -1},
{10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, -1},
{0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{10, 5, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, -1},
{5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, -1},
{10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, -1},
{11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, -1},
{9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, -1},
{7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, -1},
{2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1},
{8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, -1},
{9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, -1},
{9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, -1},
{1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, -1},
{9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, -1},
{9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1},
{5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, -1},
{0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, -1},
{10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, -1},
{2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, -1},
{0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, -1},
{0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, -1},
{9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, -1},
{5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, -1},
{3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, -1},
{5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, -1},
{8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, -1},
{0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, -1},
{9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1},
{0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, -1},
{1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, -1},
{3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, -1},
{4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, -1},
{9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, -1},
{11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, -1},
{11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, -1},
{2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, -1},
{9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, -1},
{3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, -1},
{1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, -1},
{4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, -1},
{4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, -1},
{0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, -1},
{3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, -1},
{3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, -1},
{0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{3, 2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, -1},
{9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, -1},
{1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}};




float MetaballsField (float x, float y, float z){
	list<Blob*>::iterator it;
	float field=0;
	for(it=render_blobs.begin();it!=render_blobs.end();it++){
		Blob* blob=*it;
		float xd = blob->mat.grid[3][0]-x;
		float yd = blob->mat.grid[3][1]-y;
		float zd = blob->mat.grid[3][2]+z;
		float r2=xd*xd + yd*yd + zd*zd;
		field+=blob->charge/r2;
		/*if (r2<=1)
			field+=(1-r2)*(1-r2);*/

	}

	return field;
}

float ArraysField (float x, float y, float z){

	data_array->mat.TransformVec(x, y, z, 1);

	int X,Y,Z;
	X=(int)x;
	Y=(int)y;
	Z=(int)z;

	int w=data_array->width;
	int h=data_array->height;
	int d=data_array->depth;
	int Offset=X + Y*w + Z*w*h;

	if (X<0 || X>=w) return 0;
	if (Y<0 || Y>=h) return 0;
	if (Z<0 || Z>=d) return 0;

	float a1,a2,a3,a4,a5,a6,a7,a8;
	a1=data_array->data[Offset];
	a2=data_array->data[Offset + 1];
	a3=data_array->data[Offset + w];
	a4=data_array->data[Offset + 1 + w];
	a5=data_array->data[Offset + w*h];
	a6=data_array->data[Offset + 1 + w*h];
	a7=data_array->data[Offset + w + w*h];
	a8=data_array->data[Offset + 1 +w + w*h];


	float i1,i2,i3,i4,i5,i6;

	i1=a1+(a2-a1)*(x-X);
	i2=a3+(a4-a3)*(x-X);
	i3=a5+(a6-a5)*(x-X);
	i4=a7+(a8-a7)*(x-X);
	i5=i1+(i2-i1)*(y-Y);
	i6=i3+(i4-i3)*(y-Y);

	return i5+(i6-i5)*(z-Z);

}

Fluid* Fluid::CreateFluid(){
	Fluid* fluid=new Fluid();
	fluid->class_name="Fluid";

	Global::root_ent->child_list.push_back(fluid);
	fluid->parent=0;

	entity_list.push_back(fluid);

	fluid->UpdateMat(true);

	fluid->min_x=-999999999;
	fluid->max_x=999999999;
	fluid->min_y=-999999999;
	fluid->max_y=999999999;
	fluid->min_z=-999999999;
	fluid->max_z=999999999;
	fluid->no_surfs=1;

	Surface* surf=new Surface();
	fluid->surf_list.push_back(surf);

	fluid->ScalarField=&MetaballsField;

	fluid->threshold=.5;
	fluid->render_mode=0;

	fluid->ResetBuffers();
#ifdef GLES2
	surf->UpdateVBO();
#endif

	return fluid;

}

void Fluid::FreeEntity(){
	Surface* surf=*surf_list.begin();
	delete surf;
	surf_list.clear();


	for (int i=0;i<20;i++){
		for (int i1=0;i1<62;i1++){
			delete[] xzbuffer[i][i1];
			delete[] xybuffer[i][i1];
			delete[] yzbuffer[i][i1];
		}
		delete[] xzbuffer[i];
		delete[] xybuffer[i];
		delete[] yzbuffer[i];

	}

	delete[] xzbuffer;
	delete[] xybuffer;
	delete[] yzbuffer;

	delete[] buffercenter;

	Entity::FreeEntity();

	delete this;

	return;


}

void Fluid::FluidFunction(float (*FieldFunction)(float, float, float)){
	ScalarField=FieldFunction;
}

void Fluid::FluidArray(float* Array, int w, int h, int d){
	ScalarField=&ArraysField;
	render_mode=2;
	fieldarray=new FieldArray;
	fieldarray->data=Array;
	fieldarray->width=w;
	fieldarray->height=h;
	fieldarray->depth=d;
}

void Fluid::MarchingCube(float x, float y, float z, float x1, float y1, float z1, float F[8]){

	float EdgeX[12], EdgeY[12], EdgeZ[12];

	Surface* surf=*surf_list.begin();

	unsigned char cubeIndex=0;
	
	if(F[6] < threshold)
		cubeIndex |= 1;
	if(F[7] < threshold)
		cubeIndex |= 2;
	if(F[3] < threshold)
		cubeIndex |= 4;
	if(F[2] < threshold)
		cubeIndex |= 8;
	if(F[4] < threshold)
		cubeIndex |= 16;
	if(F[5] < threshold)
		cubeIndex |= 32;
	if(F[1] < threshold)
		cubeIndex |= 64;
	if(F[0] < threshold)
		cubeIndex |= 128;

	//look this value up in the edge table to see which edges to interpolate along
	int usedEdges=edgeTable[cubeIndex];

	//if the cube is entirely within/outside surface, no faces			
	if(usedEdges==0 || usedEdges==255)
		return;

	if(usedEdges & 1){
		float Ratio = ( threshold - F[6] )/( F[7] - F[6] );

		EdgeX[0] = x  + Ratio*(x1 - x );
		EdgeY[0] = y1 + Ratio*(y1 - y1);
		EdgeZ[0] = z1 + Ratio*(z1 - z1);


	}
	if(usedEdges & 2){
		float Ratio = ( threshold - F[7] )/( F[3] - F[7] );

		EdgeX[1] = x1 + Ratio*(x1 - x1);
		EdgeY[1] = y1 + Ratio*(y1 - y1);
		EdgeZ[1] = z1 + Ratio*(z  - z1);

	}
	if(usedEdges & 4){
		float Ratio = ( threshold - F[3] )/( F[2] - F[3] );

		EdgeX[2] = x1 + Ratio*(x  - x1);
		EdgeY[2] = y1 + Ratio*(y1 - y1);
		EdgeZ[2] = z  + Ratio*(z  - z );

	}
	if(usedEdges & 8){
		float Ratio = ( threshold - F[2] )/( F[6] - F[2] );

		EdgeX[3] = x  + Ratio*(x  - x );
		EdgeY[3] = y1 + Ratio*(y1 - y1);
		EdgeZ[3] = z  + Ratio*(z1 - z );

	}


	if(usedEdges & 16){
		float Ratio = ( threshold - F[4] )/( F[5] - F[4] );

		EdgeX[4] = x  + Ratio*(x1 - x );
		EdgeY[4] = y  + Ratio*(y  - y );
		EdgeZ[4] = z1 + Ratio*(z1 - z1);

	}
	if(usedEdges & 32){
		float Ratio = ( threshold - F[5] )/( F[1] - F[5] );

		EdgeX[5] = x1 + Ratio*(x1 - x1);
		EdgeY[5] = y  + Ratio*(y  - y );
		EdgeZ[5] = z1 + Ratio*(z  - z1);

	}
	if(usedEdges & 64){
		float Ratio = ( threshold - F[1] )/( F[0] - F[1] );

		EdgeX[6] = x1 + Ratio*(x  - x1);
		EdgeY[6] = y  + Ratio*(y  - y );
		EdgeZ[6] = z  + Ratio*(z  - z );

	}
	if(usedEdges & 128){
		float Ratio = ( threshold - F[0] )/( F[4] - F[0] );

		EdgeX[7] = x  + Ratio*(x  - x );
		EdgeY[7] = y  + Ratio*(y  - y );
		EdgeZ[7] = z  + Ratio*(z1 - z );
	}


	if(usedEdges & 256){
		float Ratio = ( threshold - F[4] )/( F[6] - F[4] );

		EdgeX[8] = x  + Ratio*(x  - x );
		EdgeY[8] = y  + Ratio*(y1 - y );
		EdgeZ[8] = z1 + Ratio*(z1 - z1);
	}
	if(usedEdges & 512){
		float Ratio = ( threshold - F[5] )/( F[7] - F[5] );

		EdgeX[9] = x1 + Ratio*(x1 - x1);
		EdgeY[9] = y  + Ratio*(y1 - y );
		EdgeZ[9] = z1 + Ratio*(z1 - z1);
	}
	if(usedEdges & 1024){
		float Ratio = ( threshold - F[1] )/( F[3] - F[1] );

		EdgeX[10] = x1 + Ratio*(x1 - x1);
		EdgeY[10] = y  + Ratio*(y1 - y );
		EdgeZ[10] = z  + Ratio*(z  - z );
	}
	if(usedEdges & 2048){
		float Ratio = ( threshold - F[0] )/( F[2] - F[0] );

		EdgeX[11] = x  + Ratio*(x  - x );
		EdgeY[11] = y  + Ratio*(y1 - y );
		EdgeZ[11] = z  + Ratio*(z  - z );
	}

	for(int k=0; triTable[cubeIndex][k]!=-1; k+=3){



		surf->vert_coords.push_back( EdgeX[triTable[cubeIndex][k+0]]);
		surf->vert_coords.push_back( EdgeY[triTable[cubeIndex][k+0]]);
		surf->vert_coords.push_back(-EdgeZ[triTable[cubeIndex][k+0]]);

		surf->vert_coords.push_back( EdgeX[triTable[cubeIndex][k+1]]);
		surf->vert_coords.push_back( EdgeY[triTable[cubeIndex][k+1]]);
		surf->vert_coords.push_back(-EdgeZ[triTable[cubeIndex][k+1]]);

		surf->vert_coords.push_back( EdgeX[triTable[cubeIndex][k+2]]);
		surf->vert_coords.push_back( EdgeY[triTable[cubeIndex][k+2]]);
		surf->vert_coords.push_back(-EdgeZ[triTable[cubeIndex][k+2]]);

		if(brush.fx&4){
			float ax,ay,az,bx,by,bz;
			float nx,ny,nz;
			ax = EdgeX[triTable[cubeIndex][k+1]]-EdgeX[triTable[cubeIndex][k+0]];
			ay = EdgeY[triTable[cubeIndex][k+1]]-EdgeY[triTable[cubeIndex][k+0]];
			az = EdgeZ[triTable[cubeIndex][k+1]]-EdgeZ[triTable[cubeIndex][k+0]];
			bx = EdgeX[triTable[cubeIndex][k+2]]-EdgeX[triTable[cubeIndex][k+1]];
			by = EdgeY[triTable[cubeIndex][k+2]]-EdgeY[triTable[cubeIndex][k+1]];
			bz = EdgeZ[triTable[cubeIndex][k+2]]-EdgeZ[triTable[cubeIndex][k+1]];
			nx = ( ay * bz ) - ( az * by );
			ny = ( az * bx ) - ( ax * bz );
			nz = ( ax * by ) - ( ay * bx );


			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
			surf->vert_norm.push_back(nx); surf->vert_norm.push_back(ny);surf->vert_norm.push_back(nz);
		}else{

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]]+1,EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]])-ScalarField(EdgeX[triTable[cubeIndex][k+0]]-1,EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]]+1,EdgeZ[triTable[cubeIndex][k+0]])-ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]]-1,EdgeZ[triTable[cubeIndex][k+0]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+0]],EdgeY[triTable[cubeIndex][k+0]],EdgeZ[triTable[cubeIndex][k+0]]-1));

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]]+1,EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]])-ScalarField(EdgeX[triTable[cubeIndex][k+1]]-1,EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]]+1,EdgeZ[triTable[cubeIndex][k+1]])-ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]]-1,EdgeZ[triTable[cubeIndex][k+1]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+1]],EdgeY[triTable[cubeIndex][k+1]],EdgeZ[triTable[cubeIndex][k+1]]-1));

			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]]+1,EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]])-ScalarField(EdgeX[triTable[cubeIndex][k+2]]-1,EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]]+1,EdgeZ[triTable[cubeIndex][k+2]])-ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]]-1,EdgeZ[triTable[cubeIndex][k+2]]));
			surf->vert_norm.push_back(ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]+1)-ScalarField(EdgeX[triTable[cubeIndex][k+2]],EdgeY[triTable[cubeIndex][k+2]],EdgeZ[triTable[cubeIndex][k+2]]-1));
		}





/*surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);
surf->vert_col.push_back(1.0);*/

		surf->no_verts+=3;

	}



/*int v1,v2,v3;
v3=surf->AddVertex(x,y1,-z);
v2=surf->AddVertex(x1,y,-z);
v1=surf->AddVertex(x,y,-z);
v4=surf->AddVertex(x,y,-z1);
v5=surf->AddVertex(x1,y,-z);
v6=surf->AddVertex(x,y1,-z);*/

//surf->AddTriangle(v1,v2,v3);


}


float Fluid::MiddlePoint (float A, float B, float C, float D){

/*
	if (A<threshold){
		if (C>=threshold){
			if (B<threshold){
				if (D>=threshold){
					float m=(A + B) / 2;
					return (threshold-m) / ((threshold-A) / (C - A) + (threshold-B) / (D - B))+m;

				} else
				{
				}
			} 
			
		} else if (B>=threshold){
			if (C<threshold){
				if (D>=threshold){
					float m=(A + C) / 2;
					return (threshold-m) / ((threshold-A) / (B - A) + (threshold-C) / (D - C))+m;


				}
			}
		}

	} else {
		if (C<threshold){
			if (B>=threshold){
				if (D<threshold){
					float m=(C + D) / 2;
					return (threshold-m) / ((threshold-C) / (A - C) + (threshold-D) / (B - D))+m;


				}
			}
		} else if (B<threshold){
			if (C>=threshold){
				if (D<threshold){
					float m=(B + D) / 2;
					return (threshold-m) / ((threshold-B) / (A - B) + (threshold-D) / (C - D))+m;

				}
			}
		}
	}*/

	unsigned char sideIndex=0;
	
	if(A < threshold)
		sideIndex |= 1;
	if(B < threshold)
		sideIndex |= 2;
	if(C < threshold)
		sideIndex |= 4;
	if(D < threshold)
		sideIndex |= 8;

	switch (sideIndex){
		case 9:
		case 14:
		case 1:{
			float c1=(threshold-A) / (C - A);
			float c2=(threshold-A) / (B - A);
			return (threshold-A) / (2*(c1*c2) / (c1+c2))+A;
			}
		case 2:
		case 13:
		case 6:{
			float c1=(threshold-B) / (A - B);
			float c2=(threshold-B) / (D - B);
			return (threshold-B) / (2*(c1*c2) / (c1+c2))+B;
			}
		case 12:
		case 3:{
			float m=(threshold-A) / (C - A) + (threshold-B) / (D - B);
			if (m<1)
				{
					float m2=(A+B)/2;
					return (threshold-m2)/m +m2;
				}else{
					float m2=(C+D)/2;
					return (threshold-m2)/(2-m) +m2;
				}
			}
		case 11:
		case 4:{
			float c1=(threshold-C) / (A - C);
			float c2=(threshold-C) / (D - C);
			return (threshold-C) / (2*(c1*c2) / (c1+c2))+C;
			}
		case 10:
		case 5:{
			float m=(threshold-A) / (B - A) + (threshold-C) / (D - C);
			if (m<1)
				{
					float m2=(A+C)/2;
					return (threshold-m2)/m +m2;
				}else{
					float m2=(B+D)/2;
					return (threshold-m2)/(2-m) +m2;
				}
			}
		case 7:
		case 8:{
			float c1=(threshold-D) / (C - D);
			float c2=(threshold-D) / (B - D);
			return (threshold-D) / (2*(c1*c2) / (c1+c2))+D;
			}
/*		case 10:{
			float m=(B + D) / 2;
			return (threshold-m) / ((threshold-B) / (A - B) + (threshold-D) / (C - D))+m;
			}
		case 12:{
			float m=(C + D) / 2;
			return (threshold-m) / ((threshold-C) / (A - C) + (threshold-D) / (B - D))+m;
			}
*/
		default:
			return (A+B+C+D)/4;
	}
	
}


void Fluid::BuildCubeGrid(float x, float y, float z, float l, float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8){

	for (int i = 0 ;i<= 5; i++){
		float d = Global::camera_in_use->frustum[i][0] * x +
		 Global::camera_in_use->frustum[i][1] * y -
		 Global::camera_in_use->frustum[i][2] * z +
		 Global::camera_in_use->frustum[i][3];
		if (d <= -l*sqrt(6)) return;//{ds=ds/10; break;}
	}

	float dx,dy,dz;	
	float rc;	

	/* compute distance from node To camera (approximated for speed, don't need to be exact) */
	dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);
	rc = dx+dy+dz;

	if (rc*.1<=3*l){

		int ix=(x - Xcf)/l+.5+buffercenter[level];
		int iy=(y - Ycf)/l+.5+buffercenter[level];
		int iz=(z - Zcf)/l+.5+buffercenter[level];

		float F[27];
		F[0] =f1;							//ScalarField(x-l, y-l, z-l);
		F[1] =xzbuffer[level][ix+1][iz+1];				//ScalarField(x  , y-l, z-l);
		F[2] =f2;							//ScalarField(x+l, y-l, z-l);
		F[3] =xybuffer[level][ix+1][iy+1];				//ScalarField(x-l, y,   z-l);
		F[4] =xybuffer[level][ix][iy];					//ScalarField(x  , y,   z-l);
		F[5] =xybuffer[level][ix+1][iy];				//ScalarField(x+l, y,   z-l);
		F[6] =f3;							//ScalarField(x-l, y+l, z-l);
		F[7] =xybuffer[level][ix][iy+1];				//ScalarField(x  , y+l, z-l);
		F[8] =f4;							//ScalarField(x+l, y+l, z-l);

		F[9] =yzbuffer[level][iy+1][iz+1];				//ScalarField(x-l, y-l, z);
		F[10]=xzbuffer[level][ix][iz];					//ScalarField(x,   y-l, z);
		F[11]=xzbuffer[level][ix+1][iz];				//ScalarField(x+l, y-l, z);
		F[12]=yzbuffer[level][iy][iz];					//ScalarField(x-l, y,   z);
		F[13]=ScalarField(x,   y,   z);
		F[14]=ScalarField(x+l, y,   z);
		F[15]=yzbuffer[level][iy+1][iz];				//ScalarField(x-l, y+l, z);
		F[16]=ScalarField(x,   y+l, z);
		F[17]=ScalarField(x+l, y+l, z);

		F[18]=f5;							//ScalarField(x-l, y-l, z+l);
		F[19]=xzbuffer[level][ix][iz+1];				//ScalarField(x  , y-l, z+l);
		F[20]=f6;							//ScalarField(x+l, y-l, z+l);
		F[21]=yzbuffer[level][iy][iz+1];				//ScalarField(x-l, y,   z+l);
		F[22]=ScalarField(x  , y,   z+l);
		F[23]=ScalarField(x+l, y,   z+l);
		F[24]=f7;							//ScalarField(x-l, y+l, z+l);
		F[25]=ScalarField(x  , y+l, z+l);
		F[26]=f8;							//ScalarField(x+l, y+l, z+l);

		//fix cracks

		dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);	//Back
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
			F[3] = (f1+f3)/2;
			F[4] = MiddlePoint(f1,f2,f3,f4);
			F[5] = (f2+f4)/2;
			F[7] = (f3+f4)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);	//Front
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[19] = (f5+f6)/2;
			F[21] = (f5+f7)/2;
			F[22] = MiddlePoint(f5,f6,f7,f8);
			F[23] = (f6+f8)/2;
			F[25] = (f7+f8)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);	//Left
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[3] = (f1+f3)/2;
			F[9] = (f1+f5)/2;
			F[12] = MiddlePoint(f1,f3,f5,f7);
			F[15] = (f3+f7)/2;
			F[21] = (f5+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - Zcf);	//Right
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[5] = (f2+f4)/2;
			F[11] = (f2+f6)/2;
			F[14] = MiddlePoint(f2,f4,f6,f8);
			F[17] = (f4+f8)/2;
			F[23] = (f6+f8)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);	//Up
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
			F[9] = (f1+f5)/2;
			F[10] = MiddlePoint(f1,f2,f5,f6);
			F[11] = (f2+f6)/2;
			F[19] = (f5+f6)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);	//Down
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[7] = (f3+f4)/2;
			F[15] = (f3+f7)/2;
			F[16] = MiddlePoint(f3,f4,f7,f8);
			F[17] = (f4+f8)/2;
			F[25] = (f7+f8)/2;
		}

		//Edges
		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[1] = (f1+f2)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[7] = (f3+f4)/2;
		}

		dx = abs(x - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[19] = (f5+f6)/2;
		}

		dx = abs(x - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[25] = (f7+f8)/2;
		}


		dx = abs(x - 2 * l - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[9] = (f1+f5)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[11] = (f2+f6)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[15] = (f3+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y + 2 * l - Ycf); dz = abs(z - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[17] = (f4+f8)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[3] = (f1+f3)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z - 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[5] = (f2+f4)/2;
		}

		dx = abs(x - 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[21] = (f5+f7)/2;
		}

		dx = abs(x + 2 * l - Xcf); dy = abs(y - Ycf); dz = abs(z + 2 * l - Zcf);
		rc = dx+dy+dz;
		if (rc*.1>3*l){
			F[23] = (f6+f8)/2;
		}

		//Stores data that will be reused, so we don't have to compute them again

		xzbuffer[level][ix][iz]=F[16];
		xzbuffer[level][ix+1][iz]=F[17];
		xzbuffer[level][ix][iz+1]=F[25];
		xzbuffer[level][ix+1][iz+1]=F[7];

		xybuffer[level][ix][iy]=F[22];
		xybuffer[level][ix+1][iy]=F[23];
		xybuffer[level][ix][iy+1]=F[25];
		xybuffer[level][ix+1][iy+1]=F[21];

		yzbuffer[level][iy][iz]=F[14];
		yzbuffer[level][iy+1][iz]=F[17];
		yzbuffer[level][iy][iz+1]=F[23];
		yzbuffer[level][iy+1][iz+1]=F[11];


		l=l/2;
		level+=1;

		BuildCubeGrid (x-l, y-l, z-l,l,  F[0], F[1], F[3], F[4], F[9], F[10], F[12], F[13]);
		BuildCubeGrid (x+l, y-l, z-l,l,  F[1], F[2], F[4], F[5], F[10], F[11], F[13], F[14]);
		BuildCubeGrid (x-l, y+l, z-l,l,  F[3], F[4], F[6], F[7], F[12], F[13], F[15], F[16]);
		BuildCubeGrid (x+l, y+l, z-l,l,  F[4], F[5], F[7], F[8], F[13], F[14], F[16], F[17]);
		BuildCubeGrid (x-l, y-l, z+l,l,  F[9], F[10], F[12], F[13], F[18], F[19], F[21], F[22]);
		BuildCubeGrid (x+l, y-l, z+l,l,  F[10], F[11], F[13], F[14], F[19], F[20], F[22], F[23]);
		BuildCubeGrid (x-l, y+l, z+l,l,  F[12], F[13], F[15], F[16], F[21], F[22], F[24], F[25]);
		BuildCubeGrid (x+l, y+l, z+l,l,  F[13], F[14], F[16], F[17], F[22], F[23], F[25], F[26]);

		level-=1;
	} else {
		float F[8];
		F[0] =f1;
		F[1] =f2;
		F[2] =f3;
		F[3] =f4;
		F[4] =f5;
		F[5] =f6;
		F[6] =f7;
		F[7] =f8;


		MarchingCube (x-l, y-l, z-l,x+l,y+l,z+l, F);
	}

}

void Fluid::ResetBuffers(){

	xzbuffer=new float**[20];
	xybuffer=new float**[20];
	yzbuffer=new float**[20];
	buffercenter=new int[20];

	for (int i=0;i<20;i++){
		buffercenter[i]=31;
		xzbuffer[i]=new float*[62];
		xybuffer[i]=new float*[62];
		yzbuffer[i]=new float*[62];
		for (int i1=0;i1<62;i1++){
			xzbuffer[i][i1]=new float[62];
			xybuffer[i][i1]=new float[62];
			yzbuffer[i][i1]=new float[62];
		}

	}

}

void Fluid::Render(){
	Xcf=Global::camera_in_use->EntityX();
	Ycf=Global::camera_in_use->EntityY();
	Zcf=Global::camera_in_use->EntityZ();

	Surface* surf=*surf_list.begin();
	surf->no_verts=0;

	surf->vert_coords.clear();
	surf->vert_norm.clear();
	surf->vert_col.clear();
	surf->no_tris=0;

	if (render_mode==1){
		// Only metaballs that are in the view frustum are used to compute the scalar field
		render_blobs.clear();
		list<Blob*>::iterator it;

		for(it=metaball_list.begin();it!=metaball_list.end();it++){
			Blob* blob=*it;
			if (Global::camera_in_use->EntityInFrustum(blob)){
				render_blobs.push_back(blob);
			}
		}
	}else if (render_mode==0){
		render_blobs=metaball_list;
	}else
	{
		//Array
		data_array=fieldarray;
		MQ_GetInvMatrix(fieldarray->mat);
	}

	level=0;



	surf->tris.clear();


	glBindBuffer(GL_ARRAY_BUFFER,0);

	BuildCubeGrid (Xcf, Ycf, Zcf, Global::camera_in_use->range_far,0,0,0,0,0,0,0,0);


#ifndef GLES2
	glDisable(GL_ALPHA_TEST);
#endif

	if (order!=0){
		glDisable(GL_DEPTH_TEST);
		glDepthMask(GL_FALSE);
	}else{
		glEnable(GL_DEPTH_TEST);
		glDepthMask(GL_TRUE);
	}

	switch(brush.blend){
		case 0:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
			break;
		case 1:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
			break;
		case 2:
			glBlendFunc(GL_DST_COLOR,GL_ZERO); // multiply
			break;
		case 3:
			glBlendFunc(GL_SRC_ALPHA,GL_ONE); // additive and alpha
			break;
		}

	float ambient_red,ambient_green,ambient_blue;

#ifndef GLES2
	// fx flag 1 - full bright ***todo*** disable all lights?
	if (brush.fx & 1){
		if(Global::fx1!=true){
			Global::fx1=true;
			glDisableClientState(GL_NORMAL_ARRAY);
		}
		ambient_red  =1.0;
		ambient_green=1.0;
		ambient_blue =1.0;
	}else{
		if(Global::fx1!=false){
			Global::fx1=false;
			glEnableClientState(GL_NORMAL_ARRAY);
		}
		ambient_red  =Global::ambient_red;
		ambient_green=Global::ambient_green;
		ambient_blue =Global::ambient_blue;
	}

	// fx flag 2 - vertex colours
	if(Global::fx2!=false){
		Global::fx2=false;
		glDisableClientState(GL_COLOR_ARRAY);
		glDisable(GL_COLOR_MATERIAL);
	}


	// fx flag 4 - flatshaded
	if(!brush.fx&4){
		glShadeModel(GL_SMOOTH);
	}

	// fx flag 8 - disable fog
	if(brush.fx&8){
		if(Global::fog_enabled==true){ // only disable if fog enabled in camera update
			glDisable(GL_FOG);
		}
	}

	// fx flag 16 - disable backface culling
	if(brush.fx&16){
		glDisable(GL_CULL_FACE);
	}else{
		glEnable(GL_CULL_FACE);
	}

	// light + material color

	float ambient[]={ambient_red,ambient_green,ambient_blue};
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT,ambient);

	float mat_ambient[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_diffuse[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_specular[]={brush.shine,brush.shine,brush.shine,brush.shine};
	float mat_shininess[]={100.0}; // upto 128

	glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,mat_ambient);
	glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,mat_diffuse);
	glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,mat_specular);
	glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS,mat_shininess);
#else
	int tex_count=0;
	tex_count=brush.no_texs;
	//if(surf.brush!=NULL){
	int tblendflags[8][2];
	float tmatrix[8][9];
	float tcoords[8];

	if (&Global::shaders[Light::no_lights][tex_count][Global::camera_in_use->fog_mode]!=Global::shader){
		Global::shader=&Global::shaders[Light::no_lights][tex_count][Global::camera_in_use->fog_mode];
		glUseProgram(Global::shader->ambient_program);
		glUniformMatrix4fv(Global::shader->view, 1 , 0, &Global::camera_in_use->mod_mat[0] );
		glUniformMatrix4fv(Global::shader->proj, 1 , 0, &Global::camera_in_use->proj_mat[0] );

		glUniformMatrix4fv(Global::shader->lightMat, Light::no_lights , 0, Light::light_matrices[0][0] );
		glUniform1fv(Global::shader->lightType, Light::no_lights , Light::light_types);
		glUniform1fv(Global::shader->lightOuterCone, Light::no_lights , Light::light_outercone);
		glUniform3fv(Global::shader->lightColor, Light::no_lights , Light::light_color[0]);

		glUniform3f(Global::shader->fogColor, Global::camera_in_use->fog_r, Global::camera_in_use->fog_g, Global::camera_in_use->fog_b);
		glUniform2f(Global::shader->fogRange, Global::camera_in_use->fog_range_near, Global::camera_in_use->fog_range_far);
	}

	if(brush.fx&1){
		if(Global::fx1!=true){
			Global::fx1=true;
		}
		ambient_red  =1.0;
		ambient_green=1.0;
		ambient_blue =1.0;
	}else{
		if(Global::fx1!=false){
			Global::fx1=false;
		}
		ambient_red  =Global::ambient_red;
		ambient_green=Global::ambient_green;
		ambient_blue =Global::ambient_blue;
	}

	if(brush.fx&16){
		glDisable(GL_CULL_FACE);
	}else{
		glEnable(GL_CULL_FACE);
	}


	glUniform3f(Global::shader->amblight, ambient_red,ambient_green,ambient_blue);

	glUniform1f(Global::shader->shininess, brush.shine);

	float mat_ambient[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_diffuse[]={brush.red,brush.green,brush.blue,brush.alpha};
	float mat_specular[]={brush.shine,brush.shine,brush.shine,brush.shine};
	float mat_shininess[]={100.0}; // upto 128

#endif


	int DisableCubeSphereMapping=0;
#ifndef GLES2
	int tex_count=0;
#endif

	if(surf->ShaderMat!=NULL){
		surf->ShaderMat->TurnOn(mat, surf);
	}else{

#ifndef GLES2
		tex_count=brush.no_texs;
#endif
		for(int ix=0;ix<tex_count;ix++){

			if(brush.tex[ix]){

				// Main brush texture takes precedent over surface brush texture
				unsigned int texture=0;
				int tex_flags=0,tex_blend=0;
				float tex_u_scale=1.0,tex_v_scale=1.0,tex_u_pos=0.0,tex_v_pos=0.0,tex_ang=0.0;
				int tex_cube_mode=0;


				texture=brush.cache_frame[ix];
				tex_flags=brush.tex[ix]->flags;
				tex_blend=brush.tex[ix]->blend;
				tex_u_scale=brush.tex[ix]->u_scale;
				tex_v_scale=brush.tex[ix]->v_scale;
				tex_u_pos=brush.tex[ix]->u_pos;
				tex_v_pos=brush.tex[ix]->v_pos;
				tex_ang=brush.tex[ix]->angle;
				tex_cube_mode=brush.tex[ix]->cube_mode;
				//frame=brush.tex_frame;

				glActiveTexture(GL_TEXTURE0+ix);
#ifndef GLES2
				glClientActiveTexture(GL_TEXTURE0+ix);
#endif

				glEnable(GL_TEXTURE_2D);
				glBindTexture(GL_TEXTURE_2D,texture); // call before glTexParameteri

#ifndef GLES2
				// masked texture flag
				if(tex_flags&4){
					glEnable(GL_ALPHA_TEST);
				}else{
					glDisable(GL_ALPHA_TEST);
				}
#endif

				// mipmapping texture flag
				if(tex_flags&8){
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
				}else{
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
				}

				// clamp u flag
				if(tex_flags&16){
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
				}else{
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
				}

				// clamp v flag
				if(tex_flags&32){
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
				}else{
					glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
				}

#ifndef GLES2
					// ***!ES***

					if(tex_flags<64){
						glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
						glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
						glEnable(GL_TEXTURE_GEN_S);
						glEnable(GL_TEXTURE_GEN_T);
					}

					// spherical environment map texture flag
					if(tex_flags&64){
						glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
						glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
						glEnable(GL_TEXTURE_GEN_S);
						glEnable(GL_TEXTURE_GEN_T);
					}

					// cubic environment map texture flag
					if(tex_flags&128){

						glEnable(GL_TEXTURE_CUBE_MAP);
						glBindTexture(GL_TEXTURE_CUBE_MAP,texture); // call before glTexParameteri

						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_R,GL_CLAMP_TO_EDGE);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
						glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);

						glEnable(GL_TEXTURE_GEN_S);
						glEnable(GL_TEXTURE_GEN_T);
						glEnable(GL_TEXTURE_GEN_R);
						//glEnable(GL_TEXTURE_GEN_Q)

						if(tex_cube_mode==1){
							glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
							glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
							glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
						}

						if(tex_cube_mode==2){
							glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
							glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
							glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
						}
						DisableCubeSphereMapping=1;

					}else  if (DisableCubeSphereMapping!=0){

						glDisable(GL_TEXTURE_CUBE_MAP);

						glDisable(GL_TEXTURE_GEN_R);

					}


				switch(tex_blend){
					case 0: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE);
					break;
					case 1: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
					break;
					case 2: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
					//case 2 glTexEnvf(GL_TEXTURE_ENV,GL_COMBINE_RGB_EXT,GL_MODULATE);
					break;
					case 3: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_ADD);
					break;
					case 4:
						glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_EXT);
						glTexEnvf(GL_TEXTURE_ENV, GL_COMBINE_RGB_EXT, GL_DOT3_RGB_EXT);
						break;
					case 5:
						glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE);
						glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_MODULATE);
						glTexEnvi(GL_TEXTURE_ENV,GL_RGB_SCALE,2.0);
						break;
					default: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
				}

				//No texture coords are used, since the surface is implicit

				// reset texture matrix
				glMatrixMode(GL_TEXTURE);
				glLoadIdentity();

				if(tex_u_pos!=0.0 || tex_v_pos!=0.0){
					glTranslatef(tex_u_pos,tex_v_pos,0.0);
				}
				if(tex_ang!=0.0){
					glRotatef(tex_ang,0.0,0.0,1.0);
				}
				if(tex_u_scale!=1.0 || tex_v_scale!=1.0){
					glScalef(tex_u_scale,tex_v_scale,1.0);
				}

				// ***!ES***
				// if spheremap flag=true then flip tex
				if(tex_flags&64){
					glScalef(1.0,-1.0,-1.0);
				}

				// if cubemap flag=true then manipulate texture matrix so that cubemap is displayed properly
				if(tex_flags&128){

					glScalef(1.0,-1.0,-1.0);

					// get current modelview matrix (set in last camera update)
					float mod_mat[16];
					glGetFloatv(GL_MODELVIEW_MATRIX,&mod_mat[0]);

					// get rotational inverse of current modelview matrix
					Matrix new_mat;
					new_mat.LoadIdentity();

					new_mat.grid[0][0] = mod_mat[0];
					new_mat.grid[1][0] = mod_mat[1];
					new_mat.grid[2][0] = mod_mat[2];

					new_mat.grid[0][1] = mod_mat[4];
					new_mat.grid[1][1] = mod_mat[5];
					new_mat.grid[2][1] = mod_mat[6];

					new_mat.grid[0][2] = mod_mat[8];
					new_mat.grid[1][2] = mod_mat[9];
					new_mat.grid[2][2] = mod_mat[10];

					glMultMatrixf(&new_mat.grid[0][0]);

				}
#else
				tmatrix[ix][0]= 1.0; tmatrix[ix][1]= 0.0; tmatrix[ix][2]= 0.0;
				tmatrix[ix][3]= 0.0; tmatrix[ix][4]= 1.0; tmatrix[ix][5]= 0.0;
				tmatrix[ix][6]= 0.0; tmatrix[ix][7]= 0.0; tmatrix[ix][8]= 1.0;

				if(tex_u_pos!=0.0 || tex_v_pos!=0.0){
					tmatrix[ix][6]= tex_u_pos; tmatrix[ix][7]= tex_v_pos;
				}
				if(tex_ang!=0.0){
					float cos_ang=cosdeg(tex_ang);
					float sin_ang=sindeg(tex_ang);
					tmatrix[ix][0]= cos_ang; tmatrix[ix][1]= sin_ang; 
					tmatrix[ix][3]=-sin_ang; tmatrix[ix][4]= cos_ang; 

				}
				if(tex_u_scale!=1.0 || tex_v_scale!=1.0){
					tmatrix[ix][0]*= tex_u_scale; tmatrix[ix][1]*= tex_v_scale; 
					tmatrix[ix][3]*= tex_u_scale; tmatrix[ix][4]*= tex_v_scale; 
				}

				if(tex_flags&128){

					glEnable(GL_TEXTURE_CUBE_MAP);
					glBindTexture(GL_TEXTURE_CUBE_MAP,texture); // call before glTexParameteri
	
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_R,GL_CLAMP_TO_EDGE);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
					glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
				}

				tblendflags[ix][0]=tex_blend;
				tblendflags[ix][1]=tex_flags&(4|128);
				tcoords[ix]=0;
#endif


			}

		}
	}

	// draw tris
#ifndef GLES2
	glMatrixMode(GL_MODELVIEW);


	glNormalPointer(GL_FLOAT,0,&surf->vert_norm[0]);
	glColorPointer(4,GL_FLOAT,0,&surf->vert_col[0]);

	glVertexPointer(3,GL_FLOAT,0,&surf->vert_coords[0]);
#else
	glUniform2iv(Global::shader->texflag, tex_count , tblendflags[0]);
	glUniformMatrix3fv(Global::shader->texmat, tex_count, 0, tmatrix[0]);
	glUniform1fv(Global::shader->tex_coords_set, tex_count , tcoords);

	glBindBuffer(GL_ARRAY_BUFFER, surf->vbo_id[0]);
	glBufferData(GL_ARRAY_BUFFER,(surf->no_verts*3*sizeof(float)),&surf->vert_coords[0],GL_STREAM_DRAW);
	glVertexAttribPointer(Global::shader->vposition, 3, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(Global::shader->vposition);

	glVertexAttribPointer(Global::shader->tex_coords, 2, GL_FLOAT, GL_FALSE, 3*sizeof(float), 0);
	glEnableVertexAttribArray(Global::shader->tex_coords);

	glBindBuffer(GL_ARRAY_BUFFER, surf->vbo_id[3]);
	glBufferData(GL_ARRAY_BUFFER,(surf->no_verts*3*sizeof(float)),&surf->vert_norm[0],GL_STREAM_DRAW);
	glVertexAttribPointer(Global::shader->vnormal, 3, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(Global::shader->vnormal);

	/*glBindBuffer(GL_ARRAY_BUFFER, surf->vbo_id[4]);
	glBufferData(GL_ARRAY_BUFFER,(surf->no_verts*4*sizeof(float)),&surf->vert_col[0],GL_STREAM_DRAW);
	glVertexAttribPointer(Global::shader->color, 4, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(Global::shader->color);*/

	glUniformMatrix4fv(Global::shader->model, 1 , 0, &mat.grid[0][0] );

	glDisableVertexAttribArray(Global::shader->color);
	glVertexAttrib4f(Global::shader->color, brush.red,brush.green,brush.blue,brush.alpha);
#endif
	glDrawArrays(GL_TRIANGLES,0,surf->no_verts);

#ifndef GLES2
	// disable all texture layers
	for(int ix=0;ix<tex_count;ix++){

		glActiveTexture(GL_TEXTURE0+ix);
		glClientActiveTexture(GL_TEXTURE0+ix);

		// reset texture matrix
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();

		glDisable(GL_TEXTURE_2D);

		// ***!ES***
		if (DisableCubeSphereMapping!=0){
			glDisable(GL_TEXTURE_CUBE_MAP);
			glDisable(GL_TEXTURE_GEN_S);
			glDisable(GL_TEXTURE_GEN_T);
			glDisable(GL_TEXTURE_GEN_R);
			//DisableCubeSphereMapping=0;
		}

	}


	if (brush.fx&8 && Global::fog_enabled==true){
		glEnable(GL_FOG);
	}
	if(surf->ShaderMat!=NULL){
		surf->ShaderMat->TurnOff();
	}
#else
	glDisableVertexAttribArray(Global::shader->vposition);
#endif

}


void Blob::FreeEntity(){

	fluid->metaball_list.remove(this);

	Entity::FreeEntity();
	
	delete this;
	
	return;

}


Blob* Blob::CreateBlob(Fluid* fluid, float radius, Entity* parent_ent){
	if(parent_ent==NULL) parent_ent=Global::root_ent;

	Blob* blob=new Blob;
	blob->class_name="Blob";
		
	blob->AddParent(*parent_ent);
	entity_list.push_back(blob);

	// update matrix
	if(blob->parent!=NULL){
		blob->mat.Overwrite(blob->parent->mat);
		blob->UpdateMat();
	}else{
		blob->UpdateMat(true);
	}

	blob->charge=radius;
	float crs=radius*radius;
	blob->cull_radius=sqrt(crs+crs+crs);
	blob->fluid=fluid;


	fluid->metaball_list.push_back(blob);
	
	return blob;

}

Blob* Blob::CopyEntity(Entity* parent_ent){

	if(parent_ent==NULL) parent_ent=Global::root_ent;

	// new blob
	Blob* blob=new Blob;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(blob);
	}
	
	// lists
	
	// add parent, add to list
	blob->AddParent(*parent_ent);
	entity_list.push_back(blob);
	
	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(blob);
	}
	
	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(blob);
	}
	
	// update matrix
	if(blob->parent){
		blob->mat.Overwrite(blob->parent->mat);
	}else{
		blob->mat.LoadIdentity();
	}
	
	// copy entity info
	
	blob->mat.Multiply(mat);
	
	blob->px=px;
	blob->py=py;
	blob->pz=pz;
	blob->sx=sx;
	blob->sy=sy;
	blob->sz=sz;
	blob->rx=rx;
	blob->ry=ry;
	blob->rz=rz;
	blob->qw=qw;
	blob->qx=qx;
	blob->qy=qy;
	blob->qz=qz;

	blob->name=name;
	blob->class_name=class_name;
	blob->order=order;
	blob->hide=false;
	
	blob->cull_radius=cull_radius;
	blob->radius_x=radius_x;
	blob->radius_y=radius_y;
	blob->box_x=box_x;
	blob->box_y=box_y;
	blob->box_z=box_z;
	blob->box_w=box_w;
	blob->box_h=box_h;
	blob->box_d=box_d;
	blob->collision_type=collision_type;
	blob->pick_mode=pick_mode;
	blob->obscurer=obscurer;

	blob->charge=charge;
	blob->fluid=fluid;

	fluid->metaball_list.push_back(blob);

	return blob;
	
}

void FieldArray::FreeEntity(){
	delete this;
	
	return;
}

FieldArray* FieldArray::CopyEntity(Entity* parent_ent){ return 0;}

