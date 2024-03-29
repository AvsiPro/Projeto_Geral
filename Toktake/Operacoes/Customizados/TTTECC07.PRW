#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTECC07  �Autor  �Jackson E. de Deus  � Data �  05/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se existe chamado no call center                   ���
���          �Se existir, dispara email para o operador informando sobre  ���
���          �o encerramento das OS                                       ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �05/05/14�01.01 |Criacao                                 ���
���Jackson       �19/05/14�01.02 |Alteracao no encerramento do chamado    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTTECC07(cChamado,cMailSpvsr,dDtFim,cHrFim)

Local cNumTMK		:= ""
Local aArea			:= GetArea()
Local cDestino		:= ""
Local cMailOper		:= "" 
Local cNumTmk		:= ""
Local cOperador		:= ""
Local cDtIni		:= ""
Local lFimAuto		:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK022",.T.,.F.),"")
Local cStatusFim	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK005",.T.,"000001"),"")	// status de finalizacao da tarefa/atendimento
Local cStatAtraso	:= "000002"

Default cChamado := ""
Default cMailSpvsr := ""

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cChamado) .And. Empty(cMailSpvsr)
	Return
EndIf

If !Empty(cMailSpvsr)
	cDestino += cMailSpvsr
EndIf	


If !Empty(cChamado)
	dbSelectArea("AB1")
	dbSetOrder(1)
	If dbSeek( xFilial("AB1") +AvKey(cChamado,"AB1_NRCHAM") )
		cNumTMK := AB1->AB1_NUMTMK
			
		If !Empty(cNumTMK)
		  	dbSelectArea("SUC")
			dbSetOrder(1)
			If dbSeek( xFilial("SUC") +AvKey(cNumTMK,"UC_CODIGO") )
				cOperador := SUC->UC_OPERADO
				cDtIni := dtoc(SUC->UC_DATA)
				
				// atrasado?
				If ( dDtFim > SUC->UC_PENDENT ) .Or. ( dDtFim == SUC->UC_PENDENT .And. cHrFim > SUC->UC_HRPEND )
					cStatusFim := cStatAtraso
				EndIf
				

				dbSelectArea("SU7")
				dbSetOrder(1)
				If dbSeek( xFilial("SU7") +AvKey(cOperador,"U7_COD") )
					cMailOper := UsrRetMail(SU7->U7_CODUSU)                             
				EndIf
				
				If Empty(cDestino)
					If !Empty(cMailOper)
						cDestino :=  cMailOper
					EndIf	
				Else 
					If !Empty(cMailOper)
						cDestino += ";" +cMailOper
					EndIf
				EndIf
				
				// ENCERRAMENTO AUTOMATICO
				If lFimAuto
					// Atualiza status
					If SUC->UC_STATUS <> "3" .And. Empty(SUC->UC_DTENCER) .And. Empty(SUC->UC_CODENCE)
						dbSelectArea("SUD")
						If dbSeek( xFilial("SUD") +AvKey(cNumTMK,"UD_CODIGO") )
							If RecLock("SUD",.F.)	
								SUD->UD_STATUS := "2"
								SUD->( MsUnLock() )
							EndIf
						EndIf
						
						dbSelectArea("SUC")
						If RecLock("SUC",.F.)
					    	SUC->UC_STATUS := "3"
					    	SUC->UC_DTENCER := dDtFim
					    	SUC->UC_CODENCE := cStatusFim	// finalizado
							SUC->( MsUnLock() )
							//Encerra as listas de pendencias se existir alguma - SOMENTE PARA ESSE ATENDIMENTO ENCERRADO
							//TK272DelSU4(cNumTMK)
						EndIf
						
						If FindFunction("U_TTMAILN")
							If !Empty(cDestino)
								EnviaEmail(cDestino,cNumTMK,cDtIni,lFimAuto)	// envia o email informando sobre o encerramento
							EndIf
						EndIf   	
					EndIf
				// DISPARA EMAIL PARA O OPERADOR - ENCERRAMENTO MANUAL	
				Else			
					If FindFunction("U_TTMAILN")
						If !Empty(cDestino)
							EnviaEmail(cDestino,cNumTMK,cDtIni,lFimAuto)	// envia o email informando que deve encerrar
						EndIf
					EndIf       
				EndIf
			EndIf		
		EndIf					
	EndIf
EndIf

MsUnLockAll()
      
RestArea(aArea)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnviaEmail  �Autor  �Jackson E. de Deus� Data �  01/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia o email para o operador responsavel pela abertura do  ���
���          �chamado no Call Center                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EnviaEmail(cDestino,cNumTMK,cDtIni,lFimAuto)    

Local cAssunto := ""
Local cHtml := ""
Default lFimAuto := .F.

If !lFimAuto
	cAssunto := "Encerramento de Chamado - N� " +cNumTMK
Else
	cAssunto := "Encerramento autom�tico de Chamado - N� " +cNumTMK
EndIf

cHtml := "<html>"
cHtml += "<head>"
cHtml += "<title>" +cAssunto +"</title>"    
cHtml += "</head>"

// Corpo
cHtml += "<body>"

If !lFimAuto
	cHtml += "<p>O chamado do Call Center n� " +cNumTMK +" iniciado no dia " +cDtIni +", j� pode ser encerrado.</p>"
	cHtml += "<p>As ordens de servi�o geradas para atendimendo t�cnico j� foram atendidas e encerradas.</p>"
Else
	cHtml += "<p>O chamado do Call Center n� " +cNumTMK +" iniciado no dia " +cDtIni +", foi encerrado.</p>"
	cHtml += "<p>As ordens de servi�o geradas para atendimendo t�cnico j� foram atendidas e encerradas.</p>"
EndIf
                                  
cHtml += "<br>"
cHtml += "<br>"
cHtml += "<br>"
cHtml += "<br>"

cHtml += "<p>" +Replicate("_",100) +"</p>"	
cHtml += "<p>E-mail autom�tico enviado via protheus.</p>"
cHtml += "<p>Favor n�o responder.</p>"
cHtml += "</body>"
cHtml += "</html>
      
U_TTMailN("microsiga",cDestino,cAssunto,cHtml,{},.F.)
      
Return