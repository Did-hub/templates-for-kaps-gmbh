**free
//________________________________________________
// DIESES PROGRAMM IST EIGENTUM DER FIRMA KAPS-UNTERNEHMENSBERATUNG
// MEISENWEG 2, 8901 EMERSACKER, 08293 / 6126
// Autor...............:    DC
//_______________________________________________

//Compiler Option
CTL-OPT Option(*NODEBUGIO:*srcstmt)
        ALWNULL(*USRCTL)
        ACTGRP(*CALLER)
        BNDDIR('KAPSBNDDIR');

/define Tool
/define KSHSRV
/copy QRPGLESRC,PRPROTOTYP
/undefine KSHSRV
/undefine Tool
/copy QRPGLESRC,DCCONST

DCL-S LIB CHAR(10);

//Definitionen
dcl-DS Parm1 qualified template;
  File              Char(10);     //Dateiname
  Library           Char(10);     //Bibliothek der Datei
  Member            Char(10);     //Member / Recordname
  TriggerEvent      Char(1);      //Trigger Event 1=Write 2=Delete 3=Update 4=Re
  TriggerTime       Char(1);      //Triggerzeit (1=After/2=Before)
  CommitLock        Char(1);      //commit Lock Level
  *N                Char(3);      //Reserved / Reserviert
  CCSID             Int(10);      //CCSID
  RRN               INT(10);      //Reserved / Reserviert
  *N                Char(4);      //Reserved / Reserviert
  BeforeOffset      Int(10);      //Offset to Before Image
  BeforeLength      Int(10);      //Length of Offset Before Image
  BeforeNULLOffset  Int(10);
  BeforeNULLLength  Int(10);
  AfterOffset       Int(10);
  AfterLength       Int(10);
  AfterNULLOffset   Int(10);
  AfterNULLLength   Int(10);
  Reserved3 char(16) ;
  TheRest char(1000) ;
END-DS;

// Event
DCL-C Insert CONST('1');
DCL-C Update CONST('3');

// Time
DCL-C after  CONST('1');
DCL-C before CONST('2');

//______
DCL-S AfterOffsetPTR pointer;
DCL-DS dsAfterOffset extname('YMUST') based(AfterOffsetPTR) qualified end-ds;

DCL-S BeforeOffsetPTR pointer;
DCL-DS dsBeforeOffset extname('YMUST') based(BeforeOffsetPTR) qualified end-ds;

DCL-S BeforeNullPointer pointer;
dcl-s BEFORE_FieldNulls char(1) dim(100) ;
DCL-DS BeforeNullSpace extname('YMUST') based(BeforeNullPointer) qualified end-ds;

dcl-s AFTER_FieldNulls  char(1) dim(100) ;
DCL-S AfterNullPointer pointer;
DCL-DS AfterNullSpace extname('YMUST') based(AfterNullPointer) qualified end-ds;

//*ENTRY
dcl-PI *N;
  p_parm1 likeds(parm1);
  Parm1_Length       Int(10);
END-PI;

// SQL Optionen
exec sql set option commit = *NONE, CLOSQLCSR = *ENDMOD;

//_____________________________________________________________________________
// MAIN

LIB = yta105_bib();
exec sql set schema = :LIB;

// data
AfterOffsetPTR  = %ADDR(p_parm1) + p_Parm1.AfterOffset;
BeforeOffsetPTR  = %ADDR(p_parm1) + p_Parm1.BeforeOffset;



// Null-value processing
Null_value_processing();

  // error handling before
  IF p_parm1.TriggerTime = before;
  //  IF xValidation(dsAfterOffset:AFTER_FieldNulls) = error;
    dsAfterOffset.STATUS = error;
  //  ENDIF;
  ENDIF;

  // processing handling after
  IF p_parm1.TriggerTime = after;
  IF dsAfterOffset.STATUS <> error;
  //   xProcess(dsAfterOffset.ID);
  ENDIF;
  ENDIF;

*INLR = *ON;
return;
//_____________________________________________________________________________
//
DCL-PROC Null_value_processing;
DCL-S i INT(10);
DCL-S ColumnCnt INT(10);

// Null-value handling
BeforeNullPointer  = %ADDR(p_parm1) + p_Parm1.BeforeNULLOffset;
AfterNullPointer  = %ADDR(p_parm1) + p_Parm1.AfterNULLOffset;

// count columns
exec sql
select count(1)
  into :ColumnCnt
  from qsys2.syscolumns
 where Table_Name   = 'YMUST'
   and table_schema = current_schema
  ;

For i = 1 to ColumnCnt;
AFTER_FieldNulls(i) = %subst(AfterNullSpace:i:1);
Endfor;

END-PROC;
