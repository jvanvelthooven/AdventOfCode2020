$content = get-content .\puzzle11input.txt
$cols = $content.count
$rows = $content[0].length
$grid = New-Object 'object[,]' $content.count,$content[0].length

Function Update-Seats {
  Param (
    $seats
  )

  $cols = $seats.count
  $rows = $seats[0].length
  $grid = New-Object 'object[,]' $seats.count,$seats[0].length
  $neighbours = (-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)
  
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

  for ($col = 0;$col -lt $cols;$col++) {
    for ($row = 0;$row -lt $rows;$row++) {
      Switch ($grid[$col,$row]) {
        '.' {
          $showLine += '.'
        }
        'L' {
          $nb = $neighbours | Where-Object {
            If (($col + $_[0]) -ge 0 -and ($row + $_[1]) -ge 0) {
              $grid[($col + $_[0]),($row + $_[1])] -eq '#'
            }
          }
          If (!$nb) {
            $showLine += '#'
            $seatsChanged = $true
          }
          Else {
            $showLine += 'L'
          }
        }
        '#' {
          $nb = $neighbours | Where-Object {
            If (($col + $_[0]) -ge 0 -and ($row + $_[1]) -ge 0) {
              $grid[($col + $_[0]),($row + $_[1])] -eq '#'
            }
          }
          If ($nb.count -ge 4) {
            $showLine += 'L'
            $seatsChanged = $true
          }
          Else {
            $showLine += '#'
          }
        }
      }
    }
    $showAll += ,$showLine
    remove-variable showLine
  }
  If ($seatsChanged) {
    $showAll
  }
  Else {
    (($showAll -join '').ToCharArray() | Where-Object {$_ -eq '#'}).count
  }
}
While ($next -isnot [int]){$next = Update-Seats -seats $next};$next

'2'
Function Update-Seats2 {
  Param (
    $seats
  )

  $cols = $seats.count
  $rows = $seats[0].length
  $grid = New-Object 'object[,]' $seats.count,$seats[0].length
  $neighbours = (-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)
  
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

  for ($col = 0;$col -lt $cols;$col++) {
    for ($row = 0;$row -lt $rows;$row++) {
      Switch ($grid[$col,$row]) {
        '.' {
          $showLine += '.'
        }
        'L' {
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
          If (!$chairs) {
            $showLine += '#'
            $seatsChanged = $true
          }
          Else {
            $showLine += 'L'
          }
        }
        '#' {
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
          If ($chairs.count -ge 5) {
            $showLine += 'L'
            $seatsChanged = $true
          }
          Else {
            $showLine += '#'
          }
        }
      }
    }
    $showAll += ,$showLine
    remove-variable showLine
  }
  If ($seatsChanged) {
    $showAll
  }
  Else {
    (($showAll -join '').ToCharArray() | Where-Object {$_ -eq '#'}).count
  }
}
$next = Update-Seats2 -seats (get-content .\puzzle11input.txt)
While ($next -isnot [int]){$next = Update-Seats2 -seats $next};$next