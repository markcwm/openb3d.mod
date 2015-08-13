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
	string::size_type idx;
	
#ifdef WIN32
	// Windows
	idx=filename.find("\\");
	if(idx!=string::npos)
		return filename.substr(0,filename.rfind("\\"));
#else
	// Unix
	idx=filename.find('/');
	if(idx!=string::npos)
		return filename.substr(0,filename.rfind('/'));
#endif
	return "";
}

// makes a new path for a filename from a given filepath
string NewFilePath(string filepath, string filename){
	string fpath=StripFile(filepath);
	string fname=Texture::Strip(filename);
	string url;
	File* stream;
	
#ifdef WIN32
	// Windows
	if (fpath.length() == 0) url=fname; else url=fpath+"\\"+fname;
	stream=File::ReadFile(url);
	if (stream == 0)
		return "";
	else{
		stream->CloseFile();
		//cout << "windows: '"+url+"'" << endl;
		return url;
	}
#else
	// Unix
	if (fpath.length() == 0) url=fname; else url=fpath+"/"+fname;
	stream=File::ReadFile(url);
	if (stream == 0)
		return "";
	else{
		stream->CloseFile();
		//cout << "unix: '"+url+"'" << endl;
		return url;
	}
#endif

	cout << "Error: Can't Find Resource File '"+filename+"'" << endl;
	return "";
}
