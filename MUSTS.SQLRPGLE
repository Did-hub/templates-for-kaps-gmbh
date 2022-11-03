000002201202       //__________________________________________________________________
000003201202       // DIESES PROGRAMM IST EIGENTUM DER FIRMA KAPS-UNTERNEHMENSBERATUNG
000004201202       // MEISENWEG 2, 8901 EMERSACKER, 08293 / 6126
000005201202       //________________________________________________
000006201116
000007201202       //Compiler Option
000008220615       CTL-OPT Option(*NODEBUGIO:*srcstmt)
000009220615               BNDDIR('KAPSBNDDIR')
000010220615               ACTGRP(*CALLER)
000011220615               DECEDIT('0,')
000012220615               DATEDIT(*DMY.);
000013201116
000014201202       // Display
000015220615       DCL-F MUSTSFM WORKSTN INDDS(dsINDICATOR)
000016220615                             INFDS(TASTEN)
000017220615                             SFILE(SUBFILE:Recnum1);
000018201202       //_______________________________________
000019201202       // Procedures
000020220615       /define var_BEST_J
000022210217       /define Tool
000023201202       /include QRPGLESRC,PRPROTOTYP
000030210315       /undefine Tool
000032220615       /undefine var_BEST_J
000040201116
000041201202       // Programm Informationen
000042201202       /copy qrpglesrc,mypsds
000043201116
000044201202       //_______________________________________
000045201202       //Subfile Variablen
000046201202       DCL-S Recnum1                Zoned(4:0);
000047201116
000048201116
000049201202       //Interne Variable
000050201202       DCL-S Seite       Zoned(10:0) INZ(1);
000051201202       DCL-S Page_Rec    like(ROWNUMBERH) DIM(99999);
000052201202       DCL-S sqlcmd CHAR(2056);
000053201202       DCL-S Lizenz CHAR(5);
000054210217       DCL-S satz_vorhanden ind;
000055210316       DCL-S exist INT(5);
000056221103       DCL-S Ansicht INT(5) INZ(1);  // 1=Ansicht1 Beschreibung
000057221103                                     // 2=Ansicht2 Beschreibung
000058221103                                     // 3=Ansicht3 Beschreibung
000059221103                                     // 4=Ansicht4 Beschreibung
000060210217       DCL-S von_Leistungstag_ymd ZONED(6:0);
000061210217       DCL-S bis_Leistungstag_ymd ZONED(6:0);
000062210721
000065201202       DCL-DS TASTEN;
000066201202       STATUS *STATUS;
000067201202       END-DS;
000068201202       // dsp_Indicatoren
000069201202       DCL-DS dsIndicator;
000070201202       FKey03_Beenden                         ind   POS(03) ;
000071210215       FKey04                                 ind   POS(04) ;
000072210315       FKey05                                 ind   POS(05) ;
000073210308       FKey08                                 ind   POS(08) ;
000074210315       FKey10                                 ind   POS(10) ;
000075210218       FKey12_Abbrechen                       ind   POS(12) ;
000076201202       FKey23_Loeschen                        ind   POS(23) ;
000077201202       Subfile_CLEAR                          ind   POS(40) ;
000078201202       Subfile_DSP                            ind   POS(41) ;
000079201202       Subfile_END                            ind   POS(42) ;
000080201202       Eingabe_zwingend_43                    ind   POS(43) ;
000081201202       INFO_GREEN                             ind   POS(50) ;
000082201202       INFO_RED                               ind   POS(51) ;
000083201202       Seite_zurueck                          ind   POS(70) ;
000084201202       Seite_weiter                           ind   POS(71) ;
000085201202       Ausklappen                             ind   POS(78) ;
000086201202       Dunkel_Hell                            ind   POS(79) ;
000087201202       sfl_red                                ind   POS(80) ;
000088201202       sfl_blu                                ind   POS(81) ;
000089201202       nicht_Eingabe                          ind   POS(97) ;
000090201202       END-DS;
000091201116
000098201202         // Datenstrukturen
000099220615         DCL-DS dsYMUST extname('YMUST') qualified END-DS;
000100220615
000101201202         // Display_Felder
000102201202         DCL-DS dsHEAD LIKEREC (HEADER :*OUTPUT) INZ;
000103201202         DCL-DS dsFOOT LIKEREC (FOOTER :*OUTPUT) INZ;
000104210518         // Eingabe Felder Speicher
000105220615         DCL-DS dsCONTROLSFL        LIKEREC (CONTROLSFL :*ALL) INZ;
000106220615         DCL-DS Eingabe             LIKEDS (dsCONTROLSFL);
000107201117
000110201203       DCL-DS Spalten1 qualified;
000111220615         S1 CHAR(10);
000112201203         T1 CHAR(1 ) INZ('|');
000113220615         S2 CHAR(10);
000114201203         T2 CHAR(1 ) INZ('|');
000115220615         S3 CHAR(7);
000116201203         T3 CHAR(1 ) INZ('|');
000117220615         S4 CHAR(80);
000118201203         T4 CHAR(1 ) INZ('|');
000127220615       END-DS;
000128201202
000129220615       //_______________________________________
000130220615       // *ENTRY
000131220615       DCL-PI *N;
000132220615       END-PI;
000133220615
000135210218       // SQL Optionen
000136220615       exec sql set option commit = *NONE, CLOSQLCSR = *ENDMOD;
000137210218
000139220615       Vorbereitung();
000140210218
000141210218       // Hauptprogramm - MAIN
000142201202       ////////////////////////////////////////////////////////////////////////
000143210218
000144220615       DOW  FKey03_Beenden = *OFF and FKey12_Abbrechen = *OFF;
000146210218
000155201202       Layout();
000156210315
000179210217       FILL();
000180220615
000182220615       Eingabe = dsCONTROLSFL;
000183201116
000184201202       WRITE HEADER (dsHEAD);
000185201202       WRITE FOOTER (dsFOOT);
000186201116
000187220617       EXFMT CONTROLSFL dsCONTROLSFL;
000188210217
000189210518       IF FKey03_Beenden = *OFF and FKey12_Abbrechen = *OFF;
000190220615
000193201202         Checkinput();
000194220615
000195220615
000196220615       ENDIF;
000197220615
000198220615
000201220615       ENDDO;
000202201116
000203201202         *INLR = *ON;
000204201202       ////////////////////////////////////////////////////////////////////////
000231220615       //_______________________________________________
000232220615       // Initiale Aufgaben bei Programmstart
000233201202        DCL-PROC Vorbereitung;
000234210225
000235220615        // Subfile Cursor Position
000238220617        dsCONTROLSFL.curx = 1;
000239220615
000240210518        // Lizenznummer
000241210518        exec sql
000242210518        select substring(satzta, 20, 5)
000243210518        into :Lizenz from yta where kyta like '105%';
000245201116
000246210518        Page_rec(Seite)=ROWNUMBERH;
000247201116
000249210518        END-PROC;
000250201202       //____________________________________________________________________
000251201202         DCL-PROC Checkinput;
000252210215         DCL-S ID BINDEC(9:0);
000253210518
000254210518         // Wenn Eingabe Aenderung
000256210518         // und Aenderung Speichern
000257220615         IF Eingabe <> dsControlSFL;
000259210518          Seite = 1;
000260220615          Eingabe = dsControlSFL;
000263210518         ENDIF;
000264210518
000265210122       IF STATUS = 1125;
000266210722        i_HILFE();
000270210122        ENDIF;
000271210122
000272220615        // Ansicht Wechsel
000273210315        IF FKey05 = *ON;
000275210518          Seite = 1;
000276210315          SELECT;
000277221103            WHEN Ansicht = 1;
000278221103                 Ansicht = 2;
000279210315
000280221103            WHEN Ansicht = 2;
000281221103                 Ansicht = 3;
000285210315
000286221103            WHEN Ansicht = 3;
000287221103                 Ansicht = 4;
000288221103
000289221103            WHEN Ansicht = 4;
000290221103                 Ansicht = 1;
000291210315
000292210315          ENDSL;
000293210315        ENDIF;
000308210315
000335210721       IF NOT nicht_Eingabe = *ON;
000336201202       IF SUBFILE_DSP = *ON;
000337201202       READC SUBFILE;
000338201202       DOW NOT %EOF();
000339201202       SELECT;
000340201203         When Wahl= 'X';
000341220615           // Auswahl
000342210315
000345210315         When Wahl= '4';
000346220615           // dlt()
000347220615
000351201202       OTHER;
000352220615       ENDSL;
000353201202       READC SUBFILE;              // nach lesen
000354211103
000355211103        // Cursor auf Subfilesatz zurücksetzen
000356220617        dsCONTROLSFL.curx = Recnum1;                  //dsCONTROLSFL.curx in DSP gesetzt
000357201202       ENDDO;
000358201202       ENDIF;
000359210721       ENDIF;
000360201116
000361201202       IF  Seite_weiter=*on AND Subfile_END=*OFF;
000362201202       Seite += 1;
000363201202       Page_rec(Seite)=ROWNUMBERH;
000364201202       ENDIF;
000365201202       IF  Seite_zurueck=*on AND Seite <> 1;
000366201202       Seite -= 1;
000367201202       ENDIF;
000368210518
000369220617         ARRN = dsCONTROLSFL.ARRN;
000370220617         dsCONTROLSFL.curx = locate_Cursor(ARRN);
000371201202        END-PROC;
000372201202       //____________________________________________________________________
000373201202        DCL-PROC FILL;
000374201116
000375201202       Exsr Clear_SFL;
000376201202       Subfile_END = *OFF;
000377201116
000378201202       ROWNUMBERH=Page_rec(Seite);
000379210217
000380210217        exec sql
000381220615        declare CursorX scroll Cursor for
000382220615        select fuse.* from
000383210217        (
000384210217        select ROW_NUMBER()
000385220615        OVER(order by NAME desc) AS rownumber
000386220615        ,ID
000387220615        ,NAME
000388220617        ,ARTIKLE
000389220617        ,STATUS
000390220617        ,DESC
000392220615        from YMUST A1
000397210217        where
000398220615         1= 1
000410210315          and
000411210315         (
000412210315          (
000413221103          :Ansicht = 1
000414220615       //    and
000416220615       //    NAME = 'ACDC'
000417220615          )
000418210315          or
000419210315          (
000420221103          :Ansicht = 2
000421220615       //    and
000423220615       //    NAME = 'ABC'
000425210315          )
000426220615         )
000439210217        )
000440210217        as fuse
000441210217        where rownumber > :rownumberH
000443210217        order by rownumber
000444210217        ;
000445210217
000448220615       exec sql OPEN CursorX;
000449201116
000451221103       DOU SQLCODE <> 0 or Recnum1 = 17;
000452201116
000454220615       exec sql fetch CursorX into
000457220615        :rownumberH
000458220615       ,:dsYMUST.ID
000459220615       ,:dsYMUST.NAME
000460220617       ,:dsYMUST.ARTIKLE
000461220617       ,:dsYMUST.STATUS
000462220617       ,:dsYMUST.DESC
000465201202       ;
000466201230
000467221103       // hidden Subfile Fields for selection
000468220615       IDH = dsYMUST.ID;
000469220615
000470201202         If sqlcode <> 0 or Recnum1 = 17;
000471201202         leave;
000472201202         ENDIF;
000487210315
000488220615         // highlight
000489201202         Dunkel_Hell = not Dunkel_Hell;
000490201202
000491201203         EXSR Spalten_fuellen;
000492201116
000493221103         // Write row in Subfile
000494201202         WRITE SUBFILE;
000495221103         // Subfile count increase
000496201202         Recnum1 += 1;
000497201202         ENDDO;
000498221103         // Subfile End
000499221103         IF Recnum1 > 1;
000500201202         Subfile_DSP=*ON;
000501201202         endif;
000502201202         If sqlcode <> 0;
000503201202         Subfile_END=*ON;
000504201202         ENDIF;
000505220615
000506220615       exec sql close CursorX;
000507201116
000508201202       //______________________
000509201202         BEGSR Clear_SFL;
000511201202         Recnum1 = 1;
000512201202         Subfile_CLEAR =*ON;
000513201202         Subfile_DSP   =*OFF;
000514201202         WRITE CONTROLSFL;
000515201202         SUBfile_CLEAR =*OFF;
000517201202         Clear WAHL;
000518201202         ENDSR;
000519201203        //______________________
000520201203         BEGSR Spalten_fuellen;
000521220615
000522220615         Spalten1.S1 = dsYMUST.NAME;
000523220617         Spalten1.S2 = dsYMUST.ARTIKLE;
000524220617         Spalten1.S3 = dsYMUST.STATUS;
000525220617         Spalten1.S4 = dsYMUST.DESC;
000526220615
000549201203         SFL1 = Spalten1;
000550201203         ENDSR;
000612201202         END-PROC;
000613201202         //____________________________________________________________________
000614201202        DCL-PROC Layout;
000615220617
000621220615       // ueberschriften
000623220615       dsHEAD.TITL = Ueberschriften(dsHEAD.TITL);
000624220615
000625220615       // subfile auswahl optionen
000626220617       dsControlSFL.Auswahl = 'X=Ansicht 4=Auswahl4';
000627220615
000629220615       // funktionstasten
000630220615       dsFOOT.FTZ = Funktionstasten(dsFOOT.FTZ:Ansicht);
000631220615
000641220615       // Status Zeile
000642220615       dsControlSFL.STATUSF = StatusZeile(dsControlSFL.STATUSF:Ansicht);
000643220615
000676210315       // Spalten Ueberschriften
000677220617       dsControlSFL.ZEILE2 = UeberschriftSpalten(dsControlSFL.ZEILE2);
000683210226
000684201202        END-PROC;
000710210722       ////////////////////////////////////////////////////////////////////////
000711210722       DCL-PROC i_HILFE;
000712210722       /define   HILFE
000713210722       /copy qrpglesrc,prprototyp
000714210722       /undefine HILFE
000715210722
000716210722       p_PROGRA  = mypsds.PROC_NAME;
000717210722       p_PRVERS  = 10;
000718210722       p_AUSWX   = mypsds.PROC_NAME;
000719210722       p_AUSZE   = 0;
000720210722       p_REOLI   = 'R';
000721210722       p_PRESE   = *BLANK;
000722210722       CALLP HILFK(p_PROGRA:p_PRVERS:p_AUSWX:p_AUSZE:p_REOLI:p_PRESE);
000723220615       END-PROC;
000724220615
000725220615       ////////////////////////////////////////////////////////////////////////
000726220615       DCL-PROC Ueberschriften;
000730220615       DCL-PI *N LIKE(dsHEAD.TITL);
000731220615       Titel LIKE(dsHEAD.TITL);
000732220615       END-PI;
000733220615
000734220615       %subst(Titel:1:%LEN(Titel)-21) =
000735220615        'Muster Subfile Programm';
000736220615       %subst(Titel:%LEN(Titel)-20:10) = MYPSDS.USER;
000737220615       %subst(Titel:%LEN(Titel)-10:10) = MYPSDS.PROC_PGM;
000738220615
000739220615       RETURN Titel;
000741220615       END-PROC;
000742220615
000743220615       ////////////////////////////////////////////////////////////////////////
000744220615       DCL-PROC Funktionstasten;
000745220615       DCL-PI *N LIKE(dsFOOT.FTZ);
000746220615       Ftasten LIKE(dsFOOT.FTZ);
000747220615       iAnsicht LIKE(Ansicht) const;
000748220615       END-PI;
000749220615
000750220615       DCL-S FKey04_Anzeige varchar(30);
000751220615       DCL-S FKey05_Anzeige varchar(30);
000752220615       DCL-S FKey08_Anzeige varchar(30);
000753220615       DCL-S FKey10_Anzeige varchar(30);
000754220615
000755221103       IF iAnsicht = 1;
000756221103       FKey05_Anzeige = 'F05=Ansicht2';
000758220615       ENDIF;
000759220615
000760221103       IF iAnsicht = 2;
000761221103       FKey05_Anzeige = 'F05=Ansicht3';
000763220615       ENDIF;
000764220615
000765221103       IF iAnsicht = 3;
000766221103       FKey05_Anzeige = 'F05=Ansicht4';
000768220615       ENDIF;
000769220615
000770221103       IF iAnsicht = 4;
000771221103       FKey05_Anzeige = 'F05=Ansicht1';
000773220615       ENDIF;
000774220615
000775220615       // Funktionstasten und Status Anzeige
000776221103       FKey04_Anzeige = 'F04=TasteM04';
000777221103       FKey08_Anzeige = 'F08=TasteM08';
000778221103       FKey10_Anzeige = 'F10=TasteM10';
000779220615
000780220615       //__________
000781220615       Ftasten =
000782220615       'F03=Beenden +
000783220615       '+%TRIM(FKey04_Anzeige)+ ' +
000784220615       '+%TRIM(FKey05_Anzeige)+ ' +
000785220615       '+%TRIM(FKey08_Anzeige)+ ' +
000786220615       '+%TRIM(FKey10_Anzeige)+ ' +
000787220615       F12=Abbrechen';
000788220615
000789220615       RETURN Ftasten;
000790220615       END-PROC;
000791220615
000792220615       ////////////////////////////////////////////////////////////////////////
000793220615       DCL-PROC StatusZeile;
000794220615       DCL-PI *N LIKE(dsCONTROLSFL.StatusF);
000795220615       iStatus LIKE(dsCONTROLSFL.StatusF);
000796220615       iAnsicht LIKE(Ansicht) const;
000797220615       END-PI;
000798220615
000799221103       IF Ansicht = 1;
000800221103       EVALR iStatus = 'Ansicht1';
000801220615       ENDIF;
000802220615
000803221103       IF Ansicht = 2;
000804221103       EVALR iStatus = 'Ansicht2';
000805220615       ENDIF;
000806220615
000807221103       IF Ansicht = 3;
000808221103       EVALR iStatus = 'Ansicht3';
000809220615       ENDIF;
000810220615
000811221103       IF Ansicht = 4;
000812221103       EVALR iSTATUS = 'Ansicht4';
000813220615       ENDIF;
000814220615
000815220615       RETURN iStatus;
000816220615       END-PROC;
000817220617
000818220617       ////////////////////////////////////////////////////////////////////////
000819220617       DCL-PROC UeberschriftSpalten;
000820220617       DCL-PI *N LIKE(dsCONTROLSFL.ZEILE2);
000821220617       iZEILE2 LIKE(dsCONTROLSFL.ZEILE2);
000823220617       END-PI;
000824220617
000825220617       Spalten1.S1 = 'Name';
000826220617       Spalten1.S2 = 'Artikel';
000827220617       Spalten1.S3 = 'Status';
000828220617       Spalten1.S4 = 'Beschreibung';
000840220617
000841220617       iZEILE2 = 'A ' + Spalten1;
000842220617
000843220617       RETURN iZEILE2;
000844220617       END-PROC;
