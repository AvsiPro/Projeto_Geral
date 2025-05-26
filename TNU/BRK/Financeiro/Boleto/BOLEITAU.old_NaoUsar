#Include "Protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"   
#include "TOTVS.CH"
#Include "FWPrintSetup.ch"

/*/
�������������������������������������������������
���Programa  � BOL_ITAU � Autor � Geronimo B Alves    � Data � 22/04/2020  ���
�������������������������������������������������
���Descri��o � IMPRESSAO DO BOLETO BANCO ITAU COM CODIGO DE BARRAS           ���
�������������������������������������������������
/*/
User Function BOLEITAU(_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc)

///Local _cFormPG		:= E1_TIPO 

DEFAULT lSched		:= .F.

PRIVATE lExec		:= .F.
PRIVATE cIndexName	:= ''
PRIVATE cIndexKey	:= ''
PRIVATE cFilter		:= ''
PRIVATE aDadosBanco	:= {} 
PRIVATE cAgen060	:= ""
PRIVATE cConta060	:= ""  
PRIVATE cDVAGE		:= ""
PRIVATE cDVCTA		:= "" 
Private _nSaldo		:= 0
PRIVATE lSrvUnix	:= IsSrvUnix()
PRIVATE _lSched		:= If(  VALTYPE(lSched) == "L" ,  lSched,  .F.) 
PRIVATE cPasta		:= ""
PRIVATE _cArq_Bole	:= ""
//PRIVATE _CCLIEN

/*
For _nX := 1 to Len(cDados)

_cFormPG := cDados[_nX][1]
_cClien  := cDados[_nX][2]
_cLojaC  := cDados[_nX][3]
_cSerie  := cDados[_nX][4]
_cNota   := cDados[_nX][5]
_cParc   := cDados[_nX][6]

_cFormPG := cDados[1][1]
_cClien  := cDados[1][2]
_cLojaC  := cDados[1][3]
_cSerie  := cDados[1][4]
_cNota   := cDados[1][5]
_cParc   := cDados[1][6]

*/
Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa imprime o Boleto Itau com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOL_ITAU"
lEnd     := .F.
cPerg    := "BOL_ITAU"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0 

// Para calculo do digito verificador quando resto da divisao for 1 digito sera P
nVal1  := 0
nVal2  := 0
nVal3  := 0
nVal4  := 0
nVal5  := 0
nVal6  := 0
nVal7  := 0
nVal8  := 0
nVal9  := 0
nVal10 := 0
nVal11 := 0
nVal12 := 0
nSum   := 0   

M->DV_NNUM   := SPACE(1)
M->DV_BARRA  := SPACE(1)
M->cBARRA    := ""
M->LineDig   := ""
M->LinhaDig  := ""
M->NumBoleta := ""
M->nDigito   := ""
M->Pedaco    := ""

//aPortador := GetAdvFVal("SA1", {"A1_XPORTAD", "A1_XAGEDEP", "A1_XCONTA", "A1_BLEMAIL"}, xFilial("SA1")+E1_CLIENTE+E1_LOJA, 1, { "", "", "", "" })
aPortador := U_BCOAGEC()		// Função le os parametros por filial de banco, agencia, conta e emite boloet S/N ? e alimenta o array aPortador
If aPortador[4] <> "S"
	Return ""
Endif
_cPort 			:= aPortador[1] 
_cAgen 			:= aPortador[2] 
_cCont 			:= aPortador[3] 
_cE1PORCJU		:= SE1->E1_PORCJUR

dbSelectArea("SE1")

If ALLTRIM(_cFormPG) == "NF"
	IF Empty(E1_XBOLEMI)
		reclock("SE1",.F.)
		E1_XBOLEMI := "0"
		MsUnlock()
	ENDIF

	dbSelectArea("SE1")
	dbSetOrder(2)		// E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If dbSeek(xFilial("SE1")+_cClien+_cLojaC+_cSerie+_cNota+_cParc+_cFormPG)	// Esta pesquisa � desnecessaria
		_nBolEmi := val(E1_XBOLEMI) + 1
		_cBolEmi := str(_nBolEmi)
		reclock("SE1",.F.)
		E1_XBOLGER := "S"
		E1_XBOLEMI := ALLTRIM(_cBolEmi)
		MsUnlock()
	
		Processa({|lEnd|MontaRel(@aDadosBanco,@cAgen060,@cConta060,@cDVAGE,@cDVCTA,_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc)})
	
	Endif
	
ELSE
	If _lSched
		CONOUT("Tipo de titulo, N�o � NF")
	Else
		MSGINFO("Tipo de titulo, N�o � NF")
		
	Endif

Endif
	//Next _nX
Return //cArq_Bole

/*/
�����������������������������������������������������������������������������
���Programa  � MontaRel � Autor � Geronimo B Alves    � Data � 22/04/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ���
�����������������������������������������������������������������������������
/*/
Static Function MontaRel(aDadosBanco,cAgen060,cConta060,cDVAGE,cDVCTA,_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc)
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	ALLTRIM(SM0->M0_NOMECOM)                                     ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     ,; //[2]Endere�o
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
//LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {  "COMISS�O DE PERMANENCIA POR DIA R$ " ,;
                         "MULTA AP�S VENCIMENTO: R$ "          ,;
                         " ( 2 % ) "                           ,;
                         "BOLETO SUJEITO A PROTESTO"            }
                         //"AP�S O VENCIMENTO PAGAR SOMENTE NAS AGENCIAS DO BANCO ITAU "  ,;

LOCAL cLocal	:= IIF( lSrvUnix, "/spool" , "\spool" )	
LOCAL lAdjustToLegacy := .T.
LOCAL lDisableSetup  := .T.

LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

cPasta		:= GetMV("MV_XBOLITAU")  
cPasta		:= cPasta + IF(SUBS(cPasta,Len(cPasta),1) == "\", "", "\")

_cArq_Bole 		:= "boletoitau"+".pdf"
_cArq_Bole		:= strtran(_cArq_Bole, " ", "_")

oPrint := FWMSPrinter():New(_cArq_Bole, 6, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
oPrint:SetPortrait() 

dbSelectArea("SE1")
Do While !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_CLIENTE == _cClien .AND. SE1->E1_LOJA == _cLojaC .AND. SE1->E1_PREFIXO == _cSerie .AND. SE1->E1_NUM == _cNota .AND. SE1->E1_PARCELA == _cParc
   	MontaBor(@aDadosBanco,@cAgen060,@cConta060,@cDVAGE,@cDVCTA,_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc)  
   	DbSelectArea("SE1")  

	aPortador := U_BCOAGEC()		// Função le os parametros por filial de banco, agencia, conta e emite boloet S/N ? e alimenta o array aPortador

	If aPortador[4] <> "S"
		Return ""
	Endif
	_cPort 			:= aPortador[1] 
	_cAgen 			:= aPortador[2] 
	_cCont 			:= aPortador[3] 
	
	//Posiciona na Arq de Parametros CNAB  
	dbSelectArea("SE1")
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+_cPort+_cAgen+_cCont,.T.)  
	
	_nNossoNux  := alltrim(SEE->EE_CODEMP) + alltrim(SUBSTR(SEE->EE_FAXATU,2,10))
	_nNossoNum  := alltrim(SEE->EE_CODEMP) + alltrim(SUBSTR(SEE->EE_FAXATU,2,10))
	                                                                                
	cCarte := alltrim(SEE->EE_CODCART) 
	
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO 	:= alltrim(StrZero(val(SEE->EE_FAXATU),11)) 
	MsUnlock()
	
	If SEE->( EOF() )
		If _lSched
			CONOUT("Este t�tulo n�o esta relacionado a nenhum registro v�lido na tabela parametro de bancos (SEE) ")
		Else
			MsgStop("Este t�tulo n�o esta relacionado a nenhum registro v�lido na tabela parametro de bancos (SEE) ")
		Endif
		Return ""
	Else
		RecLock('SEE',.F.)
		SEE->EE_FAXATU := alltrim(StrZero(val(SEE->EE_FAXATU)+1,11))
		MsUnlock()
	Endif
		
		
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
    
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Raz�o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]C�digo
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endere�o
		AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
		SA1->A1_EST                                      ,;     		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		SA1->A1_PESSOA										}       				// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Raz�o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]C�digo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endere�o
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC												 		 ,;		// [7]CGC
		SA1->A1_PESSOA												 }				// [8]PESSOA
	Endif	
	DbSelectArea("SE1")
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA) 
	_nSaldo := SE1->E1_VALOR - SE1->E1_DECRESC + E1_ACRESC - (SE1->E1_VALOR*(SE1->E1_DESCFIN/100 ))//ONDE TINHA E1_SALDO, FOI SUBSTITUIDO POR ESTA VARIAVEL
	
	M->FatorVcto := Str( ( SE1->E1_VENCREA - Ctod("07/10/1997") ),4 )  
	
	cNroDoc	:= Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
	cNroDoc	:= STRZERO(Val(cNroDoc),11)
	cNroDoc := _nNossoNux
	//Monta codigo de barras
	aCB_RN_NN    :=Ret_cBarra(	SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,;
	Subs(aDadosBanco[1] ,1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
	cNroDoc		,(E1_VALOR-nVlrAbat)	, "18"	,"9"	)  
  

	  		M->B_Campo := "341"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(_nSaldo * 100),10)
			M->B_Campo := M->B_Campo + "000000" + _nNossoNux + cCarte               
			
				//Calculo do Digito do Codigo de Barras
			BarraDV()

			//Compor a barra com o Digito verificador
			M->CodBarras := "341"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(_nSaldo * 100),10)
			M->CodBarras := M->CodBarras + "000000" + _nNossoNux + cCarte
			
			MontaLinha()  

		
          		
	aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] N�mero do t�tulo
	E1_EMISSAO                              	,;  // [2] Data da emiss�o do t�tulo
	dDataBase                    					,;  // [3] Data da emiss�o do boleto
	E1_VENCTO                               	,;  // [4] Data do vencimento
	(_nSaldo - nVlrAbat)                  	,;  // [5] Valor do t�tulo
	cNroDoc                             	,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
	E1_PREFIXO                               	,;  // [7] Prefixo da NF
	E1_TIPO	                           		}   // [8] Tipo do Titulo

	Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cAgen060,cConta060,cDVAGE,cDVCTA)
	nX := nX + 1
	dbSelectArea("SE1")
	DBSKIP()
END

DBCloseArea()

oPrint:EndPage()     // Finaliza a p�gina
If _lSched 
	oPrint:Print()		// Se for via Sched, imprime sem mostrar na tela 
Else
	oPrint:Preview()	// Se for via Menu, visualiza antes de imprimir
ENDIF

cPath_Temp := GetTempPath()
cFileOrige := cPath_Temp + "totvsprinter\" + _cArq_Bole
cFileDesti := cPasta     + _cArq_Bole
lFile := file( cFileOrige )

lCopiou := __CopyFile( cFileOrige , cFileDesti )

Return //""

/*/
�����������������������������������������������������������������������������
���Programa  � Impress  � Autor � Geronimo B Alves    � Data � 22/04/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS      ���
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cAgen060,cConta060,cDVAGE,cDVCTA)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
cBitmap := ""

oFont4   := TFont():New("Arial",9,4,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont18  := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//Barra
oFont25:= 	  TFont():New( "Arial"          ,,04,,.T.,,,,,.f. )

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 1

cBitmap := "\system\imagens\itau_bit.bmp"

oPrint:SayBitmap ( 0050, 0120, cBitmap, 0350, 0090 )  

oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

oPrint:Say  (nRow1+0130,513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0109,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0175,100 ,"Beneficiario",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0175,1060,"Ag�ncia/C�digo Beneficiario",oFont8)
oPrint:Say  (nRow1+0200,1060,Alltrim(cAgen060)+"-"+Alltrim(cDVAGE)+"/"+Alltrim(cConta060)+"-"+Alltrim(cDVCTA),oFont10)  

oPrint:Say  (nRow1+0175,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0275,100 ,"Pagador",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome

oPrint:Say  (nRow1+0275,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0275,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0320,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0425,0100,"Recebemos o Boleto/Titulo",oFont10)
oPrint:Say  (nRow1+0475,0100,"com as caracteristicas acima.",oFont10)
oPrint:Say  (nRow1+0375,1060,"Data",oFont8)
oPrint:Say  (nRow1+0375,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0475,1060,"Data",oFont8)
oPrint:Say  (nRow1+0475,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) 
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) 
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0170,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0210,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0250,1910,"(  )N�o existe n� indicado"                  	,oFont8)
oPrint:Say  (nRow1+0290,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0330,1910,"(  )N�o procurado"                              ,oFont8)
oPrint:Say  (nRow1+0370,1910,"(  )Endere�o insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0410,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0450,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0490,1910,"(  )Outros(anotar no verso)"                  	,oFont8)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 1

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI   

oPrint:SayBitmap ( 0610, 0120, cBitmap, 0350, 0090 ) 

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

oPrint:Say  (nRow2+0685,513,aDadosBanco[1]+"-9",oFont21 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0664,1800,"Recibo do Pagador",oFont14)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0730,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0745,400 ,"PAGAVEL EM QUALQUER BANCO",oFont10)

oPrint:Say  (nRow2+0730,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0770,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0830,100 ,"Beneficiario"                                        ,oFont8)  
oPrint:Say  (nRow2+0855,100 ,alltrim(aDadosEmp[1])+" - "+aDadosEmp[6]+"        "	,oFont10) //Nome + CNPJ  
oPrint:Say  (nRow1+0880,100 ,alltrim(aDadosEmp[2])+" - "+alltrim(aDadosEmp[3])+" - "+alltrim(aDadosEmp[4])+" "    ,oFont10)				//Nome + CNPJ

oPrint:Say  (nRow2+0830,1810,"Ag�ncia/C�digo Beneficiario",oFont8)   
cString := Alltrim(cAgen060)+"-"+Alltrim(cDVAGE)+"/"+Alltrim(cConta060)+"-"+Alltrim(cDVCTA)  
nCol 	 := 1810+(374-(len(cString)*22))   
oPrint:Say  (nRow2+0870,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0930,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0960,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0930,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0960,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0930,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0960,1050,"DM"    										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0930,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0960,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0930,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0960,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0930,1810,"Nosso N�mero"                                   ,oFont8)
cString := _nNossoNux  //,1,3)+"/"+Substr(aDadosTit[6],4))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0960,nCol,cString,oFont11c)

oPrint:Say  (nRow2+1000,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+1000,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+1030,555 ,cCarte                                           ,oFont10)

oPrint:Say  (nRow2+1000,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow2+1030,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+1000,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+1000,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+1000,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1030,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1070,100 ,"Instru��es de responsabilidade do Benefici�rio. Qualquer d�vida sobre este boleto, contate o Benefici�rio",oFont8)
oPrint:Say  (nRow2+1170,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*_cE1PORCJU)/30/100),"@E 99,999.99"))            ,oFont10)
oPrint:Say  (nRow2+1220,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.02)         ),"@E 99,999.99")) + aBolText[3]  ,oFont10)
oPrint:Say  (nRow2+1270,100 ,aBolText[4]                                                                                      ,oFont10)

oPrint:Say  (nRow2+1070,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1140,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow2+1210,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1280,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow2+1350,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+1420,100 ,"Pagador"                                        ,oFont8 )
oPrint:Say  (nRow2+1450,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+1503,100 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1556,100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1450,1850 ,"CNPJ do Pagador" ,oFont8) // CGC
	oPrint:Say  (nRow2+1480,1870 ,TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1450,1850 ,"CPF do Pagador" ,oFont8) 	// CPF
	oPrint:Say  (nRow2+1480,1870 ,TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1580,1850, "C�digo de Baixa"  ,oFont8 )
oPrint:Say  (nRow2+1610,1870,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow2+1665,1550,"Autentica��o Mec�nica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI
oPrint:SayBitmap ( 1900, 0120, cBitmap, 0350, 0090 )

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)  

oPrint:Say  (nRow3+1975,513,aDadosBanco[1]+"-9",oFont21 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1964,755,M->LineDig,oFont18)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2020,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2035,400 ,"PAGAVEL EM QUALQUER BANCO",oFont10)

oPrint:Say  (nRow3+2020,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2060,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2120,100 ,"Beneficiario",oFont8)    
oPrint:Say  (nRow3+2145,100 ,alltrim(aDadosEmp[1])+" - "+aDadosEmp[6]+"     "	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow1+2170,100 ,alltrim(aDadosEmp[2])+" - "+alltrim(aDadosEmp[3])+" - "+alltrim(aDadosEmp[4])+" "  ,oFont10)				//Nome + CNPJ

oPrint:Say  (nRow3+2120,1810,"Ag�ncia/C�digo Beneficiario",oFont8)
cString := Alltrim(cAgen060)+"-"+Alltrim(cDVAGE)+"/"+Alltrim(cConta060)+"-"+Alltrim(cDVCTA) 
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2160,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2220,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2250,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2220,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2250,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2220,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2250,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2220,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2250,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2220,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2250,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2220,1810,"Nosso N�mero"                                   ,oFont8)
cString := _nNossoNux 
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2250,nCol,cString,oFont11c)


oPrint:Say  (nRow3+2290,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2290,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+2320,555 ,cCarte                                  	,oFont10)

oPrint:Say  (nRow3+2290,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow3+2320,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2290,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2290,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2290,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2320,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2360,100 ,"Instru��es de responsabilidade do Benefici�rio. Qualquer d�vida sobre este boleto, contate o Benefici�rio",oFont8)
oPrint:Say  (nRow3+2460,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*_cE1PORCJU)/30/100),"@E 99,999.99"))      ,oFont10)
oPrint:Say  (nRow3+2510,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.02)   ),"@E 99,999.99")) + aBolText[3]  ,oFont10)
oPrint:Say  (nRow3+2560,100 ,aBolText[4]                                                                                ,oFont10)

oPrint:Say  (nRow3+2360,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2430,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow3+2500,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2570,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow3+2640,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2710,100 ,"Pagador"                                         ,oFont8)
oPrint:Say  (nRow3+2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2720,1850,"CNPJ do Pagador"  ,oFont8) // CGC
	oPrint:Say  (nRow3+2750,1870,TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2720,1850,"CPF do Pagador"  ,oFont8) 	// CPF
	oPrint:Say  (nRow3+2750,1870,TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (nRow2+2796,1850, "C�digo de Baixa"  ,oFont8 )
oPrint:Say  (nRow3+2826,1870,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow3+2875,1550,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )

oPrint:FWMSBAR("INT25", 38,  2.5,M->CodBarras, oPrint, .F. ,Nil, Nil, 0.017, 1, Nil, "Arial",, .F., 1, 1, .F.)  
oPrint:FwMsBar("INT25", 65.1,2.5,M->CodBarras, oPrint, .F. ,Nil, Nil, 0.017, 1, Nil, "Arial",, .F., 1, 1, .F.)  


oPrint:EndPage() // Finaliza a p�gina

Return ""

/*
�����������������������������������������������������������������������������
���Funcao    �RetDados  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera SE1                        					          ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�����������������������������������������������������������������������������
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
cBanco		,cAgencia	,cConta		,cDacCC	,;
cNroDoc		,nValor		,cCart		,cMoeda	)

Local cNosso		:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

//DEFAULT nValor := 0

cAgencia:=STRZERO(Val(cAgencia),4)

cNosso := ""
NNUM := _nNossoNux
//Nosso Numero
cNosso     := _nNossoNux

cCampoL := NNUM

//campo livre do codigo de barra                   // verificar a conta
If nValor > 0
	cFatorValor  := fator1()+strzero(nValor*100,10)
Else
	cFatorValor  := fator1()+strzero(SE1->E1_VALOR*100,10)
Endif

cLivre := cBanco+cMoeda+cFatorValor+"000000"+cCampoL+cCarte

// campo do codigo de barra
cDigBarra := CALCL_5p( cLivre )
cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,39)

// composicao da linha digitavel
cParte1  := cBanco+cMoeda
cParte1  := cParte1 + SUBSTR(cCampoL,1,5)
cDig1    := DIGI001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := DIGI001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := DIGI001( cParte3 )
cParte4  := " "+cDigBarra+" "
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
cParte4+;
cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)

Return aRet

/*
�����������������������������������������������������������������������������
���Funcao    �CALC_dig9  �Autor  �Microsiga          � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para calculo do nosso numero do banco itau                  ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
���Funcao    �DIGI001  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para calculo da linha digitavel do Banco itau               ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�����������������������������������������������������������������������������
*/
Static Function DIGI001(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
umdois := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	auxi   := Val(SubStr(cBase, idig, 1)) * umdois
	sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
	umdois := 3 - umdois
	iDig:=iDig-1
EndDo
cValor:=AllTrim(STR(sumdig,12))
nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
auxi := nDezena - sumdig

If auxi >= 10
	auxi := 0
EndIf
Return(str(auxi,1,0))

/*
�����������������������������������������������������������������������������
���Funcao    �FATOR1	�Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do FATOR  de vencimento para linha digitavel.       ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�����������������������������������������������������������������������������
*/
Static function Fator1()
If Len(ALLTRIM(SUBSTR(DTOC(SE1->E1_VENCTO),7,4))) = 4
	cData := SUBSTR(DTOC(SE1->E1_VENCTO),7,4)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
Else
	cData := "20"+SUBSTR(DTOC(SE1->E1_VENCTO),7,2)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
//cFator := STR(1000+(SE1->E1_VENCREA-STOD("20000703")),4)
Return(cFator)

/*
�����������������������������������������������������������������������������
���Funcao    �CALCL_5p   �Autor  �Microsiga          � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito do nosso numero do                        ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�����������������������������������������������������������������������������
*/
Static Function CALCL_5p(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base >= 10
		base := 2
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base + 1
	iDig   := iDig-1
EndDo
auxi := mod(sumdig,11)
If auxi == 0 .or. auxi == 1 .or. auxi >= 10
	auxi := 1
Else
	auxi := 11 - auxi
EndIf

Return(str(auxi,1,0))

/*/
�����������������������������������������������������������������������������
���Programa  � MontaBor � Autor � Geronimo B Alves    � Data � 22/04/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ���
�����������������������������������������������������������������������������
/*/
Static Function MontaBor(aDadosBanco,cAgen060,cConta060,cDVAGE,cDVCTA,_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc) 
aPortador := U_BCOAGEC()		// Função le os parametros por filial de banco, agencia, conta e emite boloet S/N ? e alimenta o array aPortador
If aPortador[4] <> "S"
	Return ""
Endif
cPort060	:= aPortador[1] 
cAgen060	:= aPortador[2] 
cConta060	:= aPortador[3] 

cSituacao := SE1->E1_SITUACA
cContrato := SE1->E1_CONTRAT
cNumBco   := SE1->E1_NUMBCO
cDVAGE    := ""
cDVCTA    := "" 

dbSelectArea("SEA")
dbSetOrder(1)
If dbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
	Reclock("SEA",.F.)
	dbDelete()
	MsUnlock()
EndIf

//��������������������������������������������������������������Ŀ
//� Vai pegar o ultimo N�mero de bordero utilizado 				  �
//����������������������������������������������������������������
cNumBor := Soma1(GetMV("MV_NUMBORR"),6)      

DbSelectArea("SA6")
DbSetOrder(1)
IF DbSeek(xFilial("SA6")+cPort060 + cAgen060 + cConta060 ) 

  			cAgen060  := A6_AGENCIA
			cConta060 := A6_NUMCON  
			cDVAGE    := A6_DVAGE
			cDVCTA    := A6_DVCTA 
			aDadosBanco  := {A6_COD                        ,; 		// [1]Numero do Banco
 			A6_NREDUZ                                       	,;  // [2]Nome do Banco
			SUBSTR(A6_AGENCIA, 1, 4)                        ,; 		// [3]Ag�ncia
			SUBSTR(A6_NUMCON,1,Len(AllTrim(A6_NUMCON))-1),; 		// [4]Conta Corrente
  			SUBSTR(A6_NUMCON,Len(AllTrim(A6_NUMCON)),1)  ,; 		// [5]D�gito da conta corrente
			"17"                                              	}	// [6]Codigo da Carteira   

	
ENDIF 

RecLock("SEA",.T.)
SEA->EA_FILIAL  := xFilial()
SEA->EA_NUMBOR  := cNumBor
SEA->EA_DATABOR := dDataBase
SEA->EA_PORTADO := cPort060
SEA->EA_AGEDEP  := cAgen060
SEA->EA_NUMCON  := cConta060
SEA->EA_NUM     := SE1->E1_NUM
SEA->EA_PARCELA := SE1->E1_PARCELA
SEA->EA_PREFIXO := SE1->E1_PREFIXO
SEA->EA_TIPO    := SE1->E1_TIPO
SEA->EA_CART    := "R"
SEA->EA_SITUACA := "1"  
SEA->EA_XUSUBOR := UsrRetName(RetCodUsr())
MsUnlock()  

RecLock("SE1",.F.)
SE1->E1_NUMBOR  := cNumBor 
SE1->E1_PORTADO := cPort060
SE1->E1_AGEDEP  := cAgen060
SE1->E1_CONTA   := cConta060
SE1->E1_DATABOR := dDataBase
SE1->E1_SITUACA := "1"
MsUnlock()

//��������������������������������������������������������������Ŀ
//� Grava o Numero do bordero atualizado						 �
//� Posicionar no sx6 sempre usando GetMv. Nao utilize Seek !!!  �
//����������������������������������������������������������������
//dbSelectArea("SX6")			// TNU - Release 25
//GetMv("MV_NUMBORR")			// TNU - Release 25
//RecLock("SX6",.F.)			// TNU - Release 25
//SX6->X6_CONTEUD := cNumbor	// TNU - Release 25
//MsUnlock()					// TNU - Release 25
PUTMV("MV_NUMBORR", cNumBor)	// TNU - Release 25

Return ""  

/*/
�����������������������������������������������������������������������������
���Programa  � BarraDV  � Autor � Geronimo B Alves    � Data � 22/04/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ���
�����������������������������������������������������������������������������
/*/
Static Function BarraDV()		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase		
Return ""                         

//////////////////////////////////////////////////////
Static Function MontaLinha()
	
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posi��es do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(_nSaldo * 100),10)
Return ""

//Calculo do Digito da Linha Digitavel
Static Function DV_LINHA()
	
		nCont  := 0
		Peso   := 2
		
		For i := Len(M->Pedaco) to 1 Step -1
			
			If M->Peso == 3
				M->Peso := 1
			Endif
			
			If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
				nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
				nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
			Else
				nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
			Endif
			
			M->Peso := M->Peso + 1
		Next
		
		M->Dezena  := Substr(Str(nCont,2),1,1)
		M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
		If M->Resto   == 10
			M->nDigito := "0"
		Else
			M->nDigito := Str(M->Resto,1)
		Endif
Return "" 

// Funcão que retorna o banco,      agencia,    conta e    emite boleto ("S/N") contido nos parametros
//////////////////////  MV_XPORTAD, MV_XAGENCI, MV_XCONTA, MV_XEMIBOL
                     
User Function BCOAGEC
Local aPortador := {"", "", "", "" }
aPortador[1] := padr(GetMV("MV_XPORTAD") , TamSX3("A6_COD")[1] )
aPortador[2] := padr(GetMV("MV_XAGENCI") , TamSX3("A6_AGENCIA")[1] )
aPortador[3] := padr(GetMV("MV_XCONTA" ) , TamSX3("A6_NUMCON ")[1] )
aPortador[4] := padr(GetMV("MV_XEMIBOL") , 1 )

Return aPortador  
