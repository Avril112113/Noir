--------------------------------------------------------
-- [Noir] Noir
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
    The version of Noir.
]]
Noir.Version = "1.0.0"

--[[
    This event is called when the framework is started.<br>
    Use this event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)
]]
Noir.Started = Noir.Libraries.Events:Create()

--[[
    This represents whether or not the framework has started.
]]
Noir.HasStarted = false

--[[
    This represents whether or not the framework is starting.
]]
Noir.IsStarting = false

--[[
    Starts the framework.<br>
    This will initalize all services, then upon completion, all services will be started.<br>
    Use the `Noir.Started` event to safely run your code.

    Noir.Started:Once(function()
        -- Your code
    end)

    Noir:Start()
]]
function Noir:Start()
    -- Checks
    if self.IsStarting then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir when it is in the process of starting.")
        return
    end

    if self.HasStarted then
        self.Libraries.Logging:Error("Start", "The addon attempted to start Noir more than once.")
        return
    end

    -- Function to setup everything
    local function setup()
        -- Set started
        self.IsStarting = false
        self.HasStarted = true

        -- Initialize services, then start them
        self.Bootstrapper:InitializeServices()
        self.Bootstrapper:StartServices()

        -- Fire event
        self.Started:Fire()
    end

    -- Set isStarting
    self.IsStarting = true

    -- Wait for onCreate
    local onCreate = self.Callbacks:Get("onCreate")

    if not onCreate then
        self.Callbacks:Once("onCreate", setup) -- setup things when onCreate fires
        self.Libraries.Logging:Info("Start", "Waiting for onCreate game event to fire before setting up Noir.")

        return
    end

    if onCreate.hasFiredOnce then
        setup() -- onCreate has fired, so setup now
        self.Libraries.Logging:Info("Start", "onCreate has already fired earlier, so Noir will set up now.")

        return
    end

    self.Callbacks:Once("onCreate", setup) -- setup things when onCreate fires
    self.Libraries.Logging:Info("Start", "Waiting for onCreate game event to fire before setting up Noir.")
end