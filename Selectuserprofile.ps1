function SelectUserprofile {                                                                                    # Function name
    Begin {                                                                                                     # Begin function
        :GetUserprofile while ($true) {                                                                         # This creates a named loop
            $path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*'   # Set a path
            $UserList = Get-ItemProperty -Path $path | Select-Object -Property PSChildName, ProfileImagePath    # Create a list
            $UserListNumber = 1                                                                                 # An input for the list
            [System.Collections.ArrayList]$UserArray=@()                                                        # Creates an array for loading data into
            foreach ($_ in $UserList) {                                                                         # For each item in $UserList
                $Name = $_.ProfileImagePath                                                                     # ProfileImagePath is a dirty entry, we are isloating it here
                $Name = $Name.Split('\')[-1]                                                                    # Using split on '\' and selecting the last item with -1
                $ArrayInput = [PSCustomObject]@{                                                                # PS custom object where we load the things we want 'number, name and sid'
                    'Num' = $UserListNumber; 'name' = $Name; 'SID' = $_.PSChildName                             # 'number, name and sid'
                }                                                                                               
                $UserArray.Add($ArrayInput) | Out-Null                                                          # Add it to the array
                $UserListNumber = $UserListNumber + 1                                                           # Add 1 to our list number
            }
            Write-Host '[ 0 ] Exit'                                                                             # Writing it to the screen
            Write-Host '' 
            foreach ($_ in $UserArray) {                                                                        # For each item in user array
                Write-Host '['$_.Num']'
                Write-Host 'Name: '$_.Name
                Write-Host 'SID:  '$_.Sid
                Write-Host ''
            }
            :SelectUserProfile while ($true) {                                                                  # A Sub loop
                $UserSelect = Read-Host 'User [#]'                                                              # Your input to select the account
                if ($UserSelect -eq '0') {                                                                      # If your input is '0'
                    Break GetUserprofile                                                                        # Breaks the outer named loop
                }
                elseif ($UserSelect -in $UserArray.Num) {                                                       # If your number is in the array.num field
                    $UserObject = $UserArray | Where-Object {$_.Num -eq $UserSelect}                            # this new $var is the item in the userarray where the user selection equals the num
                    Return $UserObject                                                                          # Returns the $var to a calling function or screen
                }
                else {                                                                                          # if the user input did not match
                    Write-Host 'That was not a valid selection'                                                 # As there is no exit function for the inner loop, this will go back to the top of :SelectUserProfile
                }
            }
        }
    }
}