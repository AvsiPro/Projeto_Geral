#IFDEF SPANISH
	#define STR0001 "CT"
    #define STR0002 "FACT"
    #define STR0003 "ENTRADAS"
    #define STR0004 "SALIDAS"
    #define STR0005 "#################################################################                                    REGISTRO DE ########                                                                                           PAGINA ######"
    #define STR0006 "MES O PERIODO/A�O: #######                                                                                                                                                                     ---------- OPERACIONES -----------"
    #define STR0007 "                                                                                                                                                                                               (1)TRIBUTADAS (2)EXENTAS (3)OTRAS "
    #define STR0008 " FECHA     ESPE  SE                  FECHA                                                                                                  ICMS OPERACIONES"
    #define STR0009 "ENTRADA    CIE   RIE     NUMERO      EMISION                     EMITENTE                   PROV   VALOR CONTABLE CUENTA CONTABLE      CFO   IPI (*)   BASE DE CALCULO ALIC    VALOR DE IMPUESTO            OBSERVACIONES"
    #define STR0010 "MES O PERIODO/A�O: #######                                                                                                                                                              -----------------OPERACIONES-------------"
    #define STR0011 "                                                                                                                                                                                        (1) TRIBUTADAS  (2) EXENTAS  (3) OTRAS   "
    #define STR0012 " FECHA     ESPE  SE                                                                                                                 ICMS OPERACINES"
    #define STR0013 "EMISION    CIE   RIE     NUMERO                           DESTINATARIO               PROV   VALOR CONTABLE CUENTA CONTABLE      CFO   IPI (*)   BASE DE CALCULO ALIC    VALOR DE IMPUESTO                 OBSERVACIONES"
    #define STR0014 "A TRANSPORTAR"
    #define STR0015 "TOTAL DEL DIA "
    #define STR0016 "TOTAL DEL MES"
    #define STR0017 "TOTAL DEL PERIODO"
    #define STR0018 "1.00 ENTRADAS DE LA PROV."
    #define STR0019 "2.00 ENTRADAS DE FUERA DE LA PROV."
    #define STR0020 "3.00 ENTRADAS DEL EXTERIOR"
    #define STR0021 "5.00 SALIDAS P/ LA PROV."
    #define STR0022 "6.00 SALIDAS P/ FUERA DE LA PROV."
    #define STR0023 "7.00 SALIDAS P/ EL EXTERIOR"
    #define STR0024 "TOTAL GENERAL"
    #define STR0025 "TOTAL"
    #define STR0026 "DEMOSTRATIVO POR PROV. DE ORIGEN DE MERCADERIA O DE INICIO DE PRESTACION DE SERVICIO"
    #define STR0027 "ICMS RETENIDO...: "   
#ELSE
   #IFDEF ENGLISH 
   #define STR0001 "CT"
   #define STR0002 "NF"
   #define STR0003 "INFLOWS"
   #define STR0004 "OUTFLOWS"
   #define STR0005 "#################################################################                                  REGISTER FROM ########                                                                                             PAGE ######"
   #define STR0006 "MONTH OR PERIOD/YEAR: #######                                                                                                                                                                    ----------- OPERATIONS -----------"
   #define STR0007 "                                                                                                                                                                                                (1)TAXED  (2)EXEMPT  (3)OTHER"
   #define STR0008 "INFLOW     SPE   SE                  ISSUE                                                                                               ICMS OPERATIONS"
   #define STR0009 "DATE       CIES  RIES    NUMBER      DATE                        DRAWER                     ST       BOOK VALUE   LEDGER ACCOUNT       CFO   IPI (*)        TAX BASIS             TAX VALUE                OBSERVATIONS"
   #define STR0010 "MONTH OR PER./YEAR: #######                                                                                                                                                             -----------------OPERATIONS--------------"
   #define STR0011 "                                                                                                                                                                                        (1) TAXED     (2) EXEMPT    (3) OTHER    "
   #define STR0012 "ISSUE      SPE   SE                                                                                                                ICMS OPERATIONS"
   #define STR0013 "DATE       CIES  RIES    NUMBER                           DESTINATION                ST       BOOK VALUE   LEDGER ACCOUNT       CFO   IPI (*)        TAX BASIS             TAX VALUE                     OBSERVATIONS"
   #define STR0014 "TO TRANSPORT"
   #define STR0015 "TOTAL OF DAY "
   #define STR0016 "TOTAL OF MONTH"
   #define STR0017 "TOTAL OF PERIOD"
   #define STR0018 "1.00 STATE INFLOWS"
   #define STR0019 "2.00 OUT OF STATE INFLOWS"
   #define STR0020 "3.00 FOREIGN INFLOWS"
   #define STR0021 "5.00 STATE OUTFLOWS"
   #define STR0022 "6.00 OUT OF STATE OUTFLOWS"
   #define STR0023 "7.00 FOREIGN OUTFLOWS"
   #define STR0024 "GENERAL TOTAL"
   #define STR0025 "TOTAL"
   #define STR0026 "STATEMENT BY GOOD'S STATE OF ORIGIN OR BY SERVICE RENDERING START DATE"
   #define STR0027 "ICMS WITHHELD...: "
      
   #ELSE
      #define STR0001 "CT"
      #define STR0002 "NF"
      #define STR0003 "ENTRADAS"
      #define STR0004 "SAIDAS"
      #define STR0005 "#################################################################                                    REGISTRO DE ########                                                                                           PAGINA ######"
      #define STR0006 "MES OU PERIODO/ANO: #######                                                                                                                                                                    ----------- OPERACOES ------------"
      #define STR0007 "                                                                                                                                                                                               (1)TRIBUTADAS (2)ISENTAS (3)OUTRAS"
      #define STR0008 "  DT       ESPE  SE                  DT                                                                                                  ICMS OPERACOES"
      #define STR0009 "ENTRADA    CIE   RIE     NUMERO      EMISSAO                     EMITENTE                   UF     VALOR CONTABIL CONTA CONTABIL       CFO   IPI (*)   BASE DE CALCULO ALIQ    VALOR DO IMPOSTO             OBSERVACOES"
      #define STR0010 "MES OU PERIODO/ANO: #######                                                                                                                                                             ------------------OPERACOES--------------"
      #define STR0011 "                                                                                                                                                                                        (1) TRIBUTADAS  (2) ISENTAS  (3) OUTRAS  "
      #define STR0012 "  DT       ESPE  SE                                                                                                                 ICMS OPERACOES"
      #define STR0013 "EMISSAO    CIE   RIE     NUMERO                           DESTINATARIO               UF     VALOR CONTABIL CONTA CONTABIL       CFO   IPI (*)   BASE DE CALCULO ALIQ    VALOR DO IMPOSTO                  OBSERVACOES"
      #define STR0014 "A TRANSPORTAR"
      #define STR0015 "TOTAL DO DIA "
      #define STR0016 "TOTAL DO MES"
      #define STR0017 "TOTAL DO PERIODO"
      #define STR0018 "1.00 ENTRADAS DO ESTADO"
      #define STR0019 "2.00 ENTRADAS DE FORA DO ESTADO"
      #define STR0020 "3.00 ENTRADAS DO EXTERIOR"
      #define STR0021 "5.00 SAIDAS PARA O ESTADO"
      #define STR0022 "6.00 SAIDAS PARA FORA DO ESTADO"
      #define STR0023 "7.00 SAIDAS PARA O EXTERIOR"
      #define STR0024 "TOTAL GERAL"
      #define STR0025 "TOTAL"
      #define STR0026 "DEMONSTRATIVO POR ESTADO DE ORIGEM DA MERCADORIA OU DE INICIO DA PRESTACAO DE SERVICO"
      #define STR0027 "ICMS RETIDO...: "
   #ENDIF
#ENDIF
