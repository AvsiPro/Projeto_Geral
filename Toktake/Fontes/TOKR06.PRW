#INCLUDE "PROTHEUS.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTOKR06   บ Autor ณ RAMON LARA FRANCO  บ Data ณ  26/01/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Produtos Faturados Por PA                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOK TAKE ALIMENTACAO LTDA                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TOKR06

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Produtos Faturados Por PA"
Local cPict         := ""
Local nLin          := 80
Local imprime       := .T.


//                               10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private Cabec1        := "Filial    PA                            NF         Serie  Emissao     Produto                                           Un                  Quantidade                    Vl Unitario                   Vl Total"
Private Cabec2        := ""
Private titulo        := "Produtos Faturados Por PA"
Private aOrd 		:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "TOKR06"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "TOK06"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "TOKR06"

Private cString := "SC5"

dbSelectArea("SC5")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

LOCAL _cQuery  := " "
Local _cProd   := " "
Local _nTotal1  := 0  
Local _nTotal2  := 0  

dbSelectArea("SC5")
dbSetOrder(1)

_cQuery := " SELECT SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_XCODPA, SC5.C5_XDCODPA, SC5.C5_NOTA,  " 
_cQuery += " SC5.C5_SERIE, SF2.F2_EMISSAO, SC6.C6_PRODUTO, SC6.C6_DESCRI,  		"
_cQuery += " SC6.C6_UM, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR 				"
_cQuery += " FROM "+retsqlname("SC5")+" SC5 ,"+retsqlname("SC6")+" SC6 ,"+retsqlname("SF2")+" SF2 
_cQuery += " WHERE SC5.C5_NUM = SC6.C6_NUM	 									"
_cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL									"
_cQuery += " AND SF2.F2_DOC = SC5.C5_NOTA										"
_cQuery += " AND SF2.F2_SERIE = SC5.C5_SERIE									"
_cQuery += " AND SC5.C5_NOTA <> ''												"
_cQuery += " AND SC5.C5_XNFABAS = '1'											"
_cQuery += " AND SC5.C5_XFINAL =  '4'											"
_cQuery += " AND SC5.C5_XCODPA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'		"
_cQuery += " AND SC5.C5_EMISSAO >= '"+DTOS(MV_PAR03)+"'							"
_cQuery += " AND SC5.C5_EMISSAO <= '"+DTOS(MV_PAR04)+"'							"
_cQuery += " AND SC5.D_E_L_E_T_ = '' 											"
_cQuery += " AND SC6.D_E_L_E_T_ = ''                          					"
_cQuery += " AND SF2.D_E_L_E_T_ = ''                                        	"
_cQuery += " ORDER BY SC5.C5_FILIAL, SC5.C5_NUM

MemoWrite("TOKR06.sql", _cQuery)

If Select("TPE") > 0
   DbSelectArea("TPE")
   DbCloseArea()
Endif

TCQUERY _cQuery NEW ALIAS "TPE"
TCSETFIELD("TPE" , "F2_EMISSAO" , 'D' , 08,0)
TCSETFIELD("TPE" , "C6_QTDVEN"  , 'N' , 14,0)  
TCSETFIELD("TPE" , "C6_PRCVEN"  , 'N' , 14,2)
TCSETFIELD("TPE" , "C6_VALOR"   , 'N' , 14,2)

DbSelectArea("TPE")
DBGOTOP()
nPag := 1

/*
If MV_PAR05 = 2
   ArqExc()
   //TPE->(DbCloseArea())
   //Return()
Endif
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_cNUM   :=  TPE->C5_NUM
                                                                        
DO WHILE TPE->(!Eof())                

   If nLin > 66 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
      nLin := 8
   Endif
    dDATE := TPE->F2_EMISSAO               
  //dDATE := STOD(TPE->F2_EMISSAO)
     IF  _cNUM  <> TPE->C5_NUM
         	nLin := nLin + 2 
			@ nLin,000 PSAY "[TOTAL EM R$: "
			@ nLin,019 PSAY  _nTotal1     Picture "@E 99,999,999.99" + "]"
			
    		nLin := nLin + 2
   	  		@ nLin,000 PSAY Repl("-",Limite)
   	  		nLin := nLin + 1
		    _nTotal1 := 0  
   		    _nTotal2 := 0  
            _cNUM := TPE->C5_NUM
    
     ENDIF

  	 nLin := nLin + 1
	 @ nLin,000 PSAY TPE->C5_FILIAL
     @ nLin,010 PSAY TPE->C5_XCODPA 
  	 @ nLin,020 PSAY TPE->C5_XDCODPA
  	 @ nLin,040 PSAY TPE->C5_NOTA
  	 @ nLin,051 PSAY TPE->C5_SERIE 
  	 //@ nLin,058 PSAY STOD(TPE->F2_EMISSAO)
  	 @ nLin,058 PSAY TPE->F2_EMISSAO
  	 @ nLin,070 PSAY TPE->C6_PRODUTO
  	 @ nLin,080 PSAY TPE->C6_DESCRI
  	 @ nLin,120 PSAY TPE->C6_UM
	 @ nLin,140 PSAY TPE->C6_QTDVEN Picture PESQPICT ("SC6","C6_QTDVEN")
 	 @ nLin,170 PSAY TPE->C6_PRCVEN Picture PESQPICT ("SC6","C6_PRCVEN")
 	 @ nLin,200 PSAY TPE->C6_VALOR  Picture PESQPICT ("SC6","C6_VALOR")
     _nTotal1 := _nTotal1 + TPE->C6_VALOR

	DbSelectArea("TPE")
	DBSKIP()
  
ENDDO 

nLin := nLin + 2 
@ nLin,000 PSAY "[TOTAL EM R$: "
@ nLin,019 PSAY  _nTotal1     Picture "@E 99,999,999.99" + "]"
				       	  		 
If MV_PAR05 = 2
   ArqExc()
   TPE->(DbCloseArea())
   //Return()
Endif

Set Device to Screen
Set Printer To
dbCommitAll()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ RAMON LARA FRANCO  บ Data ณ  03/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

   local j      := 0 
   local i      := 0       
   ssAlias      := Alias()
   cPerg        := PADR(cPerg,len(sx1->x1_grupo))
   aRegs        := {}     

   dbSelectArea("SX1")
   dbSetOrder(1)
   
   AADD(aRegs,{cPerg,"01","PA de  ?","PA de  ?","PA	de  ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZZ1","","","","",""})
   AADD(aRegs,{cPerg,"02","PA Ate ?","PA Ate ?","PA Ate ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","ZZ1","","","","",""})
   AADD(aRegs,{cPerg,"05","Data Inicial      ?","Data Inicial     ?","Data Inicial     ?","mv_ch3","D",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"06","Data Final        ?","Data Final       ?","Data Final       ?","mv_ch4","D",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"07","Tipo de Geracao   :","","","mv_ch5","N",01,0,0,"C","","mv_par05","Relatorio","Relatorio","Relatorio","","","Excel"      ,"Excel"      ,"Excel"      ,"","","","","","","","","","","","","","","","","",""})      
   
   For i := 1 to Len(aRegs)
     If !DbSeek(cPerg+aRegs[i,2])
       RecLock("SX1",.T.)
       For j := 1 to FCount()
         FieldPut(j,aRegs[i,j])
       Next
       MsUnlock()
     Endif
   Next
   DbSelectArea(ssAlias)

Static Function ArqExc()

//Excel("TPE","RESTC01")
Excel("TPE")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ  Excel   ณ Autor ณ       TOTVS           ณ Data ณ Abr/2009  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณ Abre TRB no Excel.                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA1: Alias da tabela temporaria.                          ณฑฑ
ฑฑณParametrosณ ExpA2: Nome do arquivo excel a ser criado.                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nil                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
O arquivo TRB ja deve estar criado
Exemplo de chamada:
U_Excel("TRB","RESTC01")
*/
Static Function Excel(xAlias,xNome)

Local cPath  := " "
Local cArq   := " "            

cno   := "ProdPA"+substr(dtos(date()),7,2)+substr(dtos(date()),5,2)+substr(dtos(date()),3,2)+subst(time(),1,2)+subst(time(),4,2)+""+subst(time(),7,2)
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