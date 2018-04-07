// methods.cpp

#include "openb3d/src/animation.h"
#include "openb3d/src/animation_keys.h"
#include "openb3d/src/pick.h"
#include "openb3d/src/light.h"
#include "openb3d/src/shadow.h"
#include "openb3d/src/quaternion.h"
#include "openb3d/src/model.h"

#include <string.h>

extern "C" {

// Animation

void AnimateMesh_( Mesh* ent1,float framef,int start_frame,int end_frame ){
	Animation::AnimateMesh( ent1,framef,start_frame,end_frame );
}

void AnimateMesh2_( Mesh* ent1,float framef,int start_frame,int end_frame ){
	Animation::AnimateMesh2( ent1,framef,start_frame,end_frame );
}

void AnimateMesh3_(Mesh* ent1){
	Animation::AnimateMesh3( ent1 );
}

void VertexDeform_(Mesh* ent){
	Animation::VertexDeform( ent );
}

// AnimationKeys

AnimationKeys* AnimationKeysCopy_( AnimationKeys* obj ){
	return obj->Copy();
}

// Brush

Brush* BrushCopy_( Brush* obj ){
	return obj->Copy();
}

int CompareBrushes_( Brush* brush1,Brush* brush2 ){
	return Brush::CompareBrushes( brush1,brush2 );
}

// Camera

void ExtractFrustum_( Camera* obj ){
	obj->ExtractFrustum();
}

float EntityInFrustum_( Camera* obj,Entity* ent ){
	return obj->EntityInFrustum( ent );
}

void CameraUpdate_( Camera* obj ){
	obj->Update();
}

void CameraRender_( Camera* obj ){
	obj->Render();
}

void UpdateSprite_( Camera* obj,Sprite& sprite ){
	obj->UpdateSprite( sprite );
}

void AddTransformedSpriteToSurface_( Camera* obj,Sprite& sprite,Surface* surf ){
	obj->AddTransformedSpriteToSurface( sprite,surf );
}

void RenderListAdd_( Camera* obj,Mesh* mesh ){
	obj->RenderListAdd( mesh );
}

void accPerspective_( Camera* obj,float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus ){
	obj->accPerspective( fovy,aspect,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus );
}

void accFrustum_( Camera* obj,float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus ){
	obj->accFrustum( left_,right_,bottom,top,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus );
}

void UpdateProjMatrix_( Camera* obj ){
	obj->UpdateProjMatrix();
}

void CameraUpdateEntityRender_( Entity* ent,Entity* cam ){
	UpdateEntityRender( ent,cam );
}

// Entity

int CountAllChildren_( Entity* obj,int no_children ){
	return obj->CountAllChildren( no_children );
}

Entity* GetChildFromAll_( Entity* obj,int child_no,int &no_children,Entity* ent ){
	return obj->GetChildFromAll( child_no,no_children,ent );
}

int Hidden_( Entity* obj ){
	return obj->Hidden();
}

void AlignToVector_( Entity* obj,float x,float y,float z,int axis,float rate ){
	obj->AlignToVector( x,y,z,axis,rate );
}

void UpdateMat_( Entity* obj,bool load_identity ){
	obj->UpdateMat( load_identity );
}

void AddParent_( Entity* obj,Entity &parent_ent ){
	obj->AddParent( parent_ent );
}

void UpdateChildren_( Entity* ent_p ){
	Entity::UpdateChildren( ent_p );
}

float EntityDistanceSquared_( Entity* obj,Entity* ent2 ){
	return obj->EntityDistanceSquared( ent2 );
}

void MQ_Update_( Entity* obj ){
	obj->MQ_Update();
}
void MQ_GetInvMatrix_( Entity* obj,Matrix &mat0 ){
	obj->MQ_GetInvMatrix( mat0 );
}

void MQ_GetMatrix_( Entity* obj,Matrix &mat3 ){
	obj->MQ_GetMatrix( mat3 );
}

void MQ_GetScaleXYZ_( Entity* obj,float &width,float &height,float &depth ){
	obj->MQ_GetScaleXYZ( width,height,depth );
}

void MQ_Turn_( Entity* obj,float ang,float vx,float vy,float vz,int glob ){
	obj->MQ_Turn( ang,vx,vy,vz,glob );
}

void MQ_ApplyNewtonTransform_( Entity* obj,const float* newtonMatrix ){
	obj->MQ_ApplyNewtonTransform( newtonMatrix );
}

// Global

void UpdateEntityAnim_( Mesh& mesh ){
	Global::UpdateEntityAnim( mesh );
}

// Light

void LightUpdate_( Light* obj ){
	obj->Update();
}

// Matrix

void MatrixLoadIdentity_( Matrix* obj ){
	obj->LoadIdentity();
}

Matrix* MatrixCopy_( Matrix* obj ){
	return obj->Copy();
}

void MatrixOverwrite_( Matrix* obj,Matrix &mat ){
	obj->Overwrite( mat );
}

void MatrixGetInverse_( Matrix* obj,Matrix &mat ){
	obj->GetInverse( mat );
}

void MatrixMultiply_( Matrix* obj,Matrix &mat ){
	obj->Multiply( mat );
}

void MatrixTranslate_( Matrix* obj,float x,float y,float z ){
	obj->Translate( x,y,z );
}

void MatrixScale_( Matrix* obj,float x,float y,float z ){
	obj->Scale( x,y,z );
}

void MatrixRotate_( Matrix* obj,float rx,float ry,float rz ){
	obj->Rotate( rx,ry,rz );
}

void MatrixRotatePitch_( Matrix* obj,float ang ){
	obj->RotatePitch( ang );
}

void MatrixRotateYaw_( Matrix* obj,float ang ){
	obj->RotateYaw( ang );
}

void MatrixRotateRoll_( Matrix* obj,float ang ){
	obj->RotateRoll( ang );
}

void MatrixFromQuaternion_( Matrix* obj,float x,float y,float z,float w ){
	obj->FromQuaternion( x,y,z,w );
}

void MatrixTransformVec_( Matrix* obj,float &rx,float &ry,float &rz,int addTranslation=0 ){
	obj->TransformVec( rx,ry,rz,addTranslation );
}

void MatrixTranspose_( Matrix* obj ){
	obj->Transpose();
}

void MatrixSetTranslate_( Matrix* obj,float x,float y,float z ){
	obj->SetTranslate( x,y,z );
}

void MatrixMultiply2_( Matrix* obj,Matrix &mat ){
	obj->Multiply2( mat );
}

void MatrixGetInverse2_( Matrix* obj,Matrix &mat ){
	obj->GetInverse2( mat );
}

float MatrixGetPitch_( Matrix* obj ){
	return obj->GetPitch();
}

float MatrixGetYaw_( Matrix* obj ){
	return obj->GetYaw();
}

float MatrixGetRoll_( Matrix* obj ){
	return obj->GetRoll();
}

void MatrixFromToRotation_( Matrix* obj,float ix,float iy,float iz,float jx,float jy,float jz ){
	obj->FromToRotation( ix,iy,iz,jx,jy,jz );
}

void MatrixToQuat_( Matrix* obj,float &qx,float &qy,float &qz,float &qw ){
	obj->ToQuat( qx,qy,qz,qw );
}

void MatrixQuaternion_FromAngleAxis_( float angle,float ax,float ay,float az,float &rx,float &ry,float &rz,float &rw ){
	Quaternion_FromAngleAxis( angle,ax,ay,az,rx,ry,rz,rw );
}

void MatrixQuaternion_MultiplyQuat_( float x1,float y1,float z1,float w1,float x2,float y2,float z2,float w2,float &rx,float &ry,float &rz,float &rw ){
	Quaternion_MultiplyQuat( x1,y1,z1,w1,x2,y2,z2,w2,rx,ry,rz,rw );
}

void MatrixInterpolateMatrix_( Matrix &m,Matrix &a,float alpha ){
	InterpolateMatrix( m,a,alpha );
}

// Mesh

void MeshColor_( Mesh* obj,float r,float g,float b,float a ){
	obj->MeshColor( r,g,b,a );
}

void MeshRed_( Mesh* obj,float r ){
	obj->MeshRed( r );
}

void MeshGreen_( Mesh* obj,float g ){
	obj->MeshGreen( g );
}

void MeshBlue_( Mesh* obj,float b ){
	obj->MeshBlue( b );
}

void MeshAlpha_( Mesh* obj,float a ){
	obj->MeshAlpha( a );
}

// Model

void ModelTrimVerts_( Surface* obj ){
	TrimVerts( obj );
}

void CopyBonesList_( Entity* ent,vector<Bone*>& bones ){
	Mesh::CopyBonesList( ent,bones );
}

Mesh* CollapseAnimMesh_( Mesh* obj,Mesh* mesh ){
	return obj->CollapseAnimMesh( mesh );
}

Mesh* CollapseChildren_( Mesh* obj,Entity* ent0,Mesh* mesh ){
	return obj->CollapseChildren( ent0,mesh );
}

void TransformMesh_( Mesh* obj,Matrix& mat ){
	obj->TransformMesh( mat );
}

void GetBounds_( Mesh* obj ){
	obj->GetBounds();
}

int Alpha_( Mesh* obj ){
	return obj->Alpha();
}

void TreeCheck_( Mesh* obj ){
	obj->TreeCheck();
}

void MeshRender_( Mesh* obj ){
	obj->Render();
}

void UpdateShadow_( Mesh* obj ){
	obj->UpdateShadow();
}

// Pick

Entity* PickMain_( float ax,float ay,float az,float bx,float by,float bz,float radius ){
	return Pick::PickMain( ax,ay,az,bx,by,bz,radius );
}

// Quaternion

void QuaternionToMat_( float w,float x,float y,float z,Matrix& mat ){
	QuatToMat( w,x,y,z,mat );
}
void QuaternionToEuler_( float w,float x,float y,float z,float &pitch,float &yaw,float &roll ){
	QuatToEuler( w,x,y,z,pitch,yaw,roll );
}
void QuaternionSlerp_( float Ax,float Ay,float Az,float Aw,float Bx,float By,float Bz,float Bw,float& Cx,float& Cy,float& Cz,float& Cw,float t ){
	Slerp( Ax,Ay,Az,Aw,Bx,By,Bz,Bw,Cx,Cy,Cz,Cw,t );
}

// ShadowObject

void SetShadowColor_( int R,int G,int B,int A ){
	ShadowObject::SetShadowColor( R,G,B,A );
}

void ShadowInit_(){
	ShadowObject::ShadowInit();
}

void RemoveShadowfromMesh_( ShadowObject* obj,Mesh* M ){
	obj->RemoveShadowfromMesh( M );
}

void ShadowObjectUpdate_( Camera* Cam ){
	ShadowObject::Update( Cam );
}

void RenderVolume_(){
	ShadowObject::RenderVolume();
}

void UpdateAnim_( ShadowObject* obj ){
	obj->UpdateAnim();
}

void ShadowObjectInit_( ShadowObject* obj ){
	obj->Init();
}

void InitShadow_( ShadowObject* obj ){
	obj->InitShadow();
}

void UpdateCaster_( ShadowObject* obj ){
	obj->UpdateCaster();
}

void ShadowRenderWorldZFail_(){
	ShadowObject::ShadowRenderWorldZFail();
}

// Sprite

void SpriteTexCoords_( Sprite* obj,int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set ){
	obj->SpriteTexCoords( cell_x,cell_y,cell_w,cell_h,tex_w,tex_h,uv_set );
}

void SpriteVertexColor_( Sprite* obj,int v,float r,float g,float b ){
	obj->SpriteVertexColor( v,r,g,b );
}

// Surface

Surface* SurfaceCopy_( Surface* obj ){
	return obj->Copy();
}

void SurfaceColor_( Surface* obj,float r,float g,float b,float a ){
	obj->SurfaceColor( r,g,b,a );
}

void SurfaceRed_( Surface* obj,float r ){
	obj->SurfaceRed( r );
}

void SurfaceGreen_( Surface* obj,float g ){
	obj->SurfaceGreen( g );
}

void SurfaceBlue_( Surface* obj,float b ){
	obj->SurfaceBlue( b );
}

void SurfaceAlpha_( Surface* obj,float a ){
	obj->SurfaceAlpha( a );
}

void SurfaceUpdateNormals_( Surface* obj ){
	obj->UpdateNormals();
}

float TriangleNX_( Surface* obj,int tri_no ){
	return obj->TriangleNX( tri_no );
}

float TriangleNY_( Surface* obj,int tri_no ){
	return obj->TriangleNY( tri_no );
}

float TriangleNZ_( Surface* obj,int tri_no ){
	return obj->TriangleNZ( tri_no );
}

void UpdateVBO_( Surface* obj ){
	obj->UpdateVBO();
}

void FreeVBO_( Surface* obj ){
	obj->FreeVBO();
}

void RemoveTri_( Surface* obj,int tri ){
	obj->RemoveTri( tri );
}

// Terrain

void UpdateTerrain_( Terrain* obj ){
	obj->UpdateTerrain();
}

void RecreateROAM_( Terrain* obj ){
	obj->RecreateROAM();
}

void drawsub_( Terrain* obj,int l,float v0[],float v1[],float v2[] ){
	obj->drawsub( l,v0,v1,v2 );
}

void TerrainUpdateNormals_( Terrain* obj ){
	obj->UpdateNormals();
}

void col_tree_sub_( Terrain* obj,int l,float v0[],float v1[],float v2[] ){
	obj->col_tree_sub( l,v0,v1,v2 );
}

// Texture

Texture* TextureCopy_( Texture* obj ){
	return obj->Copy();
}

Texture* TexInList_( Texture* obj,list<Texture*>& list_ref ){
	return obj->TexInList( list_ref );
}

void FilterFlags_( Texture* obj ){
	obj->FilterFlags();
}
void SetTextureFilename_( Texture* obj,char* t_filename ){
	string filename(t_filename);
	obj->file=filename;
}

} // end extern C
