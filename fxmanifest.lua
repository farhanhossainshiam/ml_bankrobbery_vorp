resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author "NoxFarhan (Discord: NoxFarhan#0001)"
description "It's a Simple bank robbery you need to item for starting the robbery."
version "1.0.1"

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

exports {
	'IsRobb',
}


