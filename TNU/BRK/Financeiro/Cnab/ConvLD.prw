#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³CONVLD    ºAutor  ³Eduardo Augusto      º Data ³  17/05/2013 	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para Conversão da Representação Numérica do Código de º±±
±±º          ³ Barras - Linha Digitável (LD) em Código de Barras (CB).      º±±
±±º			 ³																º±±
±±º			 ³ Para utilização dessa Função, deve-se criar um Gatilho para oº±±
±±º			 ³ campo E2_CODBAR, Conta Domínio: E2_CODBAR, Tipo: Primário,   º±±
±±º			 ³ Regra: EXECBLOCK("CONVLD",.T.), Posiciona: Não.   			º±±
±±º			 ³                                                              º±±          
±±º			 ³ Utilize também a Validação do Usuário para o Campo E2_CODBAR º±±
±±º    		 ³ EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.  			º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Expressa Distribuidora de Medicamentos Ltda					º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CONVLD()
                      
SetPrvt("cStr")
	cStr := Alltrim(M->E2_CODBAR)
	If ValType(M->E2_CODBAR) == Nil .OR. Empty(M->E2_CODBAR)
		// Se o Campo está em Branco não Converte nada.
		cStr := ""
	Else
		// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
		cStr := If(Len(cStr)<44,cStr + Repl("0",47-Len(cStr)),cStr)
	EndIf
Do Case
Case Len(cStr) == 47
	cStr := Substr(cStr,1,4) + Substr(cStr,33,15) + Substr(cStr,5,5) + Substr(cStr,11,10) + Substr(cStr,22,10)
Case Len(cStr) == 48
   cStr := Substr(cStr,1,11) + Substr(cStr,13,11) + Substr(cStr,25,11) + Substr(cStr,37,11)
OtherWise
	cStr := cStr + Space(48-Len(cStr))
EndCase
Return(cStr)