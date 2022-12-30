#INCLUDE "PROTHEUS.CH"

Static cNomeFont  := "Arial" 

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦                                                     
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TINTA002 ¦ Autor ¦ Alexandre Venâncio     ¦ Data ¦ 07/04/22¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Fonte criado com o intuito de criar uma rotina de cadastro ¦¦¦
¦¦¦          ¦ de api para integrações.                            		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ SQUAD INTEGRADOR                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function TINTA003(cCodAPI)

Local nY            :=  0
Local nJ            :=  0
Private aList1      := {}
Private oList1  
Private aList2      := {}
Private aList2B     := {}
Private oList2
Private aList3      := {}
Private oList3
Private aList4      := {}
Private oList4
Private cTable      := space(3)
Private oOk   	    := LoadBitmap(GetResources(),'br_verde')   
Private oNo   	    := LoadBitmap(GetResources(),'br_vermelho') 
Private oPK         := LoadBitmap(GetResources(),'br_azul') 
Private oJn         := LoadBitmap(GetResources(),'br_amarelo')
Private aLsLeg      := {oNo,oOk,oPK,oJn}
Private cVariavel   := ''
Private cvarqry     :=  ''
Private cQryBkp     :=  ''
Private oFontTit    := TFont():New(cNomeFont, , -13, , .T.)
Private _cEfetiva   := "1"
Private _aItens     := {"1=Unico","2=Multiplos"}
Private cUrlApi     := space(150)
Private cEndPnt     := space(150)
Private cNomApi     := space(150)
Private cLimtApi    := space(4)
Private cCoringa    := ''
Private cCondWhr    := ''
Private cCondInr    := ''
Private aCmpBkp     := {}
Private cCodP36     := ''

Private oDlg1,oGrp1,oSay1,oSay2,oGet1,oGrp2,oFld1,oMGet1,oBtn3,oBtn4,oBrw3,oMGet2
Private oSay4,oSay5,oSay6,oBrw1,oBrw2,oGet2,oBrw4,oBtn1,oBtn2,oCBox1,oBtn5
Private cCodPAJ     :=  ''
Private aDestinos   :=  {}
Private lDestApi    :=  .F.
Private lAlterAp    :=  .F.
Default cCodAPI     :=  ''


cCodPAJ := cCodAPI

Aadd(aList1,{'','','','','','1','',''})
Aadd(aList2,{1,'','','','','','','','',''})
Aadd(aList3,{1,'','','','','','','','',''})
Aadd(aList4,{space(40),space(150),space(80),space(3),'','','','',''})

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

If !Empty(cCodAPI)
    DbSelectArea("PAJ")
    DbSetOrder(1)
    DbSeek(xFilial("PAJ")+cCodAPI)
    aTbl := separa(PAJ->PAJ_TABELA,"|")
    cNomApi := PAJ->PAJ_DESCRI
    cUrlApi := PAJ->PAJ_URL 
    cEndPnt := PAJ->PAJ_ENDPOI
    cLimtApi:= PAJ->PAJ_LIMITE
    cQryBkp := PAJ->PAJ_QUERY
    aCmpBkp := separa(PAJ->PAJ_CAMPOS,"|")
    cVariavel := PAJ->PAJ_JSON
    cCodP36 := PAJ->PAJ_CODP36
    aDestinos := Separa(PAJ->PAJ_DESTIN,"&")
    lAlterAp := .T.

    If len(aDestinos) > 0   
        aList4 := {}
        For nY := 1 to len(aDestinos)
            aBkLin  :=  Separa(aDestinos[nY],"|")
            aAux    := {}
            For nJ := 1 to len(aBkLin)
                Aadd(aAux,aBkLin[nJ])
            Next nJ
            If len(aAux) > 0
                Aadd(aList4,aAux)
            EndIf 
        Next nY
    EndIf

    For nY := 1 to len(aTbl)
        If !Empty(aTbl[nY])
            addtable(substr(aTbl[nY],1,3),_cEfetiva)
        EndIf
    Next nY 
EndIf 

Tela()

return

/*/{Protheus.doc} Tela
    Tela principal para criação do webhook
    @type  Static Function
    @author user
    @since 28/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Tela()

oDlg1      := MSDialog():New( 054,098,770,1397,"Cadastro de Processos Webhook",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,044,048,600,"Cadastro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 012,196,{||"Nome API"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 012,232,{|u|if(PCount()>0,cNomApi:=u,cNomApi)},oGrp1,224,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay2      := TSay():New( 032,128,{||"Chave única"},oGrp1,,oFontTit,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,412,008)
    
oGrp2      := TGroup():New( 052,012,324,632,"Tabelas e campos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oFld1      := TFolder():New( 064,016,{"Tabelas x Campos","Query x Filtros","Informações API envio","Schema Json"},{},oGrp2,,,,.T.,.F.,612,248,) 
    
    oSay3      := TSay():New( 016,004,{||"Informe a Tabela"},oFld1:aDialogs[1],,oFontTit,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,056,008)
    oGet2      := TGet():New( 028,004,{|u|if(PCount()>0,cTable:=u,cTable)},oFld1:aDialogs[1],048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    bSetGet := {|u| IIf(Pcount() > 0, _cEfetiva := u, _cEfetiva ) }
    oCBox1     := TComboBox():New( 040,004,bSetGet,_aItens,052,010,oFld1:aDialogs[1],,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

    oBtn5      := TButton():New( 052,004,"Incluir",oFld1:aDialogs[1],{|| addtable(cTable,_cEfetiva)},035,010,,,,.T.,,"",,,,.F. )
    
    oSay4      := TSay():New( 004,064,{||"Tabelas"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay5      := TSay():New( 004,240,{||"Campos"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay6      := TSay():New( 132,064,{||"Joins"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

    oList1:= 	TCBrowse():New(012,064,170,120,, {'','Tabela','Descricao','Tipo'},;
                                {10,30,40,30},;
                                oFld1:aDialogs[1],,,,{|| FHelp()},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{ aList1[oList1:nAt,01],; 
                         aList1[oList1:nAt,02],;
                         aList1[oList1:nAt,03],;
                         _aItens[val(aList1[oList1:nAt,06])]}}


    oMGet1     := TMultiGet():New( 004,004,{|u| If(PCount()>0,cvarqry:=u,cvarqry)},oFld1:aDialogs[2],600,188,oFontTit,,CLR_BLACK,CLR_WHITE,,.T.,"",,{|| cQryBkp := cvarqry},.F.,.F.,.T.,,,.F.,,,,,,  )
    
        oBtn3      := TButton():New( 204,208,"Ajustar",oFld1:aDialogs[2],{|| mudaqry()},037,012,,,,.T.,,"",,,,.F. )
        oBtn4      := TButton():New( 204,292,"Editar",oFld1:aDialogs[2],{|| editcol({},5)},037,012,,,,.T.,,"",,,,.F. )
    
    
    oList4:= 	TCBrowse():New(004,004,605,210,, {'Destino','URL Api','EndPoint','Limite Envio Itens'},;
                                    {40,60,50,40},;
                                    oFld1:aDialogs[3],,,,{|| /*FHelp()*/},{|| /*editapi()*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList4:SetArray(aList4)
    oList4:bLine := {||{aList4[oList4:nAt,01],; 
                        aList4[oList4:nAt,02],;
                        aList4[oList4:nAt,03],;
                        aList4[oList4:nAt,04]}}
        
        oBtn7      := TButton():New( 214,275,"+",oFld1:aDialogs[3],{|| editapi()},037,012,,,,.T.,,"",,,,.F. )
        
    oMGet2     := TMultiGet():New( 004,004,{|u| If(PCount()>0,cvariavel:=u,cvariavel)},oFld1:aDialogs[4],600,188,oFontTit,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
    
        oBtn6      := TButton():New( 204,228,"Ajustar",oFld1:aDialogs[4],{|| editcol({},0)},037,012,,,,.T.,,"",,,,.F. )
        oBtn6      := TButton():New( 204,298,"Editar",oFld1:aDialogs[4],{|| editcol({},4)},037,012,,,,.T.,,"",,,,.F. )
        
    oList2:= 	TCBrowse():New(012,240,368,218,, {'','Campo','Descricao','Tipo','Tamanho','Alias Integ.'},;
                                {10,30,40,30,30,30},;
                                oFld1:aDialogs[1],,,,{|| /*FHelp()*/},{|| editcol(oList2:nAt,2)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{ aLsLeg[aList2[oList2:nAt,01]],; 
                         aList2[oList2:nAt,02],;
                         aList2[oList2:nAt,03],; 
                         aList2[oList2:nAt,04],;
                         aList2[oList2:nAt,05],;
                         aList2[oList2:nAt,06]}}

    oList3  := 	TCBrowse():New(140,064,170,092,, {'','Campo1','Campo2'},;
                                {50,50},;
                                oFld1:aDialogs[1],,,,{|| /*FHelp()*/},{|| editcol(oList3:nAt,3)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList3:SetArray(aList3)
    oList3:bLine := {||{ aLsLeg[aList3[oList3:nAt,01]],;
                         aList3[oList3:nAt,02],; 
                         aList3[oList3:nAt,03]}}

    oBtn1      := TButton():New( 328,224,"Salvar",oDlg1,{|| gravar() },037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 328,340,"Cancelar",oDlg1,{|| oDlg1:end() },037,012,,,,.T.,,"",,,,.F. )
    //oBtn1:disable()

    MENU oMenu1 POPUP 
    MENUITEM "Alterar Tipo" ACTION ( alttipo() )
    MENUITEM "Remover tabela" ACTION ( deltable() )
    ENDMENU                                                                           

    oList1:bRClicked := { |oObject,nX,nY| oMenu1:Activate( nX, (nY-10), oObject ) }
    
    MENU oMenu2 POPUP 
    MENUITEM "Marcar/Desmarcar todos" ACTION ( editcol({},1))
    MENUITEM "Ordenar" ACTION ( ordenar())
    MENUITEM "Campo Coringa" ACTION ( coringa())
    MENUITEM "Informar Campos Join" ACTION ( joincpo())
    ENDMENU                                                                           

    oList2:bRClicked := { |oObject,nX,nY| oMenu2:Activate( nX, (nY-10), oObject ) }

oDlg1:Activate(,,,.T.)

Return
/*/{Protheus.doc} FHelp
    Atualiza o segundo grid de acordo com o primeiro grid(Tabela) selecionada
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function FHelp()

Local nCont 
aList2 := {}

oSay2:settext("")

For nCont := 1 to len(aList2B)
    If aList2B[nCont,07] == aList1[oList1:nAt,02]
        Aadd(aList2,aList2B[nCont])
    EndIf
Next nCont

If len(aList2) < 1
    Aadd(aList2,{1,'','','','',''})
ENDIF

oSay2:settext("Chave única "+aList1[oList1:nAt,4])
oList2:SetArray(aList2)
oList2:bLine := {||{ aLsLeg[aList2[oList2:nAt,01]],; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],; 
                            aList2[oList2:nAt,04],;
                            aList2[oList2:nAt,05],;
                            aList2[oList2:nAt,06]}}

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

return


/*/{Protheus.doc} addtable
    Incluir as tabelas no grid para envio dos dados
    @type  Static Function
    @author user
    @since 07/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @ Adiciona tabelas no grid.
    (examples)
    @see (links_or_references)
/*/
Static Function addtable(cAlias,_cEfetiva)
    
Local nCont 
Local aRetRelations :=  {}
Local lRet          :=  .F. 
Local aAuxJoin      :=  {}

Local aAux1         :=  {}
Local aAux2         :=  {}
Local nX            :=  0
Local lPriKey       :=  .T.

If Empty(aList1[1,2])
    aList1 := {}
EndIf 

cNome  := Alltrim(FWX2Nome( cAlias ))

If len(aList1) > 2 .Or. Ascan(aList1,{|x| x[2] == cAlias}) > 0
    //Somente poderão ser utilizadas tres tabelas no máximo.
    //Não permitir incluir a mesma tabela duas vezes

    RETURN
EndIf 

cvarqry := cQryBkp

If Empty(aList2[1,2])
    aList2 := {}
EndIf 

If Empty(aList3[1,2])
    aList3 := {}
EndIf 



If !Empty(cNome)
        
    If len(aList1) > 0
        lRet := FWSX9Util():SearchX9Paths( aList1[len(aList1),2], cAlias, @aRetRelations )

        If lRet 
            For nCont := 1 to len(aRetRelations)
                If aRetRelations[nCont,01] == aList1[len(aList1),2] .And. Alltrim(aRetRelations[nCont,03]) == cAlias
                    Aadd(aAuxJoin,{aRetRelations[nCont,02],aRetRelations[nCont,04]})
                EndIf
            Next nCont
        else
            MsgAlert("Não foi encontrado o relacionamento entre as tabelas no controle da SX9, faça o relacionamento manualmente")
            nPosP := Ascan(aList1,{|x| x[1] == "P"})
            If nPosP > 0
                aAux1 := separa(aList1[nPosP,04],"+")
                //Encontrou Primary key na tabela considerada principal da integração
                If len(aAux1) > 0
                    For nCont := 1 to len(aAux1)
                        Aadd(aList3,{1,aAux1[nCont],""})
                    Next nCont 
                else
                    lPriKey := .F.
                EndIf
            EndIf
        EndIf 
    EndIf 

    cUnKey := FWX2Unico( cAlias )
    Aadd(aList1,{If(len(aList1)>0,'S','P'),cAlias,Alltrim(cNome),cUnKey,'',_cEfetiva})

    If !lPriKey .And. len(aList1) > 1 .And. !Empty(cUnKey)
        aAux1 := separa(cUnKey,"+")
        If len(aAux1) > 0
            For nCont := 1 to len(aAux1)
                Aadd(aList3,{1,aAux1[nCont],""})
            Next nCont 
        EndIf
    EndIf 

    aCampos := FWSX3Util():GetListFieldsStruct( cAlias , .F. ) 

    For nCont := 1 to len(aCampos)
        aCampos[nCont,04] := FWSX3Util():GetDescription( aCampos[nCont,01] )
        lCmp := Ascan(aCmpBkp,{|x| Alltrim(x) == Alltrim(aCampos[nCont,01])}) > 0
        Aadd(aList2B,{If(lCmp,2,1),aCampos[nCont,01],aCampos[nCont,04],aCampos[nCont,02],aCampos[nCont,03],If(lCmp,lower(strtran(strtran(aCampos[nCont,04],".")," ","_")),''),cAlias,len(aList2b)+1})
    Next nCont


    For nCont := 1 to len(aAuxJoin)
        aAux1 := separa(aAuxJoin[nCont,01],"+")
        aAux2 := separa(aAuxJoin[nCont,02],"+")
        For nX := 1 to len(aAux1)
            Aadd(aList3,{1,aAux1[nX],aAux2[nX]})
        Next nX
    Next nCont

    If len(aList3) < 1
        Aadd(aList3,{1,'',''})
    EndIf

    //If Empty(cQryBkp)
    If !lAlterAp
        MntStrQr(cAlias)  //funcao que monta a query inicial
    EndIf 
    //EndIf 

    aList2 := {}

    If len(aList2B) > 0
        For nCont := 1 to len(aList2B)
            If aList2B[nCont,07] == aList1[If(oList1<>Nil,oList1:nAt,len(aList1)),02]   
                Aadd(aList2,aList2B[nCont])
            EndIf
        Next nCont
    Else
        Aadd(aList2,{1,'','','','',''})
    EndIf 

    If oList1 <> Nil

        oList1:SetArray(aList1)
        oList1:bLine := {||{ aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            _aItens[val(aList1[oList1:nAt,06])]}}

        oList2:SetArray(aList2)
        oList2:bLine := {||{ aLsLeg[aList2[oList2:nAt,01]],; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],; 
                            aList2[oList2:nAt,04],;
                            aList2[oList2:nAt,05],;
                            aList2[oList2:nAt,06]}}

        oList3:SetArray(aList3)
        oList3:bLine := {||{ aLsLeg[aList3[oList3:nAt,01]],;
                            aList3[oList3:nAt,02],; 
                            aList3[oList3:nAt,03]}}
        
        fhelp()
        oList1:refresh()
        oList2:refresh()
        oList3:refresh()
        oDlg1:refresh()
    EndIf 
else
    MsgAlert("Tabela inexistente")
EndIf

Return

/*/{Protheus.doc} editcol
    Edicao das linhas, querys e json disparado conforme botão ou item selecionado nos grids
    @type  Static Function
    @author user
    @since 08/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha,nOpc)

Local aArea     :=  GetArea()
Local cVirg     :=  ''
Local cAux      :=  ''
Local nCont
Local nCon2     
Local aAux      :=  {}
Local cAxJson   :=  ""

If nOpc == 0

    //Atualizar json
    aAux := Strtokarr(aList1[1,4],"+")
    Aeval(aAux,{|x| cAxJson += '%'+x+'%'})

    cVariavel := '{'+CRLF
    cVariavel += '"table":'+'"'+aList1[1,2]+'",'+CRLF
    cVariavel += '"pk":'+'"'+cAxJson+'",'+CRLF
    cVariavel += '"fields":'+CRLF 
    cVariavel += '{'+CRLF
    
    For nCont := 1 to len(aList1)
        If aList1[nCont,06] == "2"
            cVariavel += If(nCont==2,'},' + CRLF,CRLF) + aList1[nCont,2]+': ['+CRLF+'{'+CRLF
            cVirg := ""
        EndIF
    
        For nCon2 := 1 to len(aList2B)
            IF aList1[nCont,2] == aList2B[nCon2,7] .And. aList2B[nCon2,1] == 2
                If lDestApi
                    cVariavel += cVirg+'"'+Alltrim(aList2B[nCon2,02])+'" : "%'+Alltrim(aList2B[nCon2,02])+'%"'+CRLF
                Else 
                    cVariavel += cVirg+'"'+lower(strtran(strtran(aList2B[nCon2,03],".")," ","_"))+'" : "%'+Alltrim(aList2B[nCon2,02])+'%"'+CRLF
                EndIf 
                cVirg := ','
            Endif 
        Next nCon2

        If aList1[nCont,06] == "2"
            cVariavel += '}'+CRLF+'],'+CRLF 
        EndIf 
    Next nCont

    cVariavel += '}'+CRLF
    cVariavel += '}'
    

ElseIf nOpc == 1

    IF !lDestApi
        If MsgYesNo("API de Destino é um ambiente Protheus?")
            lDestApi := .T.
        EndIf 
    EndIf 

    For nCont := 1 to len(aList2)
        If aList2[nCont,01] == 1
            aList2[nCont,01] := 2
            If lDestApi
                aList2[nCont,06] := Alltrim(aList2[nCont,02])
            Else
                aList2[nCont,06] := lower(strtran(strtran(aList2[nCont,03],".")," ","_"))
            EndIf 
        Else
            aList2[nCont,01] := 1 
            cAux := '"'+lower(strtran(strtran(aList2[nCont,03],".")," ","_"))+'" : %'+Alltrim(aList2[nCont,02])+'%'+cVirg+CRLF
            aList2[nCont,06] := ''
        EndIf
    Next nCont

ElseIf nOpc == 2

    IF !lDestApi
        If MsgYesNo("API de Destino é um ambiente Protheus?")
            lDestApi := .T.
        EndIf 
    EndIf 

    If aList2[nLinha,01] == 1
        aList2[nLinha,01] := 2

        If lDestApi
            aList2[nCont,06] := Alltrim(aList2[nCont,02])
        Else
            aList2[nLinha,06] := lower(strtran(strtran(aList2[nLinha,03],".")," ","_"))
        EndIf 
    else
        aList2[nLinha,01] := 1 
        cAux := '"'+lower(strtran(strtran(aList2[nLinha,03],".")," ","_"))+'" : %'+Alltrim(aList2[nLinha,02])+'%'+cVirg+CRLF
        aList2[nLinha,06]  := ''
    EndIf

elseIf nOpc == 3

    If aList3[nLinha,01] == 1
        aList3[nLinha,01] := 2
    else
        aList3[nLinha,01] := 1 
    Endif 

elseIf nOpc == 4
    oMGet2:lReadOnly := .F.
    oMGet2:refresh()
    oDlg1:refresh()   
elseif nOpc == 5
    oMGet1:lReadOnly := .F.
    oMGet1:refresh()
    oDlg1:refresh()
EndIf

Asort(aList2B,,,{|x,y| x[8] < y[8]})

oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editapi
    Edicao das apis de destino a serem configuradas
    @type  Static Function
    @author user
    @since 29/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editapi()

Local lAlterou  := .F.
Local nCont

If !Empty(aList4[len(aList4),01])
    Aadd(aList4,{space(40),space(150),space(80),space(3),'','','','',''})
    oList4:SetArray(aList4)
    oList4:bLine := {||{aList4[oList4:nAt,01],; 
                        aList4[oList4:nAt,02],;
                        aList4[oList4:nAt,03],;
                        aList4[oList4:nAt,04]}}
    oList4:nAt := len(aList4)
    oList4:refresh()
    oDlg1:refresh()
EndIf 

For nCont := 1 to 4
    lAlterou := .F.
    While !lAlterou
        lEditCell(aList4,oList4,'',nCont)    
        If !Empty(aList4[len(aList4),nCont])
            lAlterou := .T.
        EndIf
    ENDDO
Next nCont

oList4:nAt := 1
oList4:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} ordenar
    Ordenacao do grid de campos
    @type  Static Function
    @author user
    @since 13/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ordenar()

Local aPergs    := {}
Local aRet      :=  {}
Local aOrdem    :=  {'1=Ordem Alfabetica','2=Ordem configurador'}
Local nOpc      :=  0

aAdd( aPergs ,{2,"Ordenar por?","1" , aOrdem , 100,'.T.',.F.})
	
If ParamBox(aPergs ,"Ordem",@aRet)
    nOpc := aRet[1]
    If val(nOpc) == 1
        Asort(aList2,,,{|x,y| x[2] < y[2]})
    Else
        Asort(aList2,,,{|x,y| x[8] < y[8]})
    EndIf

    oList2:refresh()
    oDlg1:refresh()
EndIf

Return

/*/{Protheus.doc} mudaqry()
    Atualizacao da query gerada pela rotina
    @type  Static Function
    @author user
    @since 04/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function mudaqry()

Local aArea     := GetArea()
Local cQuery    := cQryBkp
Local nCont
Local cVirg     :=  ''
Local cCmps     :=  ''
Local cJoin     :=  ''
Local lCmpsel   :=  .F.
Local lJonsel   :=  .F.
Local lOkQry    :=  .T.
Local lCoring   :=  .F.

For nCont := 1 to len(aList2B)
    If aList2B[nCont,01] == 2
        If aList2B[nCont,04] == "M"
            cCmps += cVirg + 'UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr('+Alltrim(aList2B[nCont,02])+', 2000, 1)) AS '+Alltrim(aList2B[nCont,02])
        Else
            cCmps += cVirg + Alltrim(aList2B[nCont,02])
        EndIf 
        cVirg := ','
        lCmpsel := .T.
    EndIf

    If aList2B[nCont,01] == 3
        lCoring := .T.
        cCoringa := Alltrim(aList2B[nCont,02])
    EndIf
Next nCont

cVirg := ''

For nCont := 1 to len(aList3)
    If aList3[nCont,01] == 2
        cJoin += cVirg + Alltrim(aList3[nCont,02]) + "=" + Alltrim(aList3[nCont,03])
        cVirg := " AND "
        lJonsel := .T.
    EndIf
Next nCont

If lCmpsel  
    If AT('[%CAMPOS%]',cQuery) > 0
        cQuery := strtran(cQuery,"[%CAMPOS%]",cCmps)
    Else
        cQrnew := substr(cQuery,1,8)+CRLF+cCmps+CRLF+substr(cQuery,AT("FROM",CQUERY))
        cQuery := cQrnew 
    EndIF 
else
    MsgAlert("Não foram informados os campos para retorno da Query")
    lOkQry := .F.
ENDIF

If lJonSel
    cQuery := strtran(cQuery,"[%JOIN_CAMPOS%]",cJoin)
else
    If len(aList1) > 1  
        MsgAlert("Não foram informados os campos de Join entre as tabelas")
        lOkQry := .F.
    EndIf
EndIf

If lCoring
    cQuery := strtran(cQuery,"%CORINGA%",cCoringa)
EndIf

If lOkQry 
    cvarqry := cQuery
else
    cvarqry := cQryBkp
EndIf

RestArea(aArea)

Return 


/*/{Protheus.doc} joincpo()scription)
    Criacao do join entre as tabelas selecionadas
    @type  Static Function
    @author user
    @since 04/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function joincpo()

Local aArea :=  GetArea()
Local nPosL2B   :=  Ascan(aList2B,{|x| Alltrim(x[2]) == Alltrim(aList3[oList3:nAT,02])}) 
Local nIgual    :=  0

If aList2B[nPosL2B,04] == aList2[oList2:nAt,04]
    nIgual++
EndIF 

If aList2B[nPosL2B,05] == aList2[oList2:nAt,05]
    nIgual++
EndIF 

If aList2B[nPosL2B,07] <> aList2[oList2:nAt,07]
    nIGual++
ENDIF

If nIgual <> 3
    MsgAlert("Os campos que estão sendo relacionados são de formato ou tamanhos diferentes e não poderão ser utilizados no Join entre as tabelas.")
else
    aList3[oList3:nAt,03] := aList2[oList2:nAt,02]
    aList3[oList3:nAt,01] := 2
EndIf 

oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

Return


/*/{Protheus.doc} alttipo
    Altera os tipos das tabelas selecionadas entre primaria e secundaria
    @type  Static Function
    @author user
    @since 05/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function alttipo()
    
If aList1[oList1:nAt,06] == '1'
    aList1[oList1:nAt,06] := '2'
else
    aList1[oList1:nAt,06] := '1'
ENDIF

oList1:refresh()
oDlg1:refresh()

Return 

/*/{Protheus.doc} deltable
    Apaga uma tabela selecionada
    @type  Static Function
    @author user
    @since 07/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function deltable()

Local aArea :=  GetArea()
Local lItem :=  .T.
Local nPos
Local nTamL2 := len(aList2B)
Local nInicio 

If MsgYesNo("Deseja remover esta tabela?")
    aList3 := {}

    Asort(aList2B,,,{|x,y| x[7] < y[7]})
    nPos := Ascan(aList2B,{|x| x[7] == aList1[oList1:nAt,02]})
    nInicio := nPos    
    While lItem
        If aList2B[nPos,07] == aList1[oList1:nAt,02]
            Adel(aList2B,nPos)
            Asize(aList2B,len(aList2B)-1)
        EndIf
        nInicio++
        If nInicio > nTamL2
            lItem := .F.
        EndIf 
    EndDo

    Adel(aList1,oList1:nAt)
    Asize(aList1,len(aList1)-1)

    Asort(aList2B,,,{|x,y| x[8] < y[8]})

    If len(aList1) < 1
        Aadd(aList1,{'','','','','','1','',''})
    EndIf 

    If len(aList2B) < 1
        Aadd(aList2B,{1,'','','','','','',1,'',''})
    EndIf 

    If len(aList3) < 1
        Aadd(aList3,{1,'','','','','','','','',''})
    EndIf 

    oList1:nAt := 1
    oList2:nAt := 1
    oList3:nAt := 1
    
    oList1:SetArray(aList1)
    oList1:bLine := {||{ aList1[oList1:nAt,01],; 
                         aList1[oList1:nAt,02],;
                         aList1[oList1:nAt,03],;
                         _aItens[val(aList1[oList1:nAt,06])]}}

    oList2:SetArray(aList2)
    oList2:bLine := {||{ aLsLeg[aList2[oList2:nAt,01]],; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],; 
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06]}}

    oList3:SetArray(aList3)
    oList3:bLine := {||{ aLsLeg[aList3[oList3:nAt,01]],;
                         aList3[oList3:nAt,02],; 
                         aList3[oList3:nAt,03]}}

    oList1:refresh()
    oList2:refresh()
    oList3:refresh()
    oDlg1:refresh()
    
    cvarqry := ''
    

    MntStrQr(aList1[len(aList1),02])
    editcol(len(aList1),0)
    Fhelp()
EndIf 

RestArea(aArea)

Return


/*/{Protheus.doc} MntStrQr
    Ajusta a estrutura da query a ser utilizada pela rotina
    @type  Static Function
    @author user
    @since 07/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MntStrQr(cAlias)

Local cAuxQry       :=  ''

If Empty(cvarqry)
    cpofil  := substr(aList1[len(aList1),04],1,At('+',aList1[len(aList1),04])-1)

    If Empty(cpofil)
        cpofil := If(substr(cAlias,1,1)<>"S",Alltrim(cAlias),substr(cAlias,2))+"_FILIAL"
    EndIf 

    cvarqry := "SELECT "+CRLF
    cvarqry += " [%CAMPOS%] "+CRLF
    cvarqry += " FROM "+RetSQLName(cAlias)+" "+cAlias+CRLF
    cvarqry += " WHERE "+cpofil+"='"+xFilial(cAlias)+"' AND "+cAlias+".D_E_L_E_T_=' '"+CRLF
    cvarqry += " AND COALESCE(TO_CHAR("+cAlias+".S_T_A_M_P_,'YYYYMMDDHH24MISS'),'19810101000000' ) >= 'CTIMESTAMP' "

    If !Empty(cCondWhr)
        cvarqry += cCondWhr
    EndIf 
else
    cpofil  := substr(aList1[len(aList1),04],1,At('+',aList1[len(aList1),04])-1)

    If Empty(cpofil)
        cpofil := If(substr(cAlias,1,1)<>"S",Alltrim(cAlias),substr(cAlias,2))+"_FILIAL"
    EndIf 

    cAuxQry := SUBSTR(cvarqry,AT("WHERE",cvarqry))
    cvarqry := SUBSTR(cvarqry,1,AT("WHERE",cvarqry)-1)
    cvarqry += " INNER JOIN "+RetSQLName(cAlias)+" "+cAlias+" ON "
    //cvarqry += " [%JOIN_CAMPOS%] "+CRLF
    //cvarqry += "  AND "+cpofil+"='"+xFilial(cAlias)+"' AND "+cAlias+".D_E_L_E_T_=' '"+CRLF
    cvarqry += cpofil+"='"+xFilial(cAlias)+"' AND "+cAlias+".D_E_L_E_T_=' '"+CRLF
    

    If !Empty(cCondInr)
        cvarqry += cCondInr
    EndIF 

    cvarqry += Alltrim(cAuxQry) + CRLF 

    If !'%JOIN_CAMPOS%' $ cvarqry 
        cvarqry += " AND [%JOIN_CAMPOS%] "+CRLF
    EndIf 
EndIf

cQryBkp := cvarqry

Return

/*/{Protheus.doc} coringa
    Campo coringa a ser utilizado quando nao houver uma ligação direta entre as tabelas
    @type  Static Function
    @author user
    @since 07/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function coringa()
    
Local aArea :=  GetArea()

If Empty(cCoringa)
    aList2[oList2:nAt,01] := 3
    cCoringa := aList2[oList2:nAt,02]
    cvarqry  := strtran(cvarqry,"%CORINGA%",cCoringa)
    oList2:refresh()
    oDlg1:refresh()
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} gravar
    Grava os dados nas tabelas de controle do webhook
    @type  Static Function
    @author user
    @since 07/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravar()

Local aArea     :=  GetArea()
Local lOk       :=  .T.
Local cCodigo 
Local cTabelas  := ''
Local cCampos   := ''
Local nCont     :=  0
Local cApiDst   := ''
Local lP36      := .F.

If '[%CAMPOS%]' $ cvarqry
    lOk := .F.
EndIf 

If '[%JOIN_CAMPOS%]' $ cvarqry
    lOk := .F.
EndIf

For nCont := 1 to len(aList4)
    If Empty(aList4[nCont,01])
        lOk := .F.
    EndIf
Next nCont

If Empty(cvariavel)
    lOk := .F.
EndIf 

If Empty(cNomApi)
    lOk := .F.
EndIf 

If Empty(cCoringa)
    //lOk := .F.
EndIf

If lOk 
    
    Aeval(aList1,{|x| cTabelas += x[2]+'='+x[6]+'|'})
    Aeval(aList2B,{|x| cCampos += If(cvaltochar(x[1]) = '2',Alltrim(x[2])+'|','')})
    Aeval(aList4,{|x| cApiDst += x[1]+"|"+x[2]+"|"+x[3]+"|"+x[4]+"&"})

    Begin Transaction
    //Criando fila Webhook 
    If Empty(cCodPAJ)
        cCodigo := GetSxEnum("PAJ","PAJ_CODIGO")
        ConfirmSx8()
    else
        cCodigo := cCodPAJ
    EndIf 
    
    If Empty(cCodP36)
        cCodP36 := GETSXENUM("P36","P36_CODIGO")
        ConfirmSX8()
        lP36 := .T.
    EndIf 
    
    DbSelectArea("PAJ")
    DbSetOrder(1)
    
    If Empty(cCodPAJ)
        Reclock("PAJ",.T.)
    else
        Reclock("PAJ",.F.)
    EndIF 

    PAJ->PAJ_CODIGO := cCodigo
    PAJ->PAJ_DESCRI := cNomApi
    PAJ->PAJ_JSON   := cvariavel 
    PAJ->PAJ_URL    := cUrlApi
    PAJ->PAJ_ENDPOI := cEndPnt
    PAJ->PAJ_QUERY  := cvarqry
    PAJ->PAJ_TABELA := cTabelas
    PAJ->PAJ_LIMITE := cLimtApi
    PAJ->PAJ_CAMPOS := cCampos
    PAJ->PAJ_CODP36 := cCodP36
    PAJ->PAJ_DESTIN := cApiDst
    PAJ->(MsUnlock())
    
    //Gravar no cadastro de APIs do Interceptor
    DbSelectArea("P36")
    DbSetOrder(1)
    
    If lP36
        Reclock("P36",.T.)
    Else
        DbSeek(xFilial("P36")+cCodP36)
        Reclock("P36",.F.)
    EndIf 

    P36->P36_FILIAL := xFilial("P36")
    P36->P36_DATA   := DDATABASE
    P36->P36_CODIGO := cCodP36
    P36->P36_TIPORE := '1'
    P36->P36_DESCRI := cNomApi
    P36->P36_URL	:= cUrlApi
    P36->P36_PATH   := cEndPnt
    P36->P36_METHOD := '2'
    P36->P36_TIPO   := '1'
    P36->P36_ASYNC  := 'S'
    P36->P36_AUTHEN := 'N'
    P36->P36_STATUS := 'A'
    P36->P36_CALLBA := 'U_TINTA004'
    P36->P36_FILA   := 'WEBHOOK'
    P36->P36_NFILA  := 4
    P36->(MsUnlock())


    End Transaction 
    
    oDlg1:end()

EndIf 

RestArea(aArea)

Return
