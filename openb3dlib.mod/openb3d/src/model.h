/*
 *  model.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef MODEL_H
#define MODEL_H

#include "entity.h"
#include "mesh.h"
#include "file.h"

#include <iostream>
//#include <fstream>
#include <string>
using namespace std;

Mesh* LoadAnimB3D(string f_name,Entity* parent_ent_ext=NULL);

string b3dReadString(File* file);
string ReadTag(File* file);
int NewTag(string tag);
int TagID(string tag);
void TrimVerts(Surface* surf);


/*
const int BRUS;
const int NODE;
const int ANIM;
const int MESH;
const int VRTS;
const int TRIS;
const int BONE;
const int KEYS;
*/

#endif
