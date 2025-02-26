#Include 'Protheus.ch'

/*/{Protheus.doc}	CADZZ1
Cadastro do Status Pedido ACD.

@author				Paulo Lima
@since				01/02/2022
@return				Nil
/*/
User Function CADZZ1()

	Local cVldAlt := ".F." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
	
	Private cString := "ZZ1"
	
	dbSelectArea("ZZ1")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Status pelo ACD",cVldExc,cVldAlt)

Return
