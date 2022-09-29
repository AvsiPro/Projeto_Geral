#include "protheus.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFAT23C�Autor  �Jackson E. de Deus    � Data �  27/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna totais de orcamentos								  ���
���          �Abastecimento												  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson	       �27/04/15�01.00 |Criacao                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TTFAT23C( cCliente,cLoja,cNumOrc,cCompet )
        
Local aArea := GetArea()
Local nValor := 0
Local cSql := ""
Local cUltDia := ""
Local dDtIni := STOD("")
Local dDtFim := STOD("")
Default cCliente := ""
Default cLoja := ""
Default cNumOrc := ""
Default cCompet := ""

If cEmpAnt <> "01"
	Return
EndIF

If Empty(cCliente) .And. Empty(cNumOrc)
	Conout("#TTFAT23C -> PARAMETROS INCORRETOS")
	Return nValor
EndIf

// consulta
cSql := "SELECT SUM(CK_VALOR) TOTAL FROM " +RetSqlName("SCK") +" SCK "
cSql += "INNER JOIN " +RetSqlName("SCJ") +" SCJ ON " 
cSql += "CJ_FILIAL = CK_FILIAL "
cSql += "AND CJ_NUM = CK_NUM "
cSql += "AND CJ_CLIENTE = CK_CLIENTE "
cSql += "AND CJ_LOJA = CK_LOJA "
cSql += "AND SCJ.D_E_L_E_T_ = SCK.D_E_L_E_T_ "
cSql += "WHERE "
cSql += "CK_FILIAL = '"+xFilial("SCK")+"' "

If !Empty(cCliente)
	cSql += "AND CK_CLIENTE = '"+cCliente+"' "
EndIf              
If !Empty(cLoja)
	cSql += "AND CK_LOJA = '"+cLoja+"' "
EndIf

// tudo da competencia
If Empty(cNumOrc) .And. !Empty(cCompet)
	cUltDia := strzero( Day(LastDay(STOD(cCompet+"01"))),2 ) 	// ultimo dia do mes da competencia
	dDtIni := STOD(cCompet+"01")
	dDtFim := STOD(cCompet+cUltDia)
	cSql += "AND CJ_EMISSAO BETWEEN '"+dDtIni+"' AND '"+dDtFim+"' "	
EndIf

// somente orcamento especifico
If !Empty(cNumOrc)
	cSql += "AND CK_NUM = '"+cNumOrc+"' "
EndIf


cSql += "AND SCK.D_E_L_E_T_ = '' "
/*
cSql += " AND CJ_XNUMOS <> '' "
cSql += " AND CJ_STATUS = 'A' "
cSql += " AND CK_NUMPV = '' "
*/
If Select("TRBQ") > 0
	TRBQ->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBQ"

dbSelectArea("TRBQ")
If !EOF()
	nValor := TRBQ->TOTAL
EndIf
TRBQ->( dbCloseArea() )
	
RestArea(aArea)

Return nValor