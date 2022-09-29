#include "TOTVS.CH"
#include "fileio.ch"
#Include "Restful.Ch"
#include "FWMVCDEF.CH"
#Include "topconn.ch"
#Include "tbiconn.ch"
#include "fileio.ch"

User Function ROBGEN07

Local aRet 		:=	{}
Local aPergs	:=	{}
Local cSer		:=	space(3)
Local cNota		:=	space(9)
Local cCopia    :=  space(254)
Local cPathL    :=  'C:\Temp\'
Local cRemete   := "No-Reply Robsol <noreply@robsol.com.br>"
Local cBody     :=  corpo()                               
Local cSubject	:=	"Boleto de pagamento"
Local aArquivos := {}           
Local cDestino	:=	"alexandre.venancio@avsipro.com.br;financeiro@robsol.com.br"
Local nHandlel	:=	0
Local cCliName  :=  ''


If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

aAdd( aPergs ,{1,"Serie : "     ,cSer   ,"@!",'.T.',"",'.T.',40,.F.})
aAdd( aPergs ,{1,"Nota De : "   ,cNota  ,"@!",'.T.',"",'.T.',50,.F.})
aAdd( aPergs ,{1,"Nota Ate : "  ,cNota  ,"@!",'.T.',"",'.T.',50,.F.})
aAdd( aPergs ,{1,"Copia para : ",cCopia ,"@!",'.T.',"",'.T.',250,.F.})

If ParamBox(aPergs ,"Informe o local do arquivo",@aRet)
	cRet1 := aRet[1]
	cRet2 := val(aRet[2])
	cRet3 := val(aRet[3])
    cRet4 := aRet[4]

	If !ExistDir( cPathL )
        MakeDir( cPathL )
    EndIf

    If !ExistDir( cPathL+'Processados\')
        MakeDir(cPathL+'Processados\')
    ENDIF

    cFile := dtos(ddatabase)+strtran(cvaltochar(time()),":")

    nHandlel := fcreate(cPathL+'Processados\'+cFile+'.txt', FO_READWRITE + FO_SHARED )

    For cNota := cRet2 to cRet3
        aArquivos := {}
        MV_PAR01 := cRet1
        MV_PAR02 := strzero(cNota,9)
        DbSelectArea("SE1")
        DbSetOrder(1)
        If DbSeek(xFilial("SE1")+Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM"))
            DbSelectArea("SA1")
            DbSetOrder(1)
            cDestino := ''
            If Dbseek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
                cDestino := Alltrim(SA1->A1_EMAIL)
                cCliName := Alltrim(SA1->A1_NOME)+" / "+Alltrim(SA1->A1_NREDUZ)
            EndIf

            Fwrite(nHandlel,'Nota - '+strzero(cNota,9)+' # e-mail '+Alltrim(cDestino)+' # Cliente '+cCliName+CRLF,10000)
                    
            U_ROBBOL(.t.,cPathL)
            CpyT2S(cPathL+'boleto_'+strzero(cNota,9)+'.pdf','\spool\')
            Aadd(aArquivos,{"\spool\"+'boleto_'+strzero(cNota,9)+'.pdf',''})
            
            If !Empty(cDestino)
                If !Empty(cRet4)
                    cDestino := Alltrim(cDestino)+";"+Alltrim(cRet4)
                EndIf
                //cDestino := 'alexandre.venancio@avsipro.com.br'
                U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)   
            else
                Fwrite(nHandlel,'Nota - '+strzero(cNota,9)+' # Cliente '+cCliName+' # Sem E-mail cadastrado'+CRLF,10000)
            EndIf
        EndIf
    
    Next cNota

    fclose(nHandlel)
    WinExec('NOTEPAD '+ cPathL+'Processados\' + cFile+'.txt',1)

EndIf


Return

/*/{Protheus.doc} Corpo
    (long_description)
    @type  Static Function
    @author user
    @since 07/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function corpo

Local cRet := ""

cRet := If(val(substr(time(),1,2))<12 .and.val(substr(time(),1,2))>=0,'Bom dia','Boa tarde' )+'<br><br>'

cRet += "Pedimos para que caso tenham recebido algum boleto junto ao seu pedido de Notas Fiscais emitidas em 01/02/2022 a 18/02/2022, desconsidere os mesmos e considere boleto em anexo como o boleto correto, fazendo a substituição de todas as outras parcelas<br>"

cRet += "Qualquer dúvida estamos à disposição, podendo entrar em contato por esse e-mail, ou outros canais de comunicação a baixo, podem confirmar também com seu representante da região<br>"

cRet += "Dicas de Segurança<br>"
cRet += "Fique atento: Seus boletos sempre chegarão pelo remetente do Dominio: <p> ROBSOL.COM.BR </p><br>"
cRet += "Ex.: noreply@robsol.com.br financeiro@robsol.com.br<br>"
cRet += "Ao pagar confira sempre o CNPJ e o FAVORECIDO<br>"
cRet += "ROBSOL COM.IND<br>"
cRet += "23.824.405/0001-40<br>"
cRet += "23.824.405/0002-20<br>"

cRet += "Celular / WhatsApp: (11) 98577-0022<br>"
cRet += "Telefone: (11) 5082-1955<br><br>"
cRet += "e-mail financeiro3@robsol.com.br<br><br>"

cRet += "Att, Rick"

Return(cRet)
