local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BLIPS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local showblips = false 

RegisterNetEvent("blips:updateBlips")
 AddEventHandler("blips:updateBlips",function(update)
    blips = update
end)

RegisterNetEvent("blips:adminStart")
AddEventHandler("blips:adminStart",function()
    showblips = true
end)

Citizen.CreateThread(function()
    while true do
        if showblips then
            for k,v in pairs(blips) do
                local id = GetPlayerFromServerId(v[1])
                local ped = GetPlayerPed(id)
                if GetBlipFromEntity(ped) == 0 then
                    local blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip,1)
                    SetBlipColour(blip,24)
                    SetBlipAsShortRange(blip,true)
                    SetBlipScale(blip,0.3)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Conectados")
                    EndTextCommandSetBlipName(blip)
                end
            end
        end
        Citizen.Wait(100)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VROUPAS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('underground:Roupas_CL')
AddEventHandler('underground:Roupas_CL', function()
    local ped = PlayerPedId()
    local custom = {}
    custom[1] = { GetPedDrawableVariation(ped,1),GetPedTextureVariation(ped,1) }
    custom[3] = { GetPedDrawableVariation(ped,3),GetPedTextureVariation(ped,3) }
    custom[4] = { GetPedDrawableVariation(ped,4),GetPedTextureVariation(ped,4) }
    custom[5] = { GetPedDrawableVariation(ped,5),GetPedTextureVariation(ped,5) }
    custom[6] = { GetPedDrawableVariation(ped,6),GetPedTextureVariation(ped,6) }
    custom[7] = { GetPedDrawableVariation(ped,7),GetPedTextureVariation(ped,7) }
    custom[8] = { GetPedDrawableVariation(ped,8),GetPedTextureVariation(ped,8) }
    custom[9] = { GetPedDrawableVariation(ped,9),GetPedTextureVariation(ped,9) }
    custom[10] = { GetPedDrawableVariation(ped,10),GetPedTextureVariation(ped,10) }
    custom[11] = { GetPedDrawableVariation(ped,11),GetPedTextureVariation(ped,11) }
    custom["p0"] = { GetPedPropIndex(ped,0),math.max(GetPedPropTextureIndex(ped,0),0) }
    custom["p1"] = { GetPedPropIndex(ped,1),math.max(GetPedPropTextureIndex(ped,1),0) }
    custom["p2"] = { GetPedPropIndex(ped,2),math.max(GetPedPropTextureIndex(ped,2),0) }
    custom["p6"] = { GetPedPropIndex(ped,6),math.max(GetPedPropTextureIndex(ped,6),0) }
    custom["p7"] = { GetPedPropIndex(ped,7),math.max(GetPedPropTextureIndex(ped,7),0) }
    TriggerServerEvent('underground:Roupas_SV', custom) 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNCUFF ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('admcuff')
AddEventHandler('admcuff',function()
	local ped = PlayerPedId()
	if vRP.isHandcuffed() then
		vRP._setHandcuffed(source,false)
		SetPedComponentVariation(PlayerPedId(),7,0,0,2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SYNCAREA ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea",function(x,y,z)
    ClearAreaOfVehicles(x,y,z,2000.0,false,false,false,false,false)
    ClearAreaOfEverything(x,y,z,2000.0,false,false,false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ APAGAO ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cloud:setApagao")
AddEventHandler("cloud:setApagao", function(cond)
    local status = false
    if cond == 1 then
        status = true
    end
    SetBlackout(status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RAIOS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local lightsCounter = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if lightsCounter > 0 then
      lightsCounter = lightsCounter - 1
      CreateLightningThunder()
      Citizen.Wait(2000)
    end
  end
end)

RegisterNetEvent("cloud:raios")
AddEventHandler("cloud:raios", function(vezes)
    lightsCounter = lightsCounter + vezes
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TROCAR SEXO ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinmenu")
AddEventHandler("skinmenu",function(mhash)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(mhash) then
        SetPlayerModel(PlayerId(),mhash)
        SetModelAsNoLongerNeeded(mhash)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SYNCDELETEOBJ ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteobj")
AddEventHandler("syncdeleteobj",function(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToPed(index)
        if DoesEntityExist(v) and IsEntityAnObject(v) then
            Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
            SetEntityAsMissionEntity(v,true,true)
            NetworkRequestControlOfEntity(v)
            Citizen.InvokeNative(0x539E0AE3E6634B9F,Citizen.PointerValueIntInitialized(v))
            DeleteEntity(v)
            DeleteObject(v)
            SetObjectAsNoLongerNeeded(v)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HEADING ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("h",function(source,args)
	TriggerEvent('chatMessage',"HEADING",{255,70,50},GetEntityHeading(PlayerPedId()))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HASH VEICULO ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehash")
AddEventHandler("vehash",function()
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerEvent('chatMessage',"HASH",{255,70,50},GetEntityModel(vehicle))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SPAWNAR VEÍCULO ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('spawnarveiculo')
AddEventHandler('spawnarveiculo',function(name)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mhash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetVehicleIsStolen(nveh,false)
		SetPedIntoVehicle(ped,nveh,-1)
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehRadioStation(nveh,"OFF")

		SetModelAsNoLongerNeeded(mhash)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TELEPORTAR PARA O LOCAL MARCADO ]----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('tptoway')
AddEventHandler('tptoway',function()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped,x,y,height,0,0,1)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(ped) do
			RequestCollisionAtCoord(x,y,z)
			Citizen.Wait(1)
		end
		Citizen.Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(ped) do
		RequestCollisionAtCoord(x,y,z)
		Citizen.Wait(1)
	end

	SetEntityCoordsNoOffset(ped,x,y,z,0,0,1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DELETAR NPCS MORTOS ]----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('delnpcs')
AddEventHandler('delnpcs',function()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			Citizen.InvokeNative(0xAD738C3085FE7E11,ped,true,true)
			TriggerServerEvent("trydeleteped",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TUNING ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehtuning")
AddEventHandler("vehtuning",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleModKit(vehicle,0)
		SetVehicleWheelType(vehicle,7)
		SetVehicleMod(vehicle,0,GetNumVehicleMods(vehicle,0)-1,false)
		SetVehicleMod(vehicle,1,GetNumVehicleMods(vehicle,1)-1,false)
		SetVehicleMod(vehicle,2,GetNumVehicleMods(vehicle,2)-1,false)
		SetVehicleMod(vehicle,3,GetNumVehicleMods(vehicle,3)-1,false)
		SetVehicleMod(vehicle,4,GetNumVehicleMods(vehicle,4)-1,false)
		SetVehicleMod(vehicle,5,GetNumVehicleMods(vehicle,5)-1,false)
		SetVehicleMod(vehicle,6,GetNumVehicleMods(vehicle,6)-1,false)
		SetVehicleMod(vehicle,7,GetNumVehicleMods(vehicle,7)-1,false)
		SetVehicleMod(vehicle,8,GetNumVehicleMods(vehicle,8)-1,false)
		SetVehicleMod(vehicle,9,GetNumVehicleMods(vehicle,9)-1,false)
		SetVehicleMod(vehicle,10,GetNumVehicleMods(vehicle,10)-1,false)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11)-1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12)-1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13)-1,false)
		SetVehicleMod(vehicle,14,16,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15)-2,false)
		SetVehicleMod(vehicle,16,GetNumVehicleMods(vehicle,16)-1,false)
		ToggleVehicleMod(vehicle,17,true)
		ToggleVehicleMod(vehicle,18,true)
		ToggleVehicleMod(vehicle,19,true)
		ToggleVehicleMod(vehicle,20,true)
		ToggleVehicleMod(vehicle,21,true)
		ToggleVehicleMod(vehicle,22,true)
		SetVehicleMod(vehicle,23,1,false)
		SetVehicleMod(vehicle,24,1,false)
		SetVehicleMod(vehicle,25,GetNumVehicleMods(vehicle,25)-1,false)
		SetVehicleMod(vehicle,27,GetNumVehicleMods(vehicle,27)-1,false)
		SetVehicleMod(vehicle,28,GetNumVehicleMods(vehicle,28)-1,false)
		SetVehicleMod(vehicle,30,GetNumVehicleMods(vehicle,30)-1,false)
		SetVehicleMod(vehicle,33,GetNumVehicleMods(vehicle,33)-1,false)
		SetVehicleMod(vehicle,34,GetNumVehicleMods(vehicle,34)-1,false)
		SetVehicleMod(vehicle,35,GetNumVehicleMods(vehicle,35)-1,false)
		SetVehicleMod(vehicle,38,GetNumVehicleMods(vehicle,38)-1,true)
		SetVehicleTyreSmokeColor(vehicle,0,0,0)
        SetVehicleWindowTint(vehicle,1)
        SetVehicleTyresCanBurst(vehicle,false)
        SetVehicleNumberPlateText(vehicle,"ZIRIX")
        SetVehicleNumberPlateTextIndex(vehicle,5)
        SetVehicleModColor_1(vehicle,0,0,0)
        SetVehicleModColor_2(vehicle,0,0)
        SetVehicleColours(vehicle,0,0)
        SetVehicleExtraColours(vehicle,0,0)
        SetVehicleNeonLightEnabled(vehicle,0,true)
        SetVehicleNeonLightEnabled(vehicle,1,true)
        SetVehicleNeonLightEnabled(vehicle,2,true)
        SetVehicleNeonLightEnabled(vehicle,3,true)
        SetVehicleNeonLightsColour(vehicle,0,0,0)
	end
end)
------------------------------------------------------------------------------------------------------------------------------
--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local dickheaddebug = false

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent("ToggleDebug")
AddEventHandler("ToggleDebug",function()
	dickheaddebug = not dickheaddebug
    if dickheaddebug then
        TriggerEvent('chatMessage',"DEBUG",{255,70,50},"ON")
    else
        TriggerEvent('chatMessage',"DEBUG",{255,70,50},"OFF")
    end
end)

local inFreeze = false

function GetVehicle()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           -- FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

Citizen.CreateThread( function()

    while true do 
        
        Citizen.Wait(1)
        
        if dickheaddebug then
            local pos = GetEntityCoords(GetPlayerPed(-1))

            local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    

            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxtS(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxtS(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(GetPlayerPed(-1)), 55, 155, 55, 255)
            drawTxtS(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxtS(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
            
            
            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    --TriggerEvent("DoShortHudText",'Freeze Disabled',3)
                    vRP.notify("Freeze Disabled")
                else
                    inFreeze = true             
                    --TriggerEvent("DoShortHudText",'Freeze Enabled',3)
                    vRP.notify("Freeze Enabled")
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

function drawTxtS(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end