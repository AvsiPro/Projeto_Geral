
/*-------------------------------------------------------------------------//
|     Bibliotecas de funções necessárias para o funcionamento da função    //   
|------------------------------------------------------------------------- */  
 #INCLUDE "PROTHEUS.CH"                                                    //
 #INCLUDE "RWMAKE.CH"                                                      //
 #INCLUDE "TOPCONN.CH"                                                     //
/*-------------------------------------------------------------------------*/

/*/
____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦TTBLQ001()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função que irá irá desbloquear o título no financeiro	  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ Fil--> Filial do titulo							  		  ¦¦¦
¦¦¦			 ¦ Tit--> Número do titulo no financeiro					  ¦¦¦
¦¦¦			 ¦ Pref--> Prefixo do título no financeiro					  ¦¦¦           
¦¦¦			 ¦ Forn--> Fornecedor do título								  ¦¦¦
¦¦¦			 ¦ Loja--> Loja do fornecedor do título						  ¦¦¦
¦¦¦			 ¦ Tipo--> Tipo da nota										  ¦¦¦
¦¦¦			 ¦ TipLib--> Tipo de liberação do titulo					  ¦¦¦           
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokTake / Compras                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTBLQ001(Fil,Tit,Pref,Forn,Loja,Tipo,Tiplib,MotLib,Tela1,Tela2,vlrTit)

Local Natur
Private aDiv := {}
    
If cEmpAnt == "01"

	DbSelectArea("SE2") 	                                                         
    DbSetOrder(6)
    DbSeek(XFILIAL("SE2") + Forn + Loja + Pref + Tit)
        	
	While !Eof() .And. (E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM==Forn + Loja + Pref + Tit)
    	If 	RecLock("SE2",.F.)
	    		SE2->E2_DATALIB := dDataBase	// data da liberacao do titulo
				SE2->E2_USUALIB := cUsername	// usuario que fez a liberação do título
				SE2->E2_XMOTLIB := MotLib  		// Campo que irá receber o motivo da Liberação mdo título 
				SE2->E2_XTIPLIB := TipLib     	// Tipo de Liberação
				SE2->E2_XCHNFE  := Fil + Tit + Pref + Forn + Loja + Tipo
			MsUnLock()
		EndIf
		SE2->(DbSkip()) //pula para o proximo registro
	EndDo
	//If TipLib=="N"
	//	DbSelectArea("SA2") 
	//	DbSetOrder(1)
	//	If DbSeek(XFilial("SA2") + Forn + Loja)
	//		Natur := SA2->A2_NATUREZ
	//	EndIf	
	//	U_TTBLQ002(Fil,Tit,Pref,Natur,Forn,Loja,vlrTit)				
	//EndIf			
	clbq := " SELECT Z4_FILIAL 	"
	clBq += " ,Z4_ITEM 			"
	clBq += " ,Z4_CHAVENF 		"
	clBq += " ,Z4_DATA 			"
	clBq += " ,Z4_HORA 			"
	clBq += " ,Z4_USER 			"
	clBq += " ,Z4_PEDIDO 		"
	clBq += " ,Z4_FORNECE 		"
	clBq += " ,Z4_LOJA    "
	clBq += " ,Z4_NOME    "
	clBq += " ,Z4_OPER    "
	clBq += " ,Z4_PRODUTO "
	clBq += " ,Z4_DESC    "
	clBq += " ,Z4_VLRCORR "
	clBq += " ,Z4_VLRINF  "
	clBq += " ,Z4_TOTDIV  "
	clBq += " ,Z4_OBS     "
	clBq += " ,Z4_STATUS  "
	clBq += " ,Z4_CTRL	  "
	clBq += " FROM " + RetSqlName("SZ4") + " AS SZ4 "
	clBq += " WHERE Z4_CHAVENF='"+ (Fil + Tit + Pref + Forn + Loja + Tipo) +"' "
	clBq += " AND SZ4.D_E_L_E_T_='' " 
	
	If Select("GRSZ4") > 0
		dbSelectArea("GRSZ4")
		DbCloseArea()
	EndIf 
	    
	TcQuery clBq New Alias "GRSZ4"
	TcSetField("GRSZ4","Z4_DATA"	,"D",08,0)
	
	While GRSZ4->(!Eof())		
		DbSelectArea("SZ4")
		RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL 	:= GRSZ4->Z4_FILIAL
			SZ4->Z4_CHAVENF := GRSZ4->Z4_CHAVENF
			SZ4->Z4_DATA 	:= dDatabase
			SZ4->Z4_HORA 	:= Time() 
			SZ4->Z4_USER 	:= cUserName
			SZ4->Z4_PEDIDO  := GRSZ4->Z4_PEDIDO
			SZ4->Z4_FORNECE := GRSZ4->Z4_FORNECE
			SZ4->Z4_LOJA    := GRSZ4->Z4_LOJA
			SZ4->Z4_ITEM    := GRSZ4->Z4_ITEM
			DbSelectArea("SA2")
			DbSetOrder(1)
			If DbSeek(Xfilial("SA2") + GRSZ4->Z4_FORNECE + GRSZ4->Z4_LOJA )
				SZ4->Z4_NOME := SA2->A2_NOME
			EndIf		
			SZ4->Z4_OPER	:= GRSZ4->Z4_OPER
			SZ4->Z4_PRODUTO := GRSZ4->Z4_PRODUTO
		   	DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(Xfilial("SB1") + GRSZ4->Z4_PRODUTO )
				SZ4->Z4_DESC :=SB1->B1_DESC    
			EndIf
			SZ4->Z4_VLRCORR := GRSZ4->Z4_VLRCORR
			SZ4->Z4_VLRINF  := GRSZ4->Z4_VLRINF
			SZ4->Z4_TOTDIV  := GRSZ4->Z4_TOTDIV
			SZ4->Z4_OBS     := GRSZ4->Z4_OBS
			SZ4->Z4_STATUS  := "2"														               
		MsUnLock()	
		GRSZ4->(DbSkip())
	EndDo 
	SZ4->(DbCommit())
			
	DbSelectArea("SF1")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SF1")+ Tit + Pref + Forn + Loja)
		clStatus:=SF1->F1_XSTDIV
		If  RecLock("SF1",.F.)	
				SF1->F1_XSTDIV:="L" 	// Deixa o a nota com status de desbloqueado			
		    MsUnLock()	
		EndIf
	EndIf
	Aviso("Messagem","O título  foi liberado com sucesso",{"OK"},1)
	If Tela1=="oDlg" 
		Close(&Tela1)
		Close(&Tela2)
	EndIf
			
	AADD(aDiv,{ALLTRIM(SZ4->Z4_CHAVENF),ALLTRIM(SZ4->Z4_PEDIDO),ALLTRIM(SZ4->Z4_NOME),ALLTRIM(SZ4->Z4_FORNECE),ALLTRIM(SZ4->Z4_LOJA),ALLTRIM(SZ4->Z4_ITEM),ALLTRIM(SZ4->Z4_PRODUTO),ALLTRIM(SZ4->Z4_DESC),ALLTRIM(SZ4->Z4_VLRCORR),ALLTRIM(SZ4->Z4_VLRINF),ALLTRIM(SZ4->Z4_TOTDIV),ALLTRIM(SZ4->Z4_OBS)})
 	
 	U_EMAILZ4(aDiv)
EndIF
 	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2  ºAutor  ³Microsiga           º Data ³  11/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EMAILZ4()

Local aArea	   := GetArea()
Local cMailCab := " "

cMailCab = '<br><b><p> <font face="Verdana" size="1"> Segue uma Lista de todos os Itens Desbloqueados da NF:'+SUBS(SZ4->Z4_CHAVENF,3,9)+' Prefixo: '+SUBS(SZ4->Z4_CHAVENF,12,3)+ '</font></p></b><br>'	

cMailCab += '<table border="1" width="1000" height="50" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">'
cMailCab += '	<tr>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Status</font></b></td>'      
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="20"><b><font face="Verdana" size="1">Pd. Compras</font></b></td>'
cMailCab += '		<td width="1000,0" bgcolor="#FF9900" height="50"><b><font face="Verdana" size="1">Nome Forn.</font></b></td>'  
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="20"><b><font face="Verdana" size="1">Cod. Forn</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Loja Forn.</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Item</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Produto</font></b></td>'  
cMailCab += '		<td width="1600,5" bgcolor="#FF9900" height="50"><b><font face="Verdana" size="1">Descrição</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Valor Correto</font></b></td>'   
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Valor NF</font></b></td>'  
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Total Div.</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Tipo Bloqueio</font></b></td>'    
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Mot. Liberação</font></b></td>'
cMailCab += '	</tr>'

For Nx:= 1 to Len(aDiv)

		cTotDiv := ALLTRIM(Transform(VAL(aDiv[Nx][10])-VAL(aDiv[Nx][9]) , "@E 999,999,999.99"))
	
		cMailCab += '	<tr>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+IIF(SZ4->Z4_STATUS == '2',"LIBERADO","BLOQUEADO")+'</font></td>'
		cMailCab += '		<td width="142,5" height="50"><font face="Verdana" size="1">'+aDiv[Nx][2]+'</font></td>'
		cMailCab += '		<td width="1000,0" height="10"><font face="Verdana" size="1">'+aDiv[Nx][3]+'</font></td>'
		cMailCab += '		<td width="142,5" height="10"><font face="Verdana" size="1">'+aDiv[Nx][4]+'</font></td>'
		cMailCab += '		<td width="142,5" height="10"><font face="Verdana" size="1">'+aDiv[Nx][5]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aDiv[Nx][6]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aDiv[Nx][7]+'</font></td>'
		cMailCab += '		<td width="1600,5" height="50"><font face="Verdana" size="1">'+aDiv[Nx][8]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aDiv[Nx][9]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aDiv[Nx][10]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+cTotDiv+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+UPPER(aDiv[Nx][12])+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+iF(TYPE("cMultiGe1")!="U",cMultiGe1,'')+'</font></td>'		 
		cMailCab += '	</tr>'  
Next Nx

U_TTMAILN("desbloqueio@toktake.com.br","mmelao@toktake.com.br","Desbloqueio de Notas - Entradas",cMailCab,{},.T.)

RestArea(aArea)

Return()