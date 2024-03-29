// Transferencia entre almoxarifados / localizacoes          
#INCLUDE "PROTHEUS.CH"
User function TTEST22()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Pega a variavel que identifica se o calculo do custo e' :    �
//�               O = On-Line                                    �
//�               M = Mensal                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE cCusMed  := GetMv("MV_CUSMED")
PRIVATE cCadastro:= "Transfer늧cias"  //OemToAnsi(STR0001)
PRIVATE aRegSD3  := {}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se o custo medio e' calculado On-Line               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque

If cEmpAnt <> "01"
	Return
EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Posiciona numero do Lote para Lancamentos do Faturamento     �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo	// Nome do arquivo contra prova

//para estorno passar o 15o. par�metro com .T.
a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)

Return

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿌260Processa  � Eveli Morasco             � Data � 16/01/92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Processamento da inclusao                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpC01: Codigo do Produto Origem - Obrigatorio              낢�
굇�          쿐xpC02: Almox Origem             - Obrigatorio              낢�
굇�          쿐xpN01: Quantidade 1a UM         - Obrigatorio              낢�
굇�          쿐xpC03: Documento                - Obrigatorio              낢�
굇�          쿐xpD01: Data                     - Obrigatorio              낢�
굇�          쿐xpN02: Quantidade 2a UM                                    낢�
굇�          쿐xpC04: Sub-Lote                 - Obrigatorio se Rastro "S"낢�
굇�          쿐xpC05: Lote                     - Obrigatorio se usa Rastro낢�
굇�          쿐xpD02: Validade                 - Obrigatorio se usa Rastro낢�
굇�          쿐xpC06: Numero de Serie                                     낢�
굇�          쿐xpC07: Localizacao Origem                                  낢�
굇�          쿐xpC08: Codigo do Produto Destino- Obrigatorio              낢�
굇�          쿐xpC09: Almox Destino            - Obrigatorio              낢�
굇�          쿐xpC10: Localizacao Destino                                 낢�
굇�          쿐xpL01: Indica se movimento e estorno                       낢�
굇�          쿐xpN03: Numero do registro original (utilizado estorno)     낢�
굇�          쿐xpN04: Numero do registro destino (utilizado estorno)      낢�
굇�          쿐xpC11: Indicacao do programa que originou os lancamentos   낢�
굇�          쿐xpC12: cEstFis    - Estrutura Fisica          (APDL)       낢�
굇�          쿐xpC13: cServico   - Servico                   (APDL)       낢�
굇�          쿐xpC14: cTarefa    - Tarefa                    (APDL)       낢�
굇�          쿐xpC15: cAtividade - Atividade                 (APDL)       낢�
굇�          쿐xpC16: cAnomalia  - Houve Anomalia? (S/N)     (APDL)       낢�
굇�          쿐xpC17: cEstDest   - Estrututa Fisica Destino  (APDL)       낢�
굇�          쿐xpC18: cEndDest   - Endereco Destino          (APDL)       낢�
굇�          쿐xpC19: cHrInicio  - Hora Inicio               (APDL)       낢�
굇�          쿐xpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)       낢�
굇�          쿐xpC21: cCarga     - Numero da Carga           (APDL)       낢�
굇�          쿐xpC22: cUnitiza   - Numero do Unitizador      (APDL)       낢�
굇�          쿐xpC23: cOrdTar    - Ordem da Tarefa           (APDL)       낢�
굇�          쿐xpC24: cOrdAti    - Ordem da Atividade        (APDL)       낢�
굇�          쿐xpC25: cRHumano   - Recurso Humano            (APDL)       낢�
굇�          쿐xpC26: cRFisico   - Recurso Fisico            (APDL)       낢�
굇�          쿐xpN05: nPotencia  - Potencia do Lote                       낢�
굇�          쿐xpC27: cLoteDest  - Lote Destino da Transferencia          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Transferencia                                              낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
