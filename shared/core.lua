Moon = {}

MoonShared = {}

local StringCharset = {}
local NumberCharset = {}

Config = {}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    [`SHAMAL`] = true,
    [`LUXOR`] = true,
    [`LUXOR2`] = true,
    [`JET`] = true,
    [`LAZER`] = true,
    [`BUZZARD`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    [`TITAN`] = true,
    [`RHINO`] = true,
    [`FIRETRUK`] = true,
    [`MULE`] = true,
    [`MAVERICK`] = true,
    [`BLIMP`] = true,
    [`AIRTUG`] = true,
    [`CAMPER`] = true,    
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

--------- Settings --------------
MoonServerName = 'Moon Framework'

MoonDefaultSpawn = {
    X = -1441.478760,
    Y = -547.587830,
    Z = 34.741817
}

MoonStart = {
    Cash = 250,
    Bank = 1000
}

MoonEnableMinimap = false -- If set to false, minimap will be disabled if PED is outside a vehicle
-------------------------------------------------------------

for i = 48,  57 do NumberCharset[#NumberCharset+1] = string.char(i) end
for i = 65,  90 do StringCharset[#StringCharset+1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset+1] = string.char(i) end

MoonShared.RandomStr = function(length)
    if length <= 0 then return '' end
    return MoonShared.RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

MoonShared.EventPass = function(bool)
    MoonSecurity.eventPass = bool
end

MoonShared.RandomInt = function(length)
    if length <= 0 then return '' end
    return MoonShared.RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end

MoonShared.SplitStr = function(str, delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
		result[#result+1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
	result[#result+1] = string.sub(str, from)
    return result
end

MoonShared.Trim = function(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end



MoonShared.Round = function(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

MoonItems = {
    ['apple'] = {['name'] = 'apple', ['label'] = 'Apple', ['description'] = 'An apple. You can eat it if you want to :)', ['amount'] = 0, ['weight'] = 1, ['useable'] = true, ['removable'] = true, ['img'] = 'apple.png'},
    ['pistol'] = {['name'] = 'WEAPON_PISTOL', ['label'] = 'Pistol', ['description'] = 'A pistol to shot dumbasses', ['amount'] = 0, ['useable'] = true, ['weight'] = 1,  ['removable'] = true, ['img'] = 'apple.png'},
}