
/*--------------------------|
| BIBLIOTECAS DE FUNÇÕES	|
|--------------------------*/  
 #INCLUDE "PROTHEUS.CH"    //
 #INCLUDE "RWMAKE.CH"      //
 #INCLUDE "TOPCONN.CH"     //
 #INCLUDE "FONT.CH"        //
 #INCLUDE "COLORS.CH"      //
/*-------------------------*/
                                        
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦F050BUT()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada para criar botão no modo visualizar		  ¦¦¦
¦¦¦			 ¦ do contas a pagar										  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras/TokeTake                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

User Function F050BUT()
	Local aButtons := {}
	
	If !Inclui
		AAdd(aButtons, { "S4WB011N" ,{||Visualiza() },"V. Bloqueio"} )	
	EndIf
Return (aButtons)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Visualiza()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Tela para escolha da rotina a ser executada		  		  ¦¦¦
¦¦¦			 ¦ 										  					  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras/TokeTake                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

Static Function Visualiza()  
	Local opDlg1	
	opDlg1:=MSDialog():New(000,000,200,430,"VISUALIZAÇÃO DA NFE E DADOS DE BLOQUEIO",,,,,CLR_BLACK,CLR_BLACK,,,.T.)			
    	DEFINE FONT oFONT6 NAME "arial black" SIZE 0,-14	   	
		@010,05 SAY "ROTINA PARA VISUALIZAR A NOTA DE ENTRADA QUE" PIXEL FONT oFONT6 OF opDlg1
		@020,05 SAY "DEU  ORIGEM AO TÍTULO EM QUESTÃO, EMISSÃO DE" PIXEL FONT oFONT6 OF opDlg1	
		@030,05 SAY ""+Space(15)+"RELATÓRIO E LOG DE BLOQUEIO" PIXEL FONT oFONT6 OF opDlg1				
		opButton00:=tButton():New(070,007,"Nota e Origem" ,opDlg1,{||NotOrigem()},60,20,,,,.T.)
   	   	opButton01:=tButton():New(070,080,"Rel. de Blq."   ,opDlg1,{||U_TTBLQR001()},60,20,,,,.T.)
		opButton02:=tButton():New(070,150,"Log de Blq."   ,opDlg1,{||VisBlq()},60,20,,,,.T.)
	opDlg1:activate(,,,.T.,,,)
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦NotOrigem()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotina para chamar a rotina padrão de visualizar da nota   ¦¦¦
¦¦¦			 ¦ de entrada							  					  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras/TokeTake                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 
									
Static Function NotOrigem()
	Local cArea := GetArea()					
	If Trim(SE2->E2_TIPO)=="NF"
		If SE2->E2_MSFIL == cFilant
			dbSelectArea("SF1")
			dbSetOrder(1)
			If dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
				A103NFiscal("SF1",Recno(),2,.F.,.F.) // Rotina padrão de visualizacao de NF
			EndIf
		Else
			Aviso("Informação","Para visualizar origem do título de outra filial, você precisa está logado na filial de origem",{"OK"},1,"Atenção")
		EndIf
	Else
		Aviso("Informação","Só é possível visualizar Origem de título do tipo NF",{"OK"},1,"Atenção")
	EndIf	
	RestArea(cArea)
Return
			              
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

Static Function VisBlq()    
   
	Private opTela 
	Private	nUsado 		:=0
	Private nC			:=0	
	Private opQtdenp
	Private cpQtdenp	:=0
	Private oGetDados  
	Private aHEADER 	:= {}
	Private ACOLS 		:= {}
	Private cpFilial	:=space(2)
	Private cpDoc		:=space(9)
	Private cpSerie		:=space(3)
	Private cpForCli	:=space(6)
	Private cpLoja		:=space(4)
	Private cpNome		:=space(40)
	Private clTipo
	Private dpDentre	:=Ctod(Space(8))
	Private cQuery
	
    If !Dadosd2()
    	Aviso("Informação","Não existe Log de bloqueio para esta Nota",{"OK"},1,"Atenção")
    	Return .F.
    EndIf
    
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
	
	Aadd(aCols,Array(nUsado+1))
	For nI := 1 To nUsado
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next
	aCols[1][nUsado+1] := .F.
	
	opTela:= MSDialog():New(000,000,550,1240,"DIVERGENCIA DE NOTA_ENTRADA/PRE_NOTA",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
			EnchoiceBar(opTela,{||close(opTela)},{||close(opTela)},.F.,)// Traz a tela no modo de visualização.

			@ 020, 02 To 45, 620 Pixel Of opTela
			
			@ 030, 50 Say "Nota"  	  Pixel Of opTela
			@ 030, 70 MsGet opDoc 	  Var cpDoc 	Picture "@!" Size 40,0.5 Pixel Of opTela
			opDoc:lReadOnly := .T.// deixa o campo no modo visual
		
			@ 030, 120 Say "Serie" 	  Pixel Of opTela  	
			@ 030, 140 MsGet opSerie  Var cpSerie 	Picture "@!" Size 20,0.5 Pixel Of opTela
			opSerie:lReadOnly := .T.// deixa o campo no modo visual
			
			@ 030, 170 Say "ForCli"   Pixel Of opTela
			@ 030, 190 MsGet opForCli Var cpForCli 	Picture "@!" Size 30,0.5 Pixel Of opTela
			opForCli:lReadOnly := .T.// deixa o campo no modo visual
			
			@ 030, 230 Say "Loja"  	  Pixel Of opTela
			@ 030, 250 MsGet OpLoja	  Var cpLoja 	Picture "@!" Size 20,0.5 Pixel Of opTela
			opLoja:lReadOnly := .T.// deixa o campo no modo visual
			                        	
			@ 030, 300 Say "Nome"  	  Pixel Of opTela
			@ 030, 320 MsGet OpNome   Var cpNome	Picture "@!" Size 120,0.5 Pixel Of opTela
			OpNome:lReadOnly := .T.// deixa o campo no modo visual
			
			@ 030, 450 Say "Filial"   Pixel Of opTela
			@ 030, 470 MsGet opFilial Var cpFilial 	Picture "@!" Size 10,0.5 Pixel Of opTela
			opFilial:lReadOnly := .T.// deixa o campo no modo visual
			
			@ 030, 500 Say "Entrega"  Pixel Of opTela
			@ 030, 530 MsGet OpDentre Var dpDentre 	Picture "99/99/99" Size 40,0.5 Pixel Of opTela
			OpDentre:lReadOnly := .T.// deixa o campo no modo visual
			
			@ 228, 60 Say "TOTAL DE DIVERGENCIA EM R$"  Pixel Of opTela
			@ 240, 10 MsGet opQtdenp Var cpQtdenp 	Picture "@E 999,999,999.999" Size 150,15 Pixel Of opTela
			opQtdenp:Disable()
			@ 235, 02  To 260, 202 Pixel Of opTela
				
			clChave		:= SE2->E2_XCHNFE
			cpQtdenp    := U_TTBLQ000(clChave)
			
			@ 228, 220 Say "H E L P"  Pixel Of opTela
			@ 237, 220 Say "O VALOR DESTACADO AO LADO É REFERENTE AS DIVERGENCIA ENCONTRADAS NO PREÇO UNITÁRIO E NA CONFERENCIA"  Pixel Of opTela
			@ 247, 220 Say "CEGA DA NOTA FISCAL, O MEMSO SERÁ ULTILIZADO CASO O TÍTULO SEJA LIBERADO COMO N. DÉBITO."  Pixel Of opTela
			@ 235, 212 To 260, 620 Pixel Of opTela
			
			Dadosd2() // função responsavel por carregar a getdados
			
		oGetDados := MsGetDados():New(55,01,220,622,2,,,,.F.,,,.T.,200,,,,,opTela) // GetDados que receberá os itens das notas Fiscais
		DIV->(DbCloseArea()) // fecha a tabela temporaria DIV			
	opTela:Activate(,,,.T.,,,)
	cpCondNf:=Space(03)
	cpCondPc:=Space(03)

Return Nil
	
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦DADOSD2()   ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.06.2011¦¦¦
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
	Local nlCont
	Local llFlag:=.T.
	
	DbSelectArea("SF1")

	cpFilial	:= xfilial("SF1")//SF1->F1_FILIAL da Filial corrente
	cpDoc		:= SE2->E2_NUM
	cpSerie		:= SE2->E2_PREFIXO
	cpForCli	:= SE2->E2_FORNECE
	cpLoja		:= SE2->E2_LOJA
	dpDentre	:= SE2->E2_EMIS1 
			               
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SA2")+cpForCli +cpLoja ) // posiciona  na tabela de fornecedore nos indices forcli e loja
		 cpNome	:= SA2->A2_NOME
	EndIF
	
	/*----------------------------------------------------------------------------------| 		    			           
	|   Query com os dados da SD1(itens das notas de saída) para carregar a Getdados    | 
	|----------------------------------------------------------------------------------*/	
	
	clbql:= " SELECT Z4_FILIAL 	"
	clBql+= " ,Z4_ITEM 			"
	clBql+= " ,Z4_CHAVENF 		"
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
	clBql+= " FROM " + RetSqlName("SZ4") + " AS SZ4 "
	clBql+= " WHERE Z4_CHAVENF='"+ SE2->E2_XCHNFE + "' " 
	clBql+= " AND SZ4.D_E_L_E_T_='' " 
	
	If Select("DIV") > 0
		dbSelectArea("DIV")
		DbCloseArea()
	EndIf
	    
	TcQuery clBql New Alias "DIV"
	TcSetField("DIV","Z4_DATA"	,"D",08,0)	
	 
	ACOLS:={}	// array que receberá os itens das notas fiscais para carregar a getdados
	nlCont:=0 
	DbSelectArea("DIV") 
	DbGotop()	// posiciona no primeiro registro da tabela                      
	While DIV->(!Eof())	 
		AADD(ACOLS,{ DIV->Z4_STATUS,DIV->Z4_ITEM,DIV->Z4_PRODUTO ,DIV->Z4_DESC ,DIV->Z4_OPER,DIV->Z4_VLRCORR, ;						
						DIV->Z4_VLRINF ,DIV->Z4_TOTDIV,DIV->Z4_PEDIDO,DIV->Z4_DATA ,DIV->Z4_HORA, DIV->Z4_USER  ,.F.})
						nC++				 
			nlCont:= nlCont + 1
		DIV->(DbSkip())
	EndDo
	If nlCont = 0
		llFlag := .F.
		nlCont:=0
	EndIf
Return llFlag                 