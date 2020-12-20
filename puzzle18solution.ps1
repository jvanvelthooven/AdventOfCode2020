Function Get-Expression {
  Param (
    $string
  )
  # read numbers
  $numbers = $string.split(' ') | Foreach-Object {
    If ($_ -match '[0-9]') {
      [int64]$_
    }
  }
  # read expressions
  $expressions = $string.split(' ') | Foreach-Object {
    If ($_ -notmatch '[0-9]| ') {
      $_
    }
  }

  # add first
  $result = $numbers[0]

  # skip first, calc following
  For ($nr = 1;$nr -lt $numbers.count;$nr++) {
    Switch ($expressions[$nr - 1]) {
      '*' {
        $result *= $numbers[$nr]
      }
      '+' {
        $result += $numbers[$nr]
      }
    }
  }
  $result
}

# Function to remove () from sum
Function Set-Sum {
  Param (
    $sum
  )
  # rebuild sum
  $dataSet = $sum.replace('(',"z(z").replace(')',"z)z").split('z') | Where-Object {$_}
  # run through steps
  For ($item = 0;$item -lt $dataSet.count;$item++) {
    If ($dataSet[$item] -eq '(' -and $dataSet[$Item + 2] -eq ')') {
      Continue
    }
    ElseIf ($dataSet[$item] -eq ')' -and $dataSet[$Item + -2] -eq '(') {
      Continue
    }
    ElseIf ($dataSet[$item] -match '^[0-9].*[0-9]$') {
      [string]$newSum += (Get-Expression $dataSet[$item])
    }
    Else {
      [string]$newSum += $dataSet[$item]
    }
    $counter++
  }

  # Return sum
  Return $newSum
}

# read input
$sums = get-content puzzle18input.txt

$result = Foreach ($sum in $sums) {
  # while () in sum
  While ($sum.contains('(')) {
    $sum = Set-Sum $sum
  }
  # calculate last
  ,(Get-Expression $sum)
}

'2'
Function Get-Expression {
  Param (
    $string
  )
  # Check if this expression contains both + and *
  If ($string.contains('+') -and $string.contains('*')) {
    Return Add-Brackets $string
  }

  # read numbers
  $numbers = $string.split(' ') | Foreach-Object {
    If ($_ -match '[0-9]') {
      [int64]$_
    }
  }

  # read operators
  $operators = $string.split(' ') | Foreach-Object {
    If ($_ -notmatch '[0-9]| ') {
      $_
    }
  }

  # add first
  $result = $numbers[0]

  # skip first, calc following
  For ($nr = 1;$nr -lt $numbers.count;$nr++) {
    Switch ($operators[$nr - 1]) {
      '*' {
        $result *= $numbers[$nr]
      }
      '+' {
        $result += $numbers[$nr]
      }
    }
  }
  $result
}

# Function to add ()
Function Add-Brackets {
  Param (
    $string
  )
  # read numbers
  $numbers = $string.split(' ') | Foreach-Object {
    If ($_ -match '[0-9]') {
      [int64]$_
    }
  }
  # read operators
  $operators = $string.split(' ') | Foreach-Object {
    If ($_ -notmatch '[0-9]| ') {
      $_
    }
  }

  # Run through operators
  For ($nr = 0;$nr -lt $operators.count;$nr++) {
    Switch ($operators[$nr]) {
      '*' {
        If ($open) {
          $result += [string]$numbers[$nr] + (')' * $open) + ' ' + $operators[$nr] + ' '
          Remove-Variable open -ErrorAction SilentlyContinue
        }
        Else {
          $result += [string]$numbers[$nr] + ' ' + $operators[$nr] + ' '
        }
      }
      '+' {
        $open++
        $result += '(' + [string]$numbers[$nr] + ' ' + $operators[$nr] + ' '
      }
    }
  }
  If ($open) {
    $result += [string]$numbers[$nr] + (')' * $open)
  }
  Else {
    $result += [string]$numbers[$nr]
  }

  # Return result
  Return $result
}

# Function to remove () from sum
Function Set-Sum {
  Param (
    $sum
  )
  # rebuild sum
  [array]$dataSet = $sum.replace('(',"z(z").replace(')',"z)z").split('z') | Where-Object {$_}
  # run through steps
  For ($item = 0;$item -lt $dataSet.count;$item++) {
    If ($dataSet[$item] -eq '(' -and $dataSet[$Item + 2] -eq ')') {
      Continue
    }
    ElseIf ($dataSet[$item] -eq ')' -and $dataSet[$Item + -2] -eq '(') {
      Continue
    }
    ElseIf ($dataSet[$item] -match '^[0-9].*[0-9]$') {
      $expression = Get-Expression $dataSet[$item]
      If ($expression -match '^[0-9]+$') {
        [string]$newSum += $expression
      }
      Else {
        [string]$newSum += '(' + $expression + ')'
      }
    }
    Else {
      [string]$newSum += $dataSet[$item]
    }
    $counter++
  }

  # Return sum
  Return $newSum
}

# read input
$sums = get-content puzzle18input.txt

$result = Foreach ($sum in $sums) {
  # while () in sum
  While ($sum.contains('*') -or $sum.contains('+')) {
    $sum = Set-Sum $sum
  }
  # calculate last
  ,(Get-Expression $sum)
}

# sum
$result | Measure-Object -Sum