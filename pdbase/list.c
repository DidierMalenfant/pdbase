// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT

#define DM_LOG_ENABLE
#include "pdbase/pdbase.h"

typedef struct dmList {
    int count;
    size_t item_size;
    void* first;
} dmList;

dmList* dmListCreate(size_t item_size)
{
    dmList* list = (dmList*)dmMemoryCalloc(1, sizeof(dmList));

    list->item_size = item_size;
    
    DM_LOG("List: creating with item size %i", list->item_size);

    return list;
}

void dmListFree(dmList* list)
{
    if(list->first != NULL) {
        dmMemoryFree(list->first);
    }
    
    dmMemoryFree(list);
}
  
void* dmListGetItem(dmList* list, int i)
{
    if(i >= list->count) {
        DM_LOG("List: attempt to fetch item outside of bounds");
        return NULL;
    }
    
    return list->first + (list->item_size * i);
}

void dmListRemoveAllItems(dmList* list)
{
    list->count = 0;

    if(list->first != NULL) {
        dmMemoryFree(list->first);
        list->first = NULL;
    }
}

void dmListRemoveItem(dmList* list, void* item)
{
    int i = dmListIndexOfItem(list, item);
    if(i != -1) {
        dmListRemoveItemAt(list, i);
    }
    else {
        DM_LOG("List: couldnt find item %p", item);
    }
}

void dmListAppendItem(dmList* list, void* item)
{
    if(item == NULL) {
        DM_LOG("List: attempt to store NULL item");
        return;
    }
  
    ++(list->count);
    
    if(list->first == NULL) {
        list->first = dmMemoryCalloc(1, list->item_size);
    }
    else {
        list->first = dmMemoryRealloc(list->first, list->count, list->item_size);
    }
    
    dmMemoryCopy(item, 0, list->first, list->count - 1, 1, list->item_size);
}
  
void dmListRemoveItemAt(dmList* list, int i)
{
    if(list->first == NULL || list->count == 0) {
        DM_LOG("List: erase item in empty list");
        return;
    }
    
    if(i >= list->count) {
        DM_LOG("List: attempt to erase item outside of bounds");
        return;
    }
    
    if(i < 0) {
        DM_LOG("List: attempt to erase item at negative index");
        return;
    }
    
    int items_to_move = list->count - (i + 1);
    
    --(list->count);
    
    if(items_to_move > 0) {
        dmMemoryMove(list->first, (i + 1), list->first, i, items_to_move, list->item_size);
    }
    
    if(list->count == 0) {
        dmMemoryFree(list->first);
        list->first = NULL;
    }
    else {
        list->first = dmMemoryRealloc(list->first, list->count, list->item_size);
    }
}
  
void* dmListFindItem(dmList* list, int (*find_function)(void* item, int i))
{
    for(int i = 0; i < list->count; i++) {
        void* item = dmListGetItem(list, i);
        if(find_function(item, i) > 0) {
            return item;
        }
    }

    return NULL;
}

int dmListIndexOfItem(dmList* list, void* item)
{
    char first_byte = *(char*)item;

    for(int i = 0; i < list->count; i++) {
        void* found_item = dmListGetItem(list, i);
        
        // -- Quickly compare first byte
        if((*(char*)found_item) == first_byte) {
            if(memcmp(found_item, item, list->item_size) == 0) {
                return i;
            }
        }
    }

    return -1;
}
