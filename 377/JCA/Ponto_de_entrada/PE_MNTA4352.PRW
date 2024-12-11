#Include 'Totvs.ch'
/*/{Protheus.doc} MNTA4352
   Atualiza SCP status = E par avendas perdidas
   @type: User Function
   @author: RODRGO BARRETO
   @since: 02/10/2024
/*/

User Function MNTA4352()

	Local cQuery
	Local nRetorno  := ParamIXB[1]
	Local aBaixSCP	:= {}

	cQuery := "SELECT TL_CODIGO,TL_NUMSA,TL_ITEMSA,* FROM " + RetSqlName( "STJ" )+" TJ"
	cQuery += " INNER JOIN "+RetSQLName('STL')+" TL ON TL_FILIAL = TJ_FILIAL AND TL_ORDEM = TJ_ORDEM  AND TL_SEQRELA = '0' AND TL_TIPOREG = 'P' AND TL.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName('ZPC')+" ZPC ON ZPC_FILIAL = TL_FILIAL AND  ZPC_CODIGO = TL_CODIGO AND TL_NUMSA = ZPC_REQUIS AND TL_ITEMSA = ZPC_ITEM AND ZPC.D_E_L_E_T_=''"
	cQuery += " WHERE TJ.D_E_L_E_T_='' AND TJ_ORDEM = '" + STJ->TJ_ORDEM + "'"

	cQuery := ChangeQuery(cQuery)

	If Select("TMPZPC") > 0
		TMPZPC->( dbclosearea() )
	Endif

	DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),'TMPZPC', .T., .T.)

	TMPZPC->( dbgotop() )

	While TMPZPC->(!eof())
		dbSelectArea("SCP")
		dbSetOrder(2)	
		If DbSeek(xFilial("SCP")+TMPZPC->TL_CODIGO+TMPZPC->TL_NUMSA+TMPZPC->TL_ITEMSA)
			Aadd(aBaixSCP,{TMPZPC->TL_NUMSA,TMPZPC->TL_ITEMSA})
			Reclock("SCP",.F.)
			SCP->CP_QUJE := 0
			SCP->CP_STATUS := "E"
			SCP->CP_XTIPO := ''
			SCP->(Msunlock())
		ENDIF
		DbSelectArea("ZPC")
		DbSetOrder(1)
		If DbSeek(xFilial("ZPC")+TMPZPC->TL_NUMSA+TMPZPC->TL_ITEMSA+TMPZPC->TL_CODIGO)
			Reclock("ZPC",.F.)
			ZPC->ZPC_CPBAIX := "2"
			ZPC->ZPC_TIPO   := '98'
			ZPC->(Msunlock())
		ENDIF

		DbSelectArea("TMPZPC")
		TMPZPC->(dbSkip())
	EndDo

	TMPZPC->( dbCloseArea() )

	DbSelectArea("SCP")
	DbSetOrder(5)
	If Dbseek(xFilial("SCP")+STJ->TJ_ORDEM)
		While !EOF() .AND. SCP->CP_FILIAL == xFilial("SCP") .AND. ALLTRIM(SCP->CP_NUMOS) == STJ->TJ_ORDEM 
			If SCP->CP_STATUS <> 'E' .And. Ascan(aBaixSCP,{|x| x[1]+x[2] <> SCP->CP_NUM+SCP->CP_ITEM}) == 0
				Reclock("SCP",.F.)
				SCP->CP_QUJE := 0
				SCP->CP_STATUS := "E"
				SCP->CP_XTIPO := ''
				SCP->(Msunlock())
			EndIf 

			DbSelectArea("ZPC")
			DbSetOrder(1)
			If DbSeek(xFilial("ZPC")+SCP->CP_NUM+SCP->CP_ITEM+SCP->CP_PRODUTO)
				Reclock("ZPC",.F.)
				ZPC->ZPC_CPBAIX := "2"
				ZPC->ZPC_TIPO   := "98"
				ZPC->(Msunlock())
			ENDIF

			DbSelectArea("SCP")
			Dbskip()
		EndDo 
	EndIf 

Return nRetorno
