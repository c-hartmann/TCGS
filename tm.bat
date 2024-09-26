echo off

set TCGSDIR=c:\tcgs
set PERLDIR=c:\Perl



rem // preset directory and filename

rem set directory="%CD%"
set directory=%CD%
set filename="index.html"

rem // first argument is a directory or not existent

echo 1="%1"
rem if not "%1"=="" set directory="%1"
set directory="%1"
cd "%directory%"

rem // create either index.html or the file name in %1

shift
if not "%1"=="" set filename="%1"
rem shift

REM DEBUG DEBUG DEBUG
echo directory=%directory%
echo currendir="%cd%"
echo filename=%filename%
REM pause
REM DEBUG DEBUG DEBUG

rem // user interface

rem @echo assembling "file %directory%\%filename% ..."
rem @echo assembling file %filename%" ...
@echo assembling "file %directory%\%filename% ..."


rem // now go for it

rem "%PERLDIR%\bin\perl.exe" "%TCGSDIR%\main.pl" > %filename%
@echo on
perl.exe "%TCGSDIR%\main.pl" > %filename%

@echo done

:end
