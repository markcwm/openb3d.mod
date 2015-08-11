// added.cpp

#include "glew.h"

#include "texture.h"
#include "file.h"
#include "global.h"

extern "C" {

// Added functions

void DepthBufferToTex( Texture* tex,int frame ){
	glBindTexture(GL_TEXTURE_2D,tex->texture);
	glCopyTexImage2D(GL_TEXTURE_2D,0,GL_DEPTH_COMPONENT,0,Global::height-tex->height,tex->width,tex->height,0);
	glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP_SGIS,GL_TRUE);
}

} /* extern "C" */

// Added internal functions

// strips file info from filepath
string StripFile( string filename ){
	string stripped_filename=filename;
	string::size_type idx;
	
	// Unix
	idx=filename.find('/');
	if(idx!=string::npos)
		stripped_filename=filename.substr(0,filename.rfind('/'));
	else
		stripped_filename="";
	
	// Windows
	idx=filename.find("\\");
	if(idx!=string::npos)
		stripped_filename=filename.substr(0,filename.rfind("\\"));
	else
		stripped_filename="";
	
	return stripped_filename;
}

// makes a new path for a filename from a given filepath
string NewFilePath(string filepath, string filename){
	string fpath=StripFile(filepath);
	string fname=Texture::Strip(filename);
	string url;
	File* stream;
	
	// Unix
	if (fpath.length()>0) url=fpath+"/"+fname; else url=fname;
	stream=File::ReadFile(url);
	if (stream == 0)
		return "";
	else{
		stream->CloseFile();
		//cout << "unix: '"+url+"'" << endl;
		return url;
	}
	
	// Windows
	if (fpath.length()>0) url=fpath+"\\"+fname; else url=fname;
	stream=File::ReadFile(url);
	if (stream == 0)
		return "";
	else{
		stream->CloseFile();
		//cout << "windows: '"+url+"'" << endl;
		return url;
	}
	
	// Unix - try all lowercase
	for(int i=0; fname[i]; i++){
		fname[i] = tolower(fname[i]);
	}
	if (fpath.length()>0) url=fpath+"/"+fname; else url=fname;
	stream=File::ReadFile(url);
	if (stream == 0)
		return "";
	else{
		stream->CloseFile();
		return url;
	}
	
	cout << "Error: Can't Find Resource File '"+filename+"'" << endl;
	return "";
}
