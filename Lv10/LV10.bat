@echo off
setlocal enabledelayedexpansion
color 1f
title LV.10 BAT ver 1.1 by blackkitty
mode con: cols=60 lines=15

:restart
call:init
call:newPiece
call:newPiece
call:state

:main
call:state_score
set/a _x=map_x+2+6*%cx%
set/a _y=map_y+1+3*%cy%
cc %_x% %_y%

:main_getkey
::等待用户输入按键
set cdic=_&&set dic=_
cc c 100
cc k
set key=%errorlevel%
:: w 119 87 s 115 83 a 97 65 d 100 68
:: up 224072 down 224080 left 224075 right 224077
:: r 114 82
if "%key%" EQU "224072" (set cdic=0)
if "%key%" EQU "224080" (set cdic=2)
if "%key%" EQU "224075" (set cdic=3)
if "%key%" EQU "224077" (set cdic=1)
if "%key%" EQU "119" (set dic=0)
if "%key%" EQU "87" (set dic=0)
if "%key%" EQU "115" (set dic=2)
if "%key%" EQU "83" (set dic=2)
if "%key%" EQU "97" (set dic=3)
if "%key%" EQU "65" (set dic=3)
if "%key%" EQU "100" (set dic=1)
if "%key%" EQU "68" (set dic=1)
if "%key%" EQU "114" (goto restart)
if "%key%" EQU "82" (goto restart)

cc
:: hammer judge
if %hammer% GTR 0 (
    if "%key%" EQU "70" (set/a hammer-=1)
    if "%key%" EQU "102" (set/a hammer-=1)
    if "!hammer!" NEQ "%hammer%" (
        :: hammer the piece
        set map_%cx%_%cy%=
        call:erasePiece %cx% %cy%
    )
)

if "%dic%" NEQ "_" (
    call:movePiece %cx% %cy% %dic% movereturn
    if "!movereturn!" EQU "0" (
        :: 若成功移动 每个棋子+1s
        for /l %%y in (0,1,%map_height%) do (
            for /l %%x in (0,1,%map_width%) do (
                if defined map_%%x_%%y (
                    set/a p!map_%%x_%%y!_lv+=1
                    set/a tmp=p!map_%%x_%%y!_lv
                    :: 若棋子达到10级
                    if "!tmp!" EQU "10" (set emptycount=0)
                    call:printPiece !map_%%x_%%y! %%x %%y
                )
            )
        )
        call:newPiece
        set cdic=%dic%
    )
)

if "%cdic%" NEQ "_" (
    :: 移动光标
    set/a _x=cx+!xx%cdic%!
    set/a _y=cy+!yy%cdic%!
    call:inMap !_x! !_y! tmp
    if !tmp! EQU 1 (
        set cx=!_x!
        set cy=!_y!
    )
)
if !emptycount! GTR 0 (goto main)
:gameover
cc 30 11&&echo.-GAME OVER-
cc k
set key=%errorlevel%
if "%key%" EQU "114" (goto restart)
if "%key%" EQU "82" (goto restart)
goto gameover
goto:eof

:init
:: 初始化程序
:: ← ↑ → ↓ ↖ ↗ ↘ ↙
:: ①②③④⑤⑥⑦⑧⑨⑩??????????
:: ○◎●⊙〇
cls&&cc
set _LVV=〇①②③④⑤⑥⑦⑧⑨⑩
::set _LVV=〇㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩
set _MAPA=●
set map_x=2
set map_y=1
set map_width=3
set map_height=3
:: U R D L
set xx0=0&&set yy0=-1
set xx1=1&&set yy1=0
set xx2=0&&set yy2=1
set xx3=-1&&set yy3=0
:: piece type 0 attack range: U R D L
set ptype0atk=0 -1 1 0 0 1 -1 0
:: piece type 0 attack range: UR DR DL UL
set ptype1atk=1 -1 1 1 -1 1 -1 -1
set _ptype0img0=  ↑  
set _ptype0img1=←#→
set _ptype0img2=  ↓  
set _ptype1img0=↖  ↗
set _ptype1img1=  #  
set _ptype1img2=↙  ↘
set newid=1
set score=0
set hammerscore=500
set hammer=1
set/a emptycount=(%map_width%+1) * (%map_height%+1)
:: 光标位置
set cx=0
set cy=0
call:printMapAt %map_x% %map_y% %map_width% %map_height%
call:clearMap
goto:eof

:state
:: 显示信息
for /l %%y in (0,1,12) do (cc 28 %%y&&echo..)
REM cc 30 1&&echo.LV.10 BAT by blackkitty
REM cc 30 3&&echo.Choose  by Arrow keys
REM cc 30 4&&echo.Move    by WSAD
REM cc 30 5&&echo.Hammer  by F
REM cc 30 6&&echo.Restart by R
cc 30 1&&echo.LV10 BAT ver 1.1
cc 30 3&&echo.Arrow  select
cc 30 4&&echo.WSAD   move
cc 30 5&&echo.F      use hammer
cc 30 6&&echo.R      restart
:state_score
if %score% GEQ %hammerscore% (
    set/a hammerscore+=500
    set/a hammer+=1
)
REM cc 30 8&&echo.SCORE : %score%
REM cc 30 9&&echo.Hammer: %hammer%
cc 30 8&&echo.Score：%score%
cc 30 9&&echo.Hammer: %hammer%
goto:eof

:clearMap
:: clear map
for /l %%y in (0,1,%map_height%) do (
    for /l %%x in (0,1,1%map_width%) do (
        set map_%%x_%%y=
    )
)
goto:eof

:inMap
:: <x> <y> [ret] 检查(x,y)是否在地图内,返回1在地图内，返回0不在地图内
    if %1 GEQ 0 ( if %1 LEQ %map_width% (
    if %2 GEQ 0 ( if %2 LEQ %map_height%  (
        set %3=1
        goto:eof
    ))))
    set %3=0
goto:eof

:printMapAt
:: <x> <y> <w> <h> 显示地图
for /l %%y in (0,1,%4) do (
    for /l %%x in (0,1,%3) do (
        set/a _x=%1+2+%%x*6
        set/a _y=%2+1+%%y*3
        cc !_x! !_y!
        echo.%_MAPA%
    )
)
goto:eof

:printPiece
:: <pieceName> <x> <y>
:: 在（x,y）显示棋子pieceName
    set/a _x0=map_x+6*%2
    set/a _y0=map_y+3*%3
    set/a _x1=map_x+6*%2
    set/a _y1=map_y+1+3*%3
    set/a _x2=map_x+6*%2
    set/a _y2=map_y+2+3*%3
    set _type=!p%1_type!
    set _img=!_ptype%_type%img1!
    set _lv=!p%1_lv!
    set _lv=!_LVV:~%_lv%,1!
    set _img=!_img:#=%_lv%!

    cc %_x0% %_y0%&&echo.!_ptype%_type%img0!
    cc %_x1% %_y1%&&echo.%_img%
    cc %_x2% %_y2%&&echo.!_ptype%_type%img2!
goto:eof

:erasePiece
:: <x> <y>
:: 清除（x,y）位置的棋子
    set/a _x0=map_x+6*%1
    set/a _y0=map_y+3*%2
    set/a _x1=map_x+6*%1
    set/a _y1=map_y+1+3*%2
    set/a _x2=map_x+6*%1
    set/a _y2=map_y+2+3*%2
    cc %_x0% %_y0%&&echo.      
    cc %_x1% %_y1%&&echo.  %_MAPA%  
    cc %_x2% %_y2%&&echo.      
goto:eof

:newPiece
:: 创建一个随机新棋子
    if !emptycount! LEQ 0 (goto:eof)
    set/a p%newid%_lv=%random%%%2+1
    set/a p%newid%_type=%random%%%2
    :newPiece_loop
    set/a _x=%random%%%(1+%map_width%)
    set/a _y=%random%%%(1+%map_height%)
    if defined map_%_x%_%_y% (goto newPiece_loop)
    call:printPiece %newid% %_x% %_y%
    set map_%_x%_%_y%=%newid%
    set/a newid+=1
    set/a emptycount-=1
goto:eof

:movePiece
:: <x> <y> <dic> [ret]
:: 位置（x,y）向dic移动，移动成功返回0 否则返回1
    set %4=1
    if not defined map_%1_%2 (goto:eof)
    set/a _x=%1+!xx%3!
    set/a _y=%2+!yy%3!
    call:inMap !_x! !_y! tmp
    if "!tmp!" EQU "0" (goto:eof)
    if defined map_%_x%_%_y% (goto:eof)
    call:erasePiece %1 %2
    call:printPiece !map_%1_%2! %_x% %_y% 
    set _id=!map_%1_%2!
    set _type=!p%_id%_type!
    set map_%_x%_%_y%=!map_%1_%2!
    set map_%1_%2=
    call:attack %_x% %_y% !ptype%_type%atk!
    set %4=0
goto:eof

:attack
:: <x> <y> <pieceTypeATKRange>
:: pieceName发动攻击
:: 增加分数 = 攻击造成伤害之和 + 消灭棋子数*10
:attack_loop
set/a _x=%1+%3
set/a _y=%2+%4
set _a=!map_%_x%_%_y%!
set _b=!map_%1_%2!
if defined map_%_x%_%_y% (
    :: 计算攻击后生命值
    set/a _lv=!p%_a%_lv!-!p%_b%_lv!
    set/a score=!score!+!p%_b%_lv!+!_lv!
    if !_lv! LEQ 0 (
        :: 生命值<=0
        call:erasePiece %_x% %_y
        set map_%_x%_%_y%=
        set/a score=!score!+10
        set/a emptycount+=1
    ) else (
        :: 生命值>=0
        set p!map_%_x%_%_y%!_lv=!_lv!
        call:printPiece !map_%_x%_%_y%! %_x% %_y%
    )
)
shift /3&&shift /3
if "%3" NEQ "" (goto attack_loop)
goto:eof