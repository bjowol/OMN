#Bjørn Wolstad
#Scriptet er laget for å få innsyn
Function Get-FEIDEUserInfo
{
   
    [cmdletbinding()]
    [OutputType([pscustomobject])]

param
(
    [Parameter(Mandatory=$True,Position=0)]
    [String]$Brukernavn

)

BEGIN
{
    Write-Verbose -Message "[BEGIN] Begin started"

    TRY
    {
        
        $ansattecsv = Import-Csv "C:\Users\da-bwolstad\Desktop\ansatte.csv" -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop
        $elevercsv = Import-Csv "C:\Users\da-bwolstad\Desktop\elever.csv" -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop


    }#END TRY
    CATCH
    {
        $Error[0].Exception.Message

    }#END CATCH

     Write-Verbose -Message "[BEGIN] Begin finished"

}#END BEGIN
PROCESS
{
    TRY
    {
        
        if(($ansattecsv | Where {$_.Brukernavn -like $Brukernavn}).Brukernavn -like $Brukernavn)
            {
                Write-host  "Bruker ligger i Ansatte.csv" -ForegroundColor Green
                $brukeriansattecsv = $True
                $ansattecsv | Where {$_.Brukernavn -like $Brukernavn}
            }
        else
            {
                Write-Warning "Bruker ligger ikke i Ansatte filen"
                $brukeriansattecsv = $false
            }

        if(($elevercsv | where {$_.Brukernavn -like $Brukernavn}).Brukernavn -like $Brukernavn)
            {
                Write-host  "Bruker ligger i Elever.csv" -ForegroundColor Green
                $brukerielevercsv = $True
                $elevercsv | where {$_.Brukernavn -like $Brukernavn}
            }
        else
            {
                Write-Warning "Bruker ligger ikke i Elever filen"
                $brukerielevercsv = $false
            }


    }#END TRY
    CATCH
    {
        $Error[0].Exception.Message
    }#END CATCH




}#END PROCESS

END
{
    Write-Verbose -Message "[END] End started"


}#END END

}#end function Get-FEIDEUserInfo

#Get-FEIDEUserInfo -Brukernavn nostvold
#Get-FEIDEUserInfo -Brukernavn "kgranrusten"

