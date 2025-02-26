#Include 'Protheus.ch'
#Include 'Topconn.ch'

#define PAD_LEFT 	0
#define PAD_RIGHT 	1
#define PAD_CENTER 	2


User Function ETIQUETA_END
Local cPerg 	:= 'ETQEND'

    ValidPerg(cPerg)
    If !(Pergunte(cPerg,.T.))
	    Return
    Endif

	ETQENDER()

Return

/*/{Protheus.doc}	ACD
Etiqueta para Endereçamento do Estoque

@author			Paulo Lima 
@since			30/11/2021
@version		1.0
@return			nil
/*/

///////////////////////////////////////////////////////////////////////////////
//Impressão de Etiqueta para o endereço                                      //
///////////////////////////////////////////////////////////////////////////////
Static Function ETQENDER()

Local cPorta    := ""

cPorta:= if(mv_par04 = 1 ,"COM1:9600,n,8,1", if(mv_par04 = 2, "COM2:9600,n,8,1", "LPT1"))

dbSelectArea("SBE")   
dbSetOrder(1) // Armazem + Endereco + Estrutura                                        
if dbSeek(xFilial("SBE")+mv_par01+mv_par02)
    cEtiqueta := SBE->BE_LOCALIZ
	fRelQua(cEtiqueta)  //Visualiza Etiqueta

else
	MsgInfo("Endereço não encontrado!","Atenção")
endif

Return

/*/
*******************************************************************************************************************************
*******************************************************************************************************************************
//Função: fRelQua() - Visualização da Etiqueta                                                                               //
*******************************************************************************************************************************
*******************************************************************************************************************************
/*/
Static Function fRelQua(cAlias)

Private oFont1  		:= TFont():New("Arial",10,10,.T.	,.T.,,,,,.F.)
Private oFont2  		:= TFont():New("Arial",13,13,.T.   	,.T.,,,,,.F.)
Private oFont3  		:= TFont():New("Arial",16,16,.T.   	,.T.,,,,,.F.)
Private oPrint 			:= TMSPrinter():New("ETIQUETA ENDERECAMENTO")

Private PixelX 			:= oPrint:nLogPixelX()
Private PixelY 			:= oPrint:nLogPixelY()

Private nLin	:= 18
Private nCol1	:= 40			
Private nCol2	:= 500	
Private cEndereco:= AllTrim(SBE->BE_LOCAL)+AllTrim(SBE->BE_LOCALIZ)

oPrint:StartPage()

nLin:= 08
oPrint:Say(nLin,nCol1  ,'ARMAZEM....: '+ALLTRIM(IIF(!empty(SBE->BE_LOCAL),SBE->BE_LOCAL,'ER'))  ,oFont2)
oPrint:Say(nLin,nCol2  ,'ENDERECO...: '+ALLTRIM(SBE->BE_LOCALIZ)								,oFont2)
nLin+= 65
oPrint:Say(nLin,nCol1  ,'DESCRICAO..: '+ALLTRIM(SBE->BE_DESCRIC)	    						,oFont2)
nLin+= 65

MSBAR3("CODE128",1.5 *(300/PixelY),01.0*(299/PixelX),cEndereco,oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.029,0.5,/*lBanner*/,/*cFont*/,"C",.F.)

cEndereco:=''

oPrint:Preview()

Return

/*/
******************************************************************************************************************
******************************************************************************************************************
&& Funcao: ValidPerg(cPerg)
&& Descricao: Verifica a existencia do grupo de perguntas, caso nao exista cria.
******************************************************************************************************************
******************************************************************************************************************
/*/
Static Function ValidPerg(cPerg)

	Local sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Local        :       ","","" ,"mv_ch1", "C", 02, 0, 0, "G", "", "mv_par01",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBE","","","",""}) //SC2ACD
	aAdd(aRegs, {cPerg, "02", "Endereço     :       ","","" ,"mv_ch2", "C", 15, 0, 0, "G", "", "mv_par02",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBE","","","",""}) //SC2ACD
	aAdd(aRegs, {cPerg, "03", "Qtd.Etiquetas:       ","","" ,"mv_ch3", "N", 03, 0, 0, "G", "", "mv_par03",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","","",""})
	aAdd(aRegs, {cPerg, "04", "Porta        :       ","",""	,"mv_ch4", "C", 01, 0, 0, "C", "", "mv_par04",  "COM1","","","","","COM2","","","","","LPT1","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek (cPerg + aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(sAlias)
Return
