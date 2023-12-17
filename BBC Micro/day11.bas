MODE 7
DIM gal%(1,255): REM number of galaxies in each row/column
n_gal% = 0: REM total number of galaxies
DIM solve_result 7, solve_partial 7: REM 64-bit vars for PROCsolve
PROCasm_u64_utils
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
exec% = FNget_exec_channel
N% = 0
REPEAT
N% = N% + 1
PRINT N%;: INPUT LINE " >" line$
IF N% = 1 THEN size% = LEN(line$)
PROCline
UNTIL FNend_input
PRINT "Expansion factor 2: ";: PROCsolve(2)
CALL print_u64, !solve_result: PRINT
PRINT "Expansion factor 1000000: ";: PROCsolve(1000000)
CALL print_u64, !solve_result: PRINT
END
DEF FNend_input: IF exec% THEN =EOF#exec% ELSE =(line$ = "")
DEF PROCline
LOCAL x%
FOR x% = 1 TO size%
IF ASC MID$(line$,x%,1) = 35 THEN PROCadd_galaxy(x%,N%)
NEXT
ENDPROC
DEF PROCadd_galaxy(x%,y%)
gal%(0,y%) = gal%(0,y%) + 1
gal%(1,x%) = gal%(1,x%) + 1
n_gal% = n_gal% + 1
ENDPROC
DEF PROCsolve(exp%)
LOCAL axis%, i%, from%, to%
solve_result!0 = 0: solve_result!4 = 0
FOR axis% = 0 TO 1
from% = 0: to% = n_gal%
FOR i% = 1 TO size%
solve_partial!0 = from% * to%: solve_partial!4 = 0
IF gal%(axis%, i%) = 0 THEN CALL mulu64_32, !solve_partial, exp%
CALL add64, !solve_result, !solve_partial
from% = from% + gal%(axis%, i%)
to% = to% - gal%(axis%, i%)
NEXT i%
NEXT axis%
ENDPROC
DEF PROCbanner
VDU132,141:PRINT"2023/11      Cosmic Expansion"
VDU132,141:PRINT"2023/11      Cosmic Expansion"
PRINT
VDU 28,0,24,39,3
ENDPROC
DEF FNget_exec_channel
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
DEF PROCasm_u64_utils
OSWRCH=&FFEE
dst = &80: src = &82: src_byte = &84
wrk = &70: REM 12-byte work area
ldz = &7D: ctr1 = &7E: ctr2 = &7F
DIM code 287
FOR pass = 0 TO 2 STEP 2
P% = code
[ OPT pass
.add64
LDA &601:STA dst:LDA &602:STA dst+1
LDA &604:STA src:LDA &605:STA src+1
LDY #0:LDX #8:CLC
.loop LDA (dst),Y:ADC (src),Y:STA (dst),Y:INY:DEX:BNE loop:RTS
.mulu64_32
LDA &601:STA dst:LDA &602:STA dst+1
LDA &604:STA src:LDA &605:STA src+1
LDA #0:LDX #7
.zero STA wrk+4,X:DEX:BPL zero
LDY #0
.mply_byte LDA (src),Y:STA src_byte:STY ctr1:LDA #8:STA ctr2
.mply_bit LSR src_byte:BCC skip
CLC:LDY #0:LDX #8
.add LDA wrk+4,Y:ADC (dst),Y:STA wrk+4,Y:INY:DEX:BNE add
.skip ROR wrk+11:ROR wrk+10:ROR wrk+9:ROR wrk+8:ROR wrk+7:ROR wrk+6
ROR wrk+5:ROR wrk+4:ROR wrk+3:ROR wrk+2:ROR wrk+1:ROR wrk
DEC ctr2:BNE mply_bit
LDY ctr1:INY:CPY #4:BNE mply_byte
LDY #7:.copy LDA wrk,Y:STA (dst),Y:DEY:BPL copy:RTS
.print_u64
LDA &601:STA src:LDA &602:STA src+1
LDA #0:STA wrk:STA wrk+1:STA wrk+2:STA wrk+3:STA wrk+4
STA wrk+5:STA wrk+6:STA wrk+7:STA wrk+8:STA wrk+9:STA ldz
SED:LDA #7:STA ctr1
.byte LDY ctr1:LDA (src),Y:STA ctr2:LDY #7
.bit ASL ctr2:LDX #9
.decadd LDA wrk,X:ADC wrk,X:STA wrk,X:DEX:BPL decadd
DEY:BPL bit
DEC ctr1:BPL byte:CLD:LDX #0
.digit LDA wrk,X:PHA:LSR A:LSR A:LSR A:LSR A:BNE print1
LDY ldz:BEQ nyb
.print1 INC ldz:ORA #&30:JSR OSWRCH
.nyb PLA:AND #&0F:BNE print2
LDY ldz:BEQ next
.print2 INC ldz:ORA #&30:JSR OSWRCH
.next INX:CPX #10:BCC digit:LDY ldz:BEQ print2:RTS
] NEXT
ENDPROC
