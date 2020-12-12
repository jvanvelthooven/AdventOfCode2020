Function Get-Place {
  Param (
    $ticket
  )
  $rows = 0..127
  foreach ($char in $ticket[0..6]){
    $half = ($rows[-1] + $rows[0] + 1) / 2
    If ($char -eq 'B') {
      $rows = $half..$rows[-1]
    }
    Else {
      $rows = $rows[0]..($half - 1)
    }
  }
  $seats = 0..7
  foreach ($char in $ticket[7..9]){
    $half = ($seats[-1] + $seats[0] + 1) / 2
    If ($char -eq 'R') {
      $seats = $half..$seats[-1]
    }
    Else {
      $seats = $seats[0]..($half - 1)
    }
  }
  '' | select-object @{n='row';e={$rows}}, @{n='seat';e={$seats}}, @{n='nr';e={($rows[0] * 8 + $seats[0])}}
}
$content = get-content .\puzzle5input.txt
$content | foreach {Get-Place -ticket $_} | sort nr | select -Last 1
Compare-Object (1..812) ($content | foreach {Get-Place -ticket $_} | sort nr).nr