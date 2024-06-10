#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} M185BAIX
Ponto de entrada utilizado na baixa de requisições

Validar se a OS vinda do GFR já esta baixada e não permitir baixar a OS

@type user function
@author user
@since 06/06/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function M185BAIX()

Local aArea := GetArea()
Local lRet  := .T.
Local cOsSTJ    :=  If(!Empty(SCP->CP_OP),Posicione("STJ",1,SCP->CP_FILIAL+SUBSTR(SCP->CP_OP,1,6),"TJ_TERMINO"),"")
Local cDtEnc    :=  If(cOsSTJ=="S",Posicione("STJ",1,SCP->CP_FILIAL+SUBSTR(SCP->CP_OP,1,6),"TJ_DTMRFIM"),"")

If !Empty(cOsSTJ) .And. cOsSTJ == "S"
    MsgAlert("OP/OS já encerrada em "+cvaltochar(cDtEnc)+" - Procure o setor responsável","M185BAIX")
    lRet := .F.
EndIF 

RestArea(aArea)

Return(lRet)
