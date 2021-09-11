#ifndef data_h
#define data_h

#include "openb3d/src/actions.h"
#include "openb3d/src/pick.h"
#include "openb3d/src/light.h"
#include "openb3d/src/shadow.h"
#include "openb3d/src/quaternion.h"
#include "openb3d/src/sprite_batch.h"

#include <vector>
#include <list>

#ifdef __cplusplus
extern "C" {
#endif

// Static
char* StaticChar_( int classid,int varid );
int* StaticInt_( int classid,int varid );
float* StaticFloat_( int classid,int varid );
Entity* StaticEntity_( int classid,int varid );
Camera* StaticCamera_( int classid,int varid );
Pivot* StaticPivot_( int classid,int varid );
Shader* StaticShader_( int classid,int varid );
Surface* StaticSurface_( int classid,int varid );
int StaticListSize_( int classid,int varid );
Action* StaticIterListAction_( int classid,int varid,int &id );
Brush* StaticIterListBrush_( int classid,int varid,int &id );
Camera* StaticIterListCamera_( int classid,int varid,int &id );
Entity* StaticIterListEntity_( int classid,int varid,int &id );
ShadowObject* StaticIterListShadowObject_( int classid,int varid,int &id );
Terrain* StaticIterListTerrain_( int classid,int varid,int &id );
Texture* StaticIterListTexture_( int classid,int varid,int &id );
Light* StaticIterVectorLight_( int classid,int varid,int &id );

// Action
int* ActionInt_( Action* obj,int varid );
float* ActionFloat_( Action* obj,int varid );
Entity* ActionEntity_( Action* obj,int varid );

// AnimationKeys
int* AnimationKeysInt_( AnimationKeys* obj,int varid );
float* AnimationKeysFloat_( AnimationKeys* obj,int varid );
AnimationKeys* NewAnimationKeys_( Bone* obj );

// Bone
float* BoneFloat_( Bone* obj,int varid );
AnimationKeys* BoneAnimationKeys_( Bone* obj,int varid );
Matrix* BoneMatrix_( Bone* obj,int varid );

// Brush
int* BrushInt_( Brush* obj,int varid );
unsigned int* BrushUInt_( Brush* obj,int varid );
float* BrushFloat_( Brush* obj,int varid );
const char* BrushString_( Brush* obj,int varid );
Texture* BrushTextureArray_( Brush* obj,int varid,int index );
void SetBrushString_( Brush* obj,int varid,char* cstr );

// Camera
bool* CameraBool_( Camera* obj,int varid );
int* CameraInt_( Camera* obj,int varid );
float* CameraFloat_( Camera* obj,int varid );
void GlobalListPushBackCamera_( int varid,Camera* obj );
void GlobalListRemoveCamera_( int varid,Camera* obj );

// Entity
int* EntityInt_( Entity* obj,int varid );
float* EntityFloat_( Entity* obj,int varid );
const char* EntityString_( Entity* obj,int varid );
Entity* EntityEntity_( Entity* obj,int varid );
Matrix* EntityMatrix2_( Entity* obj,int varid );
Brush* EntityBrush_( Entity* obj,int varid );
int EntityListSize_( Entity* obj,int varid );
Entity* EntityIterListEntity_( Entity* obj,int varid,int &id );
void EntityListPushBackEntity_( Entity* obj,int varid,Entity* ent );
void EntityListRemoveEntity_( Entity* obj,int varid,Entity* ent );
void GlobalListPushBackEntity_( int varid,Entity* obj );
void GlobalListRemoveEntity_( int varid,Entity* obj );
void SetEntityString_( Entity* obj,int varid,char* cstr );

// Light
char* LightChar_( Light* obj,int varid );
float* LightFloat_( Light* obj,int varid );

// Matrix
float* MatrixFloat_( Matrix* obj,int varid );
Matrix* NewMatrix_();

// Mesh
int* MeshInt_( Mesh* obj,int varid );
float* MeshFloat_( Mesh* obj,int varid );
Matrix* MeshMatrix_( Mesh* obj,int varid );
int MeshListSize_( Mesh* obj,int varid );
Surface* MeshIterListSurface_( Mesh* obj,int varid,int &id );
Bone* MeshIterVectorBone_( Mesh* obj,int varid,int &id );
vector<Bone*>* MeshVectorBone_( Mesh* obj,int varid );
void MeshListPushBackSurface_( Mesh* obj,int varid,Surface* surf );
void MeshListRemoveSurface_( Mesh* obj,int varid,Surface* surf );
void MeshListPushBackBone_( Mesh* obj,int varid,Bone* bone );
void MeshListRemoveBone_( Mesh* obj,int varid,Bone* bone );

// Model
float* SurfaceCopyFloatArray_( Surface* obj,int varid,Surface* surf );
float* SurfaceResizeFloatArray_( Surface* obj,int varid,int size );
int* SurfaceResizeIntArray_( Surface* obj,int varid,int size );
float* AnimationKeysResizeFloatArray_( AnimationKeys* obj,int varid,int size );
int* AnimationKeysResizeIntArray_( AnimationKeys* obj,int varid,int size );
vector<Bone*>* MeshResizeBoneVector_( Mesh* obj,int varid,int size );
void MeshSetBoneVector_( Mesh* obj,int varid,int pos,Bone* bone );

// MD2
void SurfaceVectorPushBackFloat_( Surface* obj,int varid,float value );

// Quaternion
float* QuaternionFloat_( Quaternion* obj,int varid );
Quaternion* NewQuaternion_();

// ShadowObject
char* ShadowObjectChar_( ShadowObject* obj,int varid );
int* ShadowObjectInt_( ShadowObject* obj,int varid );
Mesh* ShadowObjectMesh_( ShadowObject* obj,int varid );
Surface* ShadowObjectSurface_( ShadowObject* obj,int varid );

// Sprite
int* SpriteInt_( Sprite* obj,int varid );
float* SpriteFloat_( Sprite* obj,int varid );

// Surface
unsigned short* SurfaceUShort_( Surface* obj,int varid );
int* SurfaceInt_( Surface* obj,int varid );
unsigned int* SurfaceUInt_( Surface* obj,int varid );
float* SurfaceFloat_( Surface* obj,int varid );
Brush* SurfaceBrush_( Surface* obj,int varid );
Shader* SurfaceShader_( Surface* obj,int varid );

// Terrain
float* TerrainFloat_( Terrain* obj,int varid );
Camera* TerrainCamera_( Terrain* obj,int varid );
Shader* TerrainShader_( Terrain* obj,int varid );

// Texture
int* TextureInt_( Texture* obj,int varid );
unsigned int* TextureUInt_( Texture* obj,int varid );
unsigned int* TextureNewUIntArray_( Texture* obj,int varid,int array_size );
float* TextureFloat_( Texture* obj,int varid );
const char* TextureString_( Texture* obj,int varid );
list<Texture*>* TextureListTexture_( Texture* obj,int varid );
void GlobalListPushBackTexture_( int varid,Texture* obj );
void GlobalListRemoveTexture_( int varid,Texture* obj );
void SetTextureString_( Texture* obj,int varid,char* cstr );

// Vector
float* VectorFloat_( Vector* obj,int varid );
Vector* NewVector_();

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
