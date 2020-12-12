Function Get-DistanceFromStartOne {
  Param (
    $instructions,
    [switch]$debug
  )
  # convert to readable instructions
  $content = get-content $instructions | ForEach-Object {[PSCustomObject]@{do=$_[0];nr=$_.substring(1)}}

  # Starting point of ship
  $loc = 0,0
  # all facing options
  $facings = 'n','e','s','w'
  # start facing 'e', 2nd entry in array
  $facing = 1

  # Run through the actions
  Foreach ($action in $content) {
    # debug start info
    If ($debug) {
      "action: $action"
      "pre: $loc"
      "facing: $($facings[$facing])"
    }
    # what to do
    Switch ($action.do) {
      # move ship north
      'n' {
        $loc[1] = $loc[1] + $action.nr
      }
      # move ship south
      's' {
        $loc[1] = $loc[1] - $action.nr
      }
      # move ship east
      'e' {
        $loc[0] = $loc[0] + $action.nr
      }
      # move ship west
      'w' {
        $loc[0] = $loc[0] - $action.nr
      }
      # turn left by degrees and match to array entry
      'l' {
        $facing = $facing - ($action.nr / 90)
        if ($facing -lt 0){$facing+=4}
      }
      # turn right by degrees and match to array entry
      'r' {
        $facing = $facing + ($action.nr / 90)
        if ($facing -ge $facings.count){$facing-=4}
      }
      # move forwards depending on heading
      'f' {
        Switch ($facings[$facing]) {
          'n' {
            $loc[1] = $loc[1] + $action.nr
          }
          's' {
            $loc[1] = $loc[1] - $action.nr
          }
          'e' {
            $loc[0] = $loc[0] + $action.nr
          }
          'w' {
            $loc[0] = $loc[0] - $action.nr
          }
        }
      }
    }
    # Debug end info
    If ($debug) {
      "post: $loc"
      "facing: $($facings[$facing])"
      '=============='
    }
  }
  # calculate manhattan distance from start
  [math]::Abs($loc[0]) + [math]::Abs($loc[1])
}
Get-DistanceFromStartOne -instructions puzzle12input.txt

'2'
Function Get-DistanceFromStartTwo {
  Param (
    $instructions,
    [switch]$debug
  )
  # convert to readable instructions
  $content = get-content $instructions | ForEach-Object {[PSCustomObject]@{do=$_[0];nr=$_.substring(1)}}

  # Starting point of Waypoint relative to ship
  $wp = 10,1
  # Starting point of ship
  $loc = 0,0
  # Run through the actions
  Foreach ($action in $content) {
    # debug start info
    If ($debug) {
      "action: $action"
      "pre: $loc"
      "wp: $wp"
    }
    # what to do
    Switch ($action.do) {
      # move the waypoint north
      'n' {
        $wp[1] = $wp[1] + $action.nr
      }
      # move the waypoint south
      's' {
        $wp[1] = $wp[1] - $action.nr
      }
      # move the waypoint east
      'e' {
        $wp[0] = $wp[0] + $action.nr
      }
      # move the waypoint west
      'w' {
        $wp[0] = $wp[0] - $action.nr
      }
      # rotate waypoint left by degrees
      'l' {
        Switch ($action.nr) {
          90 {
            $wp = -$wp[1], $wp[0]
          }
          180 {
            $wp = -$wp[0], -$wp[1]
          }
          270 {
            $wp = $wp[1], -$wp[0]
          }
        }
      }
      # rotate waypoint right by degrees
      'r' {
        Switch ($action.nr) {
          90 {
            $wp = $wp[1], -$wp[0]
          }
          180 {
            $wp = -$wp[0], -$wp[1]
          }
          270 {
            $wp = -$wp[1], $wp[0]
          }
        }
      }
      # move ship towards the waypoint
      'f' {
        $loc[0] += $wp[0] * $action.nr 
        $loc[1] += $wp[1] * $action.nr 
      }
    }
    # Debug end info
    If ($debug) {
      "post: $loc"
      "wp: $wp"
      '=============='
    }
  }

  # calculate manhattan distance from start
  [math]::Abs($loc[0]) + [math]::Abs($loc[1])
}

Get-DistanceFromStartTwo -instructions puzzle12input.txt
