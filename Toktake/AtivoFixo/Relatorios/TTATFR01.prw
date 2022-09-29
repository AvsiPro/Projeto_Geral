#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATFR01  ºAutor  ³Alexandre Venancio  º Data ³  18/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o patrimonio esta em alguma OMM ou em qual     º±±
±±º          ³cliente se encontra.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTATFR01()

Local aArea	:=	GetArea()
Local cUsers := SuperGetMV("MV_XATF001",.T.,"")	// usuarios com permissao para liberacao
Local cUsersLoc := SuperGetMV("MV_XATF002",.T.,"")		// usuarios com permissao para troca de local fisico
Private oDlg1
Private cPatr	:=	space(6)
Private cCodCli := ""
Private cLoja := ""
    
SetPrvt("oGrp1","oSay1","oGet1","oGrp2","oGrp3","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oBtn5")
SetPrvt("oSay9","oSay10","oSay11","oGrp4","oBrw2","oGrp5","oTree","oGrp6","oBrw1","oBtn1","oBtn2","oSay12","oSay13","oSay14","oSay15","oSay22","oSay23")
Private oList1,oList2
Private aList1	:=	{}
Private aList2	:=	{}
Private nArvore	:=	0

//Prepare Environment Empresa "01" Filial "01" Tables "SN1"

AAdd(aList1,{'','','','','','','',''})
AAdd(aList2,{'','','','','',''})
 

oDlg1      := MSDialog():New( 091,232,613,1115,"Consulta Patrimônio",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 005,102,044,320,"Informe o Patrimônio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 024,110,{||"Patrimônio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
		oGet1      := TGet():New( 024,142,{|u|If(Pcount()>0,cPatr:=u,cPatr)},oGrp1,036,008,'',{ || Processa( { || Preacols() },"Carregando os dados, aguarde..")  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
		
		If Alltrim(UPPER(cusername)) $ cUsers
			oBtn1      := TButton():New( 020,330,"Liberar",oDlg1,{||U_TTATFC08(cPatr)},037,012,,,,.T.,,"",,,,.F. )
		EndIf
		
	oGrp2      := TGroup():New( 045,004,237,442,"Informações Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oGrp3      := TGroup():New( 055,012,162,184,"Informações Patrimônio",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oSay2      := TSay():New( 064,018,{||"Modelo"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			//oSay3      := TSay():New( 064,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,124,008)
			oSay3      := TSay():New( 024,185,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)	// modelo patrimonio
			oSay4      := TSay():New( 064,018,{||"Status"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSay5      := TSay():New( 064,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay6      := TSay():New( 074,018,{||"Cliente"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSay7      := TSay():New( 074,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			oSay20     := TSay():New( 084,018,{||"Cnpj"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSay21     := TSay():New( 084,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			
			oSay16     := TSay():New( 094,018,{||"Codigo"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSay17     := TSay():New( 094,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			oSay18     := TSay():New( 104,018,{||"Loja"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSay19     := TSay():New( 104,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			oSay8      := TSay():New( 114,018,{||"Endereço"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
			oSay9      := TSay():New( 114,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
            
            oSay22      := TSay():New( 124,018,{||"End. PA"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
			oSay23      := TSay():New( 124,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
            

			oSay10     := TSay():New( 134,018,{||"Local Fisico"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
			oSay11     := TSay():New( 134,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			oSay12     := TSay():New( 144,018,{||"Tipo Serviço"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
			oSay13     := TSay():New( 144,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
			oSay14     := TSay():New( 154,018,{||"Sist. Pagto"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
			oSay15     := TSay():New( 154,048,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)

		oGrp4      := TGroup():New( 055,192,150,440,"Movimentações do Patrimônio",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{020,192,084,391},,, oGrp4 ) 
			oList1 := TCBrowse():New(070,195,240,070,, {'Cliente','Loja','Nome','OMM','Data ins','Data rem','OMM Rem','PA'},{30,30,50,40,40,40,40,40},;
                            oGrp4,,,,{|| },{|| /*EDITCOL*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oList1:SetArray(aList1)
			oList1:bLine := {||{aList1[oList1:nAt,01],; 
		 						 aList1[oList1:nAt,02],;
		 						 aList1[oList1:nAt,03],;
		 						 aList1[oList1:nAt,04],;
		 						 aList1[oList1:nAt,05],;
		 						 aList1[oList1:nAt,06],;
		 						 aList1[oList1:nAt,07],;
 						 		 aList1[oList1:nAt,08] }}
		
		//oGrp5      := TGroup():New( 155,012,225,184,"OMM",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oGrp5      := TGroup():New( 165,012,225,184,"OMM",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		// Menu popup
		MENU oMenu POPUP                              
		MENUITEM "Visualizar OMM" ACTION ( IIF(oTree:Nivel()==1, U_TTTMKA30(cFilAnt, oTree:getCargo(),1),/**/)  )
		ENDMENU
		//oTree     := DbTree():New( 165,015,219,176,oGrp5,,,.T.,.F. )
		oTree     := DbTree():New( 175,015,219,176,oGrp5,,,.T.,.F. )
		oTree:SetScroll( 2, .T. )
		//oTree:bRClicked   := { |oObject,nX,nY| oMenu:Activate( nX, nY, oObject ) }
	
		oGrp6      := TGroup():New( 155,192,225,440,"Contratos",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{104,192,168,392},,, oGrp6 ) 
			oList2 := TCBrowse():New(162,195,245,060,, {'Contrato','Planilha','Valor Locacao'},{50,30,40},;
                            oGrp6,,,,{|| },{|| /*EDITCOL*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oList2:SetArray(aList2)
			oList2:bLine := {||{aList2[oList2:nAt,01],; 
		 						 aList2[oList2:nAt,02],;
		 						 aList2[oList2:nAt,03]}}
	    
    	If Alltrim(upper(cUsername)) $ upper(cUsersLoc) //"FBORGES/JDEUS/JNASCIMENTO/VFERREIRA/LBSANTOS/ALIMA/FESILVA"
			oBtP      := TButton():New( 238,30,"Alterar PA",oDlg1,{ || TelaPA()  },037,012,,,,.T.,,"",,,,.F. )	    
		EndIf    
	
	    If AllTrim(UPPER(cUserName)) $ UPPER(cUsersLoc)
			oBtn1      := TButton():New( 238,126,"Alterar local",oDlg1,{ || TelaLocal()  },037,012,,,,.T.,,"",,,,.F. )
		EndIf                                                                                                             
		                                                                                                           
		oBtn5      := TButton():New( 238,076,"Mapa Maquina",oDlg1,{ || U_TTCOMC17('Patrimonio '+cPatr,cPatr,.F.,.F.,.F.)  },037,012,,,,.T.,,"",,,,.F. )
		
		If Alltrim(upper(cUsername)) $ upper(cUsersLoc)	//"FBORGES/JDEUS/JNASCIMENTO/VFERREIRA/LBSANTOS"
			oBtn4      := TButton():New( 238,200,"Acerto SisPG",oDlg1,{||U_TTFINC28(cPatr)},037,012,,,,.T.,,"",,,,.F. )
		EndIf
		
		oBtn2      := TButton():New( 238,250,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
oDlg1:Activate(,,,.T.)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATFR01  ºAutor  ³Microsiga           º Data ³  10/25/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Preacols()

Local cQuery   
Local aStatus	:=	{'Disponivel','Em transito','Em cliente','Manutencao','Empenhado','Em remocao','Em Transf','Baixado',"Extraviada"}
Local aServico	:=	{'Locacao','Servico de Cafe','LA','SA','Kit-Lanche','Serv. Cafe + Locacao','LA + Locacao','SA + Locacao'}
Local cOMM		:=	''   
Local nVlr		:=	0
Local lNova		:= .F.
Local lCriou	:= .f.
                 
If Empty(cPatr)
	Return
EndIf

CursorWait()

ProcRegua(4)
IncProc("Informações cadastrais..")                   

oSay3:settext("")
oSay5:settext("")
oSay7:settext("")
oSay9:settext("")
oSay11:settext("")
oSay13:settext("")
oSay15:settext("")
oSay17:settext("")
oSay19:settext("") 
oSay21:Settext("")
oSay23:Settext("")

aList1	:=	{}    
aList2	:=	{}                       


If ValType(oTree) == "O"
	If !oTree:isEmpty()
		oTree:Reset()
	EndIf
EndIf

cQuery := "SELECT N1_XCLIENT,N1_XLOJA,N1_XLOCINS,N1_XSTATTT,A1_NREDUZ,"
cQuery += "N1_DESCRIC,N1_XLOCINS,A1_END,A1_BAIRRO,A1_MUN,A1_EST,N1_XTPSERV,N1_XSISPG, A1_CGC,NL_DESCRIC,N1_BAIXA,N1_CHAPA,ZZ1_END "
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD+A1_LOJA=N1_XCLIENT+N1_XLOJA AND A1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SNL")+" NL ON NL_FILIAL='"+xFilial("SNL")+"' AND NL_CODIGO=N1_LOCAL AND NL.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_FILIAL='"+xFilial("SNL")+"' AND ZZ1_COD=N1_XPA AND Z1.D_E_L_E_T_=''"
cQuery += " WHERE N1_CHAPA = '"+cPatr+"' AND N1.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
If !EOF()
    oSay3:settext(TRB->N1_DESCRIC)
    oSay5:settext(If(!Empty(TRB->N1_BAIXA),'Baixado',aStatus[val(TRB->N1_XSTATTT)]))
    oSay7:settext(Alltrim(TRB->A1_NREDUZ))
    oSay9:settext(If(!Empty(TRB->NL_DESCRIC),Alltrim(TRB->NL_DESCRIC),Alltrim(TRB->A1_END)+" "+Alltrim(TRB->A1_BAIRRO)+" "+Alltrim(TRB->A1_MUN)+" "+TRB->A1_EST))
    oSay11:settext(Alltrim(TRB->N1_XLOCINS))
    oSay17:SetText(TRB->N1_XCLIENT)
    oSay19:SetText(TRB->N1_XLOJA) 
    oSay21:SetText(AllTrim(TRB->A1_CGC))     
    oSay23:settext(Alltrim(TRB->ZZ1_END))
    
    cCodCli := TRB->N1_XCLIENT
    cLoja := TRB->N1_XLOJA
    
    If !empty(TRB->N1_XTPSERV)
	    oSay13:settext(aServico[val(TRB->N1_XTPSERV)])
	EndIf
    oSay15:settext(AllTrim(TRB->N1_XSISPG))
    
EndIf


IncProc("OMM pendente..")                   	    
// OMM pendente
cQuery := "SELECT UD_CODIGO,UD_VENDA,UD_STATUS,UC_CHAVE,UD_XTAREF,Z9_DESC,Z9_TAREFA,UD_XTARSEQ,Z9_SEQ, UD_FILIAL, A1_NREDUZ FROM " +RetSqlName("SUD") +" UD "
cQuery += " INNER JOIN " +RetSqlName("SUC") +" UC ON UC_FILIAL=UD_FILIAL AND UC_CODIGO=UD_CODIGO AND UC.D_E_L_E_T_=' ' " 
cQuery += " LEFT JOIN "+RetSqlName("SA1") +" A1 ON A1_COD+A1_LOJA=UC_CHAVE AND A1.D_E_L_E_T_='' "
cQuery += "LEFT JOIN " +RetSqlName("SZ9") +" Z9 ON Z9_COD=UD_XTAREF AND Z9_SEQ=UD_XTARSEQ AND Z9.D_E_L_E_T_=' ' "
cQuery += "WHERE UD_XNPATRI = '"+cPatr+"' "
cQuery += "AND UD_STATUS='1' AND UD_ASSUNTO = '000007' AND UD.D_E_L_E_T_ = ''  AND UC_CODCANC = '' AND UC_STATUS <> '3'  "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFR01_OMM.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

oTree:BeginUpdate() 
While !EOF()
	lNova := .F.                              
	cNumChapa := cPatr
	cNumTmk := AllTrim(TRB->UD_CODIGO)
	cChave  := AllTrim(TRB->UC_CHAVE)
	cTarefa := AllTrim(TRB->Z9_TAREFA)
	cDescTar := AllTrim(TRB->Z9_DESC) 
	cSeq := AllTrim(TRB->UD_XTARSEQ)
	cPedido := AllTrim(TRB->UD_VENDA)
    	
	If !oTree:TreeSeek( cNumTmk +cNumChapa )
    	oTree:AddTreeItem( PADR( TRB->UD_FILIAL+" - "+cNumTmk, 100 ), "BR_VERMELHO",, cNumTmk +cNumChapa )
    	lNova := .T.
    	lCriou := .T.
 	EndIf
    	 
	If oTree:TreeSeek( cNumTmk +cNumChapa )
	   	If !oTree:TreeSeek( cNumTmk +cChave +cNumChapa )
			oTree:AddItem( PADR( Alltrim(TRB->A1_NREDUZ), 100 ) ,cNumTmk +cChave +cNumChapa, "CLIENTE",,,,2)		
		EndIf
	
		If !oTree:TreeSeek( cNumTmk +ALLTRIM(TRB->UD_XTAREF) +cNumChapa )
			oTree:AddItem( PADR( cDescTar, 100 ) ,cNumTmk +ALLTRIM(TRB->UD_XTAREF) +cNumChapa, "HISTORIC",,,,2)				
		EndIf
		                                                                                                                		
		If !oTree:TreeSeek( cNumTmk +cSeq +cNumChapa )
			oTree:AddItem( PADR( cSeq+" - "+cTarefa, 100 ) ,cNumTmk +cSeq +cNumChapa, "CLOCK01",,,,2)					
		EndIf
		
		If !Empty(cPedido)
			If !oTree:TreeSeek( cPedido +cNumChapa )
				oTree:AddItem( PADR( 'PV - '+cPedido, 100 ), cPedido +cNumChapa, "BUDGET",,,,2)				
			EndIf
			//oTree1:AddTree(PadR('PV - '+TRB->UD_VENDA,100 ), .F., , , , ,  )
		EndIf
		
		If lNova
			oTree:PTCOLLAPSE()
		EndIf
	EndIf	
	
	dbSkip()
End 
If lCriou
	oTree:EndTree()
EndIf
oTree:EndUpdate()



IncProc("Movimentações..") 
// Movimentacoes do patrimonio
cQuery := "SELECT ZD_CLIENTE,ZD_LOJA,ZD_NOME,ZD_NROOMM,ZD_DATAINS,ZD_DATAREM,ZD_NROOMMR, ZD_CODPA, R_E_C_N_O_ ZDREC FROM "+RetSQLName("SZD")
cQuery += " WHERE ZD_PATRIMO='"+cPatr+"' AND D_E_L_E_T_='' ORDER BY ZD_DATAINS DESC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
 
While !EOF()
	Aadd(aList1,{TRB->ZD_CLIENTE,TRB->ZD_LOJA,Alltrim(TRB->ZD_NOME),TRB->ZD_NROOMM,;
				stod(TRB->ZD_DATAINS),stod(TRB->ZD_DATAREM),TRB->ZD_NROOMMR, TRB->ZD_CODPA, TRB->ZDREC })
	Dbskip()
Enddo
              
If len(aList1) < 1
	Aadd(aList1,{'','','','','','','',''})
EndIf

oList1:SetArray(aList1)
oList1:bLine := {||{aList1[oList1:nAt,01],; 
 						 aList1[oList1:nAt,02],;
 						 aList1[oList1:nAt,03],;
 						 aList1[oList1:nAt,04],;
 						 aList1[oList1:nAt,05],;
 						 aList1[oList1:nAt,06],;
 						 aList1[oList1:nAt,07],;
 						 aList1[oList1:nAt,08] }}                      
 						 
                   
IncProc("Contratos..") 
// Contrato locacao 						 
cQuery := "SELECT ZQ_PATRIM,ZQ_PLAN,ZQ_CONTRA,ZQ_VALOR"
cQuery += " FROM "+RetSQLName("SZQ")
cQuery += " WHERE  ZQ_PATRIM = '"+Alltrim(cPatr)+"' AND D_E_L_E_T_ = '' AND ZQ_DATAREM = '' "
cQuery += " ORDER BY ZQ_DATAINS DESC "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
 
While !EOF()		
	Aadd(aList2,{TRB->ZQ_CONTRA,TRB->ZQ_PLAN,round(ZQ_VALOR,2)})
	Dbskip()
EndDo 						 

If len(aList2) < 1
	Aadd(aList2,{'','','','','',''})
EndIf
	
oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],; 
 						 aList2[oList2:nAt,02],;
 						 aList2[oList2:nAt,03]}}

oList1:refresh()
oList2:refresh()
oTree:refresh()
oDlg1:refresh()

CursorArrow()

Return


      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TelaLocal  ºAutor  ³Jackson E. de Deus º Data ³  02/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para alteracao de local fisico.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TelaLocal()

Local aArea := GetArea()
Local nRecSN1 := 0
Local nOpcao := 0
Local oGetLocal
Private cLocal := Space(TamSx3("Z8_LOCFIS1")[1])

CriaVar("Z8_CLIENTE",.T.)
CriaVar("Z8_LOJA",.T.)

M->Z8_CLIENTE := cCodcli
M->Z8_LOJA := cLoja

oDlg2	:= MSDialog():New( 230,300,408,620,"Alteração de local físico",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay2	:= TSay():New( 014,015,{||"Escolha o local físico do patrimônio:"},oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

	@ 034,015 MSGET oGetLocal VAR cLocal PICTURE "@!" F3 "SZ8SN1" OF oDlg2 SIZE 130,008 VALID VldLocal() PIXEL HASBUTTON 

	oSBtn1	:= TButton():New( 064,044,"Confirmar",oDlg2,{ || oDlg2:End(nOpcao:=1) },037,012,,,,.T.,,"",,,,.F. )
	oSBtn2	:= TButton():New( 064,088,"Sair"	  ,oDlg2,{ || oDlg2:End() },037,012,,,,.T.,,"",,,,.F. )
oDlg2:Activate(,,,.T.)

If nOpcao == 1
	If !Empty(cLocal)                      
		nRecSN1 := U_TTTMKA19(cPatr)      
		dbSelectArea("SN1")
		If nRecSN1 > 0
			dbGoto(nRecSN1)
			RecLock("SN1",.F.)
			SN1->N1_XLOCINS := cLocal
	
			MsgInfo("Local físico alterado com sucesso!")
			oSay11:SetText(cLocal)
			MsUnLock()
		EndIf
	EndIf
EndIf	

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldLocal  ºAutor  ³Jackson E. de Deus  º Data ³  02/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o local fisico.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldLocal()

Local lRet := .T.
Local cAux := &('cLocal')

If !Empty(cLocal)
	dbSelectArea("SZ8")
	dbSetOrder(2)
	If !dbSeek( xFilial("SZ8") +M->Z8_CLIENTE +M->Z8_LOJA +AvKey(cLocal,"Z8_LOCFIS1") ) 
		Aviso( "","O local informado não está cadastrado para esse cliente/loja." +CRLF +"Solicite a inclusão do local ou escolha outro disponível." ,{"Ok"} )
		lRet := .F.
		cLocal := Space(TamSx3("Z8_LOCFIS1")[1])
	EndIf
EndIf

Return lRet

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATFR01  ºAutor  ³Microsiga           º Data ³  08/18/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TelaPA()

Local nRecSN1 := 0
Local nOpcao := 0
Local oGetLocal 
Local nI
Private cPA := Space(6)


oDlg2	:= MSDialog():New( 230,300,408,620,"Alteração de PA",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay2	:= TSay():New( 014,015,{||"Escolha a PA:"},oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

	@ 034,015 MSGET oGetLocal VAR cPA PICTURE "@!" F3 "ZZ1" OF oDlg2 SIZE 50,008 VALID VldPA() PIXEL HASBUTTON 

	oSBtn1	:= TButton():New( 064,044,"Confirmar",oDlg2,{ || oDlg2:End(nOpcao:=1) },037,012,,,,.T.,,"",,,,.F. )
	oSBtn2	:= TButton():New( 064,088,"Sair"	  ,oDlg2,{ || oDlg2:End() },037,012,,,,.T.,,"",,,,.F. )
oDlg2:Activate(,,,.T.)


If !Empty(cPA)                      
	nRecSN1 := U_TTTMKA19(cPatr)      
	dbSelectArea("SN1")
	If nRecSN1 > 0
		dbGoto(nRecSN1)
		RecLock("SN1",.F.)
		SN1->N1_XPA:= cPA
		MsUnLock()
		
		For nI := 1 To Len(aList1)
			If AllTrim(aList1[nI][1]) == AllTrim(SN1->N1_XCLIENT) .And. AllTrim(aList1[nI][2]) == AllTrim(SN1->N1_XLOJA) .And. Empty(aList1[nI][6])
				dbSelectArea("SZD")
				dbGoTo(aList1[nI][9])
				If AllTrim(SZD->ZD_IDSTATU) == "1" .And. ( Empty(SZD->ZD_CODPA) .Or. AllTrim(SZD->ZD_CODPA) <> cPA )
					RecLock("SZD",.F.)
					SZD->ZD_CODPA := cPA
					MsUnLock()                        
				EndIf
			EndIf	        
		Next nI

				        		
		MsgInfo("PA alterada com sucesso!")
		Processa( { || Preacols() },"Carregando os dados, aguarde..") 
	EndIf
EndIf
      
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATFR01  ºAutor  ³Microsiga           º Data ³  08/18/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldPA()

Local lRet := .T.           

dbSelectArea("ZZ1")
dbSetOrder(1)
If dbSeek( xFilial("ZZ1") +AvKey(cPA,"ZZ1_COD") )
	cCodCli := SubStr(ZZ1->ZZ1_ITCONT,1,6)
	cLoja := SubStr(ZZ1->ZZ1_ITCONT,7,4)
	nRecSN1 := U_TTTMKA19(cPatr)      
	dbSelectArea("SN1")
	If nRecSN1 > 0
		dbGoto(nRecSN1)
		If AllTrim(SN1->N1_XCLIENT) <> AllTrim(cCodCli)
			Aviso( "","A PA informada não está vinculada ao cliente do patrimônio." ;
					 +CRLF +"Cliente PA: " +cCodCli +CRLF ;
					 +"Cliente Patrimônio: " +AllTrim(SN1->N1_XCLIENT) ,{"Ok"} )
					 
			lRet := .F.
		EndIf
	EndIf			
EndIf


Return lRet