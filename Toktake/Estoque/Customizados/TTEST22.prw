// Transferencia entre almoxarifados / localizacoes          
#INCLUDE "PROTHEUS.CH"
User function TTEST22()

//��������������������������������������������������������������Ŀ
//� Pega a variavel que identifica se o calculo do custo e' :    �
//�               O = On-Line                                    �
//�               M = Mensal                                     �
//����������������������������������������������������������������
PRIVATE cCusMed  := GetMv("MV_CUSMED")
PRIVATE cCadastro:= "Transfer�ncias"  //OemToAnsi(STR0001)
PRIVATE aRegSD3  := {}
//��������������������������������������������������������������Ŀ
//� Verifica se o custo medio e' calculado On-Line               �
//����������������������������������������������������������������
PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque

If cEmpAnt <> "01"
	Return
EndIf

	//��������������������������������������������������������������Ŀ
	//� Posiciona numero do Lote para Lancamentos do Faturamento     �
	//����������������������������������������������������������������
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo	// Nome do arquivo contra prova

//para estorno passar o 15o. par�metro com .T.
a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest)

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A260Processa  � Eveli Morasco             � Data � 16/01/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento da inclusao                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC01: Codigo do Produto Origem - Obrigatorio              ���
���          �ExpC02: Almox Origem             - Obrigatorio              ���
���          �ExpN01: Quantidade 1a UM         - Obrigatorio              ���
���          �ExpC03: Documento                - Obrigatorio              ���
���          �ExpD01: Data                     - Obrigatorio              ���
���          �ExpN02: Quantidade 2a UM                                    ���
���          �ExpC04: Sub-Lote                 - Obrigatorio se Rastro "S"���
���          �ExpC05: Lote                     - Obrigatorio se usa Rastro���
���          �ExpD02: Validade                 - Obrigatorio se usa Rastro���
���          �ExpC06: Numero de Serie                                     ���
���          �ExpC07: Localizacao Origem                                  ���
���          �ExpC08: Codigo do Produto Destino- Obrigatorio              ���
���          �ExpC09: Almox Destino            - Obrigatorio              ���
���          �ExpC10: Localizacao Destino                                 ���
���          �ExpL01: Indica se movimento e estorno                       ���
���          �ExpN03: Numero do registro original (utilizado estorno)     ���
���          �ExpN04: Numero do registro destino (utilizado estorno)      ���
���          �ExpC11: Indicacao do programa que originou os lancamentos   ���
���          �ExpC12: cEstFis    - Estrutura Fisica          (APDL)       ���
���          �ExpC13: cServico   - Servico                   (APDL)       ���
���          �ExpC14: cTarefa    - Tarefa                    (APDL)       ���
���          �ExpC15: cAtividade - Atividade                 (APDL)       ���
���          �ExpC16: cAnomalia  - Houve Anomalia? (S/N)     (APDL)       ���
���          �ExpC17: cEstDest   - Estrututa Fisica Destino  (APDL)       ���
���          �ExpC18: cEndDest   - Endereco Destino          (APDL)       ���
���          �ExpC19: cHrInicio  - Hora Inicio               (APDL)       ���
���          �ExpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)       ���
���          �ExpC21: cCarga     - Numero da Carga           (APDL)       ���
���          �ExpC22: cUnitiza   - Numero do Unitizador      (APDL)       ���
���          �ExpC23: cOrdTar    - Ordem da Tarefa           (APDL)       ���
���          �ExpC24: cOrdAti    - Ordem da Atividade        (APDL)       ���
���          �ExpC25: cRHumano   - Recurso Humano            (APDL)       ���
���          �ExpC26: cRFisico   - Recurso Fisico            (APDL)       ���
���          �ExpN05: nPotencia  - Potencia do Lote                       ���
���          �ExpC27: cLoteDest  - Lote Destino da Transferencia          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Transferencia                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
