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
