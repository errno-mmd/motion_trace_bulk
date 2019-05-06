@echo off
rem --- 
rem ---  3D �� �֐߃f�[�^���� vmd�f�[�^�ɕϊ�
rem --- 

echo ------------------------------------------
echo VMD-3d-pose-baseline-multi [%IDX%]
echo ------------------------------------------

rem ---  python ���s
set P2V_ARG=-v %VERBOSE% -t "%C_OUTPUT_SUB_DIR%" -b "born/animasa_miku_born.csv" -c 30 -z 0 -s 1 -p 0.5 -r 3 -k 1 -e 0
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd:%IMAGE_TAG% bash -c "cd /VMD-3d-pose-baseline-multi && python3 applications/pos2vmd_multi.py %P2V_ARG%"

exit /b
