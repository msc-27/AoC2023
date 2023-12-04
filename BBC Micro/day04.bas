MODE 7
REM Allow up to 256 scratchcards with numbers from 0-99
DIM flag%(99), extras%(255)
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
part1 = 0: part2 = 0
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
IF line$ <> "" THEN PROCline(line$)
PROCupdate
UNTIL line$=""
END
DEF PROCline(line$)
LOCAL ptr, n, rhs, match, copies
copies = extras%(N%) + 1
part2 = part2 + copies
ptr = INSTR(line$,":") + 1
REPEAT
REPEAT: ptr = ptr + 1: UNTIL MID$(line$,ptr,1) <> " "
n = VAL(MID$(line$,ptr))
IF n AND NOT rhs THEN flag%(n) = N%
IF n AND rhs THEN IF flag%(n) = N% THEN match = match + 1
IF n = 0 THEN rhs = TRUE
ptr = INSTR(line$," ",ptr)
UNTIL ptr = 0
IF match = 0 THEN ENDPROC
part1 = part1 + 2^(match - 1)
FOR i = N%+1 TO N%+match
extras%(i) = extras%(i) + copies
NEXT
ENDPROC
DEF PROCupdate
LOCAL vpos: vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(23,2);part1
PRINT TAB(23,3);part2
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU129,157,131,141:PRINT"2023/04        Scratchcards"
VDU129,157,131,141:PRINT"2023/04        Scratchcards"
PRINT "   Sum of card scores:"
PRINT "Total number of cards:"
PRINT
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
