/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддддбддддддбдддддддддд©╠
╠ЁPrograma  Ё MA440VLD Ё Autor Ё Artur Nucci Ferrari     Ё Data Ё 12/04/10 Ё╠
╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддддаддддддадддддддддд╢╠
╠ЁDescricao Ё Ponto de Entrada para validacao na liberacao do PV           Ё╠
╠Ё          Ё LiberaГЦo Manual                                             Ё╠
╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠
╠ЁUso       Ё Pedido de Venda                                              Ё╠
╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠
╠ЁEmpresa   Ё Tok Take                                                     Ё╠
╠цддддддддддеддддддддддддддддбддддддддддддддддддддддддддддддддддддддддддддд╢╠
*/
#INCLUDE "RWMAKE.CH"

User Function MA440VLD()
Local nPosCod  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"  	})
Local nPosCodP := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Local dDtLib   := stod("")	//SuperGetMV("MV_XBLQLIB")
Local cxTESC   := ""	//GetNewPar("MV_XTESC","888")
Local cProduto := Space(1)
Local cMens    := ""
Local cRet     := .T.
Local cErro    := 0

MV_PAR06 := ddatabase+1
MV_PAR07 := ddatabase+1

 
// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


dDtLib   := SuperGetMV("MV_XBLQLIB")
cxTESC   := GetNewPar("MV_XTESC","888")


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё BLOQUEIO DE FATURAMENTO                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If date() <= dDtLib
	MsgBox ("Reservas de estoque para Pedido de Venda estЦo bloqueadas.","Erro!!!","STOP")
	cRet := .F.
	Return(cRet)
End              
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё CONTROLE DE LIBERACAO DOS PEDIDOS DE VENDA                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If SC5->C5_XSTLIB<>0
	AVISO("MESSAGEM","Este pedido deverА passar pela aprovaГЦo para ser liberado.",{"OK"},1)
	Return .F.
End                                                                             
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё CONTROLE DE LIBERACAO DOS PEDIDOS DE VENDA                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If SC5->C5_XDTENTR<DATE()
	AVISO("MESSAGEM","NЦo И permitido liberaГЦo de pedidos quan a data de entrega anterior ao dia de hoje.",{"OK"},1)
	Return .F.
End
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё CONTROLE DA TES 888                                                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For I := 1 to Len(aCols)
	If aCols[i,nPosCod] = cXTESC //"888" TES de Reclassificacao de pedido.
		cErro := cErro +1
		cProduto := cProduto + aCols[i,nPosCodp] +" - "
	End
Next
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё CONTROLE DE ERRO                                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cErro > 0
	cMens := "ATENCAO. Favor Reclassificar Pedido de Venda, Antes de Libera-lo. Produtos que necessitam de reclassificacao: "+cProduto
	Alert(cMens)
	cRet := .f.
Else
	cRet := .t.
EndIf
Return(cRet)