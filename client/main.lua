Moon = {}
Moon.Shared = MoonShared
Moon.ServerCallbacks          = {}

Moon.CurrentRequestId          = 0
exports('GetCoreObject', function()
    return Moon
end)
