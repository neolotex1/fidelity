rem @echo off
set USERNAME=sa
set PASSWORD=jaqm739sf$
set DB=doQman_Fidelity
set SERVER=172.16.1.35,1433\MSSQLSERVER2019

set /p choice=Are you sure to execute scripts in database [%DB%] of server [%SERVER%] (y/n) ?

if '%choice%'=='y' goto begin
goto end

:begin

rem Checking server connection
rem ---------------------------------------------------------------------
sqlcmd /S "%SERVER%" /U "%USERNAME%" /P "%PASSWORD%" /Q "" >nul 2>&1
if ERRORLEVEL 1 (
rem exit script
  echo Filed to connect server - %SERVER%
) else (
  echo Server connection success - %SERVER%
)

rem Checking database connection
rem ---------------------------------------------------------------------
sqlcmd /S "%SERVER%" /U "%USERNAME%" /P "%PASSWORD%" /d "%DB%" /Q "" >nul 2>&1
if ERRORLEVEL 1 (
rem exit script
  echo Filed to connect database!  - %DB%
) else (
  echo Connected to database - %DB%
)

setlocal

set CurrentPath= %~dp0
set CurrentScriptPath= %CurrentPath%%%i
set CurrentFilename = %~dp0

SET SQLCMD=sqlcmd /S "%SERVER%" /U "%USERNAME%" /P "%PASSWORD%" /d "%DB%"
 
for /D %%i in (*) do (

	set CurrentScriptPath= %CurrentPath%%%i

	for %%d in (%CurrentScriptPath%\*.sql) do (

		echo executing script  - %%d
		echo FileName  - %%~nd

		%SQLCMD% -i%%d -o%%d.log

	)

)

endlocal

Pause

:end
exit