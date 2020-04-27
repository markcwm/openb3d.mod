#ifndef __functions_h__
#define __functions_h__

#ifdef WIN32
 #ifdef BUILD_DLL
  #define DLL_EXPORT __declspec(dllexport)
 #else
  #define DLL_EXPORT __declspec(dllimport)
 #endif
#else
 #define DLL_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

// rendering
void DLL_EXPORT BufferToTex(Texture* tex,unsigned char* buffer, int frame);
void DLL_EXPORT BackBufferToTex(Texture* tex,int frame);
void DLL_EXPORT CameraToTex(Texture* tex, Camera* cam, int frame);
void DLL_EXPORT TexToBuffer(Texture* tex,unsigned char* buffer, int frame);


/*
bbdoc: Minib3d Only
about:
This command is the equivalent of Blitz3D's MeshCullBox command.

It is used to set the radius of a mesh's 'cull sphere' - if the 'cull sphere' is not inside the viewing area, the mesh will not
be rendered.

A mesh's cull radius is set automatically, therefore in most cases you will not have to use this command.

One time you may have to use it is for animated meshes where the default cull radius may not take into account all animation
positions, resulting in the mesh being wrongly culled at extreme positions.
*/
void DLL_EXPORT MeshCullRadius_(Entity* ent, float radius);
// Blitz3D functions, A-Z

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online Help</a>
*/
int DLL_EXPORT AddAnimSeq_(Entity* ent,int length);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online Help</a>
*/
void DLL_EXPORT AddMesh_(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online Help</a>
*/
int DLL_EXPORT AddTriangle_(Surface* surf,int v0,int v1,int v2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online Help</a>
*/
int DLL_EXPORT AddVertex_(Surface* surf,float x, float y,float z,float u, float v,float w);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online Help</a>
*/
void DLL_EXPORT AmbientLight_(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online Help</a>
*/
void DLL_EXPORT AntiAlias_(int samples);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online Help</a>
*/
void DLL_EXPORT Animate_(Entity* ent,int mode,float speed,int seq,int trans);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online Help</a>
*/
int DLL_EXPORT Animating_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online Help</a>
*/
int DLL_EXPORT AnimLength_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online Help</a>
*/
int DLL_EXPORT AnimSeq_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online Help</a>
*/
float DLL_EXPORT AnimTime_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online Help</a>
*/
void DLL_EXPORT BrushAlpha_(Brush* brush, float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online Help</a>
*/
void DLL_EXPORT BrushBlend_(Brush* brush,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online Help</a>
*/
void DLL_EXPORT BrushColor_(Brush* brush,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online Help</a>
*/
void DLL_EXPORT BrushFX_(Brush* brush,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online Help</a>
*/
void DLL_EXPORT BrushShininess_(Brush* brush,float s);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online Help</a>
*/
void DLL_EXPORT BrushTexture_(Brush* brush,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online Help</a>
*/
void DLL_EXPORT CameraClsColor_(Camera* cam, float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online Help</a>
*/
void DLL_EXPORT CameraClsMode_(Camera* cam,int cls_depth,int cls_zbuffer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online Help</a>
*/
void DLL_EXPORT CameraFogColor_(Camera* cam,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online Help</a>
*/
void DLL_EXPORT CameraFogMode_(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online Help</a>
*/
void DLL_EXPORT CameraFogRange_(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online Help</a>
*/
Entity* DLL_EXPORT CameraPick_(Camera* cam,float x,float y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online Help</a>
*/
void DLL_EXPORT CameraProject_(Camera* cam,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online Help</a>
*/
void DLL_EXPORT CameraProjMode_(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online Help</a>
*/
void DLL_EXPORT CameraRange_(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online Help</a>
*/
void DLL_EXPORT CameraViewport_(Camera* cam,int x,int y,int width,int height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online Help</a>
*/
void DLL_EXPORT CameraZoom_(Camera* cam,float zoom);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online Help</a>
int ClearCollisions(){
	Global::ClearCollisions();
}
*/
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online Help</a>
*/
void DLL_EXPORT ClearSurface_(Surface* surf,int clear_verts,int clear_tris);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online Help</a>
*/
void DLL_EXPORT ClearTextureFilters_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online Help</a>
*/
void DLL_EXPORT ClearWorld_(int entities,int brushes,int textures);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online Help</a>
*/
Entity* DLL_EXPORT CollisionEntity_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online Help</a>
*/
void DLL_EXPORT Collisions_(int src_no,int dest_no,int method_no,int response_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online Help</a>
*/
float DLL_EXPORT CollisionNX_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online Help</a>
*/
float DLL_EXPORT CollisionNY_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online Help</a>
*/
float DLL_EXPORT CollisionNZ_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online Help</a>
*/
Surface* DLL_EXPORT CollisionSurface_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online Help</a>
*/
float DLL_EXPORT CollisionTime_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online Help</a>
*/
int DLL_EXPORT CollisionTriangle_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online Help</a>
*/
float DLL_EXPORT CollisionX_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online Help</a>
*/
float DLL_EXPORT CollisionY_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online Help</a>
*/
float DLL_EXPORT CollisionZ_(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online Help</a>
*/
int DLL_EXPORT CountChildren_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online Help</a>
*/
int DLL_EXPORT CountCollisions_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online Help</a>
*/
Entity* DLL_EXPORT CopyEntity_(Entity* ent,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online Help</a>
*/
Mesh* DLL_EXPORT CopyMesh_(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online Help</a>
*/
int DLL_EXPORT CountSurfaces_(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online Help</a>
*/
int DLL_EXPORT CountTriangles_(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online Help</a>
*/
int DLL_EXPORT CountVertices_(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online Help</a>
*/
Brush* DLL_EXPORT CreateBrush_(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online Help</a>
*/
Camera* DLL_EXPORT CreateCamera_(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCone_(int segments,int solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCylinder_(int segments,int solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCube_(Entity* parent);

Terrain* DLL_EXPORT CreateGeosphere_(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online Help</a>
*/
Mesh* DLL_EXPORT CreateMesh_(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online Help</a>
*/
Light* DLL_EXPORT CreateLight_(int light_type,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online Help</a>
*/
Pivot* DLL_EXPORT CreatePivot_(Entity* parent);

Mesh* DLL_EXPORT CreatePlane_(int divisions,Entity* parent);

Mesh* DLL_EXPORT CreateQuad_(Entity* parent);

ShadowObject* DLL_EXPORT CreateShadow_(Mesh* parent, char Static);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online Help</a>
*/
Mesh* DLL_EXPORT CreateSphere_(int segments,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online Help</a>
*/
Sprite* DLL_EXPORT CreateSprite_(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online Help</a>
*/
Surface* DLL_EXPORT CreateSurface_(Mesh* mesh,Brush* brush);

/*
*/
Stencil* DLL_EXPORT CreateStencil_();

/*
*/
Terrain* DLL_EXPORT CreateTerrain_(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online Help</a>
*/
Texture* DLL_EXPORT CreateTexture_(int width,int height,int flags,int frames);

/*
*/
VoxelSprite* DLL_EXPORT CreateVoxelSprite_(int slices, Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online Help</a>
*/
float DLL_EXPORT DeltaPitch_(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online Help</a>
*/
float DLL_EXPORT DeltaYaw_(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online Help</a>
*/
void DLL_EXPORT EntityAlpha_(Entity* ent,float alpha);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online Help</a>
*/
void DLL_EXPORT EntityAutoFade_(Entity* ent,float near,float far);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online Help</a>
*/
void DLL_EXPORT EntityBlend_(Entity* ent, int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online Help</a>
*/
void DLL_EXPORT EntityBox_(Entity* ent,float x,float y,float z,float w,float h,float d);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online Help</a>
*/
const char* DLL_EXPORT EntityClass_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online Help</a>
*/
Entity* DLL_EXPORT EntityCollided_(Entity* ent,int type_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online Help</a>
*/
void DLL_EXPORT EntityColor_(Entity* ent,float red,float green,float blue,float alpha,int recursive);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online Help</a>
*/
float DLL_EXPORT EntityDistance_(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online Help</a>
*/
void DLL_EXPORT EntityFX_(Entity* ent,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online Help</a>
*/
int DLL_EXPORT EntityInView_(Entity* ent,Camera* cam);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online Help</a>
*/
const char* DLL_EXPORT EntityName_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online Help</a>
*/
void DLL_EXPORT EntityOrder_(Entity* ent,int order);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online Help</a>
*/
void DLL_EXPORT EntityParent_(Entity* ent,Entity* parent_ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online Help</a>
*/
Entity* DLL_EXPORT EntityPick_(Entity* ent,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online Help</a>
*/
void DLL_EXPORT EntityPickMode_(Entity* ent,int pick_mode,int obscurer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online Help</a>
*/
float DLL_EXPORT EntityPitch_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online Help</a>
*/
void DLL_EXPORT EntityRadius_(Entity* ent,float radius_x,float radius_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online Help</a>
*/
float DLL_EXPORT EntityRoll_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online Help</a>
*/
void DLL_EXPORT EntityShininess_(Entity* ent,float shine);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online Help</a>
*/
void DLL_EXPORT EntityTexture_(Entity* ent,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online Help</a>
*/
void DLL_EXPORT EntityType_(Entity* ent,int type_no,int recursive);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online Help</a>
*/
int DLL_EXPORT EntityVisible_(Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online Help</a>
*/
float DLL_EXPORT EntityX_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online Help</a>
*/
float DLL_EXPORT EntityY_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online Help</a>
*/
float DLL_EXPORT EntityYaw_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online Help</a>
*/
float DLL_EXPORT EntityZ_(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online Help</a>
*/
int DLL_EXPORT ExtractAnimSeq_(Entity* ent,int first_frame,int last_frame,int seq);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online Help</a>
*/
Entity* DLL_EXPORT FindChild_(Entity* ent,char* child_name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online Help</a>
*/
Surface* DLL_EXPORT FindSurface_(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online Help</a><p>
*/
void DLL_EXPORT FitMesh_(Mesh* mesh,float x,float y,float z,float width,float height,float depth,int uniform);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online Help</a>
*/
void DLL_EXPORT FlipMesh_(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online Help</a>
*/
void DLL_EXPORT FreeBrush_(Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online Help</a>
*/
void DLL_EXPORT FreeEntity_(Entity* ent);

void DLL_EXPORT FreeShadow_(ShadowObject* shad);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online Help</a>
*/
void DLL_EXPORT FreeTexture_(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online Help</a>
*/
Texture* DLL_EXPORT GetBrushTexture_(Brush* brush,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online Help</a>
*/
Entity* DLL_EXPORT GetChild_(Entity* ent,int child_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online Help</a>
*/
Brush* DLL_EXPORT GetEntityBrush_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online Help</a>
*/
int DLL_EXPORT GetEntityType_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
float DLL_EXPORT GetMatElement_(Entity* ent,int row,int col);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online Help</a>
*/
Entity* DLL_EXPORT GetParentEntity_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online Help</a>
*/
Surface* DLL_EXPORT GetSurface_(Mesh* mesh,int surf_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online Help</a>
*/
Brush* DLL_EXPORT GetSurfaceBrush_(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online Help</a>
*/
void DLL_EXPORT Graphics3D_(int width,int height,int depth,int mode,int rate);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online Help</a>
*/
void DLL_EXPORT HandleSprite_(Sprite* sprite,float h_x,float h_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online Help</a>
*/
void DLL_EXPORT HideEntity_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online Help</a>
*/
void DLL_EXPORT LightColor_(Light* light,float red,float green,float blue);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online Help</a>
*/
void DLL_EXPORT LightConeAngles_(Light* light,float inner_ang,float outer_ang);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online Help</a>
*/
void DLL_EXPORT LightRange_(Light* light,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online Help</a>
*/
Entity* DLL_EXPORT LinePick_(float x,float y,float z,float dx,float dy,float dz,float radius);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online Help</a>
*/
Mesh* DLL_EXPORT LoadAnimMesh_(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online Help</a>
*/
Texture* DLL_EXPORT LoadAnimTexture_(char* file,int flags,int frame_width,int frame_height,int first_frame,int frame_count);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online Help</a>
*/
Brush* DLL_EXPORT LoadBrush_(char *file,int flags,float u_scale,float v_scale);

Terrain* DLL_EXPORT LoadGeosphere_(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online Help</a>
*/
Mesh* DLL_EXPORT LoadMesh_(char* file,Entity* parent);


Terrain* DLL_EXPORT LoadTerrain_(char* file,Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online Help</a>
*/
Texture* DLL_EXPORT LoadTexture_(char* file,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online Help</a>
*/
Sprite* DLL_EXPORT LoadSprite_(char* tex_file,int tex_flag,Entity* parent);

/*
*/
Mesh* DLL_EXPORT MeshCSG_(Mesh* m1, Mesh* m2, int method);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online Help</a>
*/
float DLL_EXPORT MeshDepth_(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online Help</a>
*/
int DLL_EXPORT MeshesIntersect_(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online Help</a>
*/
float DLL_EXPORT MeshHeight_(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online Help</a>
*/
float DLL_EXPORT MeshWidth_(Mesh* mesh);

void DLL_EXPORT ModifyGeosphere_(Geosphere* geo, int x, int z, float new_height);

void DLL_EXPORT ModifyTerrain_(Terrain* terr, int x, int z, float new_height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online Help</a>
*/
void DLL_EXPORT MoveEntity_(Entity* ent,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online Help</a>
*/
void DLL_EXPORT NameEntity_(Entity* ent,char* name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online Help</a>
*/
void DLL_EXPORT PaintEntity_(Entity* ent,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online Help</a>
*/
void DLL_EXPORT PaintMesh_(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online Help</a>
*/
void DLL_EXPORT PaintSurface_(Surface* surf,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online Help</a>
*/
Entity* DLL_EXPORT PickedEntity_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online Help</a>
*/
float DLL_EXPORT PickedNX_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online Help</a>
*/
float DLL_EXPORT PickedNY_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online Help</a>
*/
float DLL_EXPORT PickedNZ_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online Help</a>
*/
Surface* DLL_EXPORT PickedSurface_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online Help</a>
*/
float DLL_EXPORT PickedTime_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online Help</a>
*/
int DLL_EXPORT PickedTriangle_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online Help</a>
*/
float DLL_EXPORT PickedX_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online Help</a>
*/
float DLL_EXPORT PickedY_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online Help</a>
*/
float DLL_EXPORT PickedZ_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online Help</a>
*/
void DLL_EXPORT PointEntity_(Entity* ent,Entity* target_ent,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online Help</a>
*/
void DLL_EXPORT PositionEntity_(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online Help</a>
*/
void DLL_EXPORT PositionMesh_(Mesh* mesh,float px,float py,float pz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online Help</a>
*/
void DLL_EXPORT PositionTexture_(Texture* tex,float u_pos,float v_pos);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online Help</a>
*/
float DLL_EXPORT ProjectedX_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online Help</a>
*/
float DLL_EXPORT ProjectedY_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online Help</a>
*/
float DLL_EXPORT ProjectedZ_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online Help</a>
*/
void DLL_EXPORT RenderWorld_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RepeatMesh">Online Help</a>
*/
Mesh* DLL_EXPORT RepeatMesh_(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
void DLL_EXPORT ResetEntity_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online Help</a>
*/
void DLL_EXPORT RotateEntity_(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online Help</a>
*/
void DLL_EXPORT RotateMesh_(Mesh* mesh,float pitch,float yaw,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online Help</a>
*/
void DLL_EXPORT RotateSprite_(Sprite* sprite,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online Help</a>
*/
void DLL_EXPORT RotateTexture_(Texture* tex,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online Help</a>
*/
void DLL_EXPORT ScaleEntity_(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online Help</a>
*/
void DLL_EXPORT ScaleMesh_(Mesh* mesh,float sx,float sy,float sz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online Help</a>
*/
void DLL_EXPORT ScaleSprite_(Sprite* sprite,float s_x,float s_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online Help</a>
*/
void DLL_EXPORT ScaleTexture_(Texture* tex,float u_scale,float v_scale);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online Help</a>
*/
void DLL_EXPORT SetAnimTime_(Entity* ent,float time,int seq);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online Help</a>
*/
void DLL_EXPORT SetCubeFace_(Texture* tex,int face);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online Help</a>
*/
void DLL_EXPORT SetCubeMode_(Texture* tex,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online Help</a>
*/
void DLL_EXPORT ShowEntity_(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online Help</a>
*/
void DLL_EXPORT SpriteViewMode_(Sprite* sprite,int mode);

/*
*/
void DLL_EXPORT StencilAlpha_(Stencil* stencil, float a);

/*
*/
void DLL_EXPORT StencilClsColor_(Stencil* stencil, float r,float g,float b);

/*
*/
void DLL_EXPORT StencilClsMode_(Stencil* stencil,int cls_depth,int cls_zbuffer);

/*
*/
void DLL_EXPORT StencilMesh_(Stencil* stencil, Mesh* mesh, int mode);

/*
*/
void DLL_EXPORT StencilMode_(Stencil* stencil, int m, int o);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online Help</a>
*/
float DLL_EXPORT TerrainHeight_(Terrain* terr, int x, int z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online Help</a>
*/
float DLL_EXPORT TerrainX_(Terrain* terr, float x, float y, float z);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online Help</a>
*/
float DLL_EXPORT TerrainY_(Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online Help</a>
*/
float DLL_EXPORT TerrainZ_(Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online Help</a>
*/
void DLL_EXPORT TextureBlend_(Texture* tex,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online Help</a>
*/
void DLL_EXPORT TextureCoords_(Texture* tex,int coords);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online Help</a>
*/
int DLL_EXPORT TextureHeight_(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online Help</a>
*/
void DLL_EXPORT TextureFilter_(char* match_text,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online Help</a>
*/
const char* DLL_EXPORT TextureName_(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online Help</a>
*/
int DLL_EXPORT TextureWidth_(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online Help</a>
*/
float DLL_EXPORT TFormedX_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online Help</a>
*/
float DLL_EXPORT TFormedY_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online Help</a>
*/
float DLL_EXPORT TFormedZ_();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online Help</a>
*/
void DLL_EXPORT TFormNormal_(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online Help</a>
*/
void DLL_EXPORT TFormPoint_(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online Help</a>
*/
void DLL_EXPORT TFormVector_(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online Help</a>
*/
void DLL_EXPORT TranslateEntity_(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online Help</a>
*/
int DLL_EXPORT TriangleVertex_(Surface* surf,int tri_no,int corner);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online Help</a>
*/
void DLL_EXPORT TurnEntity_(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void DLL_EXPORT UpdateNormals_(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void DLL_EXPORT UpdateTexCoords_(Surface* surf);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online Help</a>
*/
void DLL_EXPORT UpdateWorld_(float anim_speed);

/*
*/
void DLL_EXPORT UseStencil_(Stencil* stencil);
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online Help</a>
*/
float DLL_EXPORT VectorPitch_(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online Help</a>
*/
float DLL_EXPORT VectorYaw_(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online Help</a>
*/
float DLL_EXPORT VertexAlpha_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online Help</a>
*/
float DLL_EXPORT VertexBlue_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online Help</a>
*/
void DLL_EXPORT VertexColor_(Surface* surf,int vid,float r,float g,float b,float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online Help</a>
*/
void DLL_EXPORT VertexCoords_(Surface* surf,int vid,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online Help</a>
*/
float DLL_EXPORT VertexGreen_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online Help</a>
*/
void DLL_EXPORT VertexNormal_(Surface* surf,int vid,float nx,float ny,float nz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online Help</a>
*/
float DLL_EXPORT VertexNX_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online Help</a>
*/
float DLL_EXPORT VertexNY_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online Help</a>
*/
float DLL_EXPORT VertexNZ_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online Help</a>
*/
float DLL_EXPORT VertexRed_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online Help</a>
*/
void DLL_EXPORT VertexTexCoords_(Surface* surf,int vid,float u,float v,float w,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online Help</a>
*/
float DLL_EXPORT VertexU_(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online Help</a>
*/
float DLL_EXPORT VertexV_(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online Help</a>
*/
float DLL_EXPORT VertexW_(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online Help</a>
*/
float DLL_EXPORT VertexX_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online Help</a>
*/
float DLL_EXPORT VertexY_(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online Help</a>
*/
float DLL_EXPORT VertexZ_(Surface* surf,int vid);

/*
*/
void DLL_EXPORT VoxelSpriteMaterial_(VoxelSprite* voxelspr, Material* mat);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online Help</a>
*/
void DLL_EXPORT Wireframe_(int enable);


float DLL_EXPORT EntityScaleX_(Entity* ent,int glob);

float DLL_EXPORT EntityScaleY_(Entity* ent,int glob);

float DLL_EXPORT EntityScaleZ_(Entity* ent,int glob);

Shader* DLL_EXPORT LoadShader_(char* ShaderName, char* VshaderFileName, char* FshaderFileName);

Shader* DLL_EXPORT CreateShader_(char* ShaderName, char* VshaderString, char* FshaderString);

void DLL_EXPORT ShadeSurface_(Surface* surf, Shader* material);

void DLL_EXPORT ShadeMesh_(Mesh* mesh, Shader* material);

void DLL_EXPORT ShadeEntity_(Entity* ent, Shader* material);

Texture* DLL_EXPORT ShaderTexture_(Shader* material, Texture* tex, char* name, int index);

void DLL_EXPORT SetFloat_(Shader* material, char* name, float v1);

void DLL_EXPORT SetFloat2_(Shader* material, char* name, float v1, float v2);

void DLL_EXPORT SetFloat3_(Shader* material, char* name, float v1, float v2, float v3);

void DLL_EXPORT SetFloat4_(Shader* material, char* name, float v1, float v2, float v3, float v4);

void DLL_EXPORT UseFloat_(Shader* material, char* name, float* v1);

void DLL_EXPORT UseFloat2_(Shader* material, char* name, float* v1, float* v2);

void DLL_EXPORT UseFloat3_(Shader* material, char* name, float* v1, float* v2, float* v3);

void DLL_EXPORT UseFloat4_(Shader* material, char* name, float* v1, float* v2, float* v3, float* v4);

void DLL_EXPORT SetInteger_(Shader* material, char* name, int v1);

void DLL_EXPORT SetInteger2_(Shader* material, char* name, int v1, int v2);

void DLL_EXPORT SetInteger3_(Shader* material, char* name, int v1, int v2, int v3);

void DLL_EXPORT SetInteger4_(Shader* material, char* name, int v1, int v2, int v3, int v4);

void DLL_EXPORT UseInteger_(Shader* material, char* name, int* v1);

void DLL_EXPORT UseInteger2_(Shader* material, char* name, int* v1, int* v2);

void DLL_EXPORT UseInteger3_(Shader* material, char* name, int* v1, int* v2, int* v3);

void DLL_EXPORT UseInteger4_(Shader* material, char* name, int* v1, int* v2, int* v3, int* v4);

void DLL_EXPORT UseSurface_(Shader* material, char* name, Surface* surf, int vbo);

void DLL_EXPORT UseMatrix_(Shader* material, char* name, int mode);

Material* DLL_EXPORT LoadMaterial_(char* filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count);

void DLL_EXPORT ShaderMaterial_(Shader* material, Material* tex, char* name, int index);

OcTree* DLL_EXPORT CreateOcTree_(float w, float h, float d, Entity* parent_ent);

void DLL_EXPORT AddToOctree_(OcTree* octree, Mesh* mesh, int level, float X, float Y, float Z, float Near, float Far);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
