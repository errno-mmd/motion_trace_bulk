@echo off
rem --- 
rem ---  Generate vmd by aligning various trace data from video data
rem --- 
cls
call activate mmdmat
if not %ERRORLEVEL% == 0 (
    goto die
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
rem -- mannequinchallenge-vmd
set DEPTH_DIR=..\mannequinchallenge-vmd
rem -- VMD-3d-pose-baseline-multi
set VMD_DIR=..\VMD-3d-pose-baseline-multi

rem -- tf-pose-estimation execute
cd /d %~dp0
call BulkTfpose_en.bat
if not %ERRORLEVEL% == 0 (
    goto die
)

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%

cd /d %~dp0

rem -----------------------------------
rem --- Generate subdirectory by index from JSON output directory
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

rem -- Execution date and time
for /f "usebackq" %%i in (`python -c "import datetime; print(datetime.datetime.now().strftime('%%Y%%m%%d_%%H%%M%%S'))"`) do set DTTM=%%i


rem -- run mannequinchallenge-vmd
call BulkDepth.bat
if not %ERRORLEVEL% == 0 (
    goto die
)

rem -- Turn the loop for the number of capture people
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
    set IDX=%%i
    
    rem -- run 3d-pose-baseline
    call Bulk3dPoseBaseline.bat
    if not %ERRORLEVEL% == 0 (
        goto die
    )

    rem -- run 3dpose_gan
    rem call Bulk3dPoseGan.bat

    rem -- run VMD-3d-pose-baseline-multi
    call BulkVmd_en.bat
    if not %ERRORLEVEL% == 0 (
        goto die
    )
)

echo ------------------------------------------
echo Trace result
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------


rem -- Return to the current directory
cd /d %~dp0
exit /b 0

:die
@echo ERROR
@pause -1
exit /b 1
