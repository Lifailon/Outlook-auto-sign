# Read README.md
# https://github.com/Lifailon/ldap-sign

### 1 block
$usr = $env:username
$filter = "(&(objectCategory=User)(samAccountName=$usr))"
$ldapsearcher = New-Object System.DirectoryServices.DirectorySearcher
$ldapsearcher.Filter = $filter
$usrfind = $ldapsearcher.FindOne()
$usrdir = $usrfind.GetDirectoryEntry()
$Name = $usrdir.name #givenName,sn,cn,displayName
$Desc = $usrdir.description #title,departament
$Company = $usrdir.company
$Mail = $usrdir.mail
$Tel = $usrdir.telephoneNumber

### 2 block
$path_local = "$env:appdata\Microsoft\Signatures"
$path_domain = "\\$env:userdnsdomain\System\Install\Sign\auto"
If ((Test-Path "$path_local") -eq $True) {Remove-Item "$path_local\*" -Recurse} else {New-Item -Path $path_local -ItemType directory}
Copy-Item -Path "$path_domain\*" -Recurse -Destination "$path_local" -Force 

### 3 block
#
#С уважением,
#ФИО
#Должность
#Компания
#Email: Почта
#Tel: Телефон
#
$htm = Get-Content "$path_local\auto.htm"
$htm = $htm -replace "ФИО","$Name"
$htm = $htm -replace "Должность","$Desc"
$htm = $htm -replace "Компания","$Company"
$htm = $htm -replace "Почта*","$Mail"
$htm = $htm -replace "Телефон","$Tel"
$htm > "$path_local\auto.htm"

### 4 block
$reg_path = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles\Outlook\9375CFF0413111d3B88A00104B2A6676\00000002"
$sig_name = "auto"
Set-ItemProperty -Path $reg_path -Name "New Signature" -Value $sig_name
Set-ItemProperty -Path $reg_path -Name "Reply-Forward Signature" -Value $sig_name