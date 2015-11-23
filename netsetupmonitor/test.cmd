
rem wait 5 seconds...
ping 127.0.0.1 -n 6 > nul

echo In Standalone Configuration>log.txt

ping 127.0.0.1 -n 15 > nul

echo Installing Database...>log.txt

ping 127.0.0.1 -n 13 > nul

echo Configuring Service Accounts...>log.txt

ping 127.0.0.1 -n 6 > nul

echo Configuring Windows...>log.txt

ping 127.0.0.1 -n 12 > nul

echo Adding Firewall Extensions>log.txt

ping 127.0.0.1 -n 15 > nul
echo Cleaning up...>log.txt

echo Setup Done!>c:\blackberry\setupdone.txt
