$data = get-content .\puzzle8input.txt | ForEach-Object {$split = $_.split(' ');,($split[0],$split[1],$false)}
$line = 0
While (!$double) {
  If ($data[$line][2]) {
    $acc
    break
  }
  $data[$line][2] = $true
  Switch ($data[$line][0]) {
    'acc' {
      $acc += [int]$data[$line][1]
      $line++
    }
    'jmp' {
      $line += [int]$data[$line][1]
    }
    'nop' {
      $line++
    }
  }
}

'2'
$data = get-content .\puzzle8input.txt | ForEach-Object {$split = $_.split(' ');,($split[0],$split[1],$false)}
remove-variable breakwhile,acc -ErrorAction SilentlyContinue
$counter = -1
Foreach ($entry in $data) {
  $counter++
  Switch ($entry[0]) {
    'acc' {
      Continue
    }
    'jmp' {
      $data[$counter][0] = 'nop'
    }
    'nop' {
      $data[$counter][0] = 'jmp'
    }
  }
  $line = 0
  remove-variable breakwhile -ErrorAction SilentlyContinue
  While (!$breakwhile -and $line -lt $data.count) {
    If ($data[$line][2]) {
      remove-variable acc -ErrorAction SilentlyContinue
      $breakwhile = $true
    }
    Else {
      $data[$line][2] = $true
      Switch ($data[$line][0]) {
        'acc' {
          $acc += [int]$data[$line][1]
          $line++
        }
        'jmp' {
          $line += [int]$data[$line][1]
        }
        'nop' {
          $line++
        }
      }
    }
  }
  If (!$breakwhile) {
    break
  }
  $data = get-content .\puzzle8input.txt | ForEach-Object {$split = $_.split(' ');,($split[0],$split[1],$false)}
}
"acc: $acc"
