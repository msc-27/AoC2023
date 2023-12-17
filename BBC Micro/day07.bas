MODE 7
DIM score%(1,999), bid%(999), index%(999): n_hands% = 0
DIM rank1%(ASC"T"), rank2%(ASC"T")
DIM freq%(12), occurs%(5)
DIM gap%(6): REM Gap sizes for Shellsort
PROCinit
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
exec% = FNget_exec_channel
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
IF line$ <> "" THEN PROCline(line$)
UNTIL FNend_input
PROCreport
END
DEF FNend_input: IF exec% THEN =EOF#exec% ELSE =(line$ = "")
DEF PROCline(line$)
LOCAL i%, c%, score1%, score2%, freq%
PROCclear_freqs
FOR i% = 1 TO 5
c% = ASC MID$(line$, i%, 1)
score1% = score1% * 16 + rank1%(c%)
score2% = score2% * 16 + rank2%(c%)
freq% = freq%(rank2%(c%)) + 1
freq%(rank2%(c%)) = freq%
occurs%(freq%) = occurs%(freq%) + 1
NEXT
score%(0, n_hands%) = score1% + FNeval1 * &100000
score%(1, n_hands%) = score2% + FNeval2 * &100000
bid%(n_hands%) = VAL MID$(line$, 7)
n_hands% = n_hands% + 1
ENDPROC
DEF PROCclear_freqs
LOCAL i%
FOR i% = 0 TO 12: freq%(i%) = 0: NEXT
FOR i% = 0 TO 5: occurs%(i%) = 0: NEXT
ENDPROC
DEF FNeval1
IF occurs%(5) THEN =6
IF occurs%(4) THEN =5
IF occurs%(3) AND occurs%(2) = 2 THEN =4
IF occurs%(3) THEN =3
IF occurs%(2) = 2 THEN =2
IF occurs%(2) THEN =1
=0
DEF FNeval2
LOCAL jok%
jok% = freq%(0)
IF jok% = 0 THEN =FNeval1
IF jok% = 1 AND occurs%(4) THEN =6
IF jok% = 1 AND occurs%(3) THEN =5
IF jok% = 1 AND occurs%(2) = 2 THEN =4
IF jok% = 1 AND occurs%(2) THEN =3
IF jok% = 1 THEN =1
IF jok% = 2 AND occurs%(3) THEN =6
IF jok% = 2 AND occurs%(2) = 2 THEN =5
IF jok% = 2 THEN =3
IF jok% = 3 AND occurs%(2) = 2 THEN =6
IF jok% = 3 THEN =5
=6
DEF PROCsort(part%)
LOCAL gap_index%, done%, ind%
FOR I% = 0 TO n_hands% - 1: index%(I%) = I%: NEXT
FOR gap_index% = 0 TO 6
G% = gap%(gap_index%)
IF G% >= n_hands% THEN NEXT gap_index%
FOR I% = G% TO n_hands% - 1
J% = I%: done% = FALSE
ind% = index%(I%): S% = score%(part%, ind%)
REPEAT
IF score%(part%, index%(J% - G%)) < S% THEN done% = TRUE ELSE index%(J%) = index%(J% - G%): J% = J% - G%
UNTIL done% OR J% < G%
index%(J%) = ind%
NEXT I%
NEXT gap_index%
ENDPROC
DEF FNresult(part%)
LOCAL i%, result%
PROCsort(part%)
FOR i% = 0 TO n_hands% - 1
result% = result% + (i%+1) * bid%(index%(i%))
NEXT
=result%
DEF PROCreport
LOCAL vpos: vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(25,2); FNresult(0)
PRINT TAB(25,3); FNresult(1)
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCinit
LOCAL i%, rank$
rank$ = "23456789TJQKA"
FOR i% = 0 TO 12: rank1%(ASC MID$(rank$,i%+1,1)) = i%: NEXT
rank$ = "J23456789TQKA"
FOR i% = 0 TO 12: rank2%(ASC MID$(rank$,i%+1,1)) = i%: NEXT
DATA 301,132,57,23,10,4,1
FOR i% = 0 TO 6: READ gap%(i%): NEXT
ENDPROC
DEF PROCbanner
VDU135,157,129,141: PRINT "2023/07        Camel Cards"
VDU135,157,129,141: PRINT "2023/07        Camel Cards"
PRINT "Winnings without jokers:"
PRINT "Winnings    with jokers:"
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
DEF FNget_exec_channel
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
