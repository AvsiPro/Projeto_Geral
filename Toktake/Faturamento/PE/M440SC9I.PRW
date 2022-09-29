#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440SC9I  ºAutor  ³CADUBITSKI	         º Data ³  03/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na gravacao do SC9 para gravar campos     º±±
±±º          ³ especificos do SC5.                                        º±±
±±º          ³ So e executado quando gera o SC9, se for liberar novamente,º±±
±±º          ³ ele nao passa por esse PE.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³          Chamada na função FATXFUN()                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M440SC9I()



// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf


SC9->C9_XDTENTR := SC5->C5_XDTENTR 	//Aqui pode ser SC6 tb, pois está posicionado.
If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR. SM0->M0_CODIGO=="11"
	SC9->C9_XDESCLI := SC5->C5_XDESCLI
	SC9->C9_XNOMUSR := SC5->C5_XNOMUSR
	SC9->C9_XOPER   := SC5->C5_XOPER
	SC9->C9_XTES    := SC6->C6_TES    
	SC9->C9_DESCRI  := SC6->C6_DESCRI
	SC9->C9_XTRANSP := SC5->C5_TRANSP
	SC9->C9_XDESCTR := SC5->C5_DESCTRA
	SC9->C9_XTPCARG := SC5->C5_XTPCARG
	SC9->C9_XGPV    := SC5->C5_XGPV
	SC9->C9_XUSRLIB := Upper(AllTrim(cusername))
	SC9->C9_XDATLIB := DATE()
	SC9->C9_XHRLIB  := TIME() 
	//Venda PA não pode ficar bloqueada por estoque
	//Item 88 da lista de pendencias.
	If SC5->C5_XFINAL $ "2/T/J/S/2/B/O/8"
		SC9->C9_BLCRED := ' '
	EndIf
End


Return()