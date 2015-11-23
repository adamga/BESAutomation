$cloudservices = Get-AzureService 
foreach ($cs in $cloudservices) 
{ 
    try{
        $depl = $cs|Get-AzureDeployment -ErrorAction Stop
    }
    catch
    {
         write-host $cs.ServiceName  " has no deployments." ;
         Remove-AzureService -ServiceName $cs.ServiceName -DeleteAll -Force
    }
}
