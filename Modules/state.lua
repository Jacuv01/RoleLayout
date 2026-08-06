local _, RoleLayout = ...

local CURRENT_DB_VERSION = 1

local function ensureBoolean(value, default)
    if type(value) ~= "boolean" then
        return default
    end
    return value
end

local function ensureActionBars(db)
    db.actionBars = db.actionBars or {}
    for i = 1, 7 do
        if type(db.actionBars[i]) ~= "boolean" then
            db.actionBars[i] = true
        end
    end
    return db.actionBars
end

local function migrateSavedVariables(db)
    if type(db.version) ~= "number" then
        db.version = 1
    end

    if db.version < CURRENT_DB_VERSION then
        db.version = CURRENT_DB_VERSION
    end

    db.locked = ensureBoolean(db.locked, false)
    db.enableExternalDefensives = ensureBoolean(db.enableExternalDefensives, false)
    db.enableDamageMeter = ensureBoolean(db.enableDamageMeter, false)
    ensureActionBars(db)

    return db
end

function RoleLayout:EnsureSavedVariables()
    if not RoleLayoutDB then
        RoleLayoutDB = {}
    end

    local db = RoleLayoutDB
    db = migrateSavedVariables(db)
    RoleLayoutDB = db

    return db
end

function RoleLayout:GetDB()
    return self:EnsureSavedVariables()
end

function RoleLayout:GetSetting(key, default)
    local db = self:GetDB()
    if db[key] == nil then
        db[key] = default
    end
    return db[key]
end

function RoleLayout:SetSetting(key, value)
    local db = self:GetDB()
    db[key] = value
    return db[key]
end

function RoleLayout:ResetSettings()
    local db = self:GetDB()
    db.actionBars = {}
    for i = 1, 7 do
        db.actionBars[i] = true
    end
    db.enableExternalDefensives = false
    db.enableDamageMeter = false
    return db
end
