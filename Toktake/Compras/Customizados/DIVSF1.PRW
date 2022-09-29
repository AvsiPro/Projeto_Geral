
/*--------------------------|
| BIBLIOTECAS DE FUNÇÕES	|
|--------------------------*/  
 #INCLUDE "PROTHEUS.CH"    //
 #INCLUDE "RWMAKE.CH"      //
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦DIVSF1()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦16.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotina principal com a escolha do filtro da nota           ¦¦¦
¦¦¦			 ¦															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

User Function DIVSF1()

    Private oDlg2
	Private cFiltra 
	Private ocFiltro    := Space(15)
	Private ocTipo   	:= Space(10)
	Private dDtInicio	:= Ctod(Space(8))
	Private dDtFinal	:= Ctod(Space(8))
	Private alTipo		:={"Serviços","Compras"}
	Private alFiltro	:={"Bloqueada","Liberada","Ambos"}

 If cEmpAnt $ "01/02"
   
	If GetMv("MV_XDIVNF")==.T.//Parametro lógico para controlar a rotina
		cUser := RetCodUsr()
		DBSELECTAREA("SX5")
		DBSETORDER(1)
 		oDlg2:=MsDialog():New(000,000,230,318,"Liberação de notas bloqueadas",,,,,CLR_BLACK,CLR_HGRAY,,,.T.)
 			@ 05,50 Say "F I L T R O   D E   N O T A S " Pixel  Of oDlg2	 		
 			@ 20,25 Say "Status" Pixel  Of oDlg2
			@ 20,50 ComboBox ocFiltro Items alFiltro  Size 85,10 pixel of oDlg2									
			@ 35,25 Say "Tipo" Pixel  Of oDlg2
			@ 35,50 ComboBox ocTipo Items alTipo  Size 85,10 pixel of oDlg2			
			@ 02, 05  To 110, 156 LABEL "" Pixel Of oDlg2
			@ 050, 25 Say "Entrada De ?"  	  Pixel Of oDlg2
			@ 050, 95 Msget  dDtInicio	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2			
			@ 065, 25 Say "Entrada Ate ?"  	  Pixel Of oDlg2
			@ 065, 95 MsGet  dDtFinal	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2			
  			opButton1:=tButton():New(085,010,"&Confirmar" 	,oDlg2,{||Filtro()},70,20,,,,.T.) && Botão para a chamada da Mbrowse 
  			opButton2:=tButton():New(085,080,"&Sair" 	,oDlg2,{||close(oDlg2)},70,20,,,,.T.) && Finaliza a tela de Status da nota	 
		oDlg2:Activate(,,,.T.,,,)                                                                       
	Else
		AVISO("Menssagem ", "O parâmetro MV_XDIVNF está desabiliatdo ",{"OK"},1)
	EndIf			
EndIf

return nil

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Filtro()   ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ criação da mBrowse para divergencia entre a nota de entrada¦¦¦
¦¦¦			 ¦ e a pre nota												  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  
		
static Function Filtro()

    Local   clTipos
	Private aIndexSF1 := {} 
	Private bFiltraBrw
		
	Private cCadastro := "DIVERGENCIA ENTRE NOTA E QTDE FÍSICA"
	Private aRotina := {{"PESQUISAR"		,"AxPesqui"		,0,1} ,; // pesquisar
			             {"LIBERA PAGTO"	,"U_TELA"		,0,2} ,; // libera pagamento
			             {"LEGENDA"			,"U_Legend"		,0,3} ,; // legenda
			             {"VISUALISAR"		,"U_TELA"		,0,4} ,; // visualizar
			             {"REL. DE DIV."	,"U_TTBLQR001"	,0,5} }  // relatório
 			             
	Private aCores 	:= { {"F1_XSTDIV=='B'"	,"BR_VERMELHO"		} ,; // Bloqueada
						 {"F1_XSTDIV=='L'" 	,"BR_AMARELO"		} ,; // Liberada
						 {"F1_XSTDIV=='V'" 	,"BR_VERDE"			} ,; // S/divergencia
						 {"EMPTY(F1_XSTDIV)","BR_AZUL" 			}} 	 // N/classificada
   
	
	If	ocTipo=="Serviços"
		If ocFiltro=="Bloqueada"	
	 		cFiltra:=" F1_XSTDIV='B' .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='N' " 
	 	EndIf
		If ocFiltro=="Liberada" 		
	 		cFiltra:="F1_XSTDIV='L' .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='N' "
	 	EndIf
	 	If ocFiltro=="Ambos" 
	 		cFiltra:="F1_XSTDIV $ 'B/L'  .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='N' " 
		EndIf
	ElseIf ocTipo== "Compras"
		If ocFiltro=="Bloqueada"	
	 		cFiltra:=" F1_XSTDIV='B' .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='S'  " 
	 	EndIf
		If ocFiltro=="Liberada" 		
	 		cFiltra:="F1_XSTDIV='L' .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='S' "
	 	EndIf
	 	If ocFiltro=="Ambos" 
	 		cFiltra:="(F1_XSTDIV ='L' .OR. F1_XSTDIV ='B' ) .AND. (F1_DTDIGIT >=dDtInicio .AND. F1_DTDIGIT <=dDtFinal) .AND. F1_XESTSIM='S' " 
		EndIf
	EndIf
 		 
	bFiltraBrw:= { || FilBrowse("SF1",@aIndexSF1,@cFiltra) }  	
	Eval(bFiltraBrw)			            
		dbSelectArea("SF1")                      
		mBrowse( 6,1,22,75,"SF1",,,,"EMPTY(F1_XSTDIV)",3,aCores)// cria uma browse da tabela especificada no quinto parametro		 
	EndFilBrw("SF1",aIndexSF1)
	 
Return Nil                                                          
         
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TELA()   ¦ Autor ¦ Ricardo Souza		    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Tela onde mostrará os itens que estão com problemas		  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TELA(cAlias,nReg,nOpc)
        
	Private opTela
	Private oDlg 
	Private opQtdenp
	Private clTipo 
	Private oGetDados
	Private oMultiGe1
	Private cMultiGe1 	:= ""
	Private cpQtdenp	:= 0
	Private	nUsado 		:= 0
	Private nC			:= 0	  
	Private aHEADER 	:= {}
	Private ACOLS 		:= {}
	Private cpFilial	:= space(2)
	Private cpDoc		:= space(9)
	Private cpMotBlq	:= space(600)
	Private cpSerie		:= space(3)
	Private cpForCli	:= space(6)
	Private cpLoja		:= space(4)
	Private cpNome		:= space(40)
	Private ocLib		:= space(9) 
	Private dpDentre	:= Ctod(Space(8))
	Private clPict1		:= "@E 999999999.99"
	Private alLib		:= {"Liberado","Devolução","N.Debito"}
	
   
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZ4")
	
	/*----------------------------------------------------------------------------------| 		    			           
	|    		condição para trazer somente os campos que estão na getdados			| 
	|----------------------------------------------------------------------------------*/ 
	
	While !Eof() .and. SX3->X3_ARQUIVO == "SZ4"
		If X3Uso(SX3->X3_USADO) 			.And. ;
			(cNivel >= SX3->X3_NIVEL) 		.And. ;
			(SX3->X3_CAMPO = "Z4_STATUS") 	.Or.  ;   
			(SX3->X3_CAMPO = "Z4_ITEM") 	.Or.  ;
			(SX3->X3_CAMPO = "Z4_PRODUTO")  .Or.  ;
			(SX3->X3_CAMPO = "Z4_DESC")		.Or.  ;
			(SX3->X3_CAMPO = "Z4_OPER")		.Or.  ;
			(SX3->X3_CAMPO = "Z4_VLRCORR")  .Or.  ;
			(SX3->X3_CAMPO = "Z4_VLRINF") 	.Or.  ;
			(SX3->X3_CAMPO = "Z4_TOTDIV") 	.Or.  ;
			(SX3->X3_CAMPO = "Z4_PEDIDO")	.Or.  ;
			(SX3->X3_CAMPO = "Z4_DATA")		.Or.  ;
			(SX3->X3_CAMPO = "Z4_HORA")		.Or.  ;
			(SX3->X3_CAMPO = "Z4_USER")	 																	
	        nUsado++ 
	        
	/*--------------------------------------------------------------| 		    			           
	|    		adciona as estruturas dos campos no aheader			| 
	|--------------------------------------------------------------*/
		
			Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,"",SX3->X3_TIPO,"","" })	
		EndIf
		DbSkip()	
	EndDo

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SE2")
	While !Eof() .and. SX3->X3_ARQUIVO == "SE2"
		If X3Uso(SX3->X3_USADO) 			.And. ;
			(cNivel >= SX3->X3_NIVEL) 		.And. ;
			(SX3->X3_CAMPO = "E2_XMOTLIB")
			nUsado++ 
				Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,"",SX3->X3_TIPO,"","" })	
		EndIf
		DbSkip()	
	EndDo
	
	Aadd(aCols,Array(nUsado+1))
	For nI := 1 To nUsado
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next
	aCols[1][nUsado+1] := .F.
	
	DbSelectArea("SF1")
	If SF1->F1_XSTDIV <> "B" .AND. nOpc==2 
		AVISO("Menssagem", "Nota sem pagamento bloqueado",{"OK"},1)	
	Else  
		opTela:= MSDialog():New(000,000,550,1240,"DIVERGENCIA DE NOTA_ENTRADA/PRE_NOTA",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			If nOpc==2		//Liberar pagamento
				EnchoiceBar(opTela,{||FLibera()},{||close(opTela)},.F.,) // Traz a tela de liberação do pagamento.
			ElseIf nOpc==4  //visualizar	
				EnchoiceBar(opTela,{||close(opTela)},{||close(opTela)},.F.,)// Traz a tela no modo de visualização.
			EndIf
				@ 020, 02 To 45, 620 Pixel Of opTela
				
				@ 030, 50 Say "Nota"  	  Pixel Of opTela
				@ 030, 70 MsGet opDoc 	  Var cpDoc 	Picture "@!" Size 40,0.5 Pixel Of opTela
				opDoc:lReadOnly := .T. 
			
				@ 030, 120 Say "Serie" 	  Pixel Of opTela
				@ 030, 140 MsGet opSerie  Var cpSerie 	Picture "@!" Size 20,0.5 Pixel Of opTela
				opSerie:lReadOnly := .T.
				
				@ 030, 170 Say "ForCli"   Pixel Of opTela
				@ 030, 190 MsGet opForCli Var cpForCli 	Picture "@!" Size 30,0.5 Pixel Of opTela
				opForCli:lReadOnly := .T.
				
				@ 030, 230 Say "Loja"  	  Pixel Of opTela
				@ 030, 250 MsGet OpLoja	  Var cpLoja 	Picture "@!" Size 20,0.5 Pixel Of opTela
				opLoja:lReadOnly := .T.
				                        	
				@ 030, 300 Say "Nome"  	  Pixel Of opTela
				@ 030, 320 MsGet OpNome   Var cpNome	Picture "@!" Size 120,0.5 Pixel Of opTela
				OpNome:lReadOnly := .T.
				
				@ 030, 450 Say "Filial"   Pixel Of opTela
				@ 030, 470 MsGet opFilial Var cpFilial 	Picture "@!" Size 10,0.5 Pixel Of opTela
				opFilial:lReadOnly := .T.
				
				@ 030, 500 Say "Entrega"  Pixel Of opTela
				@ 030, 530 MsGet OpDentre Var dpDentre 	Picture "99/99/99" Size 40,0.5 Pixel Of opTela
				OpDentre:lReadOnly := .T.
				
				@ 228, 60 Say "TOTAL DE DIVERGENCIA EM R$"  Pixel Of opTela
				@ 240, 10 MsGet opQtdenp Var cpQtdenp 	Picture "@E 999,999,999.999" Size 150,15 Pixel Of opTela
				@ 235, 02  To 260, 202 Pixel Of opTela
				opQtdenp:Disable()
				
				clChave		:= SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)
				cpQtdenp    := U_TTBLQ000(clChave)
				
				@ 228, 220 Say "H E L P"  Pixel Of opTela
				@ 237, 220 Say "O VALOR DESTACADO AO LADO É REFERENTE AS DIVERGENCIA ENCONTRADAS NO PREÇO UNITÁRIO E NA CONFERENCIA"  Pixel Of opTela
				@ 247, 220 Say "CEGA DA NOTA FISCAL, O MEMSO SERÁ ULTILIZADO CASO O TÍTULO SEJA LIBERADO COMO N. DÉBITO."  Pixel Of opTela
				@ 235, 212 To 260, 620 Pixel Of opTela
				
				Dadosd2() // Subfunção que alimenta os itens da nota divergente
				
			oGetDados := MsGetDados():New(55,01,220,622,2,,,,.F.,,,.T.,200,,,,,opTela) // GetDados que receberá os itens das notas Fiscais
			DIV->(DbCloseArea()) // fecha a tabela temporaria DIV			
		opTela:Activate(,,,.T.,,,)
	EndIf
Return Nil

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦DADOSD2()   ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Função para atribuir Valores e Atualizar o Acols      	  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function Dadosd2()

	DbSelectArea("SF1")

	cpFilial	:= xfilial("SF1")//SF1->F1_FILIAL da Filial corrente
	cpDoc		:= SF1->F1_DOC
	cpSerie		:= SF1->F1_SERIE
	cpForCli	:= SF1->F1_FORNECE
	cpLoja		:= SF1->F1_LOJA
	dpDentre	:= SF1->F1_DTDIGIT 
	clTipo		:= SF1->F1_TIPO
			               
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SA2")+cpForCli +cpLoja ) // posiciona  na tabela de fornecedore nos indices forcli e loja
		 cpNome	:= SA2->A2_NOME
	EndIF
	
	/*----------------------------------------------------------------------------------| 		    			           
	|   Query com os dados da SD1(itens das notas de saída) para carregar a Getdados    | 
	|----------------------------------------------------------------------------------*/	
	
	clbql:= " SELECT Z4_FILIAL 	"
	clBql+= " ,Z4_CHAVENF 		"
	clBql+= " ,Z4_ITEM 			"
	clBql+= " ,Z4_DATA 			"
	clBql+= " ,Z4_HORA 			"
	clBql+= " ,Z4_USER 			"
	clBql+= " ,Z4_PEDIDO 		"
	clBql+= " ,Z4_FORNECE 		"
	clBql+= " ,Z4_LOJA    "
	clBql+= " ,Z4_NOME    "
	clBql+= " ,Z4_OPER    "
	clBql+= " ,Z4_PRODUTO "
	clBql+= " ,Z4_DESC    "
	clBql+= " ,Z4_VLRCORR "
	clBql+= " ,Z4_VLRINF  "
	clBql+= " ,Z4_TOTDIV  "
	clBql+= " ,Z4_OBS     "
	clBql+= " ,Z4_STATUS  "
	clBql+= " ,Z4_CTRL	"

	clBql+= " ,E2_XMOTLIB	"

	clBql+= " FROM " + RetSqlName("SZ4") + " AS SZ4 "                                                
	
	clBql+= " LEFT JOIN "+RetSQLName("SE2")+ " AS E2 ON E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA LIKE SUBSTRING(Z4_CHAVENF,3,22) AND E2.D_E_L_E_T_=''"
	
	clBql+= " WHERE Z4_CHAVENF='"+ SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO) +"' " 
	clBql+= " AND SZ4.D_E_L_E_T_='' "
   	  
  	If Select("DIV") > 0
		dbSelectArea("DIV")
		DbCloseArea()
	EndIf
		    
	TcQuery clBql New Alias "DIV"
	TcSetField("DIV","Z4_DATA"	,"D",08,0)	
	 
	ACOLS:={}
	DbSelectArea("DIV") 
	DbGotop()
	While DIV->(!Eof())	 
			AADD(ACOLS,{ DIV->Z4_STATUS,DIV->Z4_ITEM,DIV->Z4_PRODUTO ,DIV->Z4_DESC ,DIV->Z4_OPER,DIV->Z4_VLRCORR, ;						
						DIV->Z4_VLRINF ,DIV->Z4_TOTDIV,DIV->Z4_PEDIDO,DIV->Z4_DATA ,DIV->Z4_HORA, DIV->Z4_USER  ,DIV->E2_XMOTLIB,.F.})
						nC++				    								
		DIV->(DbSkip())
	EndDo			
Return nil                 

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦FLibera()   ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ subfunção para escolha do tipo de liberação e digitação do ¦¦¦
¦¦¦			 ¦ motivo da liberação.        								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function FLibera()
	Local clMotL
    DbSelectarea("SF1")
    DbSetOrder(1)
    If DbSeek(XFILIAL("SF1")+ cpDoc + cpSerie + cpForCli + cpLoja)		  
  		DbSelectArea("SE2")
	    DbSetOrder(6)
		If DbSeek(XFILIAL("SE2")+cpForCli+cpLoja+cpSerie+cpDoc)		    		    
		    oDlg:= MSDialog():New(000,000,230,318,""+Space(18)+"LIBERAÇÃO DO TITULO",,,,,CLR_BLACK,CLR_WHITE,,,.T.)	  			  				
			    @10,015 Say "T.Liberação:" Pixel  Of oDlg							
			    @10,050 ComboBox ocLib Items alLib  Size 100,10 pixel of oDlg							
			    @30,055 Say "Motivo da Liberação" Pixel  Of oDlg	  			    			
			    @ 40, 001 Get oMultiGe1 Var cMultiGe1 Of oDlg MultiLine Size 158, 55 COLORS 0, 16777215 HSCROLL Pixel				
			    opButton1:=tButton():New(100,005,"CONFIRMAR" ,oDlg,{||Liber()},075,10,,,,.T.)			    			
			    opButton2:=tButton():New(100,080,"SAIR" 	,oDlg,{||Close(oDlg)},075,10,,,,.T.)	  						
		    oDlg:Activate(,,,.T.,,,)
		EndIf	
 	EndIf			
Return Nil

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Liber()   ¦ 	Autor ¦ Ricardo Souza	    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦Subfunção para controlar a quantidade de cacteres digitados ¦¦¦
¦¦¦			 ¦no motivo da liberação e na chamada da função do desbloqueio¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Liber() 
	Local clTipLib
	If Len(cMultiGe1) < 5
		AVISO("Menssagem", "O motivo da liberação deve ter no mínimo 5 caracteres",{"OK"},1)
		oMultiGe1:SetFocus()
		Return()
	Else
		clMotL:=cMultiGe1
	EndIf	

	/*-------------------------------------------------|
	|           Verifica o tipo da liberação           |
	|-------------------------------------------------*/               

	If Trim(ocLib) =="Liberado"
		clTipLib:="L"
	ElseIf Trim(ocLib) == "Devolução"
		clTipLib:="D"
	else
		clTipLib:="N"
	EndIf	
	U_TTBLQ001(cpFilial,cpDoc,cpSerie,cpForCli,cpLoja,clTipo,clTipLib,clMotL,"oDlg","opTela",cpQtdenp)	
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Legend()   ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦15.03.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função para mostrar através de cores quais notas estão	  ¦¦¦
¦¦¦			 ¦ com divergência          								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function Legend()
	BrwLegenda(cCadastro,"STATUS",{{"BR_VERMELHO","DIVERGENCIA BLOQUEADA"},;
	                               {"BR_AMARELO","DIVERGENCIA LIBERADA"},;
	                               {"BR_VERDE","SEM DIVERGENCIA"},;
	                               {"BR_AZUL","SEM APONTAMENTO"}})									
Return .T.
