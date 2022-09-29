/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT100TOK � Autor �  Artur Nucci Ferrari  � Data � 21/06/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � P.E. p/ consistir a Inclusao / Classificacao da NFE.       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil => Nenhum                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil => Nenhum                                              ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���Douglas Franca�02/02/07� - Validar o Centro de Custo para os grupos do ���
���              �        � TES informados no parametro MV_XLCCPV.        ���
���Douglas Franca�02/04/07� - Validar o valor do desconto x valor total do���
���              �        � item.                                         ���
���Douglas Franca�11/04/07� - Consistir tabela P3 x Almox quando forem ope���
���              �        � racoes com Terceiros (retornos).              ���
���              �        � - Nao permitir que os itens genericos sejam   ���
���              �        � lancados com TES que movimente estoque.       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

#include "rwmake.ch"

User Function MT100TOK()

Local a_AreaATU	:= GetArea()
Local a_AreaSF1	:= SF1->(GetArea()) 

Local l_Ret 	:= ParamixB[1]
Local c_Ret 	:= ""
Local c_FilOri 	:= Space(02)
Local _cNaturez := MaFisRet(,"NF_NATUREZA")
Local _cRecISS  := MaFisRet(,"NF_RECISS")  //=="2"
Local _nValISS  := MaFisRet(,"NF_VALISS")
Local _cCalcISS := ""

Local n_D1_NFORI	:= Ascan( aHeader, {|x| AllTrim(x[2]) == "D1_NFORI"     } )
Local n_D1_SERORI	:= Ascan( aHeader, {|x| AllTrim(x[2]) == "D1_SERIORI"   } )
Local n_D1_TES		:= Ascan( aHeader, {|x| AllTrim(x[2]) == "D1_TES"       } )
Local n_D1_QUANT	:= Ascan( aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"     } )
Local n_D1_COD		:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_COD"	    } )
Local n_D1_CF 		:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_CF"	    } )
Local n_D1_CC 		:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_CC"	    } )
Local n_D1_ITEM		:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_ITEM"	    } )
Local n_D1_VALDESC	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_VALDESC"	} )
Local n_D1_TOTAL	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"     } )
Local n_D1_LOCAL	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_LOCAL"     } )

Local nValBrut      := IIF(MaFisFound(),MaFisRet(,"NF_TOTAL"),aGets[TOTPED ])
Local nValDig       := 0
Local nX       		:= 0 && declarada por F�bio Sales em 20/03/2012
                   
Local lEdi1	 := .F.
Local nCont	 := 0

//������������������������������������������Incluido por Ronaldo Gomes - 28/09/2015�������������������������������������������������\\
	Local cMsg		:= ""
	Local cTxt		:= ""
	//Local cCNPJ		:= iif( cTipo $ "BD", SA1->A1_CGC, SA2->A2_CGC )
	Local cCNPJ		:= iif( cTipo $ "BD", POSICIONE("SA1",1,XFILIAL("SA1")+cA100For+cLoja,"A1_CGC"), POSICIONE("SA2",1,XFILIAL("SA2")+cA100For+cLoja,"A2_CGC"))

	Local aCodEst	:= {	{'AC','12'}, {'AL','27'}, {'AM','13'}, {'AP','16'}, {'BA','29'}, {'CE','23'}, {'DF','53'},;
							{'ES','32'}, {'GO','52'}, {'MA','21'}, {'MG','31'}, {'MS','50'}, {'MT','51'}, {'PA','15'},;
							{'PB','25'}, {'PE','26'}, {'PI','22'}, {'PR','41'}, {'RJ','33'}, {'RN','24'}, {'RO','11'},;
							{'RR','14'}, {'RS','43'}, {'SC','42'}, {'SE','28'}, {'SP','35'}, {'TO','17'} }

	Local nPos		:= aScan( aCodEst, { |x|, x[1] = cUFOrig } )
	Local nK                                                                                                                       
//�����������������������������������������������������������������������������������������������������������������������������������\\

If cEmpAnt == "01"
	While !empty(procname(nCont))
		If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA50/U_TTMT140/U_TTCOMC16"
			lEdi1 := .T.
			Exit
		EndIf 
		nCont++
	EndDo
	
	If !lEdi1
	
		//����������������������������������������������������������������������������Ŀ
		//� CONFERRENCIA DE DIGITACAO DA NFE                                           *
		//������������������������������������������������������������������������������
	
		If _nValISS > 0
			If _cRecISS == "2"
				_cCalcISS := GETADVFVAL("SED","ED_CALCISS",XFILIAL("SED")+_cNaturez,1)
				If _cCalcISS # "S"
					MsgAlert('Natureza Financeira informada '+alltrim(_cNaturez)+" n�o est� parametrizada para reter ISS e o campo Fornecedor Recolhe ISS (aba Impostos) igual a N�O. Informe uma natureza financeira que calcule ISS ou altere o campo para Fornecedor Recolhe ISS igual a SIM na aba de Impostos para confirmar a entrada da NF. ")
					l_Ret:=.F.
				EndIf
			EndIf
		EndIf
	
		//����������������������������������������������������������������������������Ŀ
		//� CONFERRENCIA DE DIGITACAO DA NFE                                           *
		//������������������������������������������������������������������������������
	
		While .T.
			@ 127,112 To 350,730 DIALOG _oObjeto1 TITLE "Conferencia da NFE Impressa (Doc. F�sico)"
			@ 010,005 Say "Valor Total da NF :"
			@ 010,055 Get nValDig Picture '@E 999,999,999.99'  Valid !Empty(nValDig) Size 50,12
			@ 040,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
			ACTIVATE DIALOG _oObjeto1 CENTERED
			If Empty(nValDig)
				Aviso("Conferencia de Digita��o da NFE","O Valor do Total da NFE deve ser preenchido. Digite o Valor Impresso na NF.",{"Ok"},,"Aten��o:")
				Loop
			End
			If nValDig<>nValBrut
				Aviso("Conferencia de Digita��o da NFE","O Valor do Total da NFE n�o confere. Favor rever o lan�amento da NF.",{"Ok"},,"Aten��o: "+Transform(nValBrut,"@E 999,999,999.99"))
				l_Ret:=.F.
			End
			Exit
		End 
		
		// **************************************************************************** //
		//   Validacao para o Sped Fiscal e Pis/Cofins, a partir do dia 1 de abril se
		//  se tornou obrigatorio preencher o campo com a numeracao da chave da nfe.
		//    Alexandre Venancio 27/05/2012
		// **************************************************************************** //
		             
		if l_Ret
			
			if alltrim(cEspecie) $ "SPED,CTE" .and. cFormul <> "S"
		
			    /*-----------------------------------------------------------------------------------------------------------\
			    | Trexo de c�digo inclu�do Por Fabio Sales em 11/06/2012 para pegar a chave da nota de sa�da que originou a  |
			    | a pre nota. Somente para os casos de transfer�ncias entre as filiais                                       |
			    |------------------------------------------------------------------------------------------------------------*/
			    
				DbSelectArea("SM0")
				clCodLcli:=""
				DbSetOrder(1)
				
				If DbSeek(cEmpAnt + cFilant)
					clCgc:=SM0->M0_CGC
				EndIf
				
				DbSelectArea("SA1")
				DbSetOrder(3)
				
				If DbSeek(xFilial("SA1") + clCgc )
					clCodLcli:=SA1->A1_COD+SA1->A1_LOJA
				EndIf
			    
			    If SF1->F1_XTRANSF<>''
			    	DbSelectArea("SF2")
				    DbSetOrder(2)
				 
				    clChave:=SF1->F1_XTRANSF+clCodLcli+SF1->F1_DOC+SF1->F1_SERIE
				 
				    If DbSeek(clChave)
				    	anfedanfe[13]:=SF2->F2_CHVNFE
				    EndIf
				    
				EndIf
				
				&&---------------------------Termina aqui o trecho de c�digo inclu�do por Fabio Sales-----------------------&& 
				
				/* DESTIVADA em 28/09/2015 por Ronaldo Gomes
				
				if empty(anfedanfe[13])
			        MsgBox("Quando a esp�cie do documento for igual a (SPED ou CTE) � Chave da NFE deve ser informada na aba Informa��es DANFE","MT100TOK","STOP" )
		            l_Ret := .f.
		        else
			        if len(alltrim(anfedanfe[13])) <> 44
			            MsgBox("A chave da NFE ou CTE devem ter 44 caracteres obrigatoriamente. Verifique o n�mero digitado.","MT100TOK","STOP" )
		                l_Ret := .f.
		            endif
		        endif
			    */
	            
	//�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������\\
	
	/*�������������������������������������������������������������������������Ŀ
	//� Verifica se a chave da nota fiscal foi preenchida, quando for nota com  �
	//� especie CTE ou SPED e nota de terceiros, pois a informacao passara a    �
	//� obrigatoabria no SPED Fiscal                                            �
	//� Por: Ronaldo Gomes em 28/09/2015                      �
	/��������������������������������������������������������������������������*/
			    		    
			    if Empty( aNFeDANFE[13] )
	
						//Verifico se a chave foi preenchida
							cMsg	:= "Chave NFe em branco"
							l_Ret	:= .F.
	
				elseif Len( AllTrim( aNFeDANFE[13] ) ) = 44
	
						//Verifico se ha digitos nao numericos
						For nK := 1 to Len( AllTrim( aNFeDANFE[13] ) )
							if !IsDigit( Substr( aNFeDANFE[13], nK, 1 ) )
							cMsg	:= "Chave NFe deve conter somente n�meros"
							l_Ret	:= .F.
						exit
							endif
		
						next
	
							if l_Ret
	
							//Verifico a composicao da chave
								if Substr( aNFeDANFE[13], 3, 4 ) != Substr( dTOs( ddEmissao ), 3, 4 )
										cTxt	:= "Foi encontrada diverg�ncia entre o m�s e ano de emiss�o da nota fiscal informada e o encontrada na Chave NFe. "
										l_Ret	:= .F.
				
								elseif Substr( aNFeDANFE[13], 7, 14 ) != cCNPJ
										cTxt	:= "Foi encontrada diverg�ncia entre o CNPJ do " + iif( cTipo $ "BD", "cliente", "fornecedor" ) + " utilizado e o encontrado na Chave NFe. "
										l_Ret	:= .F.
	
								elseif Substr( aNFeDANFE[13], 21, 2 ) != AModNot(cEspecie)
										cTxt	:= "Foi encontrada diverg�ncia entre a esp�cie/modelo da nota fiscal informada e a encontrada na Chave NFe. "
										l_Ret	:= .F.
		
								elseif Substr( aNFeDANFE[13], 23, 3 ) != StrZero( Val( cSerie ), 3 )
										cTxt	:= "Foi encontrada diverg�ncia entre a s�rie da nota fiscal informada e a encontrada na Chave NFe. "
								   		l_Ret	:= .F.
			
								elseif Substr( aNFeDANFE[13], 26, 9 ) != StrZero( Val( cNFiscal ), 9 )
										cTxt	:= "Foi encontrada diverg�ncia entre o n�mero da nota fiscal informada e a encontrada na Chave NFe. "
										l_Ret	:= .F.
	
								elseif nPos > 0
									if Substr( aNFeDANFE[13], 1, 2 ) != aCodEst[nPos,2]
										cTxt	:= "Foi encontrada diverg�ncia entre o estado da nota fiscal informada e o encontrada na Chave NFe. "
										l_Ret	:= .F.
									endif
								endif
			
			
		   						if !l_Ret
									cMsg	:= "Diverg�ncia nas informa��es da Chave NFe com o informado na nota fiscal."
								endif
		
							endif
	
				else
				//Verifico se a chave 44 posicoes
					cMsg	:= "Chave NFe menor do que 44 posi��es"
					l_Ret	:= .F.
				endif
	
					if !l_Ret
						if !l103Auto
							MsgBox(cTxt + "Esta � uma nota fiscal de terceiros com esp�cie '" + AllTrim(cEspecie) + "' e portanto � obrigat�rio o preenchimento da chave da nota fiscal, com 44 d�gitos num�ricos, na pasta 'DANFE'. Preencha esta informa��o para poder gravar a nota fiscal", "Aten��o, " + cMsg, "ERRO")
					else
							Conout("Aten��o, " + cMsg + "-> " + cTxt + "Esta � uma nota fiscal de terceiros com esp�cie '" + AllTrim(cEspecie) + "' e portanto � obrigat�rio o preenchimento da chave da nota fiscal, com 44 d�gitos num�ricos, na pasta 'DANFE'. Preencha esta informa��o para poder gravar a nota fiscal")
						endif
					endif	    
			    
			endif
		endif
		
	//�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������\\	
		
		/*-----------------------------------------------------------------\
		| Adcionado por Fabio Sales em 20/03/2012 para alimentar os campos |
		| de peso Liquido,peso bruto e volume nas notas de entrada.        |	
		\-----------------------------------------------------------------*/
		
		nlPesBr   := 0
		nlPesLi   := 0
		nlVol	  := 0
		If ctipo=="D" // Condi��o inclu�da em 05/06/2012 Por F�bio Sales para calcular o volume, pesos(l�quido/Bruto) somente nos casos de retornos e devolu��es.
			For nX:=1 to len(aCols)
				cProd	:= acols[nX,n_D1_COD]
				nlQtde 	:= aCols[nX,n_D1_QUANT]
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xfilial("SB1")+cProd)
				If aCols[nX,Len(aHeader)+1] == .F.
					nlPesBr   += (nlQtde * SB1->B1_PESBRU)
					nlPesLi   += (nlQtde * SB1->B1_PESO)
					nlVol	  += nlQtde	
				EndIf
			Next
		
			anfedanfe[2] := nlPesLi  && peso liquido
			anfedanfe[3] := nlPesBr  && peso bruto
			anfedanfe[4] := "UN" 	 && especie do volume
			anfedanfe[5] := nlVol 	 && volume
		EndIf
	EndIf
EndIF
	    
RestArea(a_AreaSF1)
RestArea(a_AreaATU)

Return l_Ret