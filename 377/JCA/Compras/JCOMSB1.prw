#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function JCOMSB1

Local oModel      := Nil
Private lMsErroAuto := .F.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

oModel  := FwLoadModel ("MATA010")
oModel:SetOperation(3) //MODEL_OPERATION_INSERT
oModel:Activate()
oModel:SetValue("SB1MASTER","B1_GRUPO"      ,"0103")
oModel:SetValue("SB1MASTER","B1_COD"        ,"RASB100")
oModel:SetValue("SB1MASTER","B1_DESC"       ,"PRODUTO TESTE 00")
oModel:SetValue("SB1MASTER","B1_TIPO"       ,"PA")
oModel:SetValue("SB1MASTER","B1_UM"         ,"UN")
oModel:SetValue("SB1MASTER","B1_LOCPAD"     ,"01")
oModel:SetValue("SB1MASTER","B1_LOCALIZ"    ,"N")
oModel:SetValue("SB1MASTER","B1_POSIPI"     ,"00000000  ")
oModel:SetValue("SB1MASTER","B1_ORIGEM"     ,"0")


If oModel:VldData()
    oModel:CommitData()
     MsgInfo("Registro INCLUIDO!", "Atenção")
Else
    VarInfo("",oModel:GetErrorMessage())
EndIf       

oModel:DeActivate()
oModel:Destroy()

oModel := NIL

Return Nil
