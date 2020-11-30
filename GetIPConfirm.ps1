function GetIPConfirm {
    Begin {
        $PCName = Read-Host "PC Name"
        $IPAddress = [System.Net.Dns]::GetHostAddresses($PCName) | Select-Object IPAddressToString
        $IPAddress
        $NSLookupName = nslookup $IPAddress | Select-Object Name 
        $NSLookupName
        if ($PCName -ne $NSLookupName) {
            Write-Host "DNS has not been updated with the current IP Address"
        }
        else {
            $PCName
            $IPAddress
            $NSLookupName
        }
    }
}