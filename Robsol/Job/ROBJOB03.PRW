#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
/*
    Envio da cópia dos pedidos gerados pelo app para os clientes
*/
User function ROBJOB03()

Local cQuery
Local aAux      :=  {}
Local nX        :=  1

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery := "SELECT C5_NUM,C5_CLIENTE,A1_EMAIL,A3_EMAIL,C5_FILIAL"
cQuery += " FROM "+RetSQLName("SC5")+" C5"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE C5_FILIAL BETWEEN '0101' AND 'ZZZ'"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(ddatabase-5)+"' AND '"+dtos(ddatabase)+"'"
cQuery += " AND C5.D_E_L_E_T_=' '"
cQuery += " AND C5_ZZSTATU='X'"
//cQuery += " AND C5_NUM='001082'"
cQuery += " AND C5_NUM+C5_CLIENT NOT IN(SELECT Z44_CODIGO+Z44_CLIENT FROM "+RetSQLName("Z44")+" WHERE D_E_L_E_T_=' ')"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

DbSelectArea("QUERY")

While !EOF()
    Aadd(aAux,{ QUERY->C5_NUM,;
                QUERY->C5_CLIENTE,;
                Alltrim(QUERY->A1_EMAIL),;
                Alltrim(QUERY->A3_EMAIL),;
				QUERY->C5_FILIAL})
    DbSkip()
Enddo

For nX := 1 to len(aAux)
    GERHTML(aAux[nX,01],aAux[nX,03]+";"+aAux[nX,04],aAux[nX,05])
    Reclock("Z44",.T.)
    Z44->Z44_FILIAL :=  xFilial("Z44")  
    Z44->Z44_CODIGO :=  aAux[nX,01]
    Z44->Z44_CLIENT :=  aAux[nX,02]
    Z44->Z44_EMAIL  :=  aAux[nX,03]+";"+aAux[nX,04]
    Z44->Z44_DTIENV :=  ddatabase
    Z44->Z44_HORAEN :=  cvaltochar(time())
    Z44->(MsUnlock())
Next nX

return


/*/{Protheus.doc} HTML
	(long_description)
	@type  Static Function
	@author user
	@since 24/02/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function GERHTML(cPedido,cEmaildest,cFilfat)

Local aArea     :=  GetArea()
Local cHtml     := ''
Local cRemete   := "No-Reply Robsol <noreply@robsol.com.br>"                               
Local cSubject	:=	"Pedido de Venda"
Local aArquivos := {}           
Local cDestino	:=	cEmaildest //"alexandre.venancio@avsipro.com.br;cnoculos@hotmail.com" //
Local lEnviar	:=	.F.
Local nQtdTot	:=	0
Local nVlrBru	:=	0
Local nVlrLiq	:=	0
Local nDescnt	:=	0

cHtml := '<h1 style="color: #5e9ca0;">Pedido de Venda Gerado!</h1>'
cHtml += '<h2 style="color: #2e6c80;">Seu pedido foi gerado com sucesso!!!</h2>
cHtml += '<p>Seu pedido foi gerado em nossa base e logo estaremos realizando o atendimento para realiza&ccedil;&atilde;o da entrega das mercadorias.</p>
cHtml += '<h2 style="color: #2e6c80;">Informa&ccedil;&otilde;es do pedido: Pedido numero '+cPedido+'</h2>
cHtml += '<table class="editorDemoTable" style="width: 544px; height: 72px;">
cHtml += '<thead>
cHtml += '<tr style="height: 18px;">
cHtml += '<td style="width: 148.188px; height: 18px;">Produto</td>
cHtml += '<td style="width: 231.95px; height: 18px;">Descri&ccedil;&atilde;o</td>
cHtml += '<td style="width: 60.575px; height: 18px;">Qtd</td>
cHtml += '<td style="width: 77.2875px; height: 18px;">Valor</td>
cHtml += '</tr>
cHtml += '</thead>
cHtml += '<tbody>

DbSelectArea("SC6")
DbSetOrder(1)
If Dbseek(cFilfat+cPedido)
	While !EOF() .And. SC6->C6_FILIAL == cFilfat .and. SC6->C6_NUM == cPedido
		cHtml += '<tr style="height: 18px;">
		cHtml += '<td style="width: 148.188px; height: 18px;">'+ALLTRIM(SC6->C6_PRODUTO)+'</td>'
		cHtml += '<td style="width: 231.95px; height: 18px;">'+ALLTRIM(SC6->C6_DESCRI)+'</td>'
		cHtml += '<td style="width: 60.575px; height: 18px;">'+TRANSFORM(SC6->C6_QTDVEN,"@E 9999")+'</td>'
		cHtml += '<td style="width: 77.2875px; height: 18px;">'+TRANSFORM(SC6->C6_PRCVEN,"@E 999,999,999.99")+'</td>'
		cHtml += '</tr>'
		lEnviar := .T.
		nQtdTot	+=	SC6->C6_QTDVEN
		nVlrBru	+=	SC6->C6_PRUNIT*SC6->C6_QTDVEN
		nVlrLiq	+=	SC6->C6_VALOR
		nDescnt	:=	SC6->C6_DESCONT
		Dbskip()
	ENDDO
endif

cHtml += '<br>'
cHtml += '<tr style="height: 28px;">
cHtml += '<b>Quantidade Total</b> '+cvaltochar(nQtdTot)+' Peças'
cHtml += '</tr>'
cHtml += '<tr style="height: 28px;">
cHtml += '<b>Valor Bruto</b> '+Transform(nVlrBru,"@E 999,999,999.99")
cHtml += '</tr>'
cHtml += '<tr style="height: 28px;">
cHtml += '<b>Desconto</b> '+cvaltochar(nDescnt)+'%'
cHtml += '</tr>'
cHtml += '<tr style="height: 28px;">
cHtml += '<b>Valor Liquido</b> '+Transform(nVlrLiq,"@E 999,999,999.99")
cHtml += '</tr>'

cHtml += '<br>'
cHtml += 'A Robsol agradece a sua confiança e parceria.'
cHtml += '</tbody>
cHtml += '</table>
cHtml += '<p><strong>&nbsp;</strong></p>
cHtml += '<p>&nbsp;</p>'

If lEnviar
	U_robmail(cRemete,cDestino,cSubject,cHtml,aArquivos,.T.)
EndIf 

RestArea(aArea)

Return 
