@echo off

color 0c
echo ===-------------------------------===
echo       Developed by: ! Iuri
echo ===-------------------------------===
pause

start ..\artifacts\FXServer.exe +exec config\server.cfg +set onesync_enableInfinity 1 +set onesync_enableInfinity 1 +set onesync_enableBeyond 1 +set onesync_forceMigration 1 +set onesync_distanceCullVehicles 1 +set onesync_workaround763185 1 +set onesync_radiusFrequency 1
exit