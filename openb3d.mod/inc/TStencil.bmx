
Rem
bbdoc: Stencil
End Rem
Type TStencil

	Field instance:Byte Ptr
	
	Function CreateObject:TStencil( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TStencil=New TStencil
		obj.instance=inst
		Return obj
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TStencil ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Function CreateStencil:TStencil()
	
		Local inst:Byte Ptr=CreateStencil_()
		Return CreateObject(inst)
		
	End Function
	
	Method StencilAlpha( a:Float )
	
		StencilAlpha_( GetInstance(Self),a )
		
	End Method
	
	Method StencilClsColor( r:Float,g:Float,b:Float )
	
		StencilClsColor_( GetInstance(Self),r,g,b )
		
	End Method
	
	Method StencilClsMode( cls_depth:Int,cls_zbuffer:Int )
	
		StencilClsMode_( GetInstance(Self),cls_depth,cls_zbuffer )
		
	End Method
	
	Method StencilMesh( mesh:TMesh,Mode:Int=1 )
	
		StencilMesh_( GetInstance(Self),TMesh.GetInstance(mesh),Mode )
		
	End Method
	
	Method StencilMode( m:Int,o:Int=1 )
	
		StencilMode_( GetInstance(Self),m,o )
		
	End Method
	
	Function UseStencil( sten:TStencil ) ' as function so Null can be passed
	
		UseStencil_( GetInstance(sten) )
		
	End Function
	
End Type
