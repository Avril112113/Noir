--------------------------------------------------------
-- [Noir] Class
--------------------------------------------------------

--[[
    ----------------------------

    CREDIT:
        Author: @Cuh4 (GitHub)
        GitHub Repository: https://github.com/cuhHub/NoirFramework

    License:
        Copyright (C) 2024 Cuh4

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------

--[[
    Create a class that objects can be created from.

    local MyClass = Class:Create("MyClass")

    function MyClass:init(name) -- This is called when MyClass.new() is called
        self.name = name
    end

    function MyClass:myName()
        print(self.name)
    end

    local object = MyClass.new("Cuh4")
    object:myName() -- "Cuh4"
]]
local Class = Noir.Libraries:Create("Class")

--[[
    Create a class that objects can be created from.

    local MyClass = Class:Create("MyClass")

    function MyClass:init(name) -- This is called when MyClass.new() is called
        self.name = name
    end

    function MyClass:myName()
        print(self.name)
    end

    local object = MyClass.new("Cuh4")
    object:myName() -- "Cuh4"
]]
---@param name string
---@param parent NoirLib_Class|nil
function Class:Create(name, parent)
    -- // Class Creation
    -- Create a class
    ---@type NoirLib_Class
    local class = {} ---@diagnostic disable-line
    class.__name = name
    class.__parent = parent

    function class:New(...)
        -- create object
        ---@type NoirLib_ClassObject
        local object = {}
        self:__descend(object, {New = true, Init = true, __descend = true})

        -- call init of object. this init function will provide the needed attributes to the object
        if self.Init then
            self.Init(object, ...)
        end

        -- return the object
        return object
    end

    function class.__descend(from, object, exceptions)
        for index, value in pairs(from) do
            if exceptions[index] then
                goto continue
            end

            if object[index] then
                goto continue
            end

            object[index] = value

            ::continue::
        end
    end

    function class:InitializeParent(...)
        if not self.__parent then
            return
        end

        local object = self.__parent:New(...)
        self.__descend(object, self, {})
    end

    function class:IsSameType(object)
        return object.__name and self.__name == object.__name
    end

    return class
end

Noir.Libraries.Class = Class

-------------------------------
-- // Intellisense
-------------------------------

---@class NoirLib_Class
---@field __name string The name of this class
---@field __parent NoirLib_Class|nil The parent class that this class inherits from
---@field Init fun(self: NoirLib_ClassObject, ...) A function that initializes objects created from this class
---
---@field New fun(self: NoirLib_Class, ...: any): NoirLib_ClassObject A method to create an object from this class
---@field __descend fun(from: NoirLib_Class|NoirLib_ClassObject, object: NoirLib_ClassObject, exceptions: table<any, boolean>) A helper function that copies important values from the class to an object
---@field InitializeParent fun(self: NoirLib_ClassObject, ...: any) A method that initializes the parent class for this object
---@field IsSameType fun(self: NoirLib_ClassObject, object: NoirLib_ClassObject): boolean A method that returns whether an object is identical to this one

---@class NoirLib_ClassObject: NoirLib_Class An object created from a class