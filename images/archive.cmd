for /F "DELIMS=" %%I IN ('dir /b /s *.iso *.image *.bin') DO (
    7z a -t7z -mx9 -mmt=on -myx=9 -sdel -x!*.7z "%%I.7z" "%%I"
)
