
local ModelNewWarCreator = class("ModelNewWarCreator")

local Actor        = require("global.actors.Actor")
local WarFieldList = require("res.data.templateWarField.WarFieldList")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function configModelWarConfigurator(model, warFieldFileName)
    local warField = require("res.data.templateWarField." .. warFieldFileName)
    model:setWarFieldFileName(warFieldFileName)
        :setEnabled(true)

    local availablePlayerIndexes = {}
    for i = 1, warField.playersCount do
        availablePlayerIndexes[i] = i
    end
    model:getModelOptionSelectorWithName("PlayerIndex"):setButtonsEnabled(true)
        :setOptions(availablePlayerIndexes)

    model:getModelOptionSelectorWithName("Fog"):setButtonsEnabled(false)
        :setOptions({"off"})

    model:getModelOptionSelectorWithName("Weather"):setButtonsEnabled(false)
        :setOptions({"clear"})

    model:getModelOptionSelectorWithName("Skill"):setButtonsEnabled(false)
        :setOptions({"Unavailable"})

    model:getModelOptionSelectorWithName("MaxSkillPoints"):setButtonsEnabled(false)
        :setOptions({"Unavailable"})
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function getActorWarFieldPreviewer(self)
    if (not self.m_ActorWarFieldPreviewer) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarFieldPreviewer", nil, "sceneMain.ViewWarFieldPreviewer")

        self.m_ActorWarFieldPreviewer = actor
        if (self.m_View) then
            self.m_View:setViewWarFieldPreviewer(actor:getView())
        end
    end

    return self.m_ActorWarFieldPreviewer
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarConfigurator", nil, "sceneMain.ViewWarConfigurator")
        actor:getModel():setEnabled(false)
            :setOnButtonBackTouched(function()
                getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                getActorWarConfigurator(self):getModel():setEnabled(false)
                if (self.m_View) then
                    self.m_View:setMenuVisible(true)
                        :setButtonNextVisible(false)
                end
            end)
            :setOnButtonConfirmTouched(function()
                local modelWarConfigurator = getActorWarConfigurator(self):getModel()
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name             = "EvtPlayerRequestDoAction",
                    actionName       = "NewWar",
                    warFieldFileName = modelWarConfigurator:getWarFieldFileName(),
                    playerIndex      = modelWarConfigurator:getModelOptionSelectorWithName("PlayerIndex"):getCurrentOption(),
                    skillIndex       = 1,
                })
            end)

        self.m_ActorWarConfigurator = actor
        if (self.m_View) then
            self.m_View:setViewWarConfigurator(actor:getView())
        end
    end

    return self.m_ActorWarConfigurator
end

local function initWarFieldList(self, list)
    local list = {}
    for warFieldFileName, warFieldName in pairs(WarFieldList) do
        list[#list + 1] = {
            name     = warFieldName,
            callback = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setEnabled(true)
                if (self.m_View) then
                    self.m_View:setButtonNextVisible(true)
                end

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    configModelWarConfigurator(getActorWarConfigurator(self):getModel(), warFieldFileName)
                    if (self.m_View) then
                        self.m_View:setMenuVisible(false)
                            :setButtonNextVisible(false)
                    end
                end
            end,
        }
    end

    self.m_ItemListWarField = list
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelNewWarCreator:ctor(param)
    initWarFieldList(self)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelNewWarCreator:initView()
    local view = self.m_View
    assert(view, "ModelNewWarCreator:initView() no view is attached to the actor of the model.")

    view:removeAllItems()
        :showListWarField(self.m_ItemListWarField)

    return self
end

function ModelNewWarCreator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelNewWarCreator:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelNewWarCreator:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelNewWarCreator:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelNewWarCreator:setEnabled(enabled)
    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():setEnabled(false)

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setButtonNextVisible(false)
            :setMenuVisible(true)
    end

    return self
end

function ModelNewWarCreator:onButtonBackTouched()
    self:setEnabled(false)
    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

function ModelNewWarCreator:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelNewWarCreator
