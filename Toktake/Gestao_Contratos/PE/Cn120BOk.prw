#DEFINE PULALINHA CHR(10)+CHR(13)

 

User Function Cn120BOk()

 

Local cContrato := ParamIXB[1]

Local cRevisao := ParamIXB[2]

Local cPlanilha := ParamIXB[3]

Local cParcela := ParamIXB[4]

Local cMsg := ""

Local cTitulo := "Ponto de Entrada CN120BOK"

 

cMsg := "Contrato: "+cContrato +PULALINHA

cMsg += "Revis�o: "+cRevisao +PULALINHA

cMsg += "Planilha: " +cPlanilha +PULALINHA

cMsg += "Parcela: " +cParcela +PULALINHA

 

MsgInfo(cMsg,cTitulo)

 

Return NIL


