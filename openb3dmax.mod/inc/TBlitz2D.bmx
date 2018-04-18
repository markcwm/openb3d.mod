
Rem
bbdoc: Blitz2D
EndRem
Type TBlitz2D

	' New function to make instant resolution switch work with Max2d - by Krischan
	Function BeginMax2D()
	
		Local x:Int, y:Int, w:Int, h:Int
		GetViewport(x, y, w, h)
		
		glDisable(GL_LIGHTING)
		glDisable(GL_DEPTH_TEST)
		glDisable(GL_SCISSOR_TEST)
		glDisable(GL_FOG)
		glDisable(GL_CULL_FACE)
		
		glMatrixMode GL_TEXTURE
		glLoadIdentity
		
		glMatrixMode GL_PROJECTION
		glLoadIdentity
		glOrtho 0, TGlobal.width[0], TGlobal.height[0], 0, -1, 1
		
		glMatrixMode GL_MODELVIEW
		glLoadIdentity
		
		SetViewport x, y, w, h
		
		Local MaxTex:Int
		glGetIntegerv(GL_MAX_TEXTURE_UNITS, Varptr MaxTex)
		
		For Local Layer:Int = 0 Until MaxTex
			glActiveTexture(GL_TEXTURE0+Layer)
			
			glDisable(GL_TEXTURE_CUBE_MAP)
			glDisable(GL_TEXTURE_GEN_S)
			glDisable(GL_TEXTURE_GEN_T)
			glDisable(GL_TEXTURE_GEN_R)
			
			glDisable(GL_TEXTURE_2D)
		Next
		
		glActiveTexture(GL_TEXTURE0)
		
		glViewport(0, 0, TGlobal.width[0], TGlobal.height[0])
		glScissor(0, 0, TGlobal.width[0], TGlobal.height[0])
		
		glEnable GL_BLEND
		glEnable(GL_TEXTURE_2D)
		
	End Function
	
	' New function to make instant resolution switch work with Max2d - by Krischan
	Function EndMax2D()
	
		glDisable(GL_TEXTURE_CUBE_MAP)
		glDisable(GL_TEXTURE_GEN_S)
		glDisable(GL_TEXTURE_GEN_T)
		glDisable(GL_TEXTURE_GEN_R)
		
		glDisable(GL_TEXTURE_2D)
		glDisable GL_BLEND
		
		TGlobal.EnableStates()
		
		TGlobal.alpha_enable[0] = 0	' alpha blending was disabled by Max2d (GL_BLEND)
		TGlobal.blend_mode[0] = 1	' force alpha blending
		TGlobal.fx1[0] = 0			' full bright/surface normals was enabled by EnableStates (GL_NORMAL_ARRAY)
		TGlobal.fx2[0] = 1			' vertex colors was enabled by EnableStates (GL_COLOR_ARRAY)
		
		glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR)
		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,GL_TRUE)
		
		glClearDepth(1.0)
		glDepthFunc(GL_LEQUAL)
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL, 0.5)
		
		For Local cam:TCamera=EachIn TCamera.cam_list
		
			' active camera - was if cam.hide[0]=0
			If cam = TGlobal.camera_in_use
				cam.UpdateFog() ' fog with Max2d fix
				Exit
			EndIf
			
		Next
		
	End Function
	
	' Old Minib3d Max2d function - by Oddball
	Function BeginMini2D()
	
		glPopClientAttrib()
		glPopAttrib()
		glMatrixMode(GL_MODELVIEW)
		glPopMatrix()
		glMatrixMode(GL_PROJECTION)
		glPopMatrix()
		glMatrixMode(GL_TEXTURE)
		glPopMatrix()
		glMatrixMode(GL_COLOR)
		glPopMatrix()
		
	End Function
	
	' Old Minib3d Max2d function - by Oddball
	Function EndMini2D()
	
		' save the Max2D settings for later
		glPushAttrib(GL_ALL_ATTRIB_BITS)
		glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS)
		glMatrixMode(GL_MODELVIEW)
		glPushMatrix()
		glMatrixMode(GL_PROJECTION)
		glPushMatrix()
		glMatrixMode(GL_TEXTURE)
		glPushMatrix()
		glMatrixMode(GL_COLOR)
		glPushMatrix()
		
		TGlobal.EnableStates() ' enables normals and vertex colors
		glDisable(GL_TEXTURE_2D) ' needed as Draw in Max2d enables it, but doesn't disable after use
		
		' set render state flags (crashes if fx2 is not set)
		TGlobal.alpha_enable[0]=0 ' alpha blending was disabled by Max2d (GL_BLEND)
		TGlobal.blend_mode[0]=1 ' force alpha blending
		TGlobal.fx1[0]=0 ' full bright/surface normals was enabled by EnableStates (GL_NORMAL_ARRAY)
		TGlobal.fx2[0]=1 ' vertex colors was enabled by EnableStates (GL_COLOR_ARRAY)
		
		glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL,GL_SEPARATE_SPECULAR_COLOR)
		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,GL_TRUE)
		
		glClearDepth(1.0)						
		glDepthFunc(GL_LEQUAL)
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
		
		glAlphaFunc(GL_GEQUAL,0.5)
		
		For Local cam:TCamera=EachIn TCamera.cam_list
			If cam=TGlobal.camera_in_use ' active camera - was if cam.hide[0]=0
				cam.UpdateFog() ' fog with Max2d fix
				Exit
			EndIf
		Next
		
	End Function
	
End Type
