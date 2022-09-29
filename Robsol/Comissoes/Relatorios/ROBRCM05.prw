#INCLUDE 'protheus.ch'
#Include 'tbiconn.ch'

/*/{Protheus.doc} User Function PPeri
    @type Static Function
    @author Diogo de Jesus Gasparini
    @since 02/09/2022
    @version 1.0
    @return cAux
    /*/
    
Static Function PPeri()
    
    Local aArea     :=  GetArea()
    Local cPerg1    :=  year(ddatabase)
    Local aPerg     :=  {}
    Local cAux      :=  ""
    Local aMes      :=  {'01','02','03','04','05','06','07','08','09','10','11','12'}

    aAdd(aPerg, {1, "Ano desejado" ,  cPerg1,  "", ".T.", "", ".T.", 50,  .F.})
    AAdd(aPerg, {2, "Mes" ,  aMes[1], aMes, 50,'.T.',.T.})
	
    If ParamBox(aPerg, "Informe o mês e o ano desejado!")
        cPerg1  := cvaltochar(MV_PAR01)
        cTriMes := aMes[val(MV_PAR02)]
        cAux    := aMes[val(MV_PAR02)]
        cAux    += cPerg1
        
    else
        cAux := {}
    ENDIF

    RestArea(aArea)

Return(cAux)

/*/{Protheus.doc} User Function ROBRCM05
    @type User Function
    @author Diogo de Jesus Gasparini
    @since 02/09/2022
    @version 1.0
    @return 
    /*/

User Function ROBRCM05()

    Local cQuery   := ""
    Local cArq     := ""
    Local cGeren   := ""
    Local cPeriod  
    Local cMes
    Local lOK 

    Local cDirTmp

    RpcSetType(3)
    RpcSetEnv('01', '0101')

    Private dDataGer  := Date()
    Private cHoraGer  := Time()
    Private cTriMes

    cPeriod  := PPeri()

    If cTriMes = '01' .OR. cTriMes = '04' .OR. cTriMes = '07' .OR. cTriMes = '10'
        cMes := '1'
    
    elseif cTriMes = '02' .OR. cTriMes = '05' .OR. cTriMes = '08' .OR. cTriMes = '11'
        cMes := '2'
    
    else 
        cMes := '3'
    
    ENDIF

    oExcel   := FWMSEXCEL():New()
    cAliasTMP   := GetNextAlias()
    cQuery := "SELECT A3_NOME, A3_COD FROM " + RetSQLName("SA3") + " WHERE A3_FILIAL = '01' AND A3_XFUNCAO = '2'"

    MPSysOpenQuery(cQuery, cAliasTMP)

    While (cAliasTMP) ->(!EOF())

        cGeren += "'" + (cAliasTMP) -> A3_COD + "',"

        (cAliasTMP) ->(DBSKIP())
    ENDDO

    cGeren := "(" + subStr(cGeren, 0,  rat(",", cGeren) - 1) + ")"

    cAliasTMP   := GetNextAlias()

    cQuery := " "
    cQuery += " SELECT Z40_GERENT,  " 
    cQuery += " Z40_VENDED,  " 
    cQuery += " Z40_MARCA,  " 
    cQuery += " Z40_PRCCOM,  " 
    cQuery += " SUM(Z40_QTDITM) AS Z40_QTDITM,  " 
    cQuery += " SUM(Z40_VLRCOM) AS Z40_VLRCOM,  " 
    cQuery += " SUM(Z31_QTDMS" + cMes + ") AS Z31_QTDMS" + cMes + ",  " 
    cQuery += " SUM(Z31_VLMS0" + cMes + ") AS Z31_VLMS0" + cMes + "  " 
    cQuery += " FROM " + RetSQLName("SA3") + " SA3   " 
    cQuery += " INNER JOIN " + RetSQLName("Z31") + " Z31   " 
    cQuery += " ON Z31_CODVEN = A3_COD   " 
    cQuery += " AND Z31_CODGER = A3_GEREN   " 
    cQuery += " AND Z31_MSAN0" + cMes + " = '" + cPeriod + "'   " 
    cQuery += " AND Z31.D_E_L_E_T_ = ''   " 
    cQuery += " INNER JOIN " + RetSQLName("Z40") + " Z40  " 
    cQuery += " ON Z40_VENDED = Z31_CODVEN  " 
    cQuery += " AND Z40_GERENT = Z31_CODGER  " 
    cQuery += " AND Z40_MARCA = Z31_MALA  " 
    cQuery += " AND Z40_XCOMPE = '" + cPeriod + "'  " 
    cQuery += " WHERE SA3.D_E_L_E_T_ = ''  " 
    cQuery += " AND A3_GEREN IN " + cGeren 
    cQuery += " GROUP BY Z40_GERENT, Z40_VENDED, Z40_MARCA, Z40_PRCCOM  " 
    MPSysOpenQuery(cQuery, cAliasTMP)

    oExcel:AddworkSheet(cPeriod) 

    oExcel:AddTable (cPeriod,"Calculo")
    oExcel:AddColumn(cPeriod,"Calculo","Gerente"                      ,1,1)
    oExcel:AddColumn(cPeriod,"Calculo","Nome do Gerente"              ,1,1)
    oExcel:AddColumn(cPeriod,"Calculo","Vendedor"                     ,1,1)
    oExcel:AddColumn(cPeriod,"Calculo","Nome do Vendedor"             ,1,1)
    oExcel:AddColumn(cPeriod,"Calculo","Mala"                         ,1,1)
    oExcel:AddColumn(cPeriod,"Calculo","QTD PCS META"                 ,1,2)
    oExcel:AddColumn(cPeriod,"Calculo","VALOR META"                   ,1,2)
    oExcel:AddColumn(cPeriod,"Calculo","% COMISSAO"                   ,1,2)
    oExcel:AddColumn(cPeriod,"Calculo","QTD Realizado"                ,1,2)
    oExcel:AddColumn(cPeriod,"Calculo","Valor Realizado"              ,1,2)

    If cMes = '1'
        While (cAliasTMP) ->(!EOF())

            oExcel:AddRow(cPeriod,"Calculo",;
                {;
                    (cAliasTMP) -> Z40_GERENT,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_GERENT,'A3_NOME')),;
                    (cAliasTMP) -> Z40_VENDED,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_VENDED,'A3_NOME')),;
                    (cAliasTMP) -> Z40_MARCA, ;
                    (cAliasTMP) -> Z31_QTDMS1,;
                    (cAliasTMP) -> Z31_VLMS01,;
                    (cAliasTMP) -> Z40_PRCCOM,;
                    (cAliasTMP) -> Z40_QTDITM,;
                    (cAliasTMP) -> Z40_VLRCOM ;
                })

                (cAliasTMP) -> (DBSKIP())
            lOK := .T.
        ENDDO
    elseif cMes = '2'
        While (cAliasTMP) ->(!EOF())

            oExcel:AddRow(cPeriod,"Calculo",;
                {;
                    (cAliasTMP) -> Z40_GERENT,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_GERENT,'A3_NOME')),;
                    (cAliasTMP) -> Z40_VENDED,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_VENDED,'A3_NOME')),;
                    (cAliasTMP) -> Z40_MARCA, ;
                    (cAliasTMP) -> Z31_QTDMS2,;
                    (cAliasTMP) -> Z31_VLMS02,;
                    (cAliasTMP) -> Z40_PRCCOM,;
                    (cAliasTMP) -> Z40_QTDITM,;
                    (cAliasTMP) -> Z40_VLRCOM ;
                })

                (cAliasTMP) -> (DBSKIP())
            lOK := .T.
        ENDDO
    else 
        While (cAliasTMP) ->(!EOF())

            oExcel:AddRow(cPeriod,"Calculo",;
                {;
                    (cAliasTMP) -> Z40_GERENT,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_GERENT,'A3_NOME')),;
                    (cAliasTMP) -> Z40_VENDED,;
                    AllTrim(posicione('SA3',1,xFilial('SA3')+(cAliasTMP)->Z40_VENDED,'A3_NOME')),;
                    (cAliasTMP) -> Z40_MARCA, ;
                    (cAliasTMP) -> Z31_QTDMS3,;
                    (cAliasTMP) -> Z31_VLMS03,;
                    (cAliasTMP) -> Z40_PRCCOM,;
                    (cAliasTMP) -> Z40_QTDITM,;
                    (cAliasTMP) -> Z40_VLRCOM ;
                })

                (cAliasTMP) -> (DBSKIP())
            lOK := .T.
        ENDDO
    ENDIF

    cDirTmp:= cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

    oExcel:Activate()

    cArq := CriaTrab(NIL, .F.) +"_CFE-Compras_"+dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')+ ".xml"  
    oExcel:GetXMLFile(cArq)
    
    If __CopyFile(cArq,cDirTmp + cArq)
        If lOK
            oExcelApp := MSExcel():New()
            oExcelApp:WorkBooks:Open(cDirTmp + cArq)
            oExcelApp:SetVisible(.T.)
            oExcelApp:Destroy()
            MsgInfo("O arquivo Excel foi gerado no dirtério: " + cDirTmp + cArq + ". ")
        EndIf
    Else
        MsgAlert("Erro ao criar o arquivo Excel!")
    EndIf

RETURN
