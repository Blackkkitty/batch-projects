:: bot_test By blackkitty
:: �㷨����������ǽ��
::
::if �ұ���ǽ
::    if ǰ��û��ǽ
::        ��ǰ����һ��
::    else
::        ����ת
::else
::    ����ת����һ��
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
    ::�ұ���ǽ
    call:jiancha return 0
    if "!return!" EQU "1" (
        ::ǰ����ǽ ����ת
        call:zhuanxiang -1
        ) else (
        ::ǰ��û��ǽ ǰ��һ��
        call:qianjin
        )
    ) else (
    ::�ұ�û��ǽ ����ת��ǰ��һ��
    call:zhuanxiang 1
    call:qianjin
    )
:: ���ߵ��յ��򷵻�
if "%x%_%y%" EQU "%end_x%_%end_y%" (goto:eof)
goto loop

:zhuanxiang 
:: ת�� 0��ת 1����ת 2���ת -1����ת
set/a dic=(%dic%+%1+4)%%4
goto:eof

:qianjin
::  ǰ��һ��
set/a x=%x%+!xx_%dic%!
set/a y=%y%+!yy_%dic%!
call go %x% %y%
goto:eof

:jiancha
::  %2: 0 ǰ��  1�ҷ�  2��  -1�� 
::  ���%2�����Ƿ���ǽ �з���1 û�з���0
set/a dd=(%dic%+%2+4)%%4
set/a xx=%x%+!xx_%dd%!
set/a yy=%y%+!yy_%dd%!
if "!%map%_%xx%_%yy%!" EQU "0" (set %1=1) else (set %1=0)
goto:eof