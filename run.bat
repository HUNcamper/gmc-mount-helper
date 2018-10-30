@echo off
setlocal EnableDelayedExpansion
cls

ECHO.
ECHO ========================================
ECHO Garry's Mod Classic project mount helper
ECHO ========================================
ECHO.

REM Look for full Steam path
SET STEAMPATH=null
FOR /F "tokens=1,2*" %%E IN ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam"') DO IF %%E EQU SteamPath SET STEAMPATH=%%G

SET STEAMPATH2=!STEAMPATH!

IF "!STEAMPATH!" EQU "null" (
	ECHO Couldn't find SteamPath in registry. Please enter the directory where Steam.exe is located ^(example: D:\Steam^)
	GOTO STEAMPATH_SET
) ELSE (
	GOTO STEAMPATH_FOUND
)


:STEAMPATH_SET
SET /P STEAMPATH="Steam.exe location: "
IF EXIST "!STEAMPATH!\Steam.exe" (
	ECHO Steam.exe found
	SET STEAMPATH2=!STEAMPATH!
) ELSE (
	ECHO Steam.exe not found. Please enter the path without the file name ^(example: D:\Steam^)
	SET STEAMPATH=null
	SET STEAMPATH2=null
	GOTO STEAMPATH_SET
)

:STEAMPATH_FOUND

ECHO.
ECHO Location of Garry's Mod Classic: %STEAMPATH%\steamapps\sourcemods\garrysmod\
ECHO Location of mountable games: %STEAMPATH2%\steamapps\common\
ECHO.
SET /P CHOICE="Are your mountable games stored somewhere else? (eg. a different drive) (Y/[N]) "

IF /I "!CHOICE!" NEQ "Y" IF /I "!CHOICE!" NEQ "y" (GOTO GAMESCAN)
ECHO Enter the path where 'steamapps' is located in (example: H:\Games\Steam) (type N to cancel)

:STEAMPATH2_SET
SET /P STEAMPATH2="steamapps location: "
IF /I "!STEAMPATH2!" EQU "N" IF /I "!STEAMPATH2!" EQU "n" GOTO STEAMPATH_FOUND
IF EXIST "!STEAMPATH2!\steamapps\common\" (
	ECHO Common folder found, folder is correct.
) ELSE (
	ECHO Common folder not found, folder is incorrect. Please enter the path where steamapps is located in, but don't include it in the path. ^(example: H:\Games\Steam, incorrect: H:\Games\Steam\steamapps\^)
	SET STEAMPATH2=null
	GOTO STEAMPATH2_SET
)

ECHO.

:GAMESCAN

ECHO Scanning for games...
TITLE Scanning for games...

SET FOUNDGAME=N

FOR /F "usebackq tokens=*" %%d IN (`DIR "%STEAMPATH2%/steamapps/common/" /B /A:D /O:N`) DO (
	
	REM Counter-Strike: Source
	IF "%%~nxd"=="Counter-Strike Source" (
		SET FOUNDGAME=Y
		SET /p CHOICE=" Do you want to mount Counter-Strike: Source? (Y/[N]) "

		IF /I "!CHOICE!" EQU "Y" IF /I "!CHOICE!" EQU "y" (
			ECHO Mounting Counter-Strike: Source...
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike"
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/maps" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/maps"

			TITLE 1/5 Extracting CS:S models
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/cstrike_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" -e "root/models" -o
			TITLE 2/5 Extracting CS:S materials
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/cstrike_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" -e "root/materials/" -o
			TITLE 3/5 Extracting CS:S sounds
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/cstrike_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" -e "root/sound/" -o
			TITLE 4/5 Extracting CS:S scripts
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/cstrike_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" -e "root/scripts/" -o
			ECHO.
			TITLE 5/5 Extracting CS:S maps
			ECHO Extracting maps...
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/cstrike_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" -e "root/maps/" -o
			ROBOCOPY "%STEAMPATH2%/steamapps/common/%%~nxd/cstrike/maps/" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/maps/" /E

			ECHO Adding extras...
			ROBOCOPY "./extras/cstrike/" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/" /E

			ECHO.

			ECHO Done extracting, creating info.txt...

			(
				ECHO "AddonInfo"
				ECHO {
				ECHO 	"name"	"Counter-Strike: Source content"
				ECHO 	"version"	"1.0"
				ECHO 	"author_name"	"Valve"
				ECHO 	"info"	"Content for Counter-Strike: Source"
				ECHO }
			) > "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_counter-strike/info.txt"

			ECHO SUCCESSFULLY MOUNTED COUNTER-STRIKE: SOURCE.
		)
	)

	REM Half-Life 2: Episode One
	IF "%%~nxd"=="Half-Life 2" IF EXIST "%STEAMPATH2%/steamapps/common/%%~nxd/episodic" (
		SET FOUNDGAME=Y
		SET /p CHOICE=" Do you want to mount Half-Life 2: Episode One? (Y/[N]) "

		IF /I "!CHOICE!" EQU "Y" IF /I "!CHOICE!" EQU "y" (
			ECHO Mounting Half-Life 2: Episode One...
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one"
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/maps" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/maps"

			TITLE 1/5 Extracting EP1 models
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/ep1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/" -e "root/models" -o
			TITLE 2/5 Extracting EP1 materials
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/ep1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/" -e "root/materials/" -o
			TITLE 3/5 Extracting EP1 sounds
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/ep1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/" -e "root/sound/" -o
			TITLE 4/5 Extracting EP1 scripts
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/ep1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/" -e "root/scripts/" -o
			ECHO.
			TITLE 5/5 Extracting EP1 maps
			ECHO Extracting maps...
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/ep1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/" -e "root/maps/" -o
			ROBOCOPY "%STEAMPATH2%/steamapps/common/%%~nxd/episodic/maps/" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/maps/" /E

			ECHO.

			ECHO Done extracting, creating info.txt...

			(
				ECHO "AddonInfo"
				ECHO {
				ECHO 	"name"	"Half-Life 2: Episode One content"
				ECHO 	"version"	"1.0"
				ECHO 	"author_name"	"Valve"
				ECHO 	"info"	"Content for Half-Life 2: Episode One"
				ECHO }
			) > "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_one/info.txt"

			ECHO SUCCESSFULLY MOUNTED HALF-LIFE 2: EPISODE ONE.
		)
	)

	REM Half-Life 2: Episode Two
	IF "%%~nxd"=="Half-Life 2" IF EXIST "%STEAMPATH2%/steamapps/common/%%~nxd/ep2" (
		SET FOUNDGAME=Y
		SET /p CHOICE=" Do you want to mount Half-Life 2: Episode Two? (Y/[N]) "

		IF /I "!CHOICE!" EQU "Y" IF /I "!CHOICE!" EQU "y" (
			ECHO Mounting Half-Life 2: Episode Two...
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two"
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/maps" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/maps"

			TITLE 1/5 Extracting EP2 models
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/ep2_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/" -e "root/models" -o
			TITLE 2/5 Extracting EP2 materials
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/ep2_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/" -e "root/materials/" -o
			TITLE 3/5 Extracting EP2 sounds
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/ep2_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/" -e "root/sound/" -o
			TITLE 4/5 Extracting EP2 scripts
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/ep2_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/" -e "root/scripts/" -o
			ECHO.
			TITLE 5/5 Extracting EP2 maps
			ECHO Extracting maps...
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/ep2_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/" -e "root/maps/" -o
			ROBOCOPY "%STEAMPATH2%/steamapps/common/%%~nxd/ep2/maps/" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/maps/" /E

			ECHO.

			ECHO Done extracting, creating info.txt...

			(
				ECHO "AddonInfo"
				ECHO {
				ECHO 	"name"	"Half-Life 2: Episode Two content"
				ECHO 	"version"	"1.0"
				ECHO 	"author_name"	"Valve"
				ECHO 	"info"	"Content for Half-Life 2: Episode Two"
				ECHO }
			) > "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_episode_two/info.txt"

			ECHO SUCCESSFULLY MOUNTED HALF-LIFE 2: EPISODE TWO.
		)
	)

	REM Half-Life: Source
	IF "%%~nxd"=="Half-Life 2" IF EXIST "%STEAMPATH2%/steamapps/common/%%~nxd/hl1" (
		SET FOUNDGAME=Y
		SET /p CHOICE=" Do you want to mount Half-Life: Source? (Y/[N]) "

		IF /I "!CHOICE!" EQU "Y" IF /I "!CHOICE!" EQU "y" (
			ECHO Mounting Half-Life: Source
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source"
			IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/maps" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source"

			TITLE 1/5 Extracting HL:S models
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/hl1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/" -e "root/models" -o
			TITLE 2/5 Extracting HL:S materials
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/hl1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/" -e "root/materials/" -o
			TITLE 3/5 Extracting HL:S sounds
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/hl1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/" -e "root/sound/" -o
			TITLE 4/5 Extracting HL:S scripts
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/hl1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/" -e "root/scripts/" -o
			ECHO.
			TITLE 5/5 Extracting HL:S maps
			ECHO Extracting maps...
			HLExtract -p "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/hl1_pak_dir.vpk" -d "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/" -e "root/maps/" -o
			ROBOCOPY "%STEAMPATH2%/steamapps/common/%%~nxd/hl1/maps/" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/maps/" /E

			ECHO.

			ECHO Done extracting, creating info.txt...

			(
				ECHO "AddonInfo"
				ECHO {
				ECHO 	"name"	"Half-Life: Source content"
				ECHO 	"version"	"1.0"
				ECHO 	"author_name"	"Valve"
				ECHO 	"info"	"Content for Half-Life: Source"
				ECHO }
			) > "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_half-life_source/info.txt"

			ECHO SUCCESSFULLY MOUNTED HALF-LIFE: SOURCE.
		)
	)
)

IF /I "!FOUNDGAME!" EQU "N" (
	ECHO No games found. Please make sure you've entered the right paths.
	GOTO END
)

SET /p CHOICE="Do you want to install scene files? (good for npc scene tool and Single Player maps) (Y/[N]) "
IF /I "!CHOICE!" NEQ "Y" IF /I "!CHOICE!" NEQ "y" (GOTO END)

SET SCENES_HL2= 
SET SCENES_EP1= 
SET SCENES_EP2= 
SET SCENES_LCO= 

:SCENE_CHOICE
TITLE Scene selection
cls

ECHO.
ECHO ======================================================
ECHO Select your option:
ECHO [!SCENES_HL2!] 1. Half-Life 2 scenes only
ECHO [!SCENES_EP1!] 2. Half-Life 2: Episode One scenes
ECHO [!SCENES_EP2!] 3. Half-Life 2: Episode Two scenes
ECHO [!SCENES_LCO!] 4. Half-Life 2: Lost Coast scenes
ECHO     5. EXTRACT SELECTED
ECHO     6. CANCEL
ECHO ======================================================
SET /P CHOICE="Choice: "

IF NOT EXIST "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes" MKDIR "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes"

IF /I "!CHOICE!" EQU "1" (
	IF /I "!SCENES_HL2!" EQU "Y" (SET SCENES_HL2= ) ELSE (SET SCENES_HL2=Y)
)
IF /I "!CHOICE!" EQU "2" (
	IF /I "!SCENES_EP1!" EQU "Y" (SET SCENES_EP1= ) ELSE (SET SCENES_EP1=Y)
)
IF /I "!CHOICE!" EQU "3" (
	IF /I "!SCENES_EP2!" EQU "Y" (SET SCENES_EP2= ) ELSE (SET SCENES_EP2=Y)
)
IF /I "!CHOICE!" EQU "4" (
	IF /I "!SCENES_LCO!" EQU "Y" (SET SCENES_LCO= ) ELSE (SET SCENES_LCO=Y)
)
IF /I "!CHOICE!" EQU "5" (GOTO SCENE_DONE)
IF /I "!CHOICE!" EQU "6" (GOTO END)
GOTO SCENE_CHOICE

:SCENE_DONE
IF "!SCENES_HL2!" EQU "N" (IF "!SCENES_EP1!" EQU "N" (IF "!SCENES_EP2!" EQU "N" (IF "!SCENES_LCO!" EQU "N" GOTO END_NOSCENE)))

IF /I "!SCENES_HL2!" EQU "Y" (
	TITLE Extracting HL2 scenes...
	ROBOCOPY "./extras/scenes/hl2" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes/" /E
)
IF /I "!SCENES_EP1!" EQU "Y" (
	TITLE Extracting EP1 scenes...
	ROBOCOPY "./extras/scenes/ep1" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes/" /E
)
IF /I "!SCENES_EP2!" EQU "Y" (
	TITLE Extracting EP2 scenes...
	ROBOCOPY "./extras/scenes/ep2" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes/" /E
)
IF /I "!SCENES_LCO!" EQU "Y" (
	TITLE Extracting Lost Coast scenes...
	ROBOCOPY "./extras/scenes/lco" "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/scenes/" /E
)

(
	ECHO "AddonInfo"
	ECHO {
	ECHO 	"name"	"Half-Life 2 Scenes"
	ECHO 	"version"	"1.0"
	ECHO 	"author_name"	"Valve"
	ECHO 	"info"	"Scenes for Half-Life 2"
	ECHO }
) > "%STEAMPATH%/steamapps/sourcemods/garrysmod/addons/mount_scenes/info.txt"

ECHO SUCCESSFULLY COPIED SCENE FILES.
GOTO END

:ERROR
ECHO An error has occurred. The script will terminate.
GOTO END

:END_NOSCENE
ECHO No scenes were selected.

:END
TITLE Done.
pause
endlocal