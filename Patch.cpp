//--------------------------------//
//--------Code-Inject-v3----------//
//-------Created-by-Razzile-------//
//--------------------------------//

#include "Patch.h"

using namespace MemoryManager;

#pragma mark Patch

Patch::Patch(long long addr, uint data) : patchAddr(addr)
{
	if (!(((data & 0xffff8000) + 0x8000) & 0xffff7fff)) {
		data = (unsigned short)_OSSwapInt16(data);
		this->patchSize = sizeof(unsigned short);
	}
	else {
		data = _OSSwapInt32(data);
		this->patchSize = sizeof(int);
	}
	this->patchData = new unsigned char[patchSize];
	this->origData = new unsigned char[patchSize];

	memcpy(patchData, &data, patchSize); // memcpy reverses endian?
	/* read in original data */
	ReadAddress(addr, origData, patchSize);
}

Patch::Patch(long long addr, std::string data) : patchAddr(addr)
{
	/* remove all blank spaces */
	std::string::iterator end_pos = std::remove(data.begin(), data.end(), ' ');
	data.erase(end_pos, data.end());
	std::cout << data << std::endl;
	const char *tempHex = data.c_str();

	this->patchSize = data.length()/2;

	this->patchData = new unsigned char[patchSize];
	this->origData = new unsigned char[patchSize];

	/* convert string to hex array */
	int n;
	for(int i = 0; i < patchSize; i++) {
		sscanf(tempHex+2*i, "%2X", &n);
		patchData[i] = (unsigned char)n;
	}
	/* read in original data */
	ReadAddress(addr, origData, patchSize);
}


Patch::~Patch()
{
	delete patchData;
	delete origData;
}

bool Patch::Apply()
{
	printf("patch size %d\n", patchSize);
	for (int i = 0; i < patchSize; i++) {
		printf("%02x:", patchData[i]);
	}
	printf("\n");
	return WriteAddress(patchAddr, patchData, patchSize);
}

bool Patch::Reset()
{
	return WriteAddress(patchAddr, origData, patchSize);
}

#pragma mark Hook

Hook::Hook(std::string symbol, void *hookPtr, void **origPtr)
: symbol(symbol), hookPtr(hookPtr), origPtr(origPtr)
{
	// 16 bytes is probably enough to cover MSHookFunction
	this->patchSize = 16;
	this->origData = new unsigned char[patchSize];
	this->hookFuncAddr = MSFindSymbol(NULL, symbol.c_str());

	ReadAddress((long long)hookFuncAddr, origData, patchSize);
}

Hook::Hook(std::string symbol, void *hookPtr) : Hook(symbol, hookPtr, NULL)
{

}

Hook::Hook(void *funcPtr, void *hookPtr, void **origPtr)
: symbol(""), hookPtr(hookPtr), origPtr(origPtr)
{
	this->patchSize = 16;
	this->origData = new unsigned char[patchSize];
	this->hookFuncAddr = (void*)(_dyld_get_image_vmaddr_slide(0) + (long long)funcPtr);

	ReadAddress((long long)hookFuncAddr, origData, patchSize);
}

Hook::Hook(void *funcPtr, void *hookPtr) : Hook(funcPtr, hookPtr, NULL)
{

}

Hook::~Hook()
{
	delete origData;
}

bool Hook::Apply()
{
	MSHookFunction(hookFuncAddr, hookPtr, origPtr);
	return true;
}

bool Hook::Reset()
{
	return WriteAddress((long long)hookFuncAddr, origData, patchSize);
}
