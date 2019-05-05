@echo off
rem --- 
rem ---  �f���f�[�^����e��g���[�X�f�[�^�𑵂���vmd�𐶐�����
rem --- 

# docker image tag
set IMAGE_TAG=1.00-1

rem -- Openpose ���s
call BulkOpenpose_Docker.bat

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%


rem -----------------------------------
rem --- JSON�o�̓f�B���N�g�� ���� index�ʃT�u�f�B���N�g������
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

set DTTM_OLD=%DTTM%
rem -- ���s���t
set DT=%date%
rem -- ���s����
set TM=%time%
rem -- ���Ԃ̋󔒂�0�ɒu��
set TM2=%TM: =0%
rem -- ���s�������t�@�C�����p�ɒu��
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

rem -- FCRN-DepthPrediction-vmd���s
call BulkDepth_Docker.bat

rem -- �L���v�`���l�������[�v����
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
    set IDX=%%i
    
    rem -- 3d-pose-baseline���s
    call Bulk3dPoseBaseline_Docker.bat
    
    rem -- 3dpose_gan���s
    call Bulk3dPoseGan_Docker.bat

    rem -- VMD-3d-pose-baseline-multi ���s
    call BulkVmd_Docker.bat
)

echo ------------------------------------------
echo �g���[�X����
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------
