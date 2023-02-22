#INCLUDE 'PROTHEUS.CH'

 /*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBFAT12

Local aArea  := GetArea()
Local aItens := {}
Local nCont  := 0
Local aPergs := {}
Local aRet   := {}
Local cVend  := space(6)

aAdd(aPergs ,{1,"Vendedor?	"			,cVend	  ,'@!',"","SA3","",70,.F.})

If ParamBox(aPergs ,"Novo Vendedor",aRet)
    cVend := aRet[1]
    DbSelectArea("SA3")
    DbSetOrder(1)
    If !Dbseek(xFilial("SA3")+cVend)
        MsgAlert("Vendedor não encontrado")
        Return
    EndIf 
else
    Return
EndIf 

If !Empty(cVend)
    DbSelectArea("SC6")
    DbSetOrder(1)
    DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)

    WHILE !EOF() .AND. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM 
        If !Empty(SC6->C6_NOTA) .And. Ascan(aItens,{|x| x[1] == SC6->C6_NOTA}) == 0
            Aadd(aItens,{SC6->C6_NOTA,SC6->C6_SERIE})
        EndIF 
        Dbskip()
    EndDo 

    For nCont := 1 to len(aItens)
        DbSelectArea("SF2")
        DbSetOrder(1)
        If Dbseek(SC5->C5_FILIAL+aItens[nCont,01]+aItens[nCont,02]+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
            Reclock("SF2",.F.)
            SF2->F2_VEND1 := cVend 
            SF2->(Msunlock())
        EndIf 
    Next nCont

    DbSelectArea("SC5")
    Reclock("SC5",.F.)
    SC5->C5_VEND1 := cVend 
    SC5->(Msunlock())

    MsgAlert("Vendedor atualizado")
EndIf 

RestArea(aArea)

Return
