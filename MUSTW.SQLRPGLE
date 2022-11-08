000002201202       //__________________________________________________________________
000003201202       // DIESES PROGRAMM IST EIGENTUM DER FIRMA KAPS-UNTERNEHMENSBERATUNG
000004201202       // MEISENWEG 2, 8901 EMERSACKER, 08293 / 6126
000005201202       //________________________________________________
000006201116
000007201202       //Compiler Option
000008201202       CTL-OPT Option(*NODEBUGIO:*srcstmt) BNDDIR('KAPSBNDDIR') ACTGRP(*CALLER)
000009201202               DECEDIT('0,') DATEDIT(*DMY.);
000010201116
000011201202       // Display
000012221104       DCL-F MUSTWFM WORKSTN INDDS(dsINDICATOR)
000013221104                             INFDS(TASTEN);
000015201202       //_______________________________________
000016201202       // Procedures
000018201202       /define hilfk
000019201202       /define var_BEST
000021210217       /define Tool
000023201202       /include QRPGLESRC,PRPROTOTYP
000030210315       /undefine Tool
000032201203       /undefine var_BEST
000033201202       /undefine hilfk
000034221107
000041201202       // Programm Informationen
000042201202       /copy qrpglesrc,mypsds
000048201116
000049201202       //Interne Variable
000052210520       DCL-S sqlcmd CHAR(32000);
000053201202       DCL-S Lizenz CHAR(5);
000055221107       DCL-S InputCheck IND;
000056221107
000057221107       // constants
000058221107       DCL-C Error '0';
000059221107       DCL-C Valid '1';
000060221107
000064201202       DCL-DS TASTEN;
000065201202       STATUS *STATUS;
000066201202       END-DS;
000067201202       // dsp_Indicatoren
000068201202       DCL-DS dsIndicator;
000069201202       FKey03_Beenden                         ind   POS(03) ;
000073210218       FKey12_Abbrechen                       ind   POS(12) ;
000074201202       FKey23_Loeschen                        ind   POS(23) ;
000079201202       INFO_GREEN                             ind   POS(50) ;
000080201202       INFO_RED                               ind   POS(51) ;
000081221107       EingabeSatz                            ind   POS(71) ;
000087201202       nicht_Eingabe                          ind   POS(97) ;
000088201202       END-DS;
000089201116
000090210520       // Datei Felder
000091221104       DCL-DS dsYMUST extname('YMUST') qualified END-DS;
000095210520       // Datenstrukturen
000098210520       // Display_Felder
000099210520       DCL-DS dsHEAD LIKEREC (HEADER :*OUTPUT) INZ;
000101210520       DCL-DS dsFOOT LIKEREC (FOOTER :*OUTPUT) INZ;
000102210520       DCL-DS dsBODY LIKEREC (BODY :*ALL) INZ;
000104210520       // Eingabe Felder Speicher
000105210520       DCL-DS dsBODYR LIKEREC (BODY :*ALL) INZ;
000134210519
000135210218       // SQL Optionen
000136210519       exec sql set option commit = *NONE, CLOSQLCSR = *ENDMOD;
000137210520
000138210520       // *ENTRY
000139210520       DCL-PI *N;
000140221108         p_ID INT(10) CONST;
000141210520       END-PI;
000142221104       // Parameter handle
000143221104       dsBODY.POSX = 5;
000144221104       dsBODY.POSY = 10;
000145221104
000146221104       // Key Parameter übernahme
000147221104       exec sql
000148221104       select Name
000149221104         into :dsYMUST.NAME
000150221104         from YMUST
000151221104        where ID = :p_ID
000152221104        ;
000153221104        dsBODY.NAME = dsYMUST.NAME;
000154210520
000155210520       // Hauptprogramm - MAIN
000156210520       ////////////////////////////////////////////////////////////////////////
000157210218
000158210519       Vorbereitung();
000159210520
000160210520       ////////////////////////////////////////////////////////////////////////
000161221107       DOW FKey03_Beenden = *OFF AND FKey12_Abbrechen = *OFF;
000170221107
000172221107       // Lock Input Control
000173221107       IF dsBODY.NAME <> *BLANK;
000174221107       EingabeSatz = NOT EingabeSatz;
000175221107       ENDIF;
000179221107
000180201202       Layout();
000181210519       DSPLY_Feld_Konstanten();
000190221104
000193221104       // Table => DSPLY
000194210520       FILL();
000195221104
000196221104       // Save
000197210520       dsBODYR = dsBODY;
000198221107
000199221107       DOU InputCheck = Valid;
000205210520
000206221104       WRITE BODY   (dsBODY);
000207221104       WRITE HEADER (dsHEAD);
000208201202       WRITE FOOTER (dsFOOT);
000215210520       EXFMT BODY dsBODY;
000216210217
000217210520       CLEAR dsFOOT.INFO;
000218221107       InputCheck = '0';
000219210520
000222221107       // FKey12 = Back
000223221107       IF FKey12_Abbrechen = *ON AND EingabeSatz = *ON;
000224221107       EingabeSatz = NOT EingabeSatz;
000225221107       ITER;
000226221107       ENDIF;
000227221107       IF FKey12_Abbrechen = *ON OR FKey03_Beenden = *ON;
000228221107       LEAVE;
000230221107       ENDIF;
000236201116
000237221107       // Display => Table
000238221107       EVAL-CORR dsYMUST = dsBODY;
000239221107
000240221107       IF Status = 1125;
000241221107       i_HILFE();
000242221107       ITER;
000243221107       ENDIF;
000244221107
000245221108       InputCheck = CheckInput(dsFOOT.INFO);
000246221107       IF InputCheck = Error;
000247221107       INFO_RED = *ON;
000248221107       ITER;
000249221107       ENDIF;
000250221107
000251221107       ENDDO;
000252221107
000255221108       IF InputCheck = Valid and EingabeSatz;
000256221108
000257221104       // If Input Change
000258210520       IF dsBODY <> dsBODYR;
000259221108
000260221104       sqlCODE = merge_YMUST();
000268210520       ENDIF;
000269221108
000270221108       LEAVE;
000271210520       ENDIF;
000272210519
000273221107       ENDDO;
000274210519
000275201202         *INLR = *ON;
000276201202       ////////////////////////////////////////////////////////////////////////
000277210520       // Initiale Aufgaben bei Programmstart
000278210520       DCL-PROC Vorbereitung;
000279210225
000280210518        // Lizenznummer
000281210518        exec sql
000282210518        select substring(satzta, 20, 5)
000283210518        into :Lizenz from yta where kyta like '105%';
000284201116
000285210518        END-PROC;
000286210520       ////////////////////////////////////////////////////////////////////////
000368210519       DCL-PROC DSPLY_Feld_Konstanten;
000369210519
000370210519         dsBody.FIELD  =
000371221104         'Feld1';
000372210519
000373210519         dsBody.FIELD1 =
000374221104         'Feld2';
000375210519
000376210519         dsBody.FIELD2 =
000377221104         'Feld3';
000499210519       END-PROC;
000500210520       ////////////////////////////////////////////////////////////////////////
000501210520       DCL-PROC FILL;
000510210520
000512221108       sqlcode = select_YKONTOINF();
000513221108       IF sqlCode = 0;
000514221108       EVAL-CORR dsBODY = dsYMUST;
000515221108       ELSE;
000516221108       dsBODY.ARTIKLE = *BLANK;
000517221108       dsBODY.DESC    = *BLANK;
000518221108       dsBODY.STATE   = *BLANK;
000519221108       ENDIF;
000520210520
000521210520       END-PROC;
000522221107       ////////////////////////////////////////////////////////////////////////
000523221108       DCL-PROC CheckInput;
000524221107        DCL-PI *N IND;
000525221107          INFO LIKE(dsFOOT.INFO);
000526221107        END-PI;
000529221107
000530221108       //  IF Error;
000531221108       //  Info = 'Ups - soemthing went wrong';
000532221108       //  return Error;
000533221107       //  ENDIF;
000537221107
000538221107        return Valid;
000539221107        END-PROC;
000540210520       ////////////////////////////////////////////////////////////////////////
000541221104       DCL-PROC merge_YMUST;
000542210520       DCL-PI *N INT(10);
000543210520       END-PI;
000544221104       DCL-S iID             INT(10);
000545221104       DCL-S iSatz_vorhanden IND;
000546210520
000547221104       // check - update or insert
000548210520       exec sql
000549221104       select ID, '1'
000550221104       into :iID, :iSatz_vorhanden
000551221104       from YMUST
000552210520       where
000553221104       Name = :dsYMUST.Name;
000554210520
000555210520       // update
000556221104       IF iSatz_vorhanden;
000557210520       exec sql
000558221104       update YMUST
000559221104       set ARTIKLE = :dsYMUST.ARTIKLE
000560221104          ,STATE   = :dsYMUST.STATE
000561221104          ,DESC    = :dsYMUST.DESC
000562210520       where
000563221104       ID = :iID;
000564210520       ENDIF;
000565210520
000566210520       // insert
000567221104       IF iSatz_vorhanden = *OFF;
000568210520       exec sql
000569221104       insert into YMUST
000570221104       (
000571221104        NAME
000572221104       ,ARTIKLE
000573221104       ,STATE
000574221104       ,DESC
000575221104       )
000576210520       VALUES
000577210520       (
000578221104        :dsYMUST.NAME
000579221104       ,:dsYMUST.ARTIKLE
000580221104       ,:dsYMUST.STATE
000581221104       ,:dsYMUST.DESC
000582210520       )
000583210520       ;
000584210520       ENDIF;
000585210519
000586210520       RETURN SQLCODE;
000587210519       END-PROC;
000588210520       ////////////////////////////////////////////////////////////////////////
000589210520       DCL-PROC select_YKONTOINF;
000590210520       DCL-PI *N INT(10);
000591210520       END-PI;
000592221104
000593210520       // select
000594210520       exec sql
000595210520       select *
000596221104       into :dsYMUST
000597221104       from YMUST
000598210520       where
000599221104       Name = :dsYMUST.Name;
000600210520
000601210520       RETURN SQLCODE;
000602210520       END-PROC;
000623210520       ////////////////////////////////////////////////////////////////////////
000624210519       DCL-PROC Layout;
000626210519
000627201202       // Ueberschrift
000628201202       %subst(dsHEAD.TITL:1:%LEN(dsHEAD.TITL)-21) =
000629221104        'Muster Window';
000630201202       %subst(dsHEAD.TITL:%LEN(dsHEAD.TITL)-20:10) = MYPSDS.USER;
000631201202       %subst(dsHEAD.TITL:%LEN(dsHEAD.TITL)-10:10) = MYPSDS.PROC_PGM;
000632201116
000633210316       // Funktionstasten und Status Anzeige
000655201202       dsFOOT.FTZ =
000656210308       'F03=Beenden +
000661210308       F12=Abbrechen';
000673210226
000674201202        END-PROC;
000702210518       ////////////////////////////////////////////////////////////////////////
000704221107       DCL-PROC i_HILFE;
000709221107       /define   HILFE
000710221107       /copy qrpglesrc,prprototyp
000711221107       /undefine HILFE
000712221107
000713221107       p_PROGRA  = mypsds.PROC_NAME;
000714221107       p_PRVERS  = 10;
000715221107       p_AUSWX   = mypsds.PROC_NAME;
000716221107       p_AUSZE   = 0;
000717221107       p_REOLI   = 'R';
000718221107       p_PRESE   = *BLANK;
000719221107       CALLP HILFK(p_PROGRA:p_PRVERS:p_AUSWX:p_AUSZE:p_REOLI:p_PRESE);
000722221107       END-PROC;
000723221107       ////////////////////////////////////////////////////////////////////////
