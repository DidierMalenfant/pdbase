# pdbase for Playdate

[![MIT License](https://img.shields.io/github/license/DidierMalenfant/pdbase)](https://spdx.org/licenses/MIT.html) [![Lua Version](https://img.shields.io/badge/Lua-5.4-yellowgreen)](https://lua.org) [![Toybox Compatible](https://img.shields.io/badge/toybox.py-compatible-brightgreen)](https://toyboxpy.io) [![Latest Version](https://img.shields.io/github/v/tag/DidierMalenfant/pdbase)](https://github.com/DidierMalenfant/pdbase/tags)

**pdbase** is a [**Playdate**](https://play.date) **toybox** which provides handy utility functions and SDK additions.

You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add DidierMalenfant/pdbase
toybox update
```

Then, if your code is in the `source` folder, just import the following:

```lua
import '../toyboxes/toyboxes.lua'
```

This **toybox** contains both **Lua** and **C** toys for you to play with. If you want to also use the **C** toys, you will have to also add `toyboxes/toybox.mk` to your makefile.

---

### filepath (Lua)

The `filepath` module contains functions allowing you to parse and modify file paths and filenames.

##### `dm.filepath.filename(path)`

Extracts the filename from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `Myfile.txt`.

##### `dm.filepath.extension(path)`

Extracts the extension from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `txt`.

##### `dm.filepath.directory(path)`

Extracts the directory from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `Folder1/Folder2`.

##### `dm.filepath.basename(path)`

Extracts the basename from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `MyFile`.

##### `dm.filepath.join(path1, path2)`

Joins two paths together and returns the result as a string. For example, if paths are `Test1` and `Test2`  then returned value will be `Test1/Test2`,

### math (Lua)

The `math` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier) and [Nick Splendorr](https://twitter.com/nosplendorr).

##### `dm.math.clamp(a, min, max)`

Clamps the value `a` to a minimum of `min` and a maximum of `max`.

##### `dm.math.ring(a, min, max) / dm.math.ring_int(a, min, max)`

Like clamp but instead of clamping it loop back to the start. Useful to cycle through values, for example an index in a menu.

##### `dm.math.approach(value, target, step)`

Every time the function is called, `value` is incremented by `step` until it reaches a maximum of `target`. Returns the incremented result. Taken from [Celeste](https://github.com/NoelFB/Celeste/tree/master/Source/Player).

##### `dm.math.infinite_approach(at_zero, at_infinite, x_halfway, x)`

An approach function which never reaches the target. `at_zero` is the lowest value possible, `at_infinite` the highest. `x_halfway` specifiess at which point you are midway and the rest is a nice natural curve. Returns the incremented result.

So for example if you want to generate new enemies that get trickier as the playtime progress. The first enemies start with just 1 health, and eventually enemies can go up to 20. We can balance that we start to see enemies with 10 health after 5 minutes.

```lua
new_enemy.health = dm.math.infinite_approach(1, 20, 5*60, playtime_in_seconds)
```

##### `dm.math.round(v, bracket)`

Rounds `v` to the number of places in `bracket`, i.e. 0.01, 0.1, 1, 10, etc... Taken from http://lua-users.org/wiki/SimpleRound

##### `dm.math.sign(v)`

Returns -1 if `v` is negative and 1 otherwise.

### table (Lua)

The `table` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier) and [Matt Sephton](https://twitter.com/gingerbeardman).

##### `dm.table.count(t)`

Returns the number of elements in table `t`. Unlike `#`, this works whether the table is ordered or not.

##### `dm.table.random(t)`

Returns a random element from table `t`.

##### `dm.table.each(t, funct)`

Applies function `funct` to all the elements of table `t`.

##### `dm.table.newAutotable(dim)`

Save you from managing the dimensions and initialisation when using tables as multi-dimensional arrays in **Lua**.

```
local at = dm.table.newAutotable(3);
print(at[0]) -- returns table
print(at[0][1]) -- returns table
print(at[0][1][2]) -- returns nil
at[0][1][2] = 2;
print(at[0][1][2]) -- returns value
print(at[0][1][3][3]) -- error, because only 3 dimensions set
```

Taken from https://stackoverflow.com/a/21287623/28290

##### `dm.table.filter(t, filterFunction)`

Filters the table `t` by applying the filter function `filterFunction`.

```
local table = [ 1, 2, 3, 4, 5]
local result = dm.table.filter(100, function(value)
   return value < 3
end)
```

### enum (Lua)

The `enum` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier).

##### `dm.enum(t)`

`enum` provides an implementation of a **C** like enumeration.

```lua
layers = dm.enum({
    'background',
    'enemies',
    'player',
    'clouds'
})

...

sprite:setZIndex(layer.player)
```

### Sampler (Lua)

Graphs samples collected/frame against a specified sample duration. Originally written by [Dustin Mierau](https://twitter.com/dmierau).

```
local mem_sampler = dm.Sampler(100, function()
   return collectgarbage("count")
end)

function playdate.update()
   mem_sampler:draw(10, 10, 50, 30)
end
```

##### `dm.Sampler(sample_period, sampler_fn)`

Creates a new sampler object given a `sample_period` in milliseconds and and function whitch should return an integer.

##### `dm.Sampler:reset()`

Reset the sampler.

##### `dm.Sampler:print()`

Print the current sampler date to the console.

##### `dm.Sampler:draw(x, y, width, height)`

Draw the sample data at `x`, `y` with a size of `width` and `height`. This needs to be called from your `playdate.update()` method.

### debug (Lua)

##### `dm.debug.drawText(text, x, y, duration)`

Draw a the `text` on the screen at `x`, `y` coordinates. If `duration` is specified then this will automatically stay on the screen for that number of frames.

This method will backup and restore any graphic states it uses to draw the text, therefore can be used anywhere in your code without disrupting your project. It uses the current font and clears the background with a rectangle before drawing the text to make sure it it legible. Definitely not something to use in production code.

This function depends on **Plupdate**. Make sure you [read about](https://github.com/DidierMalenfant/Plupdate#changes-in-your-code) what this means for your code and its `playdate.update()` callback.

##### `dm.debug.setTextBackgroundColor(color)`

Set the background color used to clear the background behind debug text to `color`.

##### `dm.debug.memoryCheck(prefix)`

First time this is called, it records the current memory situation and prints this information to the console. Subsequent times will display the change since that first call. Can be used for tracking memory leaks and usage. If `prefix` is provided then this is used in the message looged to the console (can be used to identify separate calls in your code).

### Globals (C)

##### `PlaydateAPI* pd`

Shortcut used to call Playdate API methods (for example `pd->system->logToConsole()`).

### Memory Allocation (C)

Some code in this module is based on code originally written by [Matt Sephton](https://twitter.com/gingerbeardman).

##### `void* dmMemoryAlloc(size_t nb_of_items, size_t item_size)`

Allocate memory for `nb_of_items` of the given `item_size` each. Returns `NULL` if allocation fails.

##### `void* dmMemoryCalloc(size_t nb_of_items, size_t item_size)`

Allocates and sets to 0 memory for `nb_of_items` of the given `item_size` each. Returns `NULL` if allocation fails.

##### `void* dmMemoryRealloc(void* mem, size_t nb_of_items, size_t item_size)`

Reallocates memory at `mem` for `nb_of_items` of the given `item_size` each. Returns `NULL` if allocation fails.

##### `void* dmMemoryFree(void* mem)`

Free memory at `mem`.

##### `void* dmMemoryCopy(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size)`

Copies `nb_of_items` from the `src_index` item of size `item_size` starting at `src` to the `dest_index` item starting at dest. Source and destination **cannot** overlap.

##### `void* dmMemoryMove(void* src, size_t src_index, void* dest, size_t dest_index, size_t nb_of_items, size_t item_size)`

Moves `nb_of_items` from the `src_index` item of size `item_size` starting at `src` to the `dest_index` item starting at dest.

### List (C)

##### `dmList* dmListCreate(size_t item_size)`

Create a list of items with each a size of `item_size`. Returns a pointer to the new list or NULL if failed.

##### `void dmListFree(dmList* list)`

Free `list`.

##### `void dmListRemoveAllItems(dmList* list)`

Remove all items from `list`.

##### `void* dmListGetItem(dmList* list, int i)`

Get item at index `i` from `list`.

##### `void dmListAppendItem(dmList* list, void* item)`

Append `item` to `list`,

##### `void dmListRemoveItemAt(dmList* list, int i)`

Remove item at index `i` from `list`.

##### `void* dmListFindItem(dmList* list, int (*find_function)(void* item, int i))`

Finds item in `list` by using the provided `find_function`. `find_function` should return 1 if found, 0 otherwise. Returns the item if found or NULL otherwise.

##### `int dmListIndexOfItem(dmList* list, void* item)`

Returns the index of `item` in `list` found, otherwise return -1.

##### `void dmListRemoveItem(dmList* list, void* item)`

Remove `item`, if found, from `list`.

### Debugging (C)

##### `DM_LOG(format)`

Print log message to the console. This macro is disabled unless `DM_LOG_ENABLE` is defined before including the `pdbase.h` header:

```c
#define DM_LOG_ENABLE
#include <pdbase/pdbase.h>
```

##### `PDBASE_DBG_LOG(format)`

Print debug log message to the console. This macro is also disabled unless `DM_DBG_LOG_ENABLE` and `DM_LOG_ENABLE` are defined before including the `pdbase.h` header. Therefore it can be enabled/disabled separately from `DM_LOG`:

```c
#define DM_LOG_ENABLE
#define DM_DBG_LOG_ENABLE
#include <pdbase/pdbase.h>
```

## License

**pdbase** is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.
