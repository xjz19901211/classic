# Classic

A tiny class module for Lua. Attempts to stay simple and provide decent
performance by avoiding unnecessary over-abstraction.


## Usage

The [module](classic.lua) should be dropped in to an existing project and
required by it:

```lua
Object = require "classic"
```

The module returns the object base class which can be extended to create any
additional classes.


### Creating a new class
```lua
Point = Object:extend()

function Point:init(x, y)
  self.x = x or 0
  self.y = y or 0
end
```

### Creating a new object
```lua
local p = Point.new(10, 20)
```

### Extending an existing class
```lua
Rect = Point:extend()

function Rect:init(x, y, width, height)
  self:super_call('init', x, y)
  self.width = width or 0
  self.height = height or 0
end
```

### Checking an object's type
```lua
local p = Point.new(10, 20)
print(p:is(Object)) -- true
print(p:is(Point)) -- true
print(p:is(Rect)) -- false 
```

### Using mixins
```lua
PairPrinter = Object:extend()

function PairPrinter:printPairs()
  for k, v in pairs(self) do
    print(k, v)
  end
end

Point = Object:extend()
Point:include(PairPrinter)
-- Point:include(class1, class2, ...)

function Point:init(x, y)
  self.x = x or 0
  self.y = y or 0
end


local p = Point.new()
p:printPairs()
```

### Using static variables
```lua
Point = Object:extend()
Point.scale = 2

function Point:init(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Point:getScaled()
  return self.x * Point.scale, self.y * Point.scale
end
```

### Creating a metamethod
```lua
Point = Object:extend('Point')

function Point:__tostring()
  return '<' .. self._class_name .. ' ' .. self.x .. ", " .. self.y .. '>'
end
```


## License

This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.

