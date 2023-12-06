REM Numbers in this puzzle are just within the range of
REM integer precision supported by floating point variables.
MODE 7
REM Re-use array "map" to hold the input data for each generation
DIM map(63,2): n_map = 0
REM Part 1: array of item numbers, to be updated each generation
DIM item(19): n_item = 0
REM Part 2: two lists of up to 256 item ranges; alternate between them
DIM item_range(1,255,1), n_range(1)
PROCbanner
INPUT "Filename for input >" file$
IF file$ <> "" THEN OSCLI "EXEC " + file$
exec% = FNget_exec_channel
INPUT "Seeds >" line$
PROCseed_parse(line$)
INPUT"Blank line >" line$
FOR gen = 0 TO 6
INPUT"Mapping header >" line$
N% = 0
REPEAT
N% = N% + 1: PRINT ;N%;: INPUT ">" line$
PROCmap_parse(line$, N%-1)
UNTIL FNend_input
n_map = N%-1
PROCxlate_items
PROCxlate_ranges(gen MOD 2)
NEXT
PROCupdate(1, FNmin_item)
PROCupdate(2, FNmin_range(gen MOD 2))
END
DEF FNend_input: =(line$ = "") OR (exec% <> 0 AND EOF#exec%)
DEF PROCseed_parse(line$)
LOCAL i,ptr,val
ptr = INSTR(line$," ") + 1
REPEAT
val = VAL MID$(line$,ptr)
item(i) = val
IF i MOD 2 = 0 THEN item_range(0, i DIV 2, 0) = val
IF i MOD 2 = 1 THEN item_range(0, i DIV 2, 1) = val
i = i + 1: ptr = INSTR(line$," ",ptr) + 1
UNTIL ptr = 1
n_item = i: n_range(0) = i DIV 2
ENDPROC
DEF PROCmap_parse(line$, i)
LOCAL ptr
map(i,0) = VAL line$
ptr = INSTR(line$," ") + 1
map(i,1) = VAL MID$(line$,ptr)
ptr = INSTR(line$," ",ptr) + 1
map(i,2) = VAL MID$(line$,ptr)
ENDPROC
DEF PROCxlate_items
LOCAL i
FOR i = 0 TO n_item - 1
item(i) = FNxlate_item(item(i))
NEXT
ENDPROC
DEF FNxlate_item(item)
LOCAL i,val
val = -1
REPEAT
IF item >= map(i,1) AND item < map(i,1) + map(i,2) THEN val = item + (map(i,0) - map(i,1))
i = i + 1
UNTIL val >= 0 OR i = n_map
IF val = -1 THEN val = item
=val
DEF FNmin_item
LOCAL i,min
min = item(0)
FOR i = 0 TO n_item-1
IF item(i) < min THEN min = item(i)
NEXT
=min
DEF PROCxlate_ranges(gen)
LOCAL r,x,y,m,flag,next
n_range(1-gen) = 0
FOR r = 0 TO n_range(gen) - 1
x = item_range(gen,r,0)
y = x + item_range(gen,r,1) - 1
REPEAT
m = 0: flag = FALSE: next = 65536*65536
REPEAT
IF map(m,1) <= x AND map(m,1) + map(m,2) > x THEN x = FNmap_range(1-gen,x,y,m): flag = TRUE
IF map(m,1) > x AND map(m,1) < next THEN next = map(m,1)
m = m + 1
UNTIL flag OR m = n_map
IF NOT flag THEN x = FNid_range(1-gen,x,y,next-1)
UNTIL x > y
NEXT
ENDPROC
DEF FNmap_range(gen,x,y,m)
LOCAL hi
hi = map(m,1) + map(m,2) - 1
IF y < hi THEN hi = y
item_range(gen, n_range(gen), 0) = x + (map(m,0) - map(m,1))
item_range(gen, n_range(gen), 1) = hi - x + 1
n_range(gen) = n_range(gen) + 1
=hi+1
DEF FNid_range(gen,x,y,next)
LOCAL hi
hi = y: IF next < y THEN hi = next
item_range(gen, n_range(gen), 0) = x
item_range(gen, n_range(gen), 1) = hi - x + 1
n_range(gen) = n_range(gen) + 1
=hi+1
DEF FNmin_range(gen)
LOCAL i,min
min = item_range(gen,i,0)
FOR i = 0 TO n_range(gen) - 1
IF item_range(gen,i,0) < min THEN min = item_range(gen,i,0)
NEXT
=min
DEF PROCupdate(part, val)
LOCAL vpos: vpos = VPOS
PROCtextwnd(FALSE)
PRINT TAB(30, part+1);val
PROCtextwnd(TRUE)
PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU130:VDU141:PRINT"2023/5 If You Give A Seed A Fertilizer";TAB(0,1);
VDU130:VDU141:PRINT"2023/5 If You Give A Seed A Fertilizer";TAB(0,2);
PRINT"Nearest single seed location:"
PRINT" Nearest seed range location:"
PRINT
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(switch)
VDU 28,0,24,39
IF switch VDU 5 ELSE VDU 0
ENDPROC
DEF FNget_exec_channel
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
