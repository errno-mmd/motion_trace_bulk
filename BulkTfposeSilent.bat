@echo off
rem --- 
rem ---  映像データからtf-pose-estimationで姿勢推定する
rem --- 


echo ------------------------------------------
echo tf-pose-estimation 解析
echo ------------------------------------------

rem --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

rem -----------------------------------
rem --- 入力映像パス
FOR %%1 IN (%INPUT_VIDEO%) DO (
    rem -- 入力映像パスの親ディレクトリと、ファイル名+_jsonでパス生成
    set INPUT_VIDEO_DIR=%%~dp1
    set INPUT_VIDEO_FILENAME=%%~n1
)

echo --------------

rem ------------------------------------------------
rem -- JSON出力ディレクトリ
set OUTPUT_JSON_DIR=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_json
rem -- echo %OUTPUT_JSON_DIR%

rem -- JSON出力ディレクトリ生成
mkdir %OUTPUT_JSON_DIR%
echo 解析結果JSONディレクトリ：%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- 映像出力ディレクトリ
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_tf-pose-estimation.avi
echo 解析結果aviファイル：%OUTPUT_VIDEO_PATH%

echo --------------
echo tf-pose-estimation解析を開始します。
echo 解析を中断したい場合、ESCキーを押下して下さい。
echo --------------

rem ---  tf-pose-estimationディレクトリで実行
cd /d %TFPOSE_DIR%\

rem -- exe実行
python run_video.py --video %INPUT_VIDEO%  --model mobilenet_v2_large --write_json %OUTPUT_JSON_DIR% --write_video %OUTPUT_VIDEO_PATH% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST% --no_display

if not %ERRORLEVEL% == 0 (
    exit 1
)

echo --------------
echo Done!!
echo tf-pose-estimation解析終了

cd /d %~dp0

exit /b 0
