MODE 7
PROCbanner
INPUT "Source filename >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
part1 = 0: part2 = 0
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
IF line$ <> "" PROCline(line$)
UNTIL line$ = ""
END
DEF PROCline(line$)
LOCAL id, len, ptr, n, char, red, green, blue
len = LEN(line$)
id = VAL MID$(line$,6)
ptr = INSTR(line$,":") + 2
REPEAT
n = VAL MID$(line$, ptr)
ptr = INSTR(line$," ",ptr) + 1
char = ASC MID$(line$, ptr, 1)
IF char = 98 THEN ptr = ptr + 6: IF n > blue THEN blue = n
IF char = 103 THEN ptr = ptr + 7: IF n > green THEN green = n
IF char = 114 THEN ptr = ptr + 5: IF n > red THEN red = n
UNTIL ptr > len
IF red <= 12 AND green <= 13 AND blue <= 14 THEN part1 = part1 + id
part2 = part2 + red * green * blue
PROCupdate
ENDPROC
DEF PROCupdate
LOCAL vpos
vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(26,2);part1;
PRINT TAB(27,3);part2;
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU129,141:PRINT"2023/02";:VDU130:PRINT"      Cube";:VDU132:PRINT"Conundrum"
VDU129,141:PRINT"2023/02";:VDU130:PRINT"      Cube";:VDU132:PRINT"Conundrum"
PRINT "Sum of possible game IDs:"
PRINT "Sum of minimum set powers: "
PRINT
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
