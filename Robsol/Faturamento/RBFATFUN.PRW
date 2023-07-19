#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xC5IDPRO(nOpc)

Local cRet := ""

If nOpc == "1"
    cRet := POSICIONE("Z02",1,XFILIAL("Z02")+POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XIDPROP"),"Z02_NOMPRO")
Else 
    cRet := POSICIONE("Z02",1,XFILIAL("Z02")+POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_XIDPROP"),"Z02_NOMPRO")
EndIf

Return(cRet)

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xC5IDBAN(nOpc)
    
Local cRet := ""

If nOpc == "1"
    cRet := POSICIONE("Z01",1,XFILIAL("Z01")+POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XBANDEI"),"Z01_DESBAN")
else
    cRet := POSICIONE("Z01",1,XFILIAL("Z01")+POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_XBANDEI"),"Z01_DESBAN")
ENDIF

Return(cRet)
