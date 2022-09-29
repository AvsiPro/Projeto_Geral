#include "protheus.ch
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPER11  �Autor  �Jackson E. de Deus  � Data �  10/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica os campos de doses do cadastro de patrimonio	  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �10/10/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTOPER11(cPatrimo)

Local lPVazio := .F.                       
Local cdestino := SuperGetMV("MV_XATF003",.T.,"")

Default cPatrimo := ""

If Empty(cPatrimo)
	Return
EndIf             

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cdestino)
	Conout("# TTOPER11 - Verificar parametro MV_XATF003 #")
	Return
EndIf


lPVazio := ChkPs(cPatrimo)
If lPVazio
	Mail(cPatrimo,cdestino)
EndIf

Return
      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChkPs     �Autor  �Jackson E. de Deus  � Data �  10/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica os campos de doses - P's                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ChkPs(cPatrimo)
     
Local cQuery := ""
Local lPVazio := .F.
Local lNovos := .T.
Local nTotP := 0
Local nPOk := 0
Local aCampos := {}


dbSelectArea("SN1")
For nI := 1 To 25
	cCampo := "N1_XP"+cvaltochar(nI)
	If FieldPos(cCampo) > 0
		AADD( aCampos, cCampo )
	EndIf
Next nI
	
cQuery := "SELECT "
For nI := 1 To Len(aCampos)
	cQuery += aCampos[nI]
	If nI <> Len(aCampos)
		cQuery += ","
	EndIf
	nTotP++
Next nI

cQuery += " FROM " +RetSqlName("SN1")
cQuery += " WHERE N1_CHAPA = '"+cPatrimo+"' AND D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")

If !EOF()
	For nI := 1 To nTotP
		If !Empty( TRB->&( "N1_XP" +cvaltochar(nI) ) )
			nPOk++			
		EndIf
	Next nI
EndIf
dbCloseArea()

If nPOk == 0
	lPVazio := .T.
EndIf	

Return lPVazio


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mail      �Autor  �Jackson E. de Deus  � Data �  10/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail para o supervisor.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Mail(cPatrimo,cdestino)

Local cRemete := "microsiga"
Local cAssunto := "Patrim�nio com cadastro incompleto"
Local cHtml := ""
Local aAttach := {}
Local cModelo := AllTrim( Posicione("SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"), "N1_DESCRIC") )
Default cDestino := ""

If Empty(cDestino)
	Return
EndIf


cHtml := "<html>" +CRLF
cHtml += "<head>"+CRLF
cHtml += "<title>" +cAssunto +"</title>" +CRLF
			
// Estilos
cHtml += "<style type='text/css'>"	+CRLF
cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
cHtml += "	body { background-color: #FFFFFF;"	+CRLF
cHtml += "	color: #5D665B; "	+CRLF
cHtml += "	margin: 10px;"	+CRLF
cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
cHtml += "	font-size: small;"	+CRLF
//	cArqMail += "	line-height: 180%;"
cHtml += " 	}"	+CRLF
cHtml += "</style>"	+CRLF

cHtml += "</head>"	+CRLF

// Corpo
cHtml += "<body>"	+CRLF

cHtml += "<p>O patrim�nio "+cPatrimo +" - " +cModelo +" possui inconsist�ncia em seu cadastro.</p>"	+CRLF
cHtml += "<p>Favor cadastrar as doses atrav�s da rotina de configura��es de patrim�nios no m�dulo Gest�o de Contratos.</p>"	+CRLF

cHtml += "<br>"	+CRLF
cHtml += "<br>"	+CRLF

cHtml += "<p>" +Replicate("_",35) +"</p>"	+CRLF
cHtml += "<p>E-mail autom�tico enviado via protheus.</p>"	+CRLF
cHtml += "<p>Favor n�o responder.</p>"	+CRLF
cHtml += "</body>"	+CRLF
cHtml += "</html>"	+CRLF

U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)

Return