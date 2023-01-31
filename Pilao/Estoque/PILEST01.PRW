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

Local nOpcx := 0

Private lMsErroAuto := .F.
Private lMsErroHelp := .T.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf


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

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '01' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'I147212101' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,10 , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '02' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'I154180001' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,20 , Nil } )

/*
//---------- nOpcx = 4 Alteração de Solicitação de Armazém -------------

//-----------------------------------------------------------------------------//
// AUTDELETA - Opcional
// Atributo para Definir se o Item que pertence a Solicitação de Armazém deve
// ser Excluído ou Não no processo de Alteração.

// - N = Não Deve Ser Excluído
// - S = Sim Deve Ser Excluído
//-----------------------------------------------------------------------------//
nOpcx := 4
Aadd( aCab, { "CP_NUM" ,cNumero , Nil })
Aadd( aCab, { "CP_EMISSAO" ,dDataBase , Nil })

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '01' , Nil } )

Aadd( aItens[ Len( aItens ) ],{"CP_NUM" , 'cNumero' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_001' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,10 , Nil } )
Aadd( aItens[ Len( aItens ) ],{"AUTDELETA" ,'N' , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '02' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_002' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,120 , Nil } )
Aadd( aItens[ Len( aItens ) ],{"AUTDELETA" ,'N' , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '03' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_003' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,30 , Nil } )

Aadd( aItens[ Len( aItens ) ],{"AUTDELETA" ,'S' , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '04' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_004' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,40 , Nil } )

Aadd( aItens[ Len( aItens ) ],{"AUTDELETA" ,'N' , Nil } )


//---------- nOpcx = 5 Exclusão de Solicitação de Armazém --------------
nOpcx := 5
Aadd( aCab, { "CP_NUM" ,cNumero , Nil })
Aadd( aCab, { "CP_EMISSAO" ,dDataBase , Nil })

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '01' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_001' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,10 , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '02' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_002' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,20 , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '03' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_003' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,30 , Nil } )

Aadd( aItens, {} )
Aadd( aItens[ Len( aItens ) ],{"CP_ITEM" , '04' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,'PRD_004' , Nil } )
Aadd( aItens[ Len( aItens ) ],{"CP_QUANT" ,40 , Nil } )

//----------------------------------------------------------------------
*/

SB1->( dbSetOrder( 1 ) )
SCP->( dbSetOrder( 1 ) )
MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , nOpcx )

If lMsErroAuto
    If !__lSX8
        RollBackSx8()
    EndIf

   MsgStop( 'Erro ao Executar o Processo' )
   MostraErro()
   lRet := .F.

Else
   While ( GetSx8Len() > nSaveSx8 )
       ConfirmSx8()
   End

   MsgInfo( 'Processo Executado' )
EndIf

Return lRet
