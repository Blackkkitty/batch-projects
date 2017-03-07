:: Breadth First Search By Cyxgg
:: 算法描述：宽搜

set dx0=0
set dy0=1
set dx1=0
set dy1=-1
set dx2=1
set dy2=0
set dx3=-1
set dy3=0
set /a x0=%current_x%
set /a y0=%current_y%
set head=0
set tail=1
set pre%x0%_%y0%=-1

:loop
set x=!x%head%!
set y=!y%head%!

:: 在地图上显示标记（x,y），演示搜索过程
call:mark %x% %y% .

set /a head+=1
for /l %%i in (0,1,3) do (
	set /a nx=x+!dx%%i!
	set /a ny=y+!dy%%i!
	set /a val=%map%_!nx!_!ny!
	if "!val!"=="1" (
		if not defined pre!nx!_!ny! (
			set x!tail!=!nx!
			set y!tail!=!ny!
			set /a pre!nx!_!ny!=x*10000+y
			set /a tail+=1
		)
	)
)
if defined pre%end_x%_%end_y% goto solve
goto loop

:solve
pause>nul
set x0=%end_x%
set y0=%end_y%
set head=0
call :getans
set /a head-=1
for /l %%i in (%head%,-1,0) do (
	call go !x%%i! !y%%i!
)
goto :eof

:getans
set /a tmp=pre!x%head%!_!y%head%!
if %tmp%==-1 goto :eof
set /a head+=1
set /a x%head%=tmp/10000
set /a y%head%=tmp%%10000
goto getans

:mark
:: <x> <y> 在地图上显示标记（x,y），用来演示搜索过程
set/a _x=%1*2+%maze_x% && set/a _y=%2+%maze_y%
cc %_x% %_y% && echo.%~3
goto:eof