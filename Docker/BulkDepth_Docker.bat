@echo off
rem --- 
rem ---  映像データから深度推定を行う
rem --- 

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

rem ---  python 実行
set FCRN_ARG=--model_path tensorflow/data/NYU_FCRN.ckpt --video_path %C_INPUT_VIDEO% --json_path %C_JSON_DIR% --past_depth_path \"%PAST_DEPTH_PATH%\" --interval 10 --reverse_specific \"%REVERSE_SPECIFIC_LIST%\" --order_specific \"%ORDER_SPECIFIC_LIST%\" --avi_output yes --verbose %VERBOSE% --number_people_max %NUMBER_PEOPLE_MAX% --end_frame_no %FRAME_END% --now %DTTM%

docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd:%IMAGE_TAG% bash -c "cd /FCRN-DepthPrediction-vmd/ && python3 tensorflow/predict_video.py %FCRN_ARG%"

if not %ERRORLEVEL% == 0 (
    exit 1
)

exit /b 0
