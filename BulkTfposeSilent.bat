@echo off
rem --- 
rem ---  �f���f�[�^����tf-pose-estimation�Ŏp�����肷��
rem --- 


echo ------------------------------------------
echo tf-pose-estimation ���
echo ------------------------------------------

rem --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

rem -----------------------------------
rem --- ���͉f���p�X
FOR %%1 IN (%INPUT_VIDEO%) DO (
    rem -- ���͉f���p�X�̐e�f�B���N�g���ƁA�t�@�C����+_json�Ńp�X����
    set INPUT_VIDEO_DIR=%%~dp1
    set INPUT_VIDEO_FILENAME=%%~n1
)

echo --------------

rem ------------------------------------------------
rem -- JSON�o�̓f�B���N�g��
set OUTPUT_JSON_DIR=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_json
rem -- echo %OUTPUT_JSON_DIR%

rem -- JSON�o�̓f�B���N�g������
mkdir %OUTPUT_JSON_DIR%
echo ��͌���JSON�f�B���N�g���F%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- �f���o�̓f�B���N�g��
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_tf-pose-estimation.avi
echo ��͌���avi�t�@�C���F%OUTPUT_VIDEO_PATH%

echo --------------
echo tf-pose-estimation��͂��J�n���܂��B
echo ��͂𒆒f�������ꍇ�AESC�L�[���������ĉ������B
echo --------------

rem ---  tf-pose-estimation�f�B���N�g���Ŏ��s
cd /d %TFPOSE_DIR%\

rem -- exe���s
python run_video.py --video %INPUT_VIDEO%  --model mobilenet_v2_large --write_json %OUTPUT_JSON_DIR% --write_video %OUTPUT_VIDEO_PATH% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST% --no_display

if not %ERRORLEVEL% == 0 (
    exit 1
)

echo --------------
echo Done!!
echo tf-pose-estimation��͏I��

cd /d %~dp0

exit /b 0
