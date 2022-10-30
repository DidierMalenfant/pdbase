// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT
  
#include "pdbase/pdbase.h"

static size_t _calculate_size(size_t nb_of_items, size_t item_size)
{
    if (item_size && (nb_of_items > (SIZE_MAX / item_size))) {
        return 0;
    }
    
    return nb_of_items * item_size;
}

void* dmMemoryAlloc(size_t nb_of_items, size_t item_size)
{
    size_t size = _calculate_size(nb_of_items, item_size);
    if (size == 0) {
        return NULL;
    }
    
    return pd->system->realloc(NULL, size);
}

void* dmMemoryCalloc(size_t nb_of_items, size_t item_size)
{
    size_t size = _calculate_size(nb_of_items, item_size);
    if (size == 0) {
        return NULL;
    }
    
    void* memory = pd->system->realloc(NULL, size);
    if(memory != NULL) {        
        memset(memory, 0, size);
    }
    
    return memory;
}

void* dmMemoryRealloc(void* mem, size_t nb_of_items, size_t item_size)
{
    size_t size = _calculate_size(nb_of_items, item_size);
    if (size == 0) {
        return NULL;
    }

    return pd->system->realloc(mem, size);
}

void* dmMemoryFree(void* mem)
{
    return pd->system->realloc(mem, 0);
}

void* dmMemoryCopy(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size)
{
    size_t size = _calculate_size(nb_of_items, item_size);
    if (size == 0) {
        return NULL;
    }

    size_t src_offset = _calculate_size(src_index, item_size);
    if (src_offset == 0) {
        return NULL;
    }
    
    src += src_offset;
    
    size_t dest_offset = _calculate_size(dest_index, item_size);
    if (dest_offset == 0) {
        return NULL;
    }

    dest += dest_offset;
        
    return memcpy(dest, src, size);
}

void* dmMemoryMove(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size)
{
    size_t size = _calculate_size(nb_of_items, item_size);
    if (size == 0) {
        return NULL;
    }

    size_t src_offset = _calculate_size(src_index, item_size);
    if (src_offset == 0) {
        return NULL;
    }
    
    src += src_offset;
    
    size_t dest_offset = _calculate_size(dest_index, item_size);
    if (dest_offset == 0) {
        return NULL;
    }

    dest += dest_offset;
        
    return memmove(dest, src, size);
}
