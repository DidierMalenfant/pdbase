// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT
  
#ifndef DIDIERMALENFANT_PDBASE_H
#define DIDIERMALENFANT_PDBASE_H

#include "pd_api.h"

// -- Globals
extern PlaydateAPI* pd;

// -- Utility macros
#ifndef PDBASE_ALLOC
    #define PDBASE_ALLOC(size)           pd->system->realloc(NULL, (size))
#endif

#ifndef PDBASE_FREE
    #define PDBASE_FREE(mem)             pd->system->realloc((mem), 0)
#endif

#ifndef PDBASE_LOG
    #ifdef PDBASE_LOG_ENABLE
        #define PDBASE_LOG(format, ...)         pd->system->logToConsole((format), ##__VA_ARGS__)
    #else
        #define PDBASE_LOG(format, args...)     do { } while(0)
    #endif
#endif

#ifndef PDBASE_DBG_LOG
    #ifdef PDBASE_DBG_LOG_ENABLE
        #define PDBASE_DBG_LOG                  PDBASE_LOG
    #else
        #define PDBASE_DBG_LOG(format, args...) do { } while(0)
    #endif
#endif

// -- toybox registration function
void register_pdbase(PlaydateAPI* playdate);

// -- Utility functions
void* pd_calloc(size_t nb_of_items, size_t item_size);

#endif
