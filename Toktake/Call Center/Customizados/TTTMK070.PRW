#INCLUDE "PROTHEUS.CH"

User Function TTTmk070()
Local aContato := {}
Local aEndereco := {}
Local aTelefone := {}
Local aAuxDados := {}
Private lMsErroAuto := .F.
AAdd(aContato,{"U5_FILIAL", xFilial("SU5"),Nil})
AAdd(aContato,{"U5_CODCONT","002673", Nil})
AAdd(aContato,{"U5_CONTAT","ROSE SAC", Nil})
AAdd(aContato,{"U5_EMAIL","teste@totvs.com.br", Nil})  
AAdd(aContato,{"U5_CLIENTE","001886", Nil})  
AAdd(aContato,{"U5_LOJA","0001", Nil})  

AAdd(aAuxDados, {"AGB_TIPO", "1", Nil})
AAdd(aAuxDados, {"AGB_PADRAO", "1", Nil})
//AAdd(aAuxDados, {"AGB_DDI", "55", Nil})
AAdd(aAuxDados, {"AGB_DDD", "11", Nil})
AAdd(aAuxDados, {"AGB_TELEFO", "12349874", Nil})
AAdd(aTelefone, aAuxDados)
aAuxDados := {}
AAdd(aAuxDados, {"AGA_TIPO", "1", Nil})
AAdd(aAuxDados, {"AGA_PADRAO", "1", Nil})
AAdd(aAuxDados, {"AGA_END", "R. Totvs", Nil})
AAdd(aAuxDados, {"AGA_CEP", "12345123", Nil})
AAdd(aAuxDados, {"AGA_BAIRRO", "Bairro Totvs", Nil})
AAdd(aAuxDados, {"AGA_MUNDES", "Cidade Totvs", Nil})
AAdd(aAuxDados, {"AGA_EST", "SP", Nil})
AAdd(aEndereco, aAuxDados)
MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aContato,3,aEndereco,aTelefone, .F.) 
If lMsErroAuto 
    MsgStop("Erro na gravação do contato") 
Else 
    MsgAlert('Incluido contato com sucesso.') 
EndIf
Return
