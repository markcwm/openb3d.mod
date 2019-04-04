
Rem
bbdoc: DirectDrawSurface
End Rem
Type TDDS

	Global current_surface:TDDS
	
	Field buffer:Byte Ptr
	'vector<DirectDrawSurface> Mipmaps
	
	Field width:Int Ptr
	Field height:Int Ptr
	Field depth:Int Ptr
	Field mipmapcount:Int Ptr
	Field pitch:Int Ptr
	Field size:Int Ptr
	
	Field dxt:Byte Ptr
	Field format:Int Ptr
	Field components:Int Ptr
	Field target:Int Ptr
	
	' wrapper
	?bmxng
	Global dds_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global dds_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	Field exists:Int=0 ' Free
	
	Function CreateObject:TDDS( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TDDS=New TDDS
		?bmxng
		dds_map.Insert( inst,obj )
		?Not bmxng
		dds_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		dds_map.Remove( inst )
		?Not bmxng
		dds_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TDDS( inst:Byte Ptr )
	
		?bmxng
		Return TDDS( dds_map.ValueForKey( inst ) )
		?Not bmxng
		Return TDDS( dds_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TDDS ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' char
		buffer=DirectDrawSurfaceChar_( GetInstance(Self),DDS_buffer )
		dxt=DirectDrawSurfaceChar_( GetInstance(Self),DDS_dxt )
		
		' int
		width=DirectDrawSurfaceInt_( GetInstance(Self),DDS_width )
		height=DirectDrawSurfaceInt_( GetInstance(Self),DDS_height )
		depth=DirectDrawSurfaceInt_( GetInstance(Self),DDS_depth )
		mipmapcount=DirectDrawSurfaceInt_( GetInstance(Self),DDS_mipmapcount )
		pitch=DirectDrawSurfaceInt_( GetInstance(Self),DDS_pitch )
		size=DirectDrawSurfaceInt_( GetInstance(Self),DDS_size )
		
		' uint
		format=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_format )
		components=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_components )
		target=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_target )
		
		exists=1
		
	End Method
	
	Function StringPtr:String( inst:Byte Ptr ) 
	?bmxng
		Return String(inst)
	?Not bmxng
		Return String(Int(inst))
	?
	End Function
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" DDS instance: "+StringPtr(GetInstance(Self))
		
		' char
		If buffer<>Null Then DebugLog(pad+" buffer: "+buffer[0]) Else DebugLog(pad+" buffer: Null")
		If dxt<>Null Then DebugLog(pad+" dxt: "+dxt[0]) Else DebugLog(pad+" dxt: Null")
		
		' int
		If width<>Null Then DebugLog(pad+" width: "+width[0]) Else DebugLog(pad+" width: Null")
		If height<>Null Then DebugLog(pad+" height: "+height[0]) Else DebugLog(pad+" height: Null")
		If depth<>Null Then DebugLog(pad+" depth: "+depth[0]) Else DebugLog(pad+" depth: Null")
		If mipmapcount<>Null Then DebugLog(pad+" mipmapcount: "+mipmapcount[0]) Else DebugLog(pad+" mipmapcount: Null")
		If pitch<>Null Then DebugLog(pad+" pitch: "+pitch[0]) Else DebugLog(pad+" pitch: Null")
		If size<>Null Then DebugLog(pad+" size: "+size[0]) Else DebugLog(pad+" size: Null")
		
		' uint
		If format<>Null Then DebugLog(pad+" format: "+format[0]) Else DebugLog(pad+" format: Null")
		If components<>Null Then DebugLog(pad+" components: "+components[0]) Else DebugLog(pad+" components: Null")
		If target<>Null Then DebugLog(pad+" target: "+target[0]) Else DebugLog(pad+" target: Null")
		
		DebugLog ""
		
	End Method
	
	Method FreeDDS( free_buffer:Int=0 )
	
		If exists
			exists=0
			DDS_FreeDirectDrawSurface( GetInstance(Self),free_buffer ) ' don't free buffer, it was freed earlier
			FreeObject( GetInstance(Self) )
		EndIf
		
	End Method
	
End Type
