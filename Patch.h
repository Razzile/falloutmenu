//--------------------------------//
//--------Code-Inject-v3----------//
//-------Created-by-Razzile-------//
//--------------------------------//
#include <string>
#include <iostream>
#include <sstream>
#include <sys/types.h>
#include <substrate.h>
#include "MemoryManager.h"

class Patch {
public:
	Patch(long long addr, uint data);
	Patch(long long addr, std::string data);

	~Patch();

	bool Apply();
	bool Reset();

private:
	long long patchAddr;
	unsigned char *patchData;
	unsigned char *origData;
	int patchSize;
};

class Hook {
public:
	Hook(std::string symbol, void *hookPtr, void **origPtr);
	Hook(std::string symbol, void *hookPtr);
	Hook(void *hookFuncAddr, void *hookPtr, void **origPtr);
	Hook(void *hookFuncAddr, void *hookPtr);

	~Hook();
	bool Apply();
	bool Reset();
private:
	std::string symbol;
	void *hookPtr;
	void **origPtr;
	void *hookFuncAddr;
	unsigned char *origData;
	int patchSize;
};
