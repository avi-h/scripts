Function Add-F5Acl {

<#
.SYNOPSIS
    Add a new ACL to an Existing object on the f5 load balancer.
 
.PARAMETER name
 
    Name of Existing ACL
 
.PARAMETER action
 
    'allow' or 'reject' for ACL
 
 
.PARAMETER dstStartPort
 
    Destination start port. Can take multiples values in csv list format. Ex: 80,8080,443,8443
 
.PARAMETER dstEndPort
 
    Desintation end port. Only mandatory for adding in port ranges.
 
.PARAMETER dstSubnet
 
    Destination subnet in format 192.168.1.1/32. Can take multiples values in csv list format. Ex: 10.22.33.200/24,10.224.30.2/28
    Single ip ACL changes are represented by /32
    Larger network ranges can be used by passing the correct CIDR notation.
 
.PARAMETER Protocols
 
    Changes protocol type (6=tcp,17=udp,1=ICMP,0=any) .

.PARAMETER Layer7
 
    Add rule in Layer7. parameters "Hosts" and "SCHEMES" must be presented

.PARAMETER Hosts
 
    server's host name. use for Layer7. parameter "SCHEMES" must be presented as well 

.PARAMETER Schemes
 
    protocol (Http or Https) . use for Layer7. parameter "Hosts" must be presented as well
 
.EXAMPLE
    Add-F5Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/24 -Protocols 6
     
    Add a New ACL for a single port and network range /24 (TCP)
.EXAMPLE
 
    Add-F5Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 8000 -dstSubnet 192.168.1.1/24 -Protocols 6
 
    Add a New ACL for a port range 80-8000 and network range /24 (TCP)
.Example
    Add-F5Acl -name Existing_ACL_Name -action allow -dstStartPort 80 -dstEndPort 80 -dstSubnet 192.168.1.1/32 -Protocols 0
 
    Adds a New ACL for port 80 to a SINGLE IP (any)
.Example
    Add-F5Acl -name Existing_ACL_Name -action allow -dstStartPort 80,8080,443 -dstSubnet 192.168.1.1/32,192.168.1.40/24 -Protocols 6,17,1
 
    Adds a New ACL for ports 80,8080,443 on Subnets 192.168.1.1/32 and 192.168.1.40/24 (tcp,udp,icmp)

.Example
Add-F5Acl -name $sslGroup -dstStartPort 0 -dstSubnet 0.0.0.0/0 -action allow -Protocols 0  -Layer7  -hosts "Video.Myoffice.com","test.com" -schemes https,Http

    Adds a new ACL rule in Layer 7 in Http and Https protocols


 
#>


[cmdletBinding()]
    param(
        
        [Alias("Existing acl Name")]
        [Parameter(Mandatory=$true)]
        [string]$name='',

        [Alias("Allow or Deny")]
        [Parameter(Mandatory=$true)]
        [string]$action='',

        [Alias("DestinationStart")]
        [Parameter(Mandatory=$true)]
        [string []]$dstStartPort='',

        [Alias("DestinationEnd")]
        [Parameter(Mandatory=$false)]
        [string []]$dstEndPort= $dstStartPort,

        [Alias("Subnet")]
        [Parameter(Mandatory=$true)]
        [string []]$dstSubnet='' ,
       
        [Alias("Language")]
        [Parameter(Mandatory=$true)]
        [string []]$Protocols=''  ,

        [Alias("Server")]
        [Parameter(Mandatory=$false)]
        [string []]$hosts=''  ,

        [Alias("Scheme")]
        [Parameter(Mandatory=$false)]
        [string []]$schemes='' ,

        [Parameter()]
        [switch]$Layer7
        


    )
    begin {
        if( [System.DateTime]($F5Session.WebSession.Headers.'Token-Expiration') -lt (Get-date) ){
            Write-Warning "F5 Session Token is Expired. Please re-connect to the F5 device."
            break

        }
        #Test that the F5 session is in a valid format
        Test-F5Session($F5Session)
        $acl = Get-SingleAcl -name $name
    }

    process {

        foreach ($sub in $dstSubnet) {

            foreach ($port in $dstStartPort) {
                
                foreach ($protocol in $Protocols) {

                 foreach ($hostName in $hosts) {

                 foreach ($scheme in $schemes) {

                $index = $dstStartPort.IndexOf($port)

                if( $Layer7.IsPresent ){

                    $baseAclEntry =  [PSCustomObject]@{
                        'action' = "$action"
                        'dstEndPort' = $dstEndPort[$index]
                        'dstStartPort' = "0"
                        'dstSubnet' = "0.0.0.0/0"
                        'log' = 'packet'
                        'protocol' = $protocol
                        'scheme' = $scheme
                        'srcEndPort' = 0
                        'srcStartPort' = 0
                        'srcSubnet' = '0.0.0.0/0'
                        'host' = "$hostName"
                    }

                }

                else {

                    $baseAclEntry =  [PSCustomObject]@{
                        'action' = "$action"
                        'dstEndPort' = $dstEndPort[$index]
                        'dstStartPort' = "$port"
                        'dstSubnet' = "$sub"
                        'log' = 'packet'
                        'protocol' = "$protocol"
                        'scheme' = 'any'
                        'srcEndPort' = 0
                        'srcStartPort' = 0
                        'srcSubnet' = '0.0.0.0/0'
                    }

                }
                

                # add first acl
                if ( -not $acl.entries ) { 
            
                    if( $Layer7.IsPresent ) {
                        $baseAclEntry = [PSCustomObject]@{'entries' = @(
                            [PSCustomObject]@{
                            'action' = "$action"
                            'dstEndPort' = $dstEndPort[$index]
                            'dstStartPort' = "0"
                            'dstSubnet' = "0.0.0.0/0"
                            'log' = 'packet'
                            'protocol' = 0
                            'scheme' = $scheme
                            'srcEndPort' = 0
                            'srcStartPort' = 0
                            'srcSubnet' = '0.0.0.0/0'
                            'host' = "$hostName"}
                        )}
                    }

                    else {
                        $baseAclEntry = [PSCustomObject]@{'entries' = @(
                            [PSCustomObject]@{
                            'action' = "$action"
                            'dstEndPort' = $dstEndPort[$index]
                            'dstStartPort' = "$port"
                            'dstSubnet' = $sub
                            'log' = 'packet'
                            'protocol' = $protocol
                            'scheme' = 'any'
                            'srcEndPort' = 0
                            'srcStartPort' = 0
                            'srcSubnet' = '0.0.0.0/0'}
                        )}

                    }

                        Add-Member -InputObject $acl -NotePropertyName entries -NotePropertyValue (New-Object System.Collections.ArrayList)  #add first acl into object so we don't hit this block again
                        $acl.entries += $baseAclEntry.entries 
                        $JSONBody = $baseAclEntry | ConvertTo-Json -Depth 10
            
                }

 
                else { 
                   
                   
                    $acl.entries += $baseAclEntry
                    $JSONBody = $acl | ConvertTo-Json -Depth 10 

                    }
            

                $uri = $F5Session.BaseURL.Replace('/ltm/',"/apm/acl/~Common~$name")
                $response = Invoke-RestMethodOverride -Method Patch -Uri $URI -Body $JSONBody -ContentType 'application/json' -WebSession $F5Session.WebSession
                $response
                        
                        }

                    }

                }
            }
        }
        
    }

}