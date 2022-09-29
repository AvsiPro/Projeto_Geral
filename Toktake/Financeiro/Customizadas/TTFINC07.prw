#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"  
#include "topconn.ch" 
#include "rwmake.ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC07  บAutor  ณAlexandre Venancio  บ Data ณ  08/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Geracao do bordero de cnab automaticamente atraves da     บฑฑ
ฑฑบ          ณimpressao da danfe.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC07(sSerie, nNfIni, nNfFim) 
                
Local lRet		:=	.F.                           
Private nNumBord := __Soma1(GETMV("MV_NUMBORR"))
Private lVerflimite :=.T.           
Private nNumBco:=""                 
Private nNossoNum :=""
Private nNNumAtual:=0
private nCount :=0                              
Private nDescrInf:="" 
Private cBuscaBC:=""
Private cDescrBc:="" 
Private lDisOper:=.F.
//private cAliasBord:="SEEBORD"
	
BeginSql Alias 'AlsBord'
SELECT A1_BCO1, E1_PARCELA, E1_TIPO, E1_NUM, E1_PREFIXO, E1_VALOR, EE_AGENCIA, EE_CONTA, EE_SUBCTA, EE_FAXFIM, EE_FAXATU, EE_OPER
FROM %Table:SA1% SA1, %Table:SE1% SE1, %Table:SEE% SEE
WHERE SA1.%notdel% AND
SE1.%notdel% AND
SEE.%notdel% AND
//A1_PROTEST <> %Exp:'N'% AND
E1_FILIAL = A1_FILIAL AND
E1_CLIENTE = A1_COD AND
E1_LOJA = A1_LOJA AND    
E1_PREFIXO = %Exp:sSerie% AND 
E1_NUM >= %Exp:Strzero(nNfIni,9)% AND
E1_NUM <= %Exp:Strzero(nNfFim,9)% AND 
E1_VENCREA >= %Exp:DataValida(DDatabase)% AND
E1_EMISSAO = %Exp:DDatabase% AND
A1_BCO1 <> %Exp:''% AND
E1_NUMBCO = %Exp:''% AND
E1_PORTADO = %Exp:''% AND
E1_NUMBOR = %Exp:''%  AND
A1_BCO1 = EE_CODIGO AND
EE_FILIAL = %xFilial:SEE% AND
E1_TIPO = %Exp:'NF '% AND
E1_SALDO > %Exp:0% 
//AND
//EE_MSBLQL <> %Exp:'1'% AND 
//EE_UBOLELS = %Exp:'1'% 
ORDER BY EE_FILIAL,A1_BCO1,E1_PREFIXO,E1_NUM,E1_PARCELA 
EndSql	

DbSelectArea("AlsBord")                                                              
IF !EOF()
	LjMsgRun("Gerando border๔(s). A G U A R D E !!! ","",{||lRet := ProcAlsBord()})
EndIF	

//Fechando a Tabela
DbSelectArea("AlsBord") 
AlsBord->(DbCloseArea())
                       
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC07  บAutor  ณMicrosiga           บ Data ณ  05/22/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcAlsBord()
                   
Local lRet 	:=	.F.
DbSelectArea("AlsBord") 

Begin Transaction
While !EOF()
	nCount +=1
	nNNumAtual :=(VAL(AlsBord->EE_FAXATU)+ nCount)
	nNumBco := AlsBord->A1_BCO1

	// Verificando os Limites
     IF lVerflimite .AND. (VAL(AlsBord->EE_FAXATU)+1000) > VAL(AlsBord->EE_FAXFIM)
     	lVerflimite:=.F.
     	MsgBox("Existe apenas "+Alltrim(STR(VAL(AlsBord->EE_FAXFIM) - VAL(AlsBord->EE_FAXATU)))+" n๚mero(s) de Nosso N๚mero para o Banco: "+AlsBord->A1_BCO1+". Avise o Dep. de T.I.","Informativo","ALERT")
     EndIF 
     
     IF nNNumAtual > VAL(AlsBord->EE_FAXFIM)
     	 	MsgBox(" O nosso n๚mero para o banco "+AlsBord->A1_BCO1+" se esgotou, o processo nใo continuarแ. AVISE IMEDIATAMENTE o Dep. de T.I.","PROBLEMA NOSSO NฺMERO","STOP")
			lDisOper:= DisarmTransaction()   
	   		Exit  //Sai do While	 	
     EndIF

	// Calculando o digito verificador do Nosso N๚mero
		//nNossoNum := (DigVerfNSNum(Alltrim(AlsBord->A1_BCO1), Alltrim(AlsBord->EE_AGENCIA), Alltrim(AlsBord->EE_CONTA), Alltrim(AlsBord->EE_SUBCTA), + Alltrim(STRZERO(nNNumAtual,11))))
		nNossoNum := Strzero(Val(Alltrim(AlsBord->EE_FAXATU))+1,12)
		nCalcNrBanc  := Alltrim(nNossoNum)
		cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
		cNossoNum 	:= Alltrim(nNossoNum) + Alltrim(str(cDVNrBanc))
	
	// Chamando a Rotina para grava็ใo
	 //	LjMsgRun("Gerando bordero: Nบ "+nNumBord +" para "+AlsBord->EE_OPER ,"",{||ProcBordero()})
		ProcBordero()
	
	DbSelectArea("AlsBord")
	//Salvando as Variaveis
	cDescrBc := AlsBord->EE_OPER 
	cBuscaBC := AlsBord->(A1_BCO1+EE_AGENCIA+EE_CONTA+EE_SUBCTA)
	DbSelectArea("AlsBord")
	DbSkip()
		//Verificando os borderos gerados
	    IF !AlsBord->A1_BCO1 == nNumBco .OR. EOF()
        	// Fazendo um historico
        	nDescrInf +=" Border๔ nบ "+nNumBord+" gerado para "+ cDescrBc +" ." + chr(13)+chr(10)
			//Retornando as Variaveis
   			lVerflimite:=.F.
			nNumBord := IIF(!EOF(),__Soma1(nNumBord),nNumBord)
	   	      ProcSEE(nCount)//Atualizando nosso n๚mero no cadastro
	   	     nCount := 0 
	   	    DbSelectArea("AlsBord")   
  		EndIF
Enddo 

End Transaction

IF !Empty(nDescrInf) .AND. !lDisOper
		Putmv("MV_NUMBORR",nNumBord)
   	 	//MsgBox(nDescrInf,"Borderos gerados com Sucesso!","INFO")
   	 	lRet := .T.
ElseIF lDisOper  // Sginifica que deu algum problema e a opera็ใo foi desarmada
   		//MsgBox("Houve problema na gera็ใo dos boletos: "+chr(13)+chr(10)+nDescrInf+chr(13)+chr(10)+" Informe o Dep. de T.I.","Borderos NยO Gerados!","STOP") 	 	
		lRet := .F.
EndIF

Return(lRet)



Static function ProcBordero()   
// grava dados do bordero no titulo
DbSelectArea("SE1")
DbSetOrder(1)
IF dbSeek(xFilial("SE1")+AlsBord->(E1_PREFIXO+E1_NUM+E1_PARCELA))
          RecLock("SE1",.F.)
          SE1->E1_PORTADOR := AlsBord->A1_BCO1
          SE1->E1_AGEDEP   := AlsBord->EE_AGENCIA
          SE1->E1_CONTA    := AlsBord->EE_CONTA
          SE1->E1_NUMBOR   := nNumBord
          SE1->E1_DATABOR  :=Iif (dDataBase < SE1->E1_EMISSAO,SE1->E1_EMISSAO,dDatabase) 
          SE1->E1_MOVIMEN  :=Iif (dDataBase < SE1->E1_EMISSAO,SE1->E1_EMISSAO,dDatabase) 
          SE1->E1_SITUACA  :=Iif(AlsBord->A1_BCO1 == "237","3","5") 
          SE1->E1_NUMBCO   := cNossoNum   
          //SE1->E1_SITCOBR  :="01"
          //SE1->E1_PERCSOL  :=100 
          MsUnlock()
          // grava dados do bordero no arquivo Titulos enviados ao Banco
//              SEA->EA_FILIAL  :=SPACE(02)
          DbSelectArea("SEA")
          DbSetOrder(1)
          RecLock("SEA",.T.)
   	      SEA->EA_NUMBOR  := nNumBord
          SEA->EA_PREFIXO := AlsBord->E1_PREFIXO
          SEA->EA_NUM     := AlsBord->E1_NUM
          SEA->EA_PARCELA := AlsBord->E1_PARCELA
          SEA->EA_TIPO    := AlsBord->E1_TIPO      
          SEA->EA_PORTADOR:= AlsBord->A1_BCO1
          SEA->EA_AGEDEP  := AlsBord->EE_AGENCIA
          SEA->EA_NUMCON  := AlsBord->EE_CONTA
          SEA->EA_DATABOR :=Iif (dDataBase < SE1->E1_EMISSAO,SE1->E1_EMISSAO,dDatabase) //dDATABASE
          SEA->EA_SITUACA :=Iif(AlsBord->A1_BCO1=="237","3","1")  
          SEA->EA_CART    :="R"        
          //SEA->EA_UNCART  :=AlsBord->EE_SUBCTA
          SEA->EA_FORNECE :=SPACE(06)
          SEA->EA_LOJA    :=SPACE(02)
          SEA->EA_TRANSF  :="S"
          MsUnlock()                  
 EndIf                                 
Return()  

Static function ProcSEE(QtdGer)
	 DbSelectArea("SEE")
     DbSetOrder(1) 
     IF DbSeek(xFilial("SEE")+cBuscaBC)
    	RecLock("SEE",.F.)
	      SEE->EE_FAXATU := Strzero((Val(SEE->EE_FAXATU)+QtdGer),len(Alltrim(SEE->EE_FAXATU)))
	    MsUnlock()  
     EndIF    
Return()

Static Function DigVerfNSNum(cBanco, cAgencia, cConta, cCarteira, cNosNum) 
Local _Ret:=""   
Do Case
	Case cBanco == "237" // Bradesco
	    _Ret := cNosNum + CalcDigNNum(11,cCarteira+cNosNum,{7,6,5,4,3,2},"P",.T.,.F.)
	Case cBanco == "001" //Banco Brasil
		_Ret := cNosNum + CalcDigNNum(11,cNosNum,{2,3,4,5,6,7,8,9},"X",.F.,.F.)
	Case cBanco == "341"// Banco Ita๚
		_Ret := cNosNum + CalcDigNNum(10,cAgencia+substr(cConta,1,5)+cNosNum,{1,2},"0",.T.,.T.)
EndCase   
  
_Ret := Alltrim(_Ret)
Return(_Ret)

Static Function CalcDigNNum(nDiv,nNumero,aPeso,cLetra,lSubr,lSomaDec) 
/*Fun็ใo CalcDigNNum
Param๊tros
nDiv : modulo de calculo da fun็ใo Modulo 10 ou 11
nNumero : N๚mero para calculo da fun็ใo
aPeso : Array contendo sequencia e base de calculo  
cLetra : na composi็ใo do digito for de 2 digitos substitui por essa letra  
lSubr : Utiliza o metodo de substra็ใo (.t.) ou o MOD (.f.) somente.
lSomaDec : Soma sequ๊ncia decimal. Ex 8 x 2 = 16 soma esse valor(.F.) ou soma 7 (1 + 6)(.T.)
*/
	LOCAL nCnt   := 0,;
	cDigito  := 0,;
	nSoma  := 0,;
	nBase  := 0,;
	nVlrSoma := 0

	nBase := Len(aPeso)+1

	FOR nCnt := Len(nNumero) TO 1 STEP -1
		nBase := IF(--nBase = 0,Len(aPeso),nBase)  
		nVlrSoma := Val(SUBS(nNumero,nCnt,01)) * aPeso[ nBase ]  
		nSoma += IIF (nVlrSoma >=10 .AND. lSomaDec,(Val(Subs(Alltrim(STR(nVlrSoma)),1,1)) + Val(Subs(Alltrim(STR(nVlrSoma)),2,1))), nVlrSoma )
	NEXT
	cDigito := IIF(lSubr, nDiv - (nSoma % nDiv), (nSoma % nDiv))

	DO CASE
		CASE cDigito = 11 // Somente entrarแ nessa condi็ใo se lSubr for igual a .t. e a variavel nDiv =11
			cDigito := "0"
		CASE cDigito = 10 .AND. !Empty(cLetra)
			cDigito := cLetra
		OTHERWISE
			cDigito := STR( cDigito, 1, 0 )
	ENDCASE
RETURN(cDigito)   



Return()                                    

Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
    D := 0
Else
    D := (11 - R)
End              

Return(D)

