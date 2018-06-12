

#sjekker om dette er et vanslig powershell vindu
if ($host.name -eq 'ConsoleHost')
{
    $host.ui.RawUI.ForegroundColor = "yellow" #Skriftfarge
    $host.UI.RawUI.WindowTitle = "StarShell"
    
    #return $?
}

#sjekker om dette er en ISE session/host
if ($host.Name -eq 'Windows PowerShell ISE Host')
{   
    $psISE.Options.RestoreDefaults() 
    #$psISE.Options.ConsolePaneBackgroundColor = 'darkblue'
    $psISE.Options.ConsolePaneForegroundColor = 'yellow' 
    $psISE.Options.ConsolePaneTextBackgroundColor = 'black'
    #$psISE.Options.ErrorBackgroundColor = 'black'
    #$psISE.Options.ErrorForegroundColor = 'red'
    #$psISE.Options.ErrorBackgroundColor
    $psISE.Options.FontSize = '11'
    $psISE.Options.ScriptPaneBackgroundColor = 'lightgray'
    $psISE.Options.SelectedScriptPaneState = 'Right'
    #return $?
}

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


Import-Module "Z:\Documents\1. Powershell\Get-MSOLUserInfo.psm1"
$ModulePath = "\\common\drift$\Scripts\Brukeroppretting\PowershellModuler"
Import-Module "$ModulePath\OSLO-Common-Modules.psm1" -WarningAction SilentlyContinue
Import-Module 365Tools 
Import-Module AzureAD
Import-Module MSOnline
#Import-Module SkypeOnlineConnector

$whoami = whoami.exe
Write-Host ("Modules Imported") -ForegroundColor Green
Write-Host ("Running as $whoami") -ForegroundColor Green


Write-Host ("
 █                                          /~\                               ▐▌
 █                                         |oo )         At last!             ▐▌
 █                                         _\=/_                              ▐▌
 █                         ___            /  _  \                             ▐▌
 █                        / ()\          //|/.\|\\                            ▐▌
 █                      _|_____|_       ||  \_/  ||                           ▐▌
 █                     | | === | |      || |\ /| ||                           ▐▌
 █                     |_|  O  |_|       # \_ _/ #                            ▐▌
 █                      ||  O  ||          | | |                              ▐▌
 █                      ||__*__||          | | |                              ▐▌
 █                     |~ \___/ ~|         []|[]                              ▐▌
 █                     /=\ /=\ /=\         | | |                              ▐▌
 █     ________________[_]_[_]_[_]________/_]_[_\_________________________    ▐▌
                                              
 ") -ForegroundColor White #-BackgroundColor Black   
 
 
 
                            