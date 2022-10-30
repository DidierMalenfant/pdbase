// SPDX-FileCopyrightText: 2022-present pdbase contributors
//
// SPDX-License-Identifier: MIT
  
#ifndef DM_PDBASE_H
#define DM_PDBASE_H

#include "pdbase/list.h"
#include "pdbase/memory.h"

#include "pd_api.h"

// -- Globals
extern PlaydateAPI* pd;

// -- Utility macros
#ifndef DM_LOG
    #ifdef DM_LOG_ENABLE
        #define DM_LOG(format, ...)         pd->system->logToConsole((format), ##__VA_ARGS__)
    #else
        #define DM_LOG(format, args...)     do { } while(0)
    #endif
#endif

#ifndef DM_DBG_LOG
    #ifdef DM_DBG_LOG_ENABLE
        #define DM_DBG_LOG              DM_LOG
    #else
        #define DM_DBG_LOG(format, args...) do { } while(0)
    #endif
#endif

// -- toybox registration function
void register_pdbase(PlaydateAPI* playdate);

#endif
