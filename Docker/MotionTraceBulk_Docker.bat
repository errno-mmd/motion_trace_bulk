@echo off
rem --- 
rem ---  映像データから各種トレースデータを揃えてvmdを生成する
rem --- 
cls

rem docker image tag
set IMAGE_TAG=1.02.01-1

rem -- Openpose 実行
call BulkOpenpose_Docker.bat

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%


rem -----------------------------------
rem --- JSON出力ディレクトリ から index別サブディレクトリ生成
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

set PARENT_DIR_FULL=%OUTPUT_JSON_DIR_PARENT:~0,-1%
FOR %%i IN (%PARENT_DIR_FULL%) DO (
    set PARENT_DIR_NAME=%%~ni
)

rem -- 実行日付
set DT=%date%
rem -- 実行時間
set TM=%time%
rem -- 時間の空白を0に置換
set TM2=%TM: =0%
rem -- 実行日時をファイル名用に置換
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

rem -- FCRN-DepthPrediction-vmd実行
call BulkDepth_Docker.bat

rem -- キャプチャ人数分ループを回す
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
    set IDX=%%i
    
    rem -- 3d-pose-baseline実行
    call Bulk3dPoseBaseline_Docker.bat
    
    rem -- 3dpose_gan実行
    rem call Bulk3dPoseGan_Docker.bat

    rem -- VMD-3d-pose-baseline-multi 実行
    call BulkVmd_Docker.bat
)

echo ------------------------------------------
echo トレース結果
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------
