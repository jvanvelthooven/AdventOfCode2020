# function to change memory based on mask
Function Set-Memory {
  Param (
    $value,
    $mask
  )
  $newValue = $mask.ToCharArray()
  # Run through binary
  For ($nr = ($value.length);$nr -gt 0;$nr--) {
    If ($newValue[-$nr] -eq 'x') {
      $newValue[-$nr] = $value[-$nr]
    }
  } 
  # write to memory
  ($newValue -join('')).replace('X',0)
}

# Function to run program
Function Get-Program {
  Param (
    $content
  )
  
  # initialize mem
  $mem = @{}

  # Run through program
  Foreach ($line in $content) {
    # split line
    $line = $line -split(' = ')
  
    # Check type
    If ($line[0] -eq 'mask') {
      $mask = $line[1]
    }
    Else {
      # get location
      $memLocation = $line[0].split('[]')[1]
      
      # write data
      $binary = [convert]::ToString($line[1],2)
      
      # write to memory
      $mem[$memLocation] = Set-Memory -mask $mask -value $binary
    }
  }
  # calculate sums of memory
  ($mem.values | ForEach-Object {[convert]::ToInt64($_,2)} | Measure-Object -Sum).Sum
}
  
# read input
$content = get-content .\puzzle14input.txt

# Run program
Run-Program -content $content

'2'
# Function to get all possible memory locations
Function Get-MemoryAddress {
  Param (
    $array,
    $char
  )
  #write-host "array: $array"
  # Check if we got an array with a floating bit
  If ($array -contains($char)) {
    # get the first x
    $nr = $array.IndexOf($char)

    # create new array with replacement of first x with 0
    $new0 = For ($nr2 = 0;$nr2 -lt $array.length;$nr2++) {
      If ($nr2 -eq $nr) {
        '0'
      }
      Else {
        $array[$nr2]
      }
    }
    # run against function again
    Get-MemoryAddress $new0 -char $char

    # create new array with replacement of first x with 0
    $new1 = For ($nr2 = 0;$nr2 -lt $array.length;$nr2++) {
      If ($nr2 -eq $nr) {
        '1'
      }
      Else {
        $array[$nr2]
      }
    }
    # run against function again
    Get-MemoryAddress $new1 -char $char
  }
  Else {
    # return joined array
    $array -join('')
  }
}

Function Get-MemoryAddressLocation {
  Param (
    $value,
    $mask
  )
  # write data
  $binary = ([int64][convert]::ToString($value,2)).ToString('000000000000000000000000000000000000')

  # create replacement
  $newMask = $mask.ToCharArray()

  # Run through binary
  For ($nr = 0;$nr -lt $binary.length;$nr++) {
    If ($newMask[$nr] -eq '1') {
      $newMask[$nr] = '1'
    }
    ElseIf ($newMask[$nr] -eq 'X') {
      $newMask[$nr] = 'X'
      $charNr = $nr
    }
    ElseIf ($binary[$nr] -eq '1') {
      $newMask[$nr] = '1'
    }
    Else {
      $newMask[$nr] = '0'
    }
  }

  # get all addresses
  Get-MemoryAddress -array $newMask -char $newMask[$charNr]
}

# Function to run program
Function Get-ProgramOutput {
  Param (
    $content
  )
  
  # initialize mem
  $mem = @{}

  # Run through program
  Foreach ($line in $content) {
    # split line
    $line = $line -split(' = ')
  
    # Check type
    If ($line[0] -eq 'mask') {
      $mask = $line[1]
    }
    Else {      
      # convert
      #$binary = [convert]::ToString($line[1],2)

      # get location
      $memLocation = Get-MemoryAddressLocation -Value $line[0].split('[]')[1] -mask $mask
      
      # write to memory
      Foreach ($memloc in $memLocation) {
        $mem[$memloc] = $line[1]
      }
    }
  }
  # calculate sums of memory
  ($mem.values  | Measure-Object -Sum).Sum
}
   
# read input
$content = get-content .\puzzle14input.txt

# Run program
Get-ProgramOutput -content $content
