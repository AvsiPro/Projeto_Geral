#include "totvs.ch"
/*/{Protheus.doc} mENotas
Monitor de integração com E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function mENotas()
	local   aArea     := getArea()
	local   cCondicao
	private aRotina   := {}
	private aCores    := {}
	private cCadastro := "Monitor de Integração E-Notas"

	aAdd( aRotina, {"Pesquisar" ,"axPesqui"    , 0, 1} )
	aAdd( aRotina, {"Visualizar","axVisual"    , 0, 2} )
	aAdd( aRotina, {"Request"   ,"u_mENotasReq", 0, 7} )
	aAdd( aRotina, {"Legenda"   ,"u_mENotasLeg", 0, 8} )
	aAdd( aRotina, {"Exec.JOB"  ,"u_mENotasJOB", 0, 9} )
	aAdd( aRotina, {"Cancelar"  ,"u_CanEnot"   , 0, 9} )

	aAdd(aCores ,{ 'ZPE_STATUS="1"', 'BR_BRANCO'  , 'Enviado E-Notas'          })
	aAdd(aCores ,{ 'ZPE_STATUS="2"', 'BR_AMARELO' , 'Recusado E-Notas'         })
	aAdd(aCores ,{ 'ZPE_STATUS="3"', 'BR_VERMELHO', 'Negado Prefeitura'        })
	aAdd(aCores ,{ 'ZPE_STATUS="4"', 'BR_AZUL'    , 'Autorizado Prefeitura'    })
	aAdd(aCores ,{ 'ZPE_STATUS="5"', 'BR_CINZA'   , 'Em Autorização Prefeitura'})
	aAdd(aCores ,{ 'ZPE_STATUS="6"', 'BR_PRETO'   , 'Em Cancelamento Prefeitura'})
	aAdd(aCores ,{ 'ZPE_STATUS="7"', 'BR_MARROM'  , 'Cancelamento Negado Prefeitura'})
	aAdd(aCores ,{ 'ZPE_STATUS="8"', 'BR_CANCEL'  , 'Cancelado Prefeitura'})
	aAdd(aCores ,{ 'ZPE_STATUS="9"', 'BR_VIOLETA' , 'Outros Prefeitura'})

	cCondicao := "ZPE_LAST=' '"

	dbSelectArea("ZPE")
	dbSetOrder(1)
	dbGotop()
	mBrowse( 6, 1,22,75,"ZPE",,,,,,aCores,,,,,,,,cCondicao)

	restArea(aArea)
return nil


/*/{Protheus.doc} mENotasLeg
Legenda das cores do browse
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function mENotasLeg()
	local aLeg := {}
	local nI

	for nI := 1 to len( aCores )
		aAdd( aLeg, { aCores[nI][2], aCores[nI][3]})
	next

	brwLegenda( cCadastro, "Tela", aLeg)
return nil


/*/{Protheus.doc} mENotasReq
Exibe a Requisição e Retorno do E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 18/04/2021
/*/
user function mENotasReq()
	local cMsg    := alltrim( ZPE->ZPE_REQUES )
	local cNewMsg := ""

	cNewMsg += "REQUISIÇÃO: "+CRLF
	cNewMsg += U_JSONform( cMsg, .T. ) + CRLF+CRLF

	cMsg := alltrim( ZPE->ZPE_RETORN )
	cNewMsg += "RETORNO: "+CRLF
	cNewMsg += U_JSONform( cMsg, .T. ) + CRLF

	if Aviso( "Monitor E-Notas", cNewMsg, {"Fechar", "Copiar"}, 3 ) == 2
		CopytoClipboard ( cNewMsg )
		msgInfo( "conteúdo copiado para a área de transferência", "Monitor E-Notas")
	endif
return nil


/*/{Protheus.doc} mENotasJOB
Força a execução do JOB sob demanda
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
/*/
user function mENotasJOB
	if msgYesNo("Deseja executar o JOB de integração agora?", cCadastro)
		startJob("U_jEnvENotas",GetEnvServer(),.F.)
	endif
return nil

/*/{Protheus.doc} CanEnotJOB
Força a execução cancelamento sob demanda
@type function
@version  12.1.2210
@author Odair Junior
@since 29/01/2024
/*/
user function CanEnot()
	Local cCodFil := ZPE->ZPE_FILIAL
	Local cDoc    := ZPE->ZPE_DOC
	Local cSerie  := ZPE->ZPE_SERIE
	Local lQuiet  := .F.

	dbSelectArea("SA1")
	dbSelectArea("SD2")
	dbSelectArea("SF2")


	SA1->( dbSetOrder(1) )
	SD2->( dbSetOrder(3) )
	SF2->( dbSetOrder(1) )

	if ! SF2->( dbSeek( cCodFil + cDoc + cSerie ) )
		if ! lQuiet
			msgStop("Documento não encontrado Cabeçalho ["+cCodFil +"/"+ cDoc +"-"+ cSerie+"]","Integração E-Notas")
		endif
		return .F.
	endif

	if ! SD2->( dbSeek( SF2->(F2_FILIAL+F2_DOC+F2_SERIE) ) )
		if ! lQuiet
			msgStop("Documento não encontrado Itens ["+cCodFil +"/"+ cDoc +"-"+ cSerie+"]","Integração E-Notas")
		endif
		return .F.
	endif

	if ! SA1->( dbSeek( xFilial("SA1") + SF2->(F2_CLIENTE+F2_LOJA) ) )
		if ! lQuiet
			msgStop("Cliente não encontrado ["+xFilial("SA1") +"/"+ SF2->F2_CLIENTE +"-"+ SF2->F2_LOJA+"]","Integração E-Notas")
		endif
		return .F.
	endif


	if msgYesNo("Deseja cancelar a nota: "+cDoc+" - Serie: "+cSerie+" agora?", cCadastro)
		U_canENotas( cCodFil, cDoc, cSerie, .F. )
	endif

return nil
