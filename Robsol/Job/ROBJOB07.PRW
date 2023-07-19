#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBJOB07()

Local nDia1 := 21
Local nDia2 := 149
Local nDia3 := 364
Local nDia4 := 729
Local nDia5 := 1094
Local cAuxD1 := ''
Local cAuxD2 := ''
Local nCont := 1
Local cRemete   := "No-Reply Robsol <noreply@robsol.com.br>"
Local cSubject	:=	"Pendencias - Robsol Industria Ltda"
Local cDestino	:=	"alexandre.venancio@avsipro.com.br;adm@robsol.com.br;cnoculos@hotmail.com;financeiro3@robsol.com.br;financeiro1@robsol.com.br;financeiro@robsol.com.br"
	

Private aAuxEn := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0103")
EndIf

If dow(ddatabase) == 6
    cAuxD1 := dtos(ddatabase-nDia1)
    cAuxD2 := dtos(ddatabase-nDia2)

    BuscaTit(cAuxD2,cAuxD1,nDia2)

Elseif dow(ddatabase) == 5

    cAuxD1 := dtos(ddatabase-(nDia2+1))
    cAuxD2 := dtos(ddatabase-nDia3)

    BuscaTit(cAuxD2,cAuxD1,nDia3)

Elseif dow(ddatabase) == 4

    cAuxD1 := dtos(ddatabase-(nDia3+1))
    cAuxD2 := dtos(ddatabase-nDia4)

    BuscaTit(cAuxD2,cAuxD1,nDia4)

Elseif dow(ddatabase) == 3

    cAuxD1 := dtos(ddatabase-(nDia4+1))
    cAuxD2 := dtos(ddatabase-nDia5)

    BuscaTit(cAuxD2,cAuxD1,nDia5)

Elseif dow(ddatabase) == 2

    cAuxD1 := dtos(ddatabase-(nDia5+1))
    cAuxD2 := ''

    BuscaTit(cAuxD2,cAuxD1,nDia5+1)
EndIf 

If len(aAuxEn) > 0
    For nCont := 1 to len(aAuxEn)
        aAuxEn[nCont,07] := GerHtml(aAuxEn[nCont,1],aAuxEn[nCont,2],aAuxEn[nCont,06])
    Next nCont

    For nCont := 1 to len(aAuxEn)
        U_robmail(cRemete,Alltrim(aAuxEn[nCont,03]),cSubject,aAuxEn[nCont,07],{},.T.)
    Next nCont 

    cBody := MailDisp()
    U_robmail(cRemete,cDestino,cSubject,cBody,{},.T.)

EndIf

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaTit(cAuxD2,cAuxD1,nDias)

Local aArea     :=  GetArea()
Local cQuery 

cQuery := "SELECT E1_CLIENTE,E1_LOJA,A1_NOME,A1_CGC,A1_EMAIL,SUM(E1_SALDO) AS SALDO"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=E1_FILIAL AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE E1_FILIAL='"+xFilial("SE1")+"' AND E1_BAIXA=' '"
cQuery += " AND E1.D_E_L_E_T_=' '"

If !Empty(cAuxD2)
    cQuery += " AND E1_VENCREA BETWEEN '"+cAuxD2+"' AND '"+cAuxD1+"'"
else
    cQuery += " AND E1_VENCREA <= '"+AuxD1+"'"
EndIf 

cQuery += " GROUP BY E1_CLIENTE,E1_LOJA,A1_NOME,A1_CGC,A1_EMAIL"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

While !EOF()
    Aadd(aAuxEn,{TRB->A1_NOME,;
                TRB->A1_CGC,;
                TRB->A1_EMAIL,;
                TRB->E1_CLIENTE,;
                TRB->E1_LOJA,;
                nDias,;
                "",;
                TRB->SALDO})
    Dbskip()
EndDo

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples);
    @see (links_or_references)
/*/
Static Function GerHtml(cRazao,cCnpj,nDias)

Local cHtml := ""

cHtml += "<html>"
cHtml += "<body>"
cHtml += "<h1>Prezado (a) , responsável pela empresa: "+Alltrim(cRazao)+" - "+Transform(cCnpj,"@R 99.999.999/9999-9#")+"</h1>"
cHtml += "Informamos que consta em nosso sistema boleto(s) em aberto da empresa acima.<br><br>"

If nDias > 150
    cHtml += "Estamos em aberto para negociação do seu débito. Para que possa regularizar esta pendencia, pedimos para entrar em contato com o Departamento Financeiro da Robsol.<br><br>"
Else 
    cHtml += "Por favor, entrar em contato com o Departamento Financeiro da Robsol, para regularizar a sua pendencia.<br><br>"
EndIf 

cHtml += "Telefone: (11) 5082-1955<br>"
cHtml += "<b>Emails:</b> financeiro@robsol.com.br / financeiro3@robsol.com.br / financeiro1@robsol.com.br<br><br>"
cHtml += "Caso sua pendencia já tenha sido resolvida, peço para que desconsidere a mensagem."
cHtml += "</body>"
cHtml += "</html>"

Return(cHtml)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 18/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MailDisp()

Local cHtml := ""
Local nCont := 0

cHtml += "<html>"
cHtml += "<style>"
cHtml += "table, th, td {"
cHtml += "  border:1px solid black;"
cHtml += "}"
cHtml += "</style>"
cHtml += "<body>"
cHtml += "<h2>Cobranças com mais de 20 dias de atraso</h2>"
cHtml += "<table style='width:100%'>"
cHtml += "  <tr>"
cHtml += "    <th>Cliente</th>"
cHtml += "    <th>Email</th>"
cHtml += "    <th>Valor</th>"
cHtml += "  </tr>"

For nCont := 1 to len(aAuxEn)
    cHtml += "  <tr>"
    cHtml += "    <td>"+aAuxEn[nCont,01]+" - "+Transform(aAuxEn[nCont,02],"@R 99.999.999/9999-9#")+"</td>"
    cHtml += "    <td>"+aAuxEn[nCont,03]+"</td>"
    cHtml += "    <td>"+Transform(aAuxEn[nCont,08],"@E 999,999,999.99")+"</td>"
    cHtml += "  </tr>"
Next nCont

cHtml += "</table>"

cHtml += "<p>Data de disparo "+cvaltochar(dDatabase)+".</p>"

cHtml += "</body>"
cHtml += "</html>"
"
    
Return(cHtml)
