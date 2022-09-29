#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPER06  �Autor  �Jackson E. de Deus  � Data �  07/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna os horarios do plano de trabalho da rota	          ���
���          �															  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �07/07/14�01.00 |Criacao                                 ���
���Jackson       �20/10/14�01.01 |Inclusao de novo campo na consulta:	  ���
���									SZR->ZR_SEQ                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTOPER06(cCodFil,cRota, cCliente, cLoja, cPatrim, cAno, cMes, cDia, cSeq, cTpPlan)
                       
Local cQuery := ""
Local aRet := {}

Default cCodFil := ""
Default cRota := ""
Default cCliente := ""
Default cLoja := ""
Default cPatrim := ""
Default cAno := ""
Default cMes := ""
Default cDia := ""
Default cSeq := ""
Default cTpPlan := ""
                
// valida rota / cliente
If Empty(cRota) .And. Empty(cCliente)
	Return aRet
EndIf                         
                     
If cEmpAnt == "01"
	Return aRet
EndIf

cQuery := "SELECT * FROM " +RetSqlName("SZR") +" SZR "
cQuery += " WHERE "
cQuery += " ZR_FILIAL = '"+cCodFil+"' AND "

If !Empty(cRota)
	cQuery += " ZR_ROTA = '"+cRota+"' AND "
EndIf                                  

If !Empty(cCliente) 
	cQuery += " ZR_CLIENTE = '"+cCliente+"' AND "
EndIf

If !Empty(cLoja)
	cQuery += " ZR_LOJA = '"+cLoja+"' AND "
EndIf

If !Empty(cPatrim)
	cQuery += " ZR_CHAPA = '"+cPatrim+"' AND "
EndIf

If !Empty(cAno)
	cQuery += " ZR_ANO = '"+cAno+"' AND "
EndIf

If !Empty(cMes)	
	cQuery += " ZR_MES = '"+cMes+"' AND "
EndIf

If !Empty(cDia)
	cQuery += " ZR_DIA = '"+cDia+"' AND "
EndIf

If !Empty(cSeq)
	cQuery += " ZR_SEQ = '"+cSeq+"' AND "
EndIf

If !Empty(cTpPlan)
	cQuery += " ZR_TIPOPLA = '"+cTpPlan+"' AND "
EndIf

cQuery += " D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZR_ROTA, ZR_CLIENTE, ZR_LOJA, ZR_ANO, ZR_MES, ZR_DIA, ZR_CHAPA, ZR_HORA "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRBZ"

dbSelectArea("TRBZ")
While !EOF()
	AADD(aRet, {TRBZ->ZR_ROTA,; 
				TRBZ->ZR_CLIENTE,;
				TRBZ->ZR_LOJA,;
				TRBZ->ZR_CHAPA,;
				TRBZ->ZR_ANO,;
				TRBZ->ZR_MES,;
				TRBZ->ZR_DIA,;
				TRBZ->ZR_HORA,;
				TRBZ->ZR_SEQ,;
				TRBZ->R_E_C_N_O_,;
				TRBZ->ZR_NUMOS,;
				TRBZ->ZR_TIPOPLA })
	dbSkip()
End

Return aRet