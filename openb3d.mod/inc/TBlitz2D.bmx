
Rem
bbdoc: Blitz2D
EndRem
Type TBlitz2D
	
	Function BeginMax2D() ' Function by Oddball
	
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
	
	Function EndMax2D() ' Function by Oddball
	
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
