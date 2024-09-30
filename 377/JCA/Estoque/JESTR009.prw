#include 'PROTHEUS.CH'
User Function JESTR009()

	Local aVetDoc := {}
	Local aVetVlr := {}
	Local aVetNFc := {}
	Local aItemDTC := {}
	Local aCabDTC := {}
	Local aItem := {}
	Local lCont := .T.
	Local cLotNfc := ''
	Local cRet := ''
	Local aCab := {}
	Local aErrMsg := {}

	lMsErroAuto := .F.
	nModulo := 43

    If Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","00020087")
    EndIf


	AAdd(aCab,{'DTP_QTDLOT',1,NIL})
	AAdd(aCab,{'DTP_QTDDIG',0,NIL})
	AAdd(aCab,{'DTP_STATUS','1',NIL}) //-- Em aberto

	MsExecAuto({|x,y|cRet := TmsA170(x,y)},aCab,3)

	If lMsErroAuto

		MostraErro()

		lCont := .F.

	Else

		cLotNfc := cRet

	EndIf

	If lCont

		lMsErroAuto := .F.

		aCabDTC := { {"DTC_FILORI" ,"01" , Nil},;
                    {"DTC_LOTNFC" ,cLotNfc , Nil},;
                    {"DTC_CLIREM" ,Padr("001",Len(DTC->DTC_CLIREM)), Nil},;
                    {"DTC_LOJREM" ,Padr("01" ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_DATENT" ,Ctod('24/08/2011') , Nil},;
                    {"DTC_CLIDES" ,Padr("002",Len(DTC->DTC_CLIREM)), Nil},;
                    {"DTC_LOJDES" ,Padr("01" ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_CLIDEV" ,Padr("001",Len(DTC->DTC_CLIREM)), Nil},;
                    {"DTC_LOJDEV" ,Padr("01" ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_CLICAL" ,Padr("001",Len(DTC->DTC_CLIREM)), Nil},;
                    {"DTC_LOJCAL" ,Padr("01" ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_DEVFRE" ,"1" , Nil},;
                    {"DTC_SERTMS" ,"2" , Nil},;
                    {"DTC_TIPTRA" ,"1" , Nil},;
                    {"DTC_SERVIC" ,"010" , Nil},;
                    {"DTC_TIPNFC" ,"0" , Nil},;
                    {"DTC_TIPFRE" ,"1" , Nil},;
                    {"DTC_CODNEG" ,"1" , Nil},;
                    {"DTC_SELORI" ,"1" , Nil},;
                    {"DTC_CDRORI" ,'01001', Nil},;
                    {"DTC_CDRDES" ,'05001', Nil},;
                    {"DTC_CDRCAL" ,'05001', Nil},;
                    {"DTC_DISTIV" ,'2', Nil}}

		aItem := {{"DTC_NUMNFC" ,"011" , Nil},;
                    {"DTC_SERNFC" ,"UNI" , Nil},;
                    {"DTC_CODPRO" ,"001", Nil},;
                    {"DTC_CODEMB" ,"CX" , Nil},;
                    {"DTC_EMINFC" ,Ctod('01/01/11') , Nil},;
                    {"DTC_QTDVOL" ,20 , Nil},;
                    {"DTC_PESO" ,200.0000, Nil},;
                    {"DTC_PESOM3" ,0.0000, Nil},;
                    {"DTC_VALOR" ,20000.00, Nil},;
                    {"DTC_BASSEG" ,0.00 , Nil},;
                    {"DTC_METRO3" ,0.0000, Nil},;
                    {"DTC_QTDUNI" ,0 , Nil},;
                    {"DTC_EDI" ,"2" , Nil}}

		AAdd(aItemDTC,aClone(aItem))
//
// Parametros da TMSA050 (notas fiscais do cliente)
// xAutoCab - Cabecalho da nota fiscal
// xAutoItens - Itens da nota fiscal
// xItensPesM3 - acols de Peso Cubado
// xItensEnder - acols de Enderecamento
// nOpcAuto - Opcao rotina automatica
		MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
		If lMsErroAuto
			MostraErro()
			lCont := .F.
		Else
			DTC->(dbCommit())
		EndIf
	EndIf

	If lCont
		AAdd(aVetDoc,{"DT6_FILORI","01"})
		AAdd(aVetDoc,{"DT6_LOTNFC",cLotNfc})
		AAdd(aVetDoc,{"DT6_FILDOC","01"})
		AAdd(aVetDoc,{"DT6_DOC" ,"000007"})
		AAdd(aVetDoc,{"DT6_SERIE" ,"UNI"})
		AAdd(aVetDoc,{"DT6_DATEMI",Ctod('24/08/2011')})
		AAdd(aVetDoc,{"DT6_HOREMI","1650"})
		AAdd(aVetDoc,{"DT6_VOLORI", 20})
		AAdd(aVetDoc,{"DT6_QTDVOL", 20})
		AAdd(aVetDoc,{"DT6_PESO" , 200.0000})
		AAdd(aVetDoc,{"DT6_PESOM3", 0.0000})
		AAdd(aVetDoc,{"DT6_PESCOB", 0.0000})
		AAdd(aVetDoc,{"DT6_METRO3", 0.0000})
		AAdd(aVetDoc,{"DT6_VALMER", 20000.00})
		AAdd(aVetDoc,{"DT6_QTDUNI", 0})
		AAdd(aVetDoc,{"DT6_VALFRE", 990.00})
		AAdd(aVetDoc,{"DT6_VALIMP", 135.00})
		AAdd(aVetDoc,{"DT6_VALTOT", 1125.00})
		AAdd(aVetDoc,{"DT6_BASSEG", 0.00})
		AAdd(aVetDoc,{"DT6_SERTMS","2"})
		AAdd(aVetDoc,{"DT6_TIPTRA","1"})
		AAdd(aVetDoc,{"DT6_DOCTMS","2"})
		AAdd(aVetDoc,{"DT6_CDRORI","01001 "})
		AAdd(aVetDoc,{"DT6_CDRDES","05001 "})
		AAdd(aVetDoc,{"DT6_CDRCAL","05001 "})
		AAdd(aVetDoc,{"DT6_TABFRE","R007"})
		AAdd(aVetDoc,{"DT6_TIPTAB","01"})
		AAdd(aVetDoc,{"DT6_SEQTAB","00"})
		AAdd(aVetDoc,{"DT6_TIPFRE","1"})
		AAdd(aVetDoc,{"DT6_FILDES","01"})
		AAdd(aVetDoc,{"DT6_BLQDOC","2"})
		AAdd(aVetDoc,{"DT6_PRIPER","2"})
		AAdd(aVetDoc,{"DT6_PERDCO", 0.00000})
		AAdd(aVetDoc,{"DT6_FILDCO",""})
		AAdd(aVetDoc,{"DT6_DOCDCO",""})
		AAdd(aVetDoc,{"DT6_SERDCO",""})
		AAdd(aVetDoc,{"DT6_CLIREM",Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJREM",Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDES",Padr("002",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDES",Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDEV",Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDEV",Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLICAL",Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJCAL",Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_DEVFRE","2"})
		AAdd(aVetDoc,{"DT6_FATURA",""})
		AAdd(aVetDoc,{"DT6_SERVIC","010"})
		AAdd(aVetDoc,{"DT6_CODMSG",""})
		AAdd(aVetDoc,{"DT6_STATUS","1"})
		AAdd(aVetDoc,{"DT6_DATEDI",CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_NUMSOL",""})
		AAdd(aVetDoc,{"DT6_VENCTO",CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_FILDEB","01"})
		AAdd(aVetDoc,{"DT6_PREFIX",""})
		AAdd(aVetDoc,{"DT6_NUM" ,""})
		AAdd(aVetDoc,{"DT6_TIPO" ,""})
		AAdd(aVetDoc,{"DT6_MOEDA" , 1})
		AAdd(aVetDoc,{"DT6_BAIXA" ,CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_FILNEG","01"})
		AAdd(aVetDoc,{"DT6_ALIANC",""})
		AAdd(aVetDoc,{"DT6_REENTR", 0})
		AAdd(aVetDoc,{"DT6_TIPMAN",""})
		AAdd(aVetDoc,{"DT6_PRZENT",Ctod('24/08/2011')})
		AAdd(aVetDoc,{"DT6_FIMP" ,"0"})

		AAdd(aVetVlr,{{"DT8_CODPAS","01"},;
                        {"DT8_VALPAS", 100.00},;
                        {"DT8_VALIMP", 13.64},;
                        {"DT8_VALTOT", 113.64},;
                        {"DT8_FILORI",""},;
                        {"DT8_TABFRE","R007"},;
                        {"DT8_TIPTAB","01"},;
                        {"DT8_FILDOC","01"},;
                        {"DT8_CODPRO","001"},;
                        {"DT8_DOC" ,"000007"},;
                        {"DT8_SERIE" ,"UNI"},;
                        {"VLR_ICMSOL",0}})

		

		AAdd(aVetNFc,{{"DTC_CLIREM",Padr("001",Len(DTC->DTC_CLIREM))},;
                        {"DTC_LOJREM",Padr("01" ,Len(DTC->DTC_LOJREM))},;
                        {"DTC_NUMNFC",Padr("011",Len(DTC->DTC_NUMNFC))},;
                        {"DTC_SERNFC",Padr("UNI" ,Len(DTC->DTC_SERNFC))},;
                        {"DTC_CODPRO",Padr("001" ,Len(DTC->DTC_CODPRO))},;
                        {"DTC_TIPNFC" ,"0" , Nil},;
                        {"DTC_QTDVOL", 20},;
                        {"DTC_PESO" , 200.0000},;
                        {"DTC_PESOM3", 0.0000},;
                        {"DTC_METRO3", 0.0000},;
                        {"DTC_VALOR" , 20000.00}})

		aDocOri:= { DTC->DTC_FILDOC,;    // [1] Filial Docto Original  (caracter)
                    DTC->DTC_DOC,;       // [2] No. Docto Original     (caracter)
                    DTC->DTC_SERIE,; // [3] Serie Docto Original   (caracter)
                    100,;               // [4] % Docto. Orignal       (numerico)
                    .F.,;               // [5] Complemento de Imposto (lógico)
                    7 }                 // [6] nOpcx - TMSA500        (numerico)

		aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,0,1,.T.,.T.,.T.,.T., aDocOri)
	EndIf
Return
