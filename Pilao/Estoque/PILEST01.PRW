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
    
Local lRet := .T.
Local aCab := {}
Local aItens := {}
Local nSaveSx8 := 0
Local cNumero := ''
Local aOSSLAP   :=  {}
Local nOpcx := 0
Local nCont :=  0

Private lMsErroAuto := .F.
Private lMsErroHelp := .T.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery :=	" select * from SLAPLIC.dbo.RequisicaoPeca"  

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
                    TRB->OSApObs})      //obs do aprovador
    DBSKIP()
ENDDO

//---------- nOpcx = 3 Inclusão de Solicitação de Armazém --------------
nOpcx := 3
nSaveSx8:= GetSx8Len()
cNumero := GetSx8Num( 'SCP', 'CP_NUM' )

dbSelectArea( 'SB1' )
SB1->( dbSetOrder( 1 ) )

dbSelectArea( 'SCP' )
SCP->( dbSetOrder( 1 ) )

If nOpcx == 3
    While SCP->( dbSeek( xFilial( 'SCP' ) + cNumero ) )
           ConfirmSx8()
           cNumero := GetSx8Num('SCP', 'CP_NUM')
    EndDo
EndIf

Aadd( aCab, { "CP_NUM" ,cNumero , Nil })
Aadd( aCab, { "CP_EMISSAO" ,dDataBase , Nil })

For nCont := 1 to len(aOSSLAP)
    Aadd( aItens, {} )
    Aadd( aItens[ Len( aItens ) ],{"CP_ITEM"    ,Strzero(aOSSLAP[nCont,02]) , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,aOSSLAP[nCont,03] , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_QUANT"   ,aOSSLAP[nCont,05] , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_NUMOS"   ,aOSSLAP[nCont,01] , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_XAPROV"  ,aOSSLAP[nCont,08] , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_OBS"     ,aOSSLAP[nCont,10] , Nil } )
Next nCont

SB1->( dbSetOrder( 1 ) )
SCP->( dbSetOrder( 1 ) )
MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )

If lMsErroAuto
    If !__lSX8
        RollBackSx8()
    EndIf

   //MsgStop( 'Erro ao Executar o Processo' )
   MostraErro()
   lRet := .F.

Else
   While ( GetSx8Len() > nSaveSx8 )
       ConfirmSx8()
   End
    //CP_NUM 
    //e flag = OsItemAut  = 1 significa que pode ser baixado
    U_PILEST02()
    U_PILEST03(SCP->CP_NUM)

   //MsgInfo( 'Processo Executado' )
EndIf

Return lRet
