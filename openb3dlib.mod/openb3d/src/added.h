// added.h

extern "C" {

// Added functions
void DepthBufferToTex( Texture* tex,int frame );

} // extern "C"

// Added internal functions
string StripFile( string filename );
string NewFilePath( string filepath,string filename );
