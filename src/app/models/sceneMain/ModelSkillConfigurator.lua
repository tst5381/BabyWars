
local ModelSkillConfigurator = class("ModelSkillConfigurator")

local ModelSkillConfiguration = require("src.app.models.common.ModelSkillConfiguration")
local LocalizationFunctions   = require("src.app.utilities.LocalizationFunctions")
local GameConstantFunctions   = require("src.app.utilities.GameConstantFunctions")
local getLocalizedText        = LocalizationFunctions.getLocalizedText

local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()
local ID_PASSIVE_SKILL  = 0
local ID_ACTIVE_SKILL_1 = 1
local ID_ACTIVE_SKILL_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getConfigurationTitle(configurationID)
    return string.format("%s %d", getLocalizedText(3, "Configuration"), configurationID)
end

--------------------------------------------------------------------------------
-- The functions for setting state.
--------------------------------------------------------------------------------
local function setStateMain(self)
    self.m_State = "stateMain"
    self.m_ModelSkillConfituration:ctor()

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(1, "ConfigSkills"))
            :setMenuItems(self.m_ItemsAllConfigurations)
            :setOverviewVisible(false)
            :setEnabled(true)
    end
end

local function setStateDisabled(self)
    self.m_State = "stateDisabled"
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end
end

local function setStateOverviewConfiguration(self, configurationID)
    self.m_State           = "stateOverviewConfiguration"
    self.m_ConfigurationID = configurationID

    local view = self.m_View
    if (view) then
        view:setMenuTitle(getConfigurationTitle(configurationID))
            :setMenuItems(self.m_ItemsOverview)
            :setOverviewVisible(true)
            :setEnabled(true)

        local configuration = self.m_ModelSkillConfituration
        if (configuration:isEmpty()) then
            view:setOverviewString(getLocalizedText(3, "GettingConfiguration"))
        else
            view:setOverviewString(configuration:getDescription())
        end
    end
end

local function setStateSelectMaxPoint(self)
    self.m_State = "stateSelectMaxPoint"

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(3, "MaxPoints"))
            :setMenuItems(self.m_ItemsMaxPoints)
    end
end

local function setStateOverviewPassiveSkill(self)
    self.m_State = "stateOverviewPassiveSkill"

    if (self.m_View) then
        self.m_View:setMenuTitle(getLocalizedText(3, "PassiveSkill"))
            :setMenuItems(self.m_ItemsPassiveSkillSlots)
    end
end

local function setStateSelectSkillCategory(self, skillID, slotIndex)
    self.m_State     = "stateSelectSkillCategory"
    self.m_SlotIndex = slotIndex
    self.m_SkillID   = skillID

    if (self.m_View) then
        self.m_View:setMenuTitle(string.format("%s %d", getLocalizedText(3, "Skill"), slotIndex))
            :setMenuItems(self.m_ItemsSkillCategories)
    end
end

local function setStateSelectSkill(self, categoryName)
    self.m_State        = "stateSelectSkill"
    self.m_CategoryName = categoryName

    if (self.m_View) then
        self.m_View:setMenuItems(self.m_ItemsSkills[categoryName])
    end
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initItemsAllConfigurations(self)
    local items = {}
    for i = 1, 10 do
        items[#items + 1] = {
            name     = getConfigurationTitle(i),
            callback = function()
                setStateOverviewConfiguration(self, i)
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name            = "EvtPlayerRequestDoAction",
                    actionName      = "GetSkillConfiguration",
                    configurationID = i,
                })
            end,
        }
    end

    self.m_ItemsAllConfigurations = items
end

local function initItemsOverview(self)
    local items = {
        {
            name     = getLocalizedText(3, "SetSkillPoint"),
            callback = function()
                setStateSelectMaxPoint(self)
            end,
        },
        {
            name     = getLocalizedText(3, "PassiveSkill"),
            callback = function()
                setStateOverviewPassiveSkill(self)
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 1",
            callback = function()
            end,
        },
        {
            name     = getLocalizedText(3, "ActiveSkill") .. " 2",
            callback = function()
            end,
        },
    }

    self.m_ItemsOverview = items
end

local function initItemsMaxPoints(self)
    local items = {}
    for points = MIN_POINTS, MAX_POINTS, POINTS_PER_STEP do
        items[#items + 1] = {
            name     = "" .. points,
            callback = function()
                self.m_ModelSkillConfituration:setMaxPoints(points)
                setStateOverviewConfiguration(self, self.m_ConfigurationID)
            end,
        }
    end

    self.m_ItemsMaxPoints = items
end

local function initItemsPassiveSkillSlots(self)
    local items = {}
    for i = 1, GameConstantFunctions.getPassiveSkillSlotsCount() do
        items[#items + 1] = {
            name     = string.format("%s %d", getLocalizedText(3, "Skill"), i),
            callback = function()
                setStateSelectSkillCategory(self, ID_PASSIVE_SKILL, i)
            end,
        }
    end

    self.m_ItemsPassiveSkillSlots = items
end

local function initItemsSkillCategories(self)
    local items = {}
    for _, categoryName in ipairs(GameConstantFunctions.getCategory("SkillCategories")) do
        items[#items + 1] = {
            name     = getLocalizedText(6, categoryName),
            callback = function()
                setStateSelectSkill(self, categoryName)
            end,
        }
    end

    self.m_ItemsSkillCategories = items
end

local function initItemsSkills(self)
    local items = {}
    for _, categoryName in ipairs(GameConstantFunctions.getCategory("SkillCategories")) do
        local subItems = {}
        for _, skillName in ipairs(GameConstantFunctions.getCategory(categoryName)) do
            subItems[#subItems + 1] = {
                name     = getLocalizedText(5, skillName),
                callback = function()
                end,
            }
        end
        items[categoryName] = subItems
    end

    self.m_ItemsSkills = items
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:ctor()
    self.m_State                   = "stateDisabled"
    self.m_ModelSkillConfituration = ModelSkillConfiguration:create()

    initItemsAllConfigurations(self)
    initItemsOverview(         self)
    initItemsMaxPoints(        self)
    initItemsPassiveSkillSlots(self)
    initItemsSkillCategories(  self)
    initItemsSkills(           self)

    return self
end

function ModelSkillConfigurator:initView()
    return self
end

function ModelSkillConfigurator:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelSkillConfigurator:setModelMainMenu() the model has been set already.")
    self.m_ModelMainMenu = model

    return self
end

function ModelSkillConfigurator:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil,
        "ModelSkillConfigurator:setRootScriptEventDispatcher() the model has been set already.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:doActionGetSkillConfiguration(action)
    if ((self.m_State ~= "stateDisabled")                   and
        (self.m_ConfigurationID == action.configurationID)) then
        self.m_ModelSkillConfituration:ctor(action.configuration)

        if (self.m_View) then
            self.m_View:setOverviewString(self.m_ModelSkillConfituration:getDescription())
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfigurator:setEnabled(enabled)
    if (enabled) then
        setStateMain(self)
    else
        setStateDisabled(self)
    end

    return self
end

function ModelSkillConfigurator:onButtonBackTouched()
    local state = self.m_State
    if (state == "stateMain") then
        setStateDisabled(self)
        self.m_ModelMainMenu:setMenuEnabled(true)
    elseif (state == "stateOverviewConfiguration") then
        setStateMain(self)
    elseif (state == "stateSelectMaxPoint") then
        setStateOverviewConfiguration(self, self.m_ConfigurationID)
    elseif (state == "stateOverviewPassiveSkill") then
        setStateOverviewConfiguration(self, self.m_ConfigurationID)
    elseif (state == "stateSelectSkillCategory") then
        setStateOverviewPassiveSkill(self)
    elseif (state == "stateSelectSkill") then
        setStateSelectSkillCategory(self, self.m_SkillID, self.m_SlotIndex)
    else
        error("ModelSkillConfigurator:onButtonBackTouched() the current state is invalid: " .. state)
    end

    return self
end

return ModelSkillConfigurator
