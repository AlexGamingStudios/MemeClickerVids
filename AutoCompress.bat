@echo off

:: Check if input file parameter is provided
if "%1"=="" (
    echo Usage: %0 input_file [resolution]
    exit /b 1
)

set input_file=%1

:: Check if resolution parameter is provided
if "%2"=="" (
    set resolution=
) else (
    set resolution=-vf scale=%2
)

:: Create directories if they don't exist
if not exist "Slideshow" mkdir "Slideshow"
if not exist "Low" mkdir "Low"
if not exist "Medium" mkdir "Medium"
if not exist "High" mkdir "High"

:: Slideshow (fixed at 10 fps, no audio, alpha_mode="1", remove metadata)
ffmpeg -c:v libvpx -i "%input_file%" -b:v 500k -pix_fmt yuva420p -r 10 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 "Slideshow\%~n1.webm"

:: Low Quality (fixed at 30 fps, no audio, alpha_mode="1", remove metadata)
ffmpeg -c:v libvpx -i "%input_file%" -b:v 500k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 "Low\%~n1.webm"

:: Medium Quality (fixed at 30 fps, no audio, alpha_mode="1", remove metadata)
ffmpeg -c:v libvpx -i "%input_file%" -b:v 1000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 "Medium\%~n1.webm"

:: High Quality (fixed at 30 fps, no audio, alpha_mode="1", remove metadata)
ffmpeg -c:v libvpx -i "%input_file%" -b:v 2000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 "High\%~n1.webm"
