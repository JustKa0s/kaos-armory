--[[
███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░

░░░░░██╗██╗░░░██╗░██████╗████████╗██╗░░██╗░█████╗░░█████╗░░██████╗  
░░░░░██║██║░░░██║██╔════╝╚══██╔══╝██║░██╔╝██╔══██╗██╔══██╗██╔════╝
░░░░░██║██║░░░██║╚█████╗░░░░██║░░░█████═╝░███████║██║░░██║╚█████╗░
██╗░░██║██║░░░██║░╚═══██╗░░░██║░░░██╔═██╗░██╔══██║██║░░██║░╚═══██╗
╚█████╔╝╚██████╔╝██████╔╝░░░██║░░░██║░╚██╗██║░░██║╚█████╔╝██████╔╝
░╚════╝░░╚═════╝░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═════╝░

░░░██╗░██╗░░█████╗░░█████╗░███████╗░█████╗░
██████████╗██╔══██╗██╔══██╗╚════██║██╔══██╗
╚═██╔═██╔═╝╚██████║╚██████║░░░░██╔╝╚██████║
██████████╗░╚═══██║░╚═══██║░░░██╔╝░░╚═══██║
╚██╔═██╔══╝░█████╔╝░█████╔╝░░██╔╝░░░█████╔╝
░╚═╝░╚═╝░░░░╚════╝░░╚════╝░░░╚═╝░░░░╚════╝░
--]]


show = false
isPolice = true
isinuse = false


RegisterNetEvent('GetState')
AddEventHandler('GetState', function(state)
	isinuse = state
end)

RegisterNetEvent('SpawnPed')
AddEventHandler('SpawnPed', function()
    while not NetworkIsSessionStarted() do Wait(0) end
	local Location = Config.ArmoryPed
	local lmodel = GetHashKey(Location["hash"])
    cop = createPed(lmodel, Location["x"], Location["y"], Location["z"] - 0.985, Location["h"], false)  
	FreezeEntityPosition(cop, true) 
	SetEntityHeading(cop, Location["h"])
end) 




Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Armory["x"], Config.Armory["y"], Config.Armory["z"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				local text = "~b~Arsenal"

				if dstCheck <= 0.5 then
					if isPolice then
					text = "[~g~E~s~] ~y~Hent en pistol"
					if isinuse then
					text = "~r~Allerede i brug"
				end
				
					if IsControlJustPressed(1, 38) and not isinuse then
						openGui()
						isinuse = true
				end
				else 
				text = "~r~Du har ikke adgang"
			    end
			end
			DrawText3Ds(Config.Armory["x"], Config.Armory["y"], Config.Armory["z"], text)
			end
		Citizen.Wait(sleepThread)
	end
end)


function openGui()
	if show == false then
	  SetNuiFocus(true, true)
	  SendNUIMessage({
		show = true,
	  })
	end
  end

  function closeGui()
	show = false
	SetNuiFocus(false)
	SendNUIMessage({show = false})
  end
  
  AddEventHandler(
	"onResourceStop",
	function(resource)
	  if resource == GetCurrentResourceName() then
		closeGui()
	  end
	end
  )

RegisterNUICallback("close", function(data)
	closeGui()
	isinuse = false
end)

RegisterNUICallback("giveWeapon", function(data)
	DoAnim("pistol", Config.Weapons[data.WeaponID + 1].weaponModel)
end)
RegisterNUICallback("getConfigs", function(data, cb)
	cb(Config.Weapons)
  end)

  DoAnim = function(type, hash)
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {}

	local Location = Config.Armory
	local PedLocation = Config.ArmoryPed

		local anim = type
		local weaponHash = hash

		if not NetworkHasControlOfEntity(cop) then
			NetworkRequestControlOfEntity(cop)

			Citizen.Wait(1000)
		end

		SetEntityCoords(cop, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(cop, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })


		if DoesEntityExist(cop) then
			TaskPlayAnim(cop, animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(1100)

			GiveWeaponToPed(cop, GetHashKey(weaponHash), 1, false, true)
			SetCurrentPedWeapon(cop, GetHashKey(weaponHash), true)

			TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
			time = 5
			Citizen.Wait(3100)

			RemoveWeaponFromPed(cop, GetHashKey(weaponHash))

			Citizen.Wait(15)

			GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponHash), Config.ReceiveAmmo, false, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponHash), true)

			ClearPedTasks(cop)
		end
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		Citizen.Wait(10000)
		DisableControlAction(0, 48, false)
		DisableControlAction(0, 20, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        TriggerServerEvent('SetState', isinuse)
    end
end)

local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

UnloadModels = function()
	for modelIndex = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end

		table.remove(CachedModels, modelIndex)
	end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

createPed = function(hash, coords, heading, networked)
    while not HasModelLoaded(hash) do Wait(0) RequestModel(hash) end
    local ped = CreatePed(4, hash, coords, heading, networked, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end
