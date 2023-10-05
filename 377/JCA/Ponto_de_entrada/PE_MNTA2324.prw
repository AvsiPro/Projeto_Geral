#INCLUDE 'PROTHEUS.CH'

User Function MNTA2324(xy)
Local aEsquema  := Paramixb
Local lRet      := .T.
Local cEixoAlt  := aEsquema[2]
//Local cEstNew   := SuperGetMV("TI_ESTNEW",.F.,"61") //Estoque de pneu novo no campo status

//If nNrEixos == 3
/* 1=OR;2=R1;3=R2;4=R3;5=R4
1o Eixo Direcional – Pneu novo/usado (sem conserto ou recape);
2o Eixo Direcional (Carro 8x2) – Pneu novo/usado (sem conserto ou recape);
Eixo traseiro – Pneu novo, recape, conserto ou usado;
Step – Novo ou usado (sem conserto ou recape);*/
If Alltrim(cEixoAlt) $ "DD/DE/DD2/DE2/EST"
    If TQS->TQS_BANDAA <> "1"
        MsgAlert("Pneu não pode ser utilizado neste eixo","PE_MNTA2317")
        lRet := .F.
    EndIf

    /*If ST9->T9_STATUS <> Alltrim(cEstNew) .AND. lRet
        MsgAlert("Pneu não pode ser utilizado neste eixo","PE_MNTA2317")
        lRet := .F.    
    EndIf */


EndIf 


Return(lRet)
