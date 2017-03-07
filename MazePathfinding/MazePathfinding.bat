@echo off && setlocal enabledelayedexpansion
title MazePathfinding Ver 1.2 By blackkitty

call:init
call:LoadMaze %maze%
call:ShowMazeAt %maze% %maze_x% %maze_y%
call go %current_x% %current_y%
cc 2 2&&echo.���������ʼ...  
pause>NUL
cc 2 2&&echo.                         
cc 2 0 && echo.�㷨��%bot% ��㣺(%start_x%,%start_y%) �յ㣺(%end_x%,%end_y%) �հ׸�����%path_count%
call %bot%
call:showpath
cc 2 2&&echo.��������������˳�...
pause>NUL
exit


:LoadMaze
:: mazename
echo.���ڼ��ص�ͼ...
call .\maze\%1.bat
set map=%1
set/a _1=!%1_width!*2+6
set/a _2=!%1_height!+6
if %_1% LEQ 80 (set _1=80)
mode con: cols=%_1% lines=%_2%
set start_x=1
set start_y=1
set/a end_x=!%1_width!-1
set/a end_y=!%1_height!-1
set current_x=%start_x%
set current_y=%start_y%
::  ����ѷ��ʱ��
set vis_count=0
set path_count=0
set vis_%start_x%_%start_y%=1
for /l %%y in (0,1,!%map%_height!) do (
    for /l %%x in (0,1,!%map%_width!) do (
        set vis_%%x_%%y=0
        if "!%map%_%%x_%%y!" EQU "1" (set/a path_count+=1)
    )
)
goto:eof

:ShowMazeAt
:: mazename x y
cls
for /l %%y in (0,1,!%1_height!) do (
    set _=!%1_row_%%y!
    set _=!_:0=%_WALL%!
    set _=!_:1=%_PATH%!
    set/a _y=%%y+%3
    cc %2 !_y!
    echo.!_!
)
goto:eof

:init
:: ��ʼ��
echo.���ڳ�ʼ��...
cc
set/p _=<setting.ini
%_%
set steps=0
set timer=0
set beginTime=%time%
set _PATH=  
set _WALL=�~
set _VIS=��
set _P=��
set maze_x=2
set maze_y=3
goto:eof



:showpath
:: ��ʾ����λ��
for /l %%y in (0,1,!%map%_height!) do (
    for /l %%x in (0,1,!%map%_width!) do (
        if not "!vis_%%x_%%y!" EQU "0" (
            set/a _x=%%x*2+%maze_x% && set/a _y=%%y+%maze_y%
            cc !_x! !_y!
            set/a _=!vis_%%x_%%y!
            if !vis_%%x_%%y! GTR 99 set _=99
            echo.!_!
            )
    )
)
goto:eof
