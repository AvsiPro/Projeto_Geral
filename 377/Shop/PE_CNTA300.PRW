#include 'protheus.ch'
#include 'parmtype.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CNTA300  �Autor  � Grupo 377          � Data �  05/10/2022 ���
�������������������������������������������������������������������������͹��
���Desc.     �Alimentar a data de vencimento na CNF de acordo com         ���
���			 �	parametros informados                         ���
�������������������������������������������������������������������������͹��
���Uso       � Empresa: Shopping Cidadao                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function CNTA300()

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.
Local lOk        := .f. 
Local nPC        := 0
Local dDtVenc    := ctod(" / / ")
Local nQtDias 

If aParam <> NIL
       oObj       := aParam[1]
       cIdPonto   := aParam[2]
       cIdModel   := aParam[3]
       lIsGrid    := ( Len( aParam ) > 3 )

       If cIdPonto == 'FORMLINEPRE'
              If  cIdModel == 'CNFDETAIL'
                     If !lOk
                            nQtDias := MV_PAR02
                            dDtVenc := MV_PAR09
                            lOk := .T.
                     EndIf

                     nPC := aParam[4]
                     
                     If nPC == 1
                            If !Empty(dDtVenc)
                                   oObj:ADATAMODEL[nPC][1][1][9] := dDtVenc
                            else
                                   dDtVenc := oObj:ADATAMODEL[nPC][1][1][9]
                            endif
                     Else
                            oObj:ADATAMODEL[nPC][1][1][9] := MonthSum(dDtVenc,(nPC-1))
                     EndIf                         
              EndIf
       EndIf
EndIf

Return xRet
