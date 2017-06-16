#ifndef BANK_H
#define BANK_H

/*
 *  bank.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */


#include <cstring>
//using namespace std;
#include <cstdlib>


class Bank{

public:

	Bank(){};

	void* buffer;
	int size;

	static Bank* CreateBank(int size){

		Bank* bank=new Bank;
		bank->buffer=(void*)malloc(size);

		bank->size=size;

		return bank;

	}

	static void CopyBank(Bank* src_bank,int src_offset,Bank* des_bank,int des_offset,int count){

		std::memmove((char*)des_bank->buffer+des_offset,(char*)src_bank->buffer+src_offset,count);

	}

	void FreeBank(){

		free(buffer);
		delete this;
		return;

	}

	void ResizeBank(int size){

		buffer=(void*)realloc(buffer,size);

		size=size;

	}

	int BankSize(){

		return size;

	}

	void PokeByte(int offset,char c){

		if(offset>=0 && offset<size){

		((char*)buffer+offset)[0]=c;

		}

		return;

	}

	void PokeShort(int offset,short s){

		if(offset>=0 && offset<size-1){

		((short*)buffer+offset)[0]=s;

		}

		return;

	}

	void PokeInt(int offset,int i){

		if(offset>=0 && offset<size-3){

		((int*)buffer+offset/4)[0]=i;

		}

		return;

	}

	void PokeFloat(int offset,float f){

		if(offset>=0 && offset<size-3){

		((float*)buffer+offset/4)[0]=f;

		}

		return;

	}

	char PeekByte(int offset){

		if(offset>=0 && offset<size){

		return ((char*)buffer+offset)[0];

		}

		return 0;

	}

	short PeekShort(int offset){

		if(offset>=0 && offset<size-1){

		return ((short*)buffer+offset)[0];

		}

		return 0;

	}

	int PeekInt(int offset){

		if(offset>=0 && offset<size-3){

		return ((int*)buffer+offset/4)[0];

		}

		return 0;

	}

	float PeekFloat(int offset){

		if(offset>=0 && offset<size-3){

		return ((float*)buffer+offset/4)[0];

		}

		return 0;

	}

};

#endif
