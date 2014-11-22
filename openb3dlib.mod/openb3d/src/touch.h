/*
 *  touch.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef TOUCH_H
#define TOUCH_H

#include <iostream>
#include <vector>
using namespace std;

class Touch{

public:

	//static int no_touches;
	static vector<Touch*> touch_list; // includes active touches only
	static vector<Touch*> all_touch_list; // includes active and 'dead' touches - i.e. recently removed and cancelled touches

	float x,y;
	float old_x,old_y;
	int type;
	int hit;

	Touch(int xx,int yy,int old_xx,int old_yy,int touch_type){

		old_x=old_xx;
		old_y=old_yy;
		x=xx;
		y=yy;
		type=touch_type;
		if(type==1) hit=true; else hit=false;

		if(type>=1 && type<=3) touch_list.push_back(this); // only add begin, stationary and move touches

		all_touch_list.push_back(this); // add all touches, including dead touches end and cancel

	};

	static void ClearTouches(){

		vector<Touch*>::iterator it;

		for(it=touch_list.begin();it!=touch_list.end();it++){

			Touch* touch=*it;
			delete touch;

		}

		touch_list.clear();
		all_touch_list.clear();

	}

	static int CountTouches(){

		return touch_list.size();

	}

	static int CountAllTouches(){ // includes dead touches

		return all_touch_list.size();

	}

	// returns touch type
	// 1=began
	// 2=moving
	// 3=stationary
	// 4=ended
	// 5=cancelled
	static int TouchType(int touch_no,int all=false){

		if(!all){
			return touch_list[touch_no]->type;
		}else{
			return all_touch_list[touch_no]->type;
		}

	}

	static int TouchX(int touch_no,int all=false){

		if(!all){
			return touch_list[touch_no]->x;
		}else{
			return all_touch_list[touch_no]->x;
		}

	}

	static int TouchY(int touch_no,int all=false){

		if(!all){
			return touch_list[touch_no]->y;
		}else{
			return all_touch_list[touch_no]->y;
		}

	}

	static int TouchXPrev(int touch_no,int all=false){

		if(!all){
			return touch_list[touch_no]->old_x;
		}else{
			return all_touch_list[touch_no]->old_x;
		}

	}

	static int TouchYPrev(int touch_no,int all=false){

		if(!all){
			return touch_list[touch_no]->old_y;
		}else{
			return all_touch_list[touch_no]->old_y;
		}

	}

	static int TouchXSpeed(int touch_no){

		return touch_list[touch_no]->x-touch_list[touch_no]->old_x;

	}

	static int TouchYSpeed(int touch_no){

		return touch_list[touch_no]->y-touch_list[touch_no]->old_y;

	}

	// returns x speed of all touches since last time
	static int TouchesXSpeed(){

		int swipe_x=0;

		for( unsigned int i=0;i<touch_list.size();i++){

			swipe_x=swipe_x+(touch_list[i]->x-touch_list[i]->old_x);

		}

		return swipe_x;

	}

	// returns y speed of all touches since last time
	static int TouchesYSpeed(){

		int swipe_y=0;

		for(unsigned int i=0;i<touch_list.size();i++){

			swipe_y=swipe_y+(touch_list[i]->y-touch_list[i]->old_y);

		}

		return swipe_y;

	}

	static int TouchHit(int touch_no,int all=false){

		if(!all){
			int hit=touch_list[touch_no]->hit;
			touch_list[touch_no]->hit=false;
			return hit;
		}else{
			int hit=all_touch_list[touch_no]->hit;
			all_touch_list[touch_no]->hit=false;
			return hit;
		}

	}

	 // returns true if any touch
	static int TouchesDown(){

		return touch_list.size();

	}

	// returns true if any touch hits after no touches last time
	static int TouchesHit(){

		static int down=false;

		if(touch_list.size()>0){

			if(down==false){
				down=true;
				return true;
			}
		}

		if(touch_list.size()==0){

			down=false;
			return false;

		}

		return false;

	}

	// returns true if no touches after a touch last time
	static int TouchesRelease(){

		static int down=false;

		if(touch_list.size()==0){

			if(down==true){
				down=false;
				return true;
			}

		}

		if(touch_list.size()>0){

			down=true;
			return false;

		}

		return false;

	}

};

#endif
