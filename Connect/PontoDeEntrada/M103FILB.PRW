#INCLUDE 'PROTHEUS.CH'

User Function M103FILB  

Local cRet:= ""       
Local cSupUsr := SUPERGETMV('TI_PODCMP' ,.F., 'Administrador')                      

If !Alltrim(cusername) $ cSupUsr
    cRet += " F1_FILIAL='"+xFilial("SF1")+"' AND F1_ESPECIE ='SPED' " 
EndIF

Return cRet
