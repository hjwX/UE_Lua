local BTNodeStatus = require "BTNodeStatus"

---@class BTTree: BaseClass
---@field isPause boolean 行为树是否停止了
local BTTree = BaseClass("BTTree")

function BTTree:__init(entity, tick_time)
    self.root = nil
    self.entity = entity
    self.board = {}
    self.nodeDict = {}
    self.runningActing = nil
    tick_time = tick_time or 4
    self.tick_time = tick_time
end

function BTTree:OnInit()
    if self.root then
        self.root:OnInit()
    end
end

function BTTree:Execute()
    if not self.isPause and self.currentNodeStatus ~= BTNodeStatus.Running then
        self.currentTaskStatus = self.root:Execute()
    end
end

function BTTree:Pause(isPause)
    self.isPause = isPause
    if self.isPause then
        self.currentNodeStatus = nil
    end
end

return BTTree