function SelectFromList { # Selects from List
    Begin {
        :CreateNumberedList while ($true) { # Outer loop for managing function
            $ObjectList = Get-Command # Gets a list
            $ObjectListNumber = 1 # $Var for setting $ObjectList.Number
            foreach ($_ in $ObjectList) { # For each item in $ObjectList
                $_ | Add-Member -NotePropertyName 'Number' -NotePropertyValue $ObjectListNumber # Adds number property to each item in list
                $ObjectListNumber = $ObjectListNumber + 1 # Increments $ObjectListNumber by 1
            } # End foreach ($_ in $ObjectList)
            Write-Host "0 Exit" # Write message to screen
            foreach ($_ in $ObjectList) { # Writes all objects to screen
                Write-Host $_.Number $_.Name # Writes list to screen
            } # End foreach ($_ in $ObjectList)
            :SelectFromList while ($true) { # Inner loop for selecting object from list
                $ObjectSelect = Read-Host "Please enter the number of the object" # Operator input for the selection
                if ($ObjectSelect -eq '0') { # If $ObjectSelect is 0
                    Break CreateNumberedList # Breaks :CreateNumberedList
                } # End if ($_Select -eq '0')
                $ObjectListSelect = $ObjectList | Where-Object {$_.Number -eq $ObjectSelect} # Isolates selected object 
                if ($ObjectListSelect) { # If $ObjectListSelect has a valud
                    Break SelectFromList # Breaks SelectFromList
                } # End if ($ObjectListSelect)
                Write-Host "That was not a valid selection" # Write message to screen 
            } # End :SelectFromList while ($true)
            $Object = Get-Command | Where-Object {$_.Property -eq $ObjectListSelect.property} # Can also use $Object = Get-Command -Name $ObjectListSelect.Name
            Return $Object # Returns $Object to calling function
        } # End :CreateNumberedList while ($true)
        Return # Returns with $null 
    } # End Begin
} # End function SelectFromList