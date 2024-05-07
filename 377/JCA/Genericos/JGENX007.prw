#include 'PROTHEUS.CH'

/*
    Rotina criada para alterar o codigo do fabricante no cadastro de produto
    filho.

    produtos filhos não podem ser alterados mais

*/

User Function JGENX007 

Local aArea := GetArea()

If Empty(SB1->B1_XCODPAI)
    MsgAlert("Somente produtos filhos podem ser utilizados nesta rotina!!!")
Else 
    trocarCod(SB1->B1_COD+" / "+SB1->B1_DESC,SB1->B1_FABRIC)
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} trocarCod
    Alterar o codigo do fabricante
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
Static Function trocarCod(cCodDesc,cCodAtu)

Local nOpcao := 0
Local cNewCd := space(TamSX3("B1_FABRIC")[1])

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGet1","oBtn1","oBtn2")

oDlg1      := MSDialog():New( 092,232,362,890,"Atualizar Codigo Fabricante",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 004,008,108,316,"Produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 020,016,{||cCodDesc},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,292,008)
    
        oSay2      := TSay():New( 040,032,{||"Código Atual"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
        oSay3      := TSay():New( 040,140,{||cCodAtu},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
    
        oSay4      := TSay():New( 072,032,{||"Novo Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 072,140,{|u| If(Pcount()>0,cNewCd:=u,cNewCd)},oGrp1,124,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oBtn1      := TButton():New( 112,080,"Confirmar",oDlg1,{||oDlg1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 112,180,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao > 0 .And. !Empty(cNewCd)
    If MsgYesNo("Confirma a alteração?") 
        Reclock("SB1",.F.)
        SB1->B1_FABRIC := cNewCd
        SB1->(Msunlock())
    EndIF 
EndIf 

Return
