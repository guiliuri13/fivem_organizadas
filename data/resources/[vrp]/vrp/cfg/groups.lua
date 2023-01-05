local cfg = {}

cfg.groups = {
	["Dono"] = {
		_config = {
			title = "Dono(a)",
			gtype = "staff"
		},
		"dono.permissao",
		"admin.permissao",
		"moderador.permissao"
	},
	["Administrador"] = {
		_config = {
			title = "Administrador(a)",
			gtype = "staff"
		},
		"admin.permissao",
		"moderador.permissao",
		"suporte.permissao"
	},
	["Moderador"] = {
		_config = {
			title = "Moderador(a)",
			gtype = "staff"
		},
		"moderador.permissao",
		"suporte.permissao"
	},
	["Suporte"] = {
		_config = {
			title = "Suporte",
			gtype = "staff"
		},
		"suporte.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Vip's ]------------------------------------------------------------------
	-----------------------------------------------------------------------------
	["Diamond"] = {
		_config = {
			title = "Vip Diamond",
			gtype = "vip"
		},
		"diamond.permissao"
	},
	["Gold"] = {
		_config = {
			title = "Vip Gold",
			gtype = "vip"
		},
		"gold.permissao"
	},
	["Bronze"] = {
		_config = {
			title = "Vip Bronze",
			gtype = "vip"
		},
		"bronze.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Departamento de Justiça ]------------------------------------------------
	-----------------------------------------------------------------------------
	["Juiz"] = {
		_config = {
			title = "Juiz(a)",
			gtype = "job"
		},
		"juiz.permissao",
	},
	["Procurador"] = {
		_config = {
			title = "Procurador(a)",
			gtype = "job"
		},
		"procurador.permissao",
	},
	["Promotor"] = {
		_config = {
			title = "Promotor(a)",
			gtype = "job"
		},
		"promotor.permissao",
	},
	["Defensor"] = {
		_config = {
			title = "Defensor(a) Público",
			gtype = "job"
		},
		"defensor.permissao",
	},
	["Advogado"] = {
		_config = {
			title = "Advogado(a)",
			gtype = "job"
		},
		"advogado.permissao"
	},
	-----------------------------------------------------------------------------
	--[	PMESP ]------------------------------------------------------------------
	-----------------------------------------------------------------------------
	["Comandante"] = {
		_config = {
			title = "Comandante Geral da Policia",
			gtype = "job"
		},
		"comandante.permissao",
		"policia.permissao"
	},
	["PaisanaComandante"] = {
		_config = {
			title = "Paisana Comandante da Geral",
			gtype = "job"
		},
		"paisanacomandante.permissao",
	},
	["SubComandante"] = {
		_config = {
			title = "Sub-Comandante da Policia",
			gtype = "job"
		},
		"subcomandante.permissao",
		"policia.permissao"
	},
	["PaisanaSubComandante"] = {
		_config = {
			title = "Paisana Sub-Comandante da Policia",
			gtype = "job"
		},
		"paisanasubcomandante.permissao",
	},	
	["Capitao"] = {
		_config = {
			title = "Capitão da Policia",
			gtype = "job"
		},
		"capitao.permissao",
		"policia.permissao"
	},
	["PaisanaCapitao"] = {
		_config = {
			title = "Paisana Capitão da Policia",
			gtype = "job"
		},
		"paisanacapitao.permissao",
	},
	["Tenente"] = {
		_config = {
			title = "Tenente da Policia",
			gtype = "job"
		},
		"tenente.permissao",
		"policia.permissao"
	},
	["PaisanaTenente"] = {
		_config = {
			title = "Paisana Tenente da Policia",
			gtype = "job"
		},
		"paisanatenente.permissao",
	},
	["Sargento"] = {
		_config = {
			title = "Sargento da Policia",
			gtype = "job"
		},
		"sargento.permissao",
		"policia.permissao"
	},
	["PaisanaSargento"] = {
		_config = {
			title = "Paisana Sargento da Policia",
			gtype = "job"
		},
		"paisanasargento.permissao",
	},
	["Cabo"] = {
		_config = {
			title = "Cabo da Policia",
			gtype = "job"
		},
		"cabo.permissao",
		"policia.permissao"
	},
	["PaisanaCabo"] = {
		_config = {
			title = "Paisana Cabo da Policia",
			gtype = "job"
		},
		"paisanacabo.permissao",
	},
	["Soldado"] = {
		_config = {
			title = "Soldado da Policia",
			gtype = "job"
		},
		"soldado.permissao",
		"policia.permissao"
	},
	["PaisanaSoldado"] = {
		_config = {
			title = "Paisana Soldado da Policia",
			gtype = "job"
		},
		"paisanasoldado.permissao",
	},
	["Aluno"] = {
		_config = {
			title = "Aluno da Policia",
			gtype = "job"
		},
		"aluno.permissao",
		"policia.permissao"
	},
	["PaisanaAluno"] = {
		_config = {
			title = "Paisana Aluno da Policia",
			gtype = "job"
		},
		"paisanaaluno.permissao",
	},
	-----------------------------------------------------------------------------
	--[	Hospital ]-------------------------------------------------------------------
	-----------------------------------------------------------------------------
	["Diretor"] = {
		_config = {
			title = "Diretor Geral",
			gtype = "job"
		},
		"diretor.permissao",
		"samu.permissao"
	},
	["paisana-diretor"] = {
		_config = {
			title = "Paisana Diretor Geral",
			gtype = "job"
		},
		"paisana-diretorgeral.permissao"
	},
	["DiretorAuxiliar"] = {
		_config = {
			title = "Diretor Auxiliar",
			gtype = "job"
		},
		"diretorauxiliar.permissao",
		"samu.permissao"
	},
	["paisana-diretorauxiliar"] = {
		_config = {
			title = "Paisana Diretor Auxiliar",
			gtype = "job"
		},
		"paisana-diretorauxiliar.permissao"
	},
	["MedicoChefe"] = {
		_config = {
			title = "Médico Chefe",
			gtype = "job"
		},
		"medicochefe.permissao",
		"samu.permissao"
	},
	["paisana-medicochefe"] = {
		_config = {
			title = "Paisana Medico Chefe",
			gtype = "job"
		},
		"paisana-medicochefe.permissao"
	},
	["Cirurgiao"] = {
		_config = {
			title = "Cirurgião",
			gtype = "job"
		},
		"cirurgiao.permissao",
		"samu.permissao"
	},
	["paisana-cirurgiao"] = {
		_config = {
			title = "Paisana Cirurgião",
			gtype = "job"
		},
		"paisana-cirurgião.permissao"
	},
	["MedicoAuxiliar"] = {
		_config = {
			title = "Médico Auxiliar",
			gtype = "job"
		},
		"medicoaulixiar.permissao",
		"samu.permissao"
	},
	["paisana-medicoauxiliar"] = {
		_config = {
			title = "Paisana Medico Auxiliar",
			gtype = "job"
		},
		"paisana-medicoauxiliar.permissao"
	},
	["Medico"] = {
		_config = {
			title = "Médico ",
			gtype = "job"
		},
		"medico.permissao",
		"samu.permissao"
	},
	["paisana-medico"] = {
		_config = {
			title = "Paisana Medico",
			gtype = "job"
		},
		"paisana-medico.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Paramédico ",
			gtype = "job"
		},
		"paramedico.permissao",
		"samu.permissao"
	},
	["paisana-paramedico"] = {
		_config = {
			title = "Paisana Paramedico",
			gtype = "job"
		},
		"paisana-paramedico.permissao"
	},
	["Enfermeiro"] = {
		_config = {
			title = "Enfermeiro",
			gtype = "job"
		},
		"enfermeiro.permissao",
		"samu.permissao"
	},
	["paisana-enfermeiro"] = {
		_config = {
			title = "Paisana Enfermeiro",
			gtype = "job"
		},
		"paisana-enfermeiro.permissao"
	},
	["Estagiario"] = {
		_config = {
			title = "Estágiario ",
			gtype = "job"
		},
		"estagiariosamu.permissao",
		"samu.permissao"
	},
	["paisana-estagiario"] = {
		_config = {
			title = "Paisana Estagiario",
			gtype = "job"
		},
		"paisana-estagiario.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Mecânico ]---------------------------------------------------------------
	-----------------------------------------------------------------------------
	["LiderMecanico"] = {
		_config = {
			title = "Lider da Mecânica",
			gtype = "job"
		},
		"lidermecanico.permissao",
		"mecanico.permissao"
	},
	["paisana-lidermecanico"] = {
		_config = {
			title = "Lider da Mecânica de folga",
			gtype = "job"
		},
		"paisana-lidermecanico.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecânico",
			gtype = "job"
		},
		"mecanico.permissao"
	},	
	["paisana-mecanico"] = {
		_config = {
			title = "Mecânico de folga",
			gtype = "job"
		},
		"paisana-mecanico.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Venda de Drogas ]------------------------------
	-----------------------------------------------------------------------------
	["Roxos"] = {
		_config = {
			title = "Membro dos Roxos",
			gtype = "job",
		},
		"roxos.permissao"
	},
	["LiderRoxos"] = {
		_config = {
			title = "Líder dos Roxos",
			gtype = "job",
		},
		"lider-roxos.permissao",
		"roxos.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Venda de Drogas ]------------------------------
	-----------------------------------------------------------------------------
	["Verdes"] = {
		_config = {
			title = "Membro dos Verdes",
			gtype = "job",
		},
		"verdes.permissao"
	},
	["LiderVerdes"] = {
		_config = {
			title = "Líder dos Verdes",
			gtype = "job",
		},
		"lider-verdes.permissao",
		"verdes.permissao"
	},
		-----------------------------------------------------------------------------
	--[	Organização de Produção e Venda de Drogas ]------------------------------
	-----------------------------------------------------------------------------
	["Azul"] = {
		_config = {
			title = "Membro dos Azuis",
			gtype = "job",
		},
		"azul.permissao"
	},
	["LiderAzul"] = {
		_config = {
			title = "Líder dos Azuis",
			gtype = "job",
		},
		"lider-azul.permissao",
		"azul.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Vendas de Armas ]------------------------------
	-----------------------------------------------------------------------------
	["Mafia"] = {
		_config = {
			title = "Membro da Mafia Brasileira",
			gtype = "job",
		},
		"mafia.permissao"
	},
	["LiderMafia"] = {
		_config = {
			title = "Líder da Mafia Brasileira",
			gtype = "job",
		},
		"lidermafia.permissao",
		"mafia.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Vendas de Armas ]------------------------------
	-----------------------------------------------------------------------------
	["Yakuza"] = {
		_config = {
			title = "Membro da Yakuza",
			gtype = "job",
		},
		"yakuza.permissao"
	},
	["LiderYakuza"] = {
		_config = {
			title = "Membro da Yakuza",
			gtype = "job",
		},
		"lideryakuza.permissao",
		"yakuza.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Vendas de Munição ]----------------------------
	-----------------------------------------------------------------------------
	["Motoclub"] = {
		_config = {
			title = "Membro do Moto Club",
			gtype = "job",
		},
		"motoclub.permissao"
	},
	["LiderMotoclub"] = {
		_config = {
			title = "Presidente do Motoclub",
			gtype = "job",
		},
		"liderbratva.permissao",
		"motoclub.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Produção e Vendas de Munição ]----------------------------
	-----------------------------------------------------------------------------
	["Triade"] = {
		_config = {
			title = "Membro da Triade",
			gtype = "job",
		},
		"triade.permissao"
	},
	["LiderTriade"] = {
		_config = {
			title = "Presidente da Triade",
			gtype = "job",
		},
		"lidertriade.permissao",
		"triade.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Lavagem de Dinheiro/Itens Ilegais ]-----------------------
	-----------------------------------------------------------------------------
	["Vanilla"] = {
		_config = {
			title = "Membro da Vanilla",
			gtype = "job",
		},
		"vanilla.permissao"
	},
	["LiderVanilla"] = {
		_config = {
			title = "Presidente da Vanilla",
			gtype = "job",
		},
		"lidervanilla.permissao",
		"vanilla.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Lavagem de Dinheiro/Itens Ilegais ]-----------------------
	-----------------------------------------------------------------------------
	["Bahamas"] = {
		_config = {
			title = "Membro do Bahamas",
			gtype = "job",
		},
		"bahamas.permissao"
	},
	["LiderBahamas"] = {
		_config = {
			title = "Lider Bahamas",
			gtype = "job",
		},
		"diretorbahamas.permissao",
		"bahamas.permissao"
	},
	-----------------------------------------------------------------------------
	--[	Organização de Desmanche ]------------------------------------
	-----------------------------------------------------------------------------
	["Hellangels"] = {
		_config = {
			title = "Membro da Hellangels",
			gtype = "job",
		},
		"hellangels.permissao"
	},
	["LiderHellangels"] = {
		_config = {
			title = "Lider da Hellangels",
			gtype = "job",
		},
		"liderhellangels.permissao",
		"hellangels.permissao"
	}
}

cfg.users = {
	[1] = { "Dono" },
	[2] = { "Dono" },
	[3] = { "Dono" },
}

cfg.selectors = {}

return cfg