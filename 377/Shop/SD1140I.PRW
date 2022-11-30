/*/{Protheus.doc} SD1140I
Descrição:
LOCALIZAÇÃO  : Function Ma140Grava() - Responsável por atualizar um pre-documento de entrada e seus anexos.

EM QUE PONTO : ponto de entrada na atualizacao dos itens do pre-documento de entrada.

Programa Fonte
MATA140.PRW
Sintaxe
SD1140I ( ) --> Nil

Retorno
Nil(nulo)

@author Jonas Gouveia
@since 10/02/2016
@version 2.0

@todo Criar campo F1_TKT006 (Tipo: Caracter, Tamanho: 8)

@history 03/10/2017,Jonas Gouveia,adicionado regra para preenchimento do campo D1_RATEIO para corrigir um erro na versão
@history 19/04/2018,Jonas Gouveia,retirado regra para preenchimento do campo D1_RATEIO.
@history 10/02/2019,Jonas Gouveia,incluído campo F1_TKT006 dentro do ReckLock  


@obs 
Ponto de entrada utilizado para cancelar os chamados filhos para inclusão de pre nota no movidesk.  
@type function
/*/
User Function SD1140I


// Incluido por Jonas Gouveia - 15/12/2021
// Para não entrar no PE quando vir da API FLuig.
/*
If UPPER(Funname()) ==  "INCDOCENT"
   Return .T.
End 
*/
If !"MATA094" $ Funname()

RecLock("SF1",.F.)
SF1->F1_XLINK   := cXTexto
//SF1->F1_USER    := RetCodUsr()
MSUnlock()

Endif

Return()
