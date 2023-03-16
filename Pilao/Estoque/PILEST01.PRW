#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 30/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function PILEST01()
    
Local lRet      :=  .T.
Local aCab      :=  {}
Local aItens    :=  {}
Local nSaveSx8  :=  0
Local cNumero   :=  ''
Local aOSSLAP   :=  {}
Local nOpcx     :=  0
Local nCont     :=  0
Local cOSAt     :=  ''
Local aLsSCP    :=  {}

Private lMsErroAuto := .F.
Private lMsErroHelp := .T.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0201")
EndIf

cQuery := " select * from SLAPLIC.dbo.RequisicaoPeca "
cQuery += " where CP_NUM IS NULL AND CP_ITEM IS NULL" 
cQuery += " order by OS"

If Select("TRB") > 0
    TRB->( dbclosearea() )
Endif
    
DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),"TRB", .T., .T.)
    
While !EOF()
    Aadd(aOSSLAP,{  TRB->OS,;
                    TRB->OSItem,;
                    TRB->SB1_COD,;
                    TRB->IOSQtd,;   //esse foi o que o cara pediu
                    TRB->IOSQAp,;  // esse cara que vai para a solicitacao
                    TRB->IOSQAt,;   // esse cara é o que o estoque atendeu
                    TRB->OSItemProc,;   //Sucesso ou falha
                    TRB->OSAprovador,;  //aprovador mesmo
                    TRB->OSArmazem,;   //armazem do produto
                    TRB->OSApObs,;      //obs do aprovador
                    .F.})               //Com saldo
    DBSKIP()
ENDDO

//---------- nOpcx = 3 Inclusão de Solicitação de Armazém --------------
nOpcx := 3

If len(aOSSLAP) > 0
    cOSAt := aOSSLAP[1,1]
EndIf 

dbSelectArea( 'SB1' )
SB1->( dbSetOrder( 1 ) )

dbSelectArea( 'SCP' )
SCP->( dbSetOrder( 1 ) )

For nCont := 1 to len(aOSSLAP)
    dbSelectArea("SB2")
    dbSetOrder(1) // Filial + Produto + Local

    _nSaldoB2 := 0

    If SB2->(dbSeek( xFilial("SB2") + aOSSLAP[nCont,03] + aOSSLAP[nCont,09]) )
        _nSaldoB2 := SaldoSb2()
        If _nSaldoB2 >= aOSSLAP[nCont,05]
            aOSSLAP[nCont,11] := .T.
        endIf 
    EndIf
Next nCont

For nCont := 1 to len(aOSSLAP)
    If aOSSLAP[nCont,11]
        If cOSAt <> aOSSLAP[nCont,01]
            If len(aItens) > 0
                
                lMsErroAuto := .F.
                MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )

                If lMsErroAuto
                    If !__lSX8
                        RollBackSx8()
                    EndIf

                    _cNome := "TINTA010.txt"
                    ctxtErro := MostraErro(,_cNome)
                    cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
                    cUpdQry += " SET OSItemErr='"+ctxtErro+"'"
                    cUpdQry += " where OS='"+cOSAt+"'"
                    TcSqlExec(cUpdQry)

                    lRet := .F.

                Else
                    While ( GetSx8Len() > nSaveSx8 )
                        ConfirmSx8()
                    End

                    cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
                    cUpdQry += " SET CP_NUM='"+SCP->CP_NUM+"',CP_ITEM=OSItem"
                    cUpdQry += " where OS='"+cvaltochar(cOSAt)+"'"
                    TcSqlExec(cUpdQry)
                    Aadd(aLsSCP,SCP->CP_NUM)
                    //CP_NUM 
                    //e flag = OsItemAut  = 1 significa que pode ser baixado
                    
                EndIf

                aCab := {}
                aItens:= {}
                cOSAt := aOSSLAP[nCont,01]
            EndIf

            nSaveSx8:= GetSx8Len()
            cNumero := GetSx8Num( 'SCP', 'CP_NUM' )

            If nOpcx == 3
                While SCP->( dbSeek( xFilial( 'SCP' ) + cNumero ) )
                    ConfirmSx8()
                    cNumero := GetSx8Num('SCP', 'CP_NUM')
                EndDo
            EndIf

            Aadd( aCab, { "CP_NUM" ,cNumero , Nil })
            Aadd( aCab, { "CP_EMISSAO" ,dDataBase , Nil })

            SB1->( dbSetOrder( 1 ) )
            SCP->( dbSetOrder( 1 ) )
            
            
        EndIF 

        DbselectArea("SB1")
        DbSetOrder(1)
        If DbSeek(xFilial("SB1")+aOSSLAP[nCont,03])
            If SB1->B1_MSBLQL == "1"
                Reclock("SB1",.F.)
                SB1->B1_MSBLQL := '2'
                SB1->(Msunlock())
            EndIf 
        EndIf 

        Aadd( aItens, {} )
        Aadd( aItens[ Len( aItens ) ],{"CP_ITEM"    ,Strzero(aOSSLAP[nCont,02],2) , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,aOSSLAP[nCont,03] , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_QUANT"   ,aOSSLAP[nCont,05] , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_NUMOS"   ,aOSSLAP[nCont,01] , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_LOCAL"   ,aOSSLAP[nCont,09] , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_XAPROV"  ,aOSSLAP[nCont,08] , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_OBS"     ,aOSSLAP[nCont,10] , Nil } )
    Else 
        If cOSAt <> aOSSLAP[nCont,01]
            If len(aItens) > 0
                
                lMsErroAuto := .F.
                MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )

                If lMsErroAuto
                    If !__lSX8
                        RollBackSx8()
                    EndIf

                    _cNome := "TINTA010.txt"
                    ctxtErro := MostraErro(,_cNome)
                    cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
                    cUpdQry += " SET OSItemErr='"+ctxtErro+"'"
                    cUpdQry += " where OS='"+cOSAt+"'"
                    TcSqlExec(cUpdQry)

                    lRet := .F.

                Else
                    While ( GetSx8Len() > nSaveSx8 )
                        ConfirmSx8()
                    End

                    cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
                    cUpdQry += " SET CP_NUM='"+SCP->CP_NUM+"',CP_ITEM=OSItem"
                    cUpdQry += " where OS='"+cvaltochar(cOSAt)+"'"
                    TcSqlExec(cUpdQry)
                    Aadd(aLsSCP,SCP->CP_NUM)
                    //CP_NUM 
                    //e flag = OsItemAut  = 1 significa que pode ser baixado
                    
                EndIf

                aCab := {}
                aItens:= {}
                cOSAt := aOSSLAP[nCont,01]
            EndIf
        EndIf 

        cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
        cUpdQry += " SET OSItemErr='Erro - Item sem saldo'"
        cUpdQry += " where OS='"+cvaltochar(aOSSLAP[nCont,01])+"' and OSItem='"+cvaltochar(aOSSLAP[nCont,02])+"'"
        TcSqlExec(cUpdQry)
    EndIf
    
Next nCont

If len(aItens) > 0
    cNumero := GetSx8Num( 'SCP', 'CP_NUM' )
    aCab := {}

    If nOpcx == 3
        While SCP->( dbSeek( xFilial( 'SCP' ) + cNumero ) )
            ConfirmSx8()
            cNumero := GetSx8Num('SCP', 'CP_NUM')
        EndDo
    EndIf

    Aadd( aCab, { "CP_NUM" ,cNumero , Nil })
    Aadd( aCab, { "CP_EMISSAO" ,dDataBase , Nil })

    SB1->( dbSetOrder( 1 ) )
    SCP->( dbSetOrder( 1 ) )
    
    MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )

    If lMsErroAuto
        If !__lSX8
            RollBackSx8()
        EndIf

        _cNome := "TINTA010.txt"
        ctxtErro := MostraErro(,_cNome)
        cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
        cUpdQry += " SET OSItemErr='"+ctxtErro+"'"
        cUpdQry += " where OS='"+cOSAt+"'"
        TcSqlExec(cUpdQry)
        
        lRet := .F.

    Else
        While ( GetSx8Len() > nSaveSx8 )
            ConfirmSx8()
        End

        cUpdQry := "UPDATE SLAPLIC.dbo.RequisicaoPeca "
        cUpdQry += " SET CP_NUM='"+SCP->CP_NUM+"',CP_ITEM=OSItem"
        cUpdQry += " where OS='"+cOSAt+"'"
        TcSqlExec(cUpdQry)

        Aadd(aLsSCP,SCP->CP_NUM)
        
    EndIf

EndIf 


U_PILEST02()

For nCont := 1 to len(aLsSCP)
    U_PILEST03(aLsSCP[nCont])
Next nCont

Return lRet
