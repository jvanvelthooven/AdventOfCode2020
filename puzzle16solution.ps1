$limitations = get-content .\puzzle16input.txt | Where-Object {$_ -match ': '}
$myTicket = (get-content .\puzzle16input.txt | Where-Object {$_ -match ','})[0].split(',') | ForEach-Object {[int]$_}
$tickets = (get-content .\puzzle16input.txt | Where-Object {$_ -match ','})[1..300]

# get allowed numbers
$allowedNumbers = $limitations | ForEach-Object {$split = $_.split(':')[1].split(' -');$split[1]..$split[2];$split[4]..$split[5]} | Sort-Object -Unique

# run through all tickets
$invalid = Foreach ($ticket in $tickets) {
  # convert to numbers in array
  $ticket = $ticket.split(',') | ForEach-Object {[int]$_}

  # check if ticket is valid
  $ticket | Foreach-Object {
    If (!$allowedNumbers.contains($_)) {
      $_
    }
  }
}

# calculate sum
$invalid | Measure-Object -Sum

'2'
# remove invalid tickets and convert to arrays
$validTickets = $tickets | Where-Object {
  # convert to numbers in array
  $ticket = $_.split(',') | ForEach-Object {[int]$_}

  # check if ticket is valid
  ($ticket | Where-Object {$allowedNumbers.contains($_)}).count -eq $ticket.count
} | ForEach-Object {,$_.split(',')}

# add fields to array of array
$fields = Foreach ($limitation in $limitations) {
  # name is first entry of the array
  $name = ($limitation -split(': '))[0]
  # the numbers is the 2nd
  $numbers = $limitation | ForEach-Object {$split = $_.split(':')[1].split(' -');$split[1]..$split[2];$split[4]..$split[5]} | Sort-Object -Unique
  # return the array for the collection of arrays
  ,($name,$numbers)
}

# Loop until we found all three departures
While ($dep.count -lt 6) {
  # check all rows
  For ($columnNr = 0;$columnNr -lt ($myTicket.length - 1);$columnNr++) {
    # Check if we already have this row
    If ($myTicket[$columnNr] -ne 'x') {
      # get column
      $column = $validTickets | ForEach-Object {$_[$columnNr]}

      # match to field
      $key = $fields | Where-Object {
        $key = $_
        ($column | Where-Object {$key[1].contains($_)}).count -eq $column.count
      }

      # Check if we got a single match
      If ($key[0][0] -notmatch '[a-z]{2}') {
        # remove from fields
        $fields = $fields | Where-Object {$_[0] -ne $key[0]}
        
        # see if it starts with the given word
        If ($key[0] -match '^departure') {
          $dep += ,$columnNr
        }

        # mark as done
        $myTicket[$columnNr] = 'x'

        # break
        break
      }
    }
  }
}

# Rebuild my ticket as I broke it with my x's
$myTicket = (get-content .\puzzle16input.txt | Where-Object {$_ -match ','})[0].split(',') | ForEach-Object {[int]$_}

# sum
$sum = 1;$dep | ForEach-Object {$sum *= $myTicket[$_]}

# answer
$sum