#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271BOK     ºAutor  ³Jackson E. de Deus Data ³  24/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado ao clicar no botao OK para confirmar.          º±±
±±º          ³Utilizado para preenchimento de detalhes da maquina.	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TK271BOK()

Local aArea		:= GetArea()
Local lVldTela	:= .F.
Local lRet		:= .T.
Local lVldFields := .F.
Local aFields	:= {}
Local aItens	:= {}
Local aRetTudo	:= {}
Local aAux		:= {}
Local cObsMemo	:= ""
Local cParsPag	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK009",.T.,"MV_XTMK010#MV_XTMK011"),"")
Local lAtivaAlt	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK014",.T.,.F.),"")
Local aPars		:= {}
Local cValores	:= ""
Local cOMM		:= SuperGetMV("MV_XTMK002",.T.,"")
Local nPosProd
Local nPosDesc
Local nPosVolt
Local nPosPtHdl
Local nPosMoeda
Local nPosObsPg
Local nPosMin
Local nPosValor
Local nPosSubs
Local nPosObs
Local nPObsExec
Local cProdAnt
Local nPosAlt
Local nPosTpCont
Local nPosPatr
Local cAux	
Local aPtHdl	:= {"Sim","Nao","Nao se aplica"}
Local aVolt		:= {"110v","220v","Nao se aplica"}
Local aFAbast	:= {"Residente","Rota","Itinerante","Nao se aplica"}
Local aPlugNBR	:= {"Sim","Nao"}
Local aSisPag	:= {}
Local aDoses	:= {"Sim","Nao"}
Local aMin		:= {"Sim","Nao"}
Local aContr	:= {} 
Local cContr	:= ""
Local cDescContr:= ""
Local cMoeda	:= ""
Local cDescPag	:= ""
Local aPergs	:= {}
Local aRet		:= {}
Local cStatN1	:= ""	
Private nPosOcorr
Private cOcorrIns := If(cEmpAnt=="01",SuperGetMV("MV_XTMK003",.T.,""),"")
Private cOcorrRem := If(cEmpAnt=="01",SuperGetMV("MV_XTMK004",.T.,""),"") 
private cOcorrTnf := If(cEmpAnt=="01",SuperGetMV("MV_XTMK012",.T.,""),"") 

If cEmpAnt <> "01"
	Return
EndIf

//Tipos de contratos
aContr := {"Locação",;			//[1]
			"Serv.Café",;		//[2]
			"LA",;				//[3]
			"S.A",;				//[4]
			"Kit Lanche",;		//[5]
			"Café + Locação",;	//[6]
			"LA + Locação",;	//[7]
			"SA + Locação"}		//[8]
			
                                
// Devem ser iniciada assim para que possam ser visiveis no PE TK271END/TK272HTM/TTTMKA07
_SetOwnerPrvt("aAltProd",{})		// guarda a relacao dos produtos alterados
_SetOwnerPrvt("aExcProd",{})		// guarda a relacao dos produtos excluidos		
_SetOwnerPrvt("llAlterou",.F.)		// controle - se alterou ou nao
_SetOwnerPrvt("llExcluiu",.F.)		// controle - se excluiu ou nao
_SetOwnerPrvt("llOMM",.F.)			// controle - se eh OMM ou nao
_SetOwnerPrvt("cTgtMail","")		// destinatarios email - se eh OMM ou nao                                                                  

// Busca posicoes dos campos no aCols
nPosAss		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ASSUNTO"})	// Assunto
nPosProd	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})	// Produto
nPosDesc	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_DESCPRO"})	// Descricao
nPosOcorr	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OCORREN"})	// Ocorrencia
nPosObs		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OBS"})		// Observacao
nPObsExec	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OBSEXEC"})	// Complemento
nPosRecno	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_REC_WT"})	// RECNO

// Caso seja um assunto diferente de OMM, nao continua
If aCols[1][nPosAss] <> cOMM
	Return lRet
EndIf 

llOMM := .T.

// Caso seja uma ocorrencia diferente de instalacao, nao continua
If aCols[1][nPosOcorr] <> cOcorrIns
	//Return lRet
EndIf

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒ•½Œ•½¿
//³Verifica existencia dos campos customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒ•½Œ•½Ù
*/
AADD(aFields, {"SUD"})			//[1]
AADD(aFields[1], {"UD_XVOLT",;	//[1][2][1]
				"UD_XPTHDL",;	//[1][2][2]
				"UD_XMOEDA",;	//[1][2][3]
				"UD_XOBSPAG",;
				"UD_XMINIMO",;
				"UD_XVLALUG",;
				"UD_XSUBS",;
				"UD_XTPABAS",;
				"UD_XOBSREC",;
				"UD_XPLGNBR",;
				"UD_XPRDANT",;				
				"UD_XDIVLOC",;
				"UD_XVLRMOE",;
				"UD_XVLRINS",;
				"UD_XTPCONT"})

If FindFunction("U_TTTMKA06")
	lVldFields := U_TTTMKA06(aFields)
	If ValType(lVldFields) == "L"
		If !lVldFields
			Return
		EndIf
	EndIf	
EndIf

// Busca posicoes de campos customizados
nPosVolt	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XVOLT"})	// Voltagem
nPosPtHdl	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XPTHDL"})	// Ponto Hidraulico
nPosMoeda	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XMOEDA"})	// Moeda
nPosObsPg	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XOBSPAG"})	// Obs pagamento
nPosMin		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XMINIMO"})	// Minimo Maq
nPosValor	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XVLALUG"})	// Valor Aluguel
nPosSubs	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XSUBS"})	// Doses subsidiadas
nPosTpAbas	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XTPABAS"})	// Tipo Abastecimento
nPosReceit	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XOBSREC"})	// Receita
nPosPlug	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XPLGNBR"})	// Plug NBR
nPosAlt		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XPRDANT"})	// Produto alterado
nPosDiv		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XDIVLOC"})	// Observacoes diversas de locacao
nPosVlMo	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XVLRMOE"})	// Valor de alguel do moedeiro
nPosVlIn	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XVLRINS"})	// Valor de instalacao da maquina
nPosTpCont	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XTPCONT"})	// Tipo do Contrato
nPosPatr	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XNPATRI"})	// Patrimonio

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Na alteracao, caso ainda nao tenha informado o patrimonio         ³
//³Se alterar o produto, salva o produto anterior no campo UD_XPRDANT³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If ALTERA
	dbSelectArea("SUD")
	dbSetOrder(1)
	If dbSeek(xFilial("SUD")+SUC->UC_CODIGO) 
		While SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
			For nI := 1 To Len(aCols)						
				If aCols[nI][nPosRecno] == Recno() .And. AllTrim(aCols[nI][nPosAss]) == cOMM 
					
					// tratamento para exclusao do produto na OMM
					If aCols[nI][Len(aCols[nI])]
						AjustaSN1(aCols[nI][nPosOcorr],aCols[nI][nPosPatr])
						llExcluiu := .T.
						AADD( aExcProd, aCols[nI][nPosProd] )
						
						If FindFunction("U_TTGENC01")
							U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ALTERACAO","",SUC->UC_CODIGO,"",cusername,dtos(date()),time(),,"PRODUTO EXCLUIDO: "+aCols[nI][nPosProd],SUBSTR(SUC->UC_CHAVE,1,6),SUBSTR(SUC->UC_CHAVE,7),"SUD")	
						EndIf
												
				    // tratamento para alteracao do produto na OMM
					Else
						If AllTrim(aCols[nI][nPosProd]) <> AllTrim(SUD->UD_PRODUTO)
							If !Empty(aCols[nI][nPosPatr])
								AjustaSN1(aCols[nI][nPosOcorr],aCols[nI][nPosPatr])
								aCols[nI][nPosPatr] := ""
							EndIf
					
							aCols[nI][nPosAlt] := SUD->UD_PRODUTO 
							llAlterou := .T.
							AADD(aAltProd,{aCols[nI][nPosAlt],;	//[1] Produto anterior
											aCols[nI][nPosProd],;	//[2] Produto novo
											Recno()})				//[3] Recno
											
							If FindFunction("U_TTGENC01")
								U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ALTERACAO","",SUC->UC_CODIGO,"",cusername,dtos(date()),time(),,"PRODUTO ALTERADO - ANTERIOR: "+aCols[nI][nPosAlt] +" NOVO: "+aCols[nI][nPosProd] ,SUBSTR(SUC->UC_CHAVE,1,6),SUBSTR(SUC->UC_CHAVE,7),"SUD")	
							EndIf
						EndIf
					EndIf	
				EndIf
			Next nI
			IIF(Empty(cTgtMail),IIF( AllTrim(UsrRetMail(SUD->UD_OPERADO))<>"", cTgtMail += AllTrim(UsrRetMail(SUD->UD_OPERADO)), ), ) 
		 	SUD->(dbSkip())
		End
	EndIf	   
	RestArea(aArea)
        
	// ativa/desativa tela de detalhes da maquina na alteracao
	If !lAtivaAlt
		Return lRet
	EndIf	
EndIf

If aCols[1][nPosOcorr] <> cOcorrIns
	Return lRet
EndIf

// Busca a quantidade de itens do Grid
For nI := 1 To Len(aCols)
	// Se nao for atendimento de OMM, cancela a abertura da tela                  
	If AllTrim(aCols[nI][nPosAss]) <> cOMM
		Return lRet
	EndIf
	// Caso contrario adiciona os itens no array aItens
	AADD(aItens, {aCols[nI][nPosProd],;		//[1] Produto
					aCols[nI][nPosDesc]})		//[2] Descricao
					
Next nI


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Para todos os itens, abre uma tela para digitacao dos parametros³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ
*/
For nI := 1 To Len(aItens)
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³ Configura as perguntas do Parambox                                         ³
	//³Foi feito assim para que dentro do ParamBox apareça qual o codigo da Maquina³
	//³Já que no aCols nao temos o campo Item da Grid                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	*/	

	aAdd(aPergs ,{9,"Maquina: "+AllTrim(aItens[nI][1]) +" " +Alltrim(aItens[nI][2]),130,8,.T.})						//[1]	
	aAdd(aPergs ,{9,"Detalhes"				,130,8,.T.})																//[2]
	aAdd(aPergs ,{3,"Voltagem"				,1,aVolt,50,"",.F.})														//[3]
	aAdd(aPergs ,{3,"Plug NBR"				,1,aPlugNBR,50,"",.F.})													//[4]	
	aAdd(aPergs ,{2,"Forma de abastecimento",aFAbast[1], aFAbast,100,".T.",.F.})										//[5]
	aAdd(aPergs ,{3,"Ponto Hidraulico"		,1,aPtHdl,50,"",.F.})														//[6]
	
	aAdd(aPergs ,{9,"Sistema de Pagamento",130,8,.T.})																	//[7]	
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"Aceitador de Cedulas",90,"",.F.})										//[8]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"Moedeiro com troco",90,"",.F.})										//[9]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"Moedeiro sem troco",90,"",.F.})										//[10]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"VR",90,"",.F.})														//[11]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"Leitor Smart Tok Take",90,"",.F.})										//[12]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"POS",90,"",.F.})														//[13]
	aAdd(aPergs ,{4,"Sistema de Pagamento",.F.,"Cartão Indutivo",90,"",.F.})											//[14]
	aAdd(aPergs ,{1,"Observação"			,space(TamSx3("UD_XOBSPAG")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})			//[15]
		
	aAdd(aPergs ,{9,"Cobrança"				,130,8,.T.})                                    							//[16]
	aAdd(aPergs ,{3,"Minimo"				,2,aMin,50,"",.F.})														//[17]
	aAdd(aPergs ,{1,"Quantidade Minima"		,0,PESQPICT("SUD","UD_XMINIMO"),"","","IIF(mv_par17==1,.T.,.F.)",50,.F.})	//[18]
	aAdd(aPergs ,{1,"Valor do aluguel"		,0,PESQPICT("SUD","UD_XVLALUG"),"","","",50,.F.})							//[19]
	aAdd(aPergs ,{3,"Doses subsidiadas"		,1,aDoses,50,"",.F.})														//[20]
	aAdd(aPergs ,{1,"Observação"			,space(TamSX3("UD_OBS")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})				//[21]
	aAdd(aPergs ,{1,"Receita"				,space(TamSx3("UD_XOBSREC")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})			//[22]
    //acertar estes
    aAdd(aPergs ,{1,"Gestor"				,space(TamSx3("UD_XDIVLOC")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})			//[23]
	aAdd(aPergs ,{2,"Estac. no local"		,1,aDoses,50,"",.F.})														//[24]
	aAdd(aPergs ,{2,"Estac. Pago"			,1,aDoses,50,"",.F.})														//[25]
	aAdd(aPergs ,{2,"Restrição caminhoes"	,1,aDoses,50,"",.F.})														//[26]
	aAdd(aPergs ,{2,"Acompanha 1 Kit"		,1,aDoses,50,"",.F.})														//[27]
    aAdd(aPergs ,{1,"Forma Pagto Kit"		,space(TamSx3("UD_XDIVLOC")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})			//[28]
    aAdd(aPergs ,{1,"Prazo Pagto Kit" 		,space(TamSx3("UD_XDIVLOC")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})			//[29]
	aAdd(aPergs ,{1,"Valor aluguel Moedeiro",0,PESQPICT("SUD","UD_XVLRMOE"),"","","",50,.F.})							//[30]
	aAdd(aPergs ,{1,"Valor de instalação"	,0,PESQPICT("SUD","UD_XVLRINS"),"","","",50,.F.})							//[31]
	aAdd(aPergs ,{2,"Tipo de Contrato"		,aContr[1],aContr,100,"",.F.})												//[32]
	
	If nI > 1
		For nJ := 1 To Len(aRetTudo)
			If aItens[nI][1] == aRetTudo[nJ][1]
				aPergs := aClone(aRetTudo[nJ][4])
				Exit
			EndIf
		Next nJ
	EndIf
		
	While !lVldTela
		// Executa tela do parambox
		If !ParamBox(aPergs ,"Detalhes",@aRet)//,,,.T.)
			lRet := .F.
			Return lRet
		EndIf
		
		For nJ := 3 To Len(aRet)
			If nJ == 7 .Or. nJ == 16
				Loop
			EndIf
			aPergs[nJ][3] := aRet[nJ]
		Next nJ		
		
		// Valida valor minimo
		If aRet[17] == 1 .And. aRet[18] == 0
			Aviso("TK271BOK","Preencha o campo de Valor Minimo!",{"Ok"})
			// Salva no array aPergs as respostas atuais pois na proxima execucao do ParamBox ele traz os valores padroes
	
		ElseIf aRet[9] .And. aRet[10]
			Aviso("TK271BOK","Marque apenas uma opção de Moedeiro!",{"Ok"})
			// Salva no array aPergs as respostas atuais pois na proxima execucao do ParamBox ele traz os valores padroes
		Else
			lVldTela := .T.	
		EndIf
	End
		     
	// Adiciona o produto e as respostas no array aRetTudo - sera usado depois para gravacao nos campos
	AADD(aRetTudo, {aItens[nI][1],;	//[1] Produto
					.F.,;				//[2] Flag - Se ja usou este produto ou nao 
					aRet,;				//[3] Respostas
					aPergs})
	aPergs := {}
	lVldTela := .F.
Next nI


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ d˜d˜d¿
//³Salva nos campos do aCols os valores do ParamBox³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ d˜d˜dÙ
*/
cObsMemo += "Detalhes de instalação/cobrança" +CRLF
	
For nI := 1 To Len(aCols)
	For nJ := 1 To Len(aRetTudo)
		// Verifica se ja passou por este produto do array aRetTudo - Respostas
		If aRetTudo[nJ][2]
			Loop
		EndIf

		If aCols[nI][nPosProd] == aRetTudo[nJ][1]
			
			// Voltagem		
			aCols[nI][nPosVolt]		:= IIF(aRetTudo[nJ][3][3] <> 3,AllTrim(Str(aRetTudo[nJ][3][3]))," ")
			
			// Plug NBR
			aCols[nI][nPosPlug]		:= IIF(aRetTudo[nJ][3][4] <> 3,AllTrim(Str(aRetTudo[nJ][3][4]))," ")		 
			
			// Forma de Abastecimento
			For nK := 1 To Len(aFAbast)
            	If aFAbast[nK] == aRetTudo[nJ][3][5]
            		cTpAbast := aFAbast[nK]
            		Exit
            	EndIf
            Next nK
            		
			// Ponto Hidraulico
			aCols[nI][nPosPtHdl]	:= IIF(aRetTudo[nJ][3][6] <> 3,AllTrim(Str(aRetTudo[nJ][3][6]))," ")   	
			            
            //Aceitador de Cedulas
            If aRetTudo[nJ][3][8]
            	cMoeda += "CE=1|"
	            cDescPag += "Aceitador de cédulas" + "|"
            Else
            	cMoeda += "CE=0|"
            EndIf	

            //Moedeiro com troco
            If aRetTudo[nJ][3][9]
            	cMoeda += "MC=1|"
            	cDescPag += "Moedeiro com troco" + "|"
            Else
            	cMoeda += "MC=0|"
            EndIf	
            
            //Moedeiro sem troco                       
            If aRetTudo[nJ][3][10]
            	cMoeda += "MS=1|"
	            cDescPag += "Moedeiro sem troco" + "|"
            Else                	
            	cMoeda += "MS=0|"
			EndIf
			
            //VR
            If aRetTudo[nJ][3][11]
            	cMoeda += "VR=1|"
	            cDescPag += "VR" + "|"
	        Else
	        	cMoeda += "VR=0|"
	        EndIf    
            //Smart
            If aRetTudo[nJ][3][12]
            	cMoeda += "SM=1|"
   				cDescPag += "Smart" + "|"
   			Else
   				cMoeda += "SM=0|"
   			EndIf
            //POS
            If aRetTudo[nJ][3][13]
            	cMoeda += "PO=1|"
            	cDescPag += "POS" + "|"
            Else
            	cMoeda += "PO=0|"
            EndIf
            //Cartao Indutivo
            If aRetTudo[nJ][3][14]
            	cMoeda += "CI=1|"
            	cDescPag += "CI" + "|"
            Else
            	cMoeda += "CI=0|"
            EndIf
            
            If SubStr(cMoeda,Len(cMoeda),1) == "|"
            	cMoeda := SubStr(cMoeda,1,Len(cMoeda)-1)
            EndIf
            
            If Alltrim(cDescPag) == ""
            	cDescPag := "GRATIS"
            EndIf	
            
            // Tipo de Pagamento 
			aCols[nI][nPosMoeda]	:= cMoeda
			
			// Obs Pagamento
			aCols[nI][nPosObsPg]	:= aRetTudo[nJ][3][15]
			
			// Minimo
			If aRetTudo[nJ][3][17] == 1
				aCols[nI][nPosMin]	:= aRetTudo[nJ][3][18]
			Else
				aCols[nI][nPosMin]	:= 0				
			EndIf
			
			// Quantidade Minima
			aCols[nI][nPosValor]	:= aRetTudo[nJ][3][19]
			
			// Doses subsidiadas
			aCols[nI][nPosSubs]		:= AllTrim(Str(aRetTudo[nJ][3][20]))
			
			// Observacao
			aCols[nI][nPosObs]		:= aRetTudo[nJ][3][21]
			
			// Receita
			aCols[nI][nPosReceit]	:= aRetTudo[nJ][3][22]
            
			// Informacoes referente a locacoes
			//     cObsMemo               
			cAux	:=	"GS;"+AllTrim(aRetTudo[nJ][3][23])+"|ESL;"+cvaltochar(aRetTudo[nJ][3][24])
			cAux	+=	"|ESP;"+cvaltochar(aRetTudo[nJ][3][25])+"|ESR;"+cvaltochar(aRetTudo[nJ][3][26])
			cAux	+=	"|KIT;"+cvaltochar(aRetTudo[nJ][3][27])+"|KTF;"+cvaltochar(aRetTudo[nJ][3][28])
			cAux	+=	"|KTP;"+cvaltochar(aRetTudo[nJ][3][29])
			
			aCols[nI][nPosDiv]	:= cAux
			
			// valor moedeiro
			aCols[nI][nPosVlMo]	:= aRetTudo[nJ][3][30]
			
			// valor de instalacao
			aCols[nI][nPosVlIn] := aRetTudo[nJ][3][31]
			
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para Tipo de Contrato³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
		 	For nK := 1 To Len(aContr)
            	If aContr[nK] == aRetTudo[nJ][3][32]
            		cContr := CValToChar(nK)
            		cDescContr := aContr[nK]
            		Exit
            	EndIf
            Next nK
            
            aCols[nI][nPosTpCont] := cContr
			
	         
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄrd¿
			//³Flega a posicao 2 do array para controle pois podem existir produtos repetidos no grid ³
			//³e nao temos no aCols o campo item para controle                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄrdÙ
			*/
			aRetTudo[nJ][2] := .T.
			                                               
			
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona as informacoes tambem no campo de Complemento do ITEM		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			cObsMemo += "Produto: " +aCols[nI][nPosProd] +CRLF	//UD_CODEXEC (MEMO)
	        
			// Voltagem
			If AllTrim(aCols[nI][nPosVolt]) == "1"
				cObsMemo += "Voltagem: 110v" +CRLF
			ElseIf AllTrim(aCols[nI][nPosVolt]) == "2"
				cObsMemo += "Voltagem: 200v" +CRLF				
			Else
				cObsMemo += "Voltagem: Não se aplica" +CRLF				
			EndIf      
			
			// Plug NBR
			If AllTrim(aCols[nI][nPosPlug]) == "1"
				cObsMemo += "Plug NBR: Sim" +CRLF
			ElseIf AllTrim(aCols[nI][nPosPlug]) == "2"
				cObsMemo += "Plug NBR: Não" +CRLF				
			Else
				cObsMemo += "Plug NBR: Não se aplica" +CRLF				
			EndIf		
			
			// Formas de Abastecimento
			cObsMemo += "Forma de Abastecimento: " +cTpAbast +CRLF
			
			// Ponto Hidraulico
			If AllTrim(aCols[nI][nPosPtHdl]) == "1"
				cObsMemo += "Pt. Hidraulico: Sim" +CRLF
			ElseIf AllTrim(aCols[nI][nPosPtHdl]) == "2"
				cObsMemo += "Pt. Hidraulico: Não" +CRLF
			Else
				cObsMemo += "Pt. Hidraulico: Não se aplica" +CRLF
			EndIf
			
			// Sistema de pagamento
			cObsMemo += "Sistema de Pagamento: " +cDescPag +CRLF
			
			// Observacao                                              
			cObsMemo += "Observação: " +AllTrim(aRetTudo[nJ][3][14]) +CRLF
			             
			// Minimo
			If aRetTudo[nJ][3][17] == 1 
				cObsMemo += "Quantidade Minima: " +AllTrim(Transform(aRetTudo[nJ][3][18], PESQPICT("SUD","UD_XMINIMO")))  +CRLF
			Else
				cObsMemo += "Quantidade Minima: " +CRLF
			EndIf
			         
			// Valor Aluguel
			cObsMemo += "Valor do aluguel: R$" +AllTrim(Transform(aRetTudo[nJ][3][19], PESQPICT("SUD","UD_XVLALUG"))) +CRLF
			                
			// Doses subsidiadas
			If aRetTudo[nJ][3][20] == 1
				cObsMemo += "Doses subsidiadas: Sim" +CRLF
			Else
				cObsMemo += "Doses subsidiadas: Não" +CRLF	
			EndIf
			
			// Observacao
			cObsMemo += "Observação: "+AllTrim(aRetTudo[nJ][3][21]) +CRLF
			
			cObsMemo += "Receita: " +AllTrim(aRetTudo[nJ][3][22]) +CRLF
			
			// Tipo de Contrato
			cObsMemo += "Tipo de Contrato: " +cDescContr +CRLF
			 
			//Informacoes sobre Locacoes
			cObsMemo += "Gestor: " +AllTrim(aRetTudo[nJ][3][23]) +CRLF
			cObsMemo += "Estacionamento no Local: " +If(If(valtype(aRetTudo[nJ][3][24])=="N",aRetTudo[nJ][3][24]==1,aRetTudo[nJ][3][24]=="S"),"Sim","Não") +CRLF
			cObsMemo += "Estacionamento Pago: " +If(If(valtype(aRetTudo[nJ][3][25])=="N",aRetTudo[nJ][3][25]==1,aRetTudo[nJ][3][25]=="S"),"Sim","Não") +CRLF
			cObsMemo += "Restrição Caminhão: " +If(If(valtype(aRetTudo[nJ][3][26])=="N",aRetTudo[nJ][3][26]==1,aRetTudo[nJ][3][26]=="S"),"Sim","Não") +CRLF
			cObsMemo += "Acompanha 1º Kit: " +If(If(valtype(aRetTudo[nJ][3][27])=="N",aRetTudo[nJ][3][27]==1,aRetTudo[nJ][3][27]=="S"),"Sim","Não") +CRLF  
			cObsMemo += "Forma Pagto Kit: " +Alltrim(aRetTudo[nJ][3][28]) +CRLF
			cObsMemo += "Prazo Pagto Kit: " +Alltrim(aRetTudo[nJ][3][29]) +CRLF
			cObsMemo += "Valor Aluguel Moedeiro: " +AllTrim(Transform(aRetTudo[nJ][3][30], PESQPICT("SUD","UD_XVLRMOE"))) +CRLF            
			cObsMemo += "Valor Instalação Maquina: " +AllTrim(Transform(aRetTudo[nJ][3][31], PESQPICT("SUD","UD_XVLRINS"))) +CRLF
					            
			aCols[nI][nPObsExec] := cObsMemo
			cDescPag := ""
			cMoeda := ""
			cObsMemo := ""
		    
			// Sai do Loop interno para o proximo item do aCols
			Exit
			                                          
		EndIf		                                      
	Next nJ
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSN1 ºAutor  ³Jackson E. de Deus  º Data ³  09/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o status do patrimonio na alteracao de produto      º±±
±±º          ³ e exclusao de linha                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSN1(cOcorr,cNumChapa)

Local aArea := GetArea()
Local nRecSN1 := 0
Local cStatN1 := ""
Local nI := 0
      
dbSelectArea("SN1")
nRecSN1 := U_TTTMKA19(cNumChapa)
If nRecSN1 > 0
	SN1->( dbGoTo(nRecSN1) )
	If AllTrim(cOcorr) == AllTrim(cOcorrIns)
		cStatN1 := "1"
	ElseIf AllTrim(cOcorr) == AllTrim(cOcorrRem) .Or. AllTrim(cOcorr) == AllTrim(cOcorrTnf)
		cStatN1 := "3"
	EndIf              
	
	If AllTrim(SN1->N1_CHAPA) == AllTrim(cNumChapa) .And. !AllTrim(SN1->N1_XSTATTT) $ cStatN1
		If RecLock("SN1",.F.)
			SN1->N1_XSTATTT := cStatN1
			MsUnlock()
		EndIf	
	EndIf  
EndIf

RestArea(aArea)   

Return