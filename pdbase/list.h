// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT

#ifndef DM_PDBASE_LIST_H
#define DM_PDBASE_LIST_H

#include <stdlib.h>

typedef struct dmList dmList;

extern dmList* dmListCreate(size_t item_size);
extern void dmListFree(dmList* list);
extern void dmListRemoveAllItems(dmList* list);
extern void* dmListGetItem(dmList* list, int i);
extern void dmListAppendItem(dmList* list, void* item);
extern void dmListRemoveItemAt(dmList* list, int i);
extern void* dmListFindItem(dmList* list, int (*find_function)(void* item, int i));
extern int dmListIndexOfItem(dmList* list, void* item);
extern void dmListRemoveItem(dmList* list, void* item);

#endif
