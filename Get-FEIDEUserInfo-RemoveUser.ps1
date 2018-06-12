#Bjørn Wolstad
#Scriptet er laget for å få innsyn
#Kommentarer.
#   https://stackoverflow.com/questions/27950142/using-powershell-to-strip-a-row-from-a-csv-that-contains-a-specific-word
#    Import-Csv test.csv | where {$_.Publisher -ne "Microsoft P"} | Export-Csv New.csv -notypeinfo
#    https://community.spiceworks.com/how_to/60263-convert-a-tab-delimited-csv-file-to-comma-delimited-with-powershell

Function List-FeideObjects()
{
        $ansattePath = "C:\Users\da-bwolstad\Desktop\ansatte.csv"
        $eleverPath = "C:\Users\da-bwolstad\Desktop\elever.csv"
        $ansattecsv = Import-Csv $ansattePath -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop
        $elevercsv = Import-Csv $eleverPath -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop

        $antallansatteobjekter = $ansattecsv.Count
        $antalleleverobjekter = $elevercsv.Count

        Write-Host "Det ligger $antallansatteobjekter i ansatte filen" -ForegroundColor Green
        Write-Host "Det ligger $antalleleverobjekter i elever filen" -ForegroundColor Green
        Write-Host "
        
        " 

}



Function Get-FEIDEUserInfo
{
    [cmdletbinding()]
    [OutputType([pscustomobject])]

param
(
    [Parameter(Mandatory=$True,Position=0)]
    [String]$Brukernavn,
    [Parameter(Mandatory=$false,Position=1)]
    [switch]$SlettBruker

)

BEGIN
{
    #Hvis parameter -verbose er aktivert, så ser man denne feilmeldingen. Dermed kan man se hvilknen del av scriptet som feiler
    Write-Verbose -Message "[BEGIN] Begin started"

    TRY
    {
        #impoterer csvfiler til hver sin variabel
        #utrolig viktig med -Delimiter `t for at TAB SEPARERTE filen skal impoteres riktig, med riktig headers, og ikke bare som en streng.
        $ansattePath = "C:\Users\da-bwolstad\Desktop\ansatte.csv"
        $eleverPath = "C:\Users\da-bwolstad\Desktop\elever.csv"
        $ansattecsv = Import-Csv $ansattePath -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop
        $elevercsv = Import-Csv $eleverPath -Delimiter `t -Encoding UTF8 -Verbose -ErrorAction Stop

        List-FeideObjects
        #Write-Host "Det ligger følgende objekter i Ansatte.csv"
        #Write-Host "$antallansatteobjekter" -ForegroundColor Green
        #Write-Host "Det ligger følgende objekter i Elever.csv"
        #Write-Host "$antalleleverobjekter" -ForegroundColor Green

    
    
    
    
    }#END TRY
    CATCH
    {
        #Denne viser error som skjedde i TRY{} Om det skjedde noe feil.
        $Error[0].Exception.Message

    }#END CATCH

     Write-Verbose -Message "[BEGIN] Begin finished"

}#END BEGIN
PROCESS
{
    TRY
    {
        
        #Sjekker om $Brukernavn ligger i filen Ansatte.csv
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
            }#end if

       
       #Sjekker om $Brukernavn ligger i filen Elever.csv
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
            }#end if

        #denne delen "return" avslutter scriptet uten å avslutte powershell. 
        #Her sjekker vi om brukeren i det hele tatt finnes. 
        if($brukeriansattecsv -eq $false -and $brukerielevercsv -eq $false)
        {
            Write-Warning -Message "Finner ikke bruker i ansatte.csv, eller elever.csv"
            return 
        }#end if

        #SLETT BRUKER IF STATMENT
        if($SlettBruker -eq $True)
        {
            
            Write-Warning -Message "NÅ VIL BRUKER BLI SLETTET, TRYKK JA FOR Å BEKREFTE." -WarningAction Inquire 
            Write-Verbose "SLETTER BRUKER..." 

            if($brukeriansattecsv -eq $True)
            {
                Write-Warning -Message "BRUKER BLIR SLETTET FRA ANSATTE.CSV" 
                
                $ansattecsv | Where {$_.Brukernavn -like $Brukernavn} | Out-File -Append -FilePath "\\dmzufeide01\brukerimport$\slettede_brukere.csv"
                
                #sletter bruker, og lager ny CSV FIL - Overskriver gamle filen/Skriver til ny fil.
                $ansattecsv | Where-Object {$_.Brukernavn -ne $Brukernavn} `
                | ConvertTo-Csv -NoTypeInformation -Delimiter `t | % {$_ -replace("""","")} `
                | Out-File "C:\Users\da-bwolstad\Desktop\ansatte.csv" -ErrorAction Stop -Encoding UTF8
                 

            }
           
            if($brukerielevercsv -eq $True)
            {
                Write-Warning -Message "BRUKER BLIR SLETTET FRA ELEVER.CSV"
                #Kjører funskjon for å lage objekt variabel informasjon

                $elevercsv | Where {$_.Brukernavn -like $Brukernavn} | Out-File -Append -FilePath "\\dmzufeide01\brukerimport$\slettede_brukere.csv"

                
                #sletter bruker, og lager ny CSV FIL - Overskriver gamle filen/Skriver til ny fil.
                $elevercsv | Where-Object {$_.Brukernavn -ne $Brukernavn} `
                | ConvertTo-Csv -NoTypeInformation -Delimiter `t | % {$_ -replace("""","")} `
                | Out-File "C:\Users\da-bwolstad\Desktop\elever.csv" -ErrorAction Stop -Encoding UTF8 


            }

        }#END IF

    }#END TRY

    CATCH
    {
        #Skriver ut eventuelle feilmeldinger i TRY
        $Error[0].Exception.Message
    }#END CATCH


}#END PROCESS

END
{
    #informerer om at scriptet er ferdig hvis parameteret -Verbose er aktiv.
    Write-Verbose -Message "[END] End started"
    
    #Viser hvor mange objekter det nå er i csv filene
    #Dette gjøres for å se om det er blitt slettet flere enn to objekter av gangen.
    List-FeideObjects
    #Write-Host "Det ligger følgende objekter i Ansatte.csv"
    #Write-Host "$antallansatteobjekter" -ForegroundColor Green
    #Write-Host "Det ligger følgende objekter i Elever.csv"
    #Write-Host "$antalleleverobjekter" -ForegroundColor Green



}#END END

}#end function Get-FEIDEUserInfo

#Get-FEIDEUserInfo -Brukernavn nostvold
#Get-FEIDEUserInfo -Brukernavn "kgranrusten"

