#Script to check your installed root-certificates against a list (CSV) of trustetd ones
#written by M.Rauch

#Global stuff
$global:path_to_file=$args[0]
$global:delimeter=$args[1]
$global:local_machine_path="Cert:\LocalMachine\Root\"
$global:current_user_path="Cert:\CurrentUser\Root\"
$global:trusted_thumbs = @()

write-host "
--------Root-Cert checker---------
used reference list:  $path_to_file
used delimeter:       $delimeter
" -ForegroundColor Yellow



####---Check arguments---####
function check_args (){
if ($global:path_to_file){
}
else {
throw 'No list for reference specified!! 
Usage: root_cert.ps1 path_to_csv_file "delimeter"'
}

if ($global:delimeter){
}
else {
throw 'No delimeter specified!! 
Usage: root_cert.ps1 path_to_csv_file "delimeter"'
}
}
####---END Check arguments---####



####---Import---####
function import_csv(){
#import thumbprints of csv
$trusted_list= Import-Csv $global:path_to_file -Delimiter "$global:delimeter"



#save thumbs of csv into array
$trusted_list |`
    ForEach-Object {
    $global:trusted_thumbs += $_.Thumbprint


    } 
 

}
####---END IMPORT---####







####---Checker---####
function checker($path){

#Get the thumbprints of the installed certificates
$installed_certs = Get-ChildItem $path | select -ExpandProperty Thumbprint
$untrusted_certs = @()

Write-Host "Checking Certs from $path
" -ForegroundColor Yellow

#check if installed certs are in the trusted list
foreach ($thumb in $installed_certs){
    
    if ($global:trusted_thumbs -notcontains $thumb){
    
        write-host "Certificate with Thumbprint of" $thumb "is UNTRUST" -ForegroundColor Red
        $untrusted_certs += $thumb

    }
    else {
        write-host "Certificate with Thumbprint of" $thumb "is OK" -ForegroundColor DarkGreen

    }

}

make_output($untrusted_certs)
}
####---END Checker---####



####---Output---####
function make_output($untrusted_certs) {
write-host "`n`n --- Following root certs are not in the trusted List! ---" -ForegroundColor red

foreach ($untrust in $untrusted_certs){

Get-ChildItem Cert:\currentuser\Root\$untrust | Format-List FriendlyName, Issuer, Thumbprint, Notafter
    
}
}
####---END Output---####




#Run the functions
check_args
import_csv
checker($local_machine_path)
checker($current_user_path)