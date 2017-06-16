// methods.cpp

#include "openb3d/src/animation.h"
#include "openb3d/src/animation_keys.h"
#include "openb3d/src/pick.h"
#include "openb3d/src/light.h"
#include "openb3d/src/shadow.h"

extern "C" {

// Animation

void AnimateMesh( Mesh* ent1,float framef,int start_frame,int end_frame ){
	Animation::AnimateMesh( ent1,framef,start_frame,end_frame );
}

void AnimateMesh2( Mesh* ent1,float framef,int start_frame,int end_frame ){
	Animation::AnimateMesh2( ent1,framef,start_frame,end_frame );
}

void AnimateMesh3(Mesh* ent1){
	Animation::AnimateMesh3( ent1 );
}

void VertexDeform(Mesh* ent){
	Animation::VertexDeform( ent );
}

// AnimationKeys

AnimationKeys* AnimationKeysCopy( AnimationKeys* obj ){
	return obj->Copy();
}

// Brush

Brush* BrushCopy( Brush* obj ){
	return obj->Copy();
}

int CompareBrushes( Brush* brush1,Brush* brush2 ){
	return Brush::CompareBrushes( brush1,brush2 );
}

// Camera

void ExtractFrustum( Camera* obj ){
	obj->ExtractFrustum();
}

float EntityInFrustum( Camera* obj,Entity* ent ){
	return obj->EntityInFrustum( ent );
}

void CameraUpdate( Camera* obj ){
	obj->Update();
}

void CameraRender( Camera* obj ){
	obj->Render();
}

void UpdateSprite( Camera* obj,Sprite& sprite ){
	obj->UpdateSprite( sprite );
}

void AddTransformedSpriteToSurface( Camera* obj,Sprite& sprite,Surface* surf ){
	obj->AddTransformedSpriteToSurface( sprite,surf );
}

void RenderListAdd( Camera* obj,Mesh* mesh ){
	obj->RenderListAdd( mesh );
}

void accPerspective( Camera* obj,float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus ){
	obj->accPerspective( fovy,aspect,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus );
}

void accFrustum( Camera* obj,float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus ){
	obj->accFrustum( left_,right_,bottom,top,zNear,zFar,pixdx,pixdy,eyedx,eyedy,focus );
}

void UpdateProjMatrix( Camera* obj ){
	obj->UpdateProjMatrix();
}

void CameraUpdateEntityRender( Entity* ent,Entity* cam ){
	UpdateEntityRender( ent,cam );
}

// Entity

int CountAllChildren( Entity* obj,int no_children ){
	return obj->CountAllChildren( no_children );
}

Entity* GetChildFromAll( Entity* obj,int child_no,int &no_children,Entity* ent ){
	return obj->GetChildFromAll( child_no,no_children,ent );
}

int Hidden( Entity* obj ){
	return obj->Hidden();
}

void AlignToVector( Entity* obj,float x,float y,float z,int axis,float rate ){
	obj->AlignToVector( x,y,z,axis,rate );
}

void UpdateMat( Entity* obj,bool load_identity ){
	obj->UpdateMat( load_identity );
}

void AddParent( Entity* obj,Entity &parent_ent ){
	obj->AddParent( parent_ent );
}

void UpdateChildren( Entity* ent_p ){
	Entity::UpdateChildren( ent_p );
}

float EntityDistanceSquared( Entity* obj,Entity* ent2 ){
	return obj->EntityDistanceSquared( ent2 );
}

void MQ_Update( Entity* obj ){
	obj->MQ_Update();
}
void MQ_GetInvMatrix( Entity* obj,Matrix &mat0 ){
	obj->MQ_GetInvMatrix( mat0 );
}

void MQ_GetMatrix( Entity* obj,Matrix &mat3 ){
	obj->MQ_GetMatrix( mat3 );
}

void MQ_GetScaleXYZ( Entity* obj,float &width,float &height,float &depth ){
	obj->MQ_GetScaleXYZ( width,height,depth );
}

void MQ_Turn( Entity* obj,float ang,float vx,float vy,float vz,int glob ){
	obj->MQ_Turn( ang,vx,vy,vz,glob );
}

// Global

void UpdateEntityAnim( Mesh& mesh ){
	Global::UpdateEntityAnim( mesh );
}

// Light

void LightUpdate( Light* obj ){
	obj->Update();
}

// Matrix

void MatrixLoadIdentity( Matrix* obj ){
	obj->LoadIdentity();
}

Matrix* MatrixCopy( Matrix* obj ){
	return obj->Copy();
}

void MatrixOverwrite( Matrix* obj,Matrix &mat ){
	obj->Overwrite( mat );
}

void MatrixGetInverse( Matrix* obj,Matrix &mat ){
	obj->GetInverse( mat );
}

void MatrixMultiply( Matrix* obj,Matrix &mat ){
	obj->Multiply( mat );
}

void MatrixTranslate( Matrix* obj,float x,float y,float z ){
	obj->Translate( x,y,z );
}

void MatrixScale( Matrix* obj,float x,float y,float z ){
	obj->Scale( x,y,z );
}

void MatrixRotate( Matrix* obj,float rx,float ry,float rz ){
	obj->Rotate( rx,ry,rz );
}

void MatrixRotatePitch( Matrix* obj,float ang ){
	obj->RotatePitch( ang );
}

void MatrixRotateYaw( Matrix* obj,float ang ){
	obj->RotateYaw( ang );
}

void MatrixRotateRoll( Matrix* obj,float ang ){
	obj->RotateRoll( ang );
}

void MatrixFromQuaternion( Matrix* obj,float x,float y,float z,float w ){
	obj->FromQuaternion( x,y,z,w );
}

void MatrixTransformVec( Matrix* obj,float &rx,float &ry,float &rz,int addTranslation=0 ){
	obj->TransformVec( rx,ry,rz,addTranslation );
}

void MatrixTranspose( Matrix* obj ){
	obj->Transpose();
}

void MatrixSetTranslate( Matrix* obj,float x,float y,float z ){
	obj->SetTranslate( x,y,z );
}

void MatrixMultiply2( Matrix* obj,Matrix &mat ){
	obj->Multiply2( mat );
}

void MatrixGetInverse2( Matrix* obj,Matrix &mat ){
	obj->GetInverse2( mat );
}

float MatrixGetPitch( Matrix* obj ){
	return obj->GetPitch();
}

float MatrixGetYaw( Matrix* obj ){
	return obj->GetYaw();
}

float MatrixGetRoll( Matrix* obj ){
	return obj->GetRoll();
}

void MatrixFromToRotation( Matrix* obj,float ix,float iy,float iz,float jx,float jy,float jz ){
	obj->FromToRotation( ix,iy,iz,jx,jy,jz );
}

void MatrixToQuat( Matrix* obj,float &qx,float &qy,float &qz,float &qw ){
	obj->ToQuat( qx,qy,qz,qw );
}

void MatrixQuaternion_FromAngleAxis( float angle,float ax,float ay,float az,float &rx,float &ry,float &rz,float &rw ){
	Quaternion_FromAngleAxis( angle,ax,ay,az,rx,ry,rz,rw );
}

void MatrixQuaternion_MultiplyQuat( float x1,float y1,float z1,float w1,float x2,float y2,float z2,float w2,float &rx,float &ry,float &rz,float &rw ){
	Quaternion_MultiplyQuat( x1,y1,z1,w1,x2,y2,z2,w2,rx,ry,rz,rw );
}

void MatrixInterpolateMatrix( Matrix &m,Matrix &a,float alpha ){
	InterpolateMatrix( m,a,alpha );
}

// Mesh

void MeshColor( Mesh* obj,float r,float g,float b,float a ){
	obj->MeshColor( r,g,b,a );
}

void MeshRed( Mesh* obj,float r ){
	obj->MeshRed( r );
}

void MeshGreen( Mesh* obj,float g ){
	obj->MeshGreen( g );
}

void MeshBlue( Mesh* obj,float b ){
	obj->MeshBlue( b );
}

void MeshAlpha( Mesh* obj,float a ){
	obj->MeshAlpha( a );
}

void CopyBonesList( Entity* ent,vector<Bone*>& bones ){
	Mesh::CopyBonesList( ent,bones );
}

Mesh* CollapseAnimMesh( Mesh* obj,Mesh* mesh ){
	return obj->CollapseAnimMesh( mesh );
}

Mesh* CollapseChildren( Mesh* obj,Entity* ent0,Mesh* mesh ){
	return obj->CollapseChildren( ent0,mesh );
}

void TransformMesh( Mesh* obj,Matrix& mat ){
	obj->TransformMesh( mat );
}

void GetBounds( Mesh* obj ){
	obj->GetBounds();
}

int Alpha( Mesh* obj ){
	return obj->Alpha();
}

void TreeCheck( Mesh* obj ){
	obj->TreeCheck();
}

void MeshRender( Mesh* obj ){
	obj->Render();
}

void UpdateShadow( Mesh* obj ){
	obj->UpdateShadow();
}

// Pick

Entity* PickMain( float ax,float ay,float az,float bx,float by,float bz,float radius ){
	return Pick::PickMain( ax,ay,az,bx,by,bz,radius );
}

// ShadowObject

void SetShadowColor( int R,int G,int B,int A ){
	ShadowObject::SetShadowColor( R,G,B,A );
}

void ShadowInit(){
	ShadowObject::ShadowInit();
}

void RemoveShadowfromMesh( ShadowObject* obj,Mesh* M ){
	obj->RemoveShadowfromMesh( M );
}

void ShadowObjectUpdate( Camera* Cam ){
	ShadowObject::Update( Cam );
}

void RenderVolume(){
	ShadowObject::RenderVolume();
}

void UpdateAnim( ShadowObject* obj ){
	obj->UpdateAnim();
}

void ShadowObjectInit( ShadowObject* obj ){
	obj->Init();
}

void InitShadow( ShadowObject* obj ){
	obj->InitShadow();
}

void UpdateCaster( ShadowObject* obj ){
	obj->UpdateCaster();
}

void ShadowRenderWorldZFail(){
	ShadowObject::ShadowRenderWorldZFail();
}

// Sprite

void SpriteTexCoords( Sprite* obj,int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set ){
	obj->SpriteTexCoords( cell_x,cell_y,cell_w,cell_h,tex_w,tex_h,uv_set );
}

void SpriteVertexColor( Sprite* obj,int v,float r,float g,float b ){
	obj->SpriteVertexColor( v,r,g,b );
}

// Surface

Surface* SurfaceCopy( Surface* obj ){
	return obj->Copy();
}

void SurfaceColor( Surface* obj,float r,float g,float b,float a ){
	obj->SurfaceColor( r,g,b,a );
}

void SurfaceRed( Surface* obj,float r ){
	obj->SurfaceRed( r );
}

void SurfaceGreen( Surface* obj,float g ){
	obj->SurfaceGreen( g );
}

void SurfaceBlue( Surface* obj,float b ){
	obj->SurfaceBlue( b );
}

void SurfaceAlpha( Surface* obj,float a ){
	obj->SurfaceAlpha( a );
}

void SurfaceUpdateNormals( Surface* obj ){
	obj->UpdateNormals();
}

float TriangleNX( Surface* obj,int tri_no ){
	return obj->TriangleNX( tri_no );
}

float TriangleNY( Surface* obj,int tri_no ){
	return obj->TriangleNY( tri_no );
}

float TriangleNZ( Surface* obj,int tri_no ){
	return obj->TriangleNZ( tri_no );
}

void UpdateVBO( Surface* obj ){
	obj->UpdateVBO();
}

void FreeVBO( Surface* obj ){
	obj->FreeVBO();
}

void RemoveTri( Surface* obj,int tri ){
	obj->RemoveTri( tri );
}

// Terrain

void UpdateTerrain( Terrain* obj ){
	obj->UpdateTerrain();
}

void RecreateROAM( Terrain* obj ){
	obj->RecreateROAM();
}

void drawsub( Terrain* obj,int l,float v0[],float v1[],float v2[] ){
	obj->drawsub( l,v0,v1,v2 );
}

void TerrainUpdateNormals( Terrain* obj ){
	obj->UpdateNormals();
}

void col_tree_sub( Terrain* obj,int l,float v0[],float v1[],float v2[] ){
	obj->col_tree_sub( l,v0,v1,v2 );
}

// Texture

Texture* TextureCopy( Texture* obj ){
	return obj->Copy();
}

Texture* TexInList( Texture* obj ){
	return obj->TexInList();
}

void FilterFlags( Texture* obj ){
	obj->FilterFlags();
}

} /* extern "C" */
