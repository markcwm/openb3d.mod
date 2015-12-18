
' Openb3d

Rem
Type TVertex ' struct

	Field coords:TVector2
	
	' wrapper
	Global vertex_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TVertex( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVertex=New TVertex
		vertex_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		vertex_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TVertex( inst:Byte Ptr )
	
		Return TVertex( vertex_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TVertex ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Local inst:Byte Ptr=VertexVector_( GetInstance(Self),MESHCOLLIDER_coords )
		coords=TVector2.GetObject(inst)
		If coords=Null And inst<>Null Then coords=TVector2.CreateObject(inst)
		
	End Method
	
End Type

Type TTriangle ' struct

	Field surface:Int Ptr
	Field verts:Int Ptr ' array [3]
	Field index:Int Ptr
	
	' wrapper
	Global triangle_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TTriangle( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TTriangle=New TTriangle
		triangle_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		triangle_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TTriangle( inst:Byte Ptr )
	
		Return TTriangle( triangle_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TTriangle ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		surface=TriangleInt_( GetInstance(Self),MESHCOLLIDER_surface )
		verts=TriangleInt_( GetInstance(Self),MESHCOLLIDER_verts )
		index=TriangleInt_( GetInstance(Self),MESHCOLLIDER_index )
		
	End Method
	
End Type

Type TMeshCollider ' returned by C_CreateColTree

	' structs are unnamed, accessed by vectors
	
End Type

Type TMeshInfo ' returned by C_NewMeshInfo

	Field tri_list:TList=CreateList() ' TTriangle vector
	Field vert_list:TList=CreateList() ' TVertex vector
	
	' wrapper
	Global info_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TMeshInfo( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TMeshInfo=New TMeshInfo
		info_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		DebugLog "meshinfo="+Int(inst)
		Return obj
		
	End Function
	
	Function DeleteObject( inst:Byte Ptr )
	
		info_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TMeshInfo( inst:Byte Ptr )
	
		Return TMeshInfo( info_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TMeshInfo ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method CopyList( list:TList ) ' Field list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case tri_list
				For Local id:Int=0 To MeshInfoListSize_( GetInstance(Self),MESHINFO_tri_list )-1
					inst=MeshInfoIterVectorTriangle_( GetInstance(Self),MESHINFO_tri_list )
					Local obj:TTriangle=TTriangle.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TTriangle.CreateObject(inst)
					ListAddLast list,obj
				Next
			Case vert_list
				For Local id:Int=0 To MeshInfoListSize_( GetInstance(Self),MESHINFO_vert_list )-1
					inst=MeshInfoIterVectorVertex_( GetInstance(Self),MESHINFO_vert_list )
					Local obj:TVertex=TVertex.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TVertex.CreateObject(inst)
					ListAddLast list,obj
				Next
			End Select
			
	End Method
	
End Type
EndRem

' Minib3d

Rem
Type TColTree

	Field c_col_tree:Byte Ptr=Null
	Field reset_col_tree:Int=False

	Method New()
	
		If LOG_NEW
			DebugLog "New TColTree"
		EndIf
	
	End Method
	
	Method Delete()
	
		If c_col_tree<>Null
			C_DeleteColTree(c_col_tree)
			c_col_tree=Null
		EndIf
	
		If LOG_DEL
			DebugLog "Del TColTree"
		EndIf
	
	End Method
	
	' creates a collision tree for a mesh if necessary
	Method TreeCheck(mesh:TMesh)
	
		' if reset_col_tree flag is true clear tree
		If reset_col_tree=True

			If c_col_tree<>Null
				C_DeleteColTree(c_col_tree)
				c_col_tree=Null
			EndIf
			reset_col_tree=False
				
		EndIf

		If c_col_tree=Null

			Local total_verts:Int=0
			Local mesh_info:Byte Ptr=C_NewMeshInfo()
		
			For Local s:Int=1 To mesh.CountSurfaces()
			
				Local surf:TSurface=mesh.GetSurface(s)
				
				Local no_tris:Int=surf.no_tris
				Local no_verts:Int=surf.no_verts
				Local tris:Short[]=surf.tris[..]
				Local verts:Float[]=surf.vert_coords[..]
										
				If no_tris<>0 And no_verts<>0
				
					' inc vert index
					For Local i:Int=0 To no_tris-1
						tris[i*3+0]:+total_verts
						tris[i*3+1]:+total_verts
						tris[i*3+2]:+total_verts
					Next
				
					' reverse vert order
					For Local i:Int=0 To no_tris-1
						Local t_v0:Int=tris[i*3+0]
						Local t_v2:Int=tris[i*3+2]
						tris[i*3+0]=t_v2
						tris[i*3+2]=t_v0
					Next
					
					' negate z vert coords
					For Local i:Int=0 To no_verts-1
						verts[i*3+2]=-verts[i*3+2]
					Next
		
					C_AddSurface(mesh_info,no_tris,no_verts,tris,verts,s)
										
					total_verts:+no_verts
				
				EndIf
	
			Next

			c_col_tree=C_CreateColTree(mesh_info)

			C_DeleteMeshInfo(mesh_info)

		EndIf
			
	End Method	
	
End Type
EndRem
