#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA31  บAutor  ณMicrosiga           บ Data ณ  02/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA31(cfils,craorig,ccliori,ccont,cnumos,cprod,cPatr,cTecn,cDtAgen,cContra,cItem,cTipo)

Local aArea		:= GetArea()
Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local nX     	:= 0
Local nY     	:= 0
Local lOk    	:= .T.
Local cEndc		:= ""
Local cEnde		:= ""
Local cBairroc	:= ""
Local cBairroe	:= ""
Local cMunc		:= ""
Local cMune		:= ""
Local cCepc		:= ""
Local cCepe		:= ""
Local cEstc		:= ""
Local cEste     := ""
Local cCod		:= ""
Local cLoja		:= ""
Local cAtend	:= ""
Local nDesconto	:= 0
Local nFrete	:= 0
Local nDespesa	:= 0
Local lAlterar	:= .T.
Local cRotina	:= "1" 	//Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca 
Local cChamado	:= ""
Local lChamOk	:= .F.
Local nCntWl	:= 0
Local cChamAb2 := ""
PRIVATE lMsErroAuto := .F.

If cEmpAnt <> "01"
	Return
EndIf


DbSelectArea("SA1")
DbSetOrder(1) //cfils,craorig,ccliori,cnumos
If !SA1->(DbSeek(xFilial("SA1")+ccliori))
	lOk := .F.
Else
	cCod		:=SA1->A1_COD
	cLoja		:=SA1->A1_LOJA
	cEndc		:=SA1->A1_ENDCOB
	cBairroc	:=SA1->A1_BAIRROC
	cMunc		:=SA1->A1_MUNC
	cCepc		:=SA1->A1_CEPC
	cEstc		:=SA1->A1_ESTC
	cEnde		:=SA1->A1_ENDENT
	cBairroe	:=SA1->A1_BAIRROE
	cMune		:=SA1->A1_MUNE
	cEste		:=SA1->A1_ESTE
	nDesconto	:=10
	nFrete		:=20
	nDespesa	:=30
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIncluir atendimentos do televendas   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ConOut("Inicio: " +Time())
//"Inicio: "
aCabec := {}
aItens := {}

// validacao do numero do chamado do call center
dbSelectArea("SUC")
dbSetOrder(1)
//dbSelectArea("AB1")
//dbSetOrder(5) 

cChamado := TkNumero("SUC","UC_CODIGO")

AADD(aCabec,{"UC_CODIGO"	,cChamado      					,Nil})
AADD(aCabec,{"UC_DATA"	    ,dDatabase    					,Nil})
AADD(aCabec,{"UC_CODCONT"	,ccont	     					,Nil})
AADD(aCabec,{"UC_ENTIDAD"	,"SA1"       					,Nil})
AADD(aCabec,{"UC_CHAVE"	    ,ccliori						,Nil})
AADD(aCabec,{"UC_OPERADO"	,POSICIONE("SU7",4,XFILIAL("SU7")+RETCODUSR(),"U7_COD")      					,Nil})
AADD(aCabec,{"UC_OPERACA"	,"2"       						,Nil})
AADD(aCabec,{"UC_STATUS"	,"2"       						,Nil})
AADD(aCabec,{"UC_INICIO"	,"10:00"   						,Nil})
AADD(aCabec,{"UC_OBS"		,"CHAMADO GERADO ATRAVES DA OMM "+craorig										,Nil})     
AADD(aCabec,{"UC_PENDENT"	,cDtAgen						,Nil})    //SUD->UD_PENDENT
AADD(aCabec,{"UC_HRPEND"	,"20:00"   						,Nil})    //SUC->UC_HRPEND
//AADD(aCabec,{"UC_DIASDAT"	,   11997    					,Nil})
//AADD(aCabec,{"UC_HORADAT"	,   49226   					,Nil})
AADD(aCabec,{"UC_PROSPEC"	,.F.     						,Nil})
aLinha := {}
aadd(aLinha,{"UD_CODIGO"	,cChamado       		,Nil})
aadd(aLinha,{"UD_ITEM"		,"01"       			,Nil})
aadd(aLinha,{"UD_ASSUNTO"	,If(cTipo=="1","000012","000013")  		,Nil})
aadd(aLinha,{"UD_PRODUTO"	,cprod			     	,Nil})
aadd(aLinha,{"UD_OCORREN"	,If(cTipo=="1","000190","000191")     	,Nil})
aadd(aLinha,{"UD_DATA"		,dDatabase  	     	,Nil})
aadd(aLinha,{"UD_STATUS"	,"1"		    	   	,Nil})
aadd(aLinha,{"UD_VENDA"		,craorig	  	     	,Nil})	// OMM
aadd(aLinha,{"UD_ITEMVDA"	,cItem		    	   	,Nil})
//aadd(aLinha,{"UD_NSERIE"	,cPatr		    	   	,Nil})
aadd(aLinha,{"UD_XNPATRI"	,cPatr		    	   	,Nil})

aadd(aItens,aLinha)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Executa a chamada da rotina de atendimento CALL CENTER       |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
n := len(aItens)
SetModulo("SIGATMK",'TMK')


//BeginTran()
MSExecAuto({|x,y,z,w| TMKA271(x,y,z,w)},aCabec,aItens,3,cRotina)

//TMKA271(aCabec,aItens,3,cRotina)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExibe se foi feita a inclusao ou se retornou erroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lMsErroAuto
	//ConOut("Atendimento incluido com sucesso!")
	
	//dbSelectArea("SUC")
	//If dbSeek( xFilial("SUC") +AvKey(cChamado,"UC_CODIGO") )
		ConfirmSx8()
		Aadd(aChamIns,{cChamado,''})
		cChamAb2 := Tca300(cChamado,ccliori,cprod,cPatr,cnumos,cTecn,cDtAgen,cContra,ccont)
	/*
	Else 
		lOk := .F.
		cChamado := ""
		RollBackSxE()
	EndIf
	*/
	//"Atendimento incluido com sucesso! "
Else
	ConOut("Erro na inclusao!")
	lOk := .F.
	cChamado := ""
	RollBackSx8()
	//"Erro na inclusao!"
	Mostraerro()
	//DisarmTransaction()
	//Break
EndIf

If !lOk
	//DisarmTransaction()
Else
	//EndTran()
EndIf

RestArea(aArea)

Return(cChamado)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA31  บAutor  ณMicrosiga           บ Data ณ  02/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Tca300(cChdTmk,ccliori,cProd,cPatr,cnumos,cTecn,cDtAgen,cContra,ccont,cDescLocal)
Local aCabec := {}
Local aItens := {  } 
Local aItem := {  } 
Local nX := 1
Local nY := 0
Local cChamado := ""
Local lOk := .T.
PRIVATE lMsErroAuto := .F.
Default cDescLocal := "" 


DbSelectArea("AA3")
DbSetOrder(1)
If !DbSeek(xFilial("AA3")+substr(ccliori,1,10)+cprod+cPatr)
	U_TTTECC05(1,substr(ccliori,1,6),substr(ccliori,7,4),cPatr,cDtAgen,cContra,cDescLocal)
EndIf


If lOk 
	DbSelectArea("SA1")
	Dbseek(xFilial("SA1")+ccliori)
	ConOut("Inicio: "+Time())
	
	dbSelectArea("AB1")
	dbSetOrder(1)
	cChamado := GetSXENum("AB1","AB1_NRCHAM")
	While dbSeek( xFilial("AB1") +AvKey(cChamado,"AB1_NRCHAM") )
		cChamado := GetSXENum("AB1","AB1_NRCHAM")
	End
    
	aCabec := {  } 
	aItens := {  } 
	aAdd(aCabec,{ "AB1_NRCHAM", cChamado,Nil})
	aAdd(aCabec,{ "AB1_EMISSA", dDataBase,Nil})
	aAdd(aCabec,{ "AB1_CODCLI", SA1->A1_COD,Nil})
	aAdd(aCabec,{ "AB1_LOJA" , SA1->A1_LOJA,Nil})
	aAdd(aCabec,{ "AB1_CONTAT", Posicione("SU5",1,xFilial("SU5")+ccont,"U5_CONTAT"),Nil})
	aAdd(aCabec,{ "AB1_HORA" ,Time(),Nil})
	aAdd(aCabec,{ "AB1_ATEND" ,cUserName,Nil})
	aAdd(aCabec,{ "AB1_NUMTMK",cChdTmk  ,Nil})
	
	aItem := {  } 
	aAdd(aItem,{ "AB2_ITEM" ,StrZero(nX,2),Nil})
	aAdd(aItem,{ "AB2_TIPO" ,"3",Nil})
	aAdd(aItem,{ "AB2_CLASSI","003",Nil})
	aAdd(aItem,{ "AB2_CODPRO",cprod,Nil})
	aAdd(aItem,{ "AB2_NUMSER",cPatr,Nil})
	aAdd(aItem,{ "AB2_CODPRB",'000012',Nil}) //AAG->AAG_CODPRB
	aAdd(aItem,{ "AB2_XOSMOB",cnumos,Nil})
	aAdd(aItem,{ "AB2_XTEC"  ,cTecn,Nil})
		
	aAdd(aItens,aItem)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Teste de Inclusao |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TECA300(,,aCabec,aItens,3)
	If !lMsErroAuto
		//ConOut("Incluido com sucesso!" +cChamado)
		ConfirmSx8()
		//aChamIns[len(aChamIns),02] := cChamado
	Else
		//ConOut("Erro na inclusao!")
		MostraErro() 
		RollBackSx8()
		lOk := .F.
	EndIf
EndIf

Return cChamado


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA31  บAutor  ณMicrosiga           บ Data ณ  05/22/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NUMSUC()

Local cSql := ""
Local cNum := ""
Local aArea := GetArea()

cSql := "SELECT MAX(UC_CODIGO) NUM FROM " +RetSqlName("SUC")
cSql += " WHERE UC_FILIAL = '"+xFilial("SUC")+"' "

If Select('TRBA') > 0
	dbSelectArea('TRBA')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBA",.F.,.T.)
dbSelectArea("TRBA")

cNum := TRBA->NUM
              
TRBA->(dbCloseArea())

dbSelectArea("SUC")
dbSetOrder(1)
While dbSeek( xFilial("SUC") +AvKey(cNum,"UC_CODIGO") )
	cNum := Soma1(cNum)
End

RestArea(aArea)

Return cNum