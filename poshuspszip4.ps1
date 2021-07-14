#Code by Spencer
#7.14.2021
#Powerhsell Tool to utilize USPS Web Tools API for Zip+4 Information


#Collects Address Information
$USERID = Read-Host -Prompt "Enter the USPS Web Tools API UserID/Password"
$Address2 = Read-Host -Prompt "Street Address:"
$Address1 = Read-Host -Prompt "(optional) Street Address 2"
$City = Read-Host -Prompt "City"
$State =  Read-Host -Prompt "State"
$Zip5 =  Read-Host -Prompt "Zip+5"

#Adds Quotes around USERID - needed
$USERID = '"'+$USERID+'"'
# Must be 0 as per Docs
$addressID = '"0"'	
#Request Address
$r ="http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID=$USERID><Address ID=$addressID><Address1>$Address1</Address1><Address2>$Address2</Address2><City>$City</City><State>$State</State><Zip5>$Zip5</Zip5><Zip4></Zip4></Address></AddressValidateRequest>" 
$g = Invoke-WebRequest $r
#Pulls information from request by casting data as xml
Write-Host "`n Full Address with Zip+4:"
([xml]$g).AddressValidateResponse.Address
