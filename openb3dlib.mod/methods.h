#ifndef methods_h
#define methods_h

#ifdef __cplusplus
extern "C" {
#endif

// Animation
void AnimateMesh_(Mesh* ent1,float framef,int start_frame,int end_frame);
void AnimateMesh2_(Mesh* ent1,float framef,int start_frame,int end_frame);
void AnimateMesh3_(Mesh* ent1);
void VertexDeform_(Mesh* ent);

// AnimationKeys
AnimationKeys* AnimationKeysCopy_( AnimationKeys* obj );

// Brush
Brush* BrushCopy_( Brush* obj );
int CompareBrushes_( Brush* brush1,Brush* brush2 );

// Camera
void ExtractFrustum_( Camera* obj );
float EntityInFrustum_( Camera* obj,Entity* ent );
void CameraUpdate_( Camera* obj );
void CameraRender_( Camera* obj );
void UpdateSprite_( Camera* obj,Sprite& sprite );
void AddTransformedSpriteToSurface_( Camera* obj,Sprite& sprite,Surface* surf );
void RenderListAdd_( Camera* obj,Mesh* mesh );
void accPerspective_( Camera* obj,float fovy,float aspect,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus );
void accFrustum_( Camera* obj,float left_,float right_,float bottom,float top,float zNear,float zFar,float pixdx,float pixdy,float eyedx,float eyedy,float focus );
void UpdateProjMatrix_( Camera* obj );
void CameraUpdateEntityRender_( Entity* ent,Entity* cam );

// Entity
int CountAllChildren_( Entity* obj,int no_children );
Entity* GetChildFromAll_( Entity* obj,int child_no,int &no_children,Entity* ent );
int Hidden_( Entity* obj );
void AlignToVector_( Entity* obj,float x,float y,float z,int axis,float rate );
void UpdateMat_( Entity* obj,bool load_identity );
void AddParent_( Entity* obj,Entity &parent_ent );
void UpdateChildren_( Entity* ent_p );
float EntityDistanceSquared_( Entity* obj,Entity* ent2 );
void MQ_Update_( Entity* obj );
void MQ_GetInvMatrix_( Entity* obj,Matrix &mat0 );
void MQ_GetMatrix_( Entity* obj,Matrix &mat3 );
void MQ_GetScaleXYZ_( Entity* obj,float &width,float &height,float &depth );
void MQ_Turn_( Entity* obj,float ang,float vx,float vy,float vz,int glob );
void MQ_ApplyNewtonTransform_( Entity* obj,const float* newtonMatrix );
//void UpdateAllEntities_( void(Update)(Entity* ent,Entity* ent2),Entity* ent2=NULL );

// Global
void UpdateEntityAnim_( Mesh& mesh );
//bool GlobalCompareEntityOrder_( Entity* ent1,Entity* ent2 );

// Light
void LightUpdate_( Light* obj );

// Matrix
void MatrixLoadIdentity_( Matrix* obj );
Matrix* MatrixCopy_( Matrix* obj );
void MatrixOverwrite_( Matrix* obj,Matrix &mat );
void MatrixGetInverse_( Matrix* obj,Matrix &mat );
void MatrixMultiply_( Matrix* obj,Matrix &mat );
void MatrixTranslate_( Matrix* obj,float x,float y,float z );
void MatrixScale_( Matrix* obj,float x,float y,float z );
void MatrixRotate_( Matrix* obj,float rx,float ry,float rz );
void MatrixRotatePitch_( Matrix* obj,float ang );
void MatrixRotateYaw_( Matrix* obj,float ang );
void MatrixRotateRoll_( Matrix* obj,float ang );
void MatrixFromQuaternion_( Matrix* obj,float x,float y,float z,float w );
void MatrixTransformVec_( Matrix* obj,float &rx,float &ry,float &rz,int addTranslation=0 );
void MatrixTranspose_( Matrix* obj );
void MatrixSetTranslate_( Matrix* obj,float x,float y,float z );
void MatrixMultiply2_( Matrix* obj,Matrix &mat );
void MatrixGetInverse2_( Matrix* obj,Matrix &mat );
float MatrixGetPitch_( Matrix* obj );
float MatrixGetYaw_( Matrix* obj );
float MatrixGetRoll_( Matrix* obj );
void MatrixFromToRotation_( Matrix* obj,float ix,float iy,float iz,float jx,float jy,float jz );
void MatrixToQuat_( Matrix* obj,float &qx,float &qy,float &qz,float &qw );
void MatrixQuaternion_FromAngleAxis_( float angle,float ax,float ay,float az,float &rx,float &ry,float &rz,float &rw );
void MatrixQuaternion_MultiplyQuat_( float x1,float y1,float z1,float w1,float x2,float y2,float z2,float w2,float &rx,float &ry,float &rz,float &rw );
void MatrixInterpolateMatrix_( Matrix &m,Matrix &a,float alpha );

// Mesh
void MeshColor_( Mesh* obj,float r,float g,float b,float a );
void MeshRed_( Mesh* obj,float r );
void MeshGreen_( Mesh* obj,float g );
void MeshBlue_( Mesh* obj,float b );
void MeshAlpha_( Mesh* obj,float a );
void CopyBonesList_( Entity* ent,vector<Bone*>& bones );
Mesh* CollapseAnimMesh_( Mesh* obj,Mesh* mesh );
Mesh* CollapseChildren_( Mesh* obj,Entity* ent0,Mesh* mesh );
void TransformMesh_( Mesh* obj,Matrix& mat );
void GetBounds_( Mesh* obj );
int Alpha_( Mesh* obj );
void TreeCheck_( Mesh* obj );
void MeshRender_( Mesh* obj );
void UpdateShadow_( Mesh* obj );

// Model
void ModelTrimVerts_( Surface* obj );

// Pick
Entity* PickMain_( float ax,float ay,float az,float bx,float by,float bz,float radius );

// Quaternion
void QuaternionToMat_( float w,float x,float y,float z,Matrix& mat );
void QuaternionToEuler_( float w,float x,float y,float z,float &pitch,float &yaw,float &roll );
void QuaternionSlerp_( float Ax,float Ay,float Az,float Aw,float Bx,float By,float Bz,float Bw,float& Cx,float& Cy,float& Cz,float& Cw,float t );

// ShadowObject
void SetShadowColor_( int R,int G,int B,int A );
void ShadowInit_();
void RemoveShadowfromMesh_( ShadowObject* obj,Mesh* M );
void ShadowObjectUpdate_( Camera* Cam );
void RenderVolume_();
void UpdateAnim_( ShadowObject* obj );
void ShadowObjectInit_( ShadowObject* obj );
void InitShadow_( ShadowObject* obj );
void UpdateCaster_( ShadowObject* obj );
void ShadowRenderWorldZFail_();

// Sprite
void SpriteTexCoords_( Sprite* obj,int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set );
void SpriteVertexColor_( Sprite* obj,int v,float r,float g,float b );

// Surface
Surface* SurfaceCopy_( Surface* obj );
void SurfaceColor_( Surface* obj,float r,float g,float b,float a );
void SurfaceRed_( Surface* obj,float r );
void SurfaceGreen_( Surface* obj,float g );
void SurfaceBlue_( Surface* obj,float b );
void SurfaceAlpha_( Surface* obj,float a );
void SurfaceUpdateNormals_( Surface* obj );
float TriangleNX_( Surface* obj,int tri_no );
float TriangleNY_( Surface* obj,int tri_no );
float TriangleNZ_( Surface* obj,int tri_no );
void UpdateVBO_( Surface* obj );
void FreeVBO_( Surface* obj );
void RemoveTri_( Surface* obj,int tri );

// Terrain
void UpdateTerrain_( Terrain* obj );
void RecreateROAM_( Terrain* obj );
void drawsub_( Terrain* obj,int l,float v0[],float v1[],float v2[] );
void TerrainUpdateNormals_( Terrain* obj );
//virtual void TreeCheck_(CollisionInfo* ci);
void col_tree_sub_( Terrain* obj,int l,float v0[],float v1[],float v2[] );

// Texture
Texture* TextureCopy_( Texture* obj );
Texture* TexInList_( Texture* obj,list<Texture*>& list_ref );
void FilterFlags_( Texture* obj );
void CopyPixels_(unsigned char* src,unsigned int sW,unsigned int sH,unsigned int sX,unsigned int sY,unsigned char* dst,unsigned int dW,unsigned int dH,unsigned int bPP);
//static string Strip_(string filename);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
