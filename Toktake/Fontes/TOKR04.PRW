#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"             
#include "tbiconn.ch"
#include 'ap5mail.ch'

/*/
*****************************************************************************
** Programa  : TOTR04.PRW     * Autor: Wanderley Andrade * Data: 12/01/10  **
*****************************************************************************
** Descricao : Relatorio do PickList Pedido de Venda.                      **
**             PRE-PICKLIST  SC6 PARA SC9 - Item de pedido para item       **
**             Liberacao.                                                  **
*****************************************************************************
** Modulo    : Faturamento                                                 **
*****************************************************************************
/*/

User Function TOKR04



Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
//Local titulo         := "*** P I C K   L I S T   -   P E D I D O  D E  V E N D A *** REAL X LIBERADO ***" ALTERADO EM 05/07/2010
Local titulo         := "P E D I D O  D E  V E N D A   -   REAL X LIBERADO" 
Local nLin           := 80
Local Cabec2         := " Cod.Produto.... Descricao do Produto.......... UN P. Bruto V.Cub... Qtd.Lib. Local. Lote...... Dt. Ent.  Cod.PA      Nome do PA..........  STATUS DA LIB.ESTOQUE    STATUS DA LIB.CREDITO  NOTA FISCAL/SERIE " 
Local Cabec1         := ""
Local imprime        := .T.
Local aOrd            := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""     
Private c_Eol      := "Chr(10)+Chr(13)"   
                
   
   
//Private limite           := 132
//Private tamanho          := "M"
//Private nomeprog         := "TOKR01" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo            := 18
//Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}                             

Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "TOKR04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
* Incluido layout acima devido a alteracao do escopo, solicitado pelo usuario Marcelo PCP



//Private limite           := 220
//Private tamanho          := "G"
//Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo            := 18
//Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}                        

Private nLastKey        := 0
Private c_Perg8      := "TOK04"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "TOKR04" 

Private cString := "SC9"

dbSelectArea("SC9")
dbSetOrder(1)

ValidPerg(c_Perg8)
pergunte(c_Perg8,.t.)

if MV_PAR14 = 1

	wnrel := SetPrint(cString,NomeProg,c_Perg8,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea("SD1")
dbSetOrder(1)


SetRegua(RecCount())

cQuery := "SELECT " 
cQuery += "C5_NUM, "
cQuery += "C5_EMISSAO, "
cQuery += "C5_TIPO, "
cQuery += "C5_XNFABAS, "
cQuery += "C5_XNOMUSR, "
cQuery += "C5_CLIENTE, "
cQuery += "C5_LOJACLI, "
cQuery += "C5_XCODPA, "
cQuery += "C5_XDCODPA, "
cQuery += "C5_MENNOTA, "
cQuery += "A1_NOME, "
cQuery += "A1_END, "
cQuery += "A1_BAIRRO, "
cQuery += "A1_MUN, "
cQuery += "A1_EST, "
cQuery += "A1_CEP, "
cQuery += "C6_ENTREG,  "
cQuery += "C6_PRODUTO, "
cQuery += "B1_DESC, B1_UM, B1_PESBRU, "
cQuery += "C6_QTDVEN, "
cQuery += "C6_ITEM, "
cQuery += "C6_TES,C6_PRCVEN,C6_BLQ "
cQuery += "from "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SB1")+" SB1 "
cQuery += "WHERE SC5.D_E_L_E_T_<> '*' AND SC6.D_E_L_E_T_<> '*' AND SA1.D_E_L_E_T_<> '*'AND SB1.D_E_L_E_T_<> '*'  "
cQuery += "AND C5_FILIAL = '"+xfilial("SC5")+"' "
cQuery += "AND C6_FILIAL = '"+xfilial("SC6")+"' "
cQuery += "AND B1_FILIAL = '"+xfilial("SB1")+"' "
cQuery += "AND A1_FILIAL = '"+xfilial("SA1")+"' "
cQuery += "AND C5_NUM    = C6_NUM "
cQuery += "AND A1_COD    = C5_CLIENTE "
cQuery += "AND A1_LOJA   = C5_LOJACLI "
cQuery += "AND C6_PRODUTO = B1_COD "                    
cQuery += "AND C6_ENTREG >= '"+DTOS(MV_PAR12)+"' AND C6_ENTREG <= '"+DTOS(MV_PAR13)+"' "  
cQuery += "AND C6_NUM    >= '"+MV_PAR01+"' AND C6_NUM   <= '"+MV_PAR02+"' "  
cQuery += "AND C6_PRODUTO >= '"+MV_PAR03+"' "
cQuery += "AND C6_PRODUTO <= '"+MV_PAR04+"' "   
cQuery += "AND C6_LOCAL   >= '"+MV_PAR08+"' "
cQuery += "AND C6_LOCAL   <= '"+MV_PAR09+"' "    
cQuery += "AND C5_XCODPA  >= '"+MV_PAR10+"' "  
cQuery += "AND C5_XCODPA  <= '"+MV_PAR11+"' "  
if !empty(MV_PAR15)
   cQuery += "AND C5_XNOMUSR = '"+MV_PAR15+"' "  
endif


cQuery += "order by C6_NUM,B1_DESC"  

TcQuery cQuery NEW ALIAS "TMP"
MemoWrite('C:\pasta\toke01cQuery',cQuery)

DbSelectArea("TMP")
DbGoTop()           

if MV_PAR14 = 2
   ArqExc()
   TMP->(DbCloseArea())
   return
endif
ProcRegua(TMP->(RecCount()))                   

while !eof()
	
	IncProc(TMP->(recno()))

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif


   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec1         := " PEDIDO: "+TMP->C5_NUM
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9

   Endif
    
//  cendped := LerPedEnd(TMP->C5_NUM)                              
	cendped := TMP->A1_NOME+TMP->A1_END+TMP->A1_BAIRRO+TMP->A1_MUN+TMP->A1_EST+TMP->A1_CEP  
	
	@ nLin,001 PSAY cendped 
    nLin := nLin+2

    cendpa := LerPa(TMP->C5_XCODPA)                              
	@ nLin,001 PSAY cendpa 
    nLin := nLin+2 
                 

    ccpedido := TMP->C5_NUM
   	EnvioEmail(ccpedido)   
    nvalrel      := 0.00
    ntotcub      := 0.00
    ntotvol      := 0.00         
    while !eof() .and. ccpedido = TMP->C5_NUM                                                               
	    nvolcub      := VolCub(TMP->C6_PRODUTO)
		cC5_NUM      := TMP->C5_NUM
		dC5_EMISSAO  := TMP->C5_EMISSAO
		cC5_TIPO     := TMP->C5_TIPO
		cC5_XNFABAS  := TMP->C5_XNFABAS
		cC5_XNOMUSR  := TMP->C5_XNOMUSR
		cC5_CLIENTE  := TMP->C5_CLIENTE
		cC5_LOJACLI  := TMP->C5_LOJACLI
		cC5_XCODPA   := TMP->C5_XCODPA
		cC5_XDCODPA  := TMP->C5_XDCODPA
		cC5_MENNOTA  := TMP->C5_MENNOTA
		cA1_NOME     := TMP->A1_NOME
		cA1_END      := TMP->A1_END
		cA1_BAIRRO   := TMP->A1_BAIRRO
		cA1_MUN      := TMP->A1_MUN
		cA1_EST      := TMP->A1_EST
		cA1_CEP      := TMP->A1_CEP
		dC6_ENTREG   := TMP->C6_ENTREG
		cC6_PRODUTO  := TMP->C6_PRODUTO
		cB1_DESC     := TMP->B1_DESC
		nC6_QTDVEN   := TMP->C6_QTDVEN
		cC6_ITEM     := TMP->C6_ITEM
		cC6_TES      := TMP->C6_TES 
		                
	    cB1_UM       := TMP->B1_UM 
	    cB1_PESBRU   := TMP->B1_PESBRU
	
	    ccpedido     := TMP->C5_NUM
	    cC5_MENNOTA  := TMP->C5_MENNOTA       
	    nC6_PRCVEN   := TMP->C6_PRCVEN 
	    cC6_BLQ      := TMP->C6_BLQ
	
	
        cest  := " "
        ccred := " "

            
        cQueryT := "SELECT C9_QTDLIB, "
        cQueryT += "C9_DATALIB, "
        cQueryT += "C9_NFISCAL, "
        cQueryT += "C9_SERIENF, "
        cQueryT += "C9_BLEST, "
        cQueryT += "C9_BLCRED,C9_LOCAL,C9_LOTECTL "
        cQueryT += "FROM "+RetSQLName("SC9")+" "
        cQueryT += "WHERE D_E_L_E_T_<> '*' "
        cQueryT += "AND C9_FILIAL = '"+xfilial("SC9")+"'
        cQueryT += "AND C9_PEDIDO = '"+ccpedido+"'  "
        cQueryT += "AND C9_PRODUTO = '"+cC6_PRODUTO+"' "
        cQueryT += "AND C9_ITEM = '"+cC6_ITEM+"' "
		TcQuery cQueryT NEW ALIAS "TMT"
		DbSelectArea("TMT")
        MemoWrite('C:\pasta\toke01cQueryT',cQueryT)
		                      
		if !eof()                      
			nC9_QTDLIB  := TMT->C9_QTDLIB
			dC9_DATALIB := TMT->C9_DATALIB
			cC9_NFISCAL := TMT->C9_NFISCAL
			cC9_SERIENF := TMT->C9_SERIENF
            cC9_LOCAL   := TMT->C9_LOCAL
            cC9_LOTECTL := TMT->C9_LOTECTL
            if TMT->C9_BLEST = '10'
//			cC9_BLEST   := TMT->C9_BLEST
                cC9_BLEST := "Item Faturado"
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLEST := "Liberado"
                else
                   cC9_BLEST := "Bloqueado"
                endif
            endif                  


            if TMT->C9_BLEST = '10'
                cC9_BLCRED := "Item Faturado"
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLCRED := "Liberado"
                else
                   cC9_BLCRED := "Bloqueado"
                endif
            endif                  

		else
			nC9_QTDLIB  := nC6_QTDVEN
			dC9_DATALIB := " " //TMT->C9_DATALIB
			cC9_NFISCAL := " " //TMT->C9_NFISCAL
			cC9_SERIENF := " " //TMT->C9_SERIENF
			cC9_BLEST   := "PEDIDO EM ABERTO"
			cC9_BLCRED  := "PEDIDO EM ABERTO"		
            cC9_LOCAL   := " " //TMT->C9_LOCAL
            cC9_LOTECTL := " " //TMT->C9_LOTECTL
            if cC6_BLQ = "R"
    			cC9_BLEST   := "ENCERRADO SEM NOTA"
     			cC9_BLCRED  := "ENCERRADO SEM NOTA"		
            endif
            
		endif
		TMT->(DbCloseArea())
        DbSelectArea("TMP")
            
            
            
		@ nLin,001 PSAY cC6_PRODUTO 
		@ nLin,017 PSAY cB1_DESC //,1,24)
		@ nLin,048 PSAY cB1_UM                              
		@ nLin,051 PSAY STR(cB1_PESBRU,8,2)   
		@ nLin,060 PSAY str(nvolcub,8,2)                                               
		@ nLin,069 PSAY str(nC9_QTDLIB,8,2) //"12345678"  //"TMP->C9_QTDLIB" //str(TMP->C9_QTDLIB,8,2) 
		@ nLin,078 PSAY cC9_LOCAL //"1234"   //"TMP->C9_LOCAL"
		@ nLin,085 PSAY cC9_LOTECTL //"123456" //"TMP->C9_LOTECTL"                         
	    @ nLin,096 PSAY dtoc(stod(TMP->C6_ENTREG))   
		@ nLin,106 PSAY cC5_XCODPA                                               
		@ nLin,118 PSAY cC5_XDCODPA 
	            
	    nvalrel := nvalrel+(nC9_QTDLIB*nC6_PRCVEN)
	    ntotcub := ntotcub+nvolcub
	    ntotvol := ntotvol+(cB1_PESBRU*nC9_QTDLIB)

		@ nLin,140 PSAY cC9_BLEST  //"cest"
		@ nLin,165 PSAY cC9_BLCRED //"ccred" 

		@ nLin,188 PSAY cC9_NFISCAL  //"cest"
		@ nLin,203 PSAY cC9_SERIENF  //"ccred"  
 
    	
	    nLin := nLin + 1 
	    dbSkip()                                        
        If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
              Cabec1  := " PEDIDO: "+ccpedido 
              Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
              nLin := 9
        Endif

	  enddo
	  nLin := nLin + 1 
	  @ nLin,001 PSAY "Valor Total do PickList R$: " 
	  @ nLin,033 PSAY str(nvalrel,14,2) 
	  nLin := nLin + 1 
	  @ nLin,001 PSAY "Valor Total do Peso Bruto : " 
	  @ nLin,033 PSAY str(ntotvol,14,2) 
	  nLin := nLin + 1 
	  @ nLin,001 PSAY "Valor Total do Vol.Cubico : " 
      @ nLin,033 PSAY str(ntotcub,14,2) 
   	  nLin := nLin + 2 
	  @ nLin,001 PSAY "Observacao: " 
      @ nLin,033 PSAY cC5_MENNOTA 

      nvalrel := 0.00
	  ntotcub := 0.00
	  ntotvol := 0.00
				
	  nLin := 80
EndDo                                  

TMP->(DbCloseArea())


SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
  

*----------------------------*
Static Function ValidPerg()
*----------------------------*

c_Alias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
c_Perg8 := PADR(c_Perg8,10)
aRegs:={}

Aadd(aRegs,{c_Perg8,"01","Pedido              De:","","","mv_ch1" ,"C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"02","Pedido             Ate:","","","mv_ch2" ,"C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"03","Produto             De:","","","mv_ch3" ,"C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{c_Perg8,"04","Produto            Ate:","","","mv_ch4" ,"C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{c_Perg8,"05","Tipo de Pedido        :","","","mv_ch5" ,"C",01,0,0,"C","","mv_par05","Normal","Normal","Normal"         ,"","","Dev.Compras","Dev.Compras","Dev.Compras","","","Util.Fornecedor","Util.Fornecedor","Util.Fornecedor","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"06","Nota de Abastecimento :","","","mv_ch6" ,"C",01,0,0,"C","","mv_par06","Sim","Sim","Sim"                  ,"","","Nao"        ,"Nao"        ,"Nao"        ,"","","Todas","Todas","Todas","","","","","","","","","","","","",""})
//Aadd(aRegs,{c_Perg8,"07","Pedido Liberado       :","","","mv_ch7" ,"C",01,0,0,"C","","mv_par07","Credito","Credito","Credito","","","Estoque","Estoque","Estoque","","","Ambas","Ambas","Ambas","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"07","Pedido Liberado       :","","","mv_ch7" ,"C",01,0,0,"C","","mv_par07","Credito","Credito","Credito","","","Estoque","Estoque","Estoque","","","Ambas","Ambas","Ambas","","","Nao Considera","Nao Considera","Nao Considera","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"08","Armazem Origem      De:","","","mv_ch8" ,"C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"09","Armazem Origem     Ate:","","","mv_ch9" ,"C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"10","PA                  De:","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"11","PA                 Ate:","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"12","Dtd.Entrega         De:","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"13","Dtd.Entrega        Ate:","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"14","Tipo de Geracao       :","","","mv_ch14","N",01,0,0,"C","","mv_par14","Relatorio","Relatorio","Relatorio","","","Excel"      ,"Excel"      ,"Excel"      ,"","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{c_Perg8,"15","Login do Usuario      :","","","mv_ch15","C",40,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg8+aRegs[i,2])
		RecLock("SX1", .T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(c_Alias)

Return Nil
                                  
Static Function ArqExc()

_aStruTRB2 := {}        

AADD(_aStruTRB2,{ "PRODUTO"      , "C", 15, 0}) //  15  TMP->C9_PRODUTO
AADD(_aStruTRB2,{ "DESCRICAO"    , "C", 30, 0}) //  30  TMP->B1_DESC
AADD(_aStruTRB2,{ "UM"           , "C", 02, 0}) //  02  TMP->B1_UM
AADD(_aStruTRB2,{ "PESBRUTO"     , "N", 12, 2}) //  12  STR(TMP->B1_PESBRU,12,2)
AADD(_aStruTRB2,{ "VOL_CUB"      , "N", 12, 2}) //  12  str(nvolcub,12,2)
AADD(_aStruTRB2,{ "QTD_LIB"      , "N", 12, 2}) //  12  str(TMP->C9_QTDLIB,12,2)
AADD(_aStruTRB2,{ "LOCAL"        , "C", 06, 0}) //  06  TMP->C9_LOCAL
AADD(_aStruTRB2,{ "LOTE"         , "C", 10, 0}) //  10  TMP->C9_LOTECTL
AADD(_aStruTRB2,{ "PEDIDO"       , "C", 06, 0}) //  06  TMP->C9_PEDIDO
AADD(_aStruTRB2,{ "PA"           , "C", 06, 0}) //  06  TMP->C5_XCODPA
AADD(_aStruTRB2,{ "NOME_PA"      , "C", 20, 0}) //  20  TMP->C5_XDCODPA
AADD(_aStruTRB2,{ "STATUSEST"    , "C", 30, 0}) //  20  TMP->C5_XDCODPA
AADD(_aStruTRB2,{ "STATUSCRE"    , "C", 30, 0}) //  20  TMP->C5_XDCODPA
AADD(_aStruTRB2,{ "DTENTREGA"    , "D", 8 , 0}) //  20  TMP->C5_XDCODPA 
AADD(_aStruTRB2,{ "NOTAFISCAL"   , "C", 9 , 0}) //  20  TMP->C5_XDCODPA 
AADD(_aStruTRB2,{ "SERIE"        , "C", 3 , 0}) //  20  TMP->C5_XDCODPA 



_cArq2     := CriaTrab(_aStruTRB2,.T.)
dbUseArea(.T.,,_cArq2 ,"TRB3",.T.)
DbSelectArea("TMP")
DbGoTop()                      

while !eof()

		cC01 := TMP->C6_PRODUTO
		cC02 := TMP->B1_DESC
		cC03 := TMP->B1_UM
		nC04 := TMP->B1_PESBRU  
		nC05 := VolCub(TMP->C6_PRODUTO)
		cC09 := TMP->C5_NUM
		cC10 := TMP->C5_XCODPA
		cC11 := TMP->C5_XDCODPA
		cC12 := TMP->C5_XDCODPA                  
		cC13 := TMP->C6_ENTREG
	    citem := TMP->C6_ITEM                 
	

        cQueryT := "SELECT C9_QTDLIB, "
        cQueryT += "C9_DATALIB, "
        cQueryT += "C9_NFISCAL, "
        cQueryT += "C9_SERIENF, "
        cQueryT += "C9_BLEST, "
        cQueryT += "C9_BLCRED,C9_LOCAL,C9_LOTECTL "
        cQueryT += "FROM "+RetSQLName("SC9")+" "
        cQueryT += "WHERE D_E_L_E_T_<> '*' "
        cQueryT += "AND C9_FILIAL  = '"+xfilial("SC9")+"'
        cQueryT += "AND C9_PEDIDO  = '"+cC09+"'  "
        cQueryT += "AND C9_PRODUTO = '"+cC01+"' "
        cQueryT += "AND C9_ITEM    = '"+citem+"' "
		TcQuery cQueryT NEW ALIAS "TMT"
		DbSelectArea("TMT")
        MemoWrite('C:\pasta\toke01cQueryT',cQueryT)
		                      
		if !eof()                      
			nC9_QTDLIB  := TMT->C9_QTDLIB
			dC9_DATALIB := TMT->C9_DATALIB
			cC9_NFISCAL := TMT->C9_NFISCAL
			cC9_SERIENF := TMT->C9_SERIENF
            cC9_LOCAL   := TMT->C9_LOCAL
            cC9_LOTECTL := TMT->C9_LOTECTL
            if TMT->C9_BLEST = '10'
//			cC9_BLEST   := TMT->C9_BLEST
                cC9_BLEST := "Item Faturado"
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLEST := "Liberado"
                else
                   cC9_BLEST := "Bloqueado"
                endif
            endif                  


            if TMT->C9_BLEST = '10'
                cC9_BLCRED := "Item Faturado"
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLCRED := "Liberado"
                else
                   cC9_BLCRED := "Bloqueado"
                endif
            endif                  

		else
			nC9_QTDLIB  := 0.00
			dC9_DATALIB := " " //TMT->C9_DATALIB
			cC9_NFISCAL := " " //TMT->C9_NFISCAL
			cC9_SERIENF := " " //TMT->C9_SERIENF
			cC9_BLEST   := "PEDIDO EM ABERTO"
			cC9_BLCRED  := "PEDIDO EM ABERTO"		
            cC9_LOCAL   := " " //TMT->C9_LOCAL
            cC9_LOTECTL := " " //TMT->C9_LOTECTL
		endif
		TMT->(DbCloseArea())
        DbSelectArea("TMP")

		nC06 := nC9_QTDLIB
		cC07 := cC9_LOCAL
		cC08 := cC9_LOTECTL
	    
	                      
		
    DbSelectArea("TRB3")
	RecLock("TRB3", .T.)
    TRB3->PRODUTO     := cC01   
    TRB3->DESCRICAO   := cC02
    TRB3->UM          := cC03
    TRB3->PESBRUTO    := nC04
    TRB3->VOL_CUB     := nC05
    TRB3->QTD_LIB     := nC06
    TRB3->LOCAL       := cC07
    TRB3->LOTE        := cC08
    TRB3->PEDIDO      := cC09
    TRB3->PA          := cC10
    TRB3->NOME_PA     := cC11 
    TRB3->STATUSEST   := cC9_BLEST
    TRB3->STATUSCRE   := cC9_BLCRED
    TRB3->DTENTREGA   := stod(cC13)
    TRB3->NOTAFISCAL  := cC9_NFISCAL
    TRB3->SERIE       := cC9_SERIENF

    MsUnLock()                        
    DbSelectArea("TMP")
    dbskip()
enddo  
Excel("TRB3","RESTC01")

Return
                                                                                                               

Static Function VolCub(produto6)
area6   := getarea()
cQuery6 := "SELECT B5_COMPR,B5_ESPESS,B5_LARG,B5_CEME "
cQuery6 += " FROM "+RetSQLName("SB5")+" "
cQuery6 += " WHERE D_E_L_E_T_<> '*' " 
cQuery6 += " AND B5_FILIAL = '"+xfilial("SB5")+"' "
cQuery6 += " AND B5_COD    = '"+produto6+"' "
MemoWrite('C:\pasta\TOKR999_CUB',cQuery6)

TcQuery cQuery6 NEW ALIAS "TMP6"

DbSelectArea("TMP6")
DbGoTop()                                       

ccub := TMP6->B5_COMPR*TMP6->B5_ESPESS*TMP6->B5_LARG

TMP6->(DbCloseArea())
restarea(area6)
Return(ccub)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  Excel   ³ Autor ³       TOTVS           ³ Data ³ Abr/2009  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Abre TRB no Excel.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1: Alias da tabela temporaria.                          ³±±
±±³Parametros³ ExpA2: Nome do arquivo excel a ser criado.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O arquivo TRB ja deve estar criado
Exemplo de chamada:
U_Excel("TRB","RESTC01")
*/
Static Function Excel(xAlias,xNome)

Local cPath  := " "
Local cArq   := " "            

cno   := "PICKLIST"+substr(dtos(date()),7,2)+substr(dtos(date()),5,2)+substr(dtos(date()),3,2)+subst(time(),1,2)+subst(time(),4,2)+""+subst(time(),7,2)
xNome := cno 
//Carrego o path de onde sera gerado o arquivo em excel
cPath	:= cGetFile("","Local",0,"",.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
cARQ    := ALLTRIM(cPath)+xNome+".XLS"
ARQUIVO := "\SYSTEM\"+xNome+".XLS"

DBSELECTAREA(xAlias)
  
IF FILE(ARQUIVO)
   DELETE FILE(ARQUIVO) 
ENDIF
COPY TO &ARQUIVO
//direciona o arquivo para o \temp  do path c:\windows\
IF FILE(ARQUIVO)
   COPY FILE &ARQUIVO TO &cARQ
ENDIF

//carrega o excel com o arquivo gerado, para isso, colocar o excel no path da maquina.
//WINEXEC("EXCEL "+ALLTRIM(cARQ),1)

If ! ApOleClient( 'MsExcel' ) 
	MsgAlert('MsExcel nao instalado')
	Return()
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( ALLTRIM(cARQ) ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

DBSELECTAREA(xAlias)

Return()                        


Static Function LerPa(PA6)                     
        
area6   := getarea()

cQry	:= " SELECT * "
cQry	+= " FROM "+RetSqlName("ZZ1")+" ZZ1"
cQry	+= " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
cQry	+= " AND   ZZ1_COD    = '"+PA6+"'"  
cQry	+= " and D_E_L_E_T_<> '*' "  


If Select("TM1") > 0
	dbSelectArea("TM1")
	dbCloseArea()
EndIf
MemoWrite('C:\pasta\cQryZZ1',cQry)

TCQUERY cQry NEW ALIAS "TM1"
dbSelectArea("TM1")
dbGoTop()
ct := "Endereco P.A....: "+ALLTRIM(TM1->ZZ1_COD)+" - "+ALLTRIM(TM1->ZZ1_DESCRI)+" - "+alltrim(TM1->ZZ1_END)   +" - "
ct += alltrim(TM1->ZZ1_BAIRRO)+" - "
ct += alltrim(TM1->ZZ1_MUN)   +" - "
ct += alltrim(TM1->ZZ1_EST)   +" - "
ct += alltrim(TM1->ZZ1_CEP)
 
dbCloseArea()

restarea(area6)

cret := ct
      
Return(cret)  
                         

Static Function LerPedEnd(pedido6)                     
        
area6   := getarea()
                                 

cQry	:= " SELECT C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_XCODPA,A1_COD,A1_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP " 
cQry	+= " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA1")+" SA1 " 
cQry	+= " WHERE SC5.D_E_L_E_T_<> '*' AND SA1.D_E_L_E_T_<> '*' "
cQry	+= " AND A1_FILIAL = '"+xfilial("SA1")+"'  "
cQry	+= " AND C5_FILIAL = '"+xfilial("SC5")+"'  "
cQry	+= " AND C5_NUM = '"+pedido6+"'  "
cQry	+= " AND A1_COD = C5_CLIENTE "
cQry	+= " AND A1_LOJA = C5_LOJACLI "

If Select("TM1") > 0
	dbSelectArea("TM1")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TM1"
dbSelectArea("TM1")
dbGoTop()
ct := "Endereco Cliente: "
ct += alltrim(TM1->C5_CLIENTE)+" - "
ct += alltrim(TM1->C5_LOJACLI)+" - "
ct += alltrim(TM1->A1_NOME)+" - "
ct += alltrim(TM1->A1_END)+" - "
ct += alltrim(TM1->A1_BAIRRO)+" - "
ct += alltrim(TM1->A1_MUN)+" - "
ct += alltrim(TM1->A1_EST)+" - "
ct += alltrim(TM1->A1_CEP)+""

dbCloseArea()

restarea(area6)

cret := ct
      
Return(cret)  


Static Function EnvioEmail(c6C5_NUM)   
ccusu := cusername
chtml :=" "
chtml +="  <html xmlns:o='urn:schemas-microsoft-com:office:office'"+&c_Eol
chtml +="<head>"+&c_Eol
chtml +="</head>"+&c_Eol
chtml +="<body lang=PT-BR style='tab-interval:35.4pt'>"+&c_Eol
chtml +="<div class=Section1>"+&c_Eol
chtml +="<table class=MsoNormalTable border=0 cellpadding=0 width=600 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +=" <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'>"+&c_Eol
chtml +="  <td style='padding:.75pt .75pt .75pt .75pt'>"+&c_Eol
chtml +="  <p class=MsoNormal align=center style='text-align:center'><span"+&c_Eol
chtml +="  class=style71>Impressao do Pre-Pick List</span><span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p>"+&c_Eol
chtml +="  </td>"+&c_Eol
chtml +=" </tr>"+&c_Eol
chtml +="</table>"+&c_Eol
chtml +="<table class=MsoNormalTable border=0 cellpadding=0 width=871 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +="    <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "+&c_Eol
chtml +="      <td width='867' style='padding:.75pt .75pt .75pt .75pt'> <p class=MsoNormal align=center style='text-align:center'><font face='Arial, Helvetica, sans-serif'><strong>Log "+&c_Eol
chtml +="          de impressao</strong></font><br>"+&c_Eol
chtml +="          <span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p></td>"+&c_Eol
chtml +="    </tr>"+&c_Eol
chtml +="  </table>"+&c_Eol
chtml +="  <table class=MsoNormalTable border=0 cellpadding=0 width=618 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +="    <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "+&c_Eol
chtml +="      <td width='614' style='padding:.75pt .75pt .75pt .75pt'> <p class=MsoNormal align=center style='text-align:center'><font face='Arial, Helvetica, sans-serif'><strong>Data: "+&c_Eol
chtml +="          "+dtoc(ddatabase)+" - Hora: "+time()+"</strong></font><br>"+&c_Eol
chtml +="          <span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p></td>"+&c_Eol
chtml +="    </tr>"+&c_Eol
chtml +="  </table>"+&c_Eol
chtml +="  <table border='0'>"+&c_Eol
chtml +="    <tbody>"+&c_Eol
chtml +="      <tr> "+&c_Eol
chtml +="        <td width='91'><strong><font size='2' face='Arial, Helvetica, sans-serif'>Pedido:</font></strong></td>"+&c_Eol
chtml +="        <td width='89'><font size='2' face='Arial, Helvetica, sans-serif'>"+c6C5_NUM+"</font></td>"+&c_Eol
chtml +="        <td width='85'><p><strong><font size='2' face='Arial, Helvetica, sans-serif'>Usuario Impressao</font></strong></p></td>"+&c_Eol
chtml +="        <td width='317'><font size='2' face='Arial, Helvetica, sans-serif'>"+ccusu+"</font></td>"+&c_Eol
chtml +="      </tr>"+&c_Eol
chtml +="    </tbody>"+&c_Eol
chtml +="  </table>"+&c_Eol
chtml +="  </div>"+&c_Eol
chtml +="</body>"+&c_Eol
chtml +="</html>"+&c_Eol
                                     
_cEMail := "mandre@toktake.com.br"
Connect Smtp Server GETMV("MV_RELSERV") account GETMV("MV_RELACNT") password GETMV("MV_RELPSW")
Send Mail From GETMV("MV_RELACNT") To _cEMail subject "Impressao Pre_Pick_List_3." body  chtml 
Return

                                       

/*

SELECT C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_XCODPA,A1_COD,A1_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP
FROM SC5010 SC5, SA1010 SA1
WHERE SC5.D_E_L_E_T_<> '*' AND SA1.D_E_L_E_T_<> '*'
AND A1_FILIAL = ' ' 
AND C5_FILIAL = '01' 
AND C5_NUM = '000034' 
AND A1_COD = C5_CLIENTE
AND A1_LOJA = C5_LOJACLI


SELECT ZZ1_COD,ZZ1_DESCRI,ZZ1_END,ZZ1_BAIRRO,ZZ1_MUN,ZZ1_EST,ZZ1_CEP
FROM ZZ1010 ZZ1
WHERE ZZ1.D_E_L_E_T_<> '*'  
AND ZZ1_FILIAL = '01' 
AND ZZ1_COD = 'P01070' 
