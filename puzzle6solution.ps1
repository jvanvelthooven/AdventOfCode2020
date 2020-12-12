'1'
Foreach ($line in $content) {
  if($line -notmatch '^$') {
    [string]$groupLetters += $line
  }
  If ($line -match '^$' -or $line -eq $content[-1]) {
    $total += ($groupLetters.ToCharArray() | Sort-Object -Unique).count
    remove-variable groupLetters
  }
}
$total

'2'
Foreach ($line in $content) {
  if($line -notmatch '^$') {
    [string]$groupLetters += $line
    $members++
  }
  If ($line -match '^$' -or $line -eq $content[-1]) {
    $groups = $groupLetters.ToCharArray()
    Foreach ($letter in ($groups | Sort-Object -Unique)) {
      If (($groups | where-object {$_ -eq $letter}).count -eq $members) {
        $total++
      }
    }
    remove-variable groupLetters,members -erroraction silentlycontinue
  }
}
$total
