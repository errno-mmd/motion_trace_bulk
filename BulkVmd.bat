@echo off
rem --- 
rem ---  3D �� �֐߃f�[�^���� vmd�f�[�^�ɕϊ�
rem --- 

echo ------------------------------------------
echo VMD-3d-pose-baseline-multi [%IDX%]
echo ------------------------------------------

rem -- VMD-3d-pose-baseline-multi �f�B���N�g���Ɉړ�
cd /d %~dp0
cd /d %VMD_DIR%

rem ---  python ���s
python main.py -v %VERBOSE% -t "%OUTPUT_SUB_DIR%" -b "born\���ɂ܂����~�N���W���{�[��.csv" -c 30 -z 1.5 -s 1 -p 0.5 -r 5 -k 1 -e 0 -d 4

if not %ERRORLEVEL% == 0 (
    exit 1
)

cd /d %~dp0

exit /b 0
