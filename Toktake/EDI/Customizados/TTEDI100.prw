#INCLUDE "rwmake.ch"            
#INCLUDE 'TBICONN.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บ Autor ณ Alexandre Venancio บ Data ณ  31/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Nova rotina para importacao de pedidos PCA e Processamento บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TTEDI100
 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private oLeTxt

Private cString := ""

If cEmpAnt <> "01"
	Return
EndIf

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SC5/SC6"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "

@ 70,098 BMPBUTTON TYPE 04 ACTION MV_PAR01 := cGetFile( '*.txt' , 'Textos (TXT)', 0, 'C:\', .T.)//, ( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ) )
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered
  
//Reset Environment

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  31/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private nHdl    := fOpen(mv_par01,68)
                                          
Private aList := {}

Private cEOL    := "CHR(13)+CHR(10)"   

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  31/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local cFilV		:=	U_VerFIL(SubStr(cNumEmp,1,2))  
Local cStatG    :=	0         
Local nLinha	:=	1         
Local cClie		:=	'' 
Local cItemC	:=	''  
Local cTabela	:=	''
Local nPrecU	:=	0
Local lPca		:= .F.
Local lPrdB		:= .F. 
Local cProdB	:=	'' 
Local nPedPca	:=	0   
Private cPedImp	:=	''
Private aNumPed	:=	NumPed()                                          
Private cMsg		:=	''    
Private aCabec	:=	{}
Private aItens	:=	{}  
Private lMsErroAuto := .F.

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado: Processamento                  บ
//ฬออออออออออออออออัออออออออัอออออออออออัอออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho   | Posicao                   บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ID_PEDIDO      ณ 001    ณ 3 	    |    01                     บ
//บ FILIAL         ณ 004    ณ 2         |    02                		บ
//บ TIPO_PEDID     ณ 006    ณ 1         |    03                		บ
//บ CLIENTE        ณ 007    ณ 6         |    04                		บ
//บ LOJA_CLIEN     ณ 013    ณ 4         |    05                		บ
//บ DATA_ENT       ณ 017    ณ 8         |    06                		บ
//บ ABASTECIME     ณ 025    ณ 1         |    07                		บ
//บ CODIGO_PA      ณ 026    ณ 6         |    08                		บ
//บ FINALIDADE     ณ 032    ณ 1         |    09                		บ
//บ FIL_DESTIN     ณ 033    ณ 2         |    10                		บ
//บ TRANSPORTA     ณ 035    ณ 6         |    11                		บ
//บ TIPO_CARGA     ณ 041    ณ 1         |    12                		บ
//บ HORA_ENTRE     ณ 042    ณ 5         |    13                		บ
//บ COND_PAGTO     ณ 047    ณ 3         |    14                		บ
//บ TABELA         ณ 050    ณ 3         |    15                		บ
//บ CC     		   ณ 053    ณ 8         |    16                		บ
//บ ITEM_CONTA     ณ 061    ณ 20        |    17                 	บ
//บ MOEDA     	   ณ 081    ณ 1         |    18             		บ
//บ TIPO_FRETE     ณ 082    ณ 1         |    19         	        บ
//บ VAL_FRETE      ณ 083    ณ 12        |    20     	            บ
//บ SEGURO     	   ณ 095    ณ 12        |    21                     บ
//บ TAXA_MOEDA     ณ 107    ณ 11        |    22                     บ
//บ DATA_EMISS     ณ 118    ณ 8     	|    23                     บ
//บ GPV            ณ 126    ณ 7 	    |    24                     บ
//บ COD_PRODUT     ณ 133    ณ 15        |    25              	    บ
//บ QTD     	   ณ 148    ณ 9         |    26          	        บ
//บ PRC_UNIT       ณ 157    ณ 13        |    27      	            บ
//บ PRC_TOTAL      ณ 170    ณ 12        |    28  	                บ
//บ VLR_UNIT       ณ 182    ณ 13        |    29                     บ
//บ VLR_DESC       ณ 195    ณ 14        |	 30                     บ
//บ OBS    		   ณ 209    ณ 99     	|    31                     บ
//บ Status Grid    ณ xxx    ณ xx     	|    32                     บ
//บ Mensagens erro ณ xxx    ณ xx     	|    33                     บ
//บ Nome Cliente   ณ xxx    ณ xx     	|    34                     บ
//บ Numero Pedido  | xxx    ณ xx     	|    35                     บ
//บ        		   ณ        ณ        	|    36                     บ
//บ        		   ณ        ณ        	|    37                     บ
//บ        		   ณ        ณ        	|    38                     บ
//บ        		   ณ        ณ        	|    39                     บ
//บ        		   ณ        ณ        	|    40                     บ
//บ        		   ณ        ณ        	|    41                     บ
//ศออออออออออออออออฯออออออออฯอออออออออออฯอออออออออออออออออออออออออออผ


//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado: PCA                            บ
//ฬออออออออออออออออัออออออออัอออออออออออัอออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho   | Posicao                   บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ID_PEDIDO      ณ 001    ณ 3 	    |    01                     บ
//บ ID_PCA         ณ 004    ณ 10        |    02                		บ
//บ FILIAL         ณ 014    ณ 2         |    03                		บ
//บ DATAS_ENT_EMIS ณ 027    ณ 8         |    04                		บ
//บ CODIGO_PA      ณ 036    ณ 6         |    05                		บ
//บ CODIGO_PRODUTO ณ 152    ณ 7         |    06                		บ
//บ QUANTIDADE     ณ 159    ณ 9         |    07                		บ
//บ TIPO_PED       ณ XXX    ณ X         |    08                		บ
//บ CLIENTE        ณ XXX    ณ X         |    09                		บ
//บ LOJA_CLIEN     ณ XXX    ณ X         |    10                		บ
//บ FINALIDADE     ณ XXX    ณ X         |    11                		บ
//บ ABASTECIMENTO  ณ XXX    ณ X         |    12                		บ
//บ NUM_PEDIDO     ณ XXX    ณ X         |    13                		บ
//บ TRANSPORTADORA ณ XXX    ณ X         |    14                		บ
//บ COND_PAGTO     ณ XXX    ณ X         |    15                		บ
//บ HORA INC       ณ XXX    ณ X         |    16                		บ
//บ GPV            ณ XXX    ณ X         |    17                		บ
//บ ITEM CONTABIL  ณ XXX    ณ X         |    18                		บ
//บ TES            ณ XXX    ณ X         |    19                		บ
//ศออออออออออออออออฯออออออออฯอออออออออออฯอออออออออออออออออออออออออออผ

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
cBuffer  := space(3)
nBtLidos := fRead(nHdl,@cBuffer,3) // Leitura da primeira linha do arquivo texto

If cBuffer == "001"
	nTamLin  := 308+Len(cEOL)
Else
	nTamLin	 := 469+Len(cEOL)
	lPca	 := .T.
EndIf

fSeek(nHdl,0,0)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar


While nBtLidos > 0 // nTamLin

    IncProc()
    If !Substr(cBuffer,001,3) $ "001/002"
		MsgAlert("O Arquivo esta fora do formato desejado, por favor verifique","TTEDI100")
		Return
	EndIf
	
	If Substr(cBuffer,001,3) == "001"
		cStatG	:=	1
		cItemC  := '' 
		nPrecU	:=	0
		
	    If !Substr(cBuffer,004,2) $ cFilV
	    	cStatG := 3  
	    	cMsg += "Filial Informada invแlida na linha "+cvaltochar(nLinha)
	    EndIf                                                               
	    
		If empty(Posicione("SA1",1,xFilial("SA1")+Substr(cBuffer,007,6)+Substr(cBuffer,013,4),"A1_NOME"))
			cMsg += chr(13)+chr(10)+"Cliente nใo encontrado na linha "+cvaltochar(nLinha)                    
			cClie := ''
		Else
			cClie := Posicione("SA1",1,xFilial("SA1")+Substr(cBuffer,007,6)+Substr(cBuffer,013,4),"A1_NOME")
		EndIf
		
		If !Substr(cBuffer,006,1) $ 'N#C#I#P#D#B#'
			cMsg += chr(13)+chr(10)+"Tipo de Pedido invแlido na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,006,1)
			cStatG := 3
		EndIf
		
		If Empty(Substr(cBuffer,017,8)) .or. CTOD(Substr(cBuffer,017,8)) < dDataBase
			cMsg += chr(13)+chr(10)+"Data de entrega do pedido invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,017,8)                                   
			cStatG := 3
		EndIf
		
		If Empty(CTOD(Substr(cBuffer,118,8))) .or. CTOD(Substr(cBuffer,118,8)) < dDataBase
			cMsg += chr(13)+chr(10)+"Data de emissใo do pedido invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,017,8)                                   
			cStatG := 3
		EndIf      
		
			/*-----------------------------------------------|
			|    			  Consiste GPV 		 		 	 |
			|-----------------------------------------------*/
			
		If Empty(Substr(cBuffer,032,1))
			cMsg += chr(13)+chr(10)+"Finalidade de venda invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,032,1)
			cStatG := 3
		EndIf
		
		If Empty(Substr(cBuffer,026,6)) .Or. Empty(Posicione("ZZ1",1,Substr(cBuffer,004,2)+Substr(cBuffer,026,6),"ZZ1_DESCRI"))
			cMsg += chr(13)+chr(10)+"C๓digo da PA invแlido ou inexistente na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,026,6)
			cStatG := 3
		EndIf    
		
		If Substr(cBuffer,032,1) == "3" .And. !Substr(cBuffer,033,2) $ cFilV
			cMsg += chr(13)+chr(10)+"Filial de Transferencia de destino invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,033,2)
			cStatG := 3
		EndIF
		
		If Empty(Posicione("SA4",1,xFilial("SA4")+Substr(cBuffer,035,6),"A4_NOME"))
			cMsg += chr(13)+chr(10)+"Transportadora invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,035,6)
			cStatG := 3
		EndIf     
		
		If Empty(Posicione("SE4",1,xFilial("SE4")+Substr(cBuffer,047,3),"E4_DESCRI"))
			cMsg += chr(13)+chr(10)+"Condi็ใo de Pagamento invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,047,3)
			cStatG := 3
		EndIf
		
		If Empty(Posicione("DA0",1,xFilial("DA0")+Substr(cBuffer,050,3),"DA0_DESCRI"))
			If Empty(Posicione("SA1",1,xFilial("SA1")+Substr(cBuffer,007,6)+Substr(cBuffer,013,4),"A1_TABELA")) 
				cMsg += chr(13)+chr(10)+"Tabela de Pre็o invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,050,3)
				cStatG := 3
			Else
				cTabela := Posicione("SA1",1,xFilial("SA1")+Substr(cBuffer,007,6)+Substr(cBuffer,013,4),"A1_TABELA")
			EndIf
		Else
			cTabela := Substr(cBuffer,050,3)
		EndIf
		
		If Empty(Posicione("CTT",1,xFilial("CTT")+Substr(cBuffer,053,8),"CTT_DESC01"))   
			cMsg += chr(13)+chr(10)+"Centro de Custo invแlido na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,053,8)
			cStatG := 3 	
		EndIf
		
		If Empty(Posicione("CTD",1,xFilial("CTD")+Substr(cBuffer,061,20),"CTD_DESC01"))
			If Empty(Posicione("ZZ1",1,Substr(cBuffer,004,2)+Substr(cBuffer,026,6),"ZZ1_ITCONT"))
		    	cMsg += chr(13)+chr(10)+"Item Contแbil invแlido na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,061,20)
		    	cStatG := 3                                                                                                       
		 	Else
		 		cItemC := Posicione("ZZ1",1,Substr(cBuffer,004,2)+Substr(cBuffer,026,6),"ZZ1_ITCONT")
		 	EndIf
		Else
			cItemC	:=	Substr(cBuffer,061,20)
	    EndIf          
	    
	    If Empty(Posicione("SB1",1,xFilial("SB1")+Substr(cBuffer,133,15),"B1_DESC"))
	    	cMsg += chr(13)+chr(10)+"C๓digo do Produto invแlido na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,133,15)
	    	cStatG := 3
	    EndIf
	    
	    If Posicione("SB1",1,xFilial("SB1")+Substr(cBuffer,133,15),"B1_MSBLQL") == "1"
		    lPrdB := .T.
		    cProdB += Substr(cBuffer,133,15)+"/"
		EndIf
		
	    If Empty(Substr(cBuffer,148,9)) .Or. Val(Substr(cBuffer,148,9)) < 1
	    	cMsg += chr(13)+chr(10)+"Quantidade digitada invแlida na linha "+cvaltochar(nLinha)+" conte๚do "+Substr(cBuffer,148,9)
	    	cStatG := 3
	    EndIf 
	    
	    
	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    //ณ Grava os campos obtendo os valores da linha lida do arquivo texto.  ณ
	    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    Aadd(aList,{Substr(cBuffer,001,3),Substr(cBuffer,004,2),Substr(cBuffer,006,1),Substr(cBuffer,007,6),Substr(cBuffer,013,4),;
	    			If(CTOD(Substr(cBuffer,017,8))<dDataBase,dDataBase,CTOD(Substr(cBuffer,017,8))),Substr(cBuffer,025,1),;
	    			Substr(cBuffer,026,6),Substr(cBuffer,032,1),Substr(cBuffer,033,2),;
	    			Substr(cBuffer,035,6),Substr(cBuffer,041,1),Substr(cBuffer,042,5),Substr(cBuffer,047,3),cTabela,;
	    			Substr(cBuffer,053,8),cItemC,val(Substr(cBuffer,081,1)),Substr(cBuffer,082,1),Val(Substr(cBuffer,083,12)),;
	    			Val(Substr(cBuffer,095,12)),Val(Substr(cBuffer,107,11)),;
	    			If(CTOD(Substr(cBuffer,118,8))<dDataBase,dDataBase,CTOD(Substr(cBuffer,118,8))),;
	    			Substr(cBuffer,126,7),Substr(cBuffer,133,15),Val(Substr(cBuffer,148,9)),;
	    			Transform(Val(Substr(cBuffer,157,13))/100,"@E 999,999,999.99"),;
	    			Transform(If(Val(Substr(cBuffer,170,12))/100>0,Val(Substr(cBuffer,170,12))/100,(Val(Substr(cBuffer,157,13))/100)*Val(Substr(cBuffer,148,9))),"@E 999,999,999.99"),;
	    			Transform(Val(Substr(cBuffer,182,13))/100,"@E 999,999,999.99"),;
	    			Transform(Val(Substr(cBuffer,195,14))/100,"@E 999,999,999.99"),;
	    			Substr(cBuffer,209,99),cStatG,cMsg,cClie,'','',''})                
	    			
	Else 
		clquery:=" SELECT C5_XIDPCA AS IMP FROM "+RetSqlName("SC5")+" "
		clquery+=" WHERE C5_XIDPCA='"+Substr(cBuffer,004,10)+"' AND D_E_L_E_T_='' "
					
		If Select("IPCA") > 0
			dbSelectArea("IPCA")
			DbCloseArea()
		EndIf								
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,clquery),"IPCA",.F.,.T.)
   	        
  		dbSelectArea("IPCA")
        
        If !Empty(IPCA->IMP)
        	MsgAlert("ID PCA jแ importado "+Substr(cBuffer,004,10)+" linha "+cvaltochar(nLinha),"TTEDI100")
		Else
			If Posicione("SB1",1,xFilial("SB1")+Substr(cBuffer,152,7),"B1_MSBLQL") == "1"
				MsgAlert("O Produto "+Substr(cBuffer,152,7)+" na linha "+cvaltochar(nLinha)+" esta bloqueado, nใo serแ possํvel importar este arquivo.","TTEDI100")
				return
			EndIf
	 		cItemC := Posicione("ZZ1",1,Substr(cBuffer,014,2)+Substr(cBuffer,036,6),"ZZ1_ITCONT")
	
			Aadd(aList,{Substr(cBuffer,001,3),Substr(cBuffer,004,10),Substr(cBuffer,014,2),;
						If(ctod(Substr(cBuffer,027,8))<dDataBase,dDataBase,ctod(Substr(cBuffer,027,8))),;
						Substr(cBuffer,036,6),;
						Substr(cBuffer,152,7),val(Substr(cBuffer,159,9))/100,'N','000001','0001','1','4','',;
						'000019','001',time(),'PCA',cItemC,''})    
		
		EndIf
    EndIf
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Leitura da proxima linha do arquivo texto.                          ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    nLinha++
    dbSkip()
EndDo                      

If lPrdB
	MsgAlert("Nใo serแ possํvel importar este arquivo pois os seguintes c๓digos estใo bloqueados no sistema"+chr(13)+chr(10)+cProdB,"TTEDI100")
	Return
EndIf

If !lPca
	//Ordenando por filial + cliente + loja + PA - para determinar os pedidos que serใo gerados.
	Asort(aList,,,{|x,y| x[2]+x[4]+x[5]+x[8] < y[2]+y[4]+y[5]+y[8]})
	//Primeiro pedido no Array
	cPedAux := aList[1,2]+aList[1,4]+aList[1,5]+aList[1,8]   
	aList[1,35] := Soma1(aNumPed[Ascan(aNumPed,{|x| x[1] = aList[1,2]}),2])
	cNumPd	:=	aList[1,35]
	aNumPed[Ascan(aNumPed,{|x| x[1] = aList[1,2]}),2] := aList[1,35]
	
	MontaCab(1)
	MontaItem(1)
	
	For nX := 2 to len(aList)
		If cPedAux != aList[nX,2]+aList[nX,4]+aList[nX,5]+aList[nX,8]
			aList[nX,35] := Soma1(aNumPed[Ascan(aNumPed,{|x| x[1] = aList[nX,2]}),2])
			cNumPd	:=	aList[nX,35]
			aNumPed[Ascan(aNumPed,{|x| x[1] = aList[1,2]}),2] := aList[nX,35]  
			cPedAux := aList[nX,2]+aList[nX,4]+aList[nX,5]+aList[nX,8]
			MontaCab(nX)
			MontaItem(nX)	
		Else
			aList[nX,35] := cNumPd
			MontaItem(nX)		
		EndIf
	Next nX
	
	//If !empty(cMsg)
	//	MsgAlert(cMsg)
	//EndIf
	
	//Chamando a tela que apresenta os pedidos que serใo importados
	u_ttedi101()                               
Else                                                                                           
	If len(aList) > 0
		//Ordenando por filial + cliente + loja + PA - para determinar os pedidos que serใo gerados.
		Asort(aList,,,{|x,y| x[3]+x[5] < y[3]+y[5]})
		//Primeiro pedido no Array
		cPedAux := aList[1,3]+aList[1,5]  
		aList[1,13] := Soma1(aNumPed[Ascan(aNumPed,{|x| x[1] = aList[1,3]}),2])
		cNumPd	:=	aList[1,13]
		aNumPed[Ascan(aNumPed,{|x| x[1] = aList[1,3]}),2] := aList[1,13]
		ImpPCA(1) 
		
		For nX := 1 to len(aList)
			If aList[nX,3]+aList[nX,5] == cPedAux
				MontIt2(nX)
		  	Else            
		  		MSExecAuto({|x,y,z|MATA410(x,y,z)},aCabec,aItens,3)
				// Mostra Erro na geracao de Rotinas automaticas
				If lMsErroAuto
					RollBackSx8()
					MostraErro()
				Else
					cPedImp += cPedAux+"/"
				EndIf 
				cPedAux := aList[nX,3]+aList[nX,5]  
				aList[nX,13] := Soma1(aNumPed[Ascan(aNumPed,{|x| x[1] = aList[nX,3]}),2])
				cNumPd	:=	aList[nX,13]
				aNumPed[Ascan(aNumPed,{|x| x[1] = aList[nX,3]}),2] := aList[nX,13]
				aCabec := {}
		  		aItens := {}
		  		ImpPCA(nX)
		  		MontIt2(nX)
		  		nPedPca++ 
		  	EndIf
		Next nX
		
		If len(aCabec) > 0 .And. len(aItens) > 0
	  		MSExecAuto({|x,y,z|MATA410(x,y,z)},aCabec,aItens,3)
			// Mostra Erro na geracao de Rotinas automaticas
			If lMsErroAuto
				RollBackSx8()
				MostraErro()
			Else
				cPedImp+=SC5->C5_NUM
			EndIf    
		EndIf
		
		If !empty(cPedImp)
			MsgAlert("Foram importados "+cvaltochar(nPedPca)+" pedidos com as seguintes numera็๕es."+chr(13)+chr(10)+cPedImp,"TTEDI100")
		EndIf
	EndIf
		
EndIf	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

fClose(nHdl)
Close(oLeTxt)

Return
                                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NumPed()

Local aArea	:=	GetArea()
Local cQuery
Local aRetorno	:=	{}

cQuery := "SELECT C5_FILIAL,MAX(C5_NUM) AS NUM FROM "+RetSQLName("SC5")
cQuery += " WHERE C5_NUM LIKE 'E%'"
cQuery += " AND D_E_L_E_T_=''"
cQuery += " GROUP BY C5_FILIAL ORDER BY C5_FILIAL"    
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("DP102TFIN.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()     
    Aadd(aRetorno,{TRB->C5_FILIAL,TRB->NUM})
	Dbskip()
EndDo

RestArea(aArea)

Return(aRetorno)             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaCab(nLinha)

Local aArea	:=	GetArea() 
Local aCab2	:= {}

Aadd(aCab2,{"C5_FILIAL"	,aList[nLinha,02] ,Nil})   //
Aadd(aCab2,{"C5_NUM"    ,aList[nLinha,35] ,Nil})
Aadd(aCab2,{"C5_TIPO"	,aList[nLinha,03] ,Nil})   //
Aadd(aCab2,{"C5_CLIENTE",aList[nLinha,04] ,Nil})  //
Aadd(aCab2,{"C5_LOJACLI",aList[nLinha,05] ,Nil})  //
Aadd(aCab2,{"C5_CLIENT"	,aList[nLinha,04] ,Nil})  //
Aadd(aCab2,{"C5_LOJAENT",aList[nLinha,05] ,Nil}) //
Aadd(aCab2,{"C5_XIDPCA"	,'' ,Nil})                //
Aadd(aCab2,{"C5_XDTENTR",aList[nLinha,06] ,Nil})  //
Aadd(aCab2,{"C5_XNFABAS",aList[nLinha,07] ,Nil})   //
Aadd(aCab2,{"C5_XCODPA"	,If(Posicione("SA1",1,xFilial("SA1")+aList[nLinha,04]+aList[nLinha,04],"A1_XPA")== "S",aList[nLinha,08],space(6)),Nil}) //
Aadd(aCab2,{"C5_XFINAL"	,aList[nLinha,09] ,Nil})          //
Aadd(aCab2,{"C5_XFLDEST",if(aList[nLinha,10]!="00",aList[nLinha,10],'') ,Nil})
Aadd(aCab2,{"C5_TRANSP"	,aList[nLinha,11] ,Nil})          //
Aadd(aCab2,{"C5_XTPCARG",aList[nLinha,12] ,Nil})
Aadd(aCab2,{"C5_XHRPREV",aList[nLinha,13] ,Nil})
Aadd(aCab2,{"C5_CONDPAG",aList[nLinha,14] ,Nil})
Aadd(aCab2,{"C5_TABELA"	,aList[nLinha,15] ,Nil})
Aadd(aCab2,{"C5_XCCUSTO",aList[nLinha,16] ,Nil})
Aadd(aCab2,{"C5_XITEMCC",aList[nLinha,17] ,Nil})
Aadd(aCab2,{"C5_MOEDA"	,aList[nLinha,18] ,Nil})
Aadd(aCab2,{"C5_FRETE"	,aList[nLinha,20] ,Nil})
Aadd(aCab2,{"C5_TXMOEDA",aList[nLinha,22] ,Nil})
Aadd(aCab2,{"C5_EMISSAO",aList[nLinha,23] ,Nil})
Aadd(aCab2,{"C5_XGPV"	,aList[nLinha,24] ,Nil})
Aadd(aCab2,{"C5_MENNOTA",aList[nLinha,31] ,Nil})
Aadd(aCab2,{"C5_ESPECI1",'UN'	 		  ,Nil})
Aadd(aCab2,{"C5_XHRINC" ,cvaltochar(TIME()),Nil})
Aadd(aCab2,{"C5_XDATINC",DATE()				,Nil})
Aadd(aCab2,{"C5_XLOCAL" ,'' ,Nil})
Aadd(aCab2,{"C5_XNOMUSR",cUserName ,Nil})
Aadd(aCab2,{"C5_XCODUSR",__cUserId 		   ,Nil})
Aadd(aCab2,{"C5_XDESCLI",Posicione("SA1",1,xFilial("SA1")+aList[nLinha,04]+aList[nLinha,05],"A1_NOME"),Nil})
Aadd(aCab2,{"C5_TPFRETE",If(aList[nLinha,19]="0","F","C") ,Nil})
Aadd(aCab2,{"C5_TIPOCLI","F" ,Nil})
Aadd(aCab2,{"C5_TIPLIB" ,'1'			  ,Nil})
Aadd(aCab2,{"C5_VEND1"  ,'000001' 		  ,Nil})
Aadd(aCab2,{"C5_XTPPAG" ,''				  ,Nil})
Aadd(aCab2,{"C5_XMESREF" ,''				  ,Nil})

Aadd(aCabec,aCab2)
			
RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaItem(nLinha)

Local aArea	:=	GetArea()
Local cOpera:=	''
Local cTes	:=	space(3)
Local nCsv	:=	0

cTpCli  := "F"
cxFinal := aList[nLinha,09]
cEPP    := Posicione("SA1",1,xFilial("SA1") + aList[nLinha,04]+aList[nLinha,05]," A1_XEPP")

cOpera  := U_TTOPERA(aList[nLinha,24],cTpCli,cxFinal,cEPP)  

If !Empty(cOpera)
	//Buscando a TES a ser informada no item do pv.
	aAreaF4 := GetArea()
	cQueryX := "SELECT FM_TS,F4_CF"
	cQueryX += " FROM "+RetSQLName("SFM")+" FM"
	cQueryX += "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=FM_FILIAL AND F4_CODIGO=FM_TS AND F4.D_E_L_E_T_=''"
	cQueryX += " WHERE FM_TIPO='"+cOpera+"' AND FM_FILIAL='"+aList[nLinha,02]+"' AND FM_GRPROD='"+Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_GRTRIB")+"' AND FM.D_E_L_E_T_=''"

	If Select('TRB2') > 0
		dbSelectArea('TRB2')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryX),"TRB2",.F.,.T.)
	dbSelectArea("TRB2")
	cTes := If(Empty(TRB2->FM_TS),space(3),TRB2->FM_TS) 
	RestArea(aAreaF4)
EndIf

If Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_TIPCONV") =="M"
	nCsv := aList[nLinha,26] * Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_CONV")
Else
	nCsv := aList[nLinha,26] / Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_CONV")
EndIf

If !Empty(cTes)
	aList[nLinha,32] := If(aList[nLinha,32]==3,2,1)
EndIf

Aadd(aItens,{{"C6_FILIAL"	,aList[nLinha,02] ,Nil},;
				{"C6_NUM"	,aList[nLinha,35] ,Nil},;
				{"C6_ITEM"	,'' ,Nil},;
				{"C6_PRODUTO",aList[nLinha,25] ,Nil},;
				{"C6_XPRDORI",aList[nLinha,25] ,Nil},;
				{"C6_QTDVEN",aList[nLinha,26] ,Nil},;
				{"C6_XQTDORI",aList[nLinha,26] ,Nil},;
				{"C6_TPOP"	,"F" ,Nil},;
				{"C6_UNSVEN",nCsv ,Nil},;
				{"C6_PRCVEN",aList[nLinha,27] ,Nil},;
				{"C6_VALOR"	,aList[nLinha,28] ,Nil},;
				{"C6_PRUNIT",aList[nLinha,27] ,Nil},;
				{"C6_TES"	,cTes 			   ,Nil},;
				{"C6_VALDESC",aList[nLinha,30] ,Nil},;
				{"C6_CLI"	,aList[nLinha,04] ,Nil},;
				{"C6_LOJA"	,aList[nLinha,05] ,Nil},;
				{"C6_LOCAL"	,aList[nLinha,08] ,Nil},;
				{"C6_CCUSTO",aList[nLinha,16] ,Nil},;
				{"C6_ITEMCC",aList[nLinha,17] ,Nil},;
				{"C6_XGPV"	,aList[nLinha,24] ,Nil},;
				{"C6_ENTREG",aList[nLinha,06] ,Nil},;
				{"C6_XDTEORI",aList[nLinha,06] ,Nil},;
				{"C6_UM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_UM") ,Nil},;
				{"C6_SEGUM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,25],"B1_SEGUM") ,Nil},;
				{"C6_XHRINC" ,TIME() ,Nil},;
				{"C6_XDATINC",DATE()		 ,Nil},;
				{"C6_XUSRINC",cUsername 	 ,Nil}})

RestArea(aArea)

Return                                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpPCA(nLinha)

Local aArea	:=	GetArea()
Local aArea	:=	GetArea() 
Local aCab2	:= {}


Aadd(aCabec,{"C5_FILIAL"	,aList[nLinha,03] ,Nil})   // 
Aadd(aCabec,{"C5_NUM"	,aList[nLinha,13] ,Nil})
Aadd(aCabec,{"C5_TIPO"	,aList[nLinha,08] ,Nil})   //
Aadd(aCabec,{"C5_CLIENTE",aList[nLinha,09] ,Nil})  //
Aadd(aCabec,{"C5_LOJACLI",aList[nLinha,10] ,Nil})  //
Aadd(aCabec,{"C5_CLIENT"	,aList[nLinha,09] ,Nil})  //
Aadd(aCabec,{"C5_LOJAENT",aList[nLinha,10] ,Nil}) //
Aadd(aCabec,{"C5_XIDPCA"	,aList[nLinha,03] ,Nil})                //
Aadd(aCabec,{"C5_XDTENTR",aList[nLinha,04] ,Nil})  //
Aadd(aCabec,{"C5_XNFABAS",aList[nLinha,11] ,Nil})   //
Aadd(aCabec,{"C5_XCODPA"	,aList[nLinha,05],Nil}) //
Aadd(aCabec,{"C5_XFINAL"	,aList[nLinha,12] ,Nil})          //
Aadd(aCabec,{"C5_XFLDEST"	,''				   ,Nil})
Aadd(aCabec,{"C5_TRANSP"	,aList[nLinha,14] ,Nil})          //
Aadd(aCabec,{"C5_XTPCARG",''				 ,Nil})
Aadd(aCabec,{"C5_XHRPREV",aList[nLinha,16] ,Nil})
Aadd(aCabec,{"C5_CONDPAG",aList[nLinha,15] ,Nil})
Aadd(aCabec,{"C5_TABELA"	,SPACE(3) ,Nil})
Aadd(aCabec,{"C5_XCCUSTO",'70500002'		   ,Nil})
Aadd(aCabec,{"C5_XITEMCC",aList[nLinha,18] ,Nil})
Aadd(aCabec,{"C5_MOEDA"	,1 ,Nil})
Aadd(aCabec,{"C5_FRETE"	,0 ,Nil})
Aadd(aCabec,{"C5_TXMOEDA",1 ,Nil})
Aadd(aCabec,{"C5_EMISSAO",aList[nLinha,04] ,Nil})
Aadd(aCabec,{"C5_XGPV"	,aList[nLinha,17] ,Nil})
Aadd(aCabec,{"C5_MENNOTA",'' ,Nil})
Aadd(aCabec,{"C5_ESPECI1",'UN'	 		  ,Nil})
Aadd(aCabec,{"C5_XHRINC" ,cvaltochar(TIME()),Nil})
Aadd(aCabec,{"C5_XDATINC",DATE()				,Nil})
Aadd(aCabec,{"C5_XLOCAL" ,aList[nLinha,05] ,Nil})
Aadd(aCabec,{"C5_XNOMUSR",cUserName ,Nil})
Aadd(aCabec,{"C5_XCODUSR",__cUserId 		   ,Nil})
Aadd(aCabec,{"C5_TPFRETE","C" ,Nil})
Aadd(aCabec,{"C5_TIPOCLI","F" ,Nil})
Aadd(aCabec,{"C5_TIPLIB" ,'1'			  ,Nil})
Aadd(aCabec,{"C5_VEND1"  ,'000001' 		  ,Nil})
Aadd(aCabec,{"C5_XTPPAG" ,''				  ,Nil})

RestArea(aArea)

Return                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontIt2(nLinha)

Local aArea		:=	GetArea()
Local cOpera	:=	''
Local cTes		:=	space(3)
Local nCsv		:=	0
Local cPreco	:= 	0     
Local nCustoD   := 	Posicione("SB1",1,xFilial("SB1")+aList[nLinha,06],"B1_CUSTD")


/*                            1                       2                   3
		Aadd(aList,{Substr(cBuffer,001,3),Substr(cBuffer,004,10),Substr(cBuffer,014,2),; 
		                                               4
					If(ctod(Substr(cBuffer,027,8))<dDataBase,dDataBase,ctod(Substr(cBuffer,027,8))),; 
					           5
					Substr(cBuffer,036,6),;   
					           6					7	         8     9       10    11  12   13     14      15    16     17     18   19
					Substr(cBuffer,152,7),Substr(cBuffer,159,9),'N','000001','0001','1','4',pedido,'000019','001',time(),'PCA',ItemCC,tes})    

*/
cTpCli  := "F"
cxFinal := aList[nLinha,12]
cEPP    := Posicione("SA1",1,xFilial("SA1")+'00000100'+aList[nLinha,03]," A1_XEPP")

cOpera  := U_TTOPERA('PCA',cTpCli,cxFinal,cEPP)  

If !Empty(cOpera)
	//Buscando a TES a ser informada no item do pv.
	aAreaF4 := GetArea()
	cQueryX := "SELECT FM_TS,F4_CF"
	cQueryX += " FROM "+RetSQLName("SFM")+" FM"
	cQueryX += "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=FM_FILIAL AND F4_CODIGO=FM_TS AND F4.D_E_L_E_T_=''"
	cQueryX += " WHERE FM_TIPO='"+cOpera+"' AND FM_FILIAL='"+aList[nLinha,03]+"' AND FM_GRPROD='"+Posicione("SB1",1,xFilial("SB1")+aList[nLinha,06],"B1_GRTRIB")+"' AND FM.D_E_L_E_T_=''"

	If Select('TRB2') > 0
		dbSelectArea('TRB2')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryX),"TRB2",.F.,.T.)
	dbSelectArea("TRB2")
	cTes := If(Empty(TRB2->FM_TS),space(3),TRB2->FM_TS) 
	RestArea(aAreaF4)
EndIf
                //{"C6_ITEM"	,'' ,Nil},; 
                
nLucro 	:= GetMv("MV_XLUCRO")
nLucrot := GetMv("MV_XLUCROT")  

If Empty(nCustoD)
	MsgAlert("Este produto nใo possui custo standard informado. Favor procurar o setor de Controladoria.","TTEDI100")								
	Return(.F.)
Else
	If SubStr(aList[nLinha,06],1,2)$("21/22") .or. aList[nLinha,12] == "3" //Se for produto acabado ou for transferencia
		cPreco := nCustoD * nLucrot //Custo Standar + Margem
	Else
		cPreco := nCustoD * nLucro  //Custo Standar + Margem
	EndIf
EndIf
 
				
Aadd(aItens,{{"C6_FILIAL"	,aList[nLinha,03] ,Nil},;
				{"C6_NUM"	,aList[nLinha,13] ,Nil},; 
				{"C6_ITEM"	,Strzero(len(aItens)+1,2) ,Nil},; 
				{"C6_PRODUTO",aList[nLinha,06] ,Nil},;
				{"C6_XPRDORI",aList[nLinha,06] ,Nil},;
				{"C6_QTDVEN",aList[nLinha,07] ,Nil},;
				{"C6_XQTDORI",aList[nLinha,07] ,Nil},;
				{"C6_TPOP"	,"F" ,Nil},;
				{"C6_PRCVEN",round(cPreco,4)	  ,Nil},;
				{"C6_VALOR"	,round(round(cPreco,4) * round(aList[nLinha,07],4),4) ,Nil},;
				{"C6_PRUNIT",round(cPreco,4)			 ,Nil},;
				{"C6_TES"	,cTes 			   ,Nil},;
				{"C6_CLI"	,'000001'		 ,Nil},;
				{"C6_LOJA"	,'0001'			 ,Nil},;
				{"C6_LOCAL"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,06],"B1_LOCPAD") ,Nil},;
				{"C6_CCUSTO",'70500002' ,Nil},;
				{"C6_ITEMCC",aList[nLinha,18] ,Nil},;
				{"C6_XGPV"	,'PCA'			 ,Nil},;
				{"C6_ENTREG",aList[nLinha,04] ,Nil},;
				{"C6_XDTEORI",aList[nLinha,04] ,Nil},;
				{"C6_UM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,06],"B1_UM") ,Nil},;
				{"C6_SEGUM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,06],"B1_SEGUM") ,Nil},;
				{"C6_XHRINC" ,TIME() ,Nil},;
				{"C6_XDATINC",DATE()		 ,Nil},;
				{"C6_XUSRINC",cUsername 	 ,Nil}})

RestArea(aArea)

Return                  