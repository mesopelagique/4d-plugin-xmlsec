//%attributes = {"invisible":true}
/*

sign - add template

*/

$dsig_id:="xmldsig-"+generate_lowercase_uuid 

$params:=New object:C1471
$params.xmldsig:=New object:C1471

  //Signature, SignedInfo
$params.xmldsig.ns:="dsig"
$params.xmldsig.id:=$dsig_id

  //CanonicalizationMethod
$params.xmldsig.c14n:="1.0"

  //SignatureMethod
$params.xmldsig.sign:="rsa-sha256"

  //when the xml does not contain a template, one is created according to xmldsig params

  //Reference
$ref_id:="reference-"+generate_lowercase_uuid 
$params.xmldsig.digest:="sha1"
$params.xmldsig.ref:=New object:C1471
$params.xmldsig.ref.id:=$ref_id
$params.xmldsig.ref.type:="http://www.w3.org/2000/09/xmldsig#Object"

  //pass an array of X509 certificates

$rsacert:=Folder:C1567(fk resources folder:K87:11).file("rsacert.pem")

ARRAY BLOB:C1222($certBLOBs;1)
$certBLOBs{1}:=$rsacert.getContent()

If (True:C214)  //optional
	
	  //KeyInfo
	$key_id:="keyInfo-"+generate_lowercase_uuid 
	$params.xmldsig.keyInfo:=New object:C1471
	$params.xmldsig.keyInfo.id:=$key_id
	
End if 

$doc:=Folder:C1567(fk resources folder:K87:11).folder("xmldsig_sign").file("sign-doc.xml")
$rsakey:=Folder:C1567(fk resources folder:K87:11).file("rsakey.pem")

$params.xml:=$doc.getText()
$keyBLOB:=$rsakey.getContent()

$status:=xmlsec sign ($params;$keyBLOB;$certBLOBs)

ASSERT:C1129($status.success)

$xml:=$status.xml

SET TEXT TO PASTEBOARD:C523($xml)