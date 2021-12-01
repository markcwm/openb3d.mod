
' 
Rem
bbdoc: Post effects object
End Rem
Type TPostFX

	' wrapper
	?bmxng
	Global postfx_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global postfx_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TPostFX( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TPostFX=New TPostFX
		?bmxng
		postfx_map.Insert( inst,obj )
		?Not bmxng
		postfx_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		postfx_map.Remove( inst )
		?Not bmxng
		postfx_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TPostFX( inst:Byte Ptr )
	
		?bmxng
		Return TPostFX( postfx_map.ValueForKey( inst ) )
		?Not bmxng
		Return TPostFX( postfx_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TPostFX ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Function CreatePostFX:TPostFX( cam:TCamera,passes:Int=1 )
	
		Local inst:Byte Ptr=CreatePostFX_( TCamera.GetInstance(cam),passes )
		Return CreateObject(inst)
		
	End Function
	
	Method AddRenderTarget( pass_no:Int,numColBufs:Int,depth:Int,format:Int=8,scale:Float=1.0 )
	
		AddRenderTarget_( GetInstance(Self),pass_no,numColBufs,depth,format,scale )
		
	End Method
	
	Method PostFXShader( pass_no:Int,shader:TShader )
	
		PostFXShader_( GetInstance(Self),pass_no,TShader.GetInstance(shader) )
		
	End Method
	
	Method PostFXShaderPass( pass_no:Int,name:String,v:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		PostFXShaderPass_( GetInstance(Self),pass_no,cString,v )
		MemFree cString
		
	End Method
	
	Method PostFXBuffer( pass_no:Int,source_pass:Int,index:Int,slot:Int )
	
		PostFXBuffer_( GetInstance(Self),pass_no,source_pass,index,slot )
		
	End Method
	
	Method PostFXTexture( pass_no:Int,tex:TTexture,slot:Int,frame:Int=0 )
	
		PostFXTexture_( GetInstance(Self),pass_no,TTexture.GetInstance(tex),slot,frame )
		
	End Method
	
	Method PostFXFunction( pass_no:Int,PassFunction() )
	
		PostFXFunction_( GetInstance(Self),pass_no,PassFunction )
		
	End Method
	
End Type
