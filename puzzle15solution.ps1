Function Add-NextStep {
  Param (
    $array
  )
  # reverse array
  [array]::Reverse($array)

  If (!$array[1..($array.length)].contains($array[0])) {
    $nextNr = 0
  }
  Else {
    # get location of the next same number
    $nextSame = [array]::IndexOf($array[1..($array.length)],$array[0])
    # next entry is the same
    If ($nextSame -eq 0) {
      $nextNr = 1
    }
    Else {
      # calculate the next nr based on the location of the previous same number
      $nextNr = ($array.length - ($array.length - ($nextSame + 1)))
    }
  }
  # reverse again
  [array]::Reverse($array)

  # return the new array
  Return ($array + ,$nextNr)
}
# Read content
$content = (get-content .\puzzle15input.txt).split(',') | ForEach-Object {[int]$_}
# calc first step
$next = Add-NextStep -array $content
# run until 2020th entry
While ($next.count -lt 2020){$next = Add-NextStep -array $next}
# show last
$next[-1]

'2'
Function Update-NextStep {
  Param (
    $data
  )
  # Get previous number
  $prev = $data.last

  # check if we already had this number
  If (!$data.$prev -or $data.$prev -eq 0) {
    # set next number to 0
    $data.last = 0
  }
  Else {
    # calculate next number
    $data.last = $data.length - $data.$prev
  }
  # set location of this number
  $data[$prev] = $data.length

  # increase size
  $data.length++
}


# Read content
$content = (get-content .\puzzle15input.txt).split(',') | ForEach-Object {[int]$_}

# create array for reuse
$data = @{}

# add last
$data['last'] = $content[-1]

# add length
$data['length'] = $content.length

# Add all content but last
For ($step = 0;$step -lt ($content.count - 1);$step++) {
  $data[$content[$step]] = $step + 1
}

# run until 2020th entry
While ($data.length -lt 2020){Update-NextStep -data $data}

# show last
$data.last
