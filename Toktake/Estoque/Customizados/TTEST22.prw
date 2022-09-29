// Transferencia entre almoxarifados / localizacoes          
#INCLUDE "PROTHEUS.CH"
User function TTEST22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a variavel que identifica se o calculo do custo e' :    ³
//³               O = On-Line                                    ³
//³               M = Mensal                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCusMed  := GetMv("MV_CUSMED")
PRIVATE cCadastro:= "Transferˆncias"  //OemToAnsi(STR0001)
PRIVATE aRegSD3  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque

If cEmpAnt <> "01"
	Return
EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo	// Nome do arquivo contra prova

//para estorno passar o 15o. parâmetro com .T.
a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260Processa  ³ Eveli Morasco             ³ Data ³ 16/01/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento da inclusao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC01: Codigo do Produto Origem - Obrigatorio              ³±±
±±³          ³ExpC02: Almox Origem             - Obrigatorio              ³±±
±±³          ³ExpN01: Quantidade 1a UM         - Obrigatorio              ³±±
±±³          ³ExpC03: Documento                - Obrigatorio              ³±±
±±³          ³ExpD01: Data                     - Obrigatorio              ³±±
±±³          ³ExpN02: Quantidade 2a UM                                    ³±±
±±³          ³ExpC04: Sub-Lote                 - Obrigatorio se Rastro "S"³±±
±±³          ³ExpC05: Lote                     - Obrigatorio se usa Rastro³±±
±±³          ³ExpD02: Validade                 - Obrigatorio se usa Rastro³±±
±±³          ³ExpC06: Numero de Serie                                     ³±±
±±³          ³ExpC07: Localizacao Origem                                  ³±±
±±³          ³ExpC08: Codigo do Produto Destino- Obrigatorio              ³±±
±±³          ³ExpC09: Almox Destino            - Obrigatorio              ³±±
±±³          ³ExpC10: Localizacao Destino                                 ³±±
±±³          ³ExpL01: Indica se movimento e estorno                       ³±±
±±³          ³ExpN03: Numero do registro original (utilizado estorno)     ³±±
±±³          ³ExpN04: Numero do registro destino (utilizado estorno)      ³±±
±±³          ³ExpC11: Indicacao do programa que originou os lancamentos   ³±±
±±³          ³ExpC12: cEstFis    - Estrutura Fisica          (APDL)       ³±±
±±³          ³ExpC13: cServico   - Servico                   (APDL)       ³±±
±±³          ³ExpC14: cTarefa    - Tarefa                    (APDL)       ³±±
±±³          ³ExpC15: cAtividade - Atividade                 (APDL)       ³±±
±±³          ³ExpC16: cAnomalia  - Houve Anomalia? (S/N)     (APDL)       ³±±
±±³          ³ExpC17: cEstDest   - Estrututa Fisica Destino  (APDL)       ³±±
±±³          ³ExpC18: cEndDest   - Endereco Destino          (APDL)       ³±±
±±³          ³ExpC19: cHrInicio  - Hora Inicio               (APDL)       ³±±
±±³          ³ExpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)       ³±±
±±³          ³ExpC21: cCarga     - Numero da Carga           (APDL)       ³±±
±±³          ³ExpC22: cUnitiza   - Numero do Unitizador      (APDL)       ³±±
±±³          ³ExpC23: cOrdTar    - Ordem da Tarefa           (APDL)       ³±±
±±³          ³ExpC24: cOrdAti    - Ordem da Atividade        (APDL)       ³±±
±±³          ³ExpC25: cRHumano   - Recurso Humano            (APDL)       ³±±
±±³          ³ExpC26: cRFisico   - Recurso Fisico            (APDL)       ³±±
±±³          ³ExpN05: nPotencia  - Potencia do Lote                       ³±±
±±³          ³ExpC27: cLoteDest  - Lote Destino da Transferencia          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Transferencia                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
