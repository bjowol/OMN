#https://www.reddit.com/r/PowerShell/comments/3gurxs/how_to_check_if_o365_session_is_still_open/

function MSOLConnected 
{
    #Henter domene, om det feiler går scriptet videre og viser ingenting | Out-Null viser ikke noen meldinger i display
    
    Get-MsolDomain -ErrorAction SilentlyContinue | out-null
    
        #$? is used to find the return value of the last executed command. Try the following in the shell:
        #https://stackoverflow.com/questions/6834487/what-is-the-dollar-question-mark-variable-in-shell-scripting
    
    $result = $?
    return $result
}

function Get-MSOlUserInfo  
{

<#
    .SYNOPSIS

        Function that gets office365 user info

    .DESCRIPTION

        Gets the msoluser, lists and formats the user information that we want to see
    	
    .EXAMPLE
        
        Get-MSOLUserInfo -UPN bwolstad@oslo.mil.no

    .NOTES

        Bjørn Wolstad
        https://github.com/lazywinadmin/PowerShell/commit/fdffbe07aca20e2326c7bd156b605524602a0295


#>


    [CmdletBinding()]
    [OutputType([pscustomobject])]

    param
    (
    
    [Parameter(Mandatory = $true)]
    [string]$UPN

        # bruk"," for å legge til flere parametere.
       
    )

BEGIN
{
        TRY
        {
            
            Import-Module MSOnline
            
            #Sjekker om funskjonen MSOLConnected er true eller false. Den er true hvis kommandoen get-msoldomain får resultat.
            #Ergo, den sjekker om du har connection til office365 tenant.
            if (-not (MSOLConnected))
            {
                $credentials = (Get-Credential -UserName da-bwolstad@oslo.mil.no -Message 'passord')
                Connect-MsolService -Credential $credentials -ErrorAction Stop
            }
            

            $MSOLUser = Get-MsolUser -UserPrincipalName $UPN -ErrorAction Stop

            if(-not ($MSOLUser))
            {
                Write-Error -Message "[BEGIN] Cant find this user in Office365"
            }
            else
            {
                return
            }    
 


            }

            CATCH
            {
                $Error[0].Exception.Message
        
            }

        }

PROCESS
{
    
    TRY
    {
        Write-Verbose -Message "[PROCESS] Displaying Outputs"

        $user = Get-MsolUser -UserPrincipalName $UPN
        #$users = Get-MSOlUser -All 
        #$info = $users | Where-Object{$_.UserPrincipalName -eq $UPN} 
        #$info
        $user | Select-Object *




    }

    CATCH
    {
        $Error[0].Exception.Message

    }

}
END
{
        Write-Warning -Message "[END] Script is done"
}

}


