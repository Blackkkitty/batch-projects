:: dbfs By blackkitty
:: 算法描述：逆向广搜
set xx_0=0&&set yy_0=-1
set xx_1=1&&set yy_1=0
set xx_2=0&&set yy_2=1
set xx_3=-1&&set yy_3=0

set l=0
set r=1
set x0=%end_x%
set y0=%end_y%
set nxt_%end_x%_%end_y%=0

:rbfs
set x=!x%l%!
set y=!y%l%!
:: 在地图上显示标记（x,y），演示搜索过程
call:mark %x% %y% .
set/a l+=1
if "%x%_%y%" EQU "%start_x%_%start_y%" (goto rush)
for /l %%i in (0,1,3) do (
    set/a nx=x+!xx_%%i!
    set/a ny=y+!yy_%%i!
    set/a val=%map%_!nx!_!ny!
    if "!val!" EQU "1" (
        if not defined nxt_!nx!_!ny! (
            set nxt_!nx!_!ny!=!x!_!y!
            set x!r!=!nx!
            set y!r!=!ny!
            set/a r+=1
        )
    )
)
goto rbfs

:rush
set vv=!nxt_%start_x%_%start_y%!
:rush_loop
if "%vv%" EQU "0" (goto:eof)
call go %vv:_= %
set vv=!nxt_%vv%!
goto rush_loop

:mark
:: <x> <y> 在地图上显示标记（x,y），用来演示搜索过程
set/a _x=%1*2+%maze_x% && set/a _y=%2+%maze_y%
cc %_x% %_y% && echo.%~3
goto:eof