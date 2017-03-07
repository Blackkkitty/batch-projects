:: 大中华号 By aiwozhonghuaba
:: 算法描述: 向着右下角前进
set ori=a
set x=%current_x: =%
set y=%current_y: =%

:loop
call :check
set list=%list: =%
set list=%list:~,1%
set ori=!%list%:~-3,1!
for /f "delims=- tokens=2,3" %%1 in ("!%list%!") do (
    set /a x=%%1,y=%%2
    call go.bat %%1 %%2
)
if "%x%_%y%" EQU "%end_x%_%end_y%" (goto:eof)
goto loop

:check
::瞅一瞅前后左右
:: 2 4 6 8什么的,看小键盘
set /a x6=x+1,x4=x-1
set /a y2=y+1,y8=y-1
set w=!%map%_%x%_%y8%!-%x%-%y8%-s-!vis_%x%_%y8%!
set s=!%map%_%x%_%y2%!-%x%-%y2%-w-!vis_%x%_%y2%!
set a=!%map%_%x4%_%y%!-%x4%-%y%-d-!vis_%x4%_%y%!
set d=!%map%_%x6%_%y%!-%x6%-%y%-a-!vis_%x6%_%y%!

::筛选方向
::哪个方向隔得远,就优先选哪个方向
set /a dx=end_x-x,dy=end_y-y
set list= s d a w
if %dx% geq %dy% set list= d s a w

::有墙肯定不能走
for %%i in (%list%) do (
    for /f "delims=-" %%1 in ("!%%i!") do (
        if "%%1"=="0" set list=!list: %%i=!
    )
)
::就剩一方向了?
if "%list:~1,1%"=="%list:~-1%" goto :eof

::再排除来时的路
set list=!list: %ori%=!
if "%list:~1,1%"=="%list:~-1%" goto :eof

::先找一下有没有没走过的路,这个地方不用for /f,因为我感觉"大中华"应该不会一条路走了10次...
set _list=%list%
for %%i in (%list%) do (
    if not "!%%i:~-1!"=="0" set list=!list: %%i=!
)
if not "%list%"=="" goto :eof

::如果全部走过了,选走过的次数少的路
::FIXME: 可能那个方向有三条岔路,两条又绕回来了,剩下一条才是对的 ?? 好像不会被坑到...
set list=
for %%i in (%_list%) do (
    if "!list!"=="" (
        set list=%%i
    ) else (
        for /f %%j in ("!list!") do (
            if !%%i:~-1! lss !%%j:~-1! set list=%%i
        )
    )
)
goto :eof
    
:debug
title %1
pause>nul
goto :eof