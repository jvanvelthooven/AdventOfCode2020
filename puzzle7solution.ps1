$data = get-content puzzle7input.txt | foreach-object {
  $split = ($_ -replace(' bags*\.*')) -split(' contain ')
  If ($split[1] -eq 'no other') {
    $bags = $false
  }
  Else {
    $bags = ($split[1] -split(', ')) | foreach-object {
      @{($_.split(' ')[1..9] -join(' '))=$_.split(' ')[0]}
    }
  }
  @{$split[0].replace(' bags','')=$bags}
}

$shinyGold = $data | where-object {$_.values.keys -eq 'shiny gold'}
$bags = $shinyGold
remove-variable counter2
$counter1 = $bags.count
While ($counter1 -ne $counter2) {
  $counter1 = $bags.count
  Foreach ($bag in $bags.keys) {
    $bags += $data | where-object {$_.values.keys -eq $bag}
  }
  $bags = $bags | sort keys -Unique
  $counter2 = $bags.count
}

'2'
$data = @{}
get-content puzzle7input.txt | foreach-object {
  $split = ($_ -replace(' bags*\.*')) -split(' contain ')
  If ($split[1] -eq 'no other') {
    $bags = 'none'
  }
  Else {
    $bags = ($split[1] -split(', ')) | foreach-object {
      Foreach ($bag in 1..($_.split(' ')[0])) {
        $_.split(' ')[1..9] -join(' ')
      }
    }
  }
  $data.add($split[0].replace(' bags',''),$bags)
}

Function Get-AllBags {
  Param (
    $bag
  )
  If ($bag -eq 'none') {
    Return
  }
  $bag | Foreach-Object {
    Get-AllBags -bag $data.$_
  }
  $bag
}
(Get-AllBags -bag $data.'shiny gold').count