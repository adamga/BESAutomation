run BES setup against existing SQL instance
cd c:\blackberry
setup.exe --script --iAcceptBESEULA 
rem --properties "db.authentication.type=USER,db.host1=%computername%,db.instance=BES,db.name=bes,user.name=sa,user.pass=P2ssw0rd,service.account.name=%userdomain%\bes12service,service.account.password=P2ssw0rd"
