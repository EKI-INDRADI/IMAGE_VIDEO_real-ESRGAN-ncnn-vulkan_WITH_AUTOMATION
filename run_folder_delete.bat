setlocal

set tmp_frames=tmp_frames
set out_frames=out_frames
set delay=2


:: Cleanup: Delete tmp_frames and out_frames directories
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

endlocal
