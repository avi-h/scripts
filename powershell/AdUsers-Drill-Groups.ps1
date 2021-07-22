
Function Get-ADUserNestedGroups
{
    Param
    (
        [string]$DistinguishedName,
        [array]$Groups = @()
    )
 
    #Get the AD object, and get group membership.
    $ADObject = Get-ADObject -Filter "DistinguishedName -eq '$DistinguishedName'" -Properties memberOf, DistinguishedName;
    
    #If object exists.
    If($ADObject)
    {
        #Enummurate through each of the groups.
        Foreach($GroupDistinguishedName in $ADObject.memberOf)
        {
            #Get member of groups from the enummerated group.
            $CurrentGroup = Get-ADObject -Filter "DistinguishedName -eq '$GroupDistinguishedName'" -Properties memberOf, DistinguishedName;
       
            #Check if the group is already in the array.
            If(($Groups | Where-Object {$_.DistinguishedName -eq $GroupDistinguishedName}).Count -eq 0)
            {
                #Add group to array.
                $Groups +=  $CurrentGroup;
 
                #Get recursive groups.      
                $Groups = Get-ADUserNestedGroups -DistinguishedName $GroupDistinguishedName -Groups $Groups;
            }
        }
    }
 
    #Return groups.
    Return $Groups;
}
#--------------------

$dn = (Get-ADUser -SearchBase 'OU=MyBusiness,DC=office,DC=com' -Filter *) | 
? {($_.distinguishedName -notlike "*OU=Service Users*") -and( $_.Enabled -like $true)}



foreach ($Udn in $dn.distinguishedName) {

$managerDN = (Get-ADUser $Udn -Properties manager ).manager

if ($managerDN -notlike $null) {

$managerName = (Get-ADUser $managerDN).Name}

else {$managerName = "NULL"}


Get-ADUser $udn -Properties * | 


select Name,SamaccountName,Mail,Department,EmployeeID,EmployeeType,

@{l='Manager';e={$managerName}},

@{l='groups';
e={(Get-ADUserNestedGroups -DistinguishedName $Udn).name -join(',')}},

Title,MobilePhone,Created,Office,Sid | Export-Csv C:\Data\Users_DrillDown.Csv -Append

Write-Host "Done For -" (Get-ADUser $Udn).Name -ForegroundColor Gray -BackgroundColor Black
}