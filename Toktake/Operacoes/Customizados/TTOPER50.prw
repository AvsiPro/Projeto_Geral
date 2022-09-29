


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTOPER50    ºAutor  ³Jackson E. de Deusº Data ³  29/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job de calculo da venda das maquinas                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTOPER50()

Local nI,nJ
Local cMaquina := ""
Local cProduto := ""
Local cMola := ""
Local nVenda := 0 
Local nMedia := 0
Local lInsumo := .F.
Local cHrIni := ""
Local cHrFim := ""
Local dDiaIni := stod("")
Local dDiaFim := stod("")
Local dDia := stod("")
Private aMaquinas := {}

RpcSetType(3)
RpcSetEnv("01","01")

dDiaIni := dDatabase-30
dDiaFim := dDatabase


cHrIni := Time()


aMaquinas := fRetMaq(dDatabase)

/*
For nI := 1 To Len(aMaquinas)
	cMaquina := aMaquinas[nI][1]
	For nJ := 1 To Len(aMaquinas[nI][2])
		cMola := aMaquinas[nI][2][nJ][2]
		cProduto := aMaquinas[nI][2][nJ][3]
		
		cSecao := AllTrim(Posicione("SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_XSECAO"))
		lInsumo := .F.
		If cSecao $ "005#007"
			lInsumo := .T.
		EndIf
		
		If !lInsumo
			nVenda := STATICCALL( TTFAT39C, VendaZ0, cMaquina,cProduto,cMola,dDatabase-30,dDatabase)
			aMaquinas[nI][2][nJ][5] := nVenda
			nMedia := nVenda/30
			
			dbSelectArea("SZH")
			dbGoTo(aMaquinas[nI][2][nJ][4])
			If FieldPos("ZH_VENDA") > 0
				RecLock("SZH",.F.)
				SZH->ZH_VENDA := nVenda
				SZH->ZH_MEDIA := nMedia
				MsUnLock()                 
			EndIf		
		EndIf	
	Next nJ			
Next nI
*/



//Tab()

DbUseArea(.T., "TOPCONN", "MAQVEN", "TRBM", .T., .F.) 
//Index On MAQUINA TO "TRBM"

DbSelectArea("TRBM") 


For nI := 1 To Len(aMaquinas)
	cMaquina := aMaquinas[nI][1]
	For nJ := 1 To Len(aMaquinas[nI][2])
		cMola := aMaquinas[nI][2][nJ][2]
		cProduto := aMaquinas[nI][2][nJ][3]
		
		cSecao := AllTrim( Posicione("SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_XSECAO") )
		lInsumo := .F.
		If cSecao $ "005#007"
			lInsumo := .T.
		EndIf
		
		For dDia := dDiaFim To dDiaIni Step -1
			nRecM := FoundM( cMaquina,cMola,cProduto,dDia )	
			
			If !lInsumo
				nVenda := STATICCALL( TTFAT39C, VendaZ0, cMaquina,cProduto,cMola,,dDia )
				aMaquinas[nI][2][nJ][5] := nVenda
				aMaquinas[nI][2][nJ][6]	:= dDia
				
				//nMedia := nVenda/30
				
				dbSelectArea("SZH")
				dbGoTo(aMaquinas[nI][2][nJ][4])
				If FieldPos("ZH_VENDA") > 0
					RecLock("SZH",.F.)
					SZH->ZH_VENDA := nVenda
					//SZH->ZH_MEDIA := nMedia
					MsUnLock()                 
				EndIf
			Else
				aDetail := {}
				nVenda := STATICCALL( TTFAT39C, CalcCsmo, cMaquina,cProduto,dDia,dDia, @aDetail )			
			EndIf
			          
			// grava
			DbSelectArea("TRBM") 
			If nRecM > 0
				dbGoto(nRecM)
				RecLock("TRBM",.F.)
			Else
				RecLock("TRBM",.T.)
			EndIf
			                 
			TRBM->MAQUINA	:= cMaquina
			TRBM->POSICAO	:= cMola
			TRBM->PRODUTO	:= cProduto
			TRBM->VENDA		:= nVenda
			TRBM->DIA		:= dDia
			TRBM->( MsUnLock() )
			
		Next dDia	
	Next nJ			
Next nI


cHrFim := Time()

Conout("#TTOPER50 -> TEMPO: " +ElapTime(cHrIni,cHrFim))

RpcClearEnv()

Return

// Verifica/Cria tabela
Static Function Tab()

Local aCampos := {{"MAQUINA","C",6,0},;
					{"POSICAO","C",3,0},;
					{"PRODUTO","C",15,0},;
					{"VENDA","N",6,2},;
					{"DIA","D",8,0}} 

If !Chkfile("MAQVEN")
	DbCreate( "MAQVEN",aCampos,"TOPCONN" ) 
EndIf


Return


// verifica se ja existe o registro
Static Function FoundM( cMaquina,cPosicao,cProduto,dDia )	

Local nRec := 0
Local cQuery := ""


cQuery := "SELECT R_E_C_N_O_ MAQREQ FROM MAQVEN "
cQuery += " WHERE MAQUINA = '"+cMaquina+"' AND POSICAO = '"+cPosicao+"' AND PRODUTO = '"+cProduto+"' AND DIA = '"+DTOS(dDia)+"' "
cQuery += " AND D_E_L_E_T_ = '' "

MPSysOpenQuery( cQuery , "TRBR" )

dbSelectArea("TRBR")
nRec := TRBR->MAQREQ  


Return nRec



// Maquinas atendidas no dia
Static Function fRetMaq(dDia)

Local aMaq := {}
Local cQuery := ""
Local cMaquina := ""

cQuery := "SELECT ZG_PATRIM, COUNT(*) FROM " +RetSqlName("SZG") +" WITH (NOLOCK) "
cQuery += " WHERE ZG_DATAFIM = '"+DTOS(dDia)+"' AND ZG_PATRIM <> '' AND ZG_FORM IN ('02','04','08') "
cQuery += " AND D_E_L_E_T_ = '' AND SUBSTRING(ZG_ROTA,1,1) = 'R' "
cQuery += " GROUP BY ZG_PATRIM"

MPSysOpenQuery( cQuery , "TRB" )  

dbSelectArea("TRB")
While !EOF()

	cMaquina := AllTrim(TRB->ZG_PATRIM)
	aMapa := fMapa(cMaquina)
	
	dbSelectArea("TRB")

	AADD( aMaq, { cMaquina, aMapa } )
	
	dbSkip()
End

TRB->(dbCloseArea())


Return aMaq


// Mapa
Static Function fMApa(cMaquina)

Local aMapa := {}
Local cQuery := ""      

cQuery := "SELECT * FROM " +RetSqlName("SZH") +" WHERE ZH_CHAPA = '"+cMaquina+"' AND ZH_STATUS = '3' AND D_E_L_E_T_ = '' AND ZH_VERSAO <> '' "
cQuery += " ORDER BY ZH_BANDEJA, ZH_MOLA "

MPSysOpenQuery( cQuery , "TRBX" ) 

dbSelectArea("TRBX")
While !EOF()

	AADD( aMapa, { TRBX->ZH_BANDEJA,; 
					TRBX->ZH_MOLA,;
					 TRBX->ZH_CODPROD,;
					 TRBX->R_E_C_N_O_,;
					 0,;
					 stod("") } )
	
	dbSkip()
End

TRBX->(dbCloseArea()) 


Return aMapa