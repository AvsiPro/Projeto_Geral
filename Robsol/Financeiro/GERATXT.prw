#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "TopConn.ch"
#include "fileio.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºPrograma ³ GERAtxt    ºAutor³ AVSIPRO Rodrigo Barreto	    º Data Ini³ 20/01/2023       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºDesc.    ³ GERA CNAB FOLHA                                                                ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºUso      ³ ROBSOL  	                                            		  		  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

user function GERATXT()

    Local aArea := GetArea()
    Local aPergs   := {}
    Local cBordero	:= SPACE(6)
    Private cAgenc := ""
    Private cConta := ""
    Private cDigAg := "3"
    Private cDigCo := ""
    Private cConv := ""

    aAdd(aPergs, {1, "Numero do borderô ",			 		cBordero,  "",  ".T.",   "",  ".T.", 80,  .T.})

    If ParamBox(aPergs, "Informe os parâmetros")
        Processa({||VERISEA()},,"Processando...")
        //MsAguarde({|| GeraExcel()},, "O Arquivo está sendo gerado...")
        MsgAlert('ATENÇÃO: Arquivo gerado com sucesso ')
    EndIf

    restArea(aArea)
Return Nil

Static Function VERISEA()

    //Local cQuery  := ""
    Private cPar1   := MV_PAR01

    SetPrvt("MV_PAR01")

    //cQuery := " SELECT "
    //cQuery += " FROM "+ RetSQLName('SFT')+" FT "

    DbSelectArea("SEA")
    dbSetOrder(2)
    //aAuxA2 := GetAdvFVal("SA2", { "A2_NOME", "A2_CGC","A2_END", "A2_BAIRRO","A2_CEP", "A2_MUN", "A2_EST", "A2_BANCO", "A2_AGENCIA", "A2_DVAGE", "A2_DVCTA"	, "A2_NUMCON"  },;
    //							  xFilial("SA2")+cCgc , 3, { "", "", "", "", "", "", "", "", "","","","" })
     //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA                                                                             
    IF dbSeek(xFilial("SEA")+cPar1+"P"+"FOL",.t.)
        cIdTit := SEA->EA_NUM
        cAgenc := SEA->EA_AGEDEP
        cConta := SEA->EA_NUMCON
        If alltrim(cConta) == "101"
            cDigCo := "5"
            cConv := "000367948"
        else
            cDigCo := "6"
            cConv := "000230962"
        EndIf
        GerCnab(cIdTit)
    EndIf

return Nil

Static Function GerCnab(cIdTit)

    Local cQuery  := ""

    cQuery := " SELECT ZZ1_PREFIX, ZZ1_NUM, ZZ1_TIPO, ZZ1_BANCO, ZZ1_AGEN, ZZ1_DGAGE, ZZ1_CONTA, ZZ1_DGCONT, ZZ1_PARCE,"
    cQuery += " ZZ1_CGC, ZZ1_NOME, ZZ1_DTVENC, ZZ1_VALOR, ZZ1_FISJUR, ZZ1_END, ZZ1_END, ZZ1_BAIRRO, ZZ1_MUN, ZZ1_CEP, "
    cQuery += " ZZ1_EST, ZZ1_ID "
    cQuery += " FROM "+ RetSQLName('ZZ1')+" ZZ1 "
    cQuery += " WHERE ZZ1_ID = '"+cIdTit+"' "
    cQuery += " AND ZZ1.D_E_L_E_T_=''"

    Processa({||fProcessa(cQuery)},,"Processando...")

return Nil

Static Function fProcessa(cQuery)

    Local cDiretorio  := cGetFile( '*.txt|*.txt' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
    Local cArquivo    := "QRYCSV" + "_" + DTOS(DATE()) + "_" + SUBSTR(TIME(),1,2 ) + SUBSTR(TIME(),4,2 ) + SUBSTR(TIME(),7,2 ) + '.txt'
    Local cArqFull    := cDiretorio + cArquivo
    Local cHeader := ""
    Local cHeaderL := ""
    Local cSegA  := ""
    Local cSegB := ""
    Local cTraL := ""
    Local cTraA := ""
    Local nNumReg := 0
    Local nLin	:= 0
    Local nLinT := 0
    Local nValor := 0


    If Empty(cQuery)
        Alert("Consulta com problema não foi possível gerar arquivo!")
        Return
    EndIf

    nHnd := FCreate(cArqFull)

    If nHnd == -1
        MsgStop("Falha ao criar arquivo ["+cArqFull+"]","FERROR "+cValToChar(fError()))
        Return
    Endif

    //Execulta Select Banco de dados
    If Select("TRB") > 0
        Dbselectarea("TRB")
        TRB->(DbClosearea())
    EndIf

    cHeader := "001" //banco 001 - 003
    cHeader += "0000"//LOTE SERVICO   004-007
    cHeader += "0" //TIPO REGISTRO 008-008
    cHeader += space(9)//RESERVADO CNAB  009-017
    cHeader += IF(SM0->M0_TPINSC == 3, "1", "2")//TP INSC EMPRESA 018-018
    cHeader += PADL(ALLTRIM(SM0->M0_CGC), 14, "0")//NUM INSCRICAO  019-032
    cHeader += cConv //CONVENIO 033-041
    cHeader += "0126" //PAG CEDENTE    042-045
    cHeader += space(5) //RESERVADO BB 046-050
    cHeader += "  " //REMESSA TESTE  051-052
    cHeader += PADL(ALLTRIM(cAgenc), 5, "0")//AG MANTENEDORA 053-057  PEGAR DA SEA. 5 CARAC cAgenc
    cHeader += ALLTRIM(cDigAg)//DV AG MANTENED       058-058 PEGAR DA SEA
    cHeader += PADL(ALLTRIM(cConta) , 12,"0") //CONTA CORRENTE PEGAR DA SEA 059-070
    cHeader += ALLTRIM(cDigCo) //DV CONTA CORRE 071-071
    cHeader += "0" //DV AG/CONTA 072-072
    cHeader += PADR(ALLTRIM(SM0->M0_NOMECOM),30) //NOME DA EMPRESA 073-102
    cHeader += PADR("BANCO DO BRASIL S.A.",30)//NOME DO BANCO  103-132
    cHeader += space(10) // RESERVADO CNAB 133 -142
    cHeader += "1" //COD REM/RET    143-143
    cHeader += GRAVADATA(DDATABASE, .F., 5) //DT GERACAO ARQ 144 - 151
    cHeader += STRTRAN(TIME(), ":", "")//HR GERACAO ARQ 152-157
    cHeader += "000001" //VAL(SEE->EE_ULTDSK) SEQUENCIA (NSA) 158 163
    cHeader += "083" //164 166
    cHeader += "00000"//167-171
    cHeader += space(20)//RESERVADO BANCO 172- 191
    cHeader += space(31)
    cHeader += space(3)//IDENTIFICACAO  223- 225
    cHeader += REPLICATE("0", 03) //CONTROLE VANS 226-228
    cHeader += REPLICATE("0", 02) //SERVICO 229 230
    cHeader += REPLICATE("0", 10)

    FWrite(nHnd,cHeader + CHR(13)+CHR(10))

    cHeaderL := "001" //BANCO 001-003
    cHeaderL +=  "0001"   //LOTE SERVICO 004-007
    cHeaderL += "1"//TIPO REGISTRO 008-008
    cHeaderL += "C"//TIPO OPERACAO  009-009
    cHeaderL += "30"//TIPO SERVICO   010-011
    cHeaderL += "01"//FORMA LANTO    012-013
    cHeaderL += "042"//LAYOUT LOTE    014-016
    cHeaderL += " "//RESERVADO CNAB  017-017
    cHeaderL += IF(SM0->M0_TPINSC == 3, "1", "2")//TP INSC EMPRESA018-018
    cHeaderL += PADL(ALLTRIM(SM0->M0_CGC), 14, "0")//NUM INSCRICAO 019-032
    cHeaderL += cConv//CONVENIO 033-041
    cHeaderL += "0126"//PAG CEDENTE    042-045
    cHeaderL += SPACE(5)//RESERVADO BANCO 046-050
    cHeaderL += "  "//REMESSA TESTE  051-052
    cHeaderL += PADL(ALLTRIM(cAgenc), 5, "0")//AG MANTENEDORA 053-057
    cHeaderL += ALLTRIM(cDigAg)//DV AG MANTENED 058-058
    cHeaderL += PADL(ALLTRIM(cConta) , 12,"0")//CONTA CORRENTE 059-070
    cHeaderL += ALLTRIM(cDigCo)//DV CONTA CORRE 071-071
    cHeaderL += "0"//DV AG/CONTA    072-072
    cHeaderL += PADR(ALLTRIM(SM0->M0_NOMECOM),30) //NOME DA EMPRESA 073-102
    cHeaderL += SPACE(40)//MENSAGEM 1     103-142
    cHeaderL += PADR(ALLTRIM(IF(EMPTY(SM0->M0_ENDENT), SM0->M0_ENDCOB, SM0->M0_ENDENT)),30)//ENDERECO 143-172 IF(EMPTY(SM0->M0_ENDENT), SM0->M0_ENDCOB, SM0->M0_ENDENT)
    cHeaderL += "00000" //NUMERO          173-177 "00000"
    cHeaderL += PADR(SM0->M0_COMPENT,15) //COMPLEMENTO    178-192 SM0->M0_COMPENT
    cHeaderL += PADR(ALLTRIM(IF(EMPTY(SM0->M0_CIDENT), SM0->M0_CIDCOB, SM0->M0_CIDENT)),20) //CIDADE         193-212 IF(EMPTY(SM0->M0_CIDENT), SM0->M0_CIDCOB, SM0->M0_CIDENT)
    cHeaderL += IF(EMPTY(SM0->M0_CEPENT), SM0->M0_CEPCOB, SM0->M0_CEPENT)//CEP            213 -222 IF(EMPTY(SM0->M0_CEPENT), SM0->M0_CEPCOB, SM0->M0_CEPENT)
    cHeaderL += IF(EMPTY(SM0->M0_ESTENT), SM0->M0_ESTCOB, SM0->M0_ESTENT)//ESTADO          221-222 IF(EMPTY(SM0->M0_ESTENT), SM0->M0_ESTCOB, SM0->M0_ESTENT)
    cHeaderL += SPACE(8)//RESERVADO CNAB  223-230
    cHeaderL += REPLICATE("0", 10)//OCORRENCIAS    231 -240 REPLICATE("0", 10)

    FWrite(nHnd,cHeaderL + CHR(13)+CHR(10))

    TcQuery cQuery New Alias "TRB"

    TRB->(dbGoTop())
    ProcRegua(RecCount())
    nLinT := RecCount()
    TRB->(dbGoTop())

    Do While TRB->(!EOF())

        IncProc("Gravando Dados CSV " + cValToChar(nLin) + " / " + cValToChar( nLinT ))
        nNumReg += 1
        nValor += TRB->(ZZ1_VALOR)
        //detalhe segmento A
        cSegA := "001"//BANCO 001-003
        cSegA += "0001" //LOTE SERVICO    004-007
        cSegA += "3"//TIPO REGISTRO 008-008
        cSegA += padl(cValtoChar(nNumReg),5,"0")//NUM REGISTRO  009-013
        cSegA += "A"//SEGMENTO       014-014
        cSegA += "0"//TIPO MOVIMENTO  015-015
        cSegA += "00"//COD MOVIMENTO  016-017
        cSegA += "000"//COD CAMARA CENT 018-020
        cSegA += TRB->ZZ1_BANCO//BANCO 021-023
        cSegA += PADL(alltrim(TRB->ZZ1_AGEN),5,"0")//AG MANTENEDORA 024-028
        cSegA += TRB->ZZ1_DGAGE//DV AG MANTENED 029-029
        cSegA += PADL(ALLTRIM(TRB->ZZ1_CONTA),12,"0")//CONTA CORRENTE 030 -041
        cSegA += IF(EMPTY(TRB->ZZ1_DGCONT)," ",TRB->ZZ1_DGCONT)//DV CONTA CORRE 042-042
        cSegA += "0"//DV AG/CONTA    043-043
        cSegA += PADR(ALLTRIM(TRB->ZZ1_NOME),30)//NOME           044-073
        cSegA += PADL(ALLTRIM(TRB->ZZ1_NUM), 20, "0")//ID TIT EMPRESA 074-093 ID CNAB PADL(ALLTRIM(SE2->E2_IDCNAB), 20, "0")
        cSegA += GRAVADATA(DATAVALIDA(STOD(TRB->ZZ1_DTVENC)), .F., 5)//DT PAGAMENTO   094-101
        cSegA += "BRL"//TIPO MOEDA     102-104
        cSegA += REPLICATE("0",15)//QTD MOEDA      105-119
        cSegA += PADL(cValtochar(TRB->(ZZ1_VALOR) * 100),15,"0")//VALOR DO PAGTO 120-134
        cSegA += SPACE(20)//ID TIT BANCO   135 154
        cSegA += REPLICATE("0",8)//DT REAL PAGTO  155-162
        cSegA += REPLICATE("0",15)//VLR REAL PAGTO 163-177
        cSegA += SPACE(40)//INFORMACAO 2   178-217
        cSegA += SPACE(2)//FINALIDADE DOC 218-219
        cSegA += SPACE(5)//COD FINAL TED  220-224
        cSegA += SPACE(2)//COMPL FINAL PAG225-226
        cSegA += SPACE(3)//RESERVADO CNAB  227-229
        cSegA += "0"//AVISO          230 -230
        cSegA += REPLICATE("0", 10)  //OCORRENCIAS    231- 240

        FWrite(nHnd,cSegA + CHR(13)+CHR(10))

        nNumReg += 1

        cSegB := "001"//BANCO 001-003
        cSegB += "0001" //LOTE SERVICO    004-007
        cSegB += "3"//TIPO REGISTRO 008-008
        cSegB += padl(cValtoChar(nNumReg),5,"0")//NUM REGISTRO  009-013
        cSegB += "B"//SEGMENTO       014-014
        cSegB += SPACE(3) //RESERVADO AO CNAB 015-017
        cSegB += IF(TRB->ZZ1_FISJUR == "J", "2", "1")//TIPO DE INSCRIÇÃO 018-018
        cSegB += PADL(ALLTRIM(TRB->ZZ1_CGC), 14, "0")// NUM INSCRICAO  019-032
        cSegB += PADR(ALLTRIM(TRB->ZZ1_END),30)//ENDERECO 033-062
        cSegB += "00000"//NUMERO   063-067
        cSegB += SPACE(15)//COMPLEMENTO 068-082
        cSegB += PADR(TRB->ZZ1_BAIRRO,15)//BAIRRO 083-097
        cSegB += PADR(TRB->ZZ1_MUN,20)//CIDADE         098-117
        cSegB += TRB->ZZ1_CEP//CEP            118-125
        cSegB += TRB->ZZ1_EST//ESTADO         126-127
        cSegB += GRAVADATA(DATAVALIDA(STOD(TRB->ZZ1_DTVENC)), .F., 5)//VENCIMENTO     128-135
        cSegB += PADL(cValtochar(TRB->(ZZ1_VALOR) * 100),15,"0")//VALOR          136-150
        cSegB += REPLICATE("0",15)//ABATIMENTO     151-165
        cSegB += REPLICATE("0",15)//DESCONTO       166-180
        cSegB += REPLICATE("0",15) //MORA         181-195
        cSegB += REPLICATE("0",15)//MULTA          196-210
        cSegB += SPACE(15)//DOC FAVORECIDO  211-225
        cSegB += "0"//AVISO          226-226
        cSegB += REPLICATE("0", 6)//USO EXCL SIAPE 227-232
        cSegB += SPACE(8)//RESERVADO CNAB 233-240

        FWrite(nHnd,cSegB + CHR(13)+CHR(10))

        //ZZ1_FILIAL+ZZ1_PREFIX+ZZ1_NUM+ZZ1_PARCE+ZZ1_TIPO+ZZ1_CGC
        DbSelectArea("ZZ1")
        DBSetOrder(1)
        If DbSeek(xFilial("ZZ1")+TRB->ZZ1_PREFIX + TRB->ZZ1_NUM + TRB->ZZ1_PARCE + TRB->ZZ1_TIPO + TRB->ZZ1_CGC)
            RecLock("ZZ1", .F.)

            ZZ1->ZZ1_NUMBOR := cPar1

            MsUnLock()
        EndIf

        nLin++
        TRB->(dbSkip())
    Enddo
    //TRAILER DE LOTE
    cTraL := "001" //BANCO          001-003
    cTraL +=  "0001"//LOTE SERVICO    004-007
    cTraL +=    "5"//TIPO REGISTRO  008-008
    cTraL += SPACE(9)//RESERVADO CNAB 009-017
    cTraL += padl(cValtoChar(nNumReg += 2),6,"0")//QTDE REGISTRO  018-023
    cTraL += PADL(cValtochar(nValor * 100),18,"0")//VALORES        024-041
    cTraL += REPLICATE("0",18)//QTD MOEDAS     042-059
    cTraL += REPLICATE("0", 06)//AVISO DEBITO   060-065
    cTraL += SPACE(165)//RESERVADO CNAB 066 -230
    cTraL += REPLICATE("0", 10) //OCORRENCIAS    231 -240

    FWrite(nHnd,cTraL + CHR(13)+CHR(10))

    //Trailer de arquivo
    cTraA := "001" //BANCO          001-003
    cTraA += "9999" //LOTE SERVICO   004-007
    cTraA += "9" //TIPO REGISTRO  008-008
    cTraA += SPACE(9) //RESERVADO CNAB 009-017
    cTraA += "000001" //QTDE LOTES     018-023
    cTraA += padl(cValtoChar(nNumReg += 2),6,"0")//QTDE REGISTROS 024-029
    cTraA += REPLICATE("0",6)//QTDE CONTAS    030-035
    cTraA += SPACE(205)//RESERVADO CNAB 036-240

    FWrite(nHnd,cTraA + CHR(13)+CHR(10))
    fclose(nHnd)
    MsgAlert('ATENÇÃO: Arquivo gerado com sucesso ' + cArqFull)

return
