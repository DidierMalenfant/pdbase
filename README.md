# pdbase for Playdate

![](https://img.shields.io/github/license/DidierMalenfant/pdbase) ![](https://img.shields.io/badge/Lua-5.4-yellowgreen) ![](https://img.shields.io/badge/toybox.py-compatible-brightgreen) ![](https://img.shields.io/github/v/tag/DidierMalenfant/pdbase)

**pdbase** is a [**Playdate**](https://play.date) **toybox** which provides handy utility functions and SDK additions.

You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add DidierMalenfant/pdbase
```

This **toybox** contains both **Lua** and **C** toys for you to play with.

---

### filepath (Lua)

The `filepath` module contains functions allowing you to parse and modify file paths and filenames.

##### `pdbase.filepath.filename(path)`

Extracts the filename from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `Myfile.txt`.

##### `pdbase.filepath.extension(path)`

Extracts the extension from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `txt`.

##### `pdbase.filepath.directory(path)`

Extracts the directory from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `Folder1/Folder2`.

##### `pdbase.filepath.basename(path)`

Extracts the basename from `path` and returns it as a string. For example, if path is `Folder1/Folder2/MyFile.txt` then the returned value will be `MyFile`.

##### `pdbase.filepath.join(path1, path2)`

Joins two paths together and returns the result as a string. For example, if paths are `Test1` and `Test2`  then returned value will be `Test1/Test2`,

### math (Lua)

The `math` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier) and [Nick Splendorr](https://twitter.com/nosplendorr).

##### `math.clamp(a, min, max)`

Clamps the value `a` to a minimum of `min` and a maximum of `max`.

##### `math.ring(a, min, max) / math.ring_int(a, min, max)`

Like clamp but instead of clamping it loop back to the start. Useful to cycle through values, for example an index in a menu.

##### `math.approach(value, target, step)`

Every time the function is called, `value` is incremented by `step` until it reaches a maximum of `target`. Returns the incremented result. Taken from [Celeste](https://github.com/NoelFB/Celeste/tree/master/Source/Player).

##### `math.infinite_approach(at_zero, at_infinite, x_halfway, x)`

An approach function which never reaches the target. `at_zero` is the lowest value possible, `at_infinite` the highest. `x_halfway` specifiess at which point you are midway and the rest is a nice natural curve. Returns the incremented result.

So for example if you want to generate new enemies that get trickier as the playtime progress. The first enemies start with just 1 health, and eventually enemies can go up to 20. We can balance that we start to see enemies with 10 health after 5 minutes.

```lua
new_enemy.health = math.infinite_approach(1, 20, 5*60, playtime_in_seconds)
```

##### `math.round(v, bracket)`

Rounds `v` to the number of places in `bracket`, i.e. 0.01, 0.1, 1, 10, etc... Taken from http://lua-users.org/wiki/SimpleRound

##### `math.sign(v)`

Returns -1 if `v` is negative and 1 otherwise.

### table (Lua)

The `table` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier) and [Matt Sephton](https://twitter.com/gingerbeardman).

##### `table.random(t)`

Returns a random element from table `t`.

##### `table.each(t, funct)`

Applies function `funct` to all the elements of table `t`.

##### `table.newAutotable(dim)`

Save you from managing the dimensions and initialisation when using tables as multi-dimensional arrays in **Lua**.

```
local at = newAutotable(3);
print(at[0]) -- returns table
print(at[0][1]) -- returns table
print(at[0][1][2]) -- returns nil
at[0][1][2] = 2;
print(at[0][1][2]) -- returns value
print(at[0][1][3][3]) -- error, because only 3 dimensions set
```

Taken from https://stackoverflow.com/a/21287623/28290

### utils (Lua)

The `utils` module extends the **Playdate SDK** with some extra functions. Some code in this module is based on code originally written by [Nic Magnier](https://twitter.com/NicMagnier).

##### `enum(t)`

`enum` provides an implementation of a **C** like enumeration.

```lua
layers = enum({
    'background',
    'enemies',
    'player',
    'clouds'
})

...

sprite:setZIndex(layer.player)
```

### Globals (C)

##### `PlaydateAPI* pd`

Shortcut used to call Playdate API methods (for example `pd->system->logToConsole()`).

### Memory Allocation (C)

##### `PDBASE_ALLOC(size)`

Allocate memory of the given `size`. Returns `NULL` if allocation fails.

##### `void* pd_calloc(size_t nb_of_items, size_t item_size)`

Allocates and sets to 0 memory for `nb_of_items` items, each of size `size`. This is safer that using `PDBASE_ALLOC(nb_of_items * item_size)` because it shields you from any overrun caused by the multiplication.

##### `PDBASE_FREE(mem)`

Free memory at `mem`.

##### `PDBASE_LOG(format)`

Print log message to the console. This macro is disabled unless `PDBASE_LOG_ENABLE` is defined before including the `pdbase.h` header:

```c
#define PDBASE_LOG_ENABLE
#include <pdbase/pdbase.h>
```

### Debugging (C)

##### `PDBASE_DBG_LOG(format)`

Print debug log message to the console. This macro is also disabled unless `PDBASE_DBG_LOG_ENABLE` and `PDBASE_LOG_ENABLE` are defined before including the `pdbase.h` header. Therefore it can be enabled/disabled separately from `PDBASE_LOG`:

```c
#define PDBASE_LOG_ENABLE
#define PDBASE_DBG_LOG_ENABLE
#include <pdbase/pdbase.h>
```

## License

`pdbase` is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.
