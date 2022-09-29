#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#include "fileio.ch"
#include "topconn.ch"

User Function toktok
                                
Local cArqTxt		:=	'c:\temp\1706.txt'
Local aAux			:=	{}
Local aAjuste		:=	{}
Private nHandle 	:=	FT_FUse(cArqTxt) 
		
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux    := StrTokArr(cLine,";")
    /*	ZN_FILIAL
		ZN_TIPINCL
		ZN_DATA
		ZN_ROTA
		ZN_PATRIMO
		ZN_TIPMAQ	* N1_PRODUTO (descricao b1)
		ZN_CLIENTE	* N1_XCLIENT
		ZN_LOJA		* N1_XLOJA
		ZN_DESCCLI	* (Nome SA1)
		ZN_MOEDA1R
		ZN_NOTA01
		ZN_AGENTE	* ROTA (AA1_LOCAL (AA1_CODTEC))
		ZN_NOMAGEN	* ROTA (AA1_LOCAL (AA1_NOMTEC))
		ZN_VALIDA	S
		ZN_NUMOS	0
		*/
	If len(aAux) > 1
		//DbSelectArea("")
		//DbSetOrder(3)   
		filial := '01'
		tipinc := 'SANGRIA'
		dia	   := stod(aAux[1])
		rota   := aAux[2]
		patrim := aAux[3]
		tipmaq := Posicione("SB1",1,xFilial("SB1")+Posicione("SN1",2,xFilial("SN1")+aAux[3],"N1_PRODUTO"),"B1_DESC")
		cliente:= Posicione("SN1",2,xFilial("SN1")+aAux[3],"N1_XCLIENT")
		cloja  := Posicione("SN1",2,xFilial("SN1")+aAux[3],"N1_XLOJA")
		cnome  := Posicione("SA1",1,xFilial("SA1")+cliente+cloja,"A1_NOME") 
		cmoeda := If(aAux[4]<>"*",val(strtran(aAux[4],",",".")),0)
		cnota  := If(aAux[5]<>"*",val(strtran(aAux[5],",",".")),0)
		aAgt   := agent(rota)
		
		cagnt  := aAgt[1,1]
		cnoag  := aAgt[1,2]
		cvalid := 'S'
		cNumos := '0'
        Aadd(aAjuste,{filial,tipinc,dia,rota,patrim,tipmaq,cliente,cloja,cnome,cmoeda,cnota,cagnt,cnoag,cvalid,cNumos})
	EndIF                 
	FT_FSKIP()
End              

For nX := 1 to len(aAjuste)
	DbSelectArea("SZN")
	Reclock("SZN",.T.)
	SZN->ZN_FILIAL	:= aAjuste[nX,01]
	SZN->ZN_TIPINCL	:= aAjuste[nX,02]
	SZN->ZN_DATA	:= aAjuste[nX,03]
	SZN->ZN_ROTA	:= aAjuste[nX,04]
	SZN->ZN_PATRIMO	:= aAjuste[nX,05]	
	SZN->ZN_TIPMAQ	:= aAjuste[nX,06]
	SZN->ZN_CLIENTE	:= aAjuste[nX,07]
	SZN->ZN_LOJA	:= aAjuste[nX,08]	
	SZN->ZN_DESCCLI	:= aAjuste[nX,09]
	SZN->ZN_MOEDA1R	:= aAjuste[nX,10]
	SZN->ZN_NOTA01	:= aAjuste[nX,11]
	SZN->ZN_AGENTE	:= aAjuste[nX,12]
	SZN->ZN_NOMAGEN	:= aAjuste[nX,13]
	SZN->ZN_VALIDA	:= aAjuste[nX,14]
	SZN->ZN_NUMOS	:= aAjuste[nX,15]
	SZN->(Msunlock())
Next nX

FT_FUse()

Return                              

static function agent(crota)

Local aRet	:= {}

cQuery := "SELECT AA1_CODTEC,AA1_NOMTEC FROM AA1010 WHERE AA1_LOCAL='"+crota+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

Aadd(aRet,{TRB->AA1_CODTEC,TRB->AA1_NOMTEC})

Return(aRet)