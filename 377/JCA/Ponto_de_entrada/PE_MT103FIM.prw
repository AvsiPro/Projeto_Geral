#INCLUDE 'PROTHEUS.CH'

User function MT103FIM

Local nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
Local aAux      := {}
Local cChaveNf  := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(cChaveNf)

While !EOF() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChaveNf
    If Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_LOCALIZ") == "S"
        Aadd(aAux,{ SD1->D1_COD,;
                    SD1->D1_LOCAL,;
                    SD1->D1_QUANT,;
                    Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_ENDENT"),;
                    SD1->D1_NUMSEQ})
    EndIf
    Dbskip()
EndDo 

If len(aAux) > 0
    fMta265I(aAux,nOpcao)
EndIf

RETURN

static Function fMta265I(aAux,nOpcao)

Local aCab := {}
Local aItem:= {}
Local nCont:= 0

If nOpcao == 4 .OR. nOpcao == 5
    For nCont := 1 to len(aAux)
        lMsErroAuto := .F.
        
        aCab := {   {"DA_FILIAL"    ,xFilial("SDA") ,NIL},;
                    {"DA_PRODUTO"   ,aAux[nCont,01] ,NIL},;
                    {"DA_LOCAL"     ,aAux[nCont,02] ,NIL},;
                    {"DA_DOC"       ,SF1->F1_DOC    ,NIL},;
                    {"DA_SERIE"     ,SF1->F1_SERIE  ,NIL},;
                    {"DA_CLIFOR"    ,SF1->F1_FORNECE,NIL},;
                    {"DA_LOJA"      ,SF1->F1_LOJA   ,NIL},;
                    {"DA_NUMSEQ"    ,aAux[nCont,05] ,NIL}}

        aAdd(aItem,{{"DB_ITEM"      ,Strzero(nCont,3)   ,NIL},;
                    {"DB_LOCALIZ"   ,aAux[nCont,04]     ,NIL},;
                    {"DB_DATA"      ,dDataBase          ,NIL},;
                    {"DB_QUANT"     ,aAux[nCont,03]     ,NIL}})

        MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,If(nOpcao==4,3,4)) //Distribui

        If lMsErroAuto
            MostraErro()
        //Else
            //Alert("Ok")
        Endif

    Next nCont
Else 

EndIf 

Return
