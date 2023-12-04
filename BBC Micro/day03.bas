MODE 7
REM Keep a three-row buffer in row$()
REM Gear array: Dimension 1 = row (top,middle,bottom)
REM Dimension 2 = sequential number: allow 16 gears per row
REM Dimension 3 = (x-coord, count of adjacent numbers, gear ratio so far)
REM gc%(): number of gears in row
DIM row$(2), gear%(2,15,2), gc%(2)
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
Y%=&FF: X%=0: A%=&C6: exec% = (USR(&FFF4) AND &FF00) DIV &100
part1% = 0: part2% = 0
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
row$(2) = "." + line$ + "."
IF N% = 1 THEN width% = LEN(line$)+2: row$(1) = STRING$(width%, "."): PROCshift
IF N% > 1 AND line$ <> "" THEN PROCline: PROCsum_gears: PROCshift
UNTIL FNend_input
row$(2) = STRING$(width%, ".")
PROCline: PROCsum_gears: PROCshift: PROCsum_gears
END
DEF FNend_input: IF exec% THEN =EOF#exec% ELSE =(line$ = "")
DEF PROCline
LOCAL i%,c%,n%,x%
x% = -1
FOR i% = 2 TO width%-1
c% = ASC MID$(row$(1),i%,1)
IF c% >= 48 AND c% <= 57 THEN n% = n%*10 + c%-48: IF x% = -1 THEN x% = i%
IF (c% < 48 OR c% > 57) AND n% <> 0 THEN PROCnumber(n%,x%,i%-1): n% = 0: x% = -1
NEXT
IF n% THEN PROCnumber(n%,x%,width%-1)
PROCupdate(1)
ENDPROC
DEF PROCnumber(n%,x1%,x2%)
LOCAL x%,adj%
FOR x% = x1%-1 TO x2%+1
IF FNcheck_symbol(0,x%,n%) THEN adj% = TRUE
IF FNcheck_symbol(2,x%,n%) THEN adj% = TRUE
NEXT
IF FNcheck_symbol(1,x1%-1,n%) THEN adj% = TRUE
IF FNcheck_symbol(1,x2%+1,n%) THEN adj% = TRUE
IF adj% THEN part1% = part1% + n%
ENDPROC
DEF FNcheck_symbol(row%,x%,n%)
LOCAL c%
c% = ASC MID$(row$(row%),x%,1)
IF (c% >= 48 AND c% <= 57) OR c% = 46 THEN =FALSE
IF c% = 42 THEN PROCgear(row%,x%,n%)
=TRUE
DEF PROCgear(row%,x%,n%)
LOCAL i%,gx%
IF gc%(row%) = 0 THEN PROCnew_gear(row%,x%,n%): ENDPROC
i% = -1
REPEAT: i% = i% + 1
gx% = gear%(row%,i%,0)
UNTIL gx% = x% OR i% = gc%(row%) - 1
IF gx% = x% THEN PROCupdate_gear(row%,i%,n%) ELSE PROCnew_gear(row%,x%,n%)
ENDPROC
DEF PROCupdate_gear(row%,i%,n%)
LOCAL gn%
gn% = gear%(row%,i%,1): gear%(row%,i%,1) = gn% + 1
IF gn% = 1 THEN gear%(row%,i%,2) = gear%(row%,i%,2) * n%
ENDPROC
DEF PROCnew_gear(row%,x%,n%)
LOCAL gc%
gc% = gc%(row%)
gear%(row%,gc%,0) = x%
gear%(row%,gc%,1) = 1
gear%(row%,gc%,2) = n%
gc%(row%) = gc% + 1
ENDPROC
DEF PROCsum_gears
LOCAL i%
IF gc%(0) = 0 ENDPROC
FOR i% = 0 TO gc%(0) - 1
IF gear%(0,i%,1) = 2 THEN part2% = part2% + gear%(0,i%,2)
NEXT
PROCupdate(2)
ENDPROC
DEF PROCshift
LOCAL i%,row%
FOR row% = 0 TO 1
row$(row%) = row$(row%+1)
gc%(row%) = gc%(row%+1)
FOR i% = 0 TO gc%(row%+1)
gear%(row%,i%,0) = gear%(row%+1,i%,0)
gear%(row%,i%,1) = gear%(row%+1,i%,1)
gear%(row%,i%,2) = gear%(row%+1,i%,2)
NEXT: NEXT
gc%(2) = 0
ENDPROC
DEF PROCupdate(part)
LOCAL vpos: vpos = VPOS
PROCtextwnd(FALSE)
IF part = 1 THEN PRINT TAB(25,2);part1%
IF part = 2 THEN PRINT TAB(25,3);part2%
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU134,141:PRINT"2023/03         Gear Ratios"
VDU134,141:PRINT"2023/03         Gear Ratios"
PRINT "Sum of all part numbers:"
PRINT "Sum of all gear ratios:"
PRINT
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
