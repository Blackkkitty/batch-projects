:: dfs By blackkitty
:: 算法描述：深搜
set xx_0=0 && set yy_0=-1
set xx_1=1 && set yy_1=0
set xx_2=0 && set yy_2=1
set xx_3=-1 && set yy_3=0
set x=%current_x% && set y=%current_y%

set flag=0
call:dfs %x% %y% 0
goto:eof

:dfs
:: <x> <y>
if "%1_%2" EQU "%end_x%_%end_y%" (set flag=1 && goto:eof)
set dic_%3=0
:dfs_loop1
set tmp=!dic_%3!
set/a dfs=%3+1
set/a nx=%1+!xx_%tmp%!
set/a ny=%2+!yy_%tmp%!
if !vis_%nx%_%ny%! EQU 0 (
    if !%map%_%nx%_%ny%! EQU 1 (
        call go %nx% %ny%
        call:dfs %nx% %ny% %dfs%
    )
)
if %flag% EQU 1 (goto:eof)
set/a dic_%3+=1
if !dic_%3! LSS 4 (goto dfs_loop1)
goto:eof