fx_version "adamant"
game "gta5"

ui_page "sounds/html/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"animacoes/client.lua",
	"emergencyblips/client.lua",
	"ignore/client.lua",
	"realista/client.lua",
	"realista/config.lua",
	"sounds/client.lua",
	"radar.lua",
	"recoil.lua",
	"iploader.lua",
	"dispatch.lua",
	"peds.lua",
	"removehud.lua",
	"showeapons.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"animacoes/server.lua",
	"ignore/server.lua",
	"emergencyblips/server.lua",
	"realista/config.lua"
}

data_file "FIVEM_LOVES_YOU_4B38E96CC036038F" "ignore/events.meta"


files {
	"ignore/events.meta",
	"ignore/relationships.dat",
	"sounds/html/index.html",
	"sounds/html/**/*.ogg"
}