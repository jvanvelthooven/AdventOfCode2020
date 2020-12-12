$content = get-content .\puzzle4input.txt
$counter = 0
$pass = @{}
$valid = @{'byr'='^(19[2-9][0-9]|200[0-2])$';'iyr'='^20(1[0-9]|20)$';'eyr'='^20([2][0-9]|30)$';'hgt'='^((59|6[0-9]|7[0-6])in|1([5-8][0-9]|9[0-3])cm)$';'hcl'='^#([0-9]|[a-f]){6}$';'ecl'='amb|blu|brn|gry|grn|hzl|oth';'pid'='^[0-9]{9}$'}
Foreach ($line in $content) {
  if($line -notmatch '^$') {
    Foreach ($item in $line.trim(' ').split(' ')) {
      $pass.add($item.split(':')[0],$item.split(':')[1])
    }
  }
  If ($line -match '^$' -or $line -eq $content[-1]) {
    If (($valid.keys | ForEach-Object {$field = $_;$pass.$field | Where-Object {$_ -and $pass.$field -match $valid.$field}}).count -eq $valid.count) {
      $pass
    }
    $pass = @{}
  }
  $counter++
}
