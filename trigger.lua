RadialTriggers = RadialTriggers or {}

RadialTriggers.Handcuff = function(...)
    TriggerEvent("jobs_creator:actions:softHandcuff", ...)
end

RadialTriggers.putInCar = function(...)
    TriggerEvent("jobs_creator:actions:putInCar", ...)
end

RadialTriggers.takeFromCar = function(...)
    TriggerEvent("jobs_creator:actions:takeFromCar", ...)
end

RadialTriggers.drag = function(...)
    TriggerEvent("jobs_creator:actions:drag", ...)
end

RadialTriggers.checkIdentity = function(...)
    TriggerEvent("jobs_creator:actions:checkIdentity", ...)
end

RadialTriggers.checkVehicleOwner = function(...)
    TriggerEvent("jobs_creator:actions:checkVehicleOwner", ...)
end

RadialTriggers.checkLicenses = function(...)
    TriggerEvent("jobs_creator:actions:checkLicenses", ...)
end

RadialTriggers.lockpickCar = function(...)
    TriggerEvent("jobs_creator:actions:lockpickCar", ...)
end


-- Generic passthrough if needed
RadialTriggers.trigger = function(name, ...)
    TriggerEvent(name, ...)
end

return RadialTriggers
