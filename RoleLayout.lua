local addonName, RoleLayout = ...

RoleLayout.name = addonName
RoleLayout.DEBUG = false

function RoleLayout:Log(msg)
    if self.DEBUG and DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r " .. tostring(msg))
    end
end

function RoleLayout:Initialize()
    if self.EnsureSavedVariables then
        self:EnsureSavedVariables()
    end

    if self.InitializeCharacterSettings then
        self:InitializeCharacterSettings()
    end
end

DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r successfully loaded!")
