USE [master] 
GO 
CREATE LOGIN [agbesdemo\bes12service] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO 
ALTER SERVER ROLE [sysadmin] ADD MEMBER [agbesdemo\bes12service]
GO
