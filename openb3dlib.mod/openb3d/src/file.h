/*
 *  file.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */
 
#ifndef FILE_H
#define FILE_H
 
//#import <UIKit/UIKit.h>

#include <string>
#include <stdio.h>
using namespace std;
 
class File{
 
public:
 
	File(){};
	
	~File(){
		//if(pFile) delete pFile;
	}
	
	FILE * pFile;

//	static string DocsDir();
	static string ResourceFilePath(string filename);
	static File* ReadResourceFile(string filename);
	static File* ReadFile(string filename);
	static File* WriteFile(string filename);
	void CloseFile();
	char ReadByte();
	short ReadShort();
	int ReadInt();
	long ReadLong();
	float ReadFloat();
	string ReadString();
	string ReadLine();
	void WriteByte(char c);
	void WriteShort(short s);
	void WriteInt(int i);
	void WriteLong(long l);
	void WriteFloat(float f);
	void WriteString(string s);
	void WriteLine(string s);
	
	void SeekFile(int pos);
	int FilePos();
	
	int Eof();

};
 
#endif
