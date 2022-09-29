/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fQRY2TRBº Autor ³ Douglas V. Franca  º Data ³  03/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Joga os dados da Query em um arquivo de Trabalho.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ c_AliasQRY ==> Alias da query.                             º±±
±±º          ³ c_AliasTRB ==> Alias do arquivo de Trabalho.               º±±
±±º          ³ a_IndTRB   ==> Array com os indices do arquivo de Trabalho.º±±
±±º          ³ c_Campos   ==> Campos a considerar da Query, caso seja nuloº±±
±±º          ³                ou vazio serao considerados todos os campos.º±±
±±º          ³ c_NCampos  ==> Campos a desconsiderar da Query.            º±±
±±º          ³ a_Campos   ==> Para exibicao no MBrowse.                   º±±
±±º          ³ c_NBrowse  ==> Para nao exibicao no MBrowse.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorna   ³ .T. / .F. ==> Deu certo ou Nao.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


User Function fQRY2TRB(c_AliasQRY, c_AliasTRB, a_IndTRB, c_Campos, c_NCampos, a_Campos, c_NBrowse)

	Local c_Campos	:= IIF(c_Campos==Nil,"",c_Campos)
	Local c_NCampos := IIF(c_NCampos==Nil,"",c_NCampos)
	Local c_NBrowse := IIF(c_NBrowse==Nil,"",c_NBrowse)
	Local a_CpoTRB	:= {}
	local c_Arq		:= ""
	Local a_AreaSX3	:= SX3->(GetArea())
	Local l_Ret		:= .T.
	Local n_Pos		:= 0
	Local n_OrdCpos	:= 1
	
	If c_AliasQRY==Nil .or. c_AliasTRB==Nil
		Alert("O Alias da Query e/ou TRB deve ser informado.") //Colocar HELP
		Return .F.
	Endif
	
	If ValType(a_IndTRB) <> "A"
		a_IndTRB := {}
	Endif
	
	If ValType(a_Campos) <> "A"
		a_Campos := {}
	Endif

	DbSelectArea("SX3")
	DbSetOrder(2)
	For i := 1 To (c_AliasQRY)->(FCount())
		If DbSeek((c_AliasQRY)->(FieldName(i)), .F.)
			If !(AllTrim(SX3->X3_CAMPO) $ c_NCampos) .and.; 
				(AllTrim(c_Campos)=="" .or. SX3->X3_CAMPO $ c_Campos)
				aAdd(a_CpoTRB, {SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
				
				n_Pos := aScan(a_Campos, {|x| Upper(AllTrim(x[2]))==Upper(AllTrim((c_AliasQRY)->(FieldName(i))))})
				If n_Pos == 0 
					
					If !((c_AliasQRY)->(FieldName(i)) $ c_NBrowse)

						aAdd(a_Campos, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_PICTURE, n_OrdCpos})
						n_OrdCpos++
					
					Endif
					
				Else
					
					If (c_AliasQRY)->(FieldName(i)) $ c_NBrowse
					
						a_Campos[n_Pos, 7] := 0
					
					Else

						a_Campos[n_Pos, 7] := n_OrdCpos
						n_OrdCpos++
					
					Endif
	
				Endif
				
			Endif
		Else
			n_Pos := aScan(a_Campos, {|x| Upper(AllTrim(x[2]))==Upper(AllTrim((c_AliasQRY)->(FieldName(i))))})
			If n_Pos > 0
				If !((c_AliasQRY)->(FieldName(i)) $ c_NCampos) .and.; 
					(AllTrim(c_Campos)=="" .or. (c_AliasQRY)->(FieldName(i)) $ c_Campos)

					aAdd(a_CpoTRB, {a_Campos[n_Pos, 2], a_Campos[n_Pos, 3], a_Campos[n_Pos, 4], a_Campos[n_Pos, 5]})

					If (c_AliasQRY)->(FieldName(i)) $ c_NBrowse

						a_Campos[n_Pos, 7] := 0
					
					Else

						a_Campos[n_Pos, 7] := n_OrdCpos
						n_OrdCpos++
					
					Endif
				Endif
			Endif

		Endif
	Next i
	
	If Len(a_CpoTRB) == 0
		l_Ret := .F.
	Else
		
		aSort(a_Campos,,,{|x,y| x[7] < y[7]})
		
		//Remove os itens que não devem aparecer no Grid
		a_AuxCampos := a_Campos
		a_Campos := {}
		For i := 1 To Len(a_AuxCampos)
			If a_AuxCampos[i, 7] <> 0
				aAdd(a_Campos, a_AuxCampos[i])
			Endif
		Next i
		
		If Select(c_AliasTRB) <> 0
			dbSelectArea(c_AliasTRB)
			DbCloseArea()
		EndIf
		
		c_Arq 	:= CriaTrab(a_CpoTRB, .T.)
		DbUseArea(.T.,, c_Arq, c_AliasTRB, .T.)
		
		//Criacao dos Indices
		If Len(a_IndTRB) > 0
			For j := 1 To Len(a_IndTRB)
				&("c_Ind"+AllTrim(Str(j))+" := CriaTrab(Nil, .F.)")
				IndRegua(c_AliasTRB, &("c_Ind"+AllTrim(Str(j))), a_IndTRB[j],,,'Selecionando Registros...')
			Next j
			DbClearIndex()
			For j := 1 To Len(a_IndTRB)
				dbSetIndex(&("c_Ind"+AllTrim(Str(j)))+OrdBagExt())
			Next j
			DbSetOrder(1)
		Endif
		
		DbSelectArea(c_AliasQRY)
		DbGoTop()
		While (c_AliasQRY)->(!EOF())
		
			RecLock(c_AliasTRB, .T.)
			
			For n_Col := 1 To Len(a_CpoTRB)
				If a_CpoTRB[n_Col, 2] == "D"
					(c_AliasTRB)->(FieldPut(n_Col,STOD((c_AliasQRY)->(FieldGet(FieldPos(a_CpoTRB[n_Col, 1]))))))
				Else
					(c_AliasTRB)->(FieldPut(n_Col,(c_AliasQRY)->(FieldGet(FieldPos(a_CpoTRB[n_Col, 1])))))
				Endif
			Next n_Col
			
			MsUnLock()
			
			(c_AliasQRY)->(DbSkip())
		Enddo

	Endif
	
	RestArea(a_AreaSX3)
	
Return l_Ret