#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} User Function ROBRCM03
    (long_description)
    @type  Function
    @author user
    @since 14/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBRCM03



If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

Private _Vend1  :=  space(6)
Private _Vend2  :=  'ZZZZZZ'
Private _DtDe   :=  CTOD(' / / ')
Private _DtAt   :=  CTOD(' / / ')

Private cPathL      := SuperGetMV("TI_CMS03",.F.,"\File\robrcm03\") 
Private aArquivo	:= directory(cPathL+"*.txt","D")
Private aFiles      :=  {}
Private aDados      :=  {}
Private aGrife      :=  {}
Private aVndGrf     :=  {}
Private aMetas      :=  {}
Private aMeses      :=  {}
Private aQtdTot     :=  {}
Private aVlrTot     :=  {}
Private aMetaQt     :=  {}
Private aMetaVl     :=  {}
Private nTotQt      :=  0
Private nTotVl      :=  0
Private cTrimestre  :=  ''
Private nConta      :=  1
Private nAtgQtd     :=  0
Private nAtgVlr     :=  0
Private nAtqTot     :=  0
Private nAtvTot     :=  0

Define msDialog oDlg01 From 00,00 To 220,370 Title "Comissões" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel 

@040,007 SAY "Vendedor Até : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel

@055,007 SAY "Data De : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _DtDe  SIZE 60,9 OF oDlg01 Pixel 

@070,007 SAY "Data Até : " Font oFont1 of oDlg01 Pixel
@070,120 MSGET _DtAt  SIZE 60,9 OF oDlg01 Pixel

@090,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@090,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered

Processa({|| buscaDados()},"Buscando dados")
Processa({|| procrel()},"Gerando...")

Return

/*/{Protheus.doc} procrel
    (long_description)
    @type  Static Function
    @author user
    @since 21/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function procrel

Local nCont     :=  1
Local cAux1     :=  ''
Local cAux2     :=  ''

If len(aVndGrf) > 0

    //For nCont := 1 to len(aArquivo)
    //    Aadd(aFiles,LeArquivo(cPathL+aArquivo[nCont,1],nCont))
    //Next nCont

    //Cabeçalho 1
    Aadd(aFiles,LeArquivo(cPathL+aArquivo[1,1],1))
    //Cabeçalho 2 
    Aadd(aFiles,LeArquivo(cPathL+aArquivo[2,1],2))

    cAux1 := aVndGrf[1,2]
    cAux2 := aVndGrf[1,1]

    For nCont := 1 to len(aVndGrf)
        If cAux1 <> aVndGrf[nCont,2] .Or. nCont == 1
            If nCont > 1
                //Total Vendedores 5
                Aadd(aFiles,LeArquivo(cPathL+aArquivo[5,1],5,cAux1,cAux2,nCont))
                nConta ++
            EndIf

            //Gerente 3
            Aadd(aFiles,LeArquivo(cPathL+aArquivo[3,1],3,aVndGrf[nCont,2],cAux2))

            cAux1 := aVndGrf[nCont,2]
        EndIf 

        //Vendedor 4
        If cAux2 <> aVndGrf[nCont,1]
            cAux2 := aVndGrf[nCont,1]
        EndIf 

        Aadd(aFiles,LeArquivo(cPathL+aArquivo[4,1],4,cAux1,cAux2,nCont))

    Next nCont 

    //Total Vendedores 5
    Aadd(aFiles,LeArquivo(cPathL+aArquivo[5,1],5,cAux1,cAux2,nCont))

    //Total Geral 6
    Aadd(aFiles,LeArquivo(cPathL+aArquivo[6,1],6, cAux1, cAux2, nCont))

    //Rodape 7
    Aadd(aFiles,LeArquivo(cPathL+aArquivo[7,1],7))

    //Gerar arquivo final
    Processa({|| Gerararq()},"Gerando arquivo")
EndIf

Return 

/*/{Protheus.doc} LeArquivo
    (long_description)
    @type  Static Function
    @author user
    @since 14/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static function LeArquivo(cFile,nArq,cAux1,cAux2,nLinha)

Local aArea     :=  GetArea()
Local aRet      :=  {}
Local oFile
Local dDia1     :=  _DtDe

Local dDiaAux
Local lPulaD    :=  .F.
Local lZeraD    :=  .F.
Local nZ        :=  0
Local nY        :=  0
Local cFile2    :=  cPathL+'2_grifes.tmp'
Local aAux2     :=  {}
Local nParx     :=  0
Local cMala     :=  ''
//Local nQtdDia   :=  0

Default cAux1   :=  ''
Default cAux2   :=  ''
Default nLinha  :=  0

oFile := FWFileReader():New(cFile)

if (oFile:Open())
    while (oFile:hasLine())
        Aadd(aRet,oFile:GetLine())
        If nArq == 2
            If '%loop%' $ aRet[len(aRet)]
                oFile2 := FWFileReader():New(cFile2)
                if (oFile2:Open())
                    while (oFile2:hasLine())
                        Aadd(aAux2,oFile2:GetLine())
                    end
                ENDIF

                For nZ := 1 to len(aGrife)
                    For nY := 1 to len(aAux2)
                        Aadd(aRet,aAux2[nY])
                        If '%grife%' $ aRet[len(aRet)]
                            aRet[len(aRet)] := strtran(aRet[len(aRet)],'%grife%',aGrife[nZ,01]+' - '+aGrife[nZ,02])
                        EndIf     
                    Next nY 
                Next nZ
            ElseIf '%diarel%' $ aRet[len(aRet)]
                dDiaAux := dtos(ddatabase)
                dDiaAux := substr(dDiaAux,1,4)+'-'+substr(dDiaAux,5,2)+'-'+substr(dDiaAux,7,2)+'T00:00:00.000'
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%diarel%',dDiaAux)
            ElseIf '%periodorel%' $ aRet[len(aRet)]
                cAux := "Periodo de "
                dDiaAux := dtoc(_DtDe)
                cAux += dDiaAux + ' a '
                dDiaAux := dtoc(_DtAt)
                cAux += dDiaAux 
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%periodorel%',cAux)
            ElseIf '%trimestre%' $ aRet[len(aRet)]
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%trimestre%',cTrimestre+'º Trimestre')
            EndIf 
        ElseIf nArq == 3
            If '%GERENTE%' $ aRet[len(aRet)]

                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%GERENTE%',aDados[ascan(aDados,{|x| x[4] == cAux1}),9])
            EndIf 
            
            If '%mes' $ aRet[len(aRet)]
                cAuxM := substr(aRet[len(aRet)],at('%mes',aRet[len(aRet)])+4,1)
                nPos := ascan(aMeses,{|x| x[2] == cAuxM})
                cAuxA := '01/'+substr(aMeses[npos,1],1,2)+'/'+substr(aMeses[npos,1],1,2)

                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%mes'+cAuxM+'%',CMONTH(ctod(cAuxA)))
            EndIf 

            If '%diasem%' $ aRet[len(aRet)] 
                lPulaD := .T.
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%diasem%',diasemana(dDia1))
            else
                lPulaD := .F.
            EndIf 

            If !lZeraD .and. '%diames%' $ aRet[len(aRet)]
                dDia1     :=  _DtDe
                lZeraD := .T.
            EndIf 

            If lZeraD
                If '%diames%' $ aRet[len(aRet)]
                    lPulaD := .T.
                    dDiaAux := dtos(dDia1)
                    dDiaAux := substr(dDiaAux,1,4)+'-'+substr(dDiaAux,5,2)+'-'+substr(dDiaAux,7,2)+'T00:00:00.000'
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%diames%',cvaltochar(dDiaAux))        
                else
                    lPulaD := .F.
                EndIf
            EndIf

            If lPulaD
                dDia1++
                /*If dDia1 > _DtAt .And. dDia1 > lastday(_DtDe)
                    dDia1 := ctod(' / / ')
                EndIf*/
            EndIf
            

        ElseIf cvaltochar(nArq) == "4"
            
            If '%merdown%' $ aRet[len(aRet)]
                nPos := Ascan(aVndGrf,{|x| x[1] == cAux2})
                nMerg := cvaltochar(len(aVndGrf[nPos])-1)
                //cAux := 'ss:MergeDown="'+nMerg+'" ss:StyleID="m2510969669872"'
                cAux := 'ss:StyleID="s282"'
                //cAux := 'ss:MergeDown="1"'
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%merdown%',cAux)
            EndIf 

            If '%VENDEDOR%' $ aRet[len(aRet)]
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%VENDEDOR%',aDados[ascan(aDados,{|x| x[2] == cAux2}),3])
            EndIf

            If '%MALA%' $ aRet[len(aRet)]
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%MALA%',aVndGrf[nLinha,3])
                cMala := aVndGrf[nLinha,3]
            EndIf

            If '%qtd' $ aRet[len(aRet)]
                nPos := At('%qtd',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')
                nPos := Ascan(aDados,{|x| x[2]+cvaltochar(x[8])+x[5] == cAux2+nConteudo+cMala})
                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(aDados[nPos,06]))
                Else 
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,'0')
                EndIf 
            EndIf 

            If '%vlr' $ aRet[len(aRet)]
                nPos := At('%vlr',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')
                nPos := Ascan(aDados,{|x| x[2]+cvaltochar(x[8])+x[5] == cAux2+nConteudo+cMala})
                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(aDados[nPos,07]))
                Else 
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,'0')
                EndIf
            EndIf 

            If '%totqtdlinha%' $ aRet[len(aRet)]
                nQtd := 0
                For nY := 1 to len(aDados)
                    If aDados[nY,05] == cMala .And. aDados[nY,02] == cAux2
                        nQtd += aDados[nY,06]
                    EndIf
                Next nY
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totqtdlinha%',cvaltochar(nQtd))
            EndIf 

            If '%totvlrlinha%' $ aRet[len(aRet)]
                nQtd := 0
                For nY := 1 to len(aDados)
                    If aDados[nY,05] == cMala .And. aDados[nY,02] == cAux2
                        nQtd += aDados[nY,07]
                    EndIf
                Next nY
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totvlrlinha%',cvaltochar(nQtd))
            EndIf

            If '%metaqtd' $ aRet[len(aRet)]
                
                cNrMet := substr(aRet[len(aRet)],at('%metaqtd',aRet[len(aRet)])+8,1)
                nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cNrMet})
                
                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%metaqtd'+cNrMet+'%',cvaltochar(aMetas[nPos,04]))
                else
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%metaqtd'+cNrMet+'%','0')
                endIf 
            EndIf 

            If '%valormeta' $ aRet[len(aRet)]
                
                cNrMet := substr(aRet[len(aRet)],at('%valormeta',aRet[len(aRet)])+10,1)
                nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cNrMet})
                
                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%valormeta'+cNrMet+'%',cvaltochar(aMetas[nPos,03]))
                else
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%valormeta'+cNrMet+'%','0')
                endIf 
            EndIf

            If '%vendqtd%' $ aRet[len(aRet)]
                nQtd := 0
                For nY := 1 to len(aDados)
                    If aDados[nY,02] == cAux2
                        nQtd += aDados[nY,06]
                    EndIf
                Next nY
                nAtgQtd := nQtd
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%vendqtd%',cvaltochar(nQtd))
            EndIf 

            If '%totalvend%' $ aRet[len(aRet)]
                nQtd := 0
                For nY := 1 to len(aDados)
                    If aDados[nY,02] == cAux2
                        nQtd += aDados[nY,07]
                    EndIf
                Next nY
                nAtgVlr := nQtd
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totalvend%',cvaltochar(nQtd))
            EndIf

            If '%atingirqtd%' $ aRet[len(aRet)]
                cMesRef := dtos(_DtDe)
                cMesRef := substr(cMesRef,5,2)+substr(cMesRef,1,4)
                nPosM   := Ascan(aMeses,{|x| x[1] == cMesRef})
                cMesRef := aMeses[nPosM,02]
                nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cMesRef})
                nResult := 0
                If nPos > 0
                    nResult := nAtgQtd - aMetas[nPos,04]
                    If nResult < 0
                        nResult := nResult * -1
                    EndIf
                EndIf 

                nAtqTot += nResult

                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%atingirqtd%',cvaltochar(nResult))
                else
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%atingirqtd%','0')
                EndIf 
                nAtgQtd := 0
            EndIf 

            
            If '%atingirvlr%' $ aRet[len(aRet)]
                cMesRef := dtos(_DtDe)
                cMesRef := substr(cMesRef,5,2)+substr(cMesRef,1,4)
                nPosM   := Ascan(aMeses,{|x| x[1] == cMesRef})
                cMesRef := aMeses[nPosM,02]
                nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cMesRef})
                nResult := 0
                If nPos > 0
                    nResult := nAtgVlr - aMetas[nPos,03]
                    If nResult < 0
                        nResult := nResult * -1
                    EndIf
                EndIf

                nAtvTot += nResult

                If nPos > 0
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%atingirvlr%',cvaltochar(nResult))
                else
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%atingirvlr%','0')
                endIf 
                nAtgVlr := 0
            EndIf 

            If '%trocalin%' $ aRet[len(aRet)]
                //cFile2 := 'C:\FILE\4_vend1.tmp'
                cFile2 := cPathL+'4_vend2.tmp'
                cAux   := ''
                oFile2 := FWFileReader():New(cFile2)
                if (oFile2:Open())
                    while (oFile2:hasLine())
                        cAux += oFile2:GetLine()
                    end
                ENDIF
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%trocalin%',cAux)
                
                If '%VENDEDOR%' $ aRet[len(aRet)]
                    aRet[len(aRet)] := strtran(aRet[len(aRet)],'%VENDEDOR%',aDados[ascan(aDados,{|x| x[2] == cAux2}),3])
                EndIf
            EndIf 

            If '%incluimala%' $ aRet[len(aRet)]
                cFile2  := cPathL+'4_templ_vend.tmp'
                //inicia no 4 porque a primeira mala já passou
                For nParx := 4 to len(aVndGrf[nLinha])
                    cAux   := ''
                    oFile2 := FWFileReader():New(cFile2)
                    if (oFile2:Open())
                        while (oFile2:hasLine())
                            cAux += oFile2:GetLine()
                        end
                    ENDIF

                    cAux := strtran(cAux,'%VENDEDOR%',aDados[ascan(aDados,{|x| x[2] == cAux2}),3])
                    cAux := strtran(cAux,'%MALA%',aVndGrf[nLinha,nParx])
                    cMala := aVndGrf[nLinha,nParx]
                    nSomQt := 0
                    nSomVl := 0

                    For nY := 1 to 31
                        nPos := At('%qtd'+cvaltochar(nY)+'%',cAux)
                        nConteudo := strtran(substr(cAux,nPos+4,2),"%")
                        cTrocx := strtran(substr(cAux,npos,7),'<')
                        nPos := Ascan(aDados,{|x| x[2]+cvaltochar(x[8])+x[5] == cAux2+nConteudo+cMala})
                        If nPos > 0
                            cAux := strtran(cAux,cTrocx,cvaltochar(aDados[nPos,06]))
                            nSomQt += aDados[nPos,06]
                        Else 
                            cAux := strtran(cAux,cTrocx,'0')
                        EndIf

                        nPos := At('%vlr'+cvaltochar(nY)+'%',cAux)
                        nConteudo := strtran(substr(cAux,nPos+4,2),"%")
                        cTrocx := strtran(substr(cAux,npos,7),'<')
                        nPos := Ascan(aDados,{|x| x[2]+cvaltochar(x[8])+x[5] == cAux2+nConteudo+cMala})
                        If nPos > 0
                            cAux := strtran(cAux,cTrocx,cvaltochar(aDados[nPos,07]))
                            nSomVl += aDados[nPos,07]
                        Else 
                            cAux := strtran(cAux,cTrocx,'0')
                        EndIf
                                              
                    Next nY 

                    If '%totqtdlinha%' $ cAux
                        cAux := strtran(cAux,'%totqtdlinha%',cvaltochar(nSomQt))            
                    EndIf 

                    If '%totvlrlinha%' $ cAux
                        cAux := strtran(cAux,'%totvlrlinha%',cvaltochar(nSomVl))
                    EndIF 

                    For nY := 1 to 3
                        If '%metaqtd'+cvaltochar(nY)+'%' $ cAux

                            //cNrMet := substr(cAux,at('%metaqtd',cAux)+8,1)
                            nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cvaltochar(nY)})
                            
                            If nPos > 0
                                cAux := strtran(cAux,'%metaqtd'+cvaltochar(nY)+'%',cvaltochar(aMetas[nPos,04]))
                            else
                                cAux := strtran(cAux,'%metaqtd'+cvaltochar(nY)+'%','0')
                            endIf 

                            
                        EndIf 

                        If '%atingirqtd%' $ cAux
                            If val(cMesRef) == nY 
                                nResult := nSomQt-If(nPos>0,aMetas[nPos,04],0)
                                If nResult < 0
                                    nResult := nResult * -1
                                EndIf
                                nAtqTot +=  nResult

                                cAux := strtran(cAux,'%atingirqtd%',cvaltochar(nResult))
                            EndIf
                        EndIf                         

                        If '%valormeta'+cvaltochar(nY)+'%' $ cAux

                            //cNrMet := substr(cAux,at('%valormeta',cAux)+10,1)
                            nPos := Ascan(aMetas,{|x| Alltrim(x[1])+Alltrim(x[2])+x[5] == cAux2+cMala+cvaltochar(nY)})
                            
                            If nPos > 0
                                cAux := strtran(cAux,'%valormeta'+cvaltochar(nY)+'%',cvaltochar(aMetas[nPos,03]))
                            else
                                cAux := strtran(cAux,'%valormeta'+cvaltochar(nY)+'%','0')
                            endIf 

                        EndIf

                        If '%atingirvlr%' $ cAux
                            If val(cMesRef) == nY
                                nResult := nSomVl-If(nPos>0,aMetas[nPos,03],0)
                                If nResult < 0
                                    nResult := nResult * -1
                                EndIf 
                                nAtvTot += nResult

                                cAux := strtran(cAux,'%atingirvlr%',cvaltochar(nResult))
                            EndIf
                        EndIf
                        

                        
                    Next nY 

                    If nParx == 1
                        aRet[len(aRet)] := strtran(aRet[len(aRet)],'%incluimala%',cAux)
                    Else
                        Aadd(aRet,cAux)
                    EndIf
                    
                Next nParx
            endif
        ElseIf cvaltochar(nArq) == "5"

            If '%qtd' $ aRet[len(aRet)]
                nPos := At('%qtd',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')
                nQtd := 0

                For nY := 1 to len(aDados)
                    If aDados[nY,04] == cAux1 .And. val(nConteudo) == aDados[nY,08]
                        nQtd += aDados[nY,06]
                    EndIf 
                Next nY 

                aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(nQtd))
                
                If nConta <= 1
                    Aadd(aQtdTot, 0)
                ENDIF
                    
                aQtdTot[val(nConteudo)] += nQtd

            EndIf

            If '%vlr' $ aRet[len(aRet)]
                nPos := At('%vlr',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')
                nQtd := 0

                For nY := 1 to len(aDados)
                    If aDados[nY,04] == cAux1 .And. val(nConteudo) == aDados[nY,08]
                        nQtd += aDados[nY,07]
                    EndIf 
                Next nY 

                aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(nQtd))

                If nConta <= 1
                    Aadd(aVlrTot, 0)
                ENDIF
                    
                aVlrTot[val(nConteudo)] += nQtd

            EndIf 

            If '%totqt%' $ aRet[len(aRet)]
                nQtd := 0

                For nY := 1 to len(aDados)
                    If aDados[nY,04] == cAux1 
                        nQtd += aDados[nY,06]
                    EndIf 
                Next nY 

                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totqt%',cvaltochar(nQtd))

                If nConta <= 1
                    nTotQt += nQtd
                ENDIF
                 
            EndIf

            If '%totvl%' $ aRet[len(aRet)]
                
                nQtd := 0

                For nY := 1 to len(aDados)
                    If aDados[nY,04] == cAux1
                        nQtd += aDados[nY,07]
                    EndIf
                Next nY

                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totvl%',cvaltochar(nQtd))
    
                If nConta <= 1
                    nTotVl += nQtd
                ENDIF

            EndIf 

            If '%metaqtd' $ aRet[len(aRet)]

                cNrMet := substr(aRet[len(aRet)],at('%metaqtd',aRet[len(aRet)])+8,1)
                nPos := 0

                For nY := 1 to len(aMetas)
                    If aMetas[nY,06] == cAux1 .And. aMetas[nY,05] == cNrMet
                        nPos += aMetas[nY,04]
                    EndIf 
                Next nY 
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%metaqtd'+cNrMet+'%',cvaltochar(nPos))
                
                If nConta <= 1
                    Aadd(aMetaQt, 0)
                ENDIF

                aMetaQt[val(cNrMet)] += nPos

            EndIf 

            If '%valormeta' $ aRet[len(aRet)]

                cNrMet := substr(aRet[len(aRet)],at('%valormeta',aRet[len(aRet)])+10,1)
                nPos := 0

                For nY := 1 to len(aMetas)
                    If aMetas[nY,06] == cAux1 .And. aMetas[nY,05] == cNrMet
                        nPos += aMetas[nY,03]
                    EndIf 
                Next nY 
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%valormeta'+cNrMet+'%',cvaltochar(nPos))

                If nConta <= 1
                    Aadd(aMetaVl, 0)
                ENDIF

                aMetaVl[val(cNrMet)] += nPos

            EndIf

            // If '%difvlatg%' $ aRet[len(aRet)]

            //     aRet[len(aRet)] := strtran(aRet[len(aRet)],'%difvlatg%',cvaltochar(nAtvTot))
                
            // EndIf

        ElseIf cvaltochar(nArq) == "6"
            
            If '%qtd' $ aRet[len(aRet)]
                nPos := At('%qtd',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')

                aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(aQtdTot[val(nConteudo)]))
                 
            EndIf

            If '%vlr' $ aRet[len(aRet)]
                nPos := At('%vlr',aRet[len(aRet)])
                nConteudo := strtran(substr(aRet[len(aRet)],nPos+4,2),"%")
                cTrocx := strtran(substr(aRet[len(aRet)],npos,7),'<')
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],cTrocx,cvaltochar(aVlrTot[val(nConteudo)]))
                 
            EndIf

            If '%totqt%' $ aRet[len(aRet)]
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totqt%',cvaltochar(nTotQt))
                 
            EndIf

            If '%totvl%' $ aRet[len(aRet)]
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%totvl%',cvaltochar(nTotVl))

            EndIf

            If '%metaqtd' $ aRet[len(aRet)]

                cNrMet := substr(aRet[len(aRet)],at('%metaqtd',aRet[len(aRet)])+8,1)
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%metaqtd'+cNrMet+'%',cValToChar(aMetaVl[val(cNrMet)]))
                
            EndIf

            If '%valormeta' $ aRet[len(aRet)]

                cNrMet := substr(aRet[len(aRet)],at('%valormeta',aRet[len(aRet)])+10,1)
                
                aRet[len(aRet)] := strtran(aRet[len(aRet)],'%valormeta'+cNrMet+'%',cValToChar(aMetaVl[val(cNrMet)]))
                
            EndIf

            // If '%difvlatg%' $ aRet[len(aRet)]

            //     aRet[len(aRet)] := strtran(aRet[len(aRet)],'%difvlatg%',cvaltochar(nAtvTot))

            // EndIf
 
        EndIf
    end
    oFile:Close()
endif

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} Gerararq
    (long_description)
    @type  Static Function
    @author user
    @since 14/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Gerararq()

Local aArea :=  GetArea()
Local cFileNew  :=  ''
Local nHandle	:=	0
Local nX,nJ     :=  1
Local nLinhas   :=  0
Local cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

cFileNew := Alltrim(cDir)+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.xml' //cPathL
nHandle := fcreate(cFileNew , FO_READWRITE + FO_SHARED ) 

For nX := 1 to len(aFiles)
    For nJ := 1 to len(aFiles[nX])
        If "<ROW " $ Alltrim(upper(aFiles[nX,nJ]))
            nLinhas++
        EndIf
    Next nJ
Next nX

For nX := 1 to len(aFiles)
    For nJ := 1 to len(aFiles[nX])
        If 'ExpandedRowCount="' $ aFiles[nX,nJ]
            cVar := aFiles[nX,nJ]
            cvar2 := substr(cVar,1,59)
            cvar3 := substr(cvar,60)
            nPosi := at('"',cvar3)
            cVar := cvar2+cvaltochar(nLinhas)+substr(cVar3,nPosi)
            aFiles[nX,nJ] := cVar
        EndIf 
        Fwrite(nHandle,aFiles[nX,nJ]+CRLF,100000)
        
    Next nJ
Next nX

FT_FUse()

RestArea(aArea)

Return

/*/{Protheus.doc} buscaDados
    (long_description)
    @type  Static Function
    @author user
    @since 14/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function buscaDados()

Local aArea     :=  GetArea()
Local cQuery 
Local cMalas    :=  ''
Local cVirg     :=  ''
Local dAuxMA    :=  dtos(_DtDe)
Local nY        :=  0

dAuxMA := substr(dAuxMA,5,2)+substr(dAuxMA,1,4)

cQuery := "SELECT MAX(Z31_QUADRI) AS TRIMESTRE FROM "+RetSQLName("Z31")
cQuery += " WHERE Z31_MSAN01='"+dAuxMA+"' OR Z31_MSAN02='"+dAuxMA+"' OR Z31_MSAN03='"+dAuxMA+"'"
cQuery += " AND D_E_L_E_T_=' '"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

cTrimestre := TRB->TRIMESTRE

cQuery := "SELECT * FROM "+RetSQLName("Z31")
cQuery += " WHERE D_E_L_E_T_=' '  AND Z31_FILIAL='"+xFilial("Z31")+"' AND Z31_QUADRI='"+Alltrim(cTrimestre)+"'"
cQuery += " ORDER BY Z31_CODGER,Z31_CODVEN,Z31_ITEM"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    For nY := 1 to 3
        //If &('TRB->Z31_MSAN0'+cvaltochar(nY)) == dAuxMA
            Aadd(aMetas,{   TRB->Z31_CODVEN,;
                            TRB->Z31_MALA,;
                            &('TRB->Z31_VLMS0'+cvaltochar(nY)),;
                            &('TRB->Z31_QTDMS'+cvaltochar(nY)),;
                            cvaltochar(nY),;
                            TRB->Z31_CODGER})
        //EndIf
        If Ascan(aMeses,{|x| x[1] == &('TRB->Z31_MSAN0'+cvaltochar(nY))}) == 0
            Aadd(aMeses,{&('TRB->Z31_MSAN0'+cvaltochar(nY)),cvaltochar(nY)})
        EndIf
    Next nY 
    Dbskip()
EndDo 

cQuery := "SELECT Z03_CODGRI,Z03_DESGRI"
cQuery += " FROM "+RetSQLName("Z03")
cQuery += " WHERE D_E_L_E_T_=' ' AND Z03_MALA='S'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aGrife,{Alltrim(TRB->Z03_CODGRI),Alltrim(Z03_DESGRI)})
    cMalas += cVirg + Alltrim(TRB->Z03_CODGRI)
    cVirg := "','"
    Dbskip()
ENDDO

cQuery := "SELECT C5_EMISSAO AS EMISSAO,C5_VEND1 AS CODVEND,A3_NOME AS VENDEDOR,"
cQuery += " A3_GEREN AS GERENTE,BM_XMODELO AS MALA,"
cQuery += " SUM(C6_QTDVEN) AS QTD,SUM(C6_VALOR) AS VALOR"
cQuery += " FROM "+RetSQLName("SC6")+" C6"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND "
cQuery += "     C5_EMISSAO BETWEEN '"+dtos(_DtDe)+"' AND '"+dtos(_DtAt)+"' AND C5.D_E_L_E_T_=' '"
cQuery += "     AND C5_VEND1<>'000001' AND C5_XCLASPV='1'"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
//provisorio
cQuery += "  AND A3_GEREN NOT IN('  ','000064')"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '"
cQuery += " AND BM_XMODELO IN('"+cMalas+"')"
cQuery += " GROUP BY C5_EMISSAO,C5_VEND1,A3_NOME,A3_GEREN,BM_XMODELO"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    If Ascan(aVndGrf,{|x| Alltrim(x[1]) == Alltrim(TRB->CODVEND)}) == 0
        Aadd(aVndGrf,{TRB->CODVEND,TRB->GERENTE,TRB->MALA})
        
    Else
        nPos := Ascan(aVndGrf,{|x| Alltrim(x[1]) == Alltrim(TRB->CODVEND)})
        If Ascan(avndGrf[nPos],{|x| Alltrim(x) == Alltrim(TRB->MALA)}) == 0
            Aadd(aVndGrf[nPos],TRB->MALA)
        EndIf 
    EndIf 

    Aadd(aDados,{   TRB->EMISSAO,;
                    TRB->CODVEND,;
                    TRB->VENDEDOR,;
                    TRB->GERENTE,;
                    TRB->MALA,;
                    TRB->QTD,;
                    TRB->VALOR,;
                    day(stod(TRB->EMISSAO)),;
                    Alltrim(Posicione("SA3",1,xFilial("SA3")+TRB->GERENTE,"A3_NOME"))})
    Dbskip()
EndDo 

Asort(aDados,,,{|x,y| x[9]+x[3]+x[1] < y[9]+y[3]+y[1]})
Asort(aVndGrf,,,{|x,y| x[2]+x[1] < y[2]+y[1]})
Asort(aMetas,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

RestArea(aArea)

Return
