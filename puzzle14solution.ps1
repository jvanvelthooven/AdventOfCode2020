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
