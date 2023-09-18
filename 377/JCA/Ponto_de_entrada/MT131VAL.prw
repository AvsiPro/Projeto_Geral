#Include 'Protheus.ch'
User Function MT131VAL()
   Local cMarca := PARAMIXB[1]
   Local cQuerySC1 := PARAMIXB[2]
   Local cQuery := ''
   Local cMy1Alias := GetNextAlias()
   Local lRet := .T.
  dbSelectArea("SC1")
   dbSetOrder(1)
   // Restringe o uso do produto 1163101
   cQuery := "SELECT * "
   cQuery += "FROM " + RetSqlName("SC1") + " SC1 "
   cQuery += "WHERE SC1.D_E_L_E_T_ = ' ' "
   cQuery += "AND " + cQuerySC1

   cQuery := ChangeQuery(cQuery)
   Iif( Select(cMy1Alias) > 0,(cMy1Alias)->(dbCloseArea()),Nil )
   dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), cMy1Alias, .F., .T. )

   While (cMy1Alias)->(!Eof())
      If IsMark("C1_OK",cMarca)
         If Alltrim((cMy1Alias)->C1_PRODUTO) == "1163101"
             Help( , , 'Help', ,"O produto 1376101 não pode ser selecionado!", 1, 0 )
             lRet := .F.
          EndIf
      EndIf
     (cMy1Alias)->(DbSkip())
   EndDo
Return lRet
