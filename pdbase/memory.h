// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT
  
#ifndef DM_PDBASE_MEMORY_H
#define DM_PDBASE_MEMORY_H

#include <stdlib.h>

void* dmMemoryAlloc(size_t nb_of_items, size_t item_size);
void* dmMemoryCalloc(size_t nb_of_items, size_t item_size);
void* dmMemoryRealloc(void* mem, size_t nb_of_items, size_t item_size);
void* dmMemoryFree(void* mem);
void* dmMemoryCopy(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size);
void* dmMemoryMove(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size);

#endif
