@echo off
rem --- 
rem ---  �f���f�[�^����[�x������s��
rem --- 

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

rem ---  python ���s
set FCRN_ARG=--model_path tensorflow/data/NYU_FCRN.ckpt --video_path %C_INPUT_VIDEO% --json_path %C_JSON_DIR% --interval 10 --reverse_frames \"%REVERSE_FRAME_LIST%\" --order_specific \"%ORDER_SPECIFIC_LIST%\" --verbose %VERBOSE% --now %DTTM%
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd:%IMAGE_TAG% bash -c "cd /FCRN-DepthPrediction-vmd/ && python3 tensorflow/predict_video.py %FCRN_ARG%"

exit /b
