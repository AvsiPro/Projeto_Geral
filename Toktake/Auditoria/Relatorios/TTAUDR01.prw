#Include "Protheus.ch"
#Include "TBICONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTAUDR01  ºAutor  ³Microsiga           º Data ³  03/31/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTAUDR01

Local aArea	:= GetArea()
Local aBrw1	:= {} 
Local aAux	:= {}
Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Fundo_de_troco"
Local cDir := ""
Local cArqXls := "Fundo_de_troco.xml" 
Local cCadastro 	:= "TOKTAKE - Fechamentos de Fundo de Troco"
Local aSays 		:= {}
Local aRegs			:={}
Local aButtons 		:= {}                                            
Local nOpca := 0            
Local aList			:= {}
Private cPergCal    := "TTAUDR01"   
 
//Prepare Environment Empresa "01" Filial "01" //Modulo "FAT" Tables "SUD" 


aAdd(aRegs,{cPergCal,"01","Periodo de   ?","","","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPergCal,"02","Periodo ate  ?","","","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPergCal,"03","Salvar em    ?","","","mv_ch3","C",50,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})

//cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

ValidPerg(aRegs,cPergCal) 
Pergunte(cPergCal,.F.)
             
aAdd(aSays,cCadastro)   
aAdd(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

cDir := MV_PAR03

If Empty(cDir)
	Return
EndIf

cQuery := "SELECT ZF_ROTA,COUNT(*)"
cQuery += " FROM "+RetSQLName("SZF")
cQuery += " WHERE ZF_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
cQuery += " AND D_E_L_E_T_='' AND ZF_FILIAL='"+xFilial("SZF")+"'"
cQuery += " GROUP BY ZF_ROTA"
cQuery += " ORDER BY ZF_ROTA"
                     
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTAUDR01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")  

While !EOF()
    Aadd(aList,TRB->ZF_ROTA)
	DbSkip()
Enddo

For nPx := MV_PAR01 to MV_PAR02
	For nX := 1 to len(aList)
		aAux := U_TTFINR14({aList[nX],nPx,.T.}) 
		If len(aAux) > 0
			Aadd(aBrw1,aAux[1])	
		EndIf
	Next nX
Next nPx

cCabecalho := "GERAL"
oExcel:AddworkSheet("Fundo_de_troco") 
oExcel:AddTable ("Fundo_de_troco",cCabecalho)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Rota",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Troco",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Cedulas",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Moedas",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_POS",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Venda",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Sangria",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Adicao_Liquida",1,1)

For nI := 1 To Len(aBrw1)
	oExcel:AddRow("Fundo_de_troco",cCabecalho,{aBrw1[nI][1],; 	//Produto
											Transform(aBrw1[nI][2],"@E 999,999,999.99"),;		//Descricao
											Transform(aBrw1[nI][3],"@E 999,999,999.99"),;		//Qtd
											Transform(aBrw1[nI][4],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][5],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][6],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][7],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][8],"@E 999,999,999.99")}) 
Next nI

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFINC14","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFINC14", 'MsExcel não instalado. ' +CRLF +'O arquivo está em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

RestArea(aArea)

Return