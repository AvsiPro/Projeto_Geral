#INCLUDE "PROTHEUS.CH"

User Function JUBPAP07()

Local aArea := GetArea()
Local cRet  := ''
Local aArray := {}
Local nCont

    Aadd(aArray,{'A','Descascando'})
    Aadd(aArray,{'B','Trincado'})
    Aadd(aArray,{'C','Oxidacao'})
    Aadd(aArray,{'D','Riscada'})
    Aadd(aArray,{'E','Quebrada'})
    Aadd(aArray,{'F','Quebrada na Solda'})
    Aadd(aArray,{'G','Solta'})
    Aadd(aArray,{'H','Parafuso Espanado'})
    Aadd(aArray,{'I','Defeito na Ponteira'})
    Aadd(aArray,{'J','Tonalidades Diferentes'})
    Aadd(aArray,{'L','Manchada'})
    Aadd(aArray,{'N','Suporte de Plaquetas'})
    Aadd(aArray,{'M','Defeito na Mola'})

For nCont := 1 to len(aArray)
    cRet += aArray[nCont,01]+"="+aArray[nCont,02]+";"
Next nCont

RestArea(aArea)

Return(cRet)
