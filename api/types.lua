--------------------------------------------------------------------------------
-- BPLib public types and enums.
--------------------------------------------------------------------------------

if ... ~= "__bplib__.api.types" then return require("__bplib__.api.types") end
local lib = {}

---A blueprint-like object
---@alias bplib.Blueprintish LuaItemStack|LuaRecord

---@class (exact) bplib.Error
---@field message string

---@class bplib.CustomEventBase
---@field name string The name of the event.
---@field tick uint The tick the event was raised.
---@field bplib_event_id uint? The ID of the event in bplib's event system, if applicable.

return lib
