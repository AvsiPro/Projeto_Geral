#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 01/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function PILEST03(cSolic)

Local aArea     :=  GetArea()
Local aItens    :=  {}
Local nCont 

DbSelectArea("SCP")
DbSetOrder(1)
DbSeek(xFilial("SCP")+cSolic)

While !EOF() .AND. SCP->CP_NUM == cSolic 
    Aadd(aItens,{SCP->CP_NUM,SCP->CP_ITEM})
    Dbskip()
EndDo 

For nCont := 1 to len(aItens)
    execbx(aItens[nCont,01],aItens[nCont,02])
Next nCont 

RestArea(aArea)

Return 

/*/{Protheus.doc} efetbaixa
    (long_description)
    @type  Static Function
    @author user
    @since 01/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function execbx(cNum,cItem)
    
Local aCamposSCP
Local aCamposSD3

Local aRelProj
Default cNum  := "" // No.da Requisicao
Default cItem := "" // No.do Item da Req.


dbSelectArea("SCP")

dbSetOrder(1)
If SCP->(dbSeek(xFilial("SCP")+cNum+cItem))
    aCamposSCP := { {"CP_NUM" ,SCP->CP_NUM ,Nil },;
                    {"CP_ITEM" ,SCP->CP_ITEM ,Nil },;
                    {"CP_QUANT" ,SCP->CP_QUANT ,Nil }}

    aCamposSD3 := { {"D3_TM" ,"501" ,Nil },; // Tipo do Mov.
                    {"D3_COD" ,SCP->CP_PRODUTO,Nil },;
                    {"D3_LOCAL" ,SCP->CP_LOCAL ,Nil },;
                    {"D3_DOC" ,"" ,Nil },; // No.do Docto.
                    {"D3_EMISSAO" ,DDATABASE ,Nil }}


    //Dados para atualização do vinculo com pms (opcional)
    aRelProj := {}

    lMSHelpAuto := .F.
    lMsErroAuto := .F.

    MSExecAuto({|v,x,y,z,w| mata185(v,x,y,z,w)},aCamposSCP,aCamposSD3,1,,aRelProj)   // 1 = BAIXA (ROT.AUT)

    If lMsErroAuto
        MostraErro()
    EndIF

EndIf

Return Nil
