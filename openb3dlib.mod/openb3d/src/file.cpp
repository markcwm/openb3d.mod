/*
 *  file.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "file.h"
#include "string_helper.h"
//#include "misc.h"

#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
using namespace std;

/*string File::DocsDir(){

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    CFStringRef documentsDirectory = (CFStringRef)[paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }

	const char* c_docs_dir=CFStringGetCStringPtr(documentsDirectory,kCFStringEncodingMacRoman);

	int success=0;
	char localBuffer[300];

	if(c_docs_dir==NULL){
		success=CFStringGetCString(documentsDirectory,localBuffer,300,kCFStringEncodingMacRoman);
	}

	string docs_dir="";

	if(success){
		docs_dir=localBuffer;
	}else{
		docs_dir="";
	}

	return docs_dir;

}*/

string File::ResourceFilePath(string filename){

	if(filename==""){
		return "";
	}

	if(filename==""){
		return "";
	}

	//const char* c_filename=filename.c_str();

	/*NSString* ns_string = [NSString stringWithUTF8String: c_filename];

	NSArray* ns_string_parts = [ns_string componentsSeparatedByString:@"."];

	if([ns_string_parts count]!=2) return "";

	NSString* ns_string_part1=[ns_string_parts objectAtIndex: 0];
	NSString* ns_string_part2=[ns_string_parts objectAtIndex: 1];

	if([ns_string_part1 length]==0 || [ns_string_part2 length]==0){
		return "";
	}

	CFStringRef fileString;
	fileString = (CFStringRef)[[NSBundle mainBundle] pathForResource:ns_string_part1 ofType:ns_string_part2];

	if(fileString==0) return "";

	//cout << "fileString: " << fileString << endl;

	const char* filename2=CFStringGetCStringPtr(fileString,CFStringGetSystemEncoding());*/

	return filename;

}

File* File::ReadResourceFile(string filename){

	string filename2=ResourceFilePath(filename);

	if(filename2==""){
		cout << "Error: No Filename: " << filename << endl;
	}

	const char* c_filename=filename2.c_str();

	FILE* pFile=fopen(c_filename,"rb");

	if(pFile==NULL){
		cout << "Error: Cannot Find Resource File: " << filename << endl;
		return NULL;
	}

	File* file=new File();
	file->pFile=pFile;

	return file;

}

File* File::ReadFile(string filename){

/*	if(filename==""){
		RuntimeError("Error: No Filename");
	}*/

	string filename2=filename;

	FILE* pFile=fopen(filename2.c_str(),"rb");

	if(pFile==NULL){
		cout << "Error: Can't Find Document File '"+filename+"'" << endl;
		return NULL;
	}

	File* file=new File();
	file->pFile=pFile;

	return file;

}

File* File::WriteFile(string filename){

/*	if(filename==""){
		RuntimeError("Error: No Filename");
	}*/

	string filename2=filename;

	FILE* pFile=fopen(filename2.c_str(), "wb" );

	if(pFile==NULL){
		cout << "Error: Can't Write File '"+filename+"'" << endl;
		return NULL;
	}

	File* file=new File();
	file->pFile=pFile;

	return file;

}

void File::CloseFile(){

	fclose(pFile);

	delete this;

}

char File::ReadByte(){

	char c;
	fread(&c,1,1,pFile);

	return c;

}

short File::ReadShort(){

	short s;
	fread(&s,1,2,pFile);

	return s;

}

int File::ReadInt(){

	int i;
	fread(&i,1,4,pFile);

	return i;

}

long File::ReadLong(){

	long l;
	fread(&l,1,8,pFile);

	return l;

}

float File::ReadFloat(){

	float f;
	fread(&f,1,4,pFile);

	return f;

}

string File::ReadString(){

	int length=ReadInt();

	char* c=new char[length+1];
	fgets(c,length+1,pFile);

	string s=c;

	return s;

}

string File::ReadLine(){

	string s;
	char c=ReadByte();

	// get string up to first new line character of end of file
	while(c!=13 && c!=10 && Eof()!=true){

		if(c!=0){
			s=s+c;
		}
		c=ReadByte();

	}

	int pos=-1;

	// pass possible remaining new line character
	if(Eof()!=true){
		pos=FilePos();
		c=ReadByte();
		if(c!=13 && c!=10) SeekFile(pos);
	}

	return s;

}

void File::WriteByte(char c){

	fwrite(&c,1,1,pFile);

	return;

}

void File::WriteShort(short s){

	fwrite(&s,1,2,pFile);

	return;

}

void File::WriteInt(int i){

	fwrite(&i,1,4,pFile);

	return;

}

void File::WriteLong(long l){

	fwrite(&l,1,8,pFile);

	return;

}

void File::WriteFloat(float f){

	fwrite(&f,1,4,pFile);

	return;

}

void File::WriteString(string s){

	const char* cs=s.c_str();

	fputs(cs,pFile);

	return;

}

void File::WriteLine(string s){

	for(unsigned int i=0;i<s.length();i++){

		string sc=&s[i];
		const char* c=sc.c_str();

		WriteByte(*c);

	}

	char c13=13;
	char c10=10;

	WriteByte(c13);
	WriteByte(c10);

	return;

}

void File::SeekFile(int pos){

	 fseek(pFile,pos,SEEK_SET);

}

int File::FilePos(){

	return ftell(pFile);

}

int File::Eof(){

	int endof=0;

	int pos=ftell(pFile);

	char c;
	fread(&c,1,1,pFile);

	endof=feof(pFile);

	fseek(pFile,pos,SEEK_SET);

	return endof;

}
