#include 'protheus.ch'
#include 'parmtype.ch'

/*
   {Protheus.doc} MT100GE2
   Ponto de entrada MT100GE2  Complem a grav na tabela dos títulos financeiros a pagar
   03-MIT 44 FINANCEIRO FIN012- Criação campo CNPJ no cadastro do fornecedor e no título a pagar
   https://docs.google.com/document/d/10MRiybMe2fEDU-ExeFmq0RJonosTqANV/edit
   SE2->E2_ZCGCBOL := SA2->A2_ZCGCBOL os campos precisam existir no dicionário
   https://tdn.totvs.com/pages/releaseview.action?pageId=6085781
*/

User Function MT100GE2()
        Local aTitAtual := PARAMIXB[1]
        Local nOpc := PARAMIXB[2]
        Local aHeadSE2:= PARAMIXB[3]
        Local aParcelas := ParamIXB[5]
        Local nX := ParamIXB[4]

        If nOpc == 1 //.. inclusao
                SE2->E2_ZCGCBOL := SA2->A2_ZCGCBOL 
        Endif
Return
