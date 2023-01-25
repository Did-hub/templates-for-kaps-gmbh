             PGM        PARM(&K &CHWWS &B &CHFIBU)    /* V7R2M0 */

 /* PARAMETER K       = BIBLIOTHEK WARENWIRTSCHAFT                         */
 /* PARAMETER CHWWS   = BIBLIOTHEK DATEIEN WARENWIRTSCHAFT                 */
 /* PARAMETER B       = BIBLIOTHEK FINANZBUCHHALTUNG                       */
 /* PARAMETER CHFIBU  = BIBLIOTHEK DATEIEN FINAZBUCHHALTUNG                */

             DCL        VAR(&K) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHWWS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHFIBU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHEDI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INFO) TYPE(*CHAR) LEN(70)
             DCL        VAR(&RECLEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LIZ) TYPE(*CHAR) LEN(5)

/*PARAMETTER FÜR NLIZP */
             DCL        VAR(&FUNKT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BEDI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MELD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NICHT) TYPE(*CHAR) LEN(1)

/*PARAMETER FÜR CRTORDGET */
             DCL        VAR(&CRTORD) TYPE(*CHAR) LEN(1)
/*PARAMETER FÜR CHGABKTREP */
             DCL        VAR(&CORABI) TYPE(*CHAR) LEN(1)
/*PARAMETER FÜR LVS-DATEIEN ERSTELLEN */
             DCL        VAR(&DATSTS) TYPE(*CHAR) LEN(1)
/*LIZENZ ERMITTELN */
             CALL       PGM(K/U01L) PARM(&LIZ)

/*  BERICHTIGUNGEN  */


             CHGVAR     VAR(&INFO) VALUE('Dateien in Bibliothek' *BCAT +
                          &CHWWS *BCAT 'werden modifiziert.')
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&INFO) +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)

/*  NEUE DATEIEN UND DATEIÄNDERUNGEN KD  */
/*  06.2022    */

 /* -----------------------------------------------------------------------*/
 /*  ERSTELLUNG PF UND LF                                                  */
 /* -----------------------------------------------------------------------*/

          /* VLS + LVS-LAGER LEISTEN WAGEN + LAGERFACH   */
 YVLALFLS:   CHKOBJ     OBJ(&CHWWS/YVLALFLS) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YVLALFLS) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YVLALFLSL1: CHKOBJ     OBJ(&CHWWS/YVLALFLSL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YVLALFLSL1) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

 YVLALFLSL2: CHKOBJ     OBJ(&CHWWS/YVLALFLSL2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YVLALFLSL2) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* JO004 STAMMSATZDATEI TEXT FÜR MAILBODY            */
 JO004KKMBT: CHKOBJ     OBJ(&CHWWS/JO004KKMBT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/JO004KKMBT) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* BESTELLPOSITIONEN FÜR LVS - JE TE-NUMMER LVS      */
 YD2LSTE:    CHKOBJ     OBJ(&CHWWS/YD2LSTE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YD2LSTE) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* MAILBODY TEXT JE BELEGART                         */
 YMBTX:      CHKOBJ     OBJ(&CHWWS/YMBTX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YMBTX) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YMBTXL0:    CHKOBJ     OBJ(&CHWWS/YMBTXL0) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YMBTXL0) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* AUFTRAGSDATEI - POSITIONEN                        */
 YA2:        CHKOBJ     OBJ(&CHWWS/YA2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YA2) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YA2L3:      CHKOBJ     OBJ(&CHWWS/YA2L3) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YA2L3) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* LVP - AUFTRAG  POSITIONEN YA2                    */
 LPA3:       CHKOBJ     OBJ(&CHWWS/LPA3) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/LPA3) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 LPA34N2:    CHKOBJ     OBJ(&CHWWS/LPA34N2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/LPA34N2) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* ST007 - ARTIKEL ERWEITERUNG                      */
 STSYARV:    CHKOBJ     OBJ(&CHWWS/STSYARV) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/STSYARV) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 STSKUER:    CHKOBJ     OBJ(&CHWWS/STSKUER) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/STSKUER) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* ILV LAGER ZUSATZINFORMATION ILV-AUFTRAG POSITION */
 YUBWA1P:    CHKOBJ     OBJ(&CHWWS/YUBWA1P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YUBWA1P) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YUBWA1PL1:  CHKOBJ     OBJ(&CHWWS/YUBWA1PL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YUBWA1PL1) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

 YUBWA1PL2:  CHKOBJ     OBJ(&CHWWS/YUBWA1PL2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YUBWA1PL2) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* ILV LAGER ZUSATZINFORMATION ILV-AUFTRAG POSITION */
 YUBWA1O:    CHKOBJ     OBJ(&CHWWS/YUBWA1O) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YUBWA1O) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YUBWA1OL1:  CHKOBJ     OBJ(&CHWWS/YUBWA1OL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YUBWA1OL1) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* ILV LAGER ZUSATZINFORMATION ILV-AUFTRAG HISTORIE */
 YUBWA1PH:   CHKOBJ     OBJ(&CHWWS/YUBWA1PH) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/YUBWA1PH) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* EINGEHENDE DESADV                                */
 PROTDES:    CHKOBJ     OBJ(&CHWWS/PROTDES) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/PROTDES) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* ARTIKEL - VARIANTEN CE-ETIKETT JO004 PROTOKOLL   */
 YARVCEPR:   CHKOBJ     OBJ(&CHWWS/YARVCEPR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YARVCEPR) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YARVCEPRL1: CHKOBJ     OBJ(&CHWWS/YARVCEPRL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YARVCEPRL1) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* LVS - MDE - DRUCKER                              */
 LSMDEDR:    CHKOBJ     OBJ(&CHWWS/LSMDEDR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&CHWWS/LSMDEDR) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* STAMMDATEN LIEFERANT EDIFACT                     */
 YLIEDI:     CHKOBJ     OBJ(&CHWWS/YLIEDI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YLIEDI) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YLIEDI1:    CHKOBJ     OBJ(&CHWWS/YLIEDI1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YLIEDI1) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

 YLIEDI2:    CHKOBJ     OBJ(&CHWWS/YLIEDI2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YLIEDI2) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

 YLIEDI3:    CHKOBJ     OBJ(&CHWWS/YLIEDI3) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YLIEDI3) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* VERLADELISTE TA VERSAND FÜR SCAN                 */
 LSVLTV:     CHKOBJ     OBJ(&CHWWS/LSVLTV) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/LSVLTV) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 LSVLTV6:    CHKOBJ     OBJ(&CHWWS/LSVLTV6) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/LSVLTV6) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* WEITERE DATEN LVS-LAGER                          */
 YW1LVS:     CHKOBJ     OBJ(&CHWWS/YW1LVS) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YW1LVS) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

      /* VERBUCHEN STATISTIK                              */
 YVS:        CHKOBJ     OBJ(&CHWWS/YVS) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YVS) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 YVSL1:      CHKOBJ     OBJ(&CHWWS/YVSL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/YVSL1) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* LVS - WE KONTROLLE KOPFDATEN                     */
 LSW1:       CHKOBJ     OBJ(&CHWWS/LSW1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/LSW1) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 LSW1L62:    CHKOBJ     OBJ(&CHWWS/LSW1L62) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTLF +
                          FILE(&CHWWS/LSW1L62) +
                          SRCFILE(&K/QDDSSRC) OPTION(*NOSRC *NOLIST))
             MONMSG     MSGID(CPF7302)

      /* PROTOKOLL FEHLERMELDUNG ZUSATZTEXT FEHLT         */
 YPROZTX:    CHKOBJ     OBJ(&CHWWS/YPROZTX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&CHWWS/YPROZTX) SRCFILE(&K/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             MONMSG     MSGID(CPF7302)

 /* -----------------------------------------------------------------------*/
 /*  ERSTELLUNG TABLES UND VIEWS                                           */
 /* -----------------------------------------------------------------------*/

      /* TABELLE YTAYA4 ERSTELLEN  */
 YTAYA4:     CHKOBJ     OBJ(&CHWWS/YTAYA4) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CALL PGM(CRTYTAYA4) +
                          PARM(&CHWWS))
             MONMSG     MSGID(CPF0000)

 /* -----------------------------------------------------------------------*/
 /*  EINMALIGE AUFRUF - ÜBER PARAMETER SA 950 GESTEUERT                    */
 /* -----------------------------------------------------------------------*/

 /* SA 950 - PARAMETER CRTORD                       */
             CALL       PGM(CRTORDGET) PARM(&CRTORD)     /*    YTA SA 950 */
             IF         COND(&CRTORD *EQ ' ') THEN(DO)

 /* ABI-KALENDER ERSTELLEN */
             CALL       PGM(CRTABIKALR) PARM(&CHWWS &CHWWS)
             MONMSG     MSGID(CPF0000)

 /* EDIFACT BIBLIOTHEK HOLEN  */
             CALL       PGM(U01EDI) PARM(&CHEDI)
             MONMSG     MSGID(CPF0000)
 /* EDIFACT BIBLIOTHEK ZUORDNEN */
             ADDLIBLE   LIB(&CHEDI)
             MONMSG     MSGID(CPF2110) EXEC(GOTO CMDLBL(SET1))
             MONMSG     MSGID(CPF2103)
 /* ERGOTOPIA - EDI SP007 */
             CALL       PGM(CRTYORDKVA) PARM(&CHEDI &CHWWS)
             MONMSG     MSGID(CPF0000)

 SET1:       CALL       PGM(CRTORDSET) /* KENNZEICHEN IN YTA SETZEN */
             MONMSG     MSGID(CPF0000)     /*   YTA SA 950            */
             ENDDO

 /* SA 950 - PARAMETER CORABI                       */
             CALL       PGM(CORABIGET) PARM(&CORABI)     /*    YTA SA 950 */
             IF         COND(&CORABI *EQ ' ') THEN(DO)

 /* ABI-KALENDER KORRIGIEREN */
             CALL       PGM(CHGABKTREP) PARM(&CHWWS)
             MONMSG     MSGID(CPF0000)

 SET2:       CALL       PGM(CORABISET) /* KENNZEICHEN IN YTA SETZEN */
             MONMSG     MSGID(CPF0000)     /*   YTA SA 950            */
             ENDDO

 /* UNTER LIZENZ ST007 - FA.STARK --------------------------------------  */
             IF         COND(&LIZ *EQ 'ST007') THEN(DO)
 /* SA 950 - PARAMETER DATSTS                       */
             CALL       PGM(DATSTSGET) PARM(&DATSTS)     /*    YTA SA 950 */
             IF         COND(&DATSTS *EQ ' ') THEN(DO)

 /* LVS-DATEIEN FÜR ST007 ERSTELLEN */
             CALL       PGM(STSDATCL)
             MONMSG     MSGID(CPF0000)

 /* ALLE TRIGGER LOESCHEN UND NEU ERSTELLEN */
             CALL       PGM(STSTRCRTCL)
             MONMSG     MSGID(CPF0000)

 SET3:       CALL       PGM(DATSTSSET) /* KENNZEICHEN IN YTA SETZEN */
             MONMSG     MSGID(CPF0000)     /*   YTA SA 950            */
             ENDDO
             ENDDO                         /*   ST007 ------ ENDE     */

 NEXT:       /*BEIM NÄCHSTEN MAL DEN VORHERIGEN SPRUNGBEFEHL ÄNDERN */

 ENDE:       ENDPGM 
