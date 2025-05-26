// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} FA040GRV
    Ponto de entrada para gravação complementar após a persistência de todos os dados
    referentes ao título a receber, porém antes da contabilizacao.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 19/10/2022
    @return Variant, Retorno nulo fixado
    @link https://tdn.totvs.com/pages/releaseview.action?pageId=6071098
/*/
User Function FA040GRV() As Variant
    // Variáveis locais
    Local aArea     As Array   // Estado da área anteriormente posicionada
    Local nTaxValue As Numeric // Acumulado dos valores de impostos para o título
    Local nIncrease As Numeric //
    Local nDecrease As Numeric //

    // Inicialização das variáveis
    aArea     := FwGetArea()
    nTaxValue := U_GetTaxValues()
    nIncrease := E1_ACRESC
    nDecrease := E1_DECRESC

    // Grava o valor líquido removendo os impostos + decréscimos e somando os acréscimos no valor total
    DBSelectArea("SE1")
    RecLock("SE1", .F.)
        E1_XVALLIQ := E1_VALOR - nTaxValue + nIncrease - nDecrease
    MsUnlock()

    // Restaura a área anteriormente posicionada
    FwRestArea(aArea)
    FwFreeArray(aArea)
Return (NIL)

/*/{Protheus.doc} GetTaxValues
    Captura o somatório dos impostos com base no título atualmente posicionado.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 19/10/2022
    @return Numeric, Somatório dos valores de impostos
/*/
User Function GetTaxValues() As Numeric
    // Variáveis locais
    Local aArea     As Array     // Estado da área anteriormente posicionada
    Local cAlias    As Character // Alias do arquivo temporário
    Local nTaxValue As Numeric   // Acumulado dos valores de impostos para o título

    // Inicialização de variáveis
    aArea     := FwGetArea()
    cAlias    := GetNextAlias()
    nTaxValue := 0

    // Busca pelos títulos de impostos relacionados
    BEGINSQL ALIAS cAlias
        SELECT
            SUM(SE1.E1_VALOR) AS E1_VALIMP
        FROM
            %TABLE:SE1% SE1
        WHERE
            SE1.E1_FILIAL      = %EXP:SE1->E1_FILIAL%
            AND SE1.E1_PREFIXO = %EXP:SE1->E1_PREFIXO%
            AND SE1.E1_NUM     = %EXP:SE1->E1_NUM%
            AND SE1.E1_PARCELA = %EXP:SE1->E1_PARCELA%
            AND SE1.E1_TIPO IN (
                'AB-',
                'FB-',
                'FC-',
                'FU-',
                'FP-',
                'IR-',
                'IN-',
                'IS-',
                'PI-',
                'CF-',
                'CS-',
                'FE-',
                'IV-',
                'I2-',
                'IM-'
            )
            AND SE1.%NOTDEL%
    ENDSQL

    // Captura o valor de impostos
    nTaxValue := E1_VALIMP

    // Fecha a área de trabalho
    DBSelectArea(cAlias)
    DBCloseArea()

    // Restaura a área anteriormente posicionada
    FwRestArea(aArea)
    FwFreeArray(aArea)
Return (nTaxValue)
