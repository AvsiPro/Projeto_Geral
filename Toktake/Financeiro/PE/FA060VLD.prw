#include "PROTHEUS.CH"
#include "RWMAKE.CH"

User Function FA060VLD                                             

Local aArea	 :=	GetArea()
Local cMarca := ParamIxb[1]
Local cAlias := ParamIxb[2]

//If cEmpAnt == "01"
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+RTrim((cAlias)->E1_CLIENTE))
	    
	    If EMPTY(A1_BLEMAIL) .OR. A1_BLEMAIL == '2'   
			AVISO("FA060VLD", "O cliente "+RTrim((cAlias)->E1_CLIENTE+" / "+RTrim((cAlias)->E1_LOJA))+" não recebe boleto",{"OK"}, 1 )
			lRet := .F.
		Else
			lRet := .T.
		Endif
	
	Endif
//EndIF

RestArea(aArea)

Return lRet