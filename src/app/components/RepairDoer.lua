
--[[--------------------------------------------------------------------------------
-- RepairDoer是ModelTile可用的组件。只有绑定了本组件，宿主才具有“维修”的属性。
-- 主要职责：
--   维护相关数值并提供必要接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据属性来绑定和初始化本组件（所有ModelUnit都需要绑定，但具体由GameConstant决定）
--   在维修单位的回合阶段，需要通过本组件获取必要信息（维修量，可维修类型等）
-- 其他：
--   - 目前，“维修”的实际操作是由ModelPlayerManager进行的，本组件提供各种相关getter
--   - 对单位的维修是有次序的。在金钱不够的情况下，优先维修最贵的单位，造价相同的情况下，优先维修首先出现的单位（由ModelUnit.m_UnitID记录）
--   - 维修除了回复hp，也会回复燃料和弹药（不用花钱）
--   - 如果unit的hp为71（此时游戏里显示的hp为8，原因见AttackTaker），那么维修时会补充到100（此时游戏里显示hp为10)。
--     如果unit的hp为70（此时游戏里显示的hp为7），那么维修时会补充到90（此时游戏里显示为9）
--   - 维修量受co技能、金钱影响
--]]--------------------------------------------------------------------------------

local RepairDoer = require("src.global.functions.class")("RepairDoer")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions = require("src.app.utilities.LocalizationFunctions")
local ComponentManager      = require("src.global.components.ComponentManager")

RepairDoer.EXPORTED_METHODS = {
    "getRepairTargetCategoryFullName",
    "getRepairTargetCategory",
    "canRepairTarget",
    "getRepairAmountAndCost",
    "getNormalizedRepairAmount",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function RepairDoer:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function RepairDoer:loadTemplate(template)
    assert(template.amount,             "RepairDoer:loadTemplate() the param template.amount is invalid.")
    assert(template.targetCategoryType, "RepairDoer:loadTemplate() the param template.targetCategoryType is invalid.")

    self.m_Template = template

    return self
end

function RepairDoer:loadInstantialData(data)
    return self
end

function RepairDoer:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "RepairDoer:setModelPlayerManager() the model has been set already.")
    self.m_ModelPlayerManager = model

    return self
end

--------------------------------------------------------------------------------
-- Exported methods.
--------------------------------------------------------------------------------
function RepairDoer:getRepairTargetCategoryFullName()
    return LocalizationFunctions.getLocalizedText(118, self.m_Template.targetCategoryType)
end

function RepairDoer:getRepairTargetCategory()
    return GameConstantFunctions.getCategory(self.m_Template.targetCategoryType)
end

function RepairDoer:canRepairTarget(target)
    local targetTiledID = target:getTiledId()
    if (GameConstantFunctions.getPlayerIndexWithTiledId(targetTiledID) ~= self.m_Owner:getPlayerIndex()) then
        return false
    end

    local targetName = GameConstantFunctions.getUnitTypeWithTiledId(targetTiledID)
    for _, name in ipairs(self:getRepairTargetCategory()) do
        if (targetName == name) then
            return true
        end
    end

    return false
end

function RepairDoer:getRepairAmountAndCost(target, modelPlayer)
    local normalizedCurrentHP    = target:getNormalizedCurrentHP()
    local productionCost         = target:getProductionCost()
    local normalizedRepairAmount = math.min(
        10 - normalizedCurrentHP,
        self:getNormalizedRepairAmount(modelPlayer),
        math.floor(modelPlayer:getFund() * 10 / productionCost)
    )

    return (normalizedRepairAmount + normalizedCurrentHP) * 10 - target:getCurrentHP(),
        round(normalizedRepairAmount * productionCost / 10)
end

function RepairDoer:getNormalizedRepairAmount(modelPlayer)
    if (not modelPlayer) then
        return self.m_Template.amount
    else
        -- TODO: take the abilities of the player into account.
        return self.m_Template.amount
    end
end

return RepairDoer
