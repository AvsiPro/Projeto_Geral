#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} INCFUN1()
Funções extras do Incorporador
Tabela de De/Para de prefixos/Series do incorporador 
@author
@since 05/10/2021
@version 1.0
/*/
//-------------------------------------------------------------------

User Function INCFUN1(cFilOrig)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT ZX5_CHAVE,ZX5_CHAVE2"
cQuery += " FROM "+RetSQLName("ZX5")+" ZX5"
cQuery += " WHERE ZX5.D_E_L_E_T_=' ' AND ZX5_FILIAL='"+cFilOrig+"'"
cQuery += " AND ZX5_TABELA ='_INCDP'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->ZX5_CHAVE,TRB->ZX5_CHAVE2})
    Dbskip()
EndDo

RestArea(aArea)

Return(aRet) 


//-------------------------------------------------------------------
/*/{Protheus.doc} INCFUN2()
Funções extras do Incorporador
Verificar funções já rodadas do incorporador
@author
@since 05/10/2021
@version 1.0
/*/
//-------------------------------------------------------------------

User Function INCFUN2(cFilOrig,cFilDest)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT PGH_IDPROC,PGH_DESC,PGH_FUNLOG,PGH_STEXEC FROM "+RetSQLName("PGH")+" PGH"
cQuery += " INNER JOIN "+RetSQLName("PGG")+" PGG ON PGG_FILIAL=' ' AND PGG_FILORI='"+cFilOrig+"' AND PGG_FILDES='"+cFilDest+"' AND PGG.D_E_L_E_T_=' ' AND PGG_IDPROC=PGH_IDPROC"
cQuery += " WHERE PGH.D_E_L_E_T_=' '"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->PGH_IDPROC,TRB->PGH_DESC,TRB->PGH_FUNLOG,TRB->PGH_STEXEC})
    Dbskip()
ENDDO

RestArea(aArea)

Return(aRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} From2Inc()
Funções extras do Incorporador

@author
@since 05/10/2021
@version 1.0
/*/
//-------------------------------------------------------------------

User Function From2Inc(cPrefixo,cFilOrig)
Local aArea     := GetArea()
Local aPrefixo  := {}
Local nPos      := 0

aPrefixo := U_INCFUN1(cFilOrig)
cPrefixo := Alltrim(cPrefixo)

nPos := aScan(aPrefixo, {|x| Alltrim(x[1]) == cPrefixo})

If nPos > 0
    cPrefixo := Alltrim(aPrefixo[nPos,2])
Endif

RestArea(aArea)
Return PADR(cPrefixo,TAMSX3("PJ9_PREFIX")[1])

/*/{Protheus.doc} User Function _XTINGRP
description)
Local aGrupos := FWLoadSM0()
    @type  Function
    @author user
    @since 13/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function _XTINGRP()
    
Local aGrupos :=    FWLoadSM0()
Local oDlg1,oGrp1,oBtn1
Local aList1 := {}
Local oList1 := {}
Local nCont 
Local nOpc   := 0
Private cCodigo   := ''

For nCont := 1 to len(aGrupos)
    If Ascan(aList1,{|x| x[1] == aGrupos[nCont,01]}) == 0
        Aadd(aList1,{aGrupos[nCont,01],;
                    Alltrim(aGrupos[nCont,06])})
    EndIf
Next nCont 

oDlg1      := MSDialog():New( 104,223,350,611,"Grupos de Empresa",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 008,008,092,180,"Grupos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{016,012,084,172},,, oGrp1 ) 
    oList1 := TCBrowse():New(008,008,175,080,, {'Grupo','Nome' },{50,80},;
                                oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*EDITCOL*/ },, ,,,  ,,.F.,,.T.,,.F.,,,)                          
        oList1:SetArray(aList1)
        oList1:bLine := {||{aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,02]}}
                            
    oBtn1      := TButton():New( 096,072,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=oList1:nAt)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc > 0
    CEMPANT := aList1[nOpc,01]
EndIf 

Return(.t.)
