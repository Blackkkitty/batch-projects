:: bot_test By blackkitty
:: 算法描述：靠右墙走
::
::if 右边有墙
::    if 前面没有墙
::        往前走走一步
::    else
::        向左转
::else
::    向右转并走一步
::

:: U R D L
set xx_0=0 && set yy_0=-1
set xx_1=1 && set yy_1=0
set xx_2=0 && set yy_2=1
set xx_3=-1 && set yy_3=0
set x=%current_x% && set y=%current_y%
set dic=0

:loop
call:jiancha return 1
if "%return%" EQU "1" (
    ::右边有墙
    call:jiancha return 0
    if "!return!" EQU "1" (
        ::前面有墙 向左转
        call:zhuanxiang -1
        ) else (
        ::前面没有墙 前进一步
        call:qianjin
        )
    ) else (
    ::右边没有墙 向右转并前进一步
    call:zhuanxiang 1
    call:qianjin
    )
:: 若走到终点则返回
if "%x%_%y%" EQU "%end_x%_%end_y%" (goto:eof)
goto loop

:zhuanxiang 
:: 转向 0不转 1向右转 2向后转 -1向左转
set/a dic=(%dic%+%1+4)%%4
goto:eof

:qianjin
::  前进一步
set/a x=%x%+!xx_%dic%!
set/a y=%y%+!yy_%dic%!
call go %x% %y%
goto:eof

:jiancha
::  %2: 0 前方  1右方  2后方  -1左方 
::  检查%2方向是否有墙 有返回1 没有返回0
set/a dd=(%dic%+%2+4)%%4
set/a xx=%x%+!xx_%dd%!
set/a yy=%y%+!yy_%dd%!
if "!%map%_%xx%_%yy%!" EQU "0" (set %1=1) else (set %1=0)
goto:eof