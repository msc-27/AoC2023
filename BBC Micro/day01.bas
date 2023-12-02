MODE 7
PROCbanner
INPUT "Source filename >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
DIM a_pos1 0, a_pos2 0
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT " >" line$
IF line$ <> "" PROCline(line$)
UNTIL line$ = ""
END
DEF PROCline(line$)
LOCAL d1,d2,w1,w2
d1 = FNfirst_digit(line$, a_pos1)
d2 = FNlast_digit(line$, a_pos2)
w1 = FNfirst_word_before(line$, ?a_pos1)
w2 = FNlast_word_after(line$, ?a_pos2)
IF w1 = 0 THEN w1 = d1
IF w2 = 0 THEN w2 = d2
part1 = part1 + 10*d1 + d2
part2 = part2 + 10*w1 + w2
PROCupdate
ENDPROC
DEF FNfirst_digit(line$, a_pos)
LOCAL i,v
i = 0
REPEAT
i = i + 1
v = ASC MID$(line$,i,1)
UNTIL v >= 49 AND v <= 57
?a_pos = i
=v - 48
DEF FNlast_digit(line$, a_pos)
LOCAL i,v
i = LEN(line$) + 1
REPEAT
i = i - 1
v = ASC MID$(line$,i,1)
UNTIL v >= 49 AND v <= 57
?a_pos = i
=v - 48
DEF FNfirst_word_before(line$, pos)
LOCAL i,v
IF pos < 4 THEN =0
i = 1
REPEAT
v = FNcheck_word(line$,i)
i = i + 1
 UNTIL v > 0 OR i = pos - 2
=v
DEF FNlast_word_after(line$, pos)
LOCAL i,v
i = LEN(line$) - 2
IF i <= pos THEN =0
REPEAT
v = FNcheck_word(line$,i)
i = i - 1
UNTIL v > 0 OR i = pos
=v
DEF FNcheck_word(line$,i)
LOCAL n$
n$ = MID$(line$,i,3)
IF n$ = "one" THEN =1
IF n$ = "two" THEN =2
IF n$ = "six" THEN =6
n$ = MID$(line$,i,4)
IF n$ = "four" THEN =4
IF n$ = "five" THEN =5
IF n$ = "nine" THEN =9
n$ = MID$(line$,i,5)
IF n$ = "three" THEN =3
IF n$ = "seven" THEN =7
IF n$ = "eight" THEN =8
=0
DEF PROCupdate
LOCAL vpos
vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(20,2);part1;
PRINT TAB(20,3);part2;
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU 130,141: PRINT "2023/01          Trebuchet?!"
VDU 130,141: PRINT "2023/01          Trebuchet?!"
PRINT "Calibration sum 1:"
PRINT "Calibration sum 2:"
PRINT
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
