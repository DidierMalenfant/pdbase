// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT
  
#include "pdbase/pdbase.h"

// -- Globals
PlaydateAPI* pd = NULL;

// -- toybox registration function
void register_pdbase(PlaydateAPI* playdate)
{
    pd = playdate;
}

// -- Utility functions
void* pd_calloc(size_t nb_of_items, size_t item_size)
{
    if (item_size && (nb_of_items > (SIZE_MAX / item_size))) {
        return NULL;
    }

    size_t size = nb_of_items * item_size;
    void* memory = PDBASE_ALLOC(size);
    if(memory != NULL) {
        memset(memory, 0, size);
    }
    
    return memory;
}
