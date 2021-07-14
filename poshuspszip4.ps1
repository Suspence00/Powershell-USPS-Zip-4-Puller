#Code by Spencer
#7.14.2021
#Powerhsell Tool to utilize USPS Web Tools API for Zip+4 Information
# 1. Validates address via Web Request
# 2. Queries for Zip4 based on validated information

# User must obtain a valid User ID for USPS's Web Tools API by registering through USPS's website. 
# Information for that can be found here: https://www.usps.com/business/web-tools-apis/
$USERID = ""

#Enter Address Information
#Note: Address2 is the main street address, Address1 is the Suite/Apartment
$Address2 = "211 NE Revere Ave" 
$Address1 = ""
$City = "Bend"
$State = "OR"
$Zip5 = "97701"

# Adds Quotes around USERID - needed or it breaks. Also checks to make sure it's not blank.
if ($USERID -eq ""){
	Write-Host "No User ID Provided, please modify script before running" -ForegroundColor Red
	break;}
	
$USERID = '"'+$USERID+'"'

#Sets Address ID - Needed
$addressID = '"0"'

# Request Address
$validateRequestURI ="https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID=$USERID><Address ID=$addressID><Address1>$Address1</Address1><Address2>$Address2</Address2><City>$City</City><State>$State</State><Zip5>$Zip5</Zip5><Zip4></Zip4></Address></AddressValidateRequest>" 
$validatedAddress = Invoke-WebRequest $validateRequestURI

# Modifies variables to validated data 
$Address2 = ([xml]$validatedAddress).AddressValidateResponse.Address.Address2
$Address1 = ([xml]$validatedAddress).AddressValidateResponse.Address.Address1
$City = ([xml]$validatedAddress).AddressValidateResponse.Address.City
$State = ([xml]$validatedAddress).AddressValidateResponse.Address.State
$Zip5 = ([xml]$validatedAddress).AddressValidateResponse.Address.Zip5

# Zip4 API request
$zip4URI ="https://secure.shippingapis.com/ShippingAPI.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest USERID=$USERID><Address ID=$addressID><Address1>$Address1</Address1><Address2>$Address2</Address2><City>$City</City><State>$State</State><Zip5>$Zip5</Zip5><Zip4></Zip4></Address></ZipCodeLookupRequest>" 
$zip4Request = Invoke-WebRequest $zip4URI	
$zip4 = ([xml]$zip4Request).ZipCodeLookupResponse.Address.Zip4

# Final output
Write-Host "The address has been Validated, pulling Zip+4..."  -ForegroundColor Blue
Write-Host "Full Inforomation:" -ForegroundColor Blue
Write-Host "Address 1: $Address2" -ForegroundColor Yellow
Write-Host "Address 2: $Address1" -ForegroundColor Yellow
Write-Host "City: $City" -ForegroundColor Yellow
Write-Host "State 2: $State" -ForegroundColor Yellow
Write-Host "Zip5 2: $Zip5" -ForegroundColor Yellow
Write-Host "Zip4: $Zip4" -ForegroundColor Green
