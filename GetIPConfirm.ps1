function GetIPConfirm {
    Begin {
        $PCName = Read-Host "PC Name"
        $IPAddress = [System.Net.Dns]::GetHostAddresses($PCName) | Select-Object IPAddressToString
        $IPAddress
        $NSLookupName = nslookup $IPAddress | Select-Object Name 
        $NSLookupName
    }
}