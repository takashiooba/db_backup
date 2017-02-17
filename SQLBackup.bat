REM @echo off
REM ============================================================================
REM batch-name: xxxxxx.bat
REM about: Backup database 
REM ============================================================================
REM ----------------------------------------------------------------------------
REM Settings
REM   1. line 16: [set _bkupFolder=] [target backup folder name]
REM   2. line 21: [set _generation] required amounts of backup file generations
REM   3. line 31: [copy] target file name 
REM ============================================================================

REM ==================================================================
REM Backup folder name (backup server)
REM ==================================================================
set _bkupFolder=\\[IP ADDRESS]\[folder]\

REM ==================================================================
REM Number of generations
REM ==================================================================
set _generation=14

REM ==================================================================
REM Current date
REM ==================================================================
set _presentDate=%date:~10,4%%date:~4,2%%date:~7,2%

REM ==================================================================
REM Current filename
REM ==================================================================
set _filename=[Database name]_%_presentDate%.bak

REM ==================================================================
REM Create database backup
REM ==================================================================
sqlcmd -S .\SqlExpress -Q "BACKUP DATABASE [Database name] TO DISK='[work folder]\%_filename%' WITH INIT" -U [Database user] -P [Database passwork]

REM ==================================================================
REM Copy file from work to backup server
REM ==================================================================
copy [work folder]\%_filename% %_bkupFolder%\%_filename% 

REM ==================================================================
REM Remove files exceed the reqired number
REM ==================================================================
for /f "skip=%_generation% usebackq delims=" %%a in (`dir /a-d /b /o-n %_bkupFolder%`) do ( del /q "%_bkupFolder%\%%a" )

