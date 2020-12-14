Function Get-13fromFirstBus {
  Param (
    $content
  )
  # current time
  $time = $content[0]
  # bus ids
  $ids = $content[1].split(',') | Where-Object {$_ -ne 'x'}
  # run through busses and create schedule for next run
  $schedule = Foreach ($id in $ids) {
    # calculate next time and return in combination with busid
    [PSCustomObject]@{id=[int]$id;next=([math]::Floor($time / $id) + 1) * $id}
  }
  # grab first 
  $bus = $schedule | Sort-Object next | Select-Object -First 1
  # calculate answer
  $bus.id * ($bus.next - $time)
}
# read content
$content = get-content .\puzzle13input.txt
# get me the answer
Get-13fromFirstBus -content $content

'2'
# Change data to only include filled schedules and include step difference
Function Get-FilledSteps {
  Param (
    $data
  )
  # Create table of known ids and empty steps between
  $x = 0
  $filledSteps = Foreach ($id in $data.split(',')) {
    If ($id -ne 'x') {
      [PSCustomObject]@{id=[int]$id;step=$x}
    }
    $x++
  }

  # sort by size
  $filledSteps | Sort-Object id -Descending
}

Function Get-TimeTable {
  Param (
    $data,
    $counter,
    [switch]$debug
  )
  
  # Get filled steps
  $filledSteps = Get-FilledSteps -data $data

  # keep on running till we find the answer
  While (!$found) {
    If ($debug) {
      write-host $counter
    }
    # up counter
    $counter++
    # run through all steps, sorting is based on largest schedule
    for ($idCounter = 1;$idCounter -lt $filledSteps.count;$idCounter++) {
      If ($debug) {
        (($filledSteps[0].id * $counter - $filledSteps[0].step + $filledSteps[$idCounter].step) / $filledSteps[$idCounter].id)
      }
      # if the next schedule is not an integer it does not match
      If ((($filledSteps[0].id * $counter - $filledSteps[0].step + $filledSteps[$idCounter].step) / $filledSteps[$idCounter].id) -isnot [int64]) {
        # blergh
        $idCounter = $filledSteps.count
      }
      # check if this is the last schedule, yay, we found it
      ElseIf ($idCounter -eq ($filledSteps.count - 1)) {
        $found = $true
      }
    }
  }
  # calculate actual time from largest schedule and step
  $filledSteps[0].id * $counter - $filledSteps[0].step
}

# read content
$content = get-content .\puzzle13input.txt
# get me the answer
Get-TimeTable -data $content[1]

# precalculate counter from answer
$counter = (906332393333683 - 17) / 983
# verify my function from answer from other code (See below)
Get-TimeTable -data $content[1] -counter $counter






# Shameless steal of someone else' code. Needs investigation.
$t,$c=($content)-split','|?{$_}
$b=$c|%{$_-as[int]}
($b|sort($s={($_-$t%$_)%$_}))[0]|%{$_*(&$s)}

$a=$ao=1
for($i=0; $c[$i]; $i++) {
  if($c[$i] -eq 'x') { continue }
  $b=$c[$i]
  $bo=$i

  $aa=($a-$ao)%$a
  $bb=($b-$bo)%$b

  $p = $null
  for() {
    if($aa -lt $bb) {
      $aa += [math]::Ceiling(($bb-$aa)/$a)*$a
    }else{
      $bb += [math]::Ceiling(($aa-$bb)/$b)*$b
    }
    if($aa -eq $bb) {
      if($p -ne $null) {
        $a,$ao=($aa-$p), (($aa-2*$p)%($aa-$p)); break;
      } else {
        $p = $aa; $aa+=$a; $bb+=$b;
      }
    }
  }
}
$p
