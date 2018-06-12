function Install-Office365modules()
{
    $installedModules = (Get-Module).Name
    $InstallModules = ("365Tools","AzureAD","MSOnline")
    foreach($module in $InstallModules)
    {
        if($installedModules -like $module)
        {
            Write-Host "$module Is Installed"
            
        }#slutt if
        else
        {
            Install-Module $module
            Update-Module $module
            Write-Host "Installed module $module" -ForegroundColor Green
        
        }#slutt else

    }#slutt foreach

}#Slutt funksjon

