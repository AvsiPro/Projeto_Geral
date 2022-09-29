#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTTMKA10  ณ Autor ณ Alexandre Venancio    ณ Data ณ 28/06/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina criada para consultar patrimonios pelo call center  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Consultar patrimonios disponiveis e em cliente.            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTTMKA10(nModulo)

Local aArea	:=	GetArea() 
Local lRet	:=	.T.  
Local nLin 	:=	0

Private aList	:=	{}
Private oList	:=	nil
Private oDlg1,oGrp1,oBrw1,oSBtn1,oSBtn2,oGet1
Private aRet 	:= {}                        
Private cAtivo	:= space(20)
Default nModulo := 0
        
If cEmpAnt <> "01"
	Return(lRet)
EndIf
                   
//Prepare Environment Empresa "01" Filial "01" Modulo "ESP" TABLES "SUC/SUD/SN1"
//So chama esta rotina se vier do call center
If nModulo == 0
	lRet := ExempParam()
Else
	aRet := {'Cliente'}
EndIf

If !lRet
	Return
EndIf

PreAcols(nModulo)

If len(aList) < 1
	Aadd(aList,{'','','','','','',''})
EndIf

oDlg1      := MSDialog():New( 091,232,443,885,"Patrim๔nios Instalados no Cliente",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,148,316,"Maquinas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oList := TCBrowse():New(016,012,300,125,, {'Produto','Descricao','Patrimonio','Local Inst'},{40,70,30,50},;
                            oGrp1,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
oList:SetArray(aList)
oList:bLine := {||{ aList[oList:nAt,01],; 
 					 aList[oList:nAt,02],;
 					 aList[oList:nAt,03],;
                     aList[oList:nAt,04]}}

oSBtn1     := SButton():New( 154,136,1,{||oDlg1:end()},oDlg1,,"", )

If nModulo == 1
	oSBtn2     := SButton():New( 154,186,19,{||oDlg1:end(nLin:=oList:nAt)},oDlg1,,"Carregar", )
	oGet1      := TGet():New( 154,066,{|u| If(PCount()>0,cAtivo:=u,cAtivo)},oDlg1,060,008,'@!',{||},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{|| procura(cAtivo)},.F.,.F.,"","",,)

Endif

oDlg1:Activate(,,,.T.)

If nModulo == 1 
	If nLin > 0 .And. Empty(aCols[n,ascan(aHeader,{|x| alltrim(x[2]) == "AB2_CODPRO"})])
		aCols[n,ascan(aHeader,{|x| alltrim(x[2]) == "AB2_CODPRO"})] := aList[nLin,01]
		aCols[n,ascan(aHeader,{|x| alltrim(x[2]) == "AB2_NUMSER"})] := aList[nLin,03]
		aCols[n,ascan(aHeader,{|x| alltrim(x[2]) == "AB2_MEMO2"})]  := 'Local Fisico de Instala็ใo '+aList[nLin,04]
	EndIf
EndIf

RestArea(aArea)
                     
//Reset Environment

Return              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA05  บAutor  ณMicrosiga           บ Data ณ  07/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Preacols(nModulo)

Local cQuery
Local nPosP		:=	Ascan(aHeader,{|x| x[2] == "UD_PRODUTO"})

cQuery := "SELECT N1_PRODUTO,N1_DESCRIC,N1_CHAPA,N1_XLOCINS,N1_XCLIENT,N1_XLOJA"
cQuery += " FROM "+RetSQLName("SN1") 

If aRet[1] == "Cliente" .Or. nModulo == 1
	If nModulo == 1
		cQuery += " WHERE N1_XCLIENT='"+M->AB1_CODCLI+"' AND N1_XLOJA='"+M->AB1_LOJA+"'"
	Else
		cQuery += " WHERE N1_XCLIENT='"+Substr(M->UC_CHAVE,1,6)+"' AND N1_XLOJA='"+Substr(M->UC_CHAVE,7,4)+"'"
	EndIf
Else                                                          
	If Empty(aCols[n,nPosP])
		MsgAlert("Para consultar os patrim๔nios disponํveis, o campo produto deve ser preenchido.","TTTMKA10")
		Return
	Else
		cQuery += " WHERE N1_XCLIENT='' AND N1_FILIAL='"+xFilial("SN1")+"' AND N1_XSTATTT='1'"
		cQuery += " AND N1_PRODUTO = '"+aCols[n,nPosP]+"'"
	EndIf
EndIf

cQuery += " AND D_E_L_E_T_='' ORDER BY N1_XLOCINS"
  
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTTMKA05.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")    

While !EOF()
    Aadd(aList,{TRB->N1_PRODUTO,TRB->N1_DESCRIC,TRB->N1_CHAPA,TRB->N1_XLOCINS})
	Dbskip()
Enddo

Return                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA05  บAutor  ณMicrosiga           บ Data ณ  07/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExempParam()

Local aPergs := {}
Local cCodRec := space(08)
Local lRet    

aAdd( aPergs ,{2,"Recurso Para","Cliente", {"Cliente", "Disponํvel"},50,'',.T.})   

If ParamBox(aPergs ,"Parametros ",aRet)      
	lRet := .T.   
Else      
	lRet := .F.   
EndIf

Return(lRet)

Static Function procura(cAtivo)

Local nPosic := Ascan(aList,{|x| Alltrim(x[3]) ==Alltrim(cAtivo)})

If nPosic > 0
	oList:nAt := nPosic
	oList:refresh()
	oDlg1:refresh()
EndIf

Return