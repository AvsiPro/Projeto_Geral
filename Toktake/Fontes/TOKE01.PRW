#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#include 'ap5mail.ch'


/*/
*****************************************************************************
** Programa  : TOTR01.PRW     * Autor: Wanderley Andrade * Data: 08/01/10  **
*****************************************************************************
** Descricao : Relatorio do PickList Pedido de Venda.                      **
**             PRE-PICKLIST - Envio de E-mail                              **
*****************************************************************************
** Modulo    : Faturamento                                                 **
*****************************************************************************
/*/
                                      
                                      
User Function Toke01   
Private chtmltotal := " "        
Private chtml      := " "   
Private cfimhtm    := " "   
Private ccab       := " "
Private citem      := " "
Private cfimitem   := " "             
Private chtmltot   := " "
Private c_Eol      := "Chr(10)+Chr(13)"   
Private cC5_NUM  	//:=	TMP->C5_NUM 
Private cC5_EMISSAO //:=	TMP->C5_EMISSAO 
Private cC5_TIPO	//:=	TMP->C5_TIPO 
Private cC5_XNFABAS //:=	TMP->C5_XNFABAS 
Private cC5_XNOMUSR //:=	TMP->C5_XNOMUSR 
Private cC5_CLIENTE	//:=	TMP->C5_CLIENTE 
Private cC5_LOJACLI	//:=	TMP->C5_LOJACLI 
Private cC5_XCODPA 	//:=	TMP->C5_XCODPA 
Private cC5_XDCODPA //:=	TMP->C5_XDCODPA 
Private cC5_MENNOTA	//:=	TMP->C5_MENNOTA 
Private cA1_NOME	//:=	TMP->A1_NOME 
Private cA1_END	    //:=	TMP->A1_END 
Private cA1_BAIRRO	//:=	TMP->A1_BAIRRO 
Private cA1_MUN   	//:=	TMP->A1_MUN 
Private cA1_EST	    //:=	TMP->A1_EST 
Private cA1_CEP	    //:=	TMP->A1_CEP 
Private dC6_ENTREG 	//:=	TMP->C6_ENTREG 
Private cC6_PRODUTO	//:=	TMP->C6_PRODUTO 
Private cB1_DESC	//:=	TMP->B1_DESC 
Private nC6_QTDVEN	//:=	TMP->C6_QTDVEN 
Private cC6_ITEM	//:=	TMP->C6_ITEM 
Private nC9_QTDLIB  //:= TMT->C9_QTDLIB
Private dC9_DATALIB //:= TMT->C9_DATALIB
Private cC9_NFISCAL //:= TMT->C9_NFISCAL
Private cC9_SERIENF //:= TMT->C9_SERIENF
Private cC9_BLEST   //:= TMT->C9_BLEST
Private cC9_BLCRED  //:= TMT->C9_BLCRED  
Private cZZ1_END     
Private cZZ1_BAIRRO  
Private cZZ1_MUN     
Private cZZ1_EST     
Private cZZ1_CEP                  
Private cC5_XFINAL                  


//IniHtml()                                   
//FimHtml()

//CabHtml()   
//ItemHtml()
//fimItemHtml()


//chtmltotal := chtml+ccab+citem+cfimitem
//MemoWrite('C:\pasta\email.html',chtmltotal)

ItemPed()

return
                                

Static Function ItemPed         

cQuery := "SELECT " 
cQuery += "C5_NUM, "
cQuery += "C5_EMISSAO, "
cQuery += "C5_TIPO, "
cQuery += "C5_XNFABAS,C5_XFINAL, "
cQuery += "C5_XNOMUSR, "
cQuery += "C5_CLIENTE, "
cQuery += "C5_LOJACLI, "
cQuery += "C5_XCODPA, "
cQuery += "C5_XDCODPA, "
cQuery += "C5_MENNOTA, "
cQuery += "A1_NOME, "
cQuery += "A1_END, "
cQuery += "A1_BAIRRO, "
cQuery += "A1_MUN, "
cQuery += "A1_EST, "
cQuery += "A1_CEP, "
cQuery += "C6_ENTREG,  "
cQuery += "C6_PRODUTO, "
cQuery += "B1_DESC, "
cQuery += "C6_QTDVEN, "
cQuery += "C6_ITEM, "
cQuery += "C6_TES "
cQuery += "from "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SB1")+" SB1 "
cQuery += "WHERE SC5.D_E_L_E_T_<> '*' AND SC6.D_E_L_E_T_<> '*' AND SA1.D_E_L_E_T_<> '*'AND SB1.D_E_L_E_T_<> '*'  "
cQuery += "AND C5_FILIAL = '"+xfilial("SC5")+"' "
cQuery += "AND C6_FILIAL = '"+xfilial("SC6")+"' "
cQuery += "AND B1_FILIAL = '"+xfilial("SB1")+"' "
cQuery += "AND A1_FILIAL = '"+xfilial("SA1")+"' "
cQuery += "AND C5_NUM    = C6_NUM "
cQuery += "AND A1_COD    = C5_CLIENTE "
cQuery += "AND A1_LOJA   = C5_LOJACLI "
cQuery += "AND C6_PRODUTO = B1_COD "                    
cQuery += "AND C6_ENTREG >= '20100114' AND C6_ENTREG <= '20100114' "  
//cQuery += "AND (C6_NUM    = '001748' or C6_NUM    = '001512' )"  
cQuery += "order by C6_NUM,B1_DESC"  

TcQuery cQuery NEW ALIAS "TMP"
MemoWrite('C:\pasta\toke01cQuery',cQuery)

DbSelectArea("TMP")
DbGoTop()           

chtmlt1 := ""

while !eof()
    * montar cabecalho
	cC5_NUM  	:=	TMP->C5_NUM 
	cC5_EMISSAO :=	TMP->C5_EMISSAO 
	cC5_TIPO	:=	TMP->C5_TIPO 
	cC5_XNFABAS :=	TMP->C5_XNFABAS 
	cC5_XNOMUSR :=	TMP->C5_XNOMUSR 
	cC5_CLIENTE	:=	TMP->C5_CLIENTE 
	cC5_LOJACLI	:=	TMP->C5_LOJACLI 
	cC5_XCODPA 	:=	TMP->C5_XCODPA 
	cC5_XDCODPA :=	TMP->C5_XDCODPA 
	cC5_MENNOTA	:=	TMP->C5_MENNOTA 
	cA1_NOME	:=	TMP->A1_NOME 
	cA1_END	    :=	TMP->A1_END 
	cA1_BAIRRO	:=	TMP->A1_BAIRRO 
	cA1_MUN   	:=	TMP->A1_MUN 
	cA1_EST	    :=	TMP->A1_EST 
	cA1_CEP	    :=	TMP->A1_CEP 
	dC6_ENTREG 	:=	TMP->C6_ENTREG 
	cC6_PRODUTO	:=	TMP->C6_PRODUTO 
	cB1_DESC	:=	TMP->B1_DESC 
	nC6_QTDVEN	:=	TMP->C6_QTDVEN 
	cC6_ITEM	:=	TMP->C6_ITEM 
	cC6_TES  	:=	TMP->C6_TES 
	cC5_XFINAL  :=  TMP->C5_XFINAL
                                  

    cQry	:= " SELECT * "
	cQry	+= " FROM "+RetSqlName("ZZ1")+" ZZ1"
	cQry	+= " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
	cQry	+= " AND   ZZ1_COD    = '"+cC5_XCODPA+"'"
	If Select("TM1") > 0
		dbSelectArea("TM1")
		dbCloseArea()
	EndIf
	TCQUERY cQry NEW ALIAS "TM1"
	dbSelectArea("TM1")
	dbGoTop()

	cZZ1_END     := TM1->ZZ1_END
	cZZ1_BAIRRO  := TM1->ZZ1_BAIRRO
	cZZ1_MUN     := TM1->ZZ1_MUN
	cZZ1_EST     := TM1->ZZ1_EST
	cZZ1_CEP     := TM1->ZZ1_CEP
	TMT->(DbCloseArea())
                      
    CabHtml()
//    chtmlt1     :=  chtmlt1+ccab   
    
    cpedido     :=  TMP->C5_NUM
    citem       := " "
    
    nfat    := 0
    ntotreg := 0                                                
    
	while cpedido = TMP->C5_NUM
                                                               
		* montar item
	         
        cQueryT := "SELECT C9_QTDLIB, "
        cQueryT += "C9_DATALIB, "
        cQueryT += "C9_NFISCAL, "
        cQueryT += "C9_SERIENF, "
        cQueryT += "C9_BLEST, "
        cQueryT += "C9_BLCRED "
        cQueryT += "FROM "+RetSQLName("SC9")+" "
        cQueryT += "WHERE D_E_L_E_T_<> '*' "
        cQueryT += "AND C9_FILIAL = '"+xfilial("SC9")+"'
        cQueryT += "AND C9_PEDIDO = '"+cpedido+"'  "
        cQueryT += "AND C9_PRODUTO = '"+cC6_PRODUTO+"' "
        cQueryT += "AND C9_ITEM = '"+cC6_ITEM+"' "
		TcQuery cQueryT NEW ALIAS "TMT"
		DbSelectArea("TMT")
        MemoWrite('C:\pasta\toke01cQueryT',cQueryT)
		                      
		if !eof()                      
			nC9_QTDLIB  := TMT->C9_QTDLIB
			dC9_DATALIB := TMT->C9_DATALIB
			cC9_NFISCAL := TMT->C9_NFISCAL
			cC9_SERIENF := TMT->C9_SERIENF

            if TMT->C9_BLEST = '10'
//			cC9_BLEST   := TMT->C9_BLEST
                cC9_BLEST := "Item Faturado"
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLEST := "Liberado"
                else
                   cC9_BLEST := "Bloqueado"
                endif
            endif                  

//			cC9_BLCRED  := TMT->C9_BLCRED

            if TMT->C9_BLEST = '10'
//			cC9_BLEST   := TMT->C9_BLEST
                cC9_BLCRED := "Item Faturado"
                nfat := nfat+1
            else
                if empty(TMT->C9_BLEST)
                   cC9_BLCRED := "Liberado"
                else
                   cC9_BLCRED := "Bloqueado"
                endif
            endif                  

		else
			nC9_QTDLIB  := 0.00
			dC9_DATALIB := " " //TMT->C9_DATALIB
			cC9_NFISCAL := " " //TMT->C9_NFISCAL
			cC9_SERIENF := " " //TMT->C9_SERIENF
			cC9_BLEST   := "PEDIDO EM ABERTO"
			cC9_BLCRED  := "PEDIDO EM ABERTO"		
		endif                 
		ntotreg := ntotreg +1
		TMT->(DbCloseArea())
        DbSelectArea("TMP")
        ItemHtml()
        dbskip()
	
    enddo      
//    fimItemHtml()
//    chtmlt1     :=  chtmlt1+citem+cfimitem
	chtml      := " "   
	cfimhtm    := " "   
	IniHtml()                                   
	FimHtml()
	                
	cno   := "Email_Pedido_"+cpedido+"_"+substr(dtos(date()),7,2)+substr(dtos(date()),5,2)+substr(dtos(date()),3,2)+subst(time(),1,2)+subst(time(),4,2)+""+subst(time(),7,2)
                                               
    chtmltot := chtml+ccab+citem+cfimitem+cfimhtm
    
//	chtmltot := chtml+chtmlt1+cfimhtm 
	
//	EnvioEmail(chtmltot)
	  
	MemoWrite('C:\pasta\'+cno+'.html',chtmltot)

//	_cEMail := "mxfonseca@toktake.com.br;nsilva@toktake.com.br;arsilva@toktake.com.br;mandre@toktake.com.br;aremiliozzi@toktake.com.br;rneto@toktake.com.br"  
  	_cEMail := "workpedvend@toktake.com.br"  

    ddent := dtoc(stod(dC6_ENTREG))                                               

	if nfat < ntotreg
	Connect Smtp Server GETMV("MV_RELSERV") account GETMV("MV_RELACNT") password GETMV("MV_RELPSW")
	Send Mail From GETMV("MV_RELACNT") To _cEMail subject "Dt.Entrega: "+ddent+" - Pedido: "+cpedido+"-Cliente: "+substr(cA1_NOME,1,10)+"-PA: "+substr(cC5_XDCODPA,1,10)+" - Pick List - Pedido de Venda." body  chtmltot  
	endif
	                 
	
	chtmltotal := " "        
	chtml      := " "   
	cfimhtm    := " "   
	ccab       := " "
	citem      := " "
	cfimitem   := " "             
	chtmltot   := " "
	chtmlt1    := " "
	
enddo
                                  
//IniHtml()                                   
//FimHtml()

//chtmltot := chtml+chtmlt1+cfimhtm   
//MemoWrite('C:\pasta\pedidoemail.html',chtmltot)

DbSelectArea("TMP")       
TMP->(DbCloseArea())
Return

                                                                                                             
Static Function EnvioEmail(chtmltot6)
          
//_cEMail := "wanderley.andrade@totvspartners.com.br;alecadu@totvs.com.br" 
_cEMail := "mxfonseca@toktake.com.br"
Connect Smtp Server GETMV("MV_RELSERV") account GETMV("MV_RELACNT") password GETMV("MV_RELPSW")
Send Mail From GETMV("MV_RELACNT") To _cEMail subject "Pick List - Pedido de Venda." body  chtmltot6  

//Connect Smtp Server GETMV("MV_RELSERV") account GETMV("MV_RELACNT") password GETMV("MV_RELPSW")
//Send Mail From GETMV("MV_RELACNT") To _cEMail6 subject "Confirmacao de Recebimento de Pedido " body  c_Html                
                            
return

*************************************************************************************************************                                
Static Function CabHtml                                               
ccab :=" <hr> <BR><BR> "+&c_Eol

cxfinal := " "
if cC5_XFINAL = "1"
   cxfinal := "Venda Direta"
else
   if cC5_XFINAL = "2"
      cxfinal := "Venda PA"
	else
	   if cC5_XFINAL = "3"
	      cxfinal := "Transferencia"
       else
		   if cC5_XFINAL = "4"
		      cxfinal := "Abastecimento"
           else
		      cxfinal := "Outras Saidas"
		   endif
       endif
   endif
endif
           		      
	      
   

          


//ccab :=" "
ccab +=" <table border='0'> "+&c_Eol
ccab +="     <tbody> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td width='91'><strong><font size='2' face='Arial, Helvetica, sans-serif'>Pedido:</font></strong></td> "+&c_Eol
ccab +="         <td width='89'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_NUM+"</font></td> "+&c_Eol
ccab +="         <td width='85'><p><strong><font size='2' face='Arial, Helvetica, sans-serif'>Emissao:</font></strong></p></td> "+&c_Eol
ccab +="         <td width='307'><font size='2' face='Arial, Helvetica, sans-serif'>"+dtoc(stod(cC5_EMISSAO))+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Tipo Nota:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_TIPO+"</font></td> "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Tipo Venda</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cxfinal+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Usuario:</font></strong></td> "+&c_Eol
ccab +="         <td colspan='3'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_XNOMUSR+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="     </tbody> "+&c_Eol
ccab +="   </table> "+&c_Eol
ccab +="   <br> "+&c_Eol
ccab +="   <table border='0'> "+&c_Eol
ccab +="     <tbody> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td width='71'><strong><font size='2' face='Arial, Helvetica, sans-serif'>Codigo:</font></strong></td> "+&c_Eol
ccab +="         <td width='91'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_CLIENTE+"</font></td> "+&c_Eol
ccab +="         <td width='48'><strong><font size='2' face='Arial, Helvetica, sans-serif'>Loja:</font></strong></td> "+&c_Eol
ccab +="         <td width='90'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_LOJACLI+"</font></td> "+&c_Eol
ccab +="         <td width='54'><strong><font size='2' face='Arial, Helvetica, sans-serif'>Nome:</font></strong></td> "+&c_Eol
ccab +="         <td colspan='5'><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_NOME+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Endereco:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_END+"</font></td> "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Bairro:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_BAIRRO+"</font></td> "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Cidade:</font></strong></td> "+&c_Eol
ccab +="         <td width='79'><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_MUN+"</font></td> "+&c_Eol
ccab +="         <td width='53'><font size='2' face='Arial, Helvetica, sans-serif'><strong>Estado</strong>:</font></td> "+&c_Eol
ccab +="         <td width='57'><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_EST+"</font></td> "+&c_Eol
ccab +="         <td width='33'><font size='2' face='Arial, Helvetica, sans-serif'><strong>Cep:</strong></font></td> "+&c_Eol
ccab +="         <td width='70'><font size='2' face='Arial, Helvetica, sans-serif'>"+cA1_CEP+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="     </tbody> "+&c_Eol
ccab +="   </table> "+&c_Eol
ccab +="   <br> "+&c_Eol
ccab +="   <table border='0'> "+&c_Eol
ccab +="     <tbody> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Codigo  "+&c_Eol
ccab +="           PA.:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_XCODPA+"</font></td> "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>P.A.:</font></strong></td> "+&c_Eol
ccab +="         <td colspan='7'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_XDCODPA+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Endereco:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cZZ1_END+"</font></td> "+&c_Eol
ccab +="         <td><strong><font size='2' face='Arial, Helvetica, sans-serif'>Bairro:</font></strong></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cZZ1_BAIRRO+"</font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'><strong>Cidade</strong>:</font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cZZ1_MUN+"</font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'><strong>Estado:</strong></font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cZZ1_EST+"</font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'><strong>Cep</strong>:</font></td> "+&c_Eol
ccab +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cZZ1_CEP+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="     </tbody> "+&c_Eol
ccab +="   </table> "+&c_Eol
ccab +="   <br> "+&c_Eol
ccab +="   <table border='0'> "+&c_Eol
ccab +="     <tbody> "+&c_Eol
ccab +="       <tr>  "+&c_Eol
ccab +="         <td width='91'><font size='2' face='Arial, Helvetica, sans-serif'><strong>Observacao:</strong></font></td> "+&c_Eol
ccab +="         <td width='587'><font size='2' face='Arial, Helvetica, sans-serif'>"+cC5_MENNOTA+"</font></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="     </tbody> "+&c_Eol
ccab +="   </table> "+&c_Eol
ccab +="   <br> "+&c_Eol
ccab +=" <table border='1'> "+&c_Eol
ccab +="     <tbody> "+&c_Eol
ccab +="       <tr bgcolor='#000033'>  "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Data  "+&c_Eol
ccab +="             Entrega</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Cod.Produto</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Produto</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Qtd.Ped.</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Qtd.Lib.</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Item</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Status  "+&c_Eol
ccab +="             Estoque</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Status  "+&c_Eol
ccab +="             Credito</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>TES  "+&c_Eol
ccab +="             888</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Data  "+&c_Eol
ccab +="             Lib.</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Nota  "+&c_Eol
ccab +="             Fiscal</font></strong></font></div></td> "+&c_Eol
ccab +="         <td><div align='center'><font size='2'><strong><font color='#FFFFFF' face='Arial, Helvetica, sans-serif'>Serie</font></strong></font></div></td> "+&c_Eol
ccab +="       </tr> "+&c_Eol
ccab +="       <tr> "+&c_Eol                                                            

return
*************************************************************************************************************                                

*************************************************************************************************************                                
Static Function ItemHtml
citem +="       <tr> "+&c_Eol 
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+dtoc(stod(TMP->C6_ENTREG))+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+TMP->C6_PRODUTO+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+TMP->B1_DESC+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+str(TMP->C6_QTDVEN,8,2)+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+str(nC9_QTDLIB,8,2)+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+TMP->C6_ITEM+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC9_BLEST+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC9_BLCRED+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+TMP->C6_TES+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+dtoc(stod(dC9_DATALIB))+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC9_NFISCAL+"</font></td> "+&c_Eol
citem +="         <td><font size='2' face='Arial, Helvetica, sans-serif'>"+cC9_SERIENF+"</font></td> "+&c_Eol
citem +="       </tr>

Return
*************************************************************************************************************                                
*************************************************************************************************************                                
Static Function fimItemHtml

//cfimitem :="---------------------------------------------------------------------------------------------------------------------------------------<BR><BR><BR> "+&c_Eol
cfimitem :="   </tbody> "+&c_Eol
cfimitem +="   </table> "+&c_Eol
cfimitem +="   <p>&nbsp; </p> "+&c_Eol

    
Return
*************************************************************************************************************  

*************************************************************************************************************                                
Static Function IniHtml
         
chtml :="<html xmlns:o='urn:schemas-microsoft-com:office:office'"+&c_Eol
chtml +="xmlns:w='urn:schemas-microsoft-com:office:word'"+&c_Eol
chtml +="xmlns:m='http://schemas.microsoft.com/office/2004/12/omml'"+&c_Eol
chtml +="xmlns='http://www.w3.org/TR/REC-html40'>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="<head>"+&c_Eol
chtml +="<meta http-equiv=Content-Type content='text/html; charset=windows-1252'>"+&c_Eol
chtml +="<meta name=ProgId content=Word.Document>"+&c_Eol
chtml +="<meta name=Generator content='Microsoft Word 12'>"+&c_Eol
chtml +="<meta name=Originator content='Microsoft Word 12'>"+&c_Eol
chtml +="<link rel=File-List"+&c_Eol
chtml +="href='Pre_Pick_List._arquivos/filelist.xml'>"+&c_Eol
chtml +="<link rel=Edit-Time-Data"+&c_Eol
chtml +="href='Pre_Pick_List._arquivos/editdata.mso'>"+&c_Eol
chtml +="<title>Pick List - Pedido de Venda - Estoque e Credito</title>"+&c_Eol
chtml +="<!--[if gte mso 9]><xml>"+&c_Eol
chtml +=" <o:DocumentProperties>"+&c_Eol
chtml +="  <o:Author>Wanderley</o:Author>"+&c_Eol
chtml +="  <o:Template>NormalEmail</o:Template>"+&c_Eol
chtml +="  <o:Revision>1</o:Revision>"+&c_Eol
chtml +="  <o:TotalTime>0</o:TotalTime>"+&c_Eol
chtml +="  <o:Created>2010-01-10T12:01:00Z</o:Created>"+&c_Eol
chtml +="  <o:Pages>1</o:Pages>"+&c_Eol
chtml +="  <o:Words>75</o:Words>"+&c_Eol
chtml +="  <o:Characters>407</o:Characters>"+&c_Eol
chtml +="  <o:Company>Hewlett-Packard</o:Company>"+&c_Eol
chtml +="  <o:Lines>3</o:Lines>"+&c_Eol
chtml +="  <o:Paragraphs>1</o:Paragraphs>"+&c_Eol
chtml +="  <o:CharactersWithSpaces>481</o:CharactersWithSpaces>"+&c_Eol
chtml +="  <o:Version>12.00</o:Version>"+&c_Eol
chtml +=" </o:DocumentProperties>"+&c_Eol
chtml +="</xml><![endif]-->"+&c_Eol
chtml +="<link rel=themeData"+&c_Eol
chtml +="href='Pre_Pick_List._arquivos/themedata.thmx'>"+&c_Eol
chtml +="<link rel=colorSchemeMapping"+&c_Eol
chtml +="href='Pre_Pick_List._arquivos/colorschememapping.xml'>"+&c_Eol
chtml +="<!--[if gte mso 9]><xml>"+&c_Eol
chtml +=" <w:WordDocument>"+&c_Eol
chtml +="  <w:Zoom>0</w:Zoom>"+&c_Eol
chtml +="  <w:TrackMoves/>"+&c_Eol
chtml +="  <w:TrackFormatting/>"+&c_Eol
chtml +="  <w:HyphenationZone>21</w:HyphenationZone>"+&c_Eol
chtml +="  <w:ValidateAgainstSchemas/>"+&c_Eol
chtml +="  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>"+&c_Eol
chtml +="  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>"+&c_Eol
chtml +="  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>"+&c_Eol
chtml +="  <w:DoNotPromoteQF/>"+&c_Eol
chtml +="  <w:LidThemeOther>PT-BR</w:LidThemeOther>"+&c_Eol
chtml +="  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>"+&c_Eol
chtml +="  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>"+&c_Eol
chtml +="  <w:Compatibility>"+&c_Eol
chtml +="   <w:DoNotExpandShiftReturn/>"+&c_Eol
chtml +="   <w:BreakWrappedTables/>"+&c_Eol
chtml +="   <w:SplitPgBreakAndParaMark/>"+&c_Eol
chtml +="   <w:DontVertAlignCellWithSp/>"+&c_Eol
chtml +="   <w:DontBreakConstrainedForcedTables/>"+&c_Eol
chtml +="   <w:DontVertAlignInTxbx/>"+&c_Eol
chtml +="   <w:Word11KerningPairs/>"+&c_Eol
chtml +="   <w:CachedColBalance/>"+&c_Eol
chtml +="  </w:Compatibility>"+&c_Eol
chtml +="  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>"+&c_Eol
chtml +="  <m:mathPr>"+&c_Eol
chtml +="   <m:mathFont m:val='Cambria Math'/>"+&c_Eol
chtml +="   <m:brkBin m:val='before'/>"+&c_Eol
chtml +="   <m:brkBinSub m:val='&#45;-'/>"+&c_Eol
chtml +="   <m:smallFrac m:val='off'/>"+&c_Eol
chtml +="   <m:dispDef/>"+&c_Eol
chtml +="   <m:lMargin m:val='0'/>"+&c_Eol
chtml +="   <m:rMargin m:val='0'/>"+&c_Eol
chtml +="   <m:defJc m:val='centerGroup'/>"+&c_Eol
chtml +="   <m:wrapIndent m:val='1440'/>"+&c_Eol
chtml +="   <m:intLim m:val='subSup'/>"+&c_Eol
chtml +="   <m:naryLim m:val='undOvr'/>"+&c_Eol
chtml +="  </m:mathPr></w:WordDocument>"+&c_Eol
chtml +="</xml><![endif]--><!--[if gte mso 9]><xml>"+&c_Eol
chtml +=" <w:LatentStyles DefLockedState='false' DefUnhideWhenUsed='true'"+&c_Eol
chtml +="  DefSemiHidden='true' DefQFormat='false' DefPriority='99'"+&c_Eol
chtml +="  LatentStyleCount='267'>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='0' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Normal'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='heading 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 7'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 8'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='9' QFormat='true' Name='heading 9'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 7'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 8'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' Name='toc 9'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='35' QFormat='true' Name='caption'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='10' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Title'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='1' Name='Default Paragraph Font'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='11' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Subtitle'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='22' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Strong'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='20' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Emphasis'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='59' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Table Grid'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' UnhideWhenUsed='false' Name='Placeholder Text'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='1' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='No Spacing'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' UnhideWhenUsed='false' Name='Revision'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='34' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='List Paragraph'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='29' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Quote'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='30' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Intense Quote'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 1'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 2'/>
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 2'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 3'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 4'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 5'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='60' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Shading Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='61' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light List Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='62' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Light Grid Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='63' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 1 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='64' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Shading 2 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='65' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 1 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='66' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium List 2 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='67' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 1 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='68' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 2 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='69' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Medium Grid 3 Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='70' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Dark List Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='71' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Shading Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='72' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful List Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='73' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' Name='Colorful Grid Accent 6'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='19' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Subtle Emphasis'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='21' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Intense Emphasis'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='31' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Subtle Reference'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='32' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Intense Reference'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='33' SemiHidden='false'"+&c_Eol
chtml +="   UnhideWhenUsed='false' QFormat='true' Name='Book Title'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='37' Name='Bibliography'/>"+&c_Eol
chtml +="  <w:LsdException Locked='false' Priority='39' QFormat='true' Name='TOC Heading'/>"+&c_Eol
chtml +=" </w:LatentStyles>"+&c_Eol
chtml +="</xml><![endif]-->"+&c_Eol
chtml +="<style>"+&c_Eol
chtml +="<!--"+&c_Eol
chtml +=" /* Font Definitions */"+&c_Eol
chtml +=" @font-face"+&c_Eol
chtml +="	{font-family:'Cambria Math';"+&c_Eol
chtml +="	panose-1:2 4 5 3 5 4 6 3 2 4;"+&c_Eol
chtml +="	mso-font-charset:1;"+&c_Eol
chtml +="	mso-generic-font-family:roman;"+&c_Eol
chtml +="	mso-font-format:other;"+&c_Eol
chtml +="	mso-font-pitch:variable;"+&c_Eol
chtml +="	mso-font-signature:0 0 0 0 0 0;}"+&c_Eol
chtml +="@font-face"+&c_Eol
chtml +="	{font-family:Calibri;"+&c_Eol
chtml +="	panose-1:2 15 5 2 2 2 4 3 2 4;"+&c_Eol
chtml +="	mso-font-charset:0;"+&c_Eol
chtml +="	mso-generic-font-family:swiss;"+&c_Eol
chtml +="	mso-font-pitch:variable;"+&c_Eol
chtml +="	mso-font-signature:-1610611985 1073750139 0 0 159 0;}"+&c_Eol
chtml +=" /* Style Definitions */"+&c_Eol
chtml +=" p.MsoNormal, li.MsoNormal, div.MsoNormal"+&c_Eol
chtml +="	{mso-style-unhide:no;"+&c_Eol
chtml +="	mso-style-qformat:yes;"+&c_Eol
chtml +="	mso-style-parent:'';"+&c_Eol
chtml +="	margin:0cm;"+&c_Eol
chtml +="	margin-bottom:.0001pt;"+&c_Eol
chtml +="	mso-pagination:widow-orphan;"+&c_Eol
chtml +="	font-size:12.0pt;"+&c_Eol
chtml +="	font-family:'Times New Roman','serif';"+&c_Eol
chtml +="	mso-fareast-font-family:Calibri;"+&c_Eol
chtml +="	mso-fareast-theme-font:minor-latin;}"+&c_Eol
chtml +="p"+&c_Eol
chtml +="	{mso-style-noshow:yes;"+&c_Eol
chtml +="	mso-style-priority:99;"+&c_Eol
chtml +="	font-size:12.0pt;"+&c_Eol
chtml +="	font-family:'Times New Roman','serif';"+&c_Eol
chtml +="	mso-fareast-font-family:Calibri;"+&c_Eol
chtml +="	mso-fareast-theme-font:minor-latin;}"+&c_Eol
chtml +="p.style5, li.style5, div.style5"+&c_Eol
chtml +="	{mso-style-name:style5;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	mso-margin-top-alt:auto;"+&c_Eol
chtml +="	margin-right:0cm;"+&c_Eol
chtml +="	mso-margin-bottom-alt:auto;"+&c_Eol
chtml +="	margin-left:0cm;"+&c_Eol
chtml +="	mso-pagination:widow-orphan;"+&c_Eol
chtml +="	font-size:10.5pt;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-fareast-font-family:Calibri;"+&c_Eol
chtml +="	mso-fareast-theme-font:minor-latin;}"+&c_Eol
chtml +="p.style7, li.style7, div.style7"+&c_Eol
chtml +="	{mso-style-name:style7;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	mso-margin-top-alt:auto;"+&c_Eol
chtml +="	margin-right:0cm;"+&c_Eol
chtml +="	mso-margin-bottom-alt:auto;"+&c_Eol
chtml +="	margin-left:0cm;"+&c_Eol
chtml +="	mso-pagination:widow-orphan;"+&c_Eol
chtml +="	font-size:12.0pt;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-fareast-font-family:Calibri;"+&c_Eol
chtml +="	mso-fareast-theme-font:minor-latin;"+&c_Eol
chtml +="	color:red;"+&c_Eol
chtml +="	font-weight:bold;}"+&c_Eol
chtml +="p.style8, li.style8, div.style8"+&c_Eol
chtml +="	{mso-style-name:style8;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	mso-margin-top-alt:auto;"+&c_Eol
chtml +="	margin-right:0cm;"+&c_Eol
chtml +="	mso-margin-bottom-alt:auto;"+&c_Eol
chtml +="	margin-left:0cm;"+&c_Eol
chtml +="	mso-pagination:widow-orphan;"+&c_Eol
chtml +="	font-size:12.0pt;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-fareast-font-family:Calibri;"+&c_Eol
chtml +="	mso-fareast-theme-font:minor-latin;"+&c_Eol
chtml +="	font-weight:bold;}"+&c_Eol
chtml +="span.style71"+&c_Eol
chtml +="	{mso-style-name:style71;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-ascii-font-family:Arial;"+&c_Eol
chtml +="	mso-hansi-font-family:Arial;"+&c_Eol
chtml +="	mso-bidi-font-family:Arial;"+&c_Eol
chtml +="	color:red;"+&c_Eol 
chtml +="	font-weight:bold;}"+&c_Eol
chtml +="span.style81"+&c_Eol
chtml +="	{mso-style-name:style81;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-ascii-font-family:Arial;"+&c_Eol
chtml +="	mso-hansi-font-family:Arial;"+&c_Eol
chtml +="	mso-bidi-font-family:Arial;"+&c_Eol
chtml +="	font-weight:bold;}"+&c_Eol
chtml +="span.style51"+&c_Eol
chtml +="	{mso-style-name:style51;"+&c_Eol
chtml +="	mso-style-unhide:no;"+&c_Eol
chtml +="	mso-ansi-font-size:10.5pt;"+&c_Eol
chtml +="	mso-bidi-font-size:10.5pt;"+&c_Eol
chtml +="	font-family:'Arial','sans-serif';"+&c_Eol
chtml +="	mso-ascii-font-family:Arial;"+&c_Eol
chtml +="	mso-hansi-font-family:Arial;"+&c_Eol
chtml +="	mso-bidi-font-family:Arial;}"+&c_Eol
chtml +=".MsoChpDefault"+&c_Eol
chtml +="	{mso-style-type:export-only;"+&c_Eol
chtml +="	mso-default-props:yes;"+&c_Eol
chtml +="	font-size:10.0pt;"+&c_Eol
chtml +="	mso-ansi-font-size:10.0pt;"+&c_Eol
chtml +="	mso-bidi-font-size:10.0pt;}"+&c_Eol
chtml +="@page Section1"+&c_Eol
chtml +="	{size:612.0pt 792.0pt;"+&c_Eol
chtml +="	margin:70.85pt 3.0cm 70.85pt 3.0cm;"+&c_Eol
chtml +="	mso-header-margin:36.0pt;"+&c_Eol
chtml +="	mso-footer-margin:36.0pt;"+&c_Eol
chtml +="	mso-paper-source:0;}"+&c_Eol
chtml +="div.Section1"+&c_Eol
chtml +="	{page:Section1;}"+&c_Eol
chtml +="-->"+&c_Eol
chtml +="</style>"+&c_Eol
chtml +="<!--[if gte mso 10]>"+&c_Eol
chtml +="<style>"+&c_Eol
chtml +=" /* Style Definitions */"+&c_Eol
chtml +=" table.MsoNormalTable"+&c_Eol
chtml +="	{mso-style-name:'Tabela normal';"+&c_Eol
chtml +="	mso-tstyle-rowband-size:0;"+&c_Eol
chtml +="	mso-tstyle-colband-size:0;"+&c_Eol
chtml +="	mso-style-noshow:yes;"+&c_Eol
chtml +="	mso-style-priority:99;"+&c_Eol
chtml +="	mso-style-qformat:yes;"+&c_Eol
chtml +="	mso-style-parent:'';"+&c_Eol
chtml +="	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;"+&c_Eol
chtml +="	mso-para-margin:0cm;"+&c_Eol
chtml +="	mso-para-margin-bottom:.0001pt;"+&c_Eol
chtml +="	mso-pagination:widow-orphan;"+&c_Eol
chtml +="	font-size:10.0pt;"+&c_Eol
chtml +="	font-family:'Times New Roman','serif';}"+&c_Eol
chtml +="</style>"+&c_Eol
chtml +="<![endif]-->"+&c_Eol
chtml +="</head>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="<body lang=PT-BR style='tab-interval:35.4pt'>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="<div class=Section1>"+&c_Eol
chtml +="<table class=MsoNormalTable border=0 cellpadding=0 width=600 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +=" <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'>"+&c_Eol
chtml +="  <td style='padding:.75pt .75pt .75pt .75pt'>"+&c_Eol
chtml +="  <p class=MsoNormal align=center style='text-align:center'><span"+&c_Eol
chtml +="  class=style71>Pick List - Posicao dos Pedidos - Liberacoes Estoque e Credito</span><span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p>"+&c_Eol
chtml +="  </td>"+&c_Eol
chtml +=" </tr>"+&c_Eol
chtml +="</table>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="<p class=MsoNormal><span style='mso-fareast-font-family:'Times New Roman';"+&c_Eol
chtml +="display:none;mso-hide:all'><o:p>&nbsp;</o:p></span></p>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="  <table class=MsoNormalTable border=0 cellpadding=0 width=871 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +="    <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "+&c_Eol
chtml +="      <td width='867' style='padding:.75pt .75pt .75pt .75pt'> <p class=MsoNormal align=center style='text-align:center'><font face='Arial, Helvetica, sans-serif'><strong>Aten&ccedil;&atilde;o "+&c_Eol
chtml +="          aos pedidos com seus respectivos status ate o presente momento.<br>"+&c_Eol
chtml +="          Favor desconsiderar os emails anteriores</strong></font><br>"+&c_Eol
chtml +="          <span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p></td>"+&c_Eol
chtml +="    </tr>"+&c_Eol
chtml +="  </table>"+&c_Eol
chtml +="  <p class=MsoNormal><span style='mso-fareast-font-family:'Times New Roman';"+&c_Eol
chtml +="display:none;mso-hide:all'><o:p>&nbsp;</o:p></span></p>"+&c_Eol
chtml +=" "+&c_Eol
chtml +="  <table class=MsoNormalTable border=0 cellpadding=0 width=618 style='width:450.0pt;"+&c_Eol
chtml +=" mso-cellspacing:1.5pt;mso-yfti-tbllook:1184'>"+&c_Eol
chtml +="    <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "+&c_Eol
chtml +="      <td width='614' style='padding:.75pt .75pt .75pt .75pt'> <p class=MsoNormal align=center style='text-align:center'><font face='Arial, Helvetica, sans-serif'><strong>Data: "+&c_Eol
chtml +="          "+DTOC(DDATABASE)+" - Hora: "+TIME()+" </strong></font><br>"+&c_Eol
chtml +="          <span style='mso-fareast-font-family:'Times New Roman''><o:p></o:p></span></p></td>"+&c_Eol
chtml +="    </tr>"+&c_Eol
chtml +="  </table>"+&c_Eol
chtml +="  <br>"+&c_Eol

Return


                         
Static Function FimHtml   

cfimhtm := "</div> "
cfimhtm += "</body> "
cfimhtm += "</html> "

return
                                                                                   

