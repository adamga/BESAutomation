@echo off
REM Create a new AD Forest with DNS
set /p forname=Please enter an AD Forest Name:
set /p netbios=Please enter a NetBIOS Name for this domain (1-15 chars):
set /p password=Please enter a safe mode Administrator password:

dcpromo /unattend /InstallDNS:yes /dnsOnNetwork:yes /replicaOrNewDomain:domain /newDomain:forest /newDomainDNSName:%forname% /DomainNetbiosName:%netbios% /databasePath:"c:\windows\ntds" /logPath:"c:\windows\ntdslogs" /sysvolpath:"c:\windows\sysvol" /safeModeAdminPassword:"%password%" /forestLevel:2 /domainLevel:2 /rebootOnCompletion:no