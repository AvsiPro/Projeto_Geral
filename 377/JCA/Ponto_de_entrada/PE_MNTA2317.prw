#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validar se o pneu pode ser utilizado no eixo
*/
User Function MNTA2317()

Local lRet := .T. 
Local cEstNew   := SuperGetMV("TI_ESTNEW",.F.,"61") //Estoque de pneu novo no campo status
Local nNrEixos  := TQ0->TQ0_EIXOS
Local cEstepe   := '' //Ac[ascan(AC,{|x| Alltrim(x[3]) == "EST" }),3]


/*
    CREADVAR PNEU EIXO
    TQS_BANDAA - Estado atual do pneu
    1=OR;2=R1;3=R2;4=R3;5=R4
    1o Eixo Direcional – Pneu novo/usado (sem conserto ou recape);
    2o Eixo Direcional (Carro 8x2) – Pneu novo/usado (sem conserto ou recape);
    Eixo traseiro – Pneu novo, recape, conserto ou usado;
    Step – Novo ou usado (sem conserto ou recape);

*/

If "E1" $ CREADVAR .OR. nNrEixos == 4 .or. Alltrim(cEstepe) == "EST"
    If TQS->TQS_BANDAA <> "1"
        MsgAlert("Pneu não pode ser utilizado neste eixo","PE_MNTA2317")
        lRet := .F.
    EndIf 

    /*If ST9->T9_STATUS <> Alltrim(cEstNew) .AND. lRet
        MsgAlert("Pneu não pode ser utilizado neste eixo","PE_MNTA2317")
        lRet := .F.    
    EndIf  */

EndIf 

Return lRet

