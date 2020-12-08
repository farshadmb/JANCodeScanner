# JANCodeScanner
scanner framework for JANCode

- put a view in Xib or Story Board 
- change the class of the View to "ScannerView"
- set that view Delegate as "scannerViewDelegate"
- with the function  "scanResult" you will get the code from BarCode scanner as String 
-  if there was a problem with scanning the function "scanFailed" will be execute and you can handle showing errors to the user 
