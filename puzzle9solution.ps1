$content = get-content .\puzzle9input.txt | ForEach-Object {[int64]$_}
$steps = 25
$counter = $steps
Foreach ($nr in $content[$steps..($content.length - 1)]) {
  remove-variable found -ErrorAction SilentlyContinue
  Foreach ($possible1 in $content[($counter - $steps)..($counter - 1)]) {
    Foreach ($possible2 in $content[($counter - $steps)..($counter - 1)]) {
      If ($possible1 -eq $possible2) {
        Continue
      }
      If (($possible1 + $possible2) -eq $nr) {
        $found = $true
      }
    }
  }
  If (!$found) {
    $nr
    break
  }
  
  $counter++
}

'2'
$nrToBeFound = 1309761972
$content = get-content .\puzzle9input.txt | ForEach-Object {[int64]$_}
Foreach ($nr in $content) {
  $counter2 = 0
  While ($count -lt $nrToBeFound) {
    $count += $content[$counter2]
    $nrs += ,$content[$counter2]
    $counter2++
  }
  If ($count -eq $nrToBeFound) {
    ($nrs | Sort-Object)[0] + ($nrs | Sort-Object)[-1]
    break
  }
  $counter1++
}
