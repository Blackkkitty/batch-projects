:: dbfs By blackkitty
:: 算法描述：双向广搜
set xx_0=0&&set yy_0=-1
set xx_1=1&&set yy_1=0
set xx_2=0&&set yy_2=1
set xx_3=-1&&set yy_3=0

set l=0
set r=2
set x0=%start_x%
set y0=%start_y%
set v%start_x%_%start_y%=pre
set pre_%start_x%_%start_y%=0
set x1=%end_x%
set y1=%end_y%
set v%end_x%_%end_y%=nxt
set nxt_%end_x%_%end_y%=0

:dbfs
set x=!x%l%!
set y=!y%l%!
set v=!v%x%_%y%!
:: 在地图上显示标记（x,y），演示搜索过程
call:mark %x% %y% %v:~0,1%
set/a l+=1
set/a i=0
:loop
set/a nx=%x%+!xx_%i%!
set/a ny=%y%+!yy_%i%!
if "!%map%_%nx%_%ny%!" EQU "1" (
:: 若临块为路
    if "!v%nx%_%ny%!" NEQ "%v%" (
    :: 若临块的标记与本块不同
        if defined v%nx%_%ny% (
            ::找到通路
            if "%v%" EQU "pre" (
                call:rush %x% %y% %nx% %ny%
            ) else (
                call:rush %nx% %ny% %x% %y% 
            )
            goto:eof
        )
    :: 若临块的标记与本块不同，且临块无标记
        set %v%_%nx%_%ny%=%x%_%y%
        set x%r%=%nx%&&set y%r%=%ny%&&set v%nx%_%ny%=%v%
        set/a r+=1
    )
)
set/a i+=1&&if "!i!" NEQ "4" (goto loop)
goto dbfs

:rush
set vv=%1_%2
:rvs_loop
if "!pre_%vv%!" EQU "0" (goto rvs_lopp_end)
set nxt_!pre_%vv%!=%vv%
set vv=!pre_%vv%!
goto rvs_loop
:rvs_lopp_end
set nxt_%1_%2=%3_%4
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