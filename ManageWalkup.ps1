function ManageWalkup {
    Begin {
        $LocalSignInSheetPath = 'C:\users\Benja\Documents\Test2.csv'
        #$LocalSignInsheet = Import-Csv -path $LocalSignInSheetPath
        $SigninSheetPath = 'C:\users\Benja\Documents\Test.csv'
        $SignInSheetTemp = Import-Csv -path $SigninSheetPath
        [System.Collections.ArrayList]$SignInSheet = @()
        Write-Host 'Import the previous working sheet'
        $UserConfirm = Read-Host '[Y] or [N]'
        if ($UserConfirm -eq 'y') {
            $LocalSignInSheetTemp = Import-Csv -path $LocalSignInSheetPath
            foreach ($_ in $LocalSignInSheetTemp) {
                $ListInput = [PSCustomObject]@{'Number'=$_.Number;'Email'=$_.Email; `
                    'Fname'=$_.Fname;'Lname'=$_.Lname;'Ctime'=$_.Ctime;'stime'= `
                    $_.stime;'dtime'=$_.dtime;'Issue'=$_.issue}                            # Adds info to $ListInput   
                $SignInSheet.Add($ListInput) | Out-Null                                   # Loads content of $ListInput into $ListArray
            }
        }
        foreach ($_ in $SignInSheetTemp) {
            $ListInput = [PSCustomObject]@{'Number'=$_.Number;'Email'=$_.Email; `
                'Fname'=$_.Fname;'Lname'=$_.Lname;'Ctime'=$_.Ctime;'stime'= `
                $_.stime;'dtime'=$_.dtime;'Issue'=$_.issue}                            # Adds info to $ListInput   
            $SignInSheet.Add($ListInput) | Out-Null                                   # Loads content of $ListInput into $ListArray
        }
        Remove-Item -Path $SigninSheetPath
        $SignInSheet | Export-CSV -path $LocalSignInSheetPath
        :ManageWalkUpLoop while ($true) {
            Write-Host '[1] Wait for new check-ins'
            Write-Host '[2] Pull oldest check-in'
            Write-Host '[3] Complete walk up'
            $OptionSelect = Read-Host '[#]'
            if ($OptionSelect -eq '1') {
                :WaitfornewCheckins while ($true) {
                    if (Test-Path -Path $SigninSheetPath) {
                        Write-Host 'There is a new check in available'
                        $SignInSheetTemp = Import-Csv -path $SigninSheetPath
                        foreach ($_ in $SignInSheetTemp) {
                            $ListInput = [PSCustomObject]@{'Number'=$_.Number;'Email'=$_.Email; `
                                'Fname'=$_.Fname;'Lname'=$_.Lname;'Ctime'=$_.Ctime;'stime'= `
                                $_.stime;'dtime'=$_.dtime;'Issue'=$_.issue}                            # Adds info to $ListInput   
                            $SignInSheet.Add($ListInput) | Out-Null                                   # Loads content of $ListInput into $ListArray
                        }
                        $SignInSheet | Export-CSV $LocalSignInSheetPath
                        Remove-Item -Path $SigninSheetPath
                        Break WaitfornewCheckins
                    } # End if ($SignInSheetLastModCheck -ne $SignInSheetLastMod)
                    else {
                        $PendingCheckins = $SignInSheet | Where-Object {$_.Dtime -eq ''}
                        if ($PendingCheckins.count -gt 0) {
                            Write-Host 'There are uncompleted walk ups'
                            Break WaitfornewCheckins
                        } # End if ($PendingCheckins.count -gt 0)
                        else {
                            Write-Host 'No new check ins'
                            Start-Sleep (30)
                        }
                    }
                } # End :WaitfornewCheckins while ($true)
            }
            elseif ($OptionSelect -eq '2') {
                :SelectNewCheckin while ($true) {
                    $Currentneedhelp = $SignInSheet | Where-Object {$_.Stime -eq ''}
                    foreach ($_ in $Currentneedhelp) {
                        Write-Host $_.Number $_.FName $_.LName
                    } # End foreach ($_ in $Currentneedhelp)
                    $CurrentUser = Read-Host 'Enter [#] of user'
                    if ($CurrentUser -eq '0') {
                        Break SelectNewCheckin
                    }
                    if ($CurrentUser -in $Currentneedhelp.Number) {
                        $CurrentUserinfo = $Currentneedhelp | Where-Object {$_.Number -eq $CurrentUser}
                        $SignInSheet | Foreach {if($_.Number -eq $CurrentUser){$_.Stime =Get-Date}}
                        $signinSheet | Export-CSV -Path $LocalSignInSheetPath
                        Write-Host $CurrentUserinfo.Email 'Has been marked as being helped'
                        Break SelectNewCheckin
                    }
                    else {
                        Write-Host 'That was not a valid input'
                    }
                }
            }
            elseif ($OptionSelect -eq '3') {
                :CompleteWalkUp while ($true) {
                    $Currentneedhelp = $SignInSheet | Where-Object {$_.Dtime -eq '' -and $_.Stime -ne ''} 
                    foreach ($_ in $Currentneedhelp) {
                        Write-Host $_.Number $_.FName $_.LName
                    } # End foreach ($_ in $Currentneedhelp)
                    $CurrentUser = Read-Host 'Enter [#] of user'
                    if ($CurrentUser -eq '0') {
                        Break CompleteWalkUp
                    }
                    if ($CurrentUser -in $Currentneedhelp.Number) {
                        $CurrentUserInfo = $Currentneedhelp | Where-Object {$_.Number -eq $CurrentUser}
                        $SignInSheet | Foreach {if($_.Number -eq $CurrentUser){$_.Dtime =Get-Date}}
                        $signinSheet | Export-CSV -Path $LocalSignInSheetPath
                        Write-Host $CurrentUserInfo.Email 'Has been marked as completed'
                        Break CompleteWalkUp
                    }
                    else {
                        Write-Host 'That was not a valid input'
                    }
                }
            } # End elseif ($OptionSelect -eq '3')
            elseif ($OptionSelect -eq '4') {
                Write-Host 'Are you sure you want to close out the queue as is'
                $UserConfirm = Read-Host '[Y] or [N]'
                if ($UserConfirm -eq 'y') {
                    $CurrentTime = Get-Date
                    $FullSavePath = 'C:\users\benja\Documents\Test'+$currentTime
                    $SignInSheet | Export-CSV -Path $FullSavePath
                    Break ManageWalkUpLoop
                } # End if ($UserConfirm -eq 'y')
            } # End elseif ($OptionSelect -eq '4')
        }
    } # End Begin
} # End ManageWalkUp