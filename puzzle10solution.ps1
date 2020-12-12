$content = get-content .\puzzle10input.txt | ForEach-Object {[int64]$_} | Sort-Object
#$content = [array]0 + $content + ($content[-1] + 3)
Function Get-Jumps {
  Param (
    $data
  )
  $data = [array]0 + $data + ($data[-1] + 3)
  Foreach ($adapter in $data) {
    $counter++
    Switch ($data[$counter] - $adapter) {
      1 {
        $1++
      }
      2 {
        $2++
      }
      3 {
        $3++
      }
    }
  }
  '' | Select-Object @{n='1';e={$1}},@{n='3';e={$3}}
}
$result = Get-Jumps $content
"Answer: $($result.'1' * $result.'2')"

'2'
Function Get-PossibleNextSteps {
  param (
    $data,
    $steps,
    $last
  )
  If ($steps[-1] -eq $last) {
    Return ($steps -join ',')
  }
  Foreach ($step in ($data | Where-Object {1,2,3 -eq ($_ - $steps[-1])})) {
    $stepsNext = [array]$steps + $step
    Get-PossibleNextSteps -data $($data[1..($data.length)]) -steps $stepsNext -last $last
  }
}
$content = get-content .\puzzle10input.txt | ForEach-Object {[int64]$_} | Sort-Object
$content = [array]0 + $content + ($content[-1] + 3)
(Get-PossibleNextSteps -data $content[1..($content.length)] -steps $content[0] -last $content[-1]).count

Function Get-Multipliers {
  Param (
    $data
  )
  $content = [array]0 + $data + ($data[-1] + 3)
  $allNrs = 1
  Foreach ($nr in $content){
    $counter++
    If ($content[$counter] -eq ($nr + 3)) {
      Switch ($nrs) {
        4 {
          $allNrs *= 7
        }
        3 {
          $allNrs *= 4
        }
        2 {
          $allNrs *= 2
        }
      }
      Remove-Variable nrs -ErrorAction SilentlyContinue
      Continue
    }
    Else {
      $nrs++
    }
  }  
  $allNrs
}
$content = get-content .\puzzle10input.txt | ForEach-Object {[int64]$_} | Sort-Object
Get-Multipliers -data $content