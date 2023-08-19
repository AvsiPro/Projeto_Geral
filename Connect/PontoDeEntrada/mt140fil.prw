#INCLUDE 'PROTHEUS.CH'

user Function MT140FIL()

Local cRet:= ""       
Local cSupUsr := SUPERGETMV('TI_PODCMP' ,.F., 'Administrador')                      

If !Alltrim(cusername) $ cSupUsr
    cRet += " F1_FILIAL='"+xFilial("SF1")+"' AND F1_ESPECIE ='SPED' " 
EndIF

Return cRet
