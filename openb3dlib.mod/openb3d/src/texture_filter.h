/*
 *  texture_filter.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef TEXTURE_FILTER_H
#define TEXTURE_FILTER_H

#include <list>
#include <string>
#include <iostream>
using namespace std;

class TextureFilter{

public:

	static list<TextureFilter*> tex_filter_list;

	string text_match;
	int flags;

	TextureFilter(){};
	
};

#endif
