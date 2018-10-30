#http://www.computerperformance.co.uk/powershell/powershell_function_send_email.htm

Function Global:Send-EmailWithOutlook 
{

[cmdletbinding()]
[OutputType([pscustomobject])]


Param 
(

    [Parameter(Mandatory=$False,Position=0)]
    [String]$Address = "bwolstad@domain.com",
    [Parameter(Mandatory=$False,Position=1)]
    [String]$Subject = "POWERSHELL",
    [Parameter(Mandatory=$False,Position=2)]
    [String]$Body = "TEST",
    [Parameter(Mandatory=$False,Position=3)]
    [String]$Brukernavn = "bwolstad",
    [Parameter(Mandatory=$False,Position=4)]
    [String]$Attachment = $False

 )
BEGIN 
{

    #Clear-Host
    Add-Type -assembly "Microsoft.Office.Interop.Outlook"
    Write-Verbose -Message "[BEGIN] Displaying Outputs"


}
PROCESS 
{

    TRY
    {
       
        Write-Verbose -Message "[PROCESS] Displaying Outputs"

        # Create an instance Microsoft Outlook
        $Outlook = New-Object -ComObject Outlook.Application
        $Mail = $Outlook.CreateItem(0)
        $Mail.To = "$Address"
        $Mail.Subject = $Subject
        $Mail.Body =$Body
        
        # $File = "D:\CP\timetable.pdf"
        if($Attachment -eq $true)
        {
            $Mail.Attachments.Add($Attachment)
            Write-Verbose -Message "Attachment $Attachment was included"
        }
        # $Mail.Attachments.Add($File)
        $Mail.Send() 
    
    }

    CATCH
    {
        $Error[0].Exception.Message
        
        
    }

    Write-Verbose -Message "[PROCESS] Process Finished"
} # End of Process section
END 
{

    TRY
    {

        Write-Verbose -Message "[END] Displaying Outputs"

        # Section to prevent error message in Outlook
        #$Outlook.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook)
        $Outlook = $null

    }

    CATCH
    {
        $Error[0].Exception.Message
        
        
    }

        Write-Verbose -Message "[END] END Finished"

} # End of End section!

} # End of function

# Example of using this function
#Send-Email #-Address deck@swimmingpool.com
