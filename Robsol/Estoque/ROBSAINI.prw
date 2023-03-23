#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUser Function ROBSAINI()
บAutor  ณMicrosiga           บ Data ณ  20/03/2023						 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa saldo incial de produtos por arquivos CSV          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ROBSAINI()

	Local cLinha  := ""
	Local cArqAux := ""
	Local cLocP	  := ""
	Local cCod    := ""
	lOCAL nX := 0
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aVetor  := {}
	Local cFilAtu :=""
	Local lMsErroAuto := .F.

	//Chamando o cGetFile para pegar um arquivo txt ou xml, mostrando o servidor
	cArqAux := cGetFile( 'Arquivo *.csv|*.csv ',; //[ cMascara],
		'Selecao de Arquivos',;                  //[ cTitulo],
		0,;                                      //[ nMascpadrao],
		'C:\',;  	                              //[ cDirinicial],
		.F.,;                                    //[ lSalvar],
		GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
		.T.)                                     //[ lArvore]

	If !File(cArqAux)
		MsgStop("O arquivo " +cArqAux + " nใo foi encontrado. A importa็ใo serแ abortada!","[AVSIB9] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cArqAux)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo ...")

		cLinha := FT_FREADLN()

		If lPrim
			//Campos do cabe็alho
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			//Itens
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	For nX := 1 to len(aDados)
		cCod	:= ""
		cFilAtu 		:= Padl(alltrim(aDados[nX,1]),4,"0")
		cfilant		:= cFilAtu
		cCod 	:= Alltrim(aDados[nX,02])
		cLocP :=  padl(Alltrim(aDados[nX,04]),3,"0")
/*
		If len(cCod) < 6
			cCod := Padl(cCod,6,"0")
		EndIf
*/
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+PadR(cCod, tamsx3('B1_COD') [1])))
			
			aVetor :={ {"B9_FILIAL" , xFilial("SB9")		,  Nil},;
				{"B9_COD"    , SB1->B1_COD			,  Nil},;
				{"B9_LOCAL"  , cLocP		  	,  Nil},;// {"B9_DATA"   , Date()   	,  Nil},;
				{"B9_QINI"   , val(aDados[nX,03])	,  Nil} }

			DbselectArea("SB9")
			DbSetOrder(1)
			If !Dbseek(cfilant+SB1->B1_COD+cLocP)

				Begin Transaction
					lMsErroAuto := .F.
					MSExecAuto({|x, y| Mata220(x, y)}, aVetor, 3)
					If lMsErroAuto
						MostraErro()
						DisarmTransaction()
					EndIf
				End Transaction
			EndIf
		Else
			Alert("Produto nใo encontrado, verifique o produto da linha "+STR(nX-1) )
		EndIf
	Next nX

	MsgAlert("Importa็ใo concluํda!")

Return
