#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GetCodCli� Autor � Ricardo Souza         � Data � 29/12/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica qual a proxima loja para o cadastro do cliente.   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� c_CgcCli => CNPJ do Cliente.                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � a_CodCli => Array com o codigo e loja do cliente.          ���
���          �     [1] - Codigo do cliente                                ���
���          �     [2] - Loja do cliente.                                 ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function GetCodCli(c_CgcCli)
	
	Local a_AreaATU	:= GetArea()
	Local a_AreaSA1	:= SA1->(GetArea())
	Local c_LojAux	:= ""
	
	If M->A1_PESSOA == "J"
	
		DbSelectArea("SA1")
		DbSetOrder(3)
		
		If (M->A1_TIPO <> 'X') .And. DbSeek(xFilial("SA1")+Left(c_CgcCli, 8), .F.) //Validacao p/ cliente exportacao nao entrar como filial de clientes
			M->A1_COD := SA1->A1_COD												                                                                               
			While SA1->(!Eof()) .And. Left(SA1->A1_CGC, 8) == Left(c_CgcCli, 8)
				If SA1->A1_LOJA > c_LojAux
					c_LojAux := SA1->A1_LOJA
				Endif
				SA1->(DbSkip())
			Enddo
			M->A1_LOJA := Soma1(c_LojAux)
		Else
			M->A1_LOJA := "0001"
		Endif
    
    Else
    
    	SA1->(RollbackSX8())
		M->A1_COD := GetSxeNum("SA1")
		M->A1_LOJA := "0001"

    Endif
    
	RestArea(a_AreaSA1)
	RestArea(a_AreaATU)
	
Return c_CgcCli
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GetCodFor� Autor � Ricardo Souza         � Data � 29/12/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica qual a proxima loja para o cadastro do Fornecedor.���
�������������������������������������������������������������������������Ĵ��
���Parametros� c_CgcFor => CNPJ do Fornecedor.                            ���
�������������������������������������������������������������������������Ĵ��
���OBSERVACAO� Essa funcao so sera valida para fornecedores do com o tipo ���
���          �Juridico.                                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � a_CodFor => Array com o codigo e loja do fornecedor.       ���
���          �     [1] - Codigo do fornecedor                             ���
���          �     [2] - Loja do fornecedor                               ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function GetCodFor(c_CgcFor)
	
	Local a_AreaATU	:= GetArea()
	Local a_AreaSA2	:= SA2->(GetArea())
	Local c_LojAux	:= ""
	
	If M->A2_TIPO == "J"
	
		DbSelectArea("SA2")
		DbSetOrder(3) //A2_FILIAL, A2_CGC, R_E_C_N_O_, D_E_L_E_T_
		
		If DbSeek(xFilial("SA2")+Left(c_CgcFor, 8), .F.)
			M->A2_COD := SA2->A2_COD												 
			While SA2->(!Eof()) .And. Left(SA2->A2_CGC, 8) == Left(c_CgcFor, 8)
				If SA2->A2_LOJA > c_LojAux
					c_LojAux := SA2->A2_LOJA
				Endif
				SA2->(DbSkip())
			Enddo
			M->A2_LOJA := Soma1(c_LojAux)
		Else
	    	SA2->(RollbackSX8())
			M->A2_COD := GetSxeNum("SA2")
			M->A2_LOJA := "0001"
		Endif
    
    Else
    	
    	SA2->(RollbackSX8())
		M->A2_COD := GetSxeNum("SA2")
		M->A2_LOJA := "0001"
    
    Endif
    
	RestArea(a_AreaSA2)
	RestArea(a_AreaATU)
	
Return c_CgcFor
