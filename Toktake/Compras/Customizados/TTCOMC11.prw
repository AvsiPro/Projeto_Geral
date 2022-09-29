#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#include "topconn.ch"

User Function TTCOMC11(aDados)

Local aArea			:= GetArea()
Local lRet			:= .F.
Local nI			:= 0
Local cCodFil		:= ""
Local cSerie		:= ""
Local nRecSF1		:= 0
Private aCab		:= {}
Private aItensD1	:= {}
Private aIt			:= {}
Private lMsErroAuto	:= .F.

If cEmpAnt == "01"
	
	// Busca informacoes da Nota na base de dados
	cQuery := "SELECT DISTINCT "
	cQuery += "SF1.R_E_C_N_O_ F1REC, F1_FILIAL, F1_SERIE, F1_FORNECE, F1_LOJA, F1_COND, F1_EMISSAO, F1_EST, F1_TIPO, F1_FORMUL, F1_ESPECIE, A2_NATUREZ, "
	cQuery += "D1_ITEM, D1_COD "
	cQuery += "FROM " +RetSqlName("SF1") + " SF1 "
	
	cQuery += "INNER JOIN " +RetSqlName("SD1") +" SD1 ON "
	cQuery += "SD1.D1_FILIAL = SF1.F1_FILIAL "
	cQuery += "AND SD1.D1_DOC = SF1.F1_DOC "
	cQuery += "AND SD1.D1_SERIE = SF1.F1_SERIE "
	cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
	cQuery += "AND SD1.D1_LOJA = SF1.F1_LOJA "
	cQuery += "AND SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_ "
	
	cQuery += "INNER JOIN " +RetSqlName("SA2") +" SA2 ON "
	cQuery += "SA2.A2_COD = SF1.F1_FORNECE "
	cQuery += "AND SA2.A2_LOJA = SF1.F1_LOJA "
	cQuery += "AND SA2.D_E_L_E_T_ = '' "
	
	cQuery += "WHERE "
	//cQuery += "F1_DOC = '"+AvKey(aDados[2][2],"F1_DOC")+"' "
	cQuery += "F1_FORNECE = '"+aDados[4][2]+"' "
	cQuery += "AND F1_LOJA = '"+aDados[5][2]+"' "
	cQuery += "AND F1_XWSOSR = '"+aDados[1][2]+"' "
	cQuery += "AND SF1.D_E_L_E_T_ = '' "
	
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf
	
	TcQuery cQuery New Alias "TRB"
	
	dbSelectArea("TRB")
	
	cCodFil := TRB->F1_FILIAL
	cSerie := TRB->F1_SERIE
	nRecSF1 := TRB->F1REC
	
	aCab := {  { "F1_FILIAL"	, cCodFil						, Nil, Nil },;
				{ "F1_DOC"		, AvKey(aDados[2][2],"F1_DOC")	, Nil, Nil },;
	            { "F1_SERIE"	, AvKey(cSerie,"F1_SERIE")		, Nil, Nil },;
	            { "F1_FORNECE"	, aDados[4][2]					, Nil, Nil },;
	            { "F1_LOJA"		, aDados[5][2]					, Nil, Nil },;
	            { "F1_COND"		, TRB->F1_COND					, Nil, Nil },;
	            { "F1_EMISSAO"	, TRB->F1_EMISSAO				, Nil, Nil },;
	            { "F1_EST"		, TRB->F1_EST					, Nil, Nil },;      
	            { "F1_TIPO"		, TRB->F1_TIPO					, Nil, Nil },;
	            { "F1_FORMUL"	, TRB->F1_FORMUL				, Nil, Nil },;
	            { "F1_ESPECIE"	, TRB->F1_ESPECIE				, Nil, Nil },;
	            { "E2_NATUREZ"	, TRB->A2_NATUREZ				, Nil, Nil }}
	
	TRB->( dbGoTop() )
	While !EOF()
		For nI := 1 To Len(aDados[9][2])
			If TRB->D1_ITEM == aDados[9][2][nI][1]
				aItensD1 := {}
				AAdd( aItensD1, { "D1_ITEM"		, TRB->D1_ITEM			, Nil} )
				AAdd( aItensD1, { "D1_COD"		, TRB->D1_COD			, Nil} )
				AAdd( aItensD1, { "D1_XCLASPN"	, aDados[9][2][nI][2]	, Nil} )
				//AAdd( aItensD1, { "D1_TES"		, "004"					, Nil} )			
				Exit
			EndIf
		Next nI
		AAdd(aIt,aItensD1) 
		TRB->( dbSkip() )
	End
	
	Dbselectarea("SF1")
	dbSetOrder(1)
	DbSeek(cCodFil+AvKey(aDados[2][2],"F1_DOC") +AvKey(cSerie,"F1_SERIE"))
	                      
	MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCab, aIt,4,.F.)
	
	If lMsErroAuto
		MostraErro()
	Else
		lRet := .T.
	Endif   
EndIf
                                     
RestArea(aArea)

Return lRet 