$limitations = get-content .\puzzle16input.txt | Where-Object {$_ -match ': '}
$myTicket = (get-content .\puzzle16input.txt | Where-Object {$_ -match ','})[0]
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
