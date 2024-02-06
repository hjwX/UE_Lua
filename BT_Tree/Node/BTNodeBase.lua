---@class BTNodeBase: BaseClass
---@field bt BTTree
---@field bt_index number
---@field parent BTNodeBase
local BTNodeBase = BaseClass("BTNodeBase")

function BTNodeBase:__init(bt, index)
    self.bt = bt
    self.bt_index = index;
    self.parent = nil
end

function BTNodeBase:OnInit()
end

function BTNodeBase:Execute()
end

function BTNodeBase:OnDestroy()
end

function BTNodeBase:ResetTaskStatus()
end

return BTNodeBase