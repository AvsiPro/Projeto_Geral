/*/{Protheus.doc} MT140FIL
Ponto de Entrada que permite adicionar um filtro para posteriormente ser aplicado na chamada da mBrowse.LOCALIZAÇÃO: Function MATA140 - Pré-Documento de EntradaEM QUE PONTO: Antes da apresentação da MBrowse.
Programa Fonte
MATA140.PRW
Sintaxe
MT140FIL - Adição de filtro na chamada mBrowse ( [ ] ) --> cFiltro

@author Jonas Gouveia
@since 03/10/2016
@version 2.0

@todo Criar campo F1_USER (Tipo: Caracter, Tamanho:6) com o código do usuário que incluíu a pre nota fiscal

@history 15/10/2016,Jonas Gouveia,incluido validação para que o filtro seja aplicado apenas na empresa 02 (SHOPCIDADAO) 

@obs 
Filtro na tela de pre nota para que usuários não visualizem a NF de outras pessoas
@type function

/*/
User Function MT140FIL()
	Local cFiltro := ''
	Local aGrpUsr := FWSFUsrGrps(RetCodUsr())
	Local cGrpPJ := SuperGetMV('SC_GRPVEPJ', .T., '000000')

	//Aplica filtro somente na empresa 02 - Shopcidadão e se não estiver no grupo fiscal (MV_FORFIS)
	//If SM0->M0_CODIGO == "02"  .AND. !(RetCodUsr() $ (GetMv("MV_FORFIS"))) //SM0->M0_FILIAL == "01"
	//	cFiltro := " F1_USER =  '" + RetCodUsr() + "'"
	//Else
		If aScan(aGrpUsr, cGrpPJ) == 0 //usuario nao pode ver NF dos PJ
			//filtro expressao SQL
			cFiltro := " (F1_TIPO = 'N' AND"  //APENAS NF
			cFiltro += " (SELECT A2_USER FROM "
			cFiltro += RetSqlName("SA2") + " SA2 "
			cFiltro += " WHERE A2_FILIAL = '" + FWxFilial('SA2') + "'"
			cFiltro += "   AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.D_E_L_E_T_ = ' ') IN ('', '" + RetCodUsr() + "'))"
		EndIf
	//EndIf
	Return (cFiltro)
