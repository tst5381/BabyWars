
--[[--------------------------------------------------------------------------------
-- ModelActionMenu是战局中unit的操作菜单，同时也是工厂建造单位的菜单。
--
-- 主要职责及使用场景：
--   在玩家点击特定单位或地形时，显示相应的操作菜单
--
-- 其他：
--   - 本类只负责根据传入的参数构造菜单，不参与生成菜单内容本身（也就是说，本类并不知道生成的菜单到底是什么）。
--]]--------------------------------------------------------------------------------

local ModelActionMenu = class("ModelActionMenu")

local SingletonGetters = requireBW("src.app.utilities.SingletonGetters")

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(event.playerIndex)
    end
end

local function onEvtActionPlannerChoosingAction(self, event)
    self:setEnabled(true)

    if (self.m_View) then
        self.m_View:removeAllItems()
            :showActionList(event.list, event.itemWait)
    end
end

local function onEvtActionPlannerChoosingProductionTarget(self, event)
    self:setEnabled(true)

    if (self.m_View) then
        self.m_View:removeAllItems()
            :showProductionList(event.productionList)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelActionMenu:ctor(param)
    return self
end

function ModelActionMenu:initView()
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelActionMenu:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar = modelSceneWar
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtPlayerIndexUpdated",                    self)
        :addEventListener("EvtActionPlannerIdle",                     self)
        :addEventListener("EvtActionPlannerChoosingProductionTarget", self)
        :addEventListener("EvtActionPlannerMakingMovePath",           self)
        :addEventListener("EvtActionPlannerChoosingAction",           self)
        :addEventListener("EvtActionPlannerChoosingAttackTarget",     self)
        :addEventListener("EvtActionPlannerChoosingDropDestination",  self)
        :addEventListener("EvtActionPlannerChoosingFlareTarget",      self)
        :addEventListener("EvtActionPlannerChoosingSiloTarget",       self)

    if (self.m_View) then
        self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager(modelSceneWar):getPlayerIndex())
    end

    return self
end

function ModelActionMenu:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtPlayerIndexUpdated")                    then onEvtPlayerIndexUpdated(self, event)
    elseif (eventName == "EvtActionPlannerIdle")                     then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerMakingMovePath")           then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingAttackTarget")     then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingDropDestination")  then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingFlareTarget")      then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingSiloTarget")       then self:setEnabled(false)
    elseif (eventName == "EvtActionPlannerChoosingProductionTarget") then onEvtActionPlannerChoosingProductionTarget(self, event)
    elseif (eventName == "EvtActionPlannerChoosingAction")           then onEvtActionPlannerChoosingAction(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelActionMenu:setEnabled(enabled)
    if (self.m_View) then
        self.m_View:setEnabled(enabled)
    end

    return self
end

return ModelActionMenu
