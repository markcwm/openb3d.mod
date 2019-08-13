#include "model.h"
#include "entity.h"
#include "bone.h"
#include "mesh.h"
#include "texture.h"
#include "file.h"
#include <list>

namespace load3ds{

const int M3D_3DS_RGB3F          = 0x0010;
const int M3D_3DS_RGB3B          = 0x0011;
const int M3D_3DS_RGBGAMMA3B     = 0x0012;
const int M3D_3DS_RGBGAMMA3F     = 0x0013;
const int M3D_3DS_PERCENTI       = 0x0030;
const int M3D_3DS_PERCENTF       = 0x0031;
const int M3D_3DS_MAIN           = 0x4D4D;
const int M3D_3DS_3DEDITOR       = 0x3D3D;
const int M3D_3DS_OBJECTBLOCK    = 0x4000;
const int M3D_3DS_TRIMESH        = 0x4100;
const int M3D_3DS_VERTEXLIST     = 0x4110;
const int M3D_3DS_FACELIST       = 0x4120;
const int M3D_3DS_FACEMATLIST    = 0x4130;
const int M3D_3DS_TEXCOORDS      = 0x4140;
const int M3D_3DS_BrushBLOCK     = 0xAFFF;
const int M3D_3DS_BrushNAME      = 0xA000;
const int M3D_3DS_BrushAMBIENT   = 0xA010;
const int M3D_3DS_BrushDIFFUSE   = 0xA020;
const int M3D_3DS_BrushSPECULAR  = 0xA030;
const int M3D_3DS_BrushSHININESS = 0xA040;
const int M3D_3DS_TEXTUREMAP1    = 0xA200;
const int M3D_3DS_TEXTUREMAP2    = 0xA33A;
const int M3D_3DS_MAPFILENAME    = 0xA300;
const int M3D_3DS_MAPVSCALE      = 0xA354;
const int M3D_3DS_MAPUSCALE      = 0xA356;
const int M3D_3DS_MAPUOFFSET     = 0xA358;
const int M3D_3DS_MAPVOFFSET     = 0xA35A;
const int M3D_3DS_MAPROTATION    = 0xA35C;

File*          Stream;
unsigned short ChunkID;
int            ChunkSize;
Surface*       surface;
int            VertexCount;
int            TriangleCount;
Mesh*          mesh;
list<Brush*>   Brushs;
Brush*         brush;
int            TextureLayer;
Texture*       texture;
list<int>      MovedTris;

void ReadChunk(){
  ChunkID   = Stream->ReadShort();
  ChunkSize = Stream->ReadInt();
}

void SkipChunk(){
  Stream->SeekFile(Stream->FilePos()+ChunkSize-6);
}

string ReadCString(){
  string s;
  char c=Stream->ReadByte();

  // get string up to first new line character of end of file
  while(c!=0 && Stream->Eof()==0){
    s=s+c;
    c=Stream->ReadByte();
  }
  return s;
}

void ReadRGB(int Format, unsigned char &Red, unsigned char &Green, unsigned char &Blue){
  switch (Format){
    case M3D_3DS_RGB3F:
      Red   = (unsigned char)Stream->ReadFloat()*255;
      Green = (unsigned char)Stream->ReadFloat()*255;
      Blue  = (unsigned char)Stream->ReadFloat()*255;
      break;

    case M3D_3DS_RGB3B:
      Red   = Stream->ReadByte();
      Green = Stream->ReadByte();
      Blue  = Stream->ReadByte();
      break;

    case M3D_3DS_RGBGAMMA3F:
      Red   = (unsigned char)Stream->ReadFloat()*255;
      Green = (unsigned char)Stream->ReadFloat()*255;
      Blue  = (unsigned char)Stream->ReadFloat()*255;
      break;

    case M3D_3DS_RGBGAMMA3B:
      Red   = Stream->ReadByte();
      Green = Stream->ReadByte();
      Blue  = Stream->ReadByte();
      break;

    default:
      SkipChunk();
  }
}

unsigned char ReadPercent(int Format){
  switch (Format){
    case M3D_3DS_PERCENTI:
      return (int)Stream->ReadShort();

    case M3D_3DS_PERCENTF:
      return (int)Stream->ReadFloat();

    default:
      SkipChunk();
      return 0.0;
  }
}

void ReadVertexList(){
  int Index;
  float Position[3];
  VertexCount = Stream->ReadShort();
  for (Index = 0; Index< VertexCount;Index++){
    Position[0] = Stream->ReadFloat();
    Position[1] = Stream->ReadFloat();
    Position[2] = Stream->ReadFloat();
    surface->AddVertex(Position[0], Position[1], Position[2]);
  }
}

void ReadFaceList(){
  int Index;
  int Indices[3];
  TriangleCount = Stream->ReadShort();
  for (Index = 0; Index<TriangleCount;Index++){
    Indices[0] = Stream->ReadShort();
    Indices[1] = Stream->ReadShort();
    Indices[2] = Stream->ReadShort();
    Stream->ReadShort(); // FaceFlags
    surface->AddTriangle(Indices[0], Indices[1], Indices[2]);
  }
}

void ReadFaceMatList(){
  string Name;
  int Found;
  int Count;
  int Index;
  Brush* brush;
  Surface* New_surface;
  short v;

  Name = ReadCString();

  // Search for the BrushName
  Found = false;

  list<Brush*>::iterator it;
  for(it=Brushs.begin();it!=Brushs.end();it++){
    brush=*it;
    if (brush->name == Name){
      Found = true;
      break;
    }
  }

  if(Found==true) {
    New_surface = mesh->CreateSurface();
    Count = Stream->ReadShort();
    //Stream->SeekFile(Stream->FilePos()+Count*2);
    for (Index = 0; Index<Count;Index++){
      v = Stream->ReadShort();
      int v0[3];
      for (int i=0;i <3;i++){
        v0[i]=surface->TriangleVertex(v,i);
        float x,y,z,u,v,w;
        x=surface->VertexX(v0[i]);
        y=surface->VertexY(v0[i]);
        z=surface->VertexZ(v0[i]);
        u=surface->VertexU(v0[i]);
        v=surface->VertexV(v0[i]);
        w=surface->VertexW(v0[i]);
        v0[i]=New_surface->AddVertex(x,y,z,u,v,w);
      }
      New_surface->AddTriangle(v0[0],v0[1],v0[2]);
      //surface->RemoveTri(v);
      /*v=(v+1)*3;
      surface->tris[v-1]=0;
      surface->tris[v-2]=0;
      surface->tris[v-3]=0;*/
      MovedTris.push_back(v);
    }
    New_surface->PaintSurface(brush);
  }
}

void ReadTexCoords(){
  int Count;
  int Index;
  float U, V;

  Count = Stream->ReadShort();
  for (Index = 0; Index<Count;Index++){
    U = Stream->ReadFloat();
    V = -Stream->ReadFloat();
    surface->VertexTexCoords(Index, U, V, 0, 0);
    surface->VertexTexCoords(Index, U, V, 0, 1);
  }
}

void LoadMap(){
  string Filename;
  //int Pixmap;
  Filename = ReadCString();
  //Pixmap = FileType(Filename)
  //If Pixmap <> 0 Then
  Texture*       texture_check;
  texture_check = Texture::LoadTexture(Filename,4);
  //Stops OpenB3D crashing if a texture file is missing/null
  if(texture_check)
  {
	  texture = Texture::LoadTexture(Filename,4);
	  if (TextureLayer == M3D_3DS_TEXTUREMAP1){
		// Layer 0
		brush->BrushTexture(texture, 0, 0);
	  }else{
		// Layer 1
		brush->BrushTexture(texture, 0, 1);
	  }
  }
  //EndIf
}

void ReadMap(int Layer){
  texture = new Texture;
  TextureLayer = Layer;
}

void ReadTriMesh(){
  if (surface!=0){
    MovedTris.sort();
    int CheckSurface=0;
    for(list<int>::const_reverse_iterator it = MovedTris.rbegin(); it != MovedTris.rend(); it++){
      surface->RemoveTri(*it);
      CheckSurface=1;
    }
    MovedTris.clear();
    if (surface->no_tris==0 && CheckSurface !=0) {
      delete surface;
      mesh->surf_list.remove(surface);
      mesh->no_surfs=mesh->no_surfs-1;
    }
  }
  surface = mesh->CreateSurface();
}

void ReadBrushBlock(){
  brush = Brush::CreateBrush();
  Brushs.push_back(brush);
}

void New3ds(){
  Stream        = 0;
  ChunkID       = 0;
  ChunkSize     = 0;
  surface       = 0;
  VertexCount   = 0;
  TriangleCount = 0;
  mesh          = 0;
  brush         = 0;
  TextureLayer  = 0;
  texture       = 0;
}

Mesh* Load3ds(string URL, Entity* parent_ent){
  int Size;
  //Local OldDir:String
  unsigned char Red, Green, Blue;
  //unsigned char Percent;
  //Local Pixmap:TPixmap
  Stream = File::ReadResourceFile(URL);
  if (Stream == 0) return 0;

  //Size = Stream.Size()
  fseek(Stream->pFile, 0, SEEK_END); // seek to end of file
  Size = ftell(Stream->pFile); // get current file pointer
  fseek(Stream->pFile, 0, SEEK_SET);

  // Read Main-Chunk
  ReadChunk();
  if (ChunkID != M3D_3DS_MAIN || ChunkSize != Size) {
    Stream->CloseFile();
    //Print "No 3DS File"
    return 0;
  }
  // Find 3DEditor-Chunk
  while (Stream->Eof()==0){
    ReadChunk();
    if (ChunkID == M3D_3DS_3DEDITOR){
      break;
    }else{
      SkipChunk();
    }
  }

  //OldDir = CurrentDir()
  //If String(URL) <> "" Then ChangeDir(ExtractDir(String(URL)))
  mesh = Mesh::CreateMesh();
  while (Stream->Eof()==0){
    ReadChunk();
    switch (ChunkID){
    case M3D_3DS_OBJECTBLOCK:
      ReadCString(); // ' ObjectName
      break;
    case M3D_3DS_BrushBLOCK:
      ReadBrushBlock();
      break;
    case M3D_3DS_TRIMESH:
      ReadTriMesh();
      break;
    case M3D_3DS_VERTEXLIST:
      ReadVertexList();
      break;
    case M3D_3DS_FACELIST:
      ReadFaceList();
      break;
    case M3D_3DS_FACEMATLIST:
      ReadFaceMatList();
      break;
    case M3D_3DS_TEXCOORDS:
      ReadTexCoords();
      break;
    case M3D_3DS_BrushNAME:
      //Loader.Brush = CreateBrush()
      brush->name = ReadCString();
      break;
    case M3D_3DS_BrushAMBIENT:
      //ReadChunk();
      //ReadRGB(ChunkID, Red, Green, Blue);
      //brush->SetAmbientColor(Red, Green, Blue);
      break;
    case M3D_3DS_BrushDIFFUSE:
      ReadChunk();
      ReadRGB(ChunkID, Red, Green, Blue);
      //brush->BrushColor(Red, Green, Blue);
      break;
    case M3D_3DS_BrushSPECULAR:
      //'Loader.ReadChunk()
      //'Loader.ReadRGB(Loader.ChunkID, Red, Green, Blue)
      //'Loader.Brush.SetSpecularColor(Red, Green, Blue)
      break;
    case M3D_3DS_BrushSHININESS:
      //'Loader.ReadChunk()
      //'Percent = Loader.ReadPercent(Loader.ChunkID)
      //'Loader.Brush.BrushShininess(Percent)
      break;
    case M3D_3DS_MAPFILENAME:
      LoadMap();
      if(brush->no_texs==0) brush->BrushColor(Red, Green, Blue); // only use rgb if no texture
      break;
    case M3D_3DS_MAPVSCALE:
      texture->v_scale = Stream->ReadFloat();
      break;
    case M3D_3DS_MAPUSCALE:
      texture->u_scale = Stream->ReadFloat();
      break;
    case M3D_3DS_MAPUOFFSET:
      texture->u_pos = Stream->ReadFloat();
      break;
    case M3D_3DS_MAPVOFFSET:
      texture->v_pos = Stream->ReadFloat();
      break;
    case M3D_3DS_MAPROTATION:
      texture->angle = Stream->ReadFloat();
      break;
    default:
      if ((ChunkID == M3D_3DS_TEXTUREMAP1) || (ChunkID == M3D_3DS_TEXTUREMAP2)) {
        ReadMap(ChunkID);
      }else{
        SkipChunk();
      }
    }
  }
  Stream->CloseFile();

  if (surface!=0){
    MovedTris.sort();
    int CheckSurface=0;
    for(list<int>::const_reverse_iterator it = MovedTris.rbegin(); it != MovedTris.rend(); it++){
      surface->RemoveTri(*it);
      CheckSurface=1;
    }
    MovedTris.clear();

    if (surface->no_tris==0 && CheckSurface !=0) {
      delete surface;
      mesh->surf_list.remove(surface);
      mesh->no_surfs=mesh->no_surfs-1;
    }
  }


//    ChangeDir(OldDir)
//    Loader.Surface.UpdateVertices()
//    Loader.Surface.UpdateTriangles()
  mesh->UpdateNormals();
  /*Loader.Mesh.UpdateBuffer()
  Print Loader.Surface.Tris.Length
  Print Loader.Surface.no_verts
  'Loader.Mesh.FlipMesh()*/

  mesh->class_name="Mesh";
  mesh->AddParent(parent_ent);
  Entity::entity_list.push_back(mesh);
  if(mesh->parent!=0){
    mesh->mat.Overwrite(mesh->parent->mat);
    mesh->UpdateMat();
  }else{
    mesh->UpdateMat(true);
  }
  return mesh;
}

} // namespace

