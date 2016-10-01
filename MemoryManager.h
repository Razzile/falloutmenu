//--------------------------------//
//--------Code-Inject-v3----------//
//-------Created-by-Razzile-------//
//--------------------------------//

#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <sys/types.h>
#include <stdio.h>

namespace MemoryManager {
    kern_return_t ReadAddress(long address, unsigned char *outData, size_t size);
    kern_return_t WriteAddress(long address, unsigned char *inData, size_t size);
}
