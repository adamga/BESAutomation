USE [master] 
GO 
CREATE LOGIN [agbesdemo\adamga] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO 
ALTER SERVER ROLE [sysadmin] ADD MEMBER [agbesdemo\adamga]
GO
