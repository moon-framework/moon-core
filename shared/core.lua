Moon = {}

MoonShared = {}

local StringCharset = {}
local NumberCharset = {}

Moon.DefaultSpawn = {
    X = -1441.478760,
    Y = -547.587830,
    Z = 34.741817
}

MoonServerName = 'Moon Framework'

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