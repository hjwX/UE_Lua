require("base_class")
---@class EventCenter
---@field Print fun(self: any, value: any)
local EventCenter = BaseClass("EventCenter");

local function Init(self, value)
    self.name = value
end

EventCenter.Init = Init

return EventCenter
