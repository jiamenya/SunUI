local S, C, L, DB = unpack(select(2, ...))
if DB.Nuke == true then return end
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("totembar", "AceEvent-3.0")
local barDB = DB.bars.totembar


  if DB.MyClass == "SHAMAN" then
  function Module:OnInitialize()
	C = ActionBarDB
	local a1, af, a2, x, y = unpack(MoveHandleDB["totembar"]) 
    local f = _G['MultiCastActionBarFrame']
    local bar = CreateFrame("Frame","SunUITotemBar",UIParent,"SecureHandlerStateTemplate")
    bar:Width(f:GetWidth())
    bar:Height(f:GetHeight())
    bar:SetScale(C["TotemBarSacle"])
    MoveHandle.SunUITotemBar = S.MakeMove(bar, "SunUI图腾栏", "totembar", C["TotemBarSacle"])
	
    bar:SetAttribute("_onstate-vis", [[
      if not newstate then return end
      if newstate == "show" then
        self:Show()
      elseif newstate == "hide" then
        self:Hide()
      end
    ]])
    RegisterStateDriver(bar, "vis", "[bonusbar:5][@player,dead][flying][mounted][stance]hide;show")
    f:SetParent(bar)
    f:ClearAllPoints()
    f:Point("CENTER",0,0)
    f:EnableMouse(false)
    local moveTotem = function(self,a,b,c,d,e)
      if a == "CENTER" then return end
      self:ClearAllPoints()
      self:Point("CENTER",0,0)
    end
    hooksecurefunc(f, "Point", moveTotem)
    f.ignoreFramePositionManager = true

    --[[--------------------------------------------------------------------
    Adjusted code from Improved Totem Frame
    by Phanx <addons@phanx.net>
    Improves the totem frame in the default UI.
    http://www.wowinterface.com/downloads/info-ImprovedTotemFrame.html
    http://wow.curse.com/downloads/wow-addons/details/improvedtotemframe.aspx

    Copyright © 2010–2011 Phanx
    I, the copyright holder of this work, hereby release it into the public
    domain. This applies worldwide. In case this is not legally possible:
    I grant anyone the right to use this work for any purpose, without any
    conditions, unless such conditions are required by law.
    ----------------------------------------------------------------------]]

    --code for timer and destroyer is taken from improved totem frame by phanx

    --TOTEM TIMER

    local totemSlot = { 2, 1, 3, 4 }

    local function OnEvent(self, event, slot)
      if event == "PLAYER_ENTERING_WORLD" then
        slot = self.slot
      elseif slot ~= self.slot then
        return
      end
      local _, _, start, duration = GetTotemInfo(slot)
      if duration > 0 then
        self.start = start
        self.duration = duration
        self:Show()
      else
        self:Hide()
      end
    end

    local function OnHide(self)
      self.start = nil
      self.duration = nil
    end

    local function OnShow(self)
      if not self.start or not self.duration then return self:Hide() end
      self.elapsed = 1000
    end

    --format time func
    local GetFormattedTime = function(time)
      local hr, m, s, text
      if time <= 0 then text = ""
      elseif(time < 3600 and time > 60) then
        hr = floor(time / 3600)
        m = floor(mod(time, 3600) / 60 + 1)
        text = format("%dm", m)
      elseif time < 60 then
        m = floor(time / 60)
        s = mod(time, 60)
        text = (m == 0 and format("%ds", s))
      else
        hr = floor(time / 3600 + 1)
        text = format("%dh", hr)
      end
      return text
    end

    local function OnUpdate(self, elapsed)
      self.elapsed = self.elapsed + elapsed
      if self.elapsed > 0.33 then
        local timeLeft = self.start + self.duration - GetTime()
        if timeLeft > 0 then
          self.text:SetText(GetFormattedTime(timeLeft))
          self.elapsed = 0
        else
          self.text:SetText()
          self:Hide()
        end
      end
    end

    for i = 1, #totemSlot do
      local button = _G["MultiCastActionButton"..i]
      local timerFrame = CreateFrame("Frame", nil, button)
      button.timerFrame = timerFrame
      timerFrame:SetAllPoints(button)
      timerFrame:Hide()
      timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY")
      timerFrame.text:Point("CENTER", 0, 0)
      timerFrame.text:SetFont(STANDARD_TEXT_FONT, button:GetWidth()*16/36, "THINOUTLINE")
      timerFrame.text:SetShadowOffset(1,-2)
      timerFrame.text:SetShadowColor(0,0,0,0.6)
      timerFrame.text:SetJustifyH("CENTER")
      timerFrame.id = i
      timerFrame.slot = totemSlot[i]
      timerFrame:SetScript("OnEvent", OnEvent)
      timerFrame:SetScript("OnHide", OnHide)
      timerFrame:SetScript("OnShow", OnShow)
      timerFrame:SetScript("OnUpdate", OnUpdate)
      timerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
      timerFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
      OnEvent(timerFrame, "PLAYER_TOTEM_UPDATE", timerFrame.slot)
    end

    --TOTEM DESTROYER

    local destroyers = { }
    local totemSlot  = { 2, 1, 3, 4 }
    local backdrop   = { bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = false }

    local function Button_OnClick(self, button)
      DestroyTotem(self.slot)
    end

    local function Button_OnEvent(self, event, key)
      if key ~= "LSHIFT" and key ~= "RSHIFT" then return end

      local _, _, start, duration = GetTotemInfo(self.slot)

      if IsShiftKeyDown() and duration > 0 then
        self:Show()
        self:SetAlpha(ImprovedTotemFrameDB and ImprovedTotemFrameDB.dA or 0.5)
      else
        self:Hide()
      end
    end

    for i = 1, #totemSlot do
      local mcab = _G["MultiCastActionButton" .. i]

      local b = CreateFrame("Button", nil, UIParent)
      b:SetFrameStrata(mcab:GetFrameStrata())
      b:SetFrameLevel(mcab:GetFrameLevel() + 3)
      b:Point("TOPLEFT", mcab, -1, 1)
      b:Point("BOTTOMRIGHT", mcab, 1, -1)

      b:SetBackdrop(backdrop)
      b:SetBackdropColor(1, 0, 0)

      b:Hide()
      b:RegisterEvent("MODIFIER_STATE_CHANGED")
      b:SetScript("OnEvent", Button_OnEvent)

      b:RegisterForClicks("RightButtonUp")
      b:SetScript("OnClick", Button_OnClick)

      b.id = i
      b.slot = totemSlot[i]

      destroyers[b.slot] = b
      mcab.destroyer = b
    end
end
end