@echo off
rem --- 
rem ---  �f���f�[�^����Openpose�Ŏp�����肷��
rem --- 


echo ------------------------------------------
echo Openpose ���
echo ------------------------------------------

rem ---  ���͑Ώۉf���t�@�C���p�X
echo ��͑ΏۂƂȂ�f���̃t�@�C���̃t���p�X����͂��ĉ������B
echo 1�t���[���ڂɕK���l�����f���Ă��鎖���m�F���Ă��������B�i�f���ĂȂ��Ǝ��ŃR�P�܂��j
echo ���̐ݒ�͔��p�p�����̂ݐݒ�\�ŁA�K�{���ڂł��B
set INPUT_VIDEO=
set /P INPUT_VIDEO=����͑Ώۉf���t�@�C���p�X: 
rem echo INPUT_VIDEO�F%INPUT_VIDEO%

IF /I "%INPUT_VIDEO%" EQU "" (
    ECHO ��͑Ώۉf���t�@�C���p�X���ݒ肳��Ă��Ȃ����߁A�����𒆒f���܂��B
    EXIT /B
)

rem ---  ��͂��J�n����t���[��

echo --------------
echo ��͂��J�n����t���[��No����͂��ĉ������B(0�n�܂�)
echo �ŏ��Ƀ��S���\������Ă��铙�A�l�̂����m�Ƀg���[�X�ł��Ȃ��ꍇ�ɁA
echo �`���̃t���[�����X�L�b�v�ł��܂��B
echo �������͂����AENTER�����������ꍇ�A0F�ڂ���̉�͂ɂȂ�܂��B
set FRAME_FIRST=0
set /P FRAME_FIRST="��͊J�n�t���[��No: "

rem ---  �f���ɉf���Ă���ő�l��

echo --------------
echo �f���ɉf���Ă���ő�l������͂��ĉ������B
echo �������͂����AENTER�����������ꍇ�A1�l���̉�͂ɂȂ�܂��B
echo �����l���������x�̑傫���ŉf���Ă���f����1�l�����w�肵���ꍇ�A��͑Ώۂ���ԏꍇ������܂��B
set NUMBER_PEOPLE_MAX=1
set /P NUMBER_PEOPLE_MAX="�f���ɉf���Ă���ő�l��: "

rem ---  ���]�t���[�����X�g
echo --------------
set REVERSE_FRAME_LIST=
echo Openpose����F�����Ĕ��]���Ă���t���[���ԍ�(0�n�܂�)���w�肵�Ă��������B
echo �����Ŏw�肳�ꂽ�ԍ��̃t���[���ɑ΂��āA���]������s���A���]�F�肳�ꂽ�ꍇ�A�֐߈ʒu�����]����܂��B
echo �J���}�ŕ������w��\�ł��B�܂��A�n�C�t���Ŕ͈͂��w��\�ł��B
echo ��j4,10-12�@�c�@4,10,11,12 �����]����Ώۃt���[���ƂȂ�܂��B
set /P REVERSE_FRAME_LIST="�����]�t���[�����X�g: "

rem ---  ���Ԏw�胊�X�g
echo --------------
set ORDER_SPECIFIC_LIST=
echo �����l���g���[�X�ŁA������̐l��INDEX���Ԃ��w�肵�Ă��������B
echo 0F�ڂ̗����ʒu�����珇�Ԃ�0�ԖځA1�ԖځA�Ɛ����܂��B
echo �t�H�[�}�b�g�F�m���t���[���ԍ���:������0�Ԗڂɂ���l���̃C���f�b�N�X,������1�Ԗځc�n
echo ��j[10:1,0]�@�c�@10F�ڂ́A������1�Ԗڂ̐l���A0�Ԗڂ̐l���̏��Ԃɕ��בւ��܂��B
echo [10:1,0][30:0,1]�̂悤�ɁA�J�b�R�P�ʂŕ������w��\�ł��B
set /P ORDER_SPECIFIC_LIST="�����Ԏw�胊�X�g: "

rem ---  �ڍ׃��O�L��

echo --------------
echo �ڍׂȃ��O���o�����Ayes �� no ����͂��ĉ������B
echo �������͂����AENTER�����������ꍇ�A�ʏ탍�O�Ɗe��A�j���[�V����GIF���o�͂��܂��B
echo �ڍ׃��O�̏ꍇ�A�e�t���[�����Ƃ̃f�o�b�O�摜���ǉ��o�͂���܂��B�i���̕����Ԃ�������܂��j
echo warn �Ǝw�肷��ƁA�A�j���[�V����GIF���o�͂��܂���B�i���̕������ł��j
set VERBOSE=2
set IS_DEBUG=no
set /P IS_DEBUG="�ڍ׃��O[yes/no/warn]: "

IF /I "%IS_DEBUG%" EQU "yes" (
    set VERBOSE=3
)

IF /I "%IS_DEBUG%" EQU "warn" (
    set VERBOSE=1
)

rem --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

rem -----------------------------------
rem --- ���͉f���p�X
FOR %%1 IN (%INPUT_VIDEO%) DO (
    rem -- ���͉f���p�X�̐e�f�B���N�g���ƁA�t�@�C����+_json�Ńp�X����
    set INPUT_VIDEO_DIR=%%~dp1
    set INPUT_VIDEO_FILENAME=%%~n1
    set INPUT_VIDEO_FILENAME_EXT=%%~nx1
)

rem -- ���s���t
set DT=%date%
rem -- ���s����
set TM=%time%
rem -- ���Ԃ̋󔒂�0�ɒu��
set TM2=%TM: =0%
rem -- ���s�������t�@�C�����p�ɒu��
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

echo --------------

rem ------------------------------------------------
rem -- JSON�o�̓f�B���N�g��
set OUTPUT_JSON_DIR=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_json
rem echo %OUTPUT_JSON_DIR%

rem -- JSON�o�̓f�B���N�g������
mkdir %OUTPUT_JSON_DIR%
echo ��͌���JSON�f�B���N�g���F%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- �f���o�̓f�B���N�g��
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_openpose.avi
echo ��͌���avi�t�@�C���F%OUTPUT_VIDEO_PATH%

echo --------------
echo Openpose��͂��J�n���܂��B
echo ��͂𒆒f�������ꍇ�AESC�L�[���������ĉ������B
echo --------------

rem -- exe���s
set C_INPUT_VIDEO=/data/%INPUT_VIDEO_FILENAME_EXT%
set C_JSON_DIR=/data/%INPUT_VIDEO_FILENAME%_%DTTM%/%INPUT_VIDEO_FILENAME%_json
set C_OUTPUT_VIDEO=/data/%INPUT_VIDEO_FILENAME%_%DTTM%/%INPUT_VIDEO_FILENAME%_openpose.avi
set OPENPOSE_ARG=--video %C_INPUT_VIDEO% --model_pose COCO --write_json %C_JSON_DIR% --write_video %C_OUTPUT_VIDEO% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST% --display 0
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd:%IMAGE_TAG% bash -c "cd /openpose && ./build/examples/openpose/openpose.bin %OPENPOSE_ARG%"

echo --------------
echo Done!!
echo Openpose��͏I��

exit /b
