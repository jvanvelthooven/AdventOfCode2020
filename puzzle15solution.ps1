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
While ($next.count -ne 2020){$next = Add-NextStep -array $next}
# show last
$next[-1]

'2'