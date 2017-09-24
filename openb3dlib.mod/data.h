// data.h

#include "openb3d/src/actions.h"
#include "openb3d/src/pick.h"
#include "openb3d/src/light.h"
#include "openb3d/src/shadow.h"
#include "openb3d/src/quaternion.h"

#include <vector>
#include <list>
//using namespace std;

extern "C" {

// Static
char* StaticChar( int classid,int varid );
int* StaticInt( int classid,int varid );
float* StaticFloat( int classid,int varid );
Entity* StaticEntity( int classid,int varid );
Camera* StaticCamera( int classid,int varid );
Pivot* StaticPivot( int classid,int varid );
Surface* StaticSurface( int classid,int varid );
int StaticListSize( int classid,int varid );
Action* StaticIterListAction( int classid,int varid,int &id );
Camera* StaticIterListCamera( int classid,int varid,int &id );
Entity* StaticIterListEntity( int classid,int varid,int &id );
ShadowObject* StaticIterListShadowObject( int classid,int varid,int &id );
Terrain* StaticIterListTerrain( int classid,int varid,int &id );
Texture* StaticIterListTexture( int classid,int varid,int &id );
Light* StaticIterVectorLight( int classid,int varid,int &id );

// Action
int* ActionInt( Action* obj,int varid );
float* ActionFloat( Action* obj,int varid );
Entity* ActionEntity( Action* obj,int varid );

// AnimationKeys
int* AnimationKeysInt( AnimationKeys* obj,int varid );
float* AnimationKeysFloat( AnimationKeys* obj,int varid );
AnimationKeys* NewAnimationKeys();

// Bone
float* BoneFloat( Bone* obj,int varid );
AnimationKeys* BoneAnimationKeys( Bone* obj,int varid );
Matrix* BoneMatrix( Bone* obj,int varid );

// Brush
int* BrushInt( Brush* obj,int varid );
unsigned int* BrushUInt( Brush* obj,int varid );
float* BrushFloat( Brush* obj,int varid );
const char* BrushString( Brush* obj,int varid );
Texture* BrushTextureArray( Brush* obj,int varid,int index );

// Camera
bool* CameraBool( Camera* obj,int varid );
int* CameraInt( Camera* obj,int varid );
float* CameraFloat( Camera* obj,int varid );

// Entity
int* EntityInt( Entity* obj,int varid );
float* EntityFloat( Entity* obj,int varid );
const char* EntityString( Entity* obj,int varid );
Entity* EntityEntity( Entity* obj,int varid );
Matrix* EntityMatrix( Entity* obj,int varid );
Brush* EntityBrush( Entity* obj,int varid );
int EntityListSize( Entity* obj,int varid );
Entity* EntityIterListEntity( Entity* obj,int varid,int &id );
void EntityListPushBackEntity( Entity* obj,int varid,Entity* ent );
void EntityListRemoveEntity( Entity* obj,int varid,Entity* ent );

// Light
char* LightChar( Light* obj,int varid );
float* LightFloat( Light* obj,int varid );

// Matrix
float* MatrixFloat( Matrix* obj,int varid );
Matrix* NewMatrix();

// Mesh
int* MeshInt( Mesh* obj,int varid );
float* MeshFloat( Mesh* obj,int varid );
Matrix* MeshMatrix( Mesh* obj,int varid );
int MeshListSize( Mesh* obj,int varid );
Surface* MeshIterListSurface( Mesh* obj,int varid,int &id );
Bone* MeshIterVectorBone( Mesh* obj,int varid,int &id );
vector<Bone*>* MeshVectorBone( Mesh* obj,int varid );
void MeshListPushBackSurface( Mesh* obj,int varid,Surface* surf );
void MeshListPushBackBone( Mesh* obj,int varid,Bone* bone );

// Quaternion
float* QuaternionFloat( Quaternion* obj,int varid );
Quaternion* NewQuaternion();

// ShadowObject
char* ShadowObjectChar( ShadowObject* obj,int varid );
int* ShadowObjectInt( ShadowObject* obj,int varid );
Mesh* ShadowObjectMesh( ShadowObject* obj,int varid );
Surface* ShadowObjectSurface( ShadowObject* obj,int varid );

// Sprite
int* SpriteInt( Sprite* obj,int varid );
float* SpriteFloat( Sprite* obj,int varid );

// Surface
unsigned short* SurfaceUShort( Surface* obj,int varid );
int* SurfaceInt( Surface* obj,int varid );
unsigned int* SurfaceUInt( Surface* obj,int varid );
float* SurfaceFloat( Surface* obj,int varid );
Brush* SurfaceBrush( Surface* obj,int varid );
Shader* SurfaceShader( Surface* obj,int varid );

// Terrain
float* TerrainFloat( Terrain* obj,int varid );
Camera* TerrainCamera( Terrain* obj,int varid );
Shader* TerrainShader( Terrain* obj,int varid );

// Texture
int* TextureInt( Texture* obj,int varid );
unsigned int* TextureUInt( Texture* obj,int varid );
float* TextureFloat( Texture* obj,int varid );
const char* TextureString( Texture* obj,int varid );
list<Texture*>* TextureListTexture( Texture* obj,int varid );


} // extern "C"
