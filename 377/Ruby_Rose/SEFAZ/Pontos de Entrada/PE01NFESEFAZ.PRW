#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'
#INCLUDE 'APVT100.CH'

/*/
{Protheus.doc}	PE01NFESEFAZ
Ponto de Entrada ao finalizar o Processo de Embalagem.

@author				Paulo Lima
@since				01/02/2022
@return				Nil

Descrição:
Ponto de entrada localizado na função XmlNfeSef do rdmake NFESEFAZ. 
Através deste ponto é possível realizar manipulações nos dados do produto, mensagens adicionais, 
destinatário, dados da nota, pedido de venda ou compra, antes da 
montagem do XML, no momento da transmissão da NFe.

Programa Fonte:
NFESEFAZ.PRW
/*/

User Function PE01NFESEFAZ()
Local aArea		:= GetArea()
Local cPedido	:= ""
Local cNumeroNF := PARAMIXB[5][2]
Local cSerieNF  := PARAMIXB[5][1]
Local cDataHr   := DtoS(Date()) + Time()
Local cAlias 	:= getNextAlias()
Local aaParam    := aParam

	BeginSql Alias cAlias
		SELECT C5_FILIAL,C5_NUM,C5_NOTA,C5_SERIE
		  FROM %TABLE:SC5% SC5
		  WHERE %XFILIAL:SC5% = C5_FILIAL
		   AND C5_NOTA =  %exp:cNumeroNF%
		   AND C5_SERIE =  %exp:cSerieNF%
		   AND SC5.D_E_L_E_T_ = ' '
	EndSql
	(cAlias)->(dbGoTop())
	
	if !(cAlias)->(eof())
		cPedido 	:= (cAlias)->C5_NUM
	endIf

	(cAlias)->(dbCloseArea())

        dbSelectArea("ZZ1")
        if dbSeek(xFilial("ZZ1")+cPedido)
            RecLock("ZZ1",.F.)
                /*/
                ZZ1_FILIAL      := xFilial("ZZ1")
                ZZ1->ZZ1_PEDIDO := cPedido
                ZZ1->ZZ1_I_FS01 := cDataHr
                ZZ1->ZZ1_F_FS01 := SPACE(13)
                ZZ1->ZZ1_I_FS02 := SPACE(13)
                ZZ1->ZZ1_F_FS02 := cDataHr
                ZZ1->ZZ1_I_FS03 := cDataHr
                ZZ1->ZZ1_F_FS03 := SPACE(13)
                ZZ1->ZZ1_I_FS04 := SPACE(13)
                ZZ1->ZZ1_F_FS04 := cDataHr
                ZZ1->ZZ1_I_FS05 := cDataHr
                ZZ1->ZZ1_F_FS05 := cDataHr
                ZZ1->ZZ1_I_FS06 := cDataHr
                /*/
                ZZ1->ZZ1_F_FS06 := cDataHr
                /*/
                ZZ1->ZZ1_EXCLUS := cDataHr
                /*/
            MsUnlock()
        EndIf

        dbSelectArea("SC5")
        If dbSeek(xFilial("SC5")+cPedido)
            RecLock("SC5",.F.)
                SC5->C5_ZZSTATU := "E" //FATURADO
            MsUnlock()
        EndIf

    RestArea(aArea)
Return(aaParam)
