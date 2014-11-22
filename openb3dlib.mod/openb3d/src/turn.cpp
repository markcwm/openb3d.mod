class Quaternion{
 
public:
float x,y,z,w;
};
 

Quaternion* EulerToQuat(float pitch,float yaw,float roll){
	float cr=cosdeg(-roll/2.0);
	float cp=cosdeg(pitch/2.0);
	float cy=cosdeg(yaw/2.0);
	float sr=sindeg(-roll/2.0);
	float sp=sindeg(pitch/2.0);
	float sy=sindeg(yaw/2.0);
	float cpcy=cp*cy;
	float spsy=sp*sy;
	float spcy=sp*cy;
	float cpsy=cp*sy;
	Quaternion* q=new Quaternion;
	q->w=cr*cpcy+sr*spsy;
	q->x=sr*cpcy-cr*spsy;
	q->y=cr*spcy+sr*cpsy;
	q->z=cr*cpsy-sr*spcy;
	return q;
}

const float QuatToEulerAccuracy=0.001;
void QuatToEuler2(float x,float y,float z,float w,float &pitch,float& yaw,float& roll){
	float sint=(2.0*w*y)-(2.0*x*z);
	float cost_temp=1.0-(sint*sint);
	float cost;
	if (abs(cost_temp)>QuatToEulerAccuracy){
		cost=sqrt(cost_temp);
	}else{
		cost=0.0;
	}
	float sinv,cosv,sinf,cosf;
	if (abs(cost)>QuatToEulerAccuracy){
		sinv=((2.0*y*z)+(2.0*w*x))/cost;
		cosv=(1.0-(2.0*x*x)-(2.0*y*y))/cost;
		sinf=((2.0*x*y)+(2.0*w*z))/cost;
		cosf=(1.0-(2.0*y*y)-(2.0*z*z))/cost;
	}else{
		sinv=(2.0*w*x)-(2.0*y*z);
		cosv=1.0-(2.0*x*x)-(2.0*z*z);
		sinf=0.0;
		cosf=1.0;
	}
	pitch=atan2deg(sint,cost);
	yaw=atan2deg(sinf,cosf);
	roll=-atan2deg(sinv,cosv);
}

Quaternion* MultiplyQuats(Quaternion* q1,Quaternion* q2){

	Quaternion* q=new Quaternion;
	
	q->w = q1->w*q2->w - q1->x*q2->x - q1->y*q2->y - q1->z*q2->z;
	q->x = q1->w*q2->x + q1->x*q2->w + q1->y*q2->z - q1->z*q2->y;
	q->y = q1->w*q2->y + q1->y*q2->w + q1->z*q2->x - q1->x*q2->z;
	q->z = q1->w*q2->z + q1->z*q2->w + q1->x*q2->y - q1->y*q2->x;

	return q;

}

Quaternion* NormalizeQuat(Quaternion* q){

	float uv=sqrt(q->w*q->w+q->x*q->x+q->y*q->y+q->z*q->z);

	q->w=q->w/uv;
	q->x=q->x/uv;
	q->y=q->y/uv;
	q->z=q->z/uv;

	return q;

}

void EdzUpTurnEntity( Entity* ent, float x, float y, float z, int Glob = false ){
	float Pitch = 0.0;
	float Yaw = 0.0;
	float Roll = 0.0;
	
	Quaternion* Quat = EulerToQuat( 0.0, 0.0, 0.0 );		//create cone quat
	Quaternion* Turn_Quat = EulerToQuat( 0.0, 0.0, 0.0 );	//create turn quat
	
	if (Glob==false){
		Quat = EulerToQuat(ent->EntityPitch(true), ent->EntityYaw(true), ent->EntityRoll(true));	//Set Ent Quat
		Turn_Quat = EulerToQuat( x, y, z );		//Set turn quat
		Quat = MultiplyQuats( Quat, Turn_Quat );	//Multiply Entity quat with turn quat
		Quat = NormalizeQuat( Quat );			//normalise quat
		QuatToEuler2( Quat->x, Quat->y, Quat->z, Quat->w, Pitch, Yaw, Roll );	//Entity quat to euler
		ent->RotateEntity (Pitch, Yaw, Roll);
	}else{
		ent->RotateEntity (ent->EntityPitch()+x, ent->EntityYaw()+y, ent->EntityRoll()+z);
	}
}
