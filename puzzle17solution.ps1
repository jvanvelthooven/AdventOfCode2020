Function Add-Coordinate {
  Param (
    $obj,
    $coordinate,
    $value
  )
  If (!$obj[$coordinate[0]]) {
    $obj[$coordinate[0]] = @{}
  }
  If (!$obj[$coordinate[0]][$coordinate[1]]) {
    $obj[$coordinate[0]][$coordinate[1]] = @{}
  }
  $obj[$coordinate[0]][$coordinate[1]][$coordinate[2]] = $value
}

Function Show-Levels {
  Param (
    $engine
  )
  $uniqueX = $engine.keys | Sort-Object -Unique
  $uniqueY = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | Sort-Object -Unique
  $uniqueZ = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | ForEach-Object {$engine[$x][$_].keys} | Sort-Object -Unique
  Foreach ($z in $uniqueZ) {
    "z = $z"
    For ($x = $uniqueX[0];$x -le $uniqueX[-1];$x++) {
      Remove-Variable col -ErrorAction silentlycontinue
      If ($engine[$x]) {
        For ($y = $uniqueY[0];$y -le $uniqueY[-1];$y++) {
          If ($engine[$x][$y] -and $engine[$x][$y][$z]) {
            $col += ,$engine[$x][$y][$z]
          }
          Else {
            $col += ,'.'
          }
        }
      }
      Else {
        $col += ,'.'
      }
      $cols += ,$col
    }
    For ($x = 0;$x -lt $cols.length;$x++) {
      $rows = Foreach ($col in $cols) {
        $col[$x]
      }
      $rows -join ''
    }
    Remove-Variable col, cols, rows -ErrorAction silentlycontinue
  }
}

Function Get-FirstCycle {
  # create empty engine
  $engine = @{}
  
  # read input
  $content = get-content puzzle17input.txt
  
  # Change input to engine
  For ($row = 0;$row -lt $content.length;$row++) {
    $cols = $content[$row].ToCharArray()
    For ($col = 0;$col -lt $cols.length;$col++) {
      Add-Coordinate -obj $engine -coordinate $col,$row,0 -value $cols[$col]
    }
  }

  Return $engine
}

Function Get-NextCycle {
  Param (
    $engine
  )

  # Create new engine
  $newEngine = @{}

  # get unique keys per z,y,z
  $uniqueX = $engine.keys | Sort-Object -Unique
  $uniqueY = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | Sort-Object -Unique
  $uniqueZ = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | ForEach-Object {$engine[$x][$_].keys} | Sort-Object -Unique

  # get neighbours of cubes that are active
  $cubesToCheck = For ($x = $uniqueX[0];$x -le $uniqueX[-1];$x++) {
    For ($y = $uniqueY[0];$y -le $uniqueY[-1];$y++) {
      For ($z = $uniqueZ[0];$z -le $uniqueZ[-1];$z++) {
        If ($engine[$x] -and $engine[$x][$y] -and $engine[$x][$y][$z] -eq '#') {
          For ($1 = ($x - 1);$1 -le ($x + 1);$1++) {
            For ($2 = ($y - 1);$2 -le ($y + 1);$2++) {
              For ($3 = ($z - 1);$3 -le ($z + 1);$3++) {
                ,($1,$2,$3)
              }
            }
          }
        }
      }
    }
  }
  
  # get unique cubes
  $cubesToCheck = $cubesToCheck | Sort-Object -Unique

  # CHeck all cubes
  Foreach ($cube in $cubesToCheck) {
    # Get active neighbours
    $active = For ($1 = ($cube[0] - 1);$1 -le ($cube[0] + 1);$1++) {
      If ($engine[$1]) {
        For ($2 = ($cube[1] - 1);$2 -le ($cube[1] + 1);$2++) {
          If ($engine[$1][$2]) {
            For ($3 = ($cube[2] - 1);$3 -le ($cube[2] + 1);$3++) {
              If ($engine[$1] -and $engine[$1][$2] -and $engine[$1][$2][$3] -eq '#') {
                If (!($1 -eq $cube[0] -and $2 -eq $cube[1] -and $3 -eq $cube[2])) {
                  ,'#'
                }
              }
            }
          }
        }
      }
    }
    If ($engine[$cube[0]] -and $engine[$cube[0]][$cube[1]] -and $engine[$cube[0]][$cube[1]][$cube[2]] -and $engine[$cube[0]][$cube[1]][$cube[2]] -eq '#') {
      If ($active.count -eq 2 -or $active.count -eq 3) {
        #'= keep active ='
        #$cube
        Add-Coordinate -obj $newEngine -coordinate $cube -value '#'
      }
    }
    ElseIf ($active.count -eq 3) {
      #'= make active ='
      #$cube
      Add-Coordinate -obj $newEngine -coordinate $cube -value '#'
    }
  }

  # Return engine
  $newEngine
}

# Function to count the active cubes
Function Get-Cubes {
  Param (
    $engine
  )

  # get unique keys per z,y,z
  $uniqueX = $engine.keys | Sort-Object -Unique
  $uniqueY = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | Sort-Object -Unique
  $uniqueZ = $engine.keys | ForEach-Object {$x = $_;$engine[$x].keys} | ForEach-Object {$engine[$x][$_].keys} | Sort-Object -Unique

  # get neighbours of cubes that are active
  $activeCubes = For ($x = $uniqueX[0];$x -le $uniqueX[-1];$x++) {
    For ($y = $uniqueY[0];$y -le $uniqueY[-1];$y++) {
      For ($z = $uniqueZ[0];$z -le $uniqueZ[-1];$z++) {
        If ($engine[$x] -and $engine[$x][$y] -and $engine[$x][$y][$z] -eq '#') {
          '#'
        }
      }
    }
  }

  # Return count
  $activeCubes.count
}

# read initial
$engine = Get-FirstCycle

# run through cycles
1..6 | Foreach-Object {$engine = Get-NextCycle -engine $engine}

# Get count
Get-Cubes $engine
