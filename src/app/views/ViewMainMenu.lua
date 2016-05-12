
local ViewMainMenu = class("ViewMainMenu", cc.Node)

local NEW_GAME_CREATOR_Z_ORDER = 0
local WAR_LIST_Z_ORDER         = 0

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setMenuContentSize(self, width, height)
    self.m_MenuBackground:setContentSize(width, height)
    self.m_MenuListView:setContentSize(width - 10, height - 14) -- 10/14 are the height/width of the edging of background
end

local function createViewItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)
        :setTitleText(item.name)

    view:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            item.callback()
        end
    end)

    return view
end

--------------------------------------------------------------------------------
-- The composition menu background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(30, 30)
        :setOpacity(180)

    return background
end

local function initWithMenuBackground(self, background)
    self.m_MenuBackground = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The composition menu list view.
--------------------------------------------------------------------------------
local function createMenuListView()
    local listView = ccui.ListView:create()
    listView:setPosition(35, 36)
        :setItemsMargin(15)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)
        :setOpacity(180)

    return listView
end

local function initWithMenuListView(self, listView)
    self.m_MenuListView = listView
    self:addChild(listView)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewMainMenu:ctor(param)
    initWithMenuBackground(self, createMenuBackground())
    initWithMenuListView(  self, createMenuListView())

    setMenuContentSize(self, 250, display.height - 60)

    return self
end

function ViewMainMenu:setViewNewGameCreator(view)
    assert(self.m_ViewNewGameCreator == nil, "ViewMainMenu:setViewNewGameCreator() the view has been set.")
    self.m_ViewNewGameCreator = view
    self:addChild(view, NEW_GAME_CREATOR_Z_ORDER)

    return self
end

function ViewMainMenu:setViewWarList(view)
    assert(self.m_ViewWarList == nil, "ViewMainMenu:setViewWarList() the view has been set.")
    self.m_ViewWarList = view
    self:addChild(view, WAR_LIST_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewMainMenu:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewMainMenu:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewItem(item))

    return self
end

function ViewMainMenu:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_MenuListView:setVisible(visible)

    return self
end

return ViewMainMenu
