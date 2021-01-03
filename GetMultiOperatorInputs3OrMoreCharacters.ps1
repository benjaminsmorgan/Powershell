Function GetMultiOperatorInputs3OrMoreCharacters {
    Begin {
        :LoopAboveValidatingInputLoop while($True) {
            :ValidatingInputLoop while($True) {
                Try { # Validation of characters
                    [ValidatePattern('^[a-z,0-9,\s]+$')]$OperatorInput = [string](Read-Host "Operator Input").ToLower() # Allows for input of any Letters, Numbers, and spaces (Converts upper to lower)
                } # End Try 
                catch { # Catch for failing validation
                    Write-Host "The provided inputs were not valid, accepted inputs are letters and numbers only" # Write message to screen
                    $OperatorInput = '0' # Sets $OperatorInput to '0'
                } # End Catch
                if ($OperatorInput -ne '0') {
                    $OperatorInputSplit = $OperatorInput.split() # Creates $OperatorInputSplit, a list of names for each space in $OperatorInput
                    foreach ($_ in $OperatorInputSplit) { # Performs length check on all names in list
                        if ($_.length -le 2) { # If $OperatorInput.listitem is 2 or less charaters
                            Write-Host $_ "is not a valid input" # Write message to screen
                            $OperatorInput = '0'# Sets $OperatorInput value to a failed check to reset loop
                            $OperatorInputSplit = $null # Sets $OperatorSplit to $null
                        } # End if ($_.length -le 2)
                    } # End foreach ($_ in $OperatorInputSplit)
                } # End if ($OperatorInput -ne '0')
                if ($OperatorInput -eq '0') { # If $OperatorInput is 0 (failed check)
                    Write-Host " " # Writes a message to screen, last action before restarting loop
                } # End if ($OperatorInput -eq '0')
                elseif ($OperatorInput.Length -le 2) { # If $OperatorInput is less than 3 characters
                    Write-Host "The input is invalid, the minimum length of a inout is 3 characters" # Write message to screen, Last action before restarting loop
                } # End elseif ($OperatorInput.Length -le 2)
                else { # Inital validation checks passed, performing secondary validation
                    if ($OperatorInput -eq 'exit') { # If $OperatorInput equals exit
                        Break LoopAboveValidatingInputLoop # Breaks :LoopAboveValidatingInputLoop
                        } # End if ($OperatorInput -eq 'exit')
                    if ($OperatorInputSplit.count -gt 1) { # If $OperatorSplit has more than one value
                        Write-Host "Use the following operator inputs" # Write message to screen
                        Write-Host $OperatorInputSplit -Separator `n # Writes all inputs to screen
                    } # End if ($OperatorSplit.count -gt 1)
                    else { # If $OperatorSplit has 1 value
                        Write-Host "User this input"$OperatorInput # Write message to screen
                        $OperatorInputSplit = $null  # Sets $OperatorInputSplit to $null
                    } # End else (if ($OperatorInputSplit.count -gt 1))
                    $OperatorConfirm = Read-Host "Yes or No" # Operator approval of input
                    if ($OperatorConfirm -eq 'y' -or $OperatorConfirm -eq 'yes') { # If $OperatorConfirm is equal to 'y' or 'yes'
                        $OperatorValue = $OperatorInput
                        Break ValidatingInputLoop # Breaks :ValidatingInputLoop
                    } # End if ($OperatorConfirm -eq 'y' -or $OperatorConfirm -eq 'yes')
                } # End else (if ($OperatorInput -eq '0'))
            } # End :ValidatingInputLoop while($True)
            Return $OperatorValue
        } # End :LoopAboveValidatingInputLoop while($True)
    Return # Returns empty values
    } # End Begin
} # End Function GetMultiOperatorInputs3OrMoreCharacters