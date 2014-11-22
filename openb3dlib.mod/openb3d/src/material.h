#ifndef MATERIAL_H
#define MATERIAL_H

class Surface;

class MaterialPlugin{
public:
	int Active;
	virtual void TurnOn(Surface* surf = 0);
	virtual void TurnOff();
	virtual void UpdateData();
							
	void Activate(){
		if (1==1){//(HardwareInfo->ShaderSupport!=0){
			Active = 1;
		}else{
			Active = 0;
		}
	}

	void DeActivate(){
		Active = 0;
	}
};

#endif
