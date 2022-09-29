#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
*****************************************************************************
** Programa  : TOTR01.PRW     * Autor: Wanderley Andrade * Data: 24/12/09  **
*****************************************************************************
** Descricao : Relatorio do PickList Pedido de Venda.                      **
**             PRE-PICKLIST                                                **
*****************************************************************************
** Modulo    : Faturamento                                                 **
*****************************************************************************
/*/

User Function TOKR03



Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "*** P I C K   L I S T   -   P E D I D O  D E  V E N D A ***" 
Local nLin           := 80
Local Cabec2         := " Cod.Produto.... Descricao do Produto.......... UN P. Bruto V.Cub... Qtd.Lib. Local. Lote...... Dt. Ent. Cod.PA Nome do PA.......... STATUS DA LIB.ESTOQUE............  STATUS DA LIB.CREDITO............ " 
Local Cabec1         := ""
Local imprime        := .T.
Local aOrd            := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""                     
   
   
//Private limite           := 132
//Private tamanho          := "M"
//Private nomeprog         := "TOKR01" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo            := 18
//Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}                             

Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "TOKR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
* Incluido layout acima devido a alteracao do escopo, solicitado pelo usuario Marcelo PCP



//Private limite           := 220
//Private tamanho          := "G"
//Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo            := 18
//Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}                        

Private nLastKey        := 0
Private c_Perg8      := "TOK03"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "TOKR01" 

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


cQuery := "SELECT SC9.R_E_C_N_O_ SC9REC,SC9.C9_PEDIDO,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO,SC9.C9_LOCAL, " 
cQuery += " SC9.C9_LOTECTL,SC9.C9_POTENCI,SC9.C9_NUMLOTE,SC9.C9_DTVALID, " 
cQuery += " SC9.C9_NFISCAL,C9_BLEST,C9_BLCRED,B1_DESC,B1_UM,C5_NUM,B1_PESBRU,C5_TIPO,C6_PRCVEN,C6_ENTREG,C6_ITEM,C6_PRODUTO, " 
cQuery += " C5_XCODPA,C5_XDCODPA,C5_MENNOTA " 
cQuery += " FROM "+RetSQLName("SC9")+" SC9,"+RetSQLName("SB1")+" SB1, "+RetSQLName("SC5")+" SC5 , "+RetSQLName("SC6")+" SC6 " 
cQuery += " WHERE SC9.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' '
cQuery += " AND   SC9.C9_FILIAL  = '"+xfilial("SC9")+"' "
cQuery += " AND   SB1.B1_FILIAL  = '"+xfilial("SB1")+"' "
cQuery += " AND   SC5.C5_FILIAL  = '"+xfilial("SC5")+"' "                                                                
cQuery += " AND   SC6.C6_FILIAL  = '"+xfilial("SC6")+"' "                                                                

cQuery += " AND   SC9.C9_PEDIDO  >= '"+MV_PAR01+"' "
cQuery += " AND   SC9.C9_PEDIDO  <= '"+MV_PAR02+"' "
cQuery += " AND   SC9.C9_PRODUTO >= '"+MV_PAR03+"' "
cQuery += " AND   SC9.C9_PRODUTO <= '"+MV_PAR04+"' "

cQuery += " AND   SC9.C9_LOCAL   >= '"+MV_PAR08+"' "
cQuery += " AND   SC9.C9_LOCAL   <= '"+MV_PAR09+"' "

cQuery += " AND   SB1.B1_COD     = SC9.C9_PRODUTO "
cQuery += " AND   SC9.C9_PEDIDO  = SC5.C5_NUM "    
cQuery += " AND   SC6.C6_PRODUTO = SC9.C9_PRODUTO " 
cQuery += " AND   SC6.C6_NUM     = SC9.C9_PEDIDO "
cQuery += " AND   SC6.C6_ITEM    = SC9.C9_ITEM "
                                     
if mv_par07 < 4
	If mv_par07 == 2 .Or. mv_par07 == 3
		cQuery += " AND SC9.C9_BLEST  = '  '"
	EndIf
	If mv_par07 == 1 .Or. mv_par07 == 3
		cQuery += " AND SC9.C9_BLCRED = '  '"
	EndIf                                                                                        
endif
*
if !empty(MV_PAR15)
   cQuery += " AND   SC5.C5_XNOMUSR = '"+MV_PAR15+"' "  
endif
*              
if mv_par06 < 3
	if MV_PAR06 = 1
	  cQuery += " AND   SC5.C5_XFINAL = '4' "  
	endif          
endif
*
cQuery += " AND   SC5.C5_XCODPA >= '"+MV_PAR10+"' "  
cQuery += " AND   SC5.C5_XCODPA <= '"+MV_PAR11+"' "  
*
if mv_par05 = 1
    cQuery += " AND   SC5.C5_TIPO = 'N' "  
else
    if mv_par05 = 2                                                    
       cQuery += " AND   SC5.C5_TIPO = 'D' "
    else
       cQuery += " AND   SC5.C5_TIPO = 'B' "
    endif                                                          
endif
*
cQuery += " AND   SC6.C6_ENTREG >= '"+DTOS(MV_PAR12)+"' "  
cQuery += " AND   SC6.C6_ENTREG <= '"+DTOS(MV_PAR13)+"' "  
*
      
cQuery += " ORDER BY C9_PEDIDO,C9_PRODUTO"

MemoWrite('C:\pasta\TOKR01_V2',cQuery)

TcQuery cQuery NEW ALIAS "TMP"

DbSelectArea("TMP")
DbGoTop()                                       
ProcRegua(TMP->(RecCount()))                   

if MV_PAR14 = 2
   ArqExc()
   TMP->(DbCloseArea())
   return
endif

                                                
nvalrel := 0.00
ntotcub := 0.00
ntotvol := 0.00

While !EOF()
	
	IncProc(TMP->(recno()))

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif


   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec1         := " PEDIDO: "+TMP->C9_PEDIDO
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9

   Endif
                       
    ccpedido := TMP->C9_PEDIDO
    nvalrel  := 0.00
    ntotcub  := 0.00
    ntotvol  := 0.00         
    cC5_MENNOTA  := TMP->C5_MENNOTA


    cendped := LerPedEnd(TMP->C9_PEDIDO)                              
	@ nLin,001 PSAY cendped 
    nLin := nLin+2

    cendpa := LerPa(TMP->C5_XCODPA)                              
	@ nLin,001 PSAY cendpa 
    nLin := nLin+2 
                 


    while !eof() .and. ccpedido = TMP->C9_PEDIDO                                                               
	    nvolcub := VolCub(TMP->C9_PRODUTO)

        cest  := " "
        ccred := " "

		if TMP->C9_BLEST = "  "
           cest      := "LIBERADO ESTOQUE"
        else
           if TMP->C9_BLEST = '10'
	           cest  := "PEDIDO FATURADO"   
	       else
		       cest  := "PEDIDO BLOQUEADO POR ESTOQUE"
		   endif   
        endif    
//           4- C9_BLCRED = "  " -> LIBERADO
//	         "01" -> BLOQUEADO POR CREDITO
//	         "04" -> LIMITE DE CREDITO VENCIDO
//	         "05" -> LIMITE DE CREDITO POR ESTORNO
//	         "06" -> BLOQUEADO POR RISCO
//	         "09" -> BLOQUEIO DE CREDITO POR REJEICAO
//	         "10" -> PEDIDO FATURADO

        if TMP->C9_BLCRED = "  "
            ccred := "LIBERADO CREDITO"
        else
            if TMP->C9_BLCRED = "10"
               ccred := "PEDIDO FATURADO" 
            else 
               ccred := "PEDIDO BLOQUEADO POR CREDITO" 
            endif
        endif  
                      
        
            
		@ nLin,001 PSAY TMP->C9_PRODUTO 
		@ nLin,017 PSAY TMP->B1_DESC //,1,24)
		@ nLin,048 PSAY TMP->B1_UM                              
		@ nLin,051 PSAY STR(TMP->B1_PESBRU,8,2)   
		@ nLin,060 PSAY str(nvolcub,8,2)                                               
		@ nLin,069 PSAY str(TMP->C9_QTDLIB,8,2) 
		@ nLin,078 PSAY TMP->C9_LOCAL
		@ nLin,085 PSAY TMP->C9_LOTECTL                         
	    @ nLin,096 PSAY dtoc(stod(TMP->C6_ENTREG))   
		@ nLin,106 PSAY TMP->C5_XCODPA                                               
		@ nLin,118 PSAY TMP->C5_XDCODPA 
	            
	    nvalrel := nvalrel+(TMP->C9_QTDLIB*TMP->C6_PRCVEN)
	    ntotcub := ntotcub+nvolcub
	    ntotvol := ntotvol+(TMP->B1_PESBRU*TMP->C9_QTDLIB)

		@ nLin,150 PSAY cest
		@ nLin,185 PSAY ccred 

	
	    nLin := nLin + 1 
	    dbSkip()                                        
        If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
              Cabec1  := " PEDIDO: "+TMP->C9_PEDIDO
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

_cArq2     := CriaTrab(_aStruTRB2,.T.)
dbUseArea(.T.,,_cArq2 ,"TRB3",.T.)
DbSelectArea("TMP")
DbGoTop()                      

while !eof()

	cC01 := TMP->C9_PRODUTO
	cC02 := TMP->B1_DESC
	cC03 := TMP->B1_UM
	nC04 := TMP->B1_PESBRU  
	nC05 := VolCub(TMP->C9_PRODUTO)
	nC06 := TMP->C9_QTDLIB
	cC07 := TMP->C9_LOCAL
	cC08 := TMP->C9_LOTECTL
	cC09 := TMP->C9_PEDIDO
	cC10 := TMP->C5_XCODPA
	cC11 := TMP->C5_XDCODPA
	cC12 := TMP->C5_XDCODPA                  
	cC13 := TMP->C6_ENTREG
	                                     
        cest  := " "
        ccred := " "

		if TMP->C9_BLEST = "  "
           cest      := "LIBERADO ESTOQUE"
        else
           if TMP->C9_BLEST = '10'
	           cest  := "PEDIDO FATURADO"   
	       else
		       cest  := "PEDIDO BLOQUEADO POR ESTOQUE"
		   endif   
        endif    
	                      
        if TMP->C9_BLCRED = "  "
            ccred := "LIBERADO CREDITO"
        else
            if TMP->C9_BLCRED = "10"
               ccred := "PEDIDO FATURADO" 
            else 
               ccred := "PEDIDO BLOQUEADO POR CREDITO" 
            endif
        endif  
	                      
		
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
    TRB3->STATUSEST   := cest
    TRB3->STATUSCRE   := ccred
    TRB3->DTENTREGA   := stod(cC13)
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
