#INCLUDE 'protheus.ch'

User Function MA020BUT()

Local aButtons := {} // bot�es a adicionar

AAdd(aButtons,{ 'CONSULTAR'      ,{| |  U_zCNPJSA2() }, 'Consulta CNPJ','Consulta' } )

Return (aButtons)
