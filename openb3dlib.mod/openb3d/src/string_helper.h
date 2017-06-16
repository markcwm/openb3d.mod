/*
 *  string_helper.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef STRING_HELPER_H
#define STRING_HELPER_H

#include <string>
using namespace std;
 
string Left(string s,int length);
string Right(string s,unsigned int length);
string Mid(string s,int offset,int characters=0);
string Replace(string s,string find,string replace);
int Instr(string s1,string s2,int offset=0);
string Upper(string s);
string Lower(string s);
string Trim(string s);
string Chr(int asc);
int Asc(string s);
int Len(string s);
string Split(string s,string splitter,int count);

#endif
