#include "totvs.ch"  
 
User Function SPED1400()

Local aArea 		:= GetArea()
Local dDataDe       := ParamIXB[1] // Parametro data De
Local dDataAte      := ParamIXB[2] // Parametro data até
//Local cFilDe        := ParamIXB[3] // Parametro Filial De
//Local cFilAte       := ParamIXB[4] // Parametro Filial Até
//Local aLisFil       := ParamIXB[5] // Lista de filiais selecionadas (Pergunta: Seleciona Filial = SIM)
Local aMyReg1400    := {}               //  DADOS DO REGISTRO 1400
Local nPos          := 0
Local nX 
Local aFilSrc		:= {}
Local aItens 		:= {}
Local nPos1400		:= 0

If len(ParamIXB) > 5

	For nX := 1 to len(ParamIXB[5])
		If ParamIXB[5,nX,1]
			Aadd(aFilSrc,ParamIXB[5,nX,2])
		EndIf 
	Next nX 

	aItens := Busca(aFilSrc,dDataDe,dDataAte)

	For nX := 1 to len(ParamIXB[6])
		aAdd(aMyReg1400, {})
		
		nPos   :=     Len(aMyReg1400)  
		
		nPos1400 := Ascan(aItens,{|x| x[1] == ParamIXB[6,nX,02]})
		cCodSPD := If(nPos1400>0,aItens[nPos,02],"SPDIPAM11")
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,01])                     //01 - REG
		aAdd (aMyReg1400[nPos], Alltrim(cCodSPD))         	                  //02 - COD_ITEM_IPM  
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,03])                     //03 - MUN  
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,04])                     //04 - VALOR
	Next nX
EndIf

RestArea(aArea)
  
Return aMyReg1400




/*/{Protheus.doc} Busca
	Busca codigo por filiais e produto 
	@type  Static Function
	@author user
	@since 10/05/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Busca(aLista,dDataDe,dDataAte)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 
Local nCont := 1
Local cBarra := ''
Local cFils	:= ''

For nCont := 1 to len(aLista)
	cFils += cBarra + aLista[nCont]
	cBarra := "','"
Next nCont 

cQuery := "SELECT D2_COD+D2_FILIAL AS CODIGO,F09_CODIPM AS SPD1400,SUM(D2_TOTAL) AS VLRTOTAL"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("F09")+" F09 ON F09_FILIAL=' ' AND F09_TES=D2_TES AND F09.D_E_L_E_T_=' '"
cQuery += " WHERE D2_FILIAL IN('"+cFils+"')"
cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"'"
cQuery += " AND D2.D_E_L_E_T_=' '"
cQuery += " GROUP BY D2_FILIAL,D2_COD,F09_CODIPM"

IF Select('TRBLOCX') > 0
    dbSelectArea('TRBLOCX')
    dbCloseArea()
ENDIF

MemoWrite("SPED1400.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRBLOCX", .F., .T. )

DbSelectArea("TRBLOCX")

While !EOF()
	Aadd(aRet,{TRBLOCX->CODIGO,TRBLOCX->SPD1400,TRBLOCX->VLRTOTAL})
	Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
