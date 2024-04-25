#include "protheus.ch"
#include "parmtype.ch"
 
 /*
    Ponto de entrada MVC cadastro de produtos

    utilizado aqui pois não encontramos um ponto de entrada que faça a validação 
    da exclusão do cadastro de produto e faça o bloqueio antes de confirmar.

    Não permitir excluir produto pai quando já tiver um filho cadastrado

 */
User Function ITEM()
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
 
        If cIdPonto == "MODELPOS"
            iF !INCLUI .AND. !ALTERA 
                aFilhos := Buscafilhos(SB1->B1_COD)
                IF len(aFilhos) > 0
                    MsgAlert("Produto não pode ser excluído, pois já contem filhos atrelados a ele.")
                    xRet := .F.
                EndIF
            EndIF

        ElseIf cIdPonto == "FORMPRE"
            /*iF cIdModel == "SB1MASTER" .AND. !INCLUI .AND. !ALTERA 
                MsgAlert("Produto não pode ser excluído, pois já contem filhos atrelados a ele.")
                xRet := .F.
            endif */
        ElseIf cIdPonto == "FORMPOS"
            
 
        ElseIf cIdPonto == "FORMLINEPRE"
            
        ElseIf cIdPonto == "FORMLINEPOS"
           
        ElseIf cIdPonto == "MODELCOMMITTTS"
           
        ElseIf cIdPonto == "MODELCOMMITNTTS"
           
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
           
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
           
        ElseIf cIdPonto == "MODELCANCEL"
           
        ElseIf cIdPonto == "BUTTONBAR"
           
        EndIf
    EndIf
Return xRet
 
/*/{Protheus.doc} nomeStaticFunction
    Busca os produtos filhos deste cadastro que esta sendo atualizado
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
Static function Buscafilhos(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT B1_COD,B1.R_E_C_N_O_ AS REGB1"
cQuery += " FROM "+RetSQLName("SB1")+" B1"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND B1_XCODPAI='"+cCodigo+"' AND B1_XCODPAI<>' '"
cQuery += " AND D_E_L_E_T_=' '"


If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->B1_COD,TRB->REGB1})

    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
