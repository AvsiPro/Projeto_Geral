#INCLUDE "rwmake.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ Impreltxt ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 09/08/2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Imprime os dados das notas de acordo com os parâmetros 	  ¦¦¦
¦¦¦			 ¦ informados pelo o usuário								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parâmetros¦ adados--> Dados das notas de saída                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Uso       ¦ Logística/TokeTake                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function Impreltxt(adados)

	Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2  := "de acordo com os parametros informados pelo usuario."
	Local titulo  := ""
	Local nLin    := 80
	Local imprime := .T.
	Local aOrd 	  := {}
	Private lEnd  := .F.
	Private lAbortPrint:= .F.
	Private limite     := 80
	Private tamanho    := "G"
	Private nTipo      := 18
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0  
	Private nomeprog   := "NOME"       // Nome para impressão no cabeçalho
	Private wnrel      := "Dados_Nota" // Nome para impressão em disco
	Private adadosD2:= adados
	
	wnrel := SetPrint('',NomeProg,"",@titulo,cDesc1,cDesc2,"",.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,'')
	If nLastKey == 27
	   Return
	Endif
	nTipo := If(aReturn[4]==1,15,18)
	
	/*-----------------------------------------------------------------------|
	| Processamento. RPTSTATUS monta janela com a regua de processamento.    |
	|-----------------------------------------------------------------------*/
	
	RptStatus({|| RunReport("","",Titulo,nLin) },Titulo)
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/08/11   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ¦¦¦
¦¦¦          ³ monta a janela com a regua de processamento.               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/TokeTake                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	/*------------------------------------------------------------------------|
	| SETREGUA -> Indica quantos registros serao processados para a regua ³   |
	|------------------------------------------------------------------------*/
	
	SetRegua(RecCount())
	   If nLin > 55 // salto de página.
			@ 00,00 PSAY AvalImp(220)
	      nLin := 1
	   Endif
	   For nI := 1 to Len(adadosD2)
			@nLin,01  PSay adadosD2[nI][1]  // Nota
			@nLin,14  PSay adadosD2[nI][2]  // CNPJ
			@nLin,30  PSay adadosD2[nI][3]  // Unidade de Medida
			@nLin,33  PSay adadosD2[nI][4]  // Cod. Produto
			@nLin,50  PSay adadosD2[nI][5] Picture "@E 999,999,999.99" // Quantidade
			@nLin,67  PSay adadosD2[nI][6] Picture "@E 999,999,999.99" // Total por Item
			@nLin,85  PSay adadosD2[nI][7]  // Descrição do Produto
			@nLin,120 PSay adadosD2[nI][8] Picture "@E 999,999,999.99" // Peso Líquido
			@nLin,136 PSay adadosD2[nI][9] Picture "@E 999,999,999.99" // Peso bruto
			nLin := nLin + 1					   
		Next nI
		adadosD2:={}  
	
	/*-----------------------------------------|
	|³ Finaliza a execucao do relatorio...     |
	|-----------------------------------------*/
	
	Set Device To Screen
	
	/*-------------------------------------------------------------|
	| Se impressao em disco, chama o gerenciador de impressao...   |
	|-------------------------------------------------------------*/
	
	If aReturn[5]==1
	   dbCommitAll()
	   Set Printer To
	   OurSpool(wnrel)
	Endif                                                 	
	Ms_Flush()
Return