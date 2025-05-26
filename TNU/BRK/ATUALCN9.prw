#include 'protheus.ch'
#include 'parmtype.ch'

user function ATUALCN9()

local cArqTit	:= "system\Contrato/CONT.csv"
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
 	
 	nRecno:= (fExistCC(aTmp[nX,1],aTmp[nX,2])) 
 	if !Empty(nRecno)
 	    DBSELECTAREA("CN9")
 	    DBSETORDER(1)
 	 	DBGOTO(nRecno)
 	 	RecLock("CN9",.F.)
 		CN9->CN9_XCODCL := Alltrim(aTmp[nX,3])
 		CN9->CN9_XLOJCL := Alltrim(aTmp[nX,4])
 		CN9->CN9_XNOMCL := Alltrim(aTmp[nX,5])
 		CN9->CN9_XREDCL := posicione('SA1',1,xFilial('SA1')+Alltrim(aTmp[nX,3])+Alltrim(aTmp[nX,4]),'A1_NREDUZ') 
 		CN9->CN9_XDTANI := ctod(Alltrim(aTmp[nX,6]))
 		SB1->(MsUnlock())
 	Else
 		FT_FSKIP()
 	Endif
 		FT_FSKIP()
end


Return 

static function fExistCC(cFi,cCon)

local cQuery:=""

 cQuery := "SELECT "
 cQuery += "CN9.CN9_NUMERO, CN9.R_E_C_N_O_ "
 cQuery += "FROM "
 cQuery += RetSqlName("CN9") + " CN9 " 
 cQuery += " WHERE CN9.D_E_L_E_T_<> '*' " 
 cQuery += "AND CN9.CN9_FILIAL = '" + cFi +"' "
 cQuery += "AND CN9.CN9_NUMERO = '" + Alltrim(cCon) +"' "

		
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
	
