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
