@echo off
rem --- 
rem ---  Generate vmd by aligning various trace data from video data
rem --- 
cls
call activate mmdmat
if not %ERRORLEVEL% == 0 (
    exit /b 1
)

rem -----------------------------------
rem Directory path to various source code (relative or absolute)
rem -----------------------------------
rem --- tf-pose-estimation
set TFPOSE_DIR=..\tf-pose-estimation
rem --- 3d-pose-baseline-vmd
set BASELINE_DIR=..\3d-pose-baseline-vmd
rem -- 3dpose_gan_vmd
set GAN_DIR=..\3dpose_gan_vmd
rem -- FCRN-DepthPrediction-vmd
set DEPTH_DIR=..\FCRN-DepthPrediction-vmd
rem -- VMD-3d-pose-baseline-multi
set VMD_DIR=..\VMD-3d-pose-baseline-multi

rem -- tf-pose-estimation execute
cd /d %~dp0
call BulkTfpose_en.bat
if not %ERRORLEVEL% == 0 (
    exit /b 1
)

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%

cd /d %~dp0

rem -----------------------------------
rem --- Generate subdirectory by index from JSON output directory
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

rem -- Execution date
set DT=%date%
rem -- Execution time
set TM=%time%
rem -- Replace time space with 0
set TM2=%TM: =0%
rem -- Replace execution date and time for file name
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

rem -- run FCRN-DepthPrediction-vmd
call BulkDepth.bat
if not %ERRORLEVEL% == 0 (
    exit /b 1
)

rem -- Turn the loop for the number of capture people
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
    set IDX=%%i
    
    rem -- run 3d-pose-baseline
    call Bulk3dPoseBaseline.bat
    if not %ERRORLEVEL% == 0 (
        exit /b 1
    )

    rem -- run 3dpose_gan
    rem call Bulk3dPoseGan.bat

    rem -- run VMD-3d-pose-baseline-multi
    call BulkVmd_en.bat
    if not %ERRORLEVEL% == 0 (
        exit /b 1
    )
)

echo ------------------------------------------
echo Trace result
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------


rem -- Return to the current directory
cd /d %~dp0
