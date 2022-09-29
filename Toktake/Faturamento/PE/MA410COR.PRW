/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410COR  ºAutor  ³Alexandre Venancio  º Data ³  13/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada pertence à rotina de pedidos de vendaº±±
±±ºDesc.     ³MATA410(). Usado, em conjunto com o ponto MA410LEG, para    º±±
±±ºDesc.     ³ alterar cores do “browse” do cadastro, que representam o   º±±
±±ºDesc.     ³ status” do pedido. 										  º±±
±±º          ³ liberados ou faturados parcialmente.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Copel                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA410COR()

Local aArea		:= GetArea()
Local aCores	:= {}

// Tratamento para AMC
/*If cEmpAnt == "10"
	Return aCores
EndIf */


//ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»
//º Status    ³ C5_LIBEROK ³ C5_NOTA ³ C5_BLQ ³ C9_PEDIDO º
//ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍ¹
//º Aberto    ³   Vazio    ³  Vazio  ³ Vazio  ³   Vazio   º
//º Encerrado ³    'E'     ³Nao Vazio³ Vazio  ³ Nao Vazio º
//º Liberado  ³ Nao Vazio  ³  Vazio  ³ Vazio  ³ --------- º
//º Blq. Regra³ ---------- ³ ------- ³  '1'   ³ --------- º
//º Blq. Verba³ ---------- ³ ------- ³  '2'   ³ --------- º
//º Parc. Lib.³   Vazio    ³  Vazio  ³ Vazio  ³   Vazio   º
//ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¼

If SC5->(FieldPos("C5_BLQ")) == 0
	aCores := {	{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .AND. Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_PEDIDO'))",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA) .Or. C5_LIBEROK == 'E'",'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA)",'BR_AMARELO'},;	//Pedido Liberado
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC6',1,SC6->C6_FILIAL + SC6->C6_NUM,'C6_OP'))",'BR_MARROM'},;
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. !Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_PEDIDO'))","BR_PINK" }}	//Pedido Parcialmente Liberado
Else
	aCores := {{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_NFISCAL'))",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA) .Or. C5_LIBEROK == 'E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_AMARELO'},;
				{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
				{ "C5_BLQ == '2'",'BR_LARANJA'},;	//Pedido Bloquedo por verba  
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC6',1,SC6->C6_FILIAL + SC6->C6_NUM,'C6_OP'))",'BR_MARRON'},;
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_NFISCAL'))","BR_PINK" }}	//Pedido Parcialmente Liberado - JM 20/03/07

Endif

RestArea(aArea)

Return aCores