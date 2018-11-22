# RootCert-checker
Script to check your installed root-certificates against a list (CSV) of trustetd ones.<br>
Source of uploaded csv file: https://gallery.technet.microsoft.com/Trusted-Root-Program-8895e873 <br>
Version: Oktober 30


i'm not very expirienced in powerhsell :) 
if you have recomendations -> feel free to contribute.



<hr>
Usage:
.\root_checker.ps1 <path_to_csv> <delimeter>
 
 Example:
.\root_checker.ps1 .\trusted_certs.csv ";"

<b>*Note</b>
If you state the wrong delimeter the script will tell you every installed cert is "untrust"
