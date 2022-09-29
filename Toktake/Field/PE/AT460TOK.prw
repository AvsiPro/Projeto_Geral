#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT460TOK  ºAutor  ³Jackson E. de Deus  º Data ³  26/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado apos a confirmacao para validacao da tela.     º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³26/09/14³01.01 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AT460TOK()

Local lRet := .T.
Local aArea := GetArea()
Local cCliente := AB6->AB6_CODCLI
Local cLoja := AB6->AB6_LOJA
Local cProduto := AB7->AB7_CODPRO
Local cNumChapa := AB7->AB7_NUMSER

If cEmpAnt <> "10"
	dbSelectArea("AA3")
	dbSetOrder(1)
	If !dbSeek( xFilial("AA3") +AvKey(cCliente,"AA3_CODCLI") +AvKey(cLoja,"AA3_LOJA") +AvKey(cProduto,"AA3_CODPRO") +AvKey(cNumChapa,"AA3_NUMSER") )
		SET DELETED OFF
		
		dbSeek( xFilial("AA3") +AvKey(cCliente,"AA3_CODCLI") +AvKey(cLoja,"AA3_LOJA") +AvKey(cProduto,"AA3_CODPRO") +AvKey(cNumChapa,"AA3_NUMSER") )
		If Found()
			/*
			variavel criada para guardar o recno do registro que esta sendo recuperado
			utilizada posteriormente no PE AT460GRV para excluir novamente o registro
			*/                                                
			//_SetNamedPrvt( "_nRecAA3" , RECNO() , "TECA460" )           
			
			//RecLock("AA3",.F.)
			//dbRecall()       
			//MsUnLock()
		EndIf
	EndIf
EndIf          

RestArea(aArea)

Return lRet