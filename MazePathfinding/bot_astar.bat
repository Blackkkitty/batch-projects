:: astar By blackkitty
:: 算法描述：逆向启发式A*
set xx_0=0&&set yy_0=-1
set xx_1=1&&set yy_1=0
set xx_2=0&&set yy_2=1
set xx_3=-1&&set yy_3=0

set new=1
set x0=%end_x%
set y0=%end_y%
set nxt_%end_x%_%end_y%=0
set gn0=0
set fn0=0
set list=n0
set/a maxfn=!%map%_width!*!%map%_height!

:astar
set vv=_
set minfn=%maxfn%
:: 从列表选取fn最小的位置
for %%k in (%list%) do (
    if !f%%k! LSS !minfn! (
        set minfn=!f%%k!
        set vv=%%k
    )
)
:: 从列表中删除这个位置
set list=!list:%vv%=!
set vv=%vv:~1%
set x=!x%vv%!
set y=!y%vv%!

:: 在地图上显示标记（x,y），演示搜索过程
call:mark %x% %y% .

if "%x%_%y%" EQU "%start_x%_%start_y%" (goto rush)
for /l %%i in (0,1,3) do (
    set/a nx=x+!xx_%%i!
    set/a ny=y+!yy_%%i!
    set/a val=%map%_!nx!_!ny!
    if "!val!" EQU "1" (
        if not defined nxt_!nx!_!ny! (
            set nxt_!nx!_!ny!=!x!_!y!
            :: 加入列表
            set list=!list! n!new!
            :: 计算gn
            set/a gn!new!=!gn%vv%!+1
            :: 计算fn保存至fn!new!
            call:fn !nx! !ny! gn!new! fn!new!
            set x!new!=!nx!
            set y!new!=!ny!
            set/a new+=1
        )
    )
)
goto astar

:rush
set vv=!nxt_%start_x%_%start_y%!
:rush_loop
if "%vv%" EQU "0" (goto:eof)
call go %vv:_= %
set vv=!nxt_%vv%!
goto rush_loop


:fn
:: <x> <y> [gn] [ret] 起点到x，y的估计代价（fn = gn + hn）
:: gn 终点到(x,y)的实际代价
:: hn 起点到(x,y)的估计代价，估值为起点到(x,y)的曼哈顿距离
set/a tmp=%1-%start_x%
if %tmp% LSS 0 (set/a tmp=-tmp)
set %4=%tmp%
set/a tmp=%2-%start_y%
if %tmp% LSS 0 (set/a tmp=-tmp)
set/a %4=!%4!+%tmp%+!%3!
goto:eof

:mark
:: <x> <y> 在地图上显示标记（x,y），用来演示搜索过程
set/a _x=%1*2+%maze_x% && set/a _y=%2+%maze_y%
cc %_x% %_y% && echo.%~3
goto:eof