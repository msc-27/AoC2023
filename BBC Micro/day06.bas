REM Numerical accuracy appears to be sufficient for the
REM algebraic solution in part 2.
MODE 7
DIM race(9,1): n_races = 0
DIM big_race(1)
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
INPUT "Times >" line$
PROCparse_line(line$,0)
INPUT "Distances >" line$
PROCparse_line(line$,1)
PROCpart1
PROCpart2
OSCLI "EXEC"
END
DEF PROCparse_line(line$,row)
LOCAL i,ptr,val,big$
ptr = INSTR(line$,":") + 1
REPEAT
REPEAT: ptr = ptr + 1: UNTIL ASC MID$(line$,ptr,1) <> 32
val = VAL MID$(line$,ptr)
race(i,row) = val
i = i + 1
big$ = big$ + STR$(val)
ptr = INSTR(line$," ",ptr)
UNTIL ptr = 0
n_races = i
big_race(row) = VAL big$
ENDPROC
DEF PROCpart1
LOCAL i,prod
prod = 1
FOR i = 0 TO n_races - 1
prod = prod * FNsolve(race(i,0), race(i,1))
NEXT
PRINT "Part 1: "; prod
ENDPROC
DEF PROCpart2
PRINT "Part 2: "; FNsolve(big_race(0), big_race(1))
ENDPROC
DEF FNsolve(t,d)
LOCAL lo,hi
lo = INT((t - SQR(t*t - 4*d)) / 2) + 1
hi = t - lo
=hi - lo + 1
DEF PROCbanner
VDU132,157,135,141:PRINT"2023/06       Wait For It"
VDU132,157,135,141:PRINT"2023/06       Wait For It"
ENDPROC
