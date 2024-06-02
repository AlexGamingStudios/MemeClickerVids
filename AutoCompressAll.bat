@echo off

:: Check if input directory parameter is provided
if "%1"=="" (
    echo Usage: %0 input_directory [resolution]
    exit /b 1
)

set input_directory=%1

:: Check if resolution parameter is provided
if "%2"=="" (
    set resolution=
) else (
    set resolution=-vf scale=%2
)

:: Loop through all files in the input directory
for %%I in ("%input_directory%\*.webm") do (
    echo Compressing: %%I
    call :Compress "%%I"
)

exit /b

:Compress
:: Create output directories if they don't exist
if not exist "Slideshow" mkdir "Slideshow"
if not exist "Low" mkdir "Low"
if not exist "Medium" mkdir "Medium"
if not exist "High" mkdir "High"

:: Get the input file name and directory
set input_file=%~1
set input_filename=%~n1
set input_file_extension=%~x1
set input_file_directory=%~dp1

:: Output file paths
set slideshow_output="Slideshow\%input_filename%.webm"
set low_output="Low\%input_filename%.webm"
set medium_output="Medium\%input_filename%.webm"
set high_output="High\%input_filename%.webm"

:: Compression commands
ffmpeg -c:v libvpx -i "%input_file%" -b:v 500k -pix_fmt yuva420p -r 10 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 %slideshow_output%
ffmpeg -c:v libvpx -i "%input_file%" -b:v 500k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 %low_output%
ffmpeg -c:v libvpx -i "%input_file%" -b:v 1000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 %medium_output%
ffmpeg -c:v libvpx -i "%input_file%" -b:v 2000k -pix_fmt yuva420p -r 30 %resolution% -an -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -map_metadata -1 %high_output%
