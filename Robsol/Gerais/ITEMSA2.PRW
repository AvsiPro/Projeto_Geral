//****************************************************************************
// ROTINA PARA INCLUSÃO DO ITEM CONTABIL NO CADASTRO DE UM FORNECEDOR
//****************************************************************************
User Function M020INC
Local aArea  := GetArea()
  dbSelectarea("CTD")
  dbSetOrder(1)
  If !dbSeek(xFilial("CTD")+'F'+SA2->A2_COD)
    RecLock("CTD",.T.)
    CTD->CTD_FILIAL := XFILIAL("CTD")
    CTD->CTD_ITEM   := 'F'+SA2->A2_COD
    CTD->CTD_DESC01 := SA2->A2_NOME
    CTD->CTD_CLASSE := "2"
    CTD->CTD_NORMAL := "0"
    CTD->CTD_BLOQ   := "2"
    CTD->CTD_DTEXIS := CTOD("01/01/2000")
    CTD->CTD_ITLP   := 'F'+SA2->A2_COD
    CTD->CTD_CLOBRG := "2"
    CTD->CTD_ACCLVL := "1"
    MsUnLock()
  End if
RestArea(aArea)
Return .T.
