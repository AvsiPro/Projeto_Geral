#Include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

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

    Local cLinha  := ""
    Local cArqAux := ""
    Local aAuto := {}
    Local nOpcAuto := 3
    lOCAL nX := 0
    Local lPrim   := .T.
    Local aCampos := {}
    Local aDados  := {}
    Private lMsErroAuto := .F.


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

    //User Function MyMata261()
    //   Local aAuto := {}
    //  Local aItem := {}
    // Local aLinha := {}
    // Local alista := {'PA001','PA001'} //Produto Utilizado
    // Local nX

    //Local nOpcAuto := 3

    // PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SB1", "SD3"

    //Cabecalho a Incluir
    aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho

    for nX := 1 to len(aDados)
        aLinha := {}
        //Origem
        If   SB1->(DbSeek(xFilial("SB1")+PadR(aDados[nX,01], tamsx3('D3_COD') [1])))
            aadd(aLinha,{"ITEM",padl(cvaltochar(nX),3,"0"),Nil})
            aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
            aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
            aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
            aadd(aLinha,{"D3_LOCAL", padl(aDados[nX,02],3,"0"), Nil}) //armazem origem
            aadd(aLinha,{"D3_LOCALIZ", "",Nil}) //Informar endere�o origem

            //Destino
            SB1->(DbSeek(xFilial("SB1")+PadR(aDados[nX,01], tamsx3('D3_COD') [1])))
            aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
            aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
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
        Else
            alert("Produto informado na linha "+STR(nX-1)+",n�o foi localizado, verifique se o produto est� correto e informe o administrador do sistema.")
            Return
        EndIf
    Next nX

    MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

    if lMsErroAuto
        MostraErro()
    else
        alert("Importa��o conclu�da!")
    EndIf

Return
