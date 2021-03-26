Function ESDWalkUPSignIn {
    Begin {
        :Loop1 while ($true) {
            $SigninSheetPath = 'C:\users\Benja\Documents\Test.csv'
            $ListNumber = 1
            [System.Collections.ArrayList]$SignInSheet = @()
            :Loop2 while ($true) {
                
                :Loop3 while ($true) {
                    $EmailAddress = Read-Host 'Please Enter your email address'
                    $Fname = Read-Host 'First Name'
                    $Lname = Read-Host 'Last Name'
                    $Issue = Read-Host "Please provide a summary of issue"
                    $Ctime = Get-Date
                    $Stime = ''
                    $Dtime = ''
                    $ListInput = [PSCustomObject]@{'Number'=$ListNumber;'Email'=$EmailAddress; `
                        'Fname'=$Fname;'Lname'=$Lname;'Ctime'=$Ctime;'stime'= `
                        $stime;'dtime'=$dtime;'Issue'=$issue}                            # Adds info to $ListInput   
                    $SignInSheet.Add($ListInput) | Out-null 
                    $SignInSheet | Export-Csv -Path $SigninSheetPath -Append
                    $SignInSheet = $null
                    $SignInSheet = @()
                    $ListNumber = $ListNumber + 1
                    Break Loop3
                }
            }
        }
    }
}