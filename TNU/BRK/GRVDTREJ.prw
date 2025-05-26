#include "Protheus.ch"

User Function GRVDTREJ() 
 
local cArqTit	:= "IMP/data.csv"
local cLinha	:= ""
local aTmp	 	:= {}
local nX		:= 0
local aE1		:={}
local aRat		:={} 
local cPulaL	:= CHR(13) + CHR(10)
local cAux		:=""

 
FT_FUSE(cArqTit)
FT_FGOTOP()

while !FT_FEOF(cArqTit) 
	nX++
	cLinha := FT_FREADLN()
 	aAdd(aTmp,Separa(cLinha,";",.T.))
 	
 	nRecno:= (fExistCC(aTmp[nX,1],aTmp[nX,2],aTmp[nX,3])) 
 	if !Empty(nRecno)
 	    DBSELECTAREA("CNA")
 	    DBSETORDER(1)
 	 	DBGOTO(nRecno)
 	 	RecLock("CNA",.F.)
 		CNA->CNA_PROXRJ := STOD(aTmp[nX,4])
 		CNA->(MsUnlock())
 	Else
 		FT_FSKIP()
 	Endif
 		FT_FSKIP()
end


Return 

static function fExistCC(cFilC,cNroC,cNroP)

local cQuery:=""

 cQuery := "SELECT "
 cQuery += "CNA.CNA_CONTRA, CNA.R_E_C_N_O_ "
 cQuery += "FROM "
 cQuery += RetSqlName("CNA") + " CNA " 
 cQuery += " WHERE CNA.D_E_L_E_T_<> '*' " 
 cQuery += "AND CNA.CNA_FILIAL = '" + Alltrim(cFilC) +"' "
 cQuery += "AND CNA.CNA_CONTRA = '" + Alltrim(cNroC) +"' "
 cQuery += "AND CNA.CNA_REVISA = (SELECT MAX(CN91.CN9_REVISA) AS MAX FROM  " + RetSqlName("CN9") + " CN91 WHERE CN91.D_E_L_E_T_<> '*' AND CN91.CN9_FILIAL = '"+Alltrim(cFilC) +"' AND CN91.CN9_NUMERO = '" + Alltrim(cNroC) +"') "
 cQuery += "AND CNA.CNA_NUMERO = '" + Alltrim(cNroP) +"' "


		
 Iif(Select("QUERY")>0,QUERY->(dbCloseArea()),Nil)
 dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "QUERY", .T., .T.)
	   
QUERY->(dbGoTop())

If Empty(QUERY->R_E_C_N_O_)
	nRet:=""
else
    nRet:= (QUERY->R_E_C_N_O_)
endif
QUERY->(dbCloseArea())

Return nRet
