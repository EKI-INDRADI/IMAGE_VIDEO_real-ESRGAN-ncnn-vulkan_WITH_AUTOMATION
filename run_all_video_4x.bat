@echo off
setlocal

set video_format=mp4
set video_input=onepiece_demo
REM video_upscale=your_video.mp4
set tmp_frames=tmp_frames
set out_frames=out_frames
set realesr_executable=realesrgan-ncnn-vulkan.exe
set model_name=realesr-animevideov3

set fps_from_video=29.97
REM video_upscale=4 == 4x,3 == 3x,2 == 2x
set fps_output_video=29.97
set video_upscale=2
REM video_upscale=4 == 4x,3 == 3x,2 == 2x
set use_gpu=1
REM use_gpu=0,1 == MULTI GPU SUPPORT , use_gpu=0 == SINGLE GPU 1ST , use_gpu=1 == SINGLE GPU 2ND
set pixel_format=yuv444p
set cpu_threads=16
set delay=1

set output_file=%video_input%_%video_upscale%x_esrgan.%video_format%

echo "--- VIDEO INFO"
ffmpeg -i %video_input%.%video_format%

pause

echo "--- ENV_INFO"
echo "--- video_format=%video_format%"
echo "--- video_input=%video_input%"
echo "--- tmp_frames=%tmp_frames%"
echo "--- out_frames=%out_frames%"
echo "--- realesr_executable=%realesr_executable%"
echo "--- model_name=%model_name%"
echo "--- output_file=%output_file%"
echo "--- fps_from_video=%fps_from_video% | (set fps input video)"
echo "--- fps_output_video=%fps_output_video% | (set fps output video)"
echo "--- video_upscale=%video_upscale% | (video_upscale=4 == 4x | video_upscale=3 == 3x | video_upscale=2 == 2x)"
echo "--- use_gpu=%use_gpu% | (use_gpu=0,1 == MULTI GPU SUPPORT , use_gpu=0 == SINGLE GPU)"
echo "--- pixel_format=%pixel_format%"
echo "--- cpu_threads=%cpu_threads% | (set your cpu threads not core)"
echo "--- delay=%delay%"

pause

echo "--- run run_folder_create.bat in background"
REM run run_folder_create.bat in background
call run_folder_create.bat

echo "--- Extract frames from the input video"
:: Extract frames from the input video
ffmpeg -i %video_input%.%video_format% -qscale:v 1 -qmin 1 -qmax 1 -r %fps_from_video% %tmp_frames%\frame%%08d.png

timeout /t %delay% /nobreak

echo "--- Apply realesr-ncnn to enhance the frames"
:: Apply realesr-ncnn to enhance the frames
%realesr_executable% -i %tmp_frames% -o %out_frames% -n %model_name% -s %video_upscale% -g %use_gpu% -f png

timeout /t %delay% /nobreak

echo "--- Reassemble enhanced frames with the original audio into a video"
:: Reassemble enhanced frames with the original audio into a video
ffmpeg -r %fps_from_video% -i %out_frames%\frame%%08d.png -i %video_input%.%video_format% -map 0:v:0 -map 1:a:0 -c:a copy -c:v libx264 -r %fps_output_video% -thread_queue_size %cpu_threads% -pix_fmt %pixel_format% %output_file%

timeout /t %delay% /nobreak

echo "--- continue for delete folder tmp_frames & out_frames"
REM continue for delete folder tmp_frames & out_frames
pause

echo "--- run run_folder_delete.bat in background"
REM run run_folder_delete.bat in background
call run_folder_delete.bat

endlocal