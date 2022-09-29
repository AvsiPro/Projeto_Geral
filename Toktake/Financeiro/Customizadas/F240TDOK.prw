#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function F240TDOK

Local aArea	     := GetArea()
Local peAliasSE2 := paramixb[2] 
Local aTit       := {}
Local lRetorno   := .T.

If CMODPGTO $ GETMV("MV_XMODELO") //.AND. CTIPOPAG $ GETMV("MV_XTPPAGTO")

	DBSelectArea("SE2TMP")
	DBGotop()
	While !EOF()
	     
	     If SE2TMP->E2_OK == cMarca
	          	If Empty( E2_CODBAR ) 
					AADD(aTit,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,.F.})
				EndIf
	     EndIf
	     
	     SE2TMP->(DBSKIP())
	EndDo
		
		For i:= 1 To Len(aTit)       
			If 	aTit[i][6] == .F.     
				lRetorno := .F.
				exit
		    Endif
		Next                                                                                                                                              
		
		If Len(aTit) > 0 
		    Alert("O Bordero nใo foi gerado pois alguns tํtulos foram bloqueados verifique seu e-mail !" )
		    U_TITEMAIL(aTit)
		Endif
	  
Endif
    
RestArea(aArea)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  09/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TITEMAIL(aTit)

Local aArea	   := GetArea()
Local cMailCab := " "

cMailCab = '<br><b><p> <font face="Verdana" size="1"> Segue uma Lista de todos os tํtulos sem c๓digo de barras: </font></p></b><br>'	

cMailCab += '<table border="1" width="680" height="40" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">'
cMailCab += '	<tr>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Prefixo</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Tํtulo</font></b></td>'
cMailCab += '   	<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Parcela</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="20"><b><font face="Verdana" size="1">Cod. Forn</font></b></td>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="20"><b><font face="Verdana" size="1">Descri็ใo</font></b></td>'  
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Loja</font></b></td>'
cMailCab += '	</tr>'

For Nx:= 1 to Len(aTit)
	
	If aTit[Nx][6] == .F.		
		cMailCab += '	<tr>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aTit[Nx][1]+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aTit[Nx][2]+'</font></td>'
		cMailCab += '		<td width="142,5" height="10"><font face="Verdana" size="1">'+aTit[Nx][3]+'</font></td>'
		cMailCab += '		<td width="142,5" height="10"><font face="Verdana" size="1">'+aTit[Nx][4]+'</font></td>'
		cMailCab += '		<td width="142,5" height="10"><font face="Verdana" size="1">'+SUBSTR(POSICIONE("SA2",1,XFILIAL("SA2")+aTit[Nx][4]+aTit[Nx][5],"A2_NOME"),1,30)+'</font></td>'
		cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aTit[Nx][5]+'</font></td>'		 
		cMailCab += '	</tr>'  
    Endif
    
	DbSkip()
Next

U_TTMAILN("validacaocodbar@toktake.com.br",GETMV("MV_XTITBLQ"),"Tํtulos sem C๓digo de Barras",cMailCab,{},.T.)

RestArea(aArea)

Return()