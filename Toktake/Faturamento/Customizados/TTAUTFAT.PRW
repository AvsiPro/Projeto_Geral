#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/* 
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAUTFAT    บAutor  ณJosue Izidio    บ Data ณ   29/07/10      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณ Gerar Arquivo txt Documentos de Saida utilizando registros das บฑฑ
ฑฑบ      ณ tabelas: SF2 -Documentos de Saidas                             บฑฑ
ฑฑบ                 SD2 -Itens dos documentos de Saida                    บฑฑ
ฑฑบ                 SA1 -Cadastro de clientes                             บฑฑ        
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Scheduler                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTAUTFAT(cDoc,cSerie,cCliente,cLoja)

Private cEOL      := "CHR(13)+CHR(10)"
Private cDirSrv    := "Z:\" //Alltrim(SuperGETMV('MV_TXTFAT1')) 
Private cDirCli    := "Z:\" //Alltrim(SuperGETMV('MV_TXTFAT2')) 
 
dbSelectArea("SA1")          
dbSetOrder(1)

Private cArqTxt  :=  cDirSrv+"sai"+cDoc+Alltrim(cSerie)+cCliente+cLoja+".TXT" //"SAI"+StrZero(Day(dDataBase),2)+StrZero(Month(dDataBase),2)+StrZero(Year(dDataBase),4)+".TXT"      

If cEmpAnt == "10"
	Return
EndIf

cQuery := " SELECT F2_DOC,
cQuery += "F2_SERIE,"
cQuery += "F2_FILIAL,"
cQuery += "D2_FILIAL,"
cQuery += "A1_FILIAL,"
cQuery += "F2_EMISSAO,"
cQuery += "F2_HORA, "
cQuery += "F2_VALBRUT,"
cQuery += "F2_VALMERC,"
cQuery += "F2_MOEDA, "
cQuery += "F2_DTEXPOR,"
cQuery += "F2_EXPORTO,  "
cQuery += "F2_CLIENTE,"
cQuery += "F2_LOJA,  "
cQuery += "D2_DOC,   "
cQuery += "D2_SERIE, "
cQuery += "D2_PEDIDO,"
cQuery += "D2_COD,   "
cQuery += "D2_QUANT, " 
cQuery += "D2_PRCVEN, "
cQuery += "D2_TOTAL, "
cQuery += "D2_TES,   "
cQuery += "D2_ITEM,   "
cQuery += "A1_COD ,    "
cQuery += "A1_LOJA ,    "
cQuery += "F2_XCODPA	"
//cQuery += ",A1_CONTRAT    "
cQuery += " FROM "
cQuery += RetSqlName('SF2') + " SF2 , "
cQuery += RetSqlName('SD2') + " SD2 , "
cQuery += RetSqlName('SA1') + " SA1   "
cQuery += "   WHERE  "
cQuery += " A1_FILIAL = '" +xFilial("SA1")+ "' AND "
cQuery += " F2_FILIAL = '" +xFilial("SF2")+ "' AND "
cQuery += " D2_FILIAL = '" +xFilial("SD2")+ "' AND "
cQuery += " A1_FILIAL = '" +xFilial("SA1")+ "' AND "
cQuery += " F2_DTEXPOR  = ' '                  AND "
cQuery += " D2_DOC   =  F2_DOC                 AND "
cQuery += " D2_SERIE =  F2_SERIE               AND "
cQuery += " F2_DOC ='"+cDoc+"' AND F2_SERIE='"+cSerie+"' AND F2_CLIENTE='"+cCliente+"' AND F2_LOJA='"+cLoja+"' AND"
cQuery += " A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND"
cQuery += " SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*'  "
cQuery += " ORDER BY F2_DOC,D2_DOC,D2_ITEM "

TCQuery cQuery Alias TC1 New
dbSelectArea("TC1")

If TC1->(!EOF())

   nHdl     := fCreate(UPPER(cArqTxt))

   If Empty(cEOL)
      cEOL := CHR(13)+CHR(10)
   Else
      cEOL := Trim(cEOL)
      cEOL := &cEOL
   Endif

   If nHdl == -1
        Conout("O arquivo de nome "+Substr(cArqTxt,Len(cDirSrv)+1,Len(cArqTxt)-Len(cDirSrv))+" nao pode ser executado! Verifique os parametros.")
   Else
      Processa({|| AUTFAT002() },"Processando Documento de Saidas...")  
   Endif
Else
        Conout("Nใo Ha dados para gerar o arquivo"+Substr(cArqTxt,Len(cDirSrv)+1,Len(cArqTxt)-Len(cDirSrv))+"!  Verifique os parametros.")
Endif   
TC1->(DBCloseArea())
Return

******************************************
Static Function AUTFAT002()
*******************************************
Private nTamLin, cLin, cCpo, Risco,nPos                              
ProcRegua(RecCount()) // Numero de registros a processar

Private nTamLin1 := 142
Private nTamLin2 := 084
Private cDocAnt := Space(09)
Private cSerAnt := Space(03)

cLimi   := "!#"

cLin    := Space(nTamLin1)+cEOL // Variavel para criacao da linha do registros para gravacao
While !EOF()   

    IncProc()


    cDocAnt := TC1->F2_DOC
    cSerAnt := TC1->F2_SERIE

    cLin    := Space(nTamLin1)+cEOL // Variavel para criacao da linha do registros para gravacao

    If (Empty(TC1->F2_DTEXPOR))  .Or. (TC1->F2_DTEXPOR == DTOS(dDataBase))       
       cCpoI := 'I' //IDENTIFICADOR I = INCLUSAO 
    Else
       cCpoI := 'A' //IDENTIFICADOR A = ALTERACAO                                   
    Endif   

    cLin := Stuff(cLin,01,01,cCpoI) // IDENTIFICADOR 01

    cLin := Stuff(cLin,02,02,cLimi)  //"!#"

    cLin := Stuff(cLin,04,01,"C") // IDENTIFICADOR 01

    cLin := Stuff(cLin,05,02,cLimi)  //"!#"
    
    cCpo := PADR(TC1->F2_DOC,09)     //DOCUMENTO 09
    cLin := Stuff(cLin,07,09,cCpo)

    cLin := Stuff(cLin,16,02,cLimi) //"!#"
      
    cCpo := PADR(TC1->F2_SERIE,03)     //SERIE 03
    cLin := Stuff(cLin,18,03,cCpo)

    cLin := Stuff(cLin,21,02,cLimi) //"!#"
     //Posicione("SA1",1,xFilial("SA1")+TC1->F2_CLIENTE+TC1->F2_LOJA,"A1_CONTRAT")
    cCpo := PADR(TC1->F2_CLIENTE,10)     //CONTRATO 10
    cLin := Stuff(cLin,23,06,cCpo)

    cLin := Stuff(cLin,29,02,cLimi)//"!#"
    
    cCpo := PADR(TC1->F2_LOJA,10)
    cLin := Stuff(cLin,31,04,cCpo)
       
    cLin := Stuff(cLin,35,02,cLimi)//"!#"
   
    cCpo := PADR(TC1->F2_EMISSAO,08)     //DATA EMISSAO 08
    cLin := Stuff(cLin,37,08,cCpo)

    cLin := Stuff(cLin,45,02,cLimi)//"!#"

    cCpo := PADR(TC1->F2_HORA,05)     //HORA CARACTER 05
    cLin := Stuff(cLin,48,05,cCpo)

    cLin := Stuff(cLin,53,02,cLimi)//"!#"

    cCpo := PADL(TC1->F2_VALBRUT,14,"0")     //VALOR BRUTO DA NOTA 14
    cLin := Stuff(cLin,55,14,cCpo)

    cLin := Stuff(cLin,69,02,cLimi)//"!#"

    cCpo := PADL(TC1->F2_VALMERC,14,"0")     //VALOR DAS MERCADORIAS  DA NOTA 14
    cLin := Stuff(cLin,71,14,cCpo)

    cLin := Stuff(cLin,85,02,cLimi)//"!#"

    cCpo := PADL(TC1->F2_MOEDA,02,"0")      //MOEDA NUMERICO 02
    cLin := Stuff(cLin,87,02,cCpo)

    cLin := Stuff(cLin,89,02,cLimi)//"!#"   
    
    cCpo := PADR(TC1->F2_XCODPA,10)      // NATUREZA 10 
    cLin := Stuff(cLin,91,10,cCpo)

    cLin := Stuff(cLin,101,02,cLimi)//"!#"

    cCpo := PADR(Posicione("SC5",1,xFilial("SC5")+TC1->D2_PEDIDO,"C5_MENNOTA"),30)      //TES 03
    cLin := Stuff(cLin,103,30,cCpo)

    cLin := Stuff(cLin,133,02,cLimi)//"!#"

    cCpo := PADR(TC1->D2_PEDIDO,06)      //PEDIDO 06
    cLin := Stuff(cLin,135,06,cCpo)

    cLin := Stuff(cLin,141,02,cLimi)//"!#"

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        Conout("Ocorreu um erro na gravacao do arquivo "+Substr(cArqTxt,Len(cDirSrv)+1,Len(cArqTxt)-Len(cDirSrv)))
    Endif
    Do While !EOF()  .And. (TC1->F2_DOC+TC1->F2_SERIE) = (cDocAnt+cSerAnt) //SEGUNDA LINHA

       cLin    := Space(nTamLin2)+cEOL // Variavel para criacao da linha do registros para gravacao

       cLin := Stuff(cLin,01,01,cCpoI) // IDENTIFICADOR "I", "A" OU "E"  DA OPERACAO
    
       cLin := Stuff(cLin,02,02,cLimi) //"!#"

       cLin := Stuff(cLin,04,01,"I") // IDENTIFICADOR  DO REGISTRO "I"=ITEM

       cLin := Stuff(cLin,05,02,cLimi) //"!#"

       cCpo := PADR(TC1->D2_DOC,09)     //DOCUMENTO 09
       cLin := Stuff(cLin,07,09,cCpo)

       cLin := Stuff(cLin,16,02,cLimi) //"!#"

       cCpo := PADR(TC1->D2_SERIE,03)     //SERIE 03
       cLin := Stuff(cLin,18,03,cCpo)

       cLin := Stuff(cLin,21,02,cLimi) //"!#"

       cCpo := PADR(TC1->D2_COD,15)     //CODIGO DO PRODUTO 15
       cLin := Stuff(cLin,23,15,cCpo)

       cLin := Stuff(cLin,38,02,cLimi) //"!#"

       cCpo := PADL(TC1->D2_QUANT,11,"0")      //QUANTIDADE 11
       cLin := Stuff(cLin,40,11,cCpo)

       cLin := Stuff(cLin,51,02,cLimi)//"!#"                               
       
       
       cCpo := PADL(TC1->D2_PRCVEN,14,"0")      //PREวO DE VENDAS 14
       cLin := Stuff(cLin,53,14,cCpo)

       cLin := Stuff(cLin,67,02,cLimi)//"!#"                               

       cCpo := PADL(TC1->D2_TOTAL,14,"0")      //TOTAL DO ITEM 14
       cLin := Stuff(cLin,69,14,cCpo)

       cLin := Stuff(cLin,83,02,cLimi)//"!#"                                      

       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
          Conout("Ocorreu um erro na gravacao do arquivo "+Substr(cArqTxt,Len(cDirSrv)+1,Len(cArqTxt)-Len(cDirSrv)))
       Endif    
    
       TC1->(dbSkip())
    
    Enddo
    U_AtuSF2A() //Atualizar a data exportacao do cadatro de clientes.
EndDo
fClose(nHdl) 
//CPYS2T(cDirSrv+Substr(cArqTxt,Len(cDirSrv)+1,Len(cArqTxt)-Len(cDirSrv)),cDirCli,.F.)
Return

User Function AtuSF2A()
Local aArea :=GetArea()
Local cDocSerie:=cDocAnt+cSerAnt
DbselectArea("SF2")
DbSetorder(1)
If Dbseek(xFilial("SF2")+cDocSerie)
   Reclock("SF2",.F.)
   SF2->F2_DTEXPOR  := dDataBase 
   SF2->F2_EXPORTO  := 'S'
   MsUnlock()
Endif
RestArea(aArea)
Return Nil


