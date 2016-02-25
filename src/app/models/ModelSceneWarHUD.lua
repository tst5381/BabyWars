
local ModelSceneWarHUD = class("ModelSceneWarHUD")

local function createChildrenActors(param)
    local Actor = require("global.actors.Actor")

    local moneyEnergyInfoActor = Actor.createWithModelAndViewName("ModelMoneyEnergyInfo", nil, "ViewMoneyEnergyInfo")
    assert(moneyEnergyInfoActor, "ModelSceneWarHUD-createChildrenActors() failed to create a MoneyEnergyInfo actor.")

    local unitInfoActor = Actor.createWithModelAndViewName("ModelUnitInfo", nil, "ViewUnitInfo")
    assert(unitInfoActor, "ModelSceneWarHUD-createChildrenActors() failed to crate a UnitInfo actor.")
    
    return {moneyEnergyInfoActor = moneyEnergyInfoActor,
            unitInfoActor        = unitInfoActor}
end

local function initWithChildrenActors(model, actors)
    model.m_MoneyEnergyInfoActor = actors.moneyEnergyInfoActor
    assert(model.m_MoneyEnergyInfoActor, "ModelSceneWarHUD-initWithChildrenActors() failed to retrieve a MoneyEnergyInfo actor.")
    
    model.m_UnitInfoActor = actors.unitInfoActor
    assert(model.m_UnitInfoActor, "ModelSceneWarHUD-initWithChildrenActors() failed to retrieve a UnitInfo actor.")
end

local function getChildrenViewsFromButtomToTop(model)
    local views = {}
    
    views[#views + 1] = model.m_MoneyEnergyInfoActor:getView()
    views[#views + 1] = model.m_UnitInfoActor:getView()
    
    return views
end

local function initWithChildrenViews(view, childrenViewsFromButtomToTop)
    view:removeAllChildren()

    for _, childView in ipairs(childrenViewsFromButtomToTop) do
        view:addChild(childView)
    end
end

function ModelSceneWarHUD:ctor(param)
    if (param) then
        self:load(param)
    end
    
    return self
end

function ModelSceneWarHUD:load(param)
    initWithChildrenActors(self, createChildrenActors(param))
    
    return self
end

function ModelSceneWarHUD.createInstance(param)
    local model = ModelSceneWarHUD.new():load(param)
    assert(model, "ModelSceneWarHUD.createInstance() failed.")
    
    return model
end

function ModelSceneWarHUD:getTouchableChildrenViews()
    local views = {}
    local getTouchableViewFromActor = require("app.utilities.GetTouchableViewFromActor")
    
    views[#views + 1] = getTouchableViewFromActor(self.m_MoneyEnergyInfoActor)
    views[#views + 1] = getTouchableViewFromActor(self.m_UnitInfoActor)
    
    return views
end

function ModelSceneWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelSceneWarHUD:initView() no view is attached to the actor of the model.")

    initWithChildrenViews(view, getChildrenViewsFromButtomToTop(self))
        
    view:setTouchableChildrenViews(self:getTouchableChildrenViews())

    return self
end

return ModelSceneWarHUD
