#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"
#Include "font.ch"
#Include "colors.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTEST10()    ¦ Autor ¦ Fabio Sales		¦ Data ¦27.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Procedimento necessário para caso tenha que rodar o fecha- ¦¦¦
¦¦¦			 ¦ de estoque novamente										  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTEST10()

  	Private opButton01,opButton02,opButton03,opButton04,opButton05,opButton06,opButton07,opButton08:= Nil // Objetos dos Botões
	Private oMultiGe1,opGetDel,opFilial,oplEstNeg,OpDatini,oDlg := Nil // Objetos dos Gets e da tela
	Private cpLblini,cpLblfim,cpGetDel,cpFilial,plEstNeg:= ""  // variavéis da tela		
	Private DpDatini := "01/" + substr(verdata(),5,2)+ "/" + substr(verdata(),1,4)
	Private DpDatfim := substr(verdata(),7,2) +"/"+ substr(verdata(),5,2) +"/"+ substr(verdata(),1,4)
	Private cMultiGe1:= "Ao clicar em um dos botões ao lado será exibido o que cada um deles irá fazer"	
	Private dlUmes	:= GetMv("MV_ULMES")
	 			 		
	Define Font oFont2 Name "Courier New" Size 0,-15
	Define Font oFont4 Name "Courier New" Size 0,-15
 	Define Font oFont6 Name "arial black" Size 0,-25
 	Define Font oFont8 Name "arial black" Size 0,-20
 	 			
	oDlg:= MSDialog():New(000,000,500,740,"",,,,,CLR_BLACK,CLR_HGRAY,,,.T.) 	
	oPanel:= TPanel():New(02,10,"Procedimento para Refazer o fechamento",oDlg,oFont6,.T.,,CLR_BLACK,CLR_WHITE,350,020)
	
   
    /*-------------------------------------\
    | criação dos botões de funcionalidade |
    \-------------------------------------*/
    
  	opButton01 :=tButton():New(30,10,"&Acerto do custo de importação" ,oDlg,{||Acerto("1")},150,017,,oFONT4,,.T.)
  	opButton02 :=tButton():New(50,10,"Deletar a contabilização"   	  ,oDlg,{||Acerto("2")},150,017,,oFONT4,,.T.)
  	opButton03 :=tButton():New(70,10,"Deletar o fechamento"			  ,oDlg,{||Acerto("3")},150,017,,oFONT4,,.T.)
  	opButton04 :=tButton():New(90,10,"Estoque negativo"				  ,oDlg,{||Acerto("4")},150,017,,oFONT4,,.T.)
  	
  	/*-----------------------------------------------------------------------------\
    | Ojetos que serão exibidos ao clicar no botão "&Acerto do custo de importação"|
    \-----------------------------------------------------------------------------*/
  	  	
	@30,170 Get oMultiGe1 Var cMultiGe1 MultiLine Size 190,215 COLORS 0, 16777215  HSCROLL NO VSCROLL Pixel Font oFont2  Of oDlg
	oMultiGe1:lReadOnly := .T.	
	@110, 10 To 245, 162 LABEL "Parâmetros" Pixel Of oDlg
	
	@120,090 MsGet OpDatini Var DpDatini Picture "@!" Size 065,10 Pixel  Font oFont4 Of oDlg
	@140,090 MsGet OpDatfim Var DpDatfim Picture "@!" Size 065,10 Pixel  Font oFont4 Of oDlg
	@120,020 MsGet opGetDel Var cpGetDel Picture "@!" Size 135,10 Pixel  Font oFont4 Of oDlg
	@140,020 MsGet opFilial Var cpFilial Picture "@!" Size 135,10 Pixel  Font oFont4 Of oDlg
	   
	plEstNeg:="Deixar estoque negatuvo ? "+ IIf(GETMV("MV_ESTNEG")=="N","Nâo","Sim")
	
	opButton05 :=tButton():New(230,30,"Ok"		,oDlg,{||Ajuste()},50,10,,oFONT4,,.T.)
	opButton06 :=tButton():New(230,90,"Voltar"	,oDlg,{||Volta()},50,10,,oFONT4,,.T.)
	opButton07 :=tButton():New(180,35,"Sim"	,oDlg,{||ttestneg("S")},50,10,,oFONT4,,.T.)
	opButton08 :=tButton():New(180,85,"Não"	,oDlg,{||ttestneg("N")},50,10,,oFONT4,,.T.)
		   	
	@140,020 MsGet oplEstNeg Var plEstNeg	Picture "@!" Size 135,10 Pixel  Font oFont4 Of oDlg
		
	OpDatini:Disable();OpDatfim:Disable();opGetDel:Disable();opFilial:Disable();oplEstNeg:Disable()
	OpDatini:Hide();OpDatfim:Hide();opButton05:Hide();opButton06:Hide();opButton07:Hide()
	opButton08:Hide();opGetDel:Hide();opFilial:Hide();oplEstNeg:Hide()
  		  
	oDlg:Activate(,,,.T.,,,)
Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Acerto()    	¦ Autor ¦ Fabio Sales		¦ Data ¦27.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ clOpcao--> Define quais Objetos terão suas propriedade mo- ¦¦¦
¦¦¦			 ¦ dificadas.								  				  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                                        	

Static Function Acerto(clOpcao)
	Local clQuery:=""
	
	Do Case
		Case clOpcao=="1"
			opButton01:lReadonly:=.T.;opButton02:Disable();opButton03:Disable();opButton04:Disable()
			cpLblini := "Dt. Inicial";cpLblfim := "Dt. Final"
			OpDatini:Show();OpDatfim:Show();opButton05:Show();opButton05:Enable();opButton06:Show()
			cMultiGe1:= "Este procedimento irá ajustar o custo de importação de acordo com a data base do sistema. "
			cMultiGe1+= "deve se ajustar a data base do sistema para o utimo dia do mês que precisa ser ajustado"
		case clOpcao=="2"
			If  dDatabase >= GetMv("MV_ULMES")
				opButton02:lReadonly:=.T.;opButton01:Disable();opButton03:Disable();opButton04:Disable()
				cMultiGe1:= "Este procedimento irá apagar a contabilização do custo, gerado pelo o fechamento, de acordo com a data "
				cMultiGe1+= "base do sistema. Deve se ajustar a data base do sistema para o utimo dia do mês, e escolher a filial que precisa ser ajustado"					
				cpGetDel:= "Data : " + substr(verdata(),7,2) +"/"+ substr(verdata(),5,2) +"/"+ substr(verdata(),1,4)
				cpFilial:="Filial : "+ cFilant
				opButton05:Show();opButton05:Enable();opButton05:Show();opButton06:Show();opGetDel:Show();opFilial:Show()
			Else
				Alert("A data base do sistema não pode ser maior que a data do Ultimo fechamento " + Dtoc(GetMv("MV_ULMES")))
			EndIf
		case clOpcao=="3"
			If  dDatabase >= GetMv("MV_ULMES")
				opButton03:lReadonly:=.T.;opButton01:Disable();opButton02:Disable();opButton04:Disable()
				cMultiGe1:= "Este procedimento irá apagar os registros de fechamento de acordo com a data base do sistema e a filial de origem. "
				cMultiGe1+= " Deve se ajustar a data base do sistema para o utimo dia do mês e escolher a filial  que precisa ser ajustado."
				cpGetDel:= "Data : " + substr(verdata(),7,2) +"/"+ substr(verdata(),5,2) +"/"+ substr(verdata(),1,4)
				cpFilial:="Filial : "+ cFilant
				opButton05:Show();opButton05:Enable();opButton06:Show();opGetDel:Show();opFilial:Show()
			Else
				Alert("A data base do sistema não pode ser maior que a data do Ultimo fechamento " + Dtoc(GetMv("MV_ULMES")))
			EndIf
		Case clOpcao=="4"
			opButton04:lReadonly:=.T.;opButton01:Disable();opButton02:Disable();opButton03:Disable()
			cMultiGe1:= "Este procedimento irá permitir que o estoque fique negativo para que o usuário possa rodar o ajuste "
			cMultiGe1+= "de invetário dos saldos negativos. Após rodar o ajuste será necessário Bloquear."
			opButton05:Show();opButton05:Disable();	opButton06:Show();opButton07:Show();opButton08:Show();oplEstNeg:Show()
	EndCase	
	@123,020 SAY  cpLblini PIXEL Font oFont2 OF oDlg
	@143,020 SAY cpLblfim  PIXEL Font oFont2 OF oDlg
	
	If GETMV("MV_ESTNEG")=="N"
		opButton07:Enable();opButton08:Disable()
	Else
		opButton07:Disable();opButton08:Enable()
	EndIf 	
Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Volta()    	¦ Autor ¦ Fabio Sales		¦ Data ¦29.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ clOpcao--> Retorna para a tela inicial					  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

Static Function Volta()
	cpLblini := ""
	cpLblfim := ""
	Do Case
		 Case opButton01:lReadonly==.T.
			opButton01:lReadonly:=.F.;opButton02:Enable();opButton03:Enable();opButton04:Enable()
		Case opButton02:lReadonly==.T.	
			opButton02:lReadonly:=.F.;opButton01:Enable();opButton03:Enable();opButton04:Enable()
		Case opButton03:lReadonly==.T.	
			opButton03:lReadonly:=.F.;opButton02:Enable();opButton01:Enable();opButton04:Enable()	
		Case opButton04:lReadonly==.T.		
			opButton04:lReadonly:=.F.;opButton02:Enable();opButton03:Enable();opButton01:Enable()		
	End Case 
	@123,020 SAY cpLblini PIXEL Font oFont2 OF oDlg
	@143,020 SAY cpLblfim PIXEL Font oFont2 OF oDlg	
	OpDatini:Hide();OpDatfim:Hide();opButton05:Hide();opButton06:Hide();opButton07:Hide()
	opButton08:Hide();opGetDel:Hide();opFilial:Hide();oplEstNeg:Hide()	
	cMultiGe1:= "Ao clicar em um dos botões ao lado será exibido o que cada um deles irá fazer"
return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦Ajuste()    	¦ Autor ¦ Fabio Sales		¦ Data ¦29.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ clOpcao--> Executa o ajuste no custo de importação		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

Static Function Ajuste()  
    Local clQuery 
    Local clVer
	Do Case
		Case opButton01:lReadonly==.T.
			Begin Transaction
				clQuery:= " UPDATE "+RetSqlName("SD1")+" SET D1_CUSTO=((F1_VALMERC+F1_VALIPI+F1_XSISCOM)-F1_XFRTIMP-F1_SEGURO)*(((D1_TOTAL*100)/F1_VALMERC))/100 "
				clQuery+= " FROM "+RetSqlName("SF1")+" "
				clQuery+= " INNER JOIN "+RetSqlName("SD1")+" "
				clQuery+= " ON D1_FILIAL=F1_FILIAL "
				clQuery+= " AND D1_DOC=F1_DOC "
				clQuery+= " AND D1_SERIE=F1_SERIE "
				clQuery+= " AND D1_FORNECE=F1_FORNECE "
				clQuery+= " AND D1_LOJA=F1_LOJA "
				clQuery+= " AND D1_DTDIGIT=F1_DTDIGIT "
				clQuery+= " AND   "+RetSqlName("SD1")+".D_E_L_E_T_='' "
				clQuery+= " WHERE "+RetSqlName("SD1")+".D_E_L_E_T_='' "
				clQuery+= " AND F1_DTDIGIT BETWEEN '"+Substr(verdata(),1,6)+"01"+"'  AND '"+verdata()+"' "
				clQuery+= " AND F1_EST='EX'	AND F1_FILIAL='"+xFilial("SF1")+"' "
				clsql:=	TcSqlExec(clQuery)
				Alert("Custo acertado.")
			End Transaction
		Case opButton02:lReadonly==.T. 		
		    clVer:= " SELECT COUNT(*) AS TOTAL FROM "+RetSqlName("CT2")+"  WHERE D_E_L_E_T_='' AND CT2_FILORI='"+cFilant+"' "
		    clVer+= " 		AND CT2_DATA='"+VerData()+"' AND CT2_LOTE='008840'  "
		    
		    If Select("VERIF1") > 0
				dbSelectArea("VERIF1")
				DbCloseArea()
			EndIf
	
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clVer),"VERIF1",.F.,.T.)			
				
			dbSelectArea("VERIF1")
			dbGotop()
			If VERIF1->TOTAL > 0		    		    		
				Begin Transaction
					clQuery:= " UPDATE "+RetSqlName("CT2")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ "
					clQuery+= " WHERE D_E_L_E_T_='' "
					clQuery+= " AND CT2_DATA='"+VerData()+"' "
					clQuery+= " AND CT2_LOTE='008840' "
					clQuery+= " AND CT2_FILORI='"+cfilant+"' "
					clsql:=	TcSqlExec(clQuery)		
				End Transaction
				Alert("Registro deletado.")
			Else
				Alert("Esta rotina já foi executada ou não existe registro a deletar para este período")
			EndIf
		Case opButton03:lReadonly==.T.
		
		    clVer:= " SELECT COUNT(*) AS TOTAL FROM "+RetSqlName("SB9")+"  WHERE D_E_L_E_T_='' AND B9_FILIAL='"+cFilant+"' AND B9_DATA='"+VerData()+"' "
		    
		    If Select("VERIF2") > 0
				dbSelectArea("VERIF2")
				DbCloseArea()
			EndIf
					
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clVer),"VERIF2",.F.,.T.)			
				
			dbSelectArea("VERIF2")
			dbGotop()
			If VERIF2->TOTAL > 0		    		    		
				Begin Transaction				
					clQuery:= " UPDATE "+RetSqlName("SB9")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ "
					clQuery+= " WHERE D_E_L_E_T_='' "
					clQuery+= " AND B9_FILIAL='"+cFilant+"' "
					clQuery+= " AND B9_DATA='"+VerData()+"' "
					clsql:=	TcSqlExec(clQuery)		
				End Transaction			
				dlUmes:=dlUmes -Val(SubStr(Dtos(dlUmes),7,2))			
				PutMv("MV_ULMES",dlUmes)
				Alert("Registro deletado.")
			Else
				Alert("esta rotina já foi executada ou não existe registro a deletar para este período")
			EndIf	
	EndCase        
Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦VerData()    	¦ Autor ¦ Fabio Sales		¦ Data ¦29.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ clOpcao--> Trazer o utimo dia de cada mês				  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 
Static Function VerData() 
	Local nlVerAno
	Local nlMes
	DlFimMes:=""
	nlVerAno:=Val(Left(dtos(dDatabase),4)) % 4 // verifica se o ano é bisexto
	nlMes:=Substr(Dtos(dDatabase),5,2)	
	Do case
		Case nlMes=="01" 
			DlFimMes=Left(dtos(dDatabase),4) +"0131"
		Case nlMes=="02"
			Iif (nlVerAno==0, DlFimMes:=Left(dtos(dDatabase),4) + "0229", DlFimMes:=Left(dtos(dDatabase),4) + "0228")
		Case nlMes=="03"
			DlFimMes=Left(dtos(dDatabase),4) +"0331"		
		Case nlMes=="04"
			DlFimMes=Left(dtos(dDatabase),4) +"0430"
		Case nlMes=="05"
			DlFimMes=Left(dtos(dDatabase),4) +"0531"
		Case nlMes=="06" 
			DlFimMes=Left(dtos(dDatabase),4) +"0630"
		Case nlMes=="07" 
			DlFimMes=Left(dtos(dDatabase),4) +"0731"
		Case nlMes=="08" 
			DlFimMes=Left(dtos(dDatabase),4) +"0831"
		Case nlMes=="09" 
			DlFimMes=Left(dtos(dDatabase),4) +"0930"
		Case nlMes=="10" 
			DlFimMes=Left(dtos(dDatabase),4) +"1031"
		Case nlMes=="11" 
			DlFimMes=Left(dtos(dDatabase),4) +"1130"
		Case nlMes=="12" 
			DlFimMes=Left(dtos(dDatabase),4) +"1231"
	EndCase	
Return DlFimMes 

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ttestneg()   	¦ Autor ¦ Fabio Sales		¦ Data ¦29.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ estn-->Verifica qual o conteúdo Do parâmetro mv_estneg 	  ¦¦¦
¦¦¦			 ¦ e muda de acordo com a opção escolhida.					  ¦¦¦		
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque_Custos/TokeTake                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 
Static Function ttestneg(estn)	
	If estn=="S"
		opButton07:Disable();opButton08:Enable()
		PutMV("MV_ESTNEG","S")
	Else
		opButton08:Disable();opButton07:Enable()
		PutMV("MV_ESTNEG","N")
	EndIf
	plEstNeg:="Deixar estoque negatuvo ? "+ IIf(GETMV("MV_ESTNEG")=="N","Nâo","Sim")	
Return