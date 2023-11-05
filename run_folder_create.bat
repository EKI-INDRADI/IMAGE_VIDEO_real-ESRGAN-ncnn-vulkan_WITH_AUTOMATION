setlocal

set tmp_frames=tmp_frames
set out_frames=out_frames
set delay=2


:: Delete the output file if it exists
if exist %output_file% (
    echo "--- delete %output_file%"
    del %output_file%
    timeout /t %delay% /nobreak
)


:: Delete tmp_frames and out_frames directories if they exist
if exist %tmp_frames% (
    echo "--- delete folder %tmp_frames%"
    rmdir /s /q %tmp_frames%
    timeout /t %delay% /nobreak
)


if exist %out_frames% (
    echo "--- delete folder %out_frames%"
    rmdir /s /q %out_frames%
    timeout /t %delay% /nobreak
)



:: Create tmp_frames and out_frames directories

echo "--- create folder %tmp_frames%"
mkdir %tmp_frames%

timeout /t %delay% /nobreak

echo "--- create folder %out_frames%"
mkdir %out_frames%

timeout /t %delay% /nobreak

endlocal