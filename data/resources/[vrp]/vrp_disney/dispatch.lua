-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,120 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RETIRAR SOM ALEATORIO ]
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE");
		SetAudioFlag("PoliceScannerDisabled",true);
		Wait(0)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------
--[ NPC CONTROL ]
----------------------------------------------------------------------------------------------------------------------------------------
trafficDensity = 0
pedDensity = 0
Citizen.CreateThread(function()
    while true do
        SetVehicleDensityMultiplierThisFrame(trafficDensity)
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetRandomVehicleDensityMultiplierThisFrame(trafficDensity)
        SetParkedVehicleDensityMultiplierThisFrame(trafficDensity)
        SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity)
    Citizen.Wait(0)
    end
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- PERDER A ADERÊNCIA QUANDO ESTIVER COM A RODA ESTOURADA
---------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if IsPedInAnyVehicle(ped) then
            timeDistance = 4
            if GetPedInVehicleSeat(vehicle,-1) == ped then
                for i = 0, 5 do
                    if IsVehicleTyreBurst(vehicle, i, true) then
                        SetVehicleReduceGrip(vehicle,true)
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
---------------------------------------------------------------------------------------------
---[DESATIVAR Q COVER]
---------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health > 100 then
        DisableControlAction(0,44,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR A CORONHADA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timedistance = 100
    	local ped = PlayerPedId()
		if IsPedArmed(ped, 6) then
			timedistance = 5
           	DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
           	DisableControlAction(1, 142, true)
		end
		Citizen.Wait(timedistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER ARMA ABAIXO DE 40MPH DENTRO DO CARRO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timedistance = 1000
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		if IsEntityAVehicle(vehicle) then
			idle = 1
			local speed = GetEntitySpeed(vehicle)*2.236936
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				if speed >= 40 then
					SetPlayerCanDoDriveBy(PlayerId(),false)
				else
					SetPlayerCanDoDriveBy(PlayerId(),true)
				end
			end
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESATIVA O CONTROLE DO CARRO ENQUANTO ESTIVER NO AR
-----------------------------------------------------------------------------------------------------------------------------------------
--[[Citizen.CreateThread(function()
    while true do
        local timedistance = 1000
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
			timedistance = 5
            local model = GetEntityModel(veh)
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABicycle(model) and not IsThisModelABike(model) and not IsThisModelAQuadbike(model) and IsEntityInAir(veh) then
                DisableControlAction(0,59)
                DisableControlAction(0,60)
            end
        end
		Citizen.Wait(timedistance)
    end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOURAR OS PNEUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if GetPedInVehicleSeat(vehicle,-1) == ped then
                local speed = GetEntitySpeed(vehicle)*2.236936
                if speed >= 180 and math.random(100) >= 97 then
                    if GetVehicleTyresCanBurst(vehicle) == false then return end
                    local pneus = GetVehicleNumberOfWheels(vehicle)
                    local pneusEffects
                    if pneus == 2 then
                        pneusEffects = (math.random(2)-1)*4
                    elseif pneus == 4 then
                        pneusEffects = (math.random(4)-1)
                        if pneusEffects > 1 then
                            pneusEffects = pneusEffects + 2
                        end
                    elseif pneus == 6 then
                        pneusEffects = (math.random(6)-1)
                    else
                        pneusEffects = 0
                    end
                    SetVehicleTyreBurst(vehicle,pneusEffects,false,1000.0)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timedistance = 1000
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			local speed = GetEntitySpeed(vehicle) * 2.236936
			if GetPedInVehicleSeat(vehicle,-1) == ped then
			timedistance = 100			
				if speed <= 80.0 then
					if IsControlPressed(1,21) then
						SetVehicleReduceGrip(vehicle,true)
					else
						SetVehicleReduceGrip(vehicle,false)
					end
				end
			end
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ ['x'] = 265.64, ['y'] = -1261.30, ['z'] = 29.29, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 819.65, ['y'] = -1028.84, ['z'] = 26.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 1208.95, ['y'] = -1402.56, ['z'] = 35.22, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 1181.38, ['y'] = -330.84, ['z'] = 69.31, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 620.84, ['y'] = 269.10, ['z'] = 103.08, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 2581.32, ['y'] = 362.03, ['z'] = 108.46, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -319.29, ['y'] = -1471.71, ['z'] = 30.54, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 1784.32, ['y'] = 3330.55, ['z'] = 41.25, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 49.418, ['y'] = 2778.79, ['z'] = 58.04, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 263.89, ['y'] = 2606.46, ['z'] = 44.98, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 1039.95, ['y'] = 2671.13, ['z'] = 39.55, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
--	{ ['x'] = 1207.26, ['y'] = 2660.17, ['z'] = 37.89, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 2539.68, ['y'] = 2594.19, ['z'] = 37.94, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 2679.85, ['y'] = 3263.94, ['z'] = 55.24, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 2005.05, ['y'] = 3773.88, ['z'] = 32.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 1687.15, ['y'] = 4929.39, ['z'] = 42.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 1701.31, ['y'] = 6416.02, ['z'] = 32.76, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = 179.85, ['y'] = 6602.83, ['z'] = 31.86, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -94.46, ['y'] = 6419.59, ['z'] = 31.48, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -2554.99, ['y'] = 2334.40, ['z'] = 33.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -1800.37, ['y'] = 803.66, ['z'] = 138.65, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -1437.62, ['y'] = -276.74, ['z'] = 46.20, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -2096.24, ['y'] = -320.28, ['z'] = 13.16, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -724.61, ['y'] = -935.16, ['z'] = 19.21, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -526.01, ['y'] = -1211.00, ['z'] = 18.18, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
	{ ['x'] = -70.21, ['y'] = -1761.79, ['z'] = 29.53, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.4 },
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v.x,v.y,v.z)
		SetBlipSprite(blip,v.sprite)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v.color)
		SetBlipScale(blip,v.scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.nome)
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
Citizen.CreateThread(function()
	while true do
		local timedistance = 1000
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			timedistance = 100
			SetPedToRagdoll(ped,10000,10000,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			timedistance = 100
			tasertime = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			timedistance = 100
			tasertime = false
			SetTimeout(5000,function()
				SetTimecycleModifier("hud_def_desat_Trevor")
				SetTimeout(10000,function()
					SetTimecycleModifier("")
					SetTransitionTimecycleModifier("")
					StopGameplayCamShaking()
				end)
			end)
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGE WALK MODE
-----------------------------------------------------------------------------------------------------------------------------------------
local hurt = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		if not IsEntityInWater(ped) then
			if GetEntityHealth(ped) <= 199 then
				setHurt()
			elseif hurt and GetEntityHealth(ped) > 200 then
				setNotHurt()
			end
		end
	end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(PlayerPedId(),"move_m@injured",true)
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
	DisableControlAction(0,21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN BUNNYHOP
-----------------------------------------------------------------------------------------------------------------------------------------
local bunnyhop = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if bunnyhop > 0 then
            bunnyhop = bunnyhop - 5
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedJumping(ped) and bunnyhop <= 0 then
            bunnyhop = 5
        end
        if bunnyhop > 0 then
            DisableControlAction(0,22,true)
        end
        Citizen.Wait(5)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	["HOSPITALANDARDOIS"] = {
		positionFrom = { ['x'] = 344.34, ['y'] = -586.24, ['z'] = 28.8 },
		positionTo = { ['x'] = 332.31, ['y'] = -595.71, ['z'] = 43.29 },
	},

	["HOSPITALHELI"] = {
		positionFrom = { ['x'] = 330.3, ['y'] = -601.03, ['z'] = 43.29 },
		positionTo = { ['x'] = 338.58, ['y'] = -583.82, ['z'] = 74.17 }
	}
}

Citizen.CreateThread(function()
	while true do
		local timedistance = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(teleport) do
				if Vdist(v.positionFrom.x,v.positionFrom.y,v.positionFrom.z,x,y,z) <= 1.2 then
					timedistance = 4
					DrawMarker(27,v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.99,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 255, 255,100,0,0,0,1)
					if IsControlJustPressed(0,38) then
						SetEntityCoords(ped,v.positionTo.x,v.positionTo.y,v.positionTo.z-0.50)
					end
				end

				if Vdist(v.positionTo.x,v.positionTo.y,v.positionTo.z,x,y,z) <= 1.2 then
					timedistance = 4
					DrawMarker(27,v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.99,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 255, 255,100,0,0,0,1)
					if IsControlJustPressed(0,38) then
						SetEntityCoords(ped,v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.50)
					end
				end
			end
		end
		Wait(timedistance)
	end
end)