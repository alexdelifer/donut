/*
 * aplib_stub.c — stub implementations of the aPLib API for platforms where
 * lib/aplib64.a (a Linux ELF archive) cannot be linked, such as macOS.
 *
 * Compression (aP_pack / aPsafe_pack) returns APLIB_ERROR so donut reports a
 * compression error when --compress aplib is requested.  All other operations
 * that are needed only on the target (decompression, crc32) return 0.
 *
 * On Linux the real aplib64.a is used and this file is not compiled.
 */

#include "aplib.h"

unsigned int aP_pack(const void *source, void *destination, unsigned int length,
                     void *workmem,
                     int (*callback)(unsigned int, unsigned int, unsigned int, void *),
                     void *cbparam)
{
    (void)source; (void)destination; (void)length;
    (void)workmem; (void)callback; (void)cbparam;
    return APLIB_ERROR;
}

unsigned int aP_workmem_size(unsigned int inputsize)
{
    return inputsize * 4 + 1024;
}

unsigned int aP_max_packed_size(unsigned int inputsize)
{
    return inputsize + (inputsize / 8) + 64;
}

unsigned int aP_depack_asm(const void *source, void *destination)
{
    (void)source; (void)destination;
    return APLIB_ERROR;
}

unsigned int aP_depack_asm_fast(const void *source, void *destination)
{
    (void)source; (void)destination;
    return APLIB_ERROR;
}

unsigned int aP_depack_asm_safe(const void *source, unsigned int srclen,
                                void *destination, unsigned int dstlen)
{
    (void)source; (void)srclen; (void)destination; (void)dstlen;
    return APLIB_ERROR;
}

unsigned int aP_crc32(const void *source, unsigned int length)
{
    (void)source; (void)length;
    return 0;
}

unsigned int aPsafe_pack(const void *source, void *destination, unsigned int length,
                         void *workmem,
                         int (*callback)(unsigned int, unsigned int, unsigned int, void *),
                         void *cbparam)
{
    (void)source; (void)destination; (void)length;
    (void)workmem; (void)callback; (void)cbparam;
    return APLIB_ERROR;
}

unsigned int aPsafe_check(const void *source)
{
    (void)source;
    return APLIB_ERROR;
}

unsigned int aPsafe_get_orig_size(const void *source)
{
    (void)source;
    return APLIB_ERROR;
}

unsigned int aPsafe_depack(const void *source, unsigned int srclen,
                           void *destination, unsigned int dstlen)
{
    (void)source; (void)srclen; (void)destination; (void)dstlen;
    return APLIB_ERROR;
}
