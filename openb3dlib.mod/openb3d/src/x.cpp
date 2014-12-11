#include "string_helper.h"
#include "model.h"
#include "entity.h"
#include "bone.h"
#include "mesh.h"
#include "texture.h"
#include "file.h"
#include <list>
#include<cctype>
#include<algorithm>

namespace loadX{

File*  Stream;


	class XLoader_TreeNode{
	public:
		list<XLoader_TreeNode*> children;
		string content;
		string Template;
		string name;
	
		/*Method New()
			Self.children = New TList
		End Method*/
	
		void Add(XLoader_TreeNode* element){
			children.push_back(element);
		}
	};

list<int>      MovedTris;

string xReadString(File* file, int lenght){
	string t="";
	for(int i=1;i<=lenght;i++){
		char ch=file->ReadByte();
		t=t+ch;
	}
	return t;
}

string xReadAll(File* file){
	string t="";
	while (!file->Eof()){
		char ch=file->ReadByte();
		t=t+ch;
	}
	return t;
}

void string_find_and_replace( string &source, string find, string replace ) {
     
	size_t j;
	for ( ; (j = source.find( find )) != string::npos ; ) {
		source.replace( j, find.length(), replace );
	}
}

inline double convertToDouble(std::string const& s)
{
  std::istringstream i(s);
  double x;
  i >> x;
  return x;
}

/*inline vector<string> split( const string& s, const string& f ) {
    vector<string> temp;
    if ( f.empty() ) {
        temp.push_back( s );
        return temp;
    }
    typedef string::const_iterator iter;
    const iter::difference_type f_size( distance( f.begin(), f.end() ) );
    iter i( s.begin() );
    for ( iter pos; ( pos = search( i , s.end(), f.begin(), f.end() ) ) != s.end(); ) {
        temp.push_back( string( i, pos ) );
        advance( pos, f_size );
        i = pos;
    }
    temp.push_back( string( i, s.end() ) );
    return temp;
}*/

inline vector<string> split(const string& strValue, char separator){
	vector<string> vecstrResult;
	int startpos=0;
	int endpos=0;

	endpos = strValue.find_first_of(separator, startpos);
	while (endpos != -1)
	{       
		vecstrResult.push_back(strValue.substr(startpos, endpos-startpos)); // add to vector
		startpos = endpos+1; //jump past sep
		endpos = strValue.find_first_of(separator, startpos); // find next
	}
	//lastone, so no 2nd param required to go to end of string
	vecstrResult.push_back(strValue.substr(startpos));
        
	    

	return vecstrResult;
}


string XLoader_RemoveUnprintables(string s){
		
	for (char i = 0; i<= 31;i++){
		string s1;
		s1.resize(1, i);
		string_find_and_replace( s, s1, "");
	}
		
	return s;
	
}

int XLoader_FindBracketMatch(string s){
		
	int index = 1;
		
	for (unsigned int i = 0;i < s.length();i++){
		switch (s[i]){
			case '{':
				index++;
				break;
			case '}':
				index--;
			}
				 
			if (index == 0)
				return i;
	}
	
	return -1;
		
}

int XLoader_FindAlphaChar(string s){
		
	for (unsigned int i = 0;i < s.length();i++){
		if (s[i] >= 65 && s[i] <= 90)
			return i; // A-Z	
		if (s[i] >= 97 && s[i] <= 122)
			return i; // a-z
	}
		
	return -1;
	
}


XLoader_TreeNode* XLoader_MakeTree(string s, XLoader_TreeNode* parent = 0){
		
		XLoader_TreeNode* root = new XLoader_TreeNode;
		size_t pointer = 0;
		size_t find = 0;
		
		s = Trim(s);
		
		while (s.length() > 0){
			find = s.find("{", pointer);
			
			if (find == string::npos) 
				break;
			
			string header = s.substr(pointer,find-pointer);

			vector<string> bits = split (header,' ');
	
			pointer = find + 1;

			root->Template = bits[0];




			if (bits.size() > 1) 
				root->name = bits[1];
			
			int frameend = XLoader_FindBracketMatch(s.substr(pointer));
			string framecontent = s.substr(pointer,frameend);
			
			root->content = framecontent;
			
			s = s.substr(pointer + 1 + frameend);

			transform(root->Template.begin(), root->Template.end(),root->Template.begin(),::tolower);			

			if (root->Template=="frame" || root->Template=="mesh"){
				int contentend = XLoader_FindAlphaChar(framecontent);
				root->content = framecontent.substr(0,contentend);
				XLoader_TreeNode* newNode = XLoader_MakeTree(framecontent.substr(contentend), root);
				if (newNode) 
					 root->Add(newNode);
			}else if (root->Template=="meshmateriallist"){
				int contentend = XLoader_FindAlphaChar(framecontent);
				//root->content = framecontent.substr(0,contentend);
				XLoader_TreeNode* newNode = XLoader_MakeTree(framecontent.substr(contentend), root);
				if (newNode) 
					root->Add(newNode);

				parent->Add(root);
				root = new XLoader_TreeNode;
					
			}else{
				XLoader_TreeNode* newNode = XLoader_MakeTree(s, root);
				if (newNode) 
					root->Add(newNode);

				return root;

			}
			
			pointer = 0;
		}
		
		return root;
		
}


void loadBrush(list<XLoader_TreeNode*> matlist, Brush* brushes[], vector<string> &brushnames){
	int count = 0;
	list<XLoader_TreeNode*>::iterator material2;
	XLoader_TreeNode* material;

	for (material2 = matlist.begin(); material2 != matlist.end(); material2++){
		material=*material2;

		brushnames.push_back(material->name);
							
		vector<string> brushrgba = split(material->content.substr(0,material->content.find(";;")), ';');
		brushes[count] = Brush::CreateBrush(
			convertToDouble(brushrgba[0])* 255.0,
			convertToDouble(brushrgba[1])* 255.0,
			convertToDouble(brushrgba[2])* 255.0);



		brushes[count]->BrushAlpha(convertToDouble(brushrgba[3]));
								
		int texturefilestart = material->content.find('"');
								
		if (texturefilestart != -1){
			string texturefilename = material->content.substr(texturefilestart + 1,material->content.find('"', texturefilestart + 1) - texturefilestart - 1);
			Texture* tex = Texture::LoadTexture(texturefilename);
			if (tex != 0)
				brushes[count]->BrushTexture(tex);
		}
			
		count++;
	}

}

list<XLoader_TreeNode*> XLoader_FindTreeElements(XLoader_TreeNode* tree, string Template, int recur=0){
		
	list<XLoader_TreeNode*> l;
	
	string lTemplate=tree->Template;

	transform(lTemplate.begin(), lTemplate.end(),lTemplate.begin(), ::tolower);
		
	if (lTemplate == Template)
		l.push_back(tree);

	if (recur==1 && Template!="mesh")
		{if (lTemplate=="mesh")	
			{return l;}
		}
	
	list<XLoader_TreeNode*>::iterator element;
	for (element = tree->children.begin(); element != tree->children.end(); element++){
		XLoader_TreeNode* elem=*element;
		if (elem->Template == Template && elem->children.size()==0) {
			l.push_back(elem);
		}
	}

	for (element = tree->children.begin(); element != tree->children.end(); element++){
		XLoader_TreeNode* elem=*element;

		/*if (elem->Template == Template)
			l.push_back(elem);*/
		if (elem->children.size()!=0){
			list<XLoader_TreeNode*> l2;
			l2=XLoader_FindTreeElements(elem, Template, 1);
			l.merge(l2);}
	}
		
	return l;
	
}



Mesh* LoadX(string URL, Entity* parent_ent){
	Stream = File::ReadFile(URL);
	if (Stream == 0) return 0;

	string header = xReadString(Stream, 4);
	string version = xReadString(Stream, 4);
	string format = xReadString(Stream, 4);
	string floatsize= xReadString(Stream,4);
		
	if (header == "xof "){
		if (version == "0302"){
			if (format == "txt "){
					
				Mesh* submesh = Mesh::CreateMesh(parent_ent);
								
				while (!Stream->Eof()){
					// check first byte
					char checkbyte = Stream->ReadByte();
					Stream->SeekFile(Stream->FilePos() - 1);
	
					if (!(checkbyte<=32 || checkbyte == '/' || checkbyte == '#')){
						string read = xReadAll(Stream);
						read = XLoader_RemoveUnprintables(read);
						string_find_and_replace(read, " {", "{");
						string_find_and_replace(read, "{ ", "{");
						string_find_and_replace(read, " }", "}");
						string_find_and_replace(read, "} ", "}");
							
						XLoader_TreeNode* tree = XLoader_MakeTree(read);
							
						// fetch material data
						list<XLoader_TreeNode*> matlist = XLoader_FindTreeElements(tree, "material");
						Brush* brushes[matlist.size()];
						vector<string> brushnames;

						loadBrush(matlist, brushes, brushnames);

						list<XLoader_TreeNode*> framelist = XLoader_FindTreeElements(tree, "frame");
						XLoader_TreeNode* frametree;
						list<XLoader_TreeNode*>::iterator frametree2;
						if (framelist.empty())
							framelist.push_back(tree);

						for (frametree2 = framelist.begin(); frametree2 != framelist.end(); frametree2++){
							frametree=*frametree2;
							transform(frametree->name.begin(), frametree->name.end(),frametree->name.begin(), ::tolower);			
							
							if (frametree->name != "world"){
							
								// read transformation matrix
								list<XLoader_TreeNode*> tmatlist = XLoader_FindTreeElements(frametree, "frametransformmatrix");
																		
								// assemble mesh
								list<XLoader_TreeNode*> meshnodes = XLoader_FindTreeElements(frametree, "mesh");

								XLoader_TreeNode* meshnode;
								//int currentmeshnode = 0;
								Matrix tformmat;
								
								list<XLoader_TreeNode*>::iterator meshnode2;	


								list<XLoader_TreeNode*>::iterator meshlistelm;
								meshlistelm=tmatlist.begin();

								for (meshnode2=meshnodes.begin(); meshnode2!=meshnodes.end();meshnode2++){
									meshnode=*meshnode2;
									
									// create corresponding tformmatrix
									//Local meshlistelm:Object = tmatlist.ValueAtIndex(currentmeshnode)

										
									if (meshlistelm != tmatlist.end()){
										XLoader_TreeNode* meshlistelm2;
										meshlistelm2=*meshlistelm;

										vector<string> tmat = split(meshlistelm2->content,',');
										//currentmeshnode:+1
										meshlistelm++;
																			
										//tformmat:TMatrix = New TMatrix
										tformmat.LoadIdentity();
										int maty = -1;
										int matx = 0;
											
										for (matx = 0; matx <= 15; matx++){
											if (matx % 4 == 0){
												maty++;
											}
											tformmat.grid[matx - maty * 4][maty] = ::atof(tmat[matx].c_str());
										}
									}
									
									// create surface
									Surface* surf = submesh->CreateSurface();
									string meshdata = Trim(meshnode->content);
									string_find_and_replace(meshdata, " ", "");
										
									// read vertex count
									int offset = meshdata.find(";");
									int vertexcount = ::atoi(meshdata.substr(0,offset).c_str());
										
									meshdata = meshdata.substr(offset+1);
									offset = meshdata.find(";;");

									string meshdata2=meshdata.substr(0,offset);
									string_find_and_replace(meshdata2, ",", "");
									
									vector<string> vertexdata = split(meshdata2,';');

									
									// add vertices
									int vcount = 0;
										
									for (vcount = 0; vcount<= (vertexcount - 1) * 3; vcount+=3){
										float vertx = ::atof(vertexdata[vcount].c_str());
										float verty = ::atof(vertexdata[vcount + 1].c_str());
										float vertz = ::atof(vertexdata[vcount + 2].c_str());
											
										float x = vertx * tformmat.grid[0][0] + verty * tformmat.grid[0][1] + vertz * tformmat.grid[0][2] + tformmat.grid[0][3];
										float y = vertx * tformmat.grid[1][0] + verty * tformmat.grid[1][1] + vertz * tformmat.grid[1][2] + tformmat.grid[1][3];
										float z = vertx * tformmat.grid[2][0] + verty * tformmat.grid[2][1] + vertz * tformmat.grid[2][2] + tformmat.grid[2][3];
										float w = tformmat.grid[3][0] + tformmat.grid[3][1] + tformmat.grid[3][2] + tformmat.grid[3][3];
											
										surf->AddVertex(x, y, z);
									}
										
									// read face count
									meshdata = meshdata.substr(offset+2);
									offset = meshdata.find(";");
									int facecount = ::atoi(meshdata.substr(0,offset).c_str());
										
									meshdata = meshdata.substr(offset+1);
									offset = meshdata.find(";;");

									meshdata2=meshdata.substr(0,offset);
									string_find_and_replace(meshdata2, ";,", ";");
										
									vector<string> facedata = split(meshdata2,';');
										
									// draw faces
									int fcount = 0;
			
									for (fcount = 1; fcount<= facecount * 2; fcount+=2){
										vector<string> faces = split(facedata[fcount],',');
																			
										if (faces.size() == 3){
											surf->AddTriangle(
											::atoi(faces[0].c_str()),
											::atoi(faces[1].c_str()),
											::atoi(faces[2].c_str()));
										} else if (faces.size() == 4){
											surf->AddTriangle(
											::atoi(faces[0].c_str()),
											::atoi(faces[1].c_str()),
											::atoi(faces[2].c_str()));

											surf->AddTriangle(
											::atoi(faces[2].c_str()),
											::atoi(faces[3].c_str()),
											::atoi(faces[0].c_str()));
										}
									}
										
									// lookup mesh normals
									list<XLoader_TreeNode*> normals = XLoader_FindTreeElements(meshnode, "meshnormals");
										
									if (normals.empty()){
										submesh->UpdateNormals();
									}else{
										string normaldata = (*normals.begin())->content;


										int normalcount = ::atoi(normaldata.substr(0,normaldata.find(";")).c_str());

										normaldata = normaldata.substr(normaldata.find(";"));
										normaldata = normaldata.substr(0,normaldata.find(";;"));
										string_find_and_replace(normaldata, ",", "");


										vector<string> normalbits = split(normaldata, ';');
											
										for (int i = 0; i< normalcount;i++){
											surf->VertexNormal(i,
											::atof(normalbits[i * 3].c_str()),
											::atof(normalbits[i * 3+1].c_str()),
											::atof(normalbits[i * 3+2].c_str()));

										}
									}
										
									// texture coordinates
									list<XLoader_TreeNode*> textcoords = XLoader_FindTreeElements(meshnode, "meshtexturecoords");

										
									if (!textcoords.empty()){
										string texturecoordsdata = (*textcoords.begin())->content;

										int texturecoordscount = ::atoi(texturecoordsdata.substr(0,texturecoordsdata.find(";")).c_str());

										texturecoordsdata = texturecoordsdata.substr(texturecoordsdata.find(";")+1);
										texturecoordsdata = texturecoordsdata.substr(0,texturecoordsdata.find(";;"));
										string_find_and_replace(texturecoordsdata, ",", "");
										vector<string> tcoords = split(texturecoordsdata,';');

										for (int i = 0; i< texturecoordscount;i++){
											surf->VertexTexCoords(i,
											::atof(tcoords[i * 2].c_str()),
											::atof(tcoords[i * 2+1].c_str()));
										}
									}
										
									// apply materials
									list<XLoader_TreeNode*> texlist = XLoader_FindTreeElements(meshnode, "meshmateriallist");
									if (!texlist.empty()){

										string texdata = (*texlist.begin())->content;

										int materialscount = ::atoi(texdata.substr(0,texdata.find(";")).c_str());

										texdata = texdata.substr(texdata.find(";")+1);

										int facescount = ::atoi(texdata.substr(0,texdata.find(";")).c_str());

										texdata = texdata.substr(texdata.find(";")+1);

										vector<string> mats = split(texdata,',');

										texdata = texdata.substr(texdata.find(";;") + 3);

										list<XLoader_TreeNode*> Lmatlist = XLoader_FindTreeElements(meshnode, "material");
										Brush* Lbrushes[Lmatlist.size()];
										vector<string> Lbrushnames;

										loadBrush(Lmatlist, Lbrushes, Lbrushnames);
										//string texname = texdata.substr(0,texdata.find("}"));
										string_find_and_replace(texdata, "{", "");
										vector<string> texname = split(texdata,'}');

										/*for (unsigned int i = 0; i< matlist.size();i++){
											if (brushnames[i] == texname)
												{surf->PaintSurface(brushes[i]);}
										}*/
										for (int m = 0; m< materialscount;m++){
											Surface* New_surface = submesh->CreateSurface();
											for (int Index = 0; Index<facescount;Index++){
												if(::atoi(mats[Index].c_str())==m){
													int v0[3];
													for (int i=0;i <3;i++){
														v0[i]=surf->TriangleVertex(Index,i);
														float x,y,z,u,v,w,nx,ny,nz;
														x=surf->VertexX(v0[i]);
														y=surf->VertexY(v0[i]);
														z=surf->VertexZ(v0[i]);
														u=surf->VertexU(v0[i]);
														v=surf->VertexV(v0[i]);
														w=surf->VertexW(v0[i]);
														nx=surf->VertexNX(v0[i]);
														ny=surf->VertexNY(v0[i]);
														nz=surf->VertexNZ(v0[i]);
														v0[i]=New_surface->AddVertex(x,y,z,u,v,w);
														New_surface->VertexNormal(v0[i],nx,ny,nz);
													}
													New_surface->AddTriangle(v0[0],v0[1],v0[2]);
													MovedTris.push_back(Index);

												}
											}

											if (Lmatlist.size()==0){
												for (unsigned int i = 0; i< matlist.size();i++){
													if (brushnames[i] == texname[m])
														{New_surface->PaintSurface(brushes[i]);}
												}
											}else{
												New_surface->PaintSurface(Lbrushes[m]);
											}
										}

										MovedTris.sort();
										int CheckSurface=0;
										for(list<int>::const_reverse_iterator it = MovedTris.rbegin(); it != MovedTris.rend(); it++){
											surf->RemoveTri(*it);
											CheckSurface=1;
										}
										MovedTris.clear();
										if (surf->no_tris==0 && CheckSurface !=0) {
											delete surf;
											submesh->surf_list.remove(surf);
											submesh->no_surfs=submesh->no_surfs-1;
										}


									}
								}
							}
						}
					}else{
						if (checkbyte<=32)
							{Stream->SeekFile(Stream->FilePos() + 1);
						}else{
							Stream->ReadLine();
						}
					}
				}
					
				Stream->CloseFile();
					
				return submesh;
			}else{
				//cout<<"X Mesh Loader: Unsupported format '"<<format<<"'!";
			}
		}else{
			//cout<<"X Mesh Loader: Unsupported version '"<< version << "'!";
		}
	}else{
		//cout<<"X Mesh Loader: Invalid x-mesh!";
	}
	
	return Mesh::CreateCube();
	
}
}
