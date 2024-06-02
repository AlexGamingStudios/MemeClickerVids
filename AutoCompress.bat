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

:: Slideshow 
ffmpeg -i "%input_file%" -c:v libvpx -b:v 500k -pix_fmt yuva420p -r 10 %resolution% -an -auto-alt-ref 0 "Slideshow\%~n1.webm"

:: Low Quality 
ffmpeg -i "%input_file%" -c:v libvpx -b:v 500k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 "Low\%~n1.webm"

:: Medium Quality 
ffmpeg -i "%input_file%" -c:v libvpx -b:v 1000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 "Medium\%~n1.webm"

:: High Quality 
ffmpeg -i "%input_file%" -c:v libvpx -b:v 2000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 "High\%~n1.webm"
