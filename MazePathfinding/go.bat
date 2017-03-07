:go
:: <x> <y> 移动至（x，y）
if "!%map%_%1_%2!" EQU "0" (goto:eof)

set/a _x=%current_x%*2+%maze_x% && set/a _y=%current_y%+%maze_y%
cc %_x% %_y% && echo.%_PATH%
set current_x=%1 && set current_y=%2
set/a _x=%current_x%*2+%maze_x% && set/a _y=%current_y%+%maze_y%
cc %_x% %_y% && echo.%_P%
if "!vis_%1_%2!" EQU "0" (set/a vis_count+=1)
set/a vis_%1_%2+=1
set/a steps+=1
call:State
goto:eof

:State
call:difftime %beginTime% %time% timer
cc 2 1 && echo.步数：%steps% 位置：(%current_x%,%current_y%) 用时：%timer% 已访问数：%vis_count%         
goto:eof

:difftime 
:: difftime <Begin_Time> <End_Time> [ret]
set b=0%1&set e=0%2&set c=1!e:~-11!-1!b:~-11!&set c=!c::=!
set/a c=%c:.=%-4000*(160*(1%e:~-11,-9%-1%b:~-11,-9%)+1%e:~-8,-6%-1%b:~-8,-6%)
if %3.==. (echo %c:-=8640000-%) else set/a %3=%c:-=8640000-%
goto:eof