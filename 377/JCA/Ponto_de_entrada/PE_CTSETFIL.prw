#INCLUDE 'PROTHEUS.CH'

/*
    Trazer somente filiais do grupo posicionado na sele��o de relat�rios
    MIT 44_Contabilidade_CTB009_Sele��o autom�tica empresa filial_

    DOC MIT
    https://docs.google.com/document/d/1TWdO_pedSOnXbSvMQUtdBQzYdPCcDoJ9/edit
    DOC Entrega
    
    ********************************************
    DEFINIR AINDA O CRIT�RIO PARA APRESENTAR AS FILIAIS
*/

User Function CTSETFIL

Local aArea := GetArea()
Local aRet  := {}

Aadd(aRet,{'00020087','AUTO VIACAO 1001 - ESCRITORIO CENTRAL   ','30.069.314/0001-01'})

RestArea(aArea)

Return(aret)


