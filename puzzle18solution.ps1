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
