@echo off
rem --- 
rem ---  �f���f�[�^����e��g���[�X�f�[�^�𑵂���vmd�𐶐�����
rem ---  �����f���Ή��o�[�W����
rem --- 
cls

rem docker image tag
set IMAGE_TAG=1.02-1

rem ---  ���͑Ώۃp�����[�^�[�t�@�C���p�X
echo ��͑ΏۂƂȂ�p�����[�^�[�ݒ胊�X�g�t�@�C���̃t���p�X����͂��ĉ������B
echo ���̐ݒ�͔��p�p�����̂ݐݒ�\�ŁA�K�{���ڂł��B
set TARGET_LIST=
set /P TARGET_LIST=����͑Ώۃ��X�g�t�@�C���p�X: 
rem echo INPUT_VIDEO�F%INPUT_VIDEO%

IF /I "%TARGET_LIST%" EQU "" (
    ECHO ��͑Ώۃ��X�g�t�@�C���p�X���ݒ肳��Ă��Ȃ����߁A�����𒆒f���܂��B
    EXIT /B
)

SETLOCAL enabledelayedexpansion
rem -- �t�@�C���������[�v���đS����������
for /f "tokens=1-9 skip=1" %%m in (%TARGET_LIST%) do (
    echo ------------------------------
    echo ���͑Ώۉf���t�@�C���p�X: %%m
    echo ��͂��J�n����t���[��: %%n
    echo �f���ɉf���Ă���ő�l��: %%o
    echo �ڍ׃��O[yes/no/warn]: %%p
    echo ��͂��I������t���[��: %%q
    echo Openpose��͌���JSON�f�B���N�g���p�X: %%r
    echo �[�x���茋�ʃf�B���N�g���p�X: %%s
    echo ���]�w�胊�X�g%%t
    echo ���Ԏw�胊�X�g: %%u
    
    rem --- �p�����[�^�[�ێ�
    set INPUT_VIDEO=%%m
    set FRAME_FIRST=%%n
    set NUMBER_PEOPLE_MAX=%%o
    set VERBOSE=2
    set IS_DEBUG=%%p
    set FRAME_END=%%q
    set OUTPUT_JSON_DIR=%%r
    set PAST_DEPTH_PATH=%%s
    set REVERSE_SPECIFIC_LIST=%%t
    set ORDER_SPECIFIC_LIST=%%u
    
    IF /I "!IS_DEBUG!" EQU "yes" (
        set VERBOSE=3
    )

    IF /I "!IS_DEBUG!" EQU "warn" (
        set VERBOSE=1
    )

    rem -- ���s���t
    set DT=!date!
    rem -- ���s����
    set TM=!time!
    rem -- ���Ԃ̋󔒂�0�ɒu��
    set TM2=!time: =0!
    rem -- ���s�������t�@�C�����p�ɒu��
    set DTTM=!DT:~0,4!!DT:~5,2!!DT:~8,2!_!TM2:~0,2!!TM2:~3,2!!TM2:~6,2!
    
    echo now: !DTTM!
    echo verbose: !VERBOSE!

    rem -----------------------------------
    rem --- JSON�o�̓f�B���N�g�� ���� index�ʃT�u�f�B���N�g������
    FOR %%i IN (!OUTPUT_JSON_DIR!) DO (
        set OUTPUT_JSON_DIR_PARENT=%%~dpi
        set OUTPUT_JSON_DIR_NAME=%%~ni
    )
    
    rem --- �R���e�i�p�̃p�����[�^�[
    FOR %%1 IN (!INPUT_VIDEO!) DO (
        rem -- ���͉f���p�X�̐e�f�B���N�g���ƁA�t�@�C����+_json�Ńp�X����
        set INPUT_VIDEO_DIR=%%~dp1
        set INPUT_VIDEO_FILENAME=%%~n1
        set INPUT_VIDEO_FILENAME_EXT=%%~nx1
    )
    set C_INPUT_VIDEO=/data/!INPUT_VIDEO_FILENAME_EXT!
    set PARENT_DIR_FULL=!OUTPUT_JSON_DIR_PARENT:~0,-1!
    FOR %%i IN (!PARENT_DIR_FULL!) DO (
        set PARENT_DIR_NAME=%%~ni
    )
    set C_JSON_DIR=/data/!PARENT_DIR_NAME!/!OUTPUT_JSON_DIR_NAME!

    rem -- FCRN-DepthPrediction-vmd���s
    call BulkDepth_Docker.bat

    rem -- �L���v�`���l�������[�v����
    for /L %%i in (1,1,!NUMBER_PEOPLE_MAX!) do (
        set IDX=%%i
        
        rem -- 3d-pose-baseline���s
        call Bulk3dPoseBaseline_Docker.bat
        
        rem -- 3dpose_gan���s
        rem call Bulk3dPoseGan_Docker.bat

        rem -- VMD-3d-pose-baseline-multi ���s
        call BulkVmd_Docker.bat
    )

    echo ------------------------------------------
    echo �g���[�X����
    echo json: !OUTPUT_JSON_DIR!
    echo vmd:  !OUTPUT_SUB_DIR!
    echo ------------------------------------------


)

ENDLOCAL


