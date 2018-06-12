#https://docs.microsoft.com/en-us/office365/enterprise/powershell/assign-roles-to-user-accounts-with-office-365-powershell

function Connect-MSOLServiceda-bwolstad() {
    $cred = (Get-Credential -UserName da-bwolstad@oslo.mil.no -Message "Passord")
    Connect-MsolService -Credential $cred
}
Connect-MSOLServiceda-bwolstad

$newadmins = ("da-OLOVDOKKEN@oslo.mil.no")


function Get-MSOLSharePointAdmins(){
    $sharepointrole = Get-MsolRole -RoleName  "SharePoint Service Administrator"
    Get-MsolRoleMember -RoleObjectId $sharepointrole.ObjectId
}

Get-MSOLSharePointAdmins

function Get-MSOLDomainAdmins(){
    $role = Get-MsolRole -RoleName "Company Administrator"
    Get-MsolRoleMember -RoleObjectId $role.ObjectId
}

Get-MSOLDomainAdmins


$dausers = Get-MsolUser -All | where {$_.UserPrincipalName -like "da-*"} 
$dausers.UserPrincipalName| Sort-Object 

#$users | where {$_.UserPrincipalName -contains "@oslo.mil.no"}


#$admins = Get-MsolRoleMember -RoleObjectId $role.ObjectId    

function Set-MSOLRoleDomainAdmin () {
    foreach($user in $newadmins){
        $golbaladmin = "Company Administrator"
        #$sharepointadmin="SharePoint Service Administrator"
        #$address = $user.UserPrincipalName

        Add-MsolRoleMember -RoleMemberEmailAddress $user -RoleName $golbaladmin -ErrorAction Stop
        #Remove-MsolRoleMember -RoleMemberEmailAddress $user -RoleName $golbaladmin
     }
}
Set-MSOLRoleDomainAdmin 

#Remove-MsolRoleMember 




