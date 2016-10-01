#include "MemoryManager.h"


kern_return_t MemoryManager::ReadAddress(long address, unsigned char *outData, size_t size)
{
    mach_port_t port = mach_task_self();
    address += _dyld_get_image_vmaddr_slide(0);
    vm_size_t sz;
    return vm_read_overwrite(port, address, size, (vm_address_t)outData, &sz);
}

kern_return_t MemoryManager::WriteAddress(long address, unsigned char *inData, size_t size)
{
    kern_return_t status;
    mach_port_t port = mach_task_self();
    address += _dyld_get_image_vmaddr_slide(0);

    /* set memory protections to allow us writing code there */
    status = vm_protect(port, address, size, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);

    /* check if the protection fails */
    if (status != KERN_SUCCESS) return status;

    /* write code to memory */
	status = vm_write(port, address, (vm_address_t)inData, size);
    if (status != KERN_SUCCESS) return status;

    return vm_protect(port, (vm_address_t)address, size, false, VM_PROT_READ | VM_PROT_EXECUTE);
}
