#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC16  บAutor  ณJackson E. de Deus  บ Data ณ  19/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados recebidos na tabela SZN.                     บฑฑ
ฑฑบ          ณUtilizada no retorno dos dados da Leitura de Maquina de cafeบฑฑ
ฑฑบ          ณe Sangria.												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.	 ณaCampos - Array com os campos da tabela e seus valores.	  บฑฑ
ฑฑบ			 ณ		Posicao [x][1] - Nome do campo no dicionario SZN	  บฑฑ
ฑฑบ			 ณ		Posicao [x][2] - Valor do campo						  บฑฑ
ฑฑบ	 		 ณ@cMsgErro - Alimenta as mensagens de erro.				  บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno	 ณlRet - True ou False										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Integracao Equipe Remota                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC16(aCampos,cMsgErro,lAuditoria)
           
Local lRet := .F.
Local nI := 0
Local cDescri := ""
Local lSangria := .F.
Local cSql := ""
Local cNumeroOS := ""
Local cNumChapa := ""
Local cCliente := ""
Local cLoja := ""
Local dDataOS      
Local cRota := ""
Local nRecnoZN := 0
Local nRecnoSZF := 0              
Local nQtd05 := 0
Local nQtd10 := 0
Local nQtd25 := 0
Local nQtd50 := 0
Local nQtd1 := 0
Local nTpServ := 0 
Local lEnvMail := .F.
                      
If cEmpAnt <> "01"
	return
EndIF

If Len(aCampos) == 0
	cMsgErro += "Campos vazios para a gravacao." +CRLF
	Return lRet
EndIf

// Pega o numero da OS
For nI := 1 To Len(aCampos)
	If AllTrim(aCampos[nI][1]) == "ZN_NUMOS"
		cNumeroOS := aCampos[nI][2]
	ElseIf AllTrim(aCampos[nI][1]) == "ZG_EOS"
		If UPPER(AllTrim(aCampos[nI][2])) == "SIM" .Or. UPPER(AllTrim(aCampos[nI][2])) == "S" 
			lEnvMail := .T.                  
		EndIf
	EndIf
Next nI

dbSelectArea("SZG")
dbSetOrder(1)
If dbSeek( xFilial("SZG") +AvKey(cNumeroOS,"ZG_NUMOS") ) 
	nTpServ := SZG->ZG_TPFORM
	If SZG->ZG_TPFORM == 3 //.Or. SZG->ZG_TPFORM == 11
		lSangria := .T.
		dDataOS := SZG->ZG_DATAFIM
		cRota := SZG->ZG_ROTA
	EndIf 
EndIf

// Tratamento para Sangria
If lSangria
	For nI := 1 To Len(aCampos)
		If aCampos[nI][1] == "ZN_PATRIMO"
			cNumChapa := aCampos[nI][2]
		ElseIf aCampos[nI][1] == "ZN_CLIENTE"
			cCliente := aCampos[nI][2]
		ElseIf aCampos[nI][1] == "ZN_LOJA"
			cLoja := aCampos[nI][2]
		ElseIf aCampos[nI][1] == "ZN_DATA"
			dDataOS := aCampos[nI][2]
		EndIf
	Next nI		
			
	cSql := "SELECT R_E_C_N_O_ ZNREC FROM " +RetSqlName("SZN")
	cSql += " WHERE ZN_TIPINCL IN('SANGRIA','AUDITORIA') AND ZN_DATA = '"+DTOS(dDataOS)+"' AND ZN_PATRIMO = '"+cNumChapa+"' "
	cSql += " AND ZN_ROTA = '"+cRota+"' AND ZN_CLIENTE = '"+cCliente+"' AND ZN_LOJA = '"+cLoja+"' AND D_E_L_E_T_ = '' "
	
	If Select("TRBN") > 0
		TRBN->( dbCloseArea() )
	EndIf                     
	
	TcQuery cSql New Alias "TRBN"
	
	dbSelectArea("TRBN")
	If TRBN->( !EOF() )
		nRecnoZN := TRBN->ZNREC
	EndIf
	
	TRBN->( dbCloseArea() )
EndIf
                           
        
dbSelectArea("SZN")
//BeginTran()

If lSangria .And. nRecnoZN > 0
	dbGoTo(nRecnoZN)
	RecLock("SZN",.F.)
Else 
	RecLock("SZN",.T.)
EndIf
		
For nI := 1 To Len(aCampos)
	// verifica se campo existe na SZN
	If SubStr(aCampos[nI][1],1,2) == "ZN"
		If FieldPos( aCampos[nI][1] ) > 0
			SZN->&(aCampos[nI][1]) := aCampos[nI][2]
		EndIf                                
	EndIf
	
	If aCampos[nI][1] == "ZN_PATRIMO"
		cDescri := RetSN1(aCampos[nI][2])
	EndIf                                    
Next nI

SZN->ZN_TIPMAQ := cDescri
SZN->( MsUnLock() )
                           

// Retorno do Troco - ABATE VALOR DOS CAMPOS 'MOEDA' E INCREMENTA OS CAMPOS 'RET'
If lSangria
	For nI := 1 To Len(aCampos)      
		If Alltrim(aCampos[nI][1]) == "ZN_MABAST1"
			nQtd05 := aCampos[nI][2]
		
		ElseIf aCampos[nI][1] == "ZN_MABAST2"
			nQtd10 := aCampos[nI][2]
			
		ElseIf aCampos[nI][1] == "ZN_MABAST3"
			nQtd25 := aCampos[nI][2]

		ElseIf aCampos[nI][1] == "ZN_MABAST4"
			nQtd50 := aCampos[nI][2]	

		ElseIf aCampos[nI][1] == "ZN_MABAST5"
			nQtd1 := aCampos[nI][2]	
		EndIf
	Next nI			               
		
	// Acerta retorno troco	                                                                                                      
	nRecnoSZF := FindSZF(dDataOS,cRota)
	If nRecnoSZF > 0
		dbSelectArea("SZF")
		dbGoTo(nRecnoSZF)

		If SZF->ZF_RETMOE1 == 0
			nQtd05 := SZF->ZF_MOEDA01 - nQtd05
		Else
			nQtd05 := SZF->ZF_RETMOE1 - nQtd05
		EndIf
  
		If SZF->ZF_RETMOE2 == 0
			nQtd10 := SZF->ZF_MOEDA02 - nQtd10
		Else
			nQtd10 := SZF->ZF_RETMOE2 - nQtd10
		EndIf

		If SZF->ZF_RETMOE3 == 0
			nQtd25 := SZF->ZF_MOEDA03 - nQtd25
		Else
			nQtd25 := SZF->ZF_RETMOE3 - nQtd25
		EndIf
	
		If SZF->ZF_RETMOE4 == 0
			nQtd50 := SZF->ZF_MOEDA04 - nQtd50
		Else
			nQtd50 := SZF->ZF_RETMOE4 - nQtd50
		EndIf

		If SZF->ZF_RETMOE5 == 0
			nQtd1 := SZF->ZF_MOEDA05 - nQtd1
		Else
			nQtd1 := SZF->ZF_RETMOE5 - nQtd1
		EndIf

		If RecLock("SZF",.F.)
			SZF->ZF_RETMOE1 := nQtd05
			SZF->ZF_RETMOE2 := nQtd10
			SZF->ZF_RETMOE3 := nQtd25
			SZF->ZF_RETMOE4 := nQtd50
			SZF->ZF_RETMOE5 := nQtd1
			SZF->( MsUnLock() )
		EndIf  
	EndIf	
EndIf	

If lEnvMail
	If RecLock("SZG",.F.)
		SZG->ZG_EOS := "1"
		MsUnLock()
	EndIf
EndIf	

//EndTran() 
MsUnLockAll()


lRet := .T.
	
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetSN1    บAutor  ณJackson E. de Deus  บ Data ณ  12/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca a descricao do patrimonio                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetSN1(cNumChapa)
              
Local cDescri := ""
Local cQuery := ""
Local aArea := GetArea()
                        
cQuery := "SELECT N1_DESCRIC FROM " +RetSqlName("SN1") + " WHERE N1_CHAPA = '"+cNumChapa+"' AND D_E_L_E_T_ = '' "
If Select("TRF") > 0
	TRF->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "TRF"
           
dbSelectArea("TRF")
cDescri := TRF->N1_DESCRIC

TRF->(dbCloseArea())

RestArea(aArea)

Return cDescri


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFindSZF   บAutor  ณJackson E. de Deus  บ Data ณ  16/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o registro das moedas na preparacao da Rota - SZF     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FindSZF(dData,cRota)		

Local nRecno := 0
Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ ZFREC FROM " +RetSqlName("SZF") +" ZF "
cQuery += " WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_DATA='"+dtos(dData)+"' AND ZF_ROTA='"+cRota+"' AND D_E_L_E_T_='' "
cQuery += " AND (ZF_MOEDA01 <> '' OR ZF_MOEDA02 <> '' OR ZF_MOEDA03 <> '' OR ZF_MOEDA04 <> '' OR ZF_MOEDA05 <> '')"

If Select("TRBD") > 0
	TRBD->( dbCloseArea() )
EndIf

TcQuery cQuery New Alias "TRBD"

If !EOF()
	nREcno := TRBD->ZFREC
EndIf

TRBD->( dbCloseArea() )

Return nRecno