#ifndef methods_h
#define methods_h

#ifdef __cplusplus
extern "C" {
#endif

// Animation
void AnimateMesh(Mesh* ent1,float framef,int start_frame,int end_frame);
void AnimateMesh2(Mesh* ent1,float framef,int start_frame,int end_frame);
void AnimateMesh3(Mesh* ent1);
void VertexDeform(Mesh* ent);

// AnimationKeys
AnimationKeys* AnimationKeysCopy( AnimationKeys* obj );

// Brush
Brush* BrushCopy( Brush* obj );
int CompareBrushes( Brush* brush1,Brush* brush2 );
void NameBrush( Brush* obj,char* b_name );

// Camera
void ExtractFrustum( Camera* obj );
float EntityInFrustum( Camera* obj,Entity* ent );
void CameraUpdate( Camera* obj );
void CameraRender( Camera* obj );
void UpdateSprite( Camera* obj,Sprite& sprite );
void AddTransformedSpriteToSurface( Camera* obj,Sprite& sprite,Surface* surf );
void RenderListAdd( Camera* obj,Mesh* mesh );
void accPerspective( Camera* obj,float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus );
void accFrustum( Camera* obj,float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus );
void UpdateProjMatrix( Camera* obj );
void CameraUpdateEntityRender( Entity* ent,Entity* cam );

// Entity
int CountAllChildren( Entity* obj,int no_children );
Entity* GetChildFromAll( Entity* obj,int child_no,int &no_children,Entity* ent );
int Hidden( Entity* obj );
void NameClass( Entity* obj,char* c_name );
void AlignToVector( Entity* obj,float x,float y,float z,int axis,float rate );
void UpdateMat( Entity* obj,bool load_identity );
void AddParent( Entity* obj,Entity &parent_ent );
void UpdateChildren( Entity* ent_p );
float EntityDistanceSquared( Entity* obj,Entity* ent2 );
void MQ_Update( Entity* obj );
void MQ_GetInvMatrix( Entity* obj,Matrix &mat0 );
void MQ_GetMatrix( Entity* obj,Matrix &mat3 );
void MQ_GetScaleXYZ( Entity* obj,float &width,float &height,float &depth );
void MQ_Turn( Entity* obj,float ang,float vx,float vy,float vz,int glob );
void MQ_ApplyNewtonTransform( Entity* obj,const float* newtonMatrix );
//void UpdateAllEntities( void(Update)(Entity* ent,Entity* ent2),Entity* ent2=NULL );

// Global
void UpdateEntityAnim( Mesh& mesh );
//bool GlobalCompareEntityOrder( Entity* ent1,Entity* ent2 );

// Light
void LightUpdate( Light* obj );

// Matrix
void MatrixLoadIdentity( Matrix* obj );
Matrix* MatrixCopy( Matrix* obj );
void MatrixOverwrite( Matrix* obj,Matrix &mat );
void MatrixGetInverse( Matrix* obj,Matrix &mat );
void MatrixMultiply( Matrix* obj,Matrix &mat );
void MatrixTranslate( Matrix* obj,float x,float y,float z );
void MatrixScale( Matrix* obj,float x,float y,float z );
void MatrixRotate( Matrix* obj,float rx,float ry,float rz );
void MatrixRotatePitch( Matrix* obj,float ang );
void MatrixRotateYaw( Matrix* obj,float ang );
void MatrixRotateRoll( Matrix* obj,float ang );
void MatrixFromQuaternion( Matrix* obj,float x,float y,float z,float w );
void MatrixTransformVec( Matrix* obj,float &rx,float &ry,float &rz,int addTranslation=0 );
void MatrixTranspose( Matrix* obj );
void MatrixSetTranslate( Matrix* obj,float x,float y,float z );
void MatrixMultiply2( Matrix* obj,Matrix &mat );
void MatrixGetInverse2( Matrix* obj,Matrix &mat );
float MatrixGetPitch( Matrix* obj );
float MatrixGetYaw( Matrix* obj );
float MatrixGetRoll( Matrix* obj );
void MatrixFromToRotation( Matrix* obj,float ix,float iy,float iz,float jx,float jy,float jz );
void MatrixToQuat( Matrix* obj,float &qx,float &qy,float &qz,float &qw );
void MatrixQuaternion_FromAngleAxis( float angle,float ax,float ay,float az,float &rx,float &ry,float &rz,float &rw );
void MatrixQuaternion_MultiplyQuat( float x1,float y1,float z1,float w1,float x2,float y2,float z2,float w2,float &rx,float &ry,float &rz,float &rw );
void MatrixInterpolateMatrix( Matrix &m,Matrix &a,float alpha );

// Mesh
void MeshColor( Mesh* obj,float r,float g,float b,float a );
void MeshRed( Mesh* obj,float r );
void MeshGreen( Mesh* obj,float g );
void MeshBlue( Mesh* obj,float b );
void MeshAlpha( Mesh* obj,float a );
void CopyBonesList( Entity* ent,vector<Bone*>& bones );
Mesh* CollapseAnimMesh( Mesh* obj,Mesh* mesh );
Mesh* CollapseChildren( Mesh* obj,Entity* ent0,Mesh* mesh );
void TransformMesh( Mesh* obj,Matrix& mat );
void GetBounds( Mesh* obj );
int Alpha( Mesh* obj );
void TreeCheck( Mesh* obj );
void MeshRender( Mesh* obj );
void UpdateShadow( Mesh* obj );

// Model
void ModelTrimVerts( Surface* obj );

// Pick
Entity* PickMain( float ax,float ay,float az,float bx,float by,float bz,float radius );

// Quaternion
void QuaternionToMat( float w,float x,float y,float z,Matrix& mat );
void QuaternionToEuler( float w,float x,float y,float z,float &pitch,float &yaw,float &roll );
void QuaternionSlerp( float Ax,float Ay,float Az,float Aw,float Bx,float By,float Bz,float Bw,float& Cx,float& Cy,float& Cz,float& Cw,float t );

// ShadowObject
void SetShadowColor( int R,int G,int B,int A );
void ShadowInit();
void RemoveShadowfromMesh( ShadowObject* obj,Mesh* M );
void ShadowObjectUpdate( Camera* Cam );
void RenderVolume();
void UpdateAnim( ShadowObject* obj );
void ShadowObjectInit( ShadowObject* obj );
void InitShadow( ShadowObject* obj );
void UpdateCaster( ShadowObject* obj );
void ShadowRenderWorldZFail();

// Sprite
void SpriteTexCoords( Sprite* obj,int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set );
void SpriteVertexColor( Sprite* obj,int v,float r,float g,float b );

// Surface
Surface* SurfaceCopy( Surface* obj );
void SurfaceColor( Surface* obj,float r,float g,float b,float a );
void SurfaceRed( Surface* obj,float r );
void SurfaceGreen( Surface* obj,float g );
void SurfaceBlue( Surface* obj,float b );
void SurfaceAlpha( Surface* obj,float a );
void SurfaceUpdateNormals( Surface* obj );
float TriangleNX( Surface* obj,int tri_no );
float TriangleNY( Surface* obj,int tri_no );
float TriangleNZ( Surface* obj,int tri_no );
void UpdateVBO( Surface* obj );
void FreeVBO( Surface* obj );
void RemoveTri( Surface* obj,int tri );

// Terrain
void UpdateTerrain( Terrain* obj );
void RecreateROAM( Terrain* obj );
void drawsub( Terrain* obj,int l,float v0[],float v1[],float v2[] );
void TerrainUpdateNormals( Terrain* obj );
//virtual void TreeCheck(CollisionInfo* ci);
void col_tree_sub( Terrain* obj,int l,float v0[],float v1[],float v2[] );

// Texture
Texture* TextureCopy( Texture* obj );
Texture* TexInList( Texture* obj,list<Texture*>& list_ref );
void FilterFlags( Texture* obj );
//static string Strip(string filename);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
