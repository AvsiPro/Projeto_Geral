#Include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#include "fileio.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �User Function ROBTARM()
�Autor Rodrigo Barreto      �Microsiga           � Data �  19/03/2023	 ���
�������������������������������������������������������������������������͹��
���Desc.     � Importa TRANsFERENCIA DE ARMAZEM                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROBTARM()

    Private cLinha  := ""
    Private cArqAux := ""
    Private aAuto := {}
    Private nOpcAuto := 3
    Private lPrim   := .T.
    Private cFilAtu := ""
    Private aCampos := {}
    Private aDados  := {}
    Private lMsErroAuto := .F.
    Private cFileLog :=	'transf_armz_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt'
    Private nHandle	:=	fcreate('c:\Temp\'+cFileLog , FO_READWRITE + FO_SHARED )

    //Chamando o cGetFile para pegar um arquivo txt ou xml, mostrando o servidor
    cArqAux := cGetFile( 'Arquivo *.csv|*.csv ',; //[ cMascara],
        'Selecao de Arquivos',;                  //[ cTitulo],
        0,;                                      //[ nMascpadrao],
        'C:\',;  	                              //[ cDirinicial],
        .F.,;                                    //[ lSalvar],
        GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
        .T.)                                     //[ lArvore]

    If !File(cArqAux)
        MsgStop("O arquivo " +cArqAux + " n�o foi encontrado. A importa��o ser� abortada!","[AVSIB9] - ATENCAO")
        Return
    EndIf

    Processa({||execlog()}, "Processando...")

Return

/*/{Protheus.doc} execlog
    (long_description)
    @type  Static Function
    @author user
    @since 22/06/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function execlog()

    Local nX := 0

    FT_FUSE(cArqAux)
    ProcRegua(FT_FLASTREC())
    FT_FGOTOP()
    While !FT_FEOF()

        IncProc("Lendo arquivo ...")

        cLinha := FT_FREADLN()

        If lPrim
            //Campos do cabe�alho
            aCampos := Separa(cLinha,";",.T.)
            lPrim := .F.
        Else
            //Itens
            AADD(aDados,Separa(cLinha,";",.T.))
        EndIf

        FT_FSKIP()
    EndDo

    //Cabecalho a Incluir
    aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho

    for nX := 1 to len(aDados)
        aLinha := {}
        cFilAtu := Padl(alltrim(aDados[nX,5]),4,"0")
        cfilant	:= cFilAtu
        //Origem

        If   SB1->(DbSeek(xFilial("SB1")+PadR(aDados[nX,01], tamsx3('D3_COD') [1]))) //varificar saldo irigem e fazer log
            IF SB9->(Dbseek(xFilial("SB9")+SB1->B1_COD+padl(aDados[nX,02],3,"0")))
                If SB9->(Dbseek(xFilial("SB9")+SB1->B1_COD+padl(aDados[nX,03],3,"0")))
                    IF SB2->(Dbseek(xFilial("SB2")+SB1->B1_COD+padl(aDados[nX,02],3,"0")))//B2_FILIAL+B2_COD+B2_LOCAL
                        IF val(aDados[nX,04]) <= SB2->B2_QATU
                            aadd(aLinha,{"ITEM",padl(cvaltochar(nX),3,"0"),Nil})
                            aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
                            aadd(aLinha,{"D3_DESCRI", substr(ALLTRIM(SB1->B1_DESC),1,30), Nil}) //descr produto origem
                            aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
                            aadd(aLinha,{"D3_LOCAL", padl(aDados[nX,02],3,"0"), Nil}) //armazem origem
                            aadd(aLinha,{"D3_LOCALIZ", "",Nil}) //Informar endere�o origem

                            //Destino
                            SB1->(DbSeek(xFilial("SB1")+PadR(aDados[nX,01], tamsx3('D3_COD') [1])))
                            aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
                            aadd(aLinha,{"D3_DESCRI", substr(ALLTRIM(SB1->B1_DESC),1,30), Nil}) //descr produto destino
                            aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
                            aadd(aLinha,{"D3_LOCAL", padl(aDados[nX,03],3,"0"), Nil}) //armazem destino
                            aadd(aLinha,{"D3_LOCALIZ","",Nil}) //Informar endere�o destino

                            aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
                            aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
                            aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
                            aadd(aLinha,{"D3_DTVALID", STOD(""), Nil}) //data validade
                            aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
                            aadd(aLinha,{"D3_QUANT", val(aDados[nX,04]), Nil}) //Quantidade
                            aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
                            aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
                            aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

                            aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
                            aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
                            aadd(aLinha,{"D3_DTVALID", STOD(""), Nil}) //validade lote destino
                            aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

                            aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
                            aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino

                            aAdd(aAuto,aLinha)
                            FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+SB1->B1_COD+"# OK"+Chr(13)+Chr(10),1000)
                        ELSE
                            FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+aDados[nX,01]+"# ERRO - N�o h� saldo atual na origem  "+padl(aDados[nX,02],3,"0")+Chr(13)+Chr(10),1000)
                        ENDIF
                    ENDIF
                else
                    FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+aDados[nX,01]+"# ERRO - N�o h� saldo inicial no destino "+padl(aDados[nX,03],3,"0")+Chr(13)+Chr(10),1000)
                EndIf
            ELSE
                FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+aDados[nX,01]+"# ERRO - N�o h� saldo inicial na Origem "+padl(aDados[nX,02],3,"0")+Chr(13)+Chr(10),1000)
            ENDIF

        Else
            //alert("Produto informado na linha "+STR(nX-1)+",n�o foi localizado, verifique se o produto est� correto e informe o administrador do sistema.")
            //Return
            FWrite(nHandle,'Linha '+cvaltochaDMIr(nX+1)+" # "+aDados[nX,01]+"# ERRO - Produto n�o encontrado"+Chr(13)+Chr(10),1000)
        EndIf

    Next nX

    MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

    if lMsErroAuto
        MostraErro('C:\TEMP\','transf_armz_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt')
    else
        //alert("Importa��o conclu�da!")
        FWrite(nHandle,'Finalizado com sucesso'+Chr(13)+Chr(10),1000)
    EndIf

    FT_FUse()
    FCLOSE( nHandle )
    MsgAlert("Importa��o conclu�da!")
    WinExec('NOTEPAD '+ 'c:\Temp\'+cFileLog,1)
Return
