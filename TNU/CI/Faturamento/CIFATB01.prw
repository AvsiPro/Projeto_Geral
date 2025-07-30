#include "totvs.ch"
/*/{Protheus.doc} CIFATB01
Monitor de integração com E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function CIFATB01()
local   aArea     := getArea()
local   cCondicao
private aRotina   := {}
private aCores    := {}
private cCadastro := "Monitor de Integração E-Notas"

    aAdd( aRotina, {"Pesquisar"                 ,"axPesqui"    , 0, 1} )
    aAdd( aRotina, {"Visualizar"                ,"axVisual"    , 0, 2} )
    aAdd( aRotina, {"Legenda"                   ,"u_CFTB1Leg", 0, 8} )
    aAdd( aRotina, {"Request"   ,"u_CFTB1Req", 0, 7} )
    //aAdd( aRotina, {"Exec.JOB"  ,"u_CFTB1JOB", 0, 9} )
    aAdd( aRotina, {"Limpar RPS"                ,'FWMsgRun(,{|| u__LimpaZPE()},"","Limpando os dados da tabela ZPE...")', 0, 8} )
    aAdd( aRotina, {"Alterar Cliente"           , 'FWMsgRun(,{|| u__ChgCli()},"","Buscando os dados do cliente")', 0, 4} )
    aAdd( aRotina, {"Cancelar RPS"              , 'FWMsgRun(,{|| u__CanRPS()},"","Cancelando RPS")', 0, 4} )
    aAdd( aRotina, {"Cancelar NFs Prefeitura"   , 'FWMsgRun(,{|| u__CanNFS()},"","Cancelando NFs Prefeitura")'   , 0, 9} )
    //_Filial, _Doc, _Serie, lQuiet
    aAdd(aCores ,{ 'ZPE_STATUS="1"', 'BR_BRANCO'  , 'Enviado E-Notas'          })
    aAdd(aCores ,{ 'ZPE_STATUS="2"', 'BR_AMARELO' , 'Recusado E-Notas'         })
    aAdd(aCores ,{ 'ZPE_STATUS="3"', 'BR_VERMELHO', 'Negado Prefeitura'        })
    aAdd(aCores ,{ 'ZPE_STATUS="4"', 'BR_AZUL'    , 'Autorizado Prefeitura'    })
    aAdd(aCores ,{ 'ZPE_STATUS="5"', 'BR_CINZA'   , 'Em Autorização Prefeitura'})
    aAdd(aCores ,{ 'ZPE_STATUS="6"', 'BR_LARANJA' , 'Outros Prefeitura'        })

    cCondicao := "ZPE_LAST=' '"

    dbSelectArea("ZPE")
    dbSetOrder(1)
    dbGotop()
    mBrowse( 6, 1,22,75,"ZPE",,,,,,aCores,,,,,,,,cCondicao)

    restArea(aArea)
return nil


/*/{Protheus.doc} CFTB1Leg
Legenda das cores do browse
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function CFTB1Leg()
local aLeg := {}
local nI

    for nI := 1 to len( aCores )
        aAdd( aLeg, { aCores[nI][2], aCores[nI][3]})
    next

    brwLegenda( cCadastro, "Tela", aLeg)
return nil


/*/{Protheus.doc} CFTB1Req
Exibe a Requisição e Retorno do E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function CFTB1Req()
local cMsg    := alltrim( ZPE->ZPE_REQUES )
local cNewMsg := ""

    If !"NEGADA" $ UPPER(alltrim(ZPE->ZPE_RETORN))
        cNewMsg += "REQUISIÇÃO: "+CRLF
        cNewMsg += U_JSONform( cMsg, .T. ) + CRLF+CRLF

        cMsg := alltrim( ZPE->ZPE_RETORN )
        cNewMsg += "RETORNO: "+CRLF
        cNewMsg += U_JSONform( cMsg, .T. ) + CRLF

        
    Else 
        cMsg := alltrim( ZPE->ZPE_RETORN )
        cNewMsg += "MOTIVO REJEIÇÃO: "+CRLF
        cNewMsg += U_JSONform( cMsg, .T.,,.T. ) + CRLF
    endIf 

    if Aviso( "Monitor E-Notas", cNewMsg, {"Fechar", "Copiar"}, 3 ) == 2
        CopytoClipboard ( cNewMsg )
        msgInfo( "conteúdo copiado para a área de transferência", "Monitor E-Notas")
    endif
return nil


/*/{Protheus.doc} CFTB1JOB
Força a execução do JOB sob demanda
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
/*/
user function CFTB1JOB
    if msgYesNo("Deseja executar o JOB de integração agora?", cCadastro)
        startJob("U_jEnvENotas",GetEnvServer(),.F.)
    endif
return nil

/*/{Protheus.doc} MnLimpaZPE
(long_description)
@type user function
@author user
@since 10/07/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function _LimpaZPE()

Local aArea     := GetArea()
Local aRecnos   :=  {}
Local cQuery 
Local nCont 
Local cFilde    :=  space(tamsx3("ZPE_FILIAL")[1])
Local cRPSde    :=  space(tamsx3("ZPE_DOC")[1])
Local cRPSAt    :=  space(tamsx3("ZPE_DOC")[1])
Local cSerde    :=  space(tamsx3("ZPE_SERIE")[1])
Local aPergs    :=  {}
Local aRet      :=  {}
Local lRange    :=  .F.

aAdd(aPergs,{1,"Filial ? "      ,cFilde,"@!",'.T.',"SM0",'.T.',80,.F.})  
aAdd(aPergs,{1,"RPS De? "       ,cRPSde,"@!",'.T.',,'.T.',80,.F.})   
aAdd(aPergs,{1,"RPS Até? "      ,cRPSAt,"@!",'.T.',,'.T.',80,.F.})
aAdd(aPergs,{1,"Serie De? "     ,cSerde,"@!",'.T.',,'.T.',80,.F.})

If ParamBox(aPergs ,"Informe o Range a ser limpo ",aRet)   
    lRange := .T.
    cFilde := aRet[1] 
    cRPSde := aRet[2]
    cRPSAt := aRet[3]
    cSerde := aRet[4]
EndIf 

cQuery := " SELECT ZPE.R_E_C_N_O_ AS RECNOZPE"
cQuery += " FROM "+RetSQLName("ZPE")+" AS ZPE"
cQuery += " WHERE EXISTS (SELECT 1 FROM "+RetSQLName("SF2")+" AS SF2 WHERE  SF2.F2_FILIAL = ZPE.ZPE_FILIAL AND SF2.F2_DOC = ZPE.ZPE_DOC AND SF2.F2_SERIE = ZPE.ZPE_SERIE AND SF2.D_E_L_E_T_ = '*' )" 
cQuery += " AND ZPE.D_E_L_E_T_=' '"

If !lRange 
    cQuery += " AND ZPE_FILIAL='"+ZPE->ZPE_FILIAL+"'"
    cQuery += " AND ZPE_DOC='"+ZPE->ZPE_DOC+"' AND ZPE_SERIE='"+ZPE->ZPE_SERIE+"'"
Else 
    cQuery += " AND ZPE_FILIAL = '"+cFilde+"'"
    cQuery += " AND ZPE_DOC BETWEEN '"+cRPSde+"' AND '"+cRPSAt+"'"
    cQuery += " AND ZPE_SERIE = '"+cSerde+"'"
EndIF 

If Select("TRB") > 0
    TRB->(DbCloseArea())
EndIf

PlsQuery(cQuery, "TRB")
DbSelectArea("TRB")
While !EOF()
    Aadd(aRecnos,TRB->RECNOZPE)
    DBSkip()
EndDo 

If len(aRecnos) > 0
    If msgYesNo("Confirma a limpeza dos dados da tabela ZPE")
        DbSelectArea("ZPE")
        For nCont := 1 to len(aRecnos)
            DbGoto(aRecnos[nCont])
            Reclock("ZPE",.F.)
            ZPE->(DBDelete())
            ZPE->(Msunlock())
        Next nCont 

        MsgAlert("Processo finalizado!!!")
    EndIf 
Else 
    Msgalert("Nota fiscal ainda consta no sistema.")
EndIF 

RestArea(aArea)

Return

/*/{Protheus.doc} _ChgCli
Alterar cadastro do cliente da RPS
@type user function
@author user
@since 10/07/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function _ChgCli()

Public cCliente := Posicione("SF2",1,ZPE->ZPE_NFEINT,"F2_CLIENTE")
Public cFilCli  := Substr(ZPE->ZPE_NFEINT,1,6)

CRMA980({},4,{},{})

Return

/*/{Protheus.doc} _CanRPS
    Cancelar RPS
    @type  Static Function
    @author user
    @since 10/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function _CanRPS()

    Local aArea     := GetArea()
    Local aArea2    :=  {}
    Local aHeader   := {}
    Local lPref     := .F.
    Local nCont     :=  0 

    Local cFilde    :=  space(tamsx3("ZPE_FILIAL")[1])
    Local cRPSde    :=  space(tamsx3("ZPE_DOC")[1])
    Local cRPSAt    :=  space(tamsx3("ZPE_DOC")[1])
    Local cSerde    :=  space(tamsx3("ZPE_SERIE")[1])
    Local aPergs    :=  {}
    Local aRet      :=  {}
    Local lRange    :=  .F.

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    aAdd(aPergs,{1,"Filial ? "    ,cFilde,"@!",'.T.',"SM0",'.T.',80,.F.})  
    aAdd(aPergs,{1,"RPS De? "     ,cRPSde,"@!",'.T.',,'.T.',80,.F.})   
    aAdd(aPergs,{1,"RPS Até? "    ,cRPSAt,"@!",'.T.',,'.T.',80,.F.})
    aAdd(aPergs,{1,"Serie ? "     ,cSerde,"@!",'.T.',,'.T.',80,.F.})

    If ParamBox(aPergs ,"Informe o Range a ser limpo ",aRet)   
        lRange := .T.
        cFilde := aRet[1] 
        cRPSde := aRet[2]
        cRPSAt := aRet[3]
        cSerde := aRet[4]        
    EndIf 
    
    For nCont := val(cRPSde) to val(cRPSAt)
        DbSelectArea("ZPE")
        DbSetOrder(2)
        Dbseek(cFilde+strzero(nCont,9)+cSerde)
        lPref := CnsStatus()
        If !lPref
            DbSelectArea("SF2")
            DbSetOrder(1)
            //If Dbseek(ZPE->ZPE_FILIAL+ZPE->ZPE_DOC+ZPE->ZPE_SERIE)
            If Dbseek(cFilde+strzero(nCont,9)+cSerde)
                aArea2 := GetArea()

                AAdd(aHeader, {"F2_DOC",      SF2->F2_DOC   ,       NIL})
                AAdd(aHeader, {"F2_SERIE",    SF2->F2_SERIE ,       NIL})

                MsExecAuto({|x| MATA520(x)}, aHeader)

                If (lMsErroAuto)
                    MostraErro()

                Else
                    //Verificar aqui o que fazer ao cancelar
                    MsgAlert("RPS cancelado com sucesso!!!","CFTB1 - _CanRPS")
                    U__LimpaZPE()
                EndIf

                RestArea(aArea2)
                
                
            EndIf 
        EndIf 
    Next nCont 

    RestArea(aArea)
Return


/*/{Protheus.doc} _CanNFS
    Cancela NFS - nas prefeituras
    @type  Static Function
    @author user
    @since 11/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function _CanNFS()
    Local aArea := GetArea()
    Local lPref     := CnsStatus()

    If lPref
        u_canENotas(ZPE->ZPE_FILIAL,ZPE->ZPE_DOC,ZPE->ZPE_SERIE,.T.)
    EndIf 

    RestArea(aArea)
Return

/*/{Protheus.doc} nomeStaticFunction
    Validaçao se a nota já foi aprovada pela prefeitura
    @type  Static Function
    @author user
    @since 11/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CnsStatus()

    Local aArea := GetArea()
    Local lRet  := .F.
    Local cQuery    := ""    

    cQuery := "SELECT ZPE_DOC FROM "+RetSQLName("ZPE")
    cQuery += " WHERE ZPE_FILIAL='"+ZPE->ZPE_FILIAL+"' AND ZPE_DOC='"+ZPE->ZPE_DOC+"'"
    cQuery += " AND ZPE_SERIE='"+ZPE->ZPE_SERIE+"' AND D_E_L_E_T_=' '"
    cQuery += " AND ZPE_STATUS='4'"

    If Select("TRB") > 0
        TRB->(DbCloseArea())
    EndIf

    PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")
    
    If !Empty(TRB->ZPE_DOC)
        lRet := .T.
    EndIf 

    RestArea(aArea)
    
Return(lRet)
