:: ���л��� By aiwozhonghuaba
:: �㷨����: �������½�ǰ��
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
::��һ��ǰ������
:: 2 4 6 8ʲô��,��С����
set /a x6=x+1,x4=x-1
set /a y2=y+1,y8=y-1
set w=!%map%_%x%_%y8%!-%x%-%y8%-s-!vis_%x%_%y8%!
set s=!%map%_%x%_%y2%!-%x%-%y2%-w-!vis_%x%_%y2%!
set a=!%map%_%x4%_%y%!-%x4%-%y%-d-!vis_%x4%_%y%!
set d=!%map%_%x6%_%y%!-%x6%-%y%-a-!vis_%x6%_%y%!

::ɸѡ����
::�ĸ��������Զ,������ѡ�ĸ�����
set /a dx=end_x-x,dy=end_y-y
set list= s d a w
if %dx% geq %dy% set list= d s a w

::��ǽ�϶�������
for %%i in (%list%) do (
    for /f "delims=-" %%1 in ("!%%i!") do (
        if "%%1"=="0" set list=!list: %%i=!
    )
)
::��ʣһ������?
if "%list:~1,1%"=="%list:~-1%" goto :eof

::���ų���ʱ��·
set list=!list: %ori%=!
if "%list:~1,1%"=="%list:~-1%" goto :eof

::����һ����û��û�߹���·,����ط�����for /f,��Ϊ�Ҹо�"���л�"Ӧ�ò���һ��·����10��...
set _list=%list%
for %%i in (%list%) do (
    if not "!%%i:~-1!"=="0" set list=!list: %%i=!
)
if not "%list%"=="" goto :eof

::���ȫ���߹���,ѡ�߹��Ĵ����ٵ�·
::FIXME: �����Ǹ�������������·,�������ƻ�����,ʣ��һ�����ǶԵ� ?? ���񲻻ᱻ�ӵ�...
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