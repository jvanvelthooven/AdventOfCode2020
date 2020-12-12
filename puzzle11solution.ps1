Function Update-Seats {
  Param (
    $seats
  )

  # set columns
  $cols = $seats.count
  # set rows
  $rows = $seats[0].length
  # create matching grid
  $grid = New-Object 'object[,]' $seats.count,$seats[0].length
  # create object for 8 neighboars
  $neighbours = (-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)
  
  # update grid to match input
  $counter1 = 0
  Foreach ($line in $seats) {
    $line = $line.ToCharArray()
    $counter2 = 0
    Foreach ($seat in $line) {
      Switch ($seats[$counter1][$counter2]) {
        '.' {
          $grid[$counter1,$counter2] = '.'
        }
        'L' {
          $grid[$counter1,$counter2] = 'L'
        }
        '#' {
          $grid[$counter1,$counter2] = '#'
        }
      }
      $counter2++
    }
    $counter1++
  }

  # run through all seats and update output with rules. Want to keep it visual so setting output to lines
  for ($col = 0;$col -lt $cols;$col++) {
    for ($row = 0;$row -lt $rows;$row++) {
      Switch ($grid[$col,$row]) {
        # no change, update line
        '.' {
          $showLine += '.'
        }
        # based on empty chair rules
        'L' {
          # read filled neighboars
          $nb = $neighbours | Where-Object {
            If (($col + $_[0]) -ge 0 -and ($row + $_[1]) -ge 0) {
              $grid[($col + $_[0]),($row + $_[1])] -eq '#'
            }
          }
          # no filled neighboars ,occupy seat 
          If (!$nb) {
            $showLine += '#'
            $seatsChanged = $true
          }
          # neighbour found, keep empty
          Else {
            $showLine += 'L'
          }
        }
        # based on filled chair rules
        '#' {
          # read filled neighboars
          $nb = $neighbours | Where-Object {
            If (($col + $_[0]) -ge 0 -and ($row + $_[1]) -ge 0) {
              $grid[($col + $_[0]),($row + $_[1])] -eq '#'
            }
          }
          # neighboars above threshold, change to empty
          If ($nb.count -ge 4) {
            $showLine += 'L'
            $seatsChanged = $true
          }
          # below threshold can keep chair filled
          Else {
            $showLine += '#'
          }
        }
      }
    }
    # add to multiline output
    $showAll += ,$showLine
    # clean variable
    remove-variable showLine
  }
  # show output if we changed
  If ($seatsChanged) {
    $showAll
  }
  # no change, count number of filled chairs
  Else {
    (($showAll -join '').ToCharArray() | Where-Object {$_ -eq '#'}).count
  }
}
# initial from input
$next = Update-Seats -seats (get-content .\puzzle11input.txt)
# loop through changes and report number of chairs
While ($next -isnot [int]){$next = Update-Seats -seats $next}
$next

'2'
Function Update-Seats2 {
  Param (
    $seats
  )

  # set columns
  $cols = $seats.count
  # set rows
  $rows = $seats[0].length
  # create matching grid
  $grid = New-Object 'object[,]' $seats.count,$seats[0].length
  # create object for 8 neighboars
  $neighbours = (-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)
  
  # update grid to match input
  $counter1 = 0
  Foreach ($line in $seats) {
    $line = $line.ToCharArray()
    $counter2 = 0
    Foreach ($seat in $line) {
      Switch ($seats[$counter1][$counter2]) {
        '.' {
          $grid[$counter1,$counter2] = '.'
        }
        'L' {
          $grid[$counter1,$counter2] = 'L'
        }
        '#' {
          $grid[$counter1,$counter2] = '#'
        }
      }
      $counter2++
    }
    $counter1++
  }

  # run through all seats and update output with rules. Want to keep it visual so setting output to lines
  for ($col = 0;$col -lt $cols;$col++) {
    for ($row = 0;$row -lt $rows;$row++) {
      Switch ($grid[$col,$row]) {
        # no change, update line
        '.' {
          $showLine += '.'
        }
        # based on empty chair rules
        'L' {
          # read filled in sight
          $chairs = Foreach ($nb in $neighbours) {
            $counter = 1
            remove-variable done -erroraction silentlycontinue
            While (!$done) {
              $nextCol = $col + $counter * $nb[0]
              $nextRow = $row + $counter * $nb[1]
              If ($nextCol -lt 0 -or $nextRow -lt 0 -or !$grid[$nextCol,$nextRow]) {
                $done = $true
              }
              ElseIf ($grid[$nextCol,$nextRow] -match '#|L') {
                $done = $true
                If ($grid[$nextCol,$nextRow] -eq '#') {
                  $grid[$nextCol,$nextRow]
                }
              }
              $counter++
            }
          }
          # nothing in sight, fill it up
          If (!$chairs) {
            $showLine += '#'
            $seatsChanged = $true
          }
          # keep same
          Else {
            $showLine += 'L'
          }
        }
        # based on filled chair rules
        '#' {
          # read filled in sight
          $chairs = Foreach ($nb in $neighbours) {
            $counter = 1
            remove-variable done -erroraction silentlycontinue
            While (!$done) {
              $nextCol = $col + $counter * $nb[0]
              $nextRow = $row + $counter * $nb[1]
              If ($nextCol -lt 0 -or $nextRow -lt 0 -or !$grid[$nextCol,$nextRow]) {
                $done = $true
              }
              ElseIf ($grid[$nextCol,$nextRow] -match '#|L') {
                $done = $true
                If ($grid[$nextCol,$nextRow] -eq '#') {
                  $grid[$nextCol,$nextRow]
                }
              }
              $counter++
            }
          }
          # above threshold, change to empty
          If ($chairs.count -ge 5) {
            $showLine += 'L'
            $seatsChanged = $true
          }
          # below threshold, keep filled
          Else {
            $showLine += '#'
          }
        }
      }
    }
    # add to multiline output
    $showAll += ,$showLine
    # clean variable
    remove-variable showLine
  }
  # show output if we changed
  If ($seatsChanged) {
    $showAll
  }
  # no change, count number of filled chairs
  Else {
    (($showAll -join '').ToCharArray() | Where-Object {$_ -eq '#'}).count
  }
}
# initial from input
$next = Update-Seats2 -seats (get-content .\puzzle11input.txt)
# loop through changes and report number of chairs
While ($next -isnot [int]){$next = Update-Seats2 -seats $next}
$next