#include "Protheus.ch"

User Function GRVHISTO() 
 
local cArqTit	:= "IMP/hist.csv"
local cLinha	:= ""
local aTmp	 	:= {}
local nX		:= 0
local nXi       := 0
local nLinhas   := 0
local cLinhaYP  := ""
Private cCodJus := ""

 
//FT_FUSE(cArqTit)
//FT_FGOTOP()

DbSelectArea("SYP")
DbSetOrder(1)

DBSELECTAREA("CN9")
DBSETORDER(1)

//while !FT_FEOF(cArqTit) 
	
	//cLinha := FT_FREADLN()
 	//aAdd(aTmp,Separa(cLinha,";",.f.))
	//CN9->(DBGOTOP())
	//SYP->(DBGOTOP()) 
	oFile := FWFileReader():New(cArqTit)
If (oFile:Open())
 	
	 If ! (oFile:EoF())
        //Enquanto houver linhas a serem lidas
        While (oFile:HasLine())

			nX++
			//Buscando o texto da linha atual
            cLinAtu := oFile:GetLine()
			aAdd(aTmp,Separa(cLinAtu,";",.t.))
			cCodJus:= ""
 			nRecno:= (fExistCC(aTmp[nX,1],aTmp[nX,2])) 
 			if !Empty(nRecno)
	 			nLinhas := MLCount(Alltrim(aTmp[nX,3]),81)
	
				If Empty(cCodJus)
			
					cChavSYP:=  GetSx8Num("SYP")//NextNumero("SYP",1,"YP_CHAVE",.T.)
					ConfirmSX8()

					cSeq := "001"
					For nXi:= 1 To nLinhas
						cLinhaYP := MemoLine(Alltrim(aTmp[nX,3]),81,nXi)

						RecLock("SYP", .T.)
						SYP->YP_CHAVE := cChavSYP
						SYP->YP_SEQ   := cSeq
						SYP->YP_TEXTO := cLinhaYP
						SYP->YP_CAMPO := "CN9_CODJUS"
						SYP->(MsUnlock())

						cSeq := Soma1(cSeq)
					Next nXi
			
 	 				CN9->(DBGOTO(nRecno))
 	 				RecLock("CN9",.F.)
 					CN9->CN9_CODJUS := cChavSYP
 					CN9->(MsUnlock())
				Else
					cQry := "SELECT MAX(YP_SEQ) AS SEQ "
 					cQry += "FROM "
 					cQry += RetSqlName("SYP") + " SYP " 
 					cQry += "WHERE SYP.D_E_L_E_T_<> '*' " 
					cQry += "AND SYP.YP_FILIAL = '"+xFilial("SYP") +"' "
					cQry += "AND SYP.YP_CHAVE = '"+cCodJus+"' "
					cQry += "AND SYP.YP_CAMPO = 'CN9_CODJUS' "

					Iif(Select("QRY")>0,QUERY->(dbCloseArea()),Nil)
 					dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), "QRY", .T., .T.)

					cSeq := QRY->SEQ

					QRY->(dbCloseArea())
					cSeq := Soma1(cSeq)

					For nXi:= 1 To nLinhas
						cLinhaYP := MemoLine(Alltrim(aTmp[nX,3]),81,nXi)

						RecLock("SYP", .T.)
						SYP->YP_CHAVE := cCodJus
						SYP->YP_SEQ   := cSeq
						SYP->YP_TEXTO := cLinhaYP
						SYP->YP_CAMPO := "CN9_CODJUS"
						SYP->(MsUnlock())

						cSeq := Soma1(cSeq)
					Next nXi


				EndIf	
 			Endif
		EndDo
    EndIf	

	//Fecha o arquivo e finaliza o processamento
    oFile:Close()	 
EndIf


Return 

static function fExistCC(cNroC,cFilC)

local cQuery:=""

cCodJus := ""

 cQuery := "SELECT "
 cQuery += "CN9.R_E_C_N_O_ , CN9.CN9_CODJUS, CN9.CN9_NUMERO "
 cQuery += "FROM "
 cQuery += RetSqlName("CN9") + " CN9 " 
 cQuery += " WHERE CN9.D_E_L_E_T_<> '*' " 
 cQuery += " AND CN9.CN9_FILIAL = '0"+Alltrim(cFilC) +"' "
 cQuery += " AND CN9.CN9_NUMERO = '" + Alltrim(cNroC) +"' "
 cQuery += " AND CN9.CN9_REVISA = (SELECT MAX(CN91.CN9_REVISA) AS MAX FROM  " + RetSqlName("CN9") + " CN91 WHERE CN91.D_E_L_E_T_<> '*' AND CN91.CN9_FILIAL = '0"+Alltrim(cFilC) +"' AND CN91.CN9_NUMERO = '" + Alltrim(cNroC) +"') "
		
 Iif(Select("QUERY")>0,QUERY->(dbCloseArea()),Nil)
 dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "QUERY", .T., .T.)
	   
QUERY->(dbGoTop())

If Empty(QUERY->R_E_C_N_O_)
	nRet:=""
else
    nRet:= (QUERY->R_E_C_N_O_)
	cCodJus:= Alltrim(QUERY->CN9_CODJUS)
endif
QUERY->(dbCloseArea())

Return nRet
