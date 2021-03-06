############################################################################################################################################
# This Scrip allows todo an IIS RESET to all the servers in a SharePoint Farm
# Requited parameters: N/A
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"

#Definition of the funcion that performs the IIS RESET in all the servers
function Do-IISReset
{    
    try
    {        
        #Getting the servers where the IISReset is going to be done
        $spServers= Get-SPServer | ? {$_.Role -eq "Application"}
        foreach ($spServer in $spServers)
        {            
            Write-Host "Doing IIS Reset in server $spServer" -f blue
            iisreset $spServer /noforce "\\"$_.Address
            iisreset $spServer /status "\\"$_.Address
        }        
        Write-Host "IIS Reset completed successfully!!" -f blue  
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global
#Calling the function
Do-IISReset
Stop-SPAssignment –Global

Remove-PSSnapin Microsoft.SharePoint.PowerShell