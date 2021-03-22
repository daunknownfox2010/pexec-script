@ECHO OFF
@REM -= PELE Launcher by Jai the Fox =-
@REM -== Version v1.0 ==-

@REM -- Shorten the current directory path, storing the long and short working directories in variables
SET "PELE_EXECUTABLE_LWDIR=%CD%"
FOR %%P IN ("%CD%") DO CD /D "%%~fsP"
SET "PELE_EXECUTABLE_WDIR=%CD%"

@REM -- Go to the initial step and begin launching
GOTO STEP_INIT


@REM -- [FUNCTION]

@REM -- Display an error message with the first parameter as a reason
:FUNC_ERROR
COLOR 0C
CLS
ECHO An error occurred, the script has aborted ^^! 
ECHO Reason: %~1 
ECHO(
PAUSE
EXIT /B 1

@REM -- Reads RL files and runs the listed lines
:FUNC_READRL
IF NOT EXIST "%~fs1" (
    CALL :FUNC_ERROR "Specified run list is not a valid file."
    EXIT /B 1
)
CD /D "%PELE_TEMPDIR_EXEC%"
FOR /F "usebackq tokens=*" %%L IN ("%~fs1") DO (
    FOR /F "usebackq tokens=1* delims=?" %%A IN ('%%~L') DO (
        IF /I %%~A==^$EchoMsg (
            ECHO ^[RL^] %%~B 
        )
        IF /I %%~A==^$Pause (
            ECHO ^[RL^] Press any key to continue . . . 
            PAUSE >NUL
        )
        IF /I %%~A==^$CreateFile (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                ECHO ^[RL^] Creating "!PELE_RUNLIST_TARGETDIR!" with contents: '%%~C' 
                ECHO %%~C>"!PELE_RUNLIST_TARGETDIR!"
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$AppendFile (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                ECHO ^[RL^] Appending "!PELE_RUNLIST_TARGETDIR!" with contents: '%%~C' 
                ECHO %%~C>>"!PELE_RUNLIST_TARGETDIR!"
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$CopyFile (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                    SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                    ECHO ^[RL^] Copying "!PELE_RUNLIST_TARGETDIR1!" to: "!PELE_RUNLIST_TARGETDIR2!" 
                    COPY /V /Y "!PELE_RUNLIST_TARGETDIR1!" "!PELE_RUNLIST_TARGETDIR2!" 2>&1 >NUL
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$MakeDir (
            FOR /F "usebackq tokens=1* delims=>" %%C IN ('%%~B') DO (
                SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~D"
                IF /I %%~C==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~D"
                IF /I %%~C==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~D"
            )
            IF NOT EXIST "!PELE_RUNLIST_TARGETDIR!" (
                ECHO ^[RL^] Creating directory: "!PELE_RUNLIST_TARGETDIR!" 
                MKDIR "!PELE_RUNLIST_TARGETDIR!"
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$MovePath (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                    SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                    ECHO ^[RL^] Moving "!PELE_RUNLIST_TARGETDIR1!" to: "!PELE_RUNLIST_TARGETDIR2!" 
                    MOVE /Y "!PELE_RUNLIST_TARGETDIR1!" "!PELE_RUNLIST_TARGETDIR2!" 2>&1 >NUL
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$RemovePath (
            FOR /F "usebackq tokens=1* delims=>" %%C IN ('%%~B') DO (
                SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~D"
                IF /I %%~C==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~D"
                IF /I %%~C==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~D"
            )
            IF EXIST "!PELE_RUNLIST_TARGETDIR!" (
                ECHO ^[RL^] Removing: "!PELE_RUNLIST_TARGETDIR!" 
                DEL /F /Q "!PELE_RUNLIST_TARGETDIR!" 2>&1 >NUL
                IF EXIST "!PELE_RUNLIST_TARGETDIR!" RMDIR /S /Q "!PELE_RUNLIST_TARGETDIR!" 2>&1 >NUL
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$SymbolicLink (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                    SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                    ECHO ^[RL^] Linking "!PELE_RUNLIST_TARGETDIR2!" to: "!PELE_RUNLIST_TARGETDIR1!" 
                    MKLINK "!PELE_RUNLIST_TARGETDIR2!" "!PELE_RUNLIST_TARGETDIR1!"
                    IF ERRORLEVEL 1 (
                        @REM -- Fallback
                        MOVE /Y "!PELE_RUNLIST_TARGETDIR1!" "!PELE_RUNLIST_TARGETDIR2!" 2>&1 >NUL
                    )
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$JunctionLink (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                    SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                    ECHO ^[RL^] Linking "!PELE_RUNLIST_TARGETDIR2!" to: "!PELE_RUNLIST_TARGETDIR1!" 
                    MKLINK /J "!PELE_RUNLIST_TARGETDIR2!" "!PELE_RUNLIST_TARGETDIR1!"
                    IF ERRORLEVEL 1 (
                        @REM -- Fallback
                        MOVE /Y "!PELE_RUNLIST_TARGETDIR1!" "!PELE_RUNLIST_TARGETDIR2!" 2>&1 >NUL
                    )
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$FileAttribute (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR!" (
                    ECHO ^[RL^] Setting attribute on "!PELE_RUNLIST_TARGETDIR!": '%%~C' 
                    ATTRIB %%~C "!PELE_RUNLIST_TARGETDIR!" 2>&1 >NUL
                )
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$ExtractTAR (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                    SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                    ECHO ^[RL^] Extracting "!PELE_RUNLIST_TARGETDIR1!" to: "!PELE_RUNLIST_TARGETDIR2!" 
                    TAR -xf "!PELE_RUNLIST_TARGETDIR1!" -C "!PELE_RUNLIST_TARGETDIR2!" 2>&1 >NUL
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$URLExtractTAR (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                ECHO ^[RL^] Extracting '%%~C' to: "!PELE_RUNLIST_TARGETDIR!" 
                CURL -sqL "%%~C" | TAR -xf - -C "!PELE_RUNLIST_TARGETDIR!" 2>&1 >NUL
                IF ERRORLEVEL 1 (
                    CALL :FUNC_ERROR "CURL failed to download the file."
                    EXIT /B 1
                )
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$Extract7ZA (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                IF EXIST "%PELE_TEMPDIR_EXEC%\7za.exe" (
                    FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                        SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                        IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                        IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                    )
                    FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                        SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                        IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                        IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                    )
                    IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                        ECHO ^[RL^] Extracting "!PELE_RUNLIST_TARGETDIR1!" to: "!PELE_RUNLIST_TARGETDIR2!" 
                        "%PELE_TEMPDIR_EXEC%\7za.exe" x "-o!PELE_RUNLIST_TARGETDIR2!" "!PELE_RUNLIST_TARGETDIR1!"
                    )
                ) ELSE (
                    ECHO ^[RL^] Could not find "7za.exe" ^^! 
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$DecompressZSTD (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                IF EXIST "%PELE_TEMPDIR_EXEC%\zstd.exe" (
                    FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~C') DO (
                        SET "PELE_RUNLIST_TARGETDIR1=%PELE_TEMPDIR_EXEC%\%%~F"
                        IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_WDIR%\%%~F"
                        IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR1=%PELE_EXECUTABLE_DIR%\%%~F"
                    )
                    FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                        SET "PELE_RUNLIST_TARGETDIR2=%PELE_TEMPDIR_EXEC%\%%~F"
                        IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_WDIR%\%%~F"
                        IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR2=%PELE_EXECUTABLE_DIR%\%%~F"
                    )
                    IF EXIST "!PELE_RUNLIST_TARGETDIR1!" (
                        ECHO ^[RL^] Decompressing "!PELE_RUNLIST_TARGETDIR1!" to: "!PELE_RUNLIST_TARGETDIR2!" 
                        "%PELE_TEMPDIR_EXEC%\zstd.exe" -d "!PELE_RUNLIST_TARGETDIR1!" -o "!PELE_RUNLIST_TARGETDIR2!"
                    )
                ) ELSE (
                    ECHO ^[RL^] Could not find "zstd.exe" ^^! 
                )
            )
            SET "PELE_RUNLIST_TARGETDIR1="
            SET "PELE_RUNLIST_TARGETDIR2="
        )
        IF /I %%~A==^$DownloadFile (
            FOR /F "usebackq tokens=1* delims=|" %%C IN ('%%~B') DO (
                FOR /F "usebackq tokens=1* delims=>" %%E IN ('%%~D') DO (
                    SET "PELE_RUNLIST_TARGETDIR=%PELE_TEMPDIR_EXEC%\%%~F"
                    IF /I %%~E==WDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_WDIR%\%%~F"
                    IF /I %%~E==EDIR SET "PELE_RUNLIST_TARGETDIR=%PELE_EXECUTABLE_DIR%\%%~F"
                )
                ECHO ^[RL^] Downloading '%%~C' to: "!PELE_RUNLIST_TARGETDIR!" 
                CURL -sqL "%%~C" -o "!PELE_RUNLIST_TARGETDIR!" 2>&1 >NUL
                IF ERRORLEVEL 1 (
                    CALL :FUNC_ERROR "CURL failed to download the file."
                    EXIT /B 1
                )
            )
            SET "PELE_RUNLIST_TARGETDIR="
        )
        IF /I %%~A==^$ExecuteCmd (
            IF DEFINED PELE_RUNLIST_EXECCMD (
                CMD /C "%%~B"
            )
        )
    )
)
CD /D "%PELE_EXECUTABLE_WDIR%"
EXIT /B 0


@REM -- [STEP]

@REM -- Script initialisation
:STEP_INIT
COLOR 0F
CLS
ECHO ^[INIT^] Working directory: "%PELE_EXECUTABLE_WDIR%" 
VERIFY OTHER 2>NUL
ECHO ^[INIT^] Initialising 'Command Extensions' . . . 
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 (
    COLOR 04
    CLS
    ECHO CRITICAL! 'Command Extensions' failed to initialise. 
    PAUSE
    GOTO EOF
)
ECHO ^[INIT^] Initialised 'Command Extensions' ! 
ECHO ^[INIT^] CMDEXT Version: ^{%CMDEXTVERSION%^} 
ECHO ^[INIT^] Initialising 'Delayed Variable Expansion' . . . 
SETLOCAL ENABLEDELAYEDEXPANSION
IF ERRORLEVEL 1 (
    CALL :FUNC_ERROR "'Delayed Variable Expansion' failed to initialise."
    GOTO EOF
)
ECHO ^[INIT^] Initialised 'Delayed Variable Expansion' ^^! 
ECHO ^[INIT^] Checking system components . . . 
IF EXIST "%SystemRoot%\System32\tar.exe" (
    ECHO ^[INIT^] Found "%SystemRoot%\System32\tar.exe" ^^! 
) ELSE (
    CALL :FUNC_ERROR "Tape Archive (tar.exe) not found in System32."
    GOTO EOF
)
IF EXIST "%SystemRoot%\System32\curl.exe" (
    ECHO ^[INIT^] Found "%SystemRoot%\System32\curl.exe" ^^! 
) ELSE (
    CALL :FUNC_ERROR "Client URL (curl.exe) not found in System32."
    GOTO EOF
)
ECHO ^[INIT^] Checking parameter %%1 . . . 
IF EXIST "%~fs1" (
    ECHO ^[INIT^] Valid parameter %%1^: "%~1" 
) ELSE (
    CALL :FUNC_ERROR "Parameter field %%%%1 does not contain a valid file/directory."
    GOTO EOF
)
SET "PELE_EXECUTABLE_DIR=%~dps1"
ECHO ^[INIT^] Executable directory: "%PELE_EXECUTABLE_DIR%" 
GOTO STEP_TEMPDIR

@REM -- Script temporary directory initialisation
:STEP_TEMPDIR
ECHO ^[TEMP^] Temporary directory: "%TEMP%" 
IF DEFINED PELE_TEMPDIR_ROOT (
    IF DEFINED PELE_TEMPDIR_EXEC (
        IF EXIST "%PELE_TEMPDIR_ROOT%" (
            IF EXIST "%PELE_TEMPDIR_EXEC%" (
                ECHO ^[TEMP^] Temporary directories are present, skipping step . . . 
                GOTO STEP_CONFIG
            )
        )
    )
)
SET "PELE_TEMPDIR_ROOT=%TEMP%\PELE.%RANDOM%_%RANDOM%"
SET "PELE_TEMPDIR_EXEC=!PELE_TEMPDIR_ROOT!\EXEC"
ECHO ^[TEMP^] Creating directory: "%PELE_TEMPDIR_ROOT%" 
IF EXIST "%PELE_TEMPDIR_ROOT%" (
    ECHO ^[TEMP^] Retrying directory creation . . . 
    GOTO STEP_TEMPDIR
)
ECHO ^[TEMP^] Creating directory: "%PELE_TEMPDIR_EXEC%" 
MKDIR "!PELE_TEMPDIR_ROOT!" "!PELE_TEMPDIR_EXEC!"
IF NOT EXIST "%PELE_TEMPDIR_ROOT%" (
    CALL :FUNC_ERROR "Failed to create temporary directories."
    GOTO EOF
)
IF NOT EXIST "%PELE_TEMPDIR_EXEC%" (
    CALL :FUNC_ERROR "Failed to create temporary directories."
    GOTO EOF
)
GOTO STEP_CONFIG

@REM -- Script configuration
:STEP_CONFIG
IF NOT DEFINED PELE_CONFIG_FILE (
    ECHO ^[CONFIG^] Checking for "pexec.ini" . . . 
    IF EXIST "%PELE_EXECUTABLE_DIR%\pexec.ini" (
        SET "PELE_CONFIG_FILE=%PELE_EXECUTABLE_DIR%\pexec.ini"
        ECHO ^[CONFIG^] Found "!PELE_CONFIG_FILE!" ^^! 
    )
    IF NOT DEFINED PELE_CONFIG_FILE (
        ECHO ^[CONFIG^] Configuration file not set, skipping step . . . 
        GOTO STEP_VARIABLES
    )
)
IF NOT EXIST "%PELE_CONFIG_FILE%" (
    ECHO ^[CONFIG^] Configuration file not found, skipping step . . . 
    GOTO STEP_VARIABLES
)
ECHO ^[CONFIG^] Configuration file: "%PELE_CONFIG_FILE%" 
ECHO ^[CONFIG^] Reading configuration . . . 
FOR /F "usebackq tokens=*" %%L IN ("%PELE_CONFIG_FILE%") DO (
    FOR /F "usebackq tokens=1* delims==" %%A IN ('%%~L') DO (
        IF /I %%~A==^@sConfigFileURL (
            SET "PELE_CONFIG_FILE_URL=%%~B"
            ECHO ^[CONFIG^] Configuration file URL: '!PELE_CONFIG_FILE_URL!' 
        )
        IF /I %%~A==^@sExecutableName (
            SET "PELE_EXECUTABLE_NAME=%%~B"
            ECHO ^[CONFIG^] Executable name: '!PELE_EXECUTABLE_NAME!' 
        )
        IF /I %%~A==^@pOverrideExecutableDir (
            IF NOT EXIST "%%~fsB" (
                CALL :FUNC_ERROR "@pOverrideExecutableDir does not contain a valid directory."
                GOTO EOF
            )
            SET "PELE_EXECUTABLE_DIR=%%~fsB"
            ECHO ^[CONFIG^] Executable directory: "!PELE_EXECUTABLE_DIR!" 
        )
        IF /I %%~A==^@sEnvironmentVars (
            SET "PELE_ENVIRONMENT_VARS=%%~B"
            ECHO ^[CONFIG^] Environment variables: '!PELE_ENVIRONMENT_VARS!' 
        )
        IF /I %%~A==^@pStartRunListFile (
            IF NOT EXIST "%%~fsB" (
                CALL :FUNC_ERROR "@pStartRunListFile does not contain a valid file."
                GOTO EOF
            )
            SET "PELE_RUNLIST_STARTFILE=%%~fsB"
            ECHO ^[CONFIG^] Start run list: "!PELE_RUNLIST_STARTFILE!" 
        )
        IF /I %%~A==^@pEndRunListFile (
            IF NOT EXIST "%%~fsB" (
                CALL :FUNC_ERROR "@pEndRunListFile does not contain a valid file."
                GOTO EOF
            )
            SET "PELE_RUNLIST_ENDFILE=%%~fsB"
            ECHO ^[CONFIG^] End run list: "!PELE_RUNLIST_ENDFILE!" 
        )
        IF /I %%~A==^@sStartRunListURL (
            ECHO ^[CONFIG^] Downloading start run list '%%~B' . . . 
            CURL -sqL "%%~B" -o "%PELE_TEMPDIR_ROOT%\RL_START.DAT" 2>&1 >NUL
            IF ERRORLEVEL 1 (
                CALL :FUNC_ERROR "CURL failed to download the run list."
                GOTO EOF
            )
            IF NOT EXIST "%PELE_TEMPDIR_ROOT%\RL_START.DAT" (
                CALL :FUNC_ERROR "CURL failed to download the run list."
                GOTO EOF
            )
            ECHO ^[CONFIG^] Successfully downloaded the start run list ^^! 
            SET "PELE_RUNLIST_STARTFILE=%PELE_TEMPDIR_ROOT%\RL_START.DAT"
            ECHO ^[CONFIG^] Start run list: "!PELE_RUNLIST_STARTFILE!" 
        )
        IF /I %%~A==^@sEndRunListURL (
            ECHO ^[CONFIG^] Downloading end run list '%%~B' . . . 
            CURL -sqL "%%~B" -o "%PELE_TEMPDIR_ROOT%\RL_END.DAT" 2>&1 >NUL
            IF ERRORLEVEL 1 (
                CALL :FUNC_ERROR "CURL failed to download the run list."
                GOTO EOF
            )
            IF NOT EXIST "%PELE_TEMPDIR_ROOT%\RL_END.DAT" (
                CALL :FUNC_ERROR "CURL failed to download the run list."
                GOTO EOF
            )
            ECHO ^[CONFIG^] Successfully downloaded the end run list ^^! 
            SET "PELE_RUNLIST_ENDFILE=%PELE_TEMPDIR_ROOT%\RL_END.DAT"
            ECHO ^[CONFIG^] Start run list: "!PELE_RUNLIST_ENDFILE!" 
        )
        IF /I %%~A==^@bSuppressLaunch (
            IF %%~B EQU 1 (
                SET "PELE_EXECUTABLE_SUPPRESSED=1"
                ECHO ^[CONFIG^] Program launch has been suppressed . . . 
            ) ELSE (
                SET "PELE_EXECUTABLE_SUPPRESSED="
                ECHO ^[CONFIG^] Program launch is not suppressed . . . 
            )
        )
        IF /I %%~A==^@bAllowCommandExecution (
            IF %%~B EQU 1 (
                ECHO ^[CONFIG^] The configuration file wants to enable command execution in run lists 
                SET /P "PELE_USERCHOICE=[CONFIG] Input 'Y' to allow: "
                IF /I !PELE_USERCHOICE!==y (
                    SET "PELE_RUNLIST_EXECCMD=1"
                    ECHO ^[CONFIG^] Allowing run list command execution . . . 
                ) ELSE (
                    SET "PELE_RUNLIST_EXECCMD="
                    ECHO ^[CONFIG^] Disallowing run list command execution . . . 
                )
            ) ELSE (
                SET "PELE_RUNLIST_EXECCMD="
                ECHO ^[CONFIG^] Disallowing run list command execution . . . 
            )
        )
    )
)
IF DEFINED PELE_CONFIG_FILE_URL (
    ECHO ^[CONFIG^] Preparing to download new configuration file . . . 
    TIMEOUT /T 1 /NOBREAK 2>&1 >NUL
    COLOR
    CLS
    ECHO Downloading new configuration file . . . 
    ECHO(
    CURL -qL "%PELE_CONFIG_FILE_URL%" -o "%PELE_TEMPDIR_ROOT%\PEXEC.INI"
    IF ERRORLEVEL 1 (
        CALL :FUNC_ERROR "CURL failed to download the configuration file."
        GOTO EOF
    )
    ECHO(
    ECHO(
    ECHO Restarting initialisation step . . . 
    SET "PELE_CONFIG_FILE=%PELE_TEMPDIR_ROOT%\PEXEC.INI"
    SET "PELE_CONFIG_FILE_URL="
    TIMEOUT /T 1 /NOBREAK 2>&1 >NUL
    GOTO STEP_INIT
)
IF DEFINED PELE_ENVIRONMENT_VARS (
    ECHO ^[CONFIG^] Setting environment variables . . . 
    FOR %%V IN ("%PELE_ENVIRONMENT_VARS:,=" "%") DO (
        FOR /F "usebackq tokens=1* delims=:" %%A IN ('%%~V') DO (
            SET "%%~A=%%~B"
        )
    )
)
SET "PELE_ENVIRONMENT_VARS="
GOTO STEP_VARIABLES

@REM -- Script environment variables
:STEP_VARIABLES
ECHO ^[VARS^] Validating script variables . . . 
IF NOT DEFINED PELE_EXECUTABLE_NAME SET "PELE_EXECUTABLE_NAME=%~n1"
ECHO ^[VARS^] Executable name: '%PELE_EXECUTABLE_NAME%' 
IF NOT DEFINED PELE_EXECUTABLE_DIR (
    CALL :FUNC_ERROR "%%%%PELE_EXECUTABLE_DIR%%%% is not defined."
    GOTO EOF
)
IF NOT EXIST "%PELE_EXECUTABLE_DIR%" (
    CALL :FUNC_ERROR "%%%%PELE_EXECUTABLE_DIR%%%% does not contain a valid directory."
    GOTO EOF
)
ECHO ^[VARS^] Executable directory: "%PELE_EXECUTABLE_DIR%" 
IF NOT DEFINED PELE_TEMPDIR_ROOT (
    CALL :FUNC_ERROR "%%%%PELE_TEMPDIR_ROOT%%%% is not defined."
    GOTO EOF
)
IF NOT EXIST "%PELE_TEMPDIR_ROOT%" (
    CALL :FUNC_ERROR "%%%%PELE_TEMPDIR_ROOT%%%% does not contain a valid directory."
    GOTO EOF
)
ECHO ^[VARS^] Temporary script root directory: "%PELE_TEMPDIR_ROOT%" 
IF NOT DEFINED PELE_TEMPDIR_EXEC (
    CALL :FUNC_ERROR "%%%%PELE_TEMPDIR_EXEC%%%% is not defined."
    GOTO EOF
)
IF NOT EXIST "%PELE_TEMPDIR_EXEC%" (
    CALL :FUNC_ERROR "%%%%PELE_TEMPDIR_EXEC%%%% does not contain a valid directory."
    GOTO EOF
)
ECHO ^[VARS^] Temporary script execution directory: "%PELE_TEMPDIR_EXEC%" 
IF NOT DEFINED PELE_CONFIG_FILE (
    ECHO(>"%PELE_TEMPDIR_ROOT%\DUMMY.INI"
    SET "PELE_CONFIG_FILE=%PELE_TEMPDIR_ROOT%\DUMMY.INI"
)
IF NOT EXIST "%PELE_CONFIG_FILE%" (
    ECHO(>"%PELE_TEMPDIR_ROOT%\DUMMY.INI"
    SET "PELE_CONFIG_FILE=%PELE_TEMPDIR_ROOT%\DUMMY.INI"
)
ECHO ^[VARS^] Configuration file: "%PELE_CONFIG_FILE%" 
IF DEFINED PELE_RUNLIST_STARTFILE (
    IF NOT EXIST "%PELE_RUNLIST_STARTFILE%" (
        CALL :FUNC_ERROR "%%%%PELE_RUNLIST_STARTFILE%%%% does not contain a valid file."
        GOTO EOF
    )
    ECHO ^[VARS^] Start run list: "%PELE_RUNLIST_STARTFILE%" 
)
IF DEFINED PELE_RUNLIST_ENDFILE (
    IF NOT EXIST "%PELE_RUNLIST_ENDFILE%" (
        CALL :FUNC_ERROR "%%%%PELE_RUNLIST_ENDFILE%%%% does not contain a valid file."
        GOTO EOF
    )
    ECHO ^[VARS^] End run list: "%PELE_RUNLIST_ENDFILE%" 
)
GOTO STEP_SRL

@REM -- Script start run list
:STEP_SRL
IF NOT DEFINED PELE_RUNLIST_STARTFILE GOTO STEP_START
ECHO ^[SRL^] Running . . . 
CALL :FUNC_READRL "%PELE_RUNLIST_STARTFILE%"
IF ERRORLEVEL 1 (
    CALL :FUNC_ERROR "Executed run list ran into an error."
    GOTO EOF
)
GOTO STEP_START

@REM -- Script end run list
:STEP_ERL
IF NOT DEFINED PELE_RUNLIST_ENDFILE GOTO EOF
ECHO ^[ERL^] Running . . . 
CALL :FUNC_READRL "%PELE_RUNLIST_ENDFILE%"
IF ERRORLEVEL 1 (
    CALL :FUNC_ERROR "Executed run list ran into an error."
    GOTO EOF
)
GOTO EOF

@REM -- Script start program
:STEP_START
IF DEFINED PELE_EXECUTABLE_SUPPRESSED (
    ECHO ^[START^] Program launch was suppressed ^^! 
    ECHO ^[START^] Press any key to continue . . . 
    COLOR 8F
    PAUSE >NUL
    COLOR 0F
    ECHO ^[START^] Finishing up . . . 
    GOTO STEP_ERL
)
ECHO ^[START^] Launching '%PELE_EXECUTABLE_NAME%' . . . 
ECHO ^[START^] %* 
COLOR 8F
START "%PELE_EXECUTABLE_NAME%" /D "%PELE_EXECUTABLE_LWDIR%" /HIGH /WAIT /B %*
COLOR 0F
ECHO ^[START^] Finishing up . . . 
GOTO STEP_ERL


@REM -- [SPECIAL]

@REM -- End of file, stop the script
:EOF
IF EXIST "%PELE_TEMPDIR_ROOT%" RMDIR /S /Q "%PELE_TEMPDIR_ROOT%"
ENDLOCAL
COLOR
CLS
