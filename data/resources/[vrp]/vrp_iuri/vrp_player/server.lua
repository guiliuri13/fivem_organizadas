local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
src = {}
Tunnel.bindInterface("vrp_player",src)
vDIAGNOSTIC = Tunnel.getInterface("vrp_diagnostic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhooklog_garmas = ""
local webhooklog_garmashack = ""
local webhooklog_enviar_dinheiro = ""
local webhooklog_roubar = ""
local webhooklog_paypal = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkRoupas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"roupas") >= 1 or vRP.hasPermission(user_id,"platina.permissao") then
			return true 
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uservehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
        	local nuser_id = parseInt(args[1])
            if nuser_id > 0 then 
                local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(nuser_id) })
                local car_names = {}
                for k,v in pairs(vehicle) do
                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b>")
                    --TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle,10000)
                end
                car_names = table.concat(car_names, ", ")
                local identity = vRP.getUserIdentity(nuser_id)
                TriggerClientEvent("Notify",source,"importante","Veículos de <b>"..identity.name.." " .. identity.firstname.. " ("..#vehicle..")</b>: "..car_names,10000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /REVISTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('revistar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local identity = vRP.getUserIdentity(user_id)
		local weapons = vRPclient.getWeapons(nplayer)
		local money = vRP.getMoney(nuser_id)
		local data = vRP.getUserDataTable(nuser_id)

		TriggerClientEvent('cancelando',source,true)
		TriggerClientEvent('cancelando',nplayer,true)
		TriggerClientEvent('carregar',nplayer,source)
		--vRPclient._playAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
		vRPclient._playAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
		TriggerClientEvent("progress",source,5000,"revistando")
		SetTimeout(5000,function()

			TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5M O C H I L A^4  - - - - - - - - - - - - - - - - - - - - - - - - - - -  [  ^3"..string.format("%.2f",vRP.getInventoryWeight(nuser_id)).."kg^4  /  ^3"..string.format("%.2f",vRP.getInventoryMaxWeight(nuser_id)).."kg^4  ]  - -")
			if data and data.inventory then
				for k,v in pairs(data.inventory) do
					TriggerClientEvent('chatMessage',source,"",{},"     "..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(k))
				end
			end
			TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5E Q U I P A D O^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
			for k,v in pairs(weapons) do
				if v.ammo < 1 then
					TriggerClientEvent('chatMessage',source,"",{},"     1x "..vRP.itemNameList("wbody|"..k))
				else
					TriggerClientEvent('chatMessage',source,"",{},"     1x "..vRP.itemNameList("wbody|"..k).." | "..vRP.format(parseInt(v.ammo)).."x Munições")
				end
			end

			--vRPclient._stopAnim(source,false)
			vRPclient._stopAnim(nplayer,false)
			TriggerClientEvent('cancelando',source,false)
			TriggerClientEvent('cancelando',nplayer,false)
			TriggerClientEvent('carregar',nplayer,source)
			TriggerClientEvent('chatMessage',source,"",{},"     $"..vRP.format(parseInt(money)).." Dólares")
		end)
		TriggerClientEvent("Notify",nplayer,"aviso","Você está sendo <b>Revistado</b>.")
		--TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
local salarios = {
	{ ['permissao'] = "platina.permissao", ['nome'] = "VIP Platina", ['payment'] = 10000 },
	{ ['permissao'] = "ouro.permissao", ['nome'] = "VIP Ouro", ['payment'] = 8000 },
	{ ['permissao'] = "prata.permissao", ['nome'] = "VIP Prata", ['payment'] = 6000 },
	{ ['permissao'] = "bronze.permissao", ['nome'] = "VIP Bronze", ['payment'] = 4000 },

	{ ['permissao'] = "policia3.permissao", ['nome'] = "Policia: 3", ['payment'] = 7000 },
	{ ['permissao'] = "policia2.permissao", ['nome'] = "Policia: 2", ['payment'] = 5000 },
	{ ['permissao'] = "policia1.permissao", ['nome'] = "Policia: 1", ['payment'] = 3000 },
	
	{ ['permissao'] = "paramedico3.permissao", ['nome'] = "Paramédico: 3", ['payment'] = 7000 },
	{ ['permissao'] = "paramedico2.permissao", ['nome'] = "Paramédico: 2", ['payment'] = 5000 },
	{ ['permissao'] = "paramedico1.permissao", ['nome'] = "Paramédico: 1", ['payment'] = 3000 },
	
	{ ['permissao'] = "mecanico3.permissao", ['nome'] = "Mecânico: 3", ['payment'] = 5000 },
	{ ['permissao'] = "mecanico2.permissao", ['nome'] = "Mecânico: 2", ['payment'] = 3000 },
	{ ['permissao'] = "mecanico1.permissao", ['nome'] = "Mecânico: 1", ['payment'] = 2000 },
	
	{ ['permissao'] = "juiz.permissao", ['nome'] = "Juiz", ['payment'] = 6000 },
	{ ['permissao'] = "advogado.permissao", ['nome'] = "Advogado", ['payment'] = 3000 }
}

RegisterServerEvent('salario:pagamento')
AddEventHandler('salario:pagamento',function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(salarios) do
			if vRP.hasPermission(user_id,v.permissao) then
				TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				TriggerClientEvent("Notify",source,"importante","Seu salário de <b>$"..vRP.format(parseInt(v.payment)).." dólares</b> foi depositado.")
				vRP.giveBankMoney(user_id,parseInt(v.payment))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCARJACK
-----------------------------------------------------------------------------------------------------------------------------------------
local veiculos = {}
RegisterServerEvent("TryDoorsEveryone")
AddEventHandler("TryDoorsEveryone",function(veh,doors,placa)
	if not veiculos[placa] then
		TriggerClientEvent("SyncDoorsEveryone",-1,veh,doors)
		veiculos[placa] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AFKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("kickAFK")
AddEventHandler("kickAFK",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"platina.permissao") then
        DropPlayer(source,"Voce foi desconectado por ficar ausente.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEQUESTRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sequestro',function(source,args,rawCommand)
	local nplayer = vRPclient.getNearestPlayer(source,5)
	if nplayer then
		if vRPclient.isHandcuffed(nplayer) then
			if not vRPclient.getNoCarro(source) then
				local vehicle = vRPclient.getNearestVehicle(source,7)
				if vehicle then
					if vRPclient.getCarroClass(source,vehicle) then
						vRPclient.setMalas(nplayer)
					end
				end
			elseif vRPclient.isMalas(nplayer) then
				vRPclient.setMalas(nplayer)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","A pessoa precisa estar algemada para colocar ou retirar do Porta-Malas.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRATAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tratamento',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"paramedico.permissao") then
        local nplayer = vRPclient.getNearestPlayer(source,3)
        if nplayer then
            if not vRPclient.isComa(nplayer) then
                TriggerClientEvent("tratamento",nplayer)
                TriggerClientEvent("Notify",source,"sucesso","Tratamento no paciente iniciado com sucesso.",10000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reparar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local mPlaca = vRPclient.ModelName(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	if mPlaca then
		if not vRPclient.isInVehicle(source) then
			if vRP.hasPermission(user_id,"mecanico.permissao") then
				if user_id ~= mPlacaUser then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
					TriggerClientEvent("progress",source,30000,"reparando")
					SetTimeout(30000,function()
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('reparar',source)
						vRPclient._stopAnim(source,false)
					end)
				else
					TriggerClientEvent("Notify",source,"aviso","Não pode efetuar reparos em seu próprio veículo.")
				end
			else
				if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
					TriggerClientEvent("progress",source,30000,"reparando")
					SetTimeout(30000,function()
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('reparar',source)
						vRPclient._stopAnim(source,false)
					end)
				else
					TriggerClientEvent("Notify",source,"negado","Precisa de um <b>Kit de Reparos</b> para reparar o motor.")
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Precisa estar próximo ou fora do veículo para efetuar os reparos.")
		end
	end
end)

RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	TriggerClientEvent("syncreparar",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('motor',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local mPlaca = vRPclient.ModelName(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	if mPlaca then
		if not vRPclient.isInVehicle(source) then
			if vRP.hasPermission(user_id,"mecanico.permissao") then
				if user_id ~= mPlacaUser then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
					TriggerClientEvent("progress",source,30000,"reparando")
					SetTimeout(30000,function()
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('repararmotor',source)
						vRPclient._stopAnim(source,false)
					end)
				else
					TriggerClientEvent("Notify",source,"aviso","Não pode efetuar reparos em seu próprio veículo.")
				end
			else
				if vRP.tryGetInventoryItem(user_id,"militec",1) then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
					TriggerClientEvent("progress",source,30000,"reparando")
					SetTimeout(30000,function()
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('repararmotor',source)
						vRPclient._stopAnim(source,false)
					end)
				else
					TriggerClientEvent("Notify",source,"negado","Precisa de um <b>Militec-1</b> para reparar o motor.")
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Precisa estar próximo ou fora do veículo para efetuar os reparos.")
		end
	end
end)

RegisterServerEvent("trymotor")
AddEventHandler("trymotor",function(nveh)
	TriggerClientEvent("syncmotor",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('enviar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	local identity = vRP.getUserIdentity(user_id)
  	local identitynu = vRP.getUserIdentity(nuser_id)
	if nuser_id and parseInt(args[1]) > 0 then
		if vRP.tryPayment(user_id,parseInt(args[1])) then
			vRP.giveMoney(nuser_id,parseInt(args[1]))
			vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
			TriggerClientEvent("Notify",source,"sucesso","Enviou <b>$"..vRP.format(parseInt(args[1])).." dólares</b>.",8000)
			vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
			TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>$"..vRP.format(parseInt(args[1])).." dólares</b>.",8000)
			SendWebhookMessage(webhooklog_enviar_dinheiro,"```ini\n[ID]: "..user_id.." - "..identity.name.." "..identity.firstname.." \n[ENVIOU]: $"..vRP.format(parseInt(args[1])).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			TriggerClientEvent("Notify",source,"negado","Não tem a quantia que deseja enviar.",8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('garmas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local weapons = vRPclient.replaceWeapons(source,{})
		for k,v in pairs(weapons) do

								SetTimeout(11000, function()
								vRP.giveInventoryItem(user_id,"wbody|"..k,1)
							end)

								if v.ammo > 0 then
									SetTimeout(11000, function()
									vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
								end)
							end

			SendWebhookMessage(webhooklog_garmas,"```ini\n[ID]: "..user_id.." - "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.itemNameList("wbody|"..k).." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			
			if v.ammo == 250 then 
				SendWebhookMessage(webhooklog_garmashack,"```ini\n[ID]: "..user_id.." - "..identity.name.." "..identity.firstname.." \n[TENTOU USAR MONSTERMENU E FOI PEGO NO PULO] \n>>>> [GUARDOU]: "..vRP.itemNameList("wbody|"..k).." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```<@&641048265856647169>")
			end
		end

		local msg = 'Suas armas serão desequipadas em'
		local msgseconds = 'segundos.'
		local notifytype = 'aviso'


		TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 10 </b>"..msgseconds.."")

		SetTimeout(1000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 9 </b>"..msgseconds.."")
		end)

		SetTimeout(2000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 8 </b>"..msgseconds.."")
		end)

		SetTimeout(3000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 7 </b>"..msgseconds.."")
		end)

		SetTimeout(4000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 6 </b>"..msgseconds.."")
		end)

		SetTimeout(5000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 5 </b>"..msgseconds.."")
		end)

		SetTimeout(6000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 4 </b>"..msgseconds.."")
		end)

		SetTimeout(7000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 3 </b>"..msgseconds.."")
		end)

		SetTimeout(8000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 2 </b>"..msgseconds.."")
		end)

		SetTimeout(9000, function()
			TriggerClientEvent("Notify", source, ""..notifytype.."", ""..msg.."<b> 1 </b>"..msgseconds.."")
		end)

		SetTimeout(11000, function()
			TriggerClientEvent("Notify", source, "sucesso", "Suas armas foram guardadas em sua <b>mochila</b>.")
		end)

	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('roubar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		local nuser_id = vRP.getUserId(nplayer)
		local policia = vRP.getUsersByPermission("policia.permissao")
		local itens_roubados = {}
		if #policia > 0 then
			if vRP.request(nplayer,"Você está sendo roubado, deseja passar tudo?",30) then
				local vida = vRPclient.getHealth(nplayer)
				if vida <= 100 then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@medic@standing@kneel@idle_a","idle_a"}},true)
					TriggerClientEvent("progress",source,30000,"roubando")
					SetTimeout(30000,function()
						local ndata = vRP.getUserDataTable(nuser_id)
						if ndata ~= nil then
							if ndata.inventory ~= nil then
								for k,v in pairs(ndata.inventory) do
									if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(k)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
										if vRP.tryGetInventoryItem(nuser_id,k,v.amount) then
											vRP.giveInventoryItem(user_id,k,v.amount)
											table.insert(itens_roubados, "[ITEM]: "..vRP.itemNameList(k).." [QUANTIDADE]: "..v.amount)
										end
									else
										TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(k).."</b> por causa do peso.")
									end
								end
							end
						end
						local weapons = vRPclient.replaceWeapons(nplayer,{})
						for k,v in pairs(weapons) do
							vRP.giveInventoryItem(nuser_id,"wbody|"..k,1)
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wbody|"..k) <= vRP.getInventoryMaxWeight(user_id) then
								if vRP.tryGetInventoryItem(nuser_id,"wbody|"..k,1) then
									vRP.giveInventoryItem(user_id,"wbody|"..k,1)
								end
							else
								TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>1x "..vRP.itemNameList("wbody|"..k).."</b> por causa do peso.")
							end
							if v.ammo > 0 then
								vRP.giveInventoryItem(nuser_id,"wammo|"..k,v.ammo)
								if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|"..k)*v.ammo <= vRP.getInventoryMaxWeight(user_id) then
									if vRP.tryGetInventoryItem(nuser_id,"wammo|"..k,v.ammo) then
										vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.ammo)).."x "..vRP.itemNameList("wammo|"..k).."</b> por causa do peso.")
								end
							end
						end
						local nmoney = vRP.getMoney(nuser_id)
						if vRP.tryPayment(nuser_id,nmoney) then
							vRP.giveMoney(user_id,nmoney)
						end
						vRPclient.setStandBY(source,parseInt(600))
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent("Notify",source,"importante","Roubo concluido com sucesso.")
					end)
				else
					local ndata = vRP.getUserDataTable(nuser_id)
					if ndata ~= nil then
						if ndata.inventory ~= nil then
							for k,v in pairs(ndata.inventory) do
								if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(k)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
									if vRP.tryGetInventoryItem(nuser_id,k,v.amount) then
										vRP.giveInventoryItem(user_id,k,v.amount)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(k).."</b> por causa do peso.")
								end
							end
						end
					end
					local weapons = vRPclient.replaceWeapons(nplayer,{})
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(nuser_id,"wbody|"..k,1)
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wbody|"..k) <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.tryGetInventoryItem(nuser_id,"wbody|"..k,1) then
								vRP.giveInventoryItem(user_id,"wbody|"..k,1)
								table.insert(itens_roubados, "[ITEM]: "..vRP.itemNameList("wbody|"..k).." [QUANTIDADE]: "..1)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>1x "..vRP.itemNameList("wbody|"..k).."</b> por causa do peso.")
						end
						if v.ammo > 0 then
							vRP.giveInventoryItem(nuser_id,"wammo|"..k,v.ammo)
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|"..k)*v.ammo <= vRP.getInventoryMaxWeight(user_id) then
								if vRP.tryGetInventoryItem(nuser_id,"wammo|"..k,v.ammo) then
									vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
									table.insert(itens_roubados, "[ITEM]: "..vRP.itemNameList("wammo|"..k).." [QTD]: "..v.ammo)
								end
							else
								TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.ammo)).."x "..vRP.itemNameList("wammo|"..k).."</b> por causa do peso.")
							end
						end
					end
					local nmoney = vRP.getMoney(nuser_id)
					if vRP.tryPayment(nuser_id,nmoney) then
						vRP.giveMoney(user_id,nmoney)
					end
					vRPclient.setStandBY(source,parseInt(600))
					local apreendidos = table.concat(itens_roubados, "\n")
					TriggerClientEvent("Notify",source,"sucesso","Roubo concluido com sucesso.")
					SendWebhookMessage(webhooklog_roubar,"```ini\n[ID]: "..user_id.." "..identity_user.name.." "..identity_user.firstname.."\n[ROUBOU]: "..nuser_id.." "..nidentity.name.." " ..nidentity.firstname .. "\n" .. apreendidos ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			else
				TriggerClientEvent("Notify",source,"importante","A pessoa está resistindo ao roubo.")
			end
		else
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytow")
AddEventHandler("trytow",function(nveh,rveh)
	TriggerClientEvent("synctow",-1,nveh,rveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytrunk")
AddEventHandler("trytrunk",function(nveh)
	TriggerClientEvent("synctrunk",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trywins")
AddEventHandler("trywins",function(nveh)
	TriggerClientEvent("syncwins",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryhood")
AddEventHandler("tryhood",function(nveh)
	TriggerClientEvent("synchood",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydoors")
AddEventHandler("trydoors",function(nveh,door)
	TriggerClientEvent("syncdoors",-1,nveh,door)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALL ADM
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
RegisterCommand('call',function(source,args,rawCommand)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	vida = vRPclient.getHealth(source)
	vRPclient._CarregarObjeto(source,"cellphone@","cellphone_call_to_text","prop_amb_phone",50,28422)
	if user_id then
		local descricao = vRP.prompt(source,"Descrição:","")
		if descricao == "" then
			vRPclient._stopAnim(source,false)
			vRPclient._DeletarObjeto(source)
			return
		end

		local x,y,z = vRPclient.getPosition(source)
		local players = {}
		vRPclient._stopAnim(source,false)
		vRPclient._DeletarObjeto(source)
		local especialidade = false
		if args[1] == "adm" then
			players = vRP.getUsersByPermission("staff.permissao")	
			especialidade = "Administradores"
		end
		local adm = ""
		if especialidade == "Administradores" then
			adm = "[ADM] "
		end
		
		vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		if #players == 0  and especialidade ~= "policiais" then
			TriggerClientEvent("Notify",source,"importante","Não há "..especialidade.." em serviço.")
		else
			local identitys = vRP.getUserIdentity(user_id)
			TriggerClientEvent("Notify",source,"sucesso","Chamado enviado com sucesso.")
			for l,w in pairs(players) do
				local player = vRP.getUserSource(parseInt(w))
				local nuser_id = vRP.getUserId(player)
				if player and player ~= uplayer then
					async(function()
						vRPclient.playSound(player,"Out_Of_Area","DLC_Lowrider_Relay_Race_Sounds")
						TriggerClientEvent('chatMessage',player,"CHAMADO",{19,197,43},adm.."Enviado por ^1"..identitys.name.." "..identitys.firstname.."^0 ["..user_id.."], "..descricao)
						local ok = vRP.request(player,"Aceitar o chamado de <b>"..identitys.name.." "..identitys.firstname.."</b>?",30)
						if ok then
							if not answered then
								answered = true
								local identity = vRP.getUserIdentity(nuser_id)
								TriggerClientEvent("Notify",source,"importante","Chamado atendido por <b>"..identity.name.." "..identity.firstname.."</b>, aguarde no local.")
								vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
								vRPclient._setGPS(player,x,y)
							else
								TriggerClientEvent("Notify",player,"importante","Chamado já foi atendido por outra pessoa.")
								vRPclient.playSound(player,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
							end
						end
						local id = idgens:gen()
						blips[id] = vRPclient.addBlip(player,x,y,z,358,71,"Chamado",0.6,false)
						SetTimeout(300000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMITCALLER
-----------------------------------------------------------------------------------------------------------------------------------------
local blipsCaller = {}
RegisterServerEvent("vrp_player:submitCaller")
AddEventHandler("vrp_player:submitCaller",function(work,message)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local tipochamado = ""
	if user_id then
	
		local players = {}
		if work == "policia" then
			players = vRP.getUsersByPermission("policia.permissao")
			tipochamado =  "Policia: "
		elseif work == "paramedico" then
			players = vRP.getUsersByPermission("paramedico.permissao")
			tipochamado =  "Paramédico: "
		elseif work == "juiz" then
			players = vRP.getUsersByPermission("juiz.permissao")
			tipochamado =  "Jurídico: "
		elseif work == "mec" then
			players = vRP.getUsersByPermission("mecanico.permissao")
			tipochamado =  "Mec: "
		elseif work == "advogado" then
			players = vRP.getUsersByPermission("advogado.permissao")
			tipochamado =  "Advogado: "
		end

		TriggerClientEvent("Notify",source,"sucesso","Chamado enviado com sucesso.",10000)

		for k,v in pairs(players) do
			local player = vRP.getUserSource(parseInt(v))
			local nuser_id = vRP.getUserId(player)
			local x,y,z = vRPclient.getPosition(source)
			local uplayer = vRP.getUserSource(user_id)
			local identitys = vRP.getUserIdentity(user_id)
			local identity = vRP.getUserIdentity(nuser_id)
			if player and player ~= uplayer then
				async(function()
					vRPclient.playSound(player,"Out_Of_Area","DLC_Lowrider_Relay_Race_Sounds")
					TriggerClientEvent('chatMessage',player,tipochamado.."CHAMADO",{19,197,43},"Enviado por ^1"..identitys.name.." "..identitys.firstname.."^0, "..message)
					local ok = vRP.request(player,tipochamado .. "Aceitar o chamado de <b>"..identitys.name.." "..identitys.firstname.."</b>?",30)
					if ok then
						if not answered then
							answered = true
							TriggerClientEvent("Notify",source,"importante","Chamado atendido por <b>"..identity.name.." "..identity.firstname.."</b>, aguarde no local.",20000)

							vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")							
							vRPclient._setGPS(player,x,y)
						else
							TriggerClientEvent("Notify",player,"negado","Chamado já foi atendido por outra pessoa.",10000)
							vRPclient.playSound(player,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
						end
					end
					local id = idgens:gen()
					blipsCaller[id] = vRPclient.addBlip(player,x,y,z,358,71,"Chamado",0.6,false)
					SetTimeout(3*60000,function()
						idgens:free(id)
						vRPclient.removeBlip(player,blipsCaller[id])
						blipsCaller[id] = nil
					end)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("toggleService")
AddEventHandler("toggleService",function()
	local source = source
	local user_id = vRP.getUserId(source)

	----- Policia -----

	if vRP.hasPermission(user_id,"policia3.permissao") then
		vRP.addUserGroup(user_id,"Policia3-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"policia3-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Policia3")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"policia2.permissao") then
		vRP.addUserGroup(user_id,"Policia2-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"policia2-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Policia2")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"policia1.permissao") then
		vRP.addUserGroup(user_id,"Policia1-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"policia1-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Policia1")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)

	----- Hospital -----

	elseif vRP.hasPermission(user_id,"paramedico3.permissao") then
		vRP.addUserGroup(user_id,"Paramedico3-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"paramedico3-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Paramedico3")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"paramedico2.permissao") then
		vRP.addUserGroup(user_id,"Paramedico2-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"paramedico2-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Paramedico2")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"paramedico1.permissao") then
		vRP.addUserGroup(user_id,"Paramedico1-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"paramedico1-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Paramedico1")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)

	----- Mecânico -----

	elseif vRP.hasPermission(user_id,"mecanico3.permissao") then
		vRP.addUserGroup(user_id,"Mecanico3-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"mecanico3-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Mecanico3")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"mecanico2.permissao") then
		vRP.addUserGroup(user_id,"Mecanico2-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"mecanico2-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Mecanico2")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
		
	elseif vRP.hasPermission(user_id,"mecanico1.permissao") then
		vRP.addUserGroup(user_id,"Mecanico1-ForaDeServico")
		TriggerClientEvent("Notify",source,"negado","Você saiu de serviço.",8000)
	elseif vRP.hasPermission(user_id,"mecanico1-foradeservico.permissao") then
		vRP.addUserGroup(user_id,"Mecanico1")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"polpar.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer == nil then
				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..vRP.format(args[1]).."</b> indisponível no momento.")
				return
			end
			nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,0,0,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #ff0000; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		else
			local nplayer = vRPclient.getNearestPlayer(source,2)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identityv = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				TriggerClientEvent("Notify",nplayer,"importante","Seu documento está sendo verificado por <b>"..identityv.name.." "..identityv.firstname.."</b>.")
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,0,0,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #ff0000; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('idp',function(source,rawCommand)	
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local identity = vRP.getUserIdentity(nuser_id)
		vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,0,0,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #ff0000; }","<div class=\"local\"><b>Passaporte:</b> ( "..vRP.format(identity.user_id).." )</div>")
		vRP.request(source,"Você deseja fechar o registro geral?",1000)
		vRPclient.removeDiv(source,"completerg")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('911',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"juiz.permissao") or vRP.hasPermission(user_id,"advogado.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"[Polícia] " ..identity.name.." "..identity.firstname,{64,64,255},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 112
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('112',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"paramedico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"[Paramédico] " ..identity.name.." "..identity.firstname,{255,70,135},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIOMEC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('anunciomec',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"Central Mecânica",{255,128,0},rawCommand:sub(12))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MCC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mcc',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "mecanico.permissao"
		if vRP.hasPermission(user_id,permission) then
			local mec = vRP.getUsersByPermission(permission)
			for l,w in pairs(mec) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"[Mecânico - Chat] "..identity.name.. " "..identity.firstname.." ",{255,191,128},rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PDC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pdc',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "policia.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"[Polícia - Chat] "..identity.name.. " "..identity.firstname.." ",{64,179,255},rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('prc',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "paramedico.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"[Paramédico - Chat] "..identity.name.. " "..identity.firstname.." ",{255,175,175},rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STAFF CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sc',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "staff.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"[STAFF CHAT] "..identity.name.. " "..identity.firstname.." ",{255,0,255},rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cc',function(source)
	local user_id = vRP.getUserId(source);
		if user_id ~= nil then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("chat:clear",-1);
		else
			TriggerClientEvent("chat:clear",source);
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatMe')
AddEventHandler('ChatMe',function(text)
    local user_id = vRP.getUserId(source)
    if user_id then
        TriggerClientEvent('DisplayMe',-1,text,source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmascara",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /blusa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('blusa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setblusa",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /colete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('colete',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcolete",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /jaqueta
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('jaqueta',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setjaqueta",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmaos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /calca
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('calca',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcalca",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /acessorios
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('acessorios',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setacessorios",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sapatos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sapatos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setsapatos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /chapeu
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('chapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setchapeu",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /oculos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('oculos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setoculos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
local roupas = {
    ["mecanico"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 12,0 },
			[4] = { 39,0 },
			[5] = { -1,0 },
			[6] = { 24,0 },
			[7] = { 109,0 },
			[8] = { 89,0 },
			[9] = { 14,0 },
			[10] = { -1,0 },
			[11] = { 66,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 38,0 },
			[5] = { -1,0 },
			[6] = { 24,0 },
			[7] = { 2,0 },
			[8] = { 56,0 },
			[9] = { 35,0 },
			[10] = { -1,0 },
			[11] = { 59,0 }
		}
	},
	["minerador"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 99,1 },
			[4] = { 89,20 },
			[5] = { -1,0 },
			[6] = { 82,2 },
			[7] = { -1,0 },
			[8] = { 90,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 273,0 },
			["p1"] = { 23,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 114,1 },
			[4] = { 92,20 },
			[5] = { -1,0 },
			[6] = { 86,2 },
			[7] = { -1,0 },
			[8] = { 54,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 286,0 },
			["p1"] = { 25,0 }
		}
	},
    ["lixeiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 17,0 },
			[4] = { 36,0 },
			[5] = { -1,0 },
			[6] = { 27,0 },
			[7] = { -1,0 },
			[8] = { 59,0 },
			[10] = { -1,0 },
			[11] = { 57,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 18,0 },
			[4] = { 35,0 },
			[5] = { -1,0 },
			[6] = { 26,0 },
			[7] = { -1,0 },
			[8] = { 36,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 50,0 }
		}
	},
	["carteiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 17,10 },
			[5] = { 40,0 },
			[6] = { 7,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 242,3 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 14,1 },
			[5] = { 40,0 },
			[6] = { 10,1 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 250,3 }
		}
	},
	["fazendeiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 37,0 },
			[4] = { 7,0 },
			[5] = { -1,0 },
			[6] = { 15,6 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 95,2 },
			["p0"] = { 105,23 },
			["p1"] = { 5,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 45,0 },
			[4] = { 25,10 },
			[5] = { -1,0 },
			[6] = { 21,1 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 171,4 },
			["p0"] = { 104,23 },
			["p1"] = { 11,2 }
		}
	},
	["lenhador"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 62,0 },
			[4] = { 89,23 },
			[5] = { -1,0 },
			[6] = { 12,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 15,0 },
			["p0"] = { 77,13 },
			["p1"] = { 23,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 71,0 },
			[4] = { 92,23 },
			[5] = { -1,0 },
			[6] = { 69,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 15,0 },
			["p1"] = { 25,0 }
		}
	},
	["taxista"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 11,0 },
			[4] = { 35,0 },
			[5] = { -1,0 },
			[6] = { 10,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 13,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 112,0 },
			[5] = { -1,0 },
			[6] = { 6,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 27,0 }
		}
	},
	["caminhoneiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 63,0 },
			[5] = { -1,0 },
			[6] = { 27,0 },
			[7] = { -1,0 },
			[8] = { 81,0 },
			[10] = { -1,0 },
			[11] = { 173,3 },
			["p1"] = { 8,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 74,5 },
			[5] = { -1,0 },
			[6] = { 9,0 },
			[7] = { -1,0 },
			[8] = { 92,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 175,3 },
			["p1"] = { 11,0 }
		}
	},
	["motocross"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 111,0 },
			[4] = { 67,3 },
			[5] = { -1,0 },
			[6] = { 47,3 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 152,0 },
			["p1"] = { 25,5 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 128,0 },
			[4] = { 69,3 },
			[5] = { -1,0 },
			[6] = { 48,3 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 149,0 },
			["p1"] = { 27,5 }
		}
	},
	["mergulho"] = {
		[1885233650] = {
			[1] = { 122,0 },
			[3] = { 31,0 },
			[4] = { 94,0 },
			[5] = { -1,0 },
			[6] = { 67,0 },
			[7] = { -1,0 },
			[8] = { 123,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 243,0 },			
			["p0"] = { -1,0 },
			["p1"] = { 26,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 122,0 },
			[3] = { 18,0 },
			[4] = { 97,0 },
			[5] = { -1,0 },
			[6] = { 70,0 },
			[7] = { -1,0 },
			[8] = { 153,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 251,0 },
			["p0"] = { -1,0 },
			["p1"] = { 28,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["pelado"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 21,0 },
			[5] = { -1,0 },
			[6] = { 34,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 15,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 21,0 },
			[5] = { -1,0 },
			[6] = { 35,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 82,0 }
		}
	},
	["paciente"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 61,0 },
			[5] = { -1,0 },
			[6] = { 16,0 },
			[7] = { -1,0 },			
			[8] = { 15,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 104,0 },			
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 57,0 },
			[5] = { -1,0 },
			[6] = { 16,0 },
			[7] = { -1,0 },		
			[8] = { 7,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 105,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["gesso"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[3] = { 1,0 },
			[4] = { 84,9 },
			[5] = { -1,0 },
			[6] = { 13,0 },
			[7] = { -1,0 },			
			[8] = { -1,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 186,9 },			
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 3,0 },
			[4] = { 86,9 },
			[5] = { -1,0 },
			[6] = { 12,0 },
			[7] = { -1,0 },		
			[8] = { -1,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 188,9 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["leiteiro"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 74,0 }, -- maos
			[4] = { 89,22 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 51,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 271,0 }, -- jaqueta		
			["p0"] = { 105,22 }, -- chapeu
			["p1"] = { 23,0 }, -- oculos
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 85,0 }, -- maos
			[4] = { 92,22 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 52,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 141,0 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 3,9 }, -- oculos
		}
	},
	["motorista"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 0,0 }, -- maos
			[4] = { 10,0 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 21,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 242,1 }, -- jaqueta		
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 7,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 14,0 }, -- maos
			[4] = { 37,0 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 27,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 250,1 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { -1,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["cacador"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 20,0 }, -- maos
			[4] = { 97,18 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { 2,2 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 244,19 }, -- jaqueta		
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 5,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 20,0 }, -- maos
			[4] = { 100,18 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { 44,1 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 252,19 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { -1,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["pescador"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 0,0 }, -- maos
			[4] = { 98,19 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { 85,2 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 247,12 }, -- jaqueta		
			["p0"] = { 104,20 }, -- chapeu
			["p1"] = { 5,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 14,0 }, -- maos
			[4] = { 101,19 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { 88,1 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 255,13 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 11,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	}
}

RegisterCommand('roupas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if args[1] then
					local custom = roupas[tostring(args[1])]
					if custom then
						local old_custom = vRPclient.getCustomization(source)
						local idle_copy = {}

						idle_copy = vRP.save_idle_custom(source,old_custom)
						idle_copy.modelhash = nil

						for l,w in pairs(custom[old_custom.modelhash]) do
							idle_copy[l] = w
						end
						vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
						Citizen.Wait(2500)
						vRPclient._stopAnim(source,true)
						vRPclient._setCustomization(source,idle_copy)
					end
				else
					vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
					Citizen.Wait(2500)
					vRPclient._stopAnim(source,true)
					vRP.removeCloak(source)
				end
			end
		end
	end
end)