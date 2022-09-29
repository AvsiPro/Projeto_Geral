/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ TT_TEA2  ณ Autor ณ Artur Nucci Ferrari   ณ Data ณ 04/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณOriginal  ณFA240Bordeณ Autor ณ Wagner Xavier         ณ Data ณ 21/05/93 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Monta a Tela para inclusao de guia / guiao na tabela SZT   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ lGuia  := .T. eh Guia / .F. eh Guiao                       ณฑฑ
ฑฑณ          ณ nOpcao := 3 - Inclusao                                     ณฑฑ
ฑฑณ          ณ           4 - Alteracao                                    ณฑฑ
ฑฑณ          ณ lDtrech2 := .T. dados do 2 trecho / .F. nao eh 2 trecho    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ ESPECIFICO TOK-TAKE                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function TT_TEA(c_Carteira,c_CliFor,c_Loja,c_Tipo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cDescText := IIf(c_Carteira='R','Cliente','Forncedor')
Local _cCliLj := c_CliFor+'/'+c_Loja
Local _cNome  := Space(1)
Local _cCC    := Space(1)
Local _nTotal := 0
Local c_Query,c_QueryTT
Local aCores		:= {}
Local a_Indice := {If(c_Carteira='R',"E1_VENCREA","E2_VENCREA")} 

Private a_Campos  	:= {{"Vencimento"            ,"VENCREA" ,"D",08,0,"@!",0},;
                        {"Prf"                   ,"PREFIXO" ,"C",03,0,"@!",0},;
                        {"Tํtulo"                ,"NUM"     ,"C",06,0,"@!",0},;
                        {"P"                     ,"PARCELA" ,"C",01,0,"@!",0},;
                        {"Tipo"                  ,"TIPO"    ,"C",03,0,"@!",0},;
                        {"Natureza"              ,"NATUREZ" ,"C",10,0,"@!",0},;
                        {"Descri็ใo da Natureza" ,"DESC_NAT","C",20,0,"@!",0},;
                        {"Emissใo"               ,"EMISSAO" ,"D",08,0,"@!",0},;
                        {"Valor"                 ,"SALDO"   ,"N",17,2,"@E 999,999,999,999.99",0}}


Private a_CamposB  	:= {{If(c_Carteira='R',"E1_VENCREA","E2_VENCREA") ,"Vencimento"            },;
                         {If(c_Carteira='R',"E1_PREFIXO","E2_PREFIXO") ,"Prf"                   },;
                         {"E2_NUM"     ,"Tํtulo"                },;
                         {If(c_Carteira='R',"E1_PARCELA","E2_PARCELA") ,"P"                     },;
                         {If(c_Carteira='R',"E1_TIPO","E2_TIPO")    ,"Tipo"                  },;
                         {If(c_Carteira='R',"E1_NATUREZ","E2_NATUREZ") ,"Natureza"              },;
                         {"ED_DESCRIC","Descri็ใo da Natureza" },;
                         {If(c_Carteira='R',"E1_EMISSAO","E2_EMISSAO") ,"Emissใo"               },;
                         {If(c_Carteira='R',"E1_SALDO","E2_SALDO")  ,"Valor"                 }}



If cEmpAnt <> "01"
	Return
EndIf

If Select("QUERY") > 0
	DbSelectArea("QUERY")
	DbCloseArea()
Endif
If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando dados p/ Total                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
c_QueryTT := MntQryTT(c_Carteira,c_CliFor,c_Loja)
TCQUERY c_QueryTT NEW ALIAS "QUERY"
_nTotal := QUERY->TOTAL    
If _nTotal = 0
   dbCloseArea("QUERY")
   Return _nTotal
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando dados p/ Browse                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
c_Query := MntQuery(c_Carteira,c_CliFor,c_Loja)
TCQUERY c_Query NEW ALIAS "QRY"
_cNome  := IF(c_Carteira=="R",QRY->A1_NOME,QRY->A2_NOME)
_cCC    := AllTrim(IF(c_Carteira=="R",QRY->A1_CONTA,QRY->A2_CONTA)) + " - " + AllTrim(QRY->CT1_DESC01)       
U_fQry2Trb("QRY","TRB",a_Indice,,,@a_Campos)
TRB->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 257,204 To 704,1134 Dialog oDlg Title OemToAnsi("PA/NDF em Aberto")
@ 009,006 Say OemToAnsi("Codigo/Lj") Size 16,8
@ 009,032 Get _cCliLj Size 100,10 When .F.

@ 009,158 Say OemToAnsi(_cDescText) Size 47,8
@ 009,219 Get _cNome Size 237,10 When .F.

@ 040,008 Say OemToAnsi("Conta Contแbil") Size 16,8
@ 040,032 Get _cCC    Size 237,10 When .F.

@ 210,006 Say OemToAnsi("Total") Size 16,8
@ 210,032 Get _nTotal Size 076,10 When .F.  Picture "@E 999,999,999,999.99"

@ 035,418 Button OemToAnsi("Finalizar") Size 36,16 Action Close(oDlg)
@ 055,006 To 200,456 BROWSE "TRB" FIELDS a_CamposB
Activate Dialog oDlg                                

If !Empty(c_Tipo)
   _nTotal := c_Tipo 
End

Return _nTotal


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MntQuery บ Autor ณArtur Nucci Ferrari บ Data ณ  03/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Montar as querys que vao alimentar o arquivo de trabalho.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MntQuery(c_Carteira,c_CliFor,c_Loja)

Local c_EOL := chr(13)
Local c_Qry := ""
If c_Carteira='P'
	c_Qry := "SELECT A2_NOME   AS A2_NOME " + c_EOL
	c_Qry += "	    ,A2_CGC    AS A2_CGC " + c_EOL
	c_Qry += "	    ,A2_CONTA  AS A2_CONTA " + c_EOL
	c_Qry += "	    ,CT1_DESC01 AS CT1_DESC01 " + c_EOL
	c_Qry += "	    ,E2_VENCREA AS E2_VENCREA " + c_EOL
	c_Qry += "	    ,E2_PREFIXO AS E2_PREFIXO " + c_EOL
	c_Qry += "	    ,E2_NUM     AS E2_NUM " + c_EOL
	c_Qry += "	    ,E2_PARCELA AS E2_PARCELA " + c_EOL
	c_Qry += "	    ,E2_TIPO    AS E2_TIPO " + c_EOL
	c_Qry += "	    ,E2_NATUREZ AS E2_NATUREZ " + c_EOL
	c_Qry += "	    ,ED_DESCRIC AS ED_DESCRIC " + c_EOL             //DESC_NAT
	c_Qry += "	    ,E2_EMISSAO AS E2_EMISSAO " + c_EOL
	c_Qry += "	    ,E2_SALDO   AS E2_SALDO " + c_EOL
	c_Qry += "FROM SE2010  " + c_EOL
	c_Qry += "INNER JOIN SA2010  " + c_EOL
	c_Qry += "      ON A2_COD=E2_FORNECE  " + c_EOL
	c_Qry += "      AND A2_LOJA=E2_LOJA  " + c_EOL
	c_Qry += "      AND SA2010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN SED010  " + c_EOL
	c_Qry += "      ON ED_CODIGO=E2_NATUREZ  " + c_EOL
	c_Qry += "      AND SED010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN CT1010  " + c_EOL
	c_Qry += "      ON CT1_CONTA=A2_CONTA  " + c_EOL
	c_Qry += "      AND CT1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "WHERE SE2010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "      AND E2_TIPO IN ('PA','NDF')  " + c_EOL
	c_Qry += "      AND E2_SALDO > 0  " + c_EOL
	c_Qry += "      AND E2_FORNECE='"+c_CliFor+"'  " + c_EOL
	c_Qry += "      AND E2_LOJA='"+c_Loja+"'   " + c_EOL
	c_Qry += "ORDER BY E2_VENCREA,E2_PREFIXO,E2_NUM,E2_PARCELA DESC    " + c_EOL
ElseIf c_Carteira='R'
	c_Qry := "SELECT A1_NOME   AS A1_NOME " + c_EOL
	c_Qry += "	    ,A1_CGC    AS A1_CGC " + c_EOL
	c_Qry += "	    ,A1_CONTA  AS A1_CONTA " + c_EOL
	c_Qry += "	    ,CT1_DESC01 AS CT1_DESC01 " + c_EOL
	c_Qry += "	    ,E1_VENCREA AS E1_VENCREA " + c_EOL
	c_Qry += "	    ,E1_PREFIXO AS E1_PREFIXO " + c_EOL
	c_Qry += "	    ,E1_NUM     AS E2_NUM " + c_EOL
	c_Qry += "	    ,E1_PARCELA AS E1_PARCELA " + c_EOL
	c_Qry += "	    ,E1_TIPO    AS E1_TIPO " + c_EOL
	c_Qry += "	    ,E1_NATUREZ AS E1_NATUREZ " + c_EOL
	c_Qry += "	    ,ED_DESCRIC AS ED_DESCRIC " + c_EOL  //DESC_NAT
	c_Qry += "	    ,E1_EMISSAO AS E1_EMISSAO " + c_EOL
	c_Qry += "	    ,E1_SALDO   AS E1_SALDO " + c_EOL
	c_Qry += "FROM SE1010  " + c_EOL
	c_Qry += "INNER JOIN SA1010  " + c_EOL
	c_Qry += "      ON A1_COD=E1_CLIENTE  " + c_EOL
	c_Qry += "      AND A1_LOJA=E1_LOJA  " + c_EOL
	c_Qry += "      AND SA1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN SED010  " + c_EOL
	c_Qry += "      ON ED_CODIGO=E1_NATUREZ  " + c_EOL
	c_Qry += "      AND SED010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN CT1010  " + c_EOL
	c_Qry += "      ON CT1_CONTA=A1_CONTA  " + c_EOL
	c_Qry += "      AND CT1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "WHERE SE1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "      AND E1_TIPO IN ('RA','NCC')  " + c_EOL
	c_Qry += "      AND E1_SALDO > 0  " + c_EOL
	c_Qry += "      AND E1_CLIENTE='"+c_CliFor+"'  " + c_EOL
	c_Qry += "      AND E1_LOJA='"+c_Loja+"'   " + c_EOL
	c_Qry += "ORDER BY E1_VENCREA,E1_PREFIXO,E1_NUM,E1_PARCELA DESC    " + c_EOL
End

MemoWrit("C:\TT_TEA.sql", c_Qry)

Return c_Qry


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MntQuery บ Autor ณArtur Nucci Ferrari บ Data ณ  03/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Montar as querys que vao alimentar o arquivo de trabalho.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MntQryTT(c_Carteira,c_CliFor,c_Loja)

Local c_EOL := chr(13)
Local c_Qry := ""
If c_Carteira='P'
	c_Qry := "SELECT SUM(E2_SALDO) AS TOTAL " + c_EOL
	c_Qry += "FROM SE2010  " + c_EOL
	c_Qry += "INNER JOIN SA2010  " + c_EOL
	c_Qry += "      ON A2_COD=E2_FORNECE  " + c_EOL
	c_Qry += "      AND A2_LOJA=E2_LOJA  " + c_EOL
	c_Qry += "      AND SA2010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN SED010  " + c_EOL
	c_Qry += "      ON ED_CODIGO=E2_NATUREZ  " + c_EOL
	c_Qry += "      AND SED010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN CT1010  " + c_EOL
	c_Qry += "      ON CT1_CONTA=A2_CONTA  " + c_EOL
	c_Qry += "      AND CT1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "WHERE SE2010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "      AND E2_TIPO IN ('PA','NDF')  " + c_EOL
	c_Qry += "      AND E2_SALDO > 0  " + c_EOL
	c_Qry += "      AND E2_FORNECE='"+c_CliFor+"'  " + c_EOL
	c_Qry += "      AND E2_LOJA='"+c_Loja+"'   " + c_EOL
ElseIf c_Carteira='R'                                
	c_Qry := "SELECT SUM(E1_SALDO) AS TOTAL " + c_EOL
	c_Qry += "FROM SE1010  " + c_EOL
	c_Qry += "INNER JOIN SA1010  " + c_EOL
	c_Qry += "      ON A1_COD=E1_CLIENTE  " + c_EOL
	c_Qry += "      AND A1_LOJA=E1_LOJA  " + c_EOL
	c_Qry += "      AND SA1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN SED010  " + c_EOL
	c_Qry += "      ON ED_CODIGO=E1_NATUREZ  " + c_EOL
	c_Qry += "      AND SED010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "INNER JOIN CT1010  " + c_EOL
	c_Qry += "      ON CT1_CONTA=A1_CONTA  " + c_EOL
	c_Qry += "      AND CT1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "WHERE SE1010.D_E_L_E_T_=''  " + c_EOL
	c_Qry += "      AND E1_TIPO IN ('RA','NCC')  " + c_EOL
	c_Qry += "      AND E1_SALDO > 0  " + c_EOL
	c_Qry += "      AND E1_CLIENTE='"+c_CliFor+"'  " + c_EOL
	c_Qry += "      AND E1_LOJA='"+c_Loja+"'   " + c_EOL
End

MemoWrit("C:\TT_TEAT.sql", c_Qry)

Return c_Qry





