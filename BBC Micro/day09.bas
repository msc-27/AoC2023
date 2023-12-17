MODE 7
@%=10
DIM value(99)
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
exec = FNget_exec_channel
N% = 0: part1 = 0: part2 = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
PROCline
UNTIL FNend_input
END
DEF FNend_input: IF exec THEN =EOF#exec ELSE =(line$ = "")
DEF PROCline
LOCAL i, j, ptr, sign, all_zero
ptr = 1
REPEAT
value(i) = VAL MID$(line$,ptr)
i = i + 1
ptr = INSTR(line$," ",ptr) + 1
UNTIL ptr = 1
sign = 1
REPEAT
all_zero = TRUE
part1 = part1 + value(i-1)
part2 = part2 + sign * value(0)
sign = -sign
FOR j = 0 TO i-2
value(j) = value(j+1) - value(j)
IF value(j) THEN all_zero = FALSE
NEXT
i = i - 1
UNTIL all_zero
PROCupdate
ENDPROC
DEF PROCupdate
LOCAL vpos: vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(21,2); part1; SPC(9)
PRINT TAB(21,3); part2; SPC(9)
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU134,157,135,141: PRINT "2023/09      Mirage Maintenance"
VDU134,157,135,141: PRINT "2023/09      Mirage Maintenance"
PRINT "Forward  projection:"
PRINT "Backward projection:"
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
DEF FNget_exec_channel
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
