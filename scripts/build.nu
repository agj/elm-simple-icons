# Files and directories.

let simpleIconsDir = "./node_modules/simple-icons"
let iconSvgsDir = $"($simpleIconsDir)/icons"
let iconDataFile = $"($simpleIconsDir)/data/simple-icons.json"
let outputElmFile = "./src/SimpleIcons.elm"

# Functions.

def icon-to-elm [] {
  let icon = $in
  let body = open $"($iconSvgsDir)/($icon.slug).svg" | from xml | svg-to-elm | indent
  let fixedName = $icon.slug | icon-name-to-elm-word
  let license = if ($icon has license) {
      $"License: ($icon.license.type)."
    } else {
      "(No license information.)"
    }
  let guidelines = if ($icon has guidelines) {
    $"[Brand guidelines.]\(($icon.guidelines))"
  } else { "" }

  $"
{-| Logo icon for “($icon.title)”. Default color is `#($icon.hex)`.

($license)

($guidelines)
-}
($fixedName) : S.Svg x
($fixedName) =
($body)
"
}

def svg-to-elm [] {
  let node = $in

  if ($node | is-text-node) {
    return $"S.text \"($node | get content)\""
  }

  let tag = $node | get tag | tag-to-name
  let attributes = $node | get attributes | items {|name, value| attribute-to-elm $name $value } | str join ", "
  let children = $node | get content | each { $in | svg-to-elm } | to-elm-list

  [$"($tag) [ ($attributes) ]", ...$children] | str join "\n"
}

def is-text-node [] {
  $in | get tag | is-empty
}

def tag-to-name [] {
  $"S.($in)"
}

def icon-name-to-elm-word [] {
  let $name = $in
  if ($name =~ '^\d') { $"n_($name)" } else { $name }
}

def attribute-to-elm [name, value] {
  $"($name | attribute-to-name) \"($value)\""
}

def attribute-to-name [] {
  match $in {
    "role" => "svgRole"
    _ => $"Sa.($in)"
  }
}

def to-elm-list [] {
  let items = $in

  match $items {
    [] => [$"[ ]"]
    [$single] => [$"[ ($single) ]"]
    [$head, ..$tail] => {
      let tailWithCommas = $tail | each { $", ($in)" }
      [$"[ ($head)", ...$tailWithCommas, "]"]
    }
  }
}

def indent [] {
  $in | lines | each { $"    ($in)" } | str join "\n" 
}

# Generation.

let iconData = open $iconDataFile | sort-by slug
let icons = $iconData | each {|icon| $icon | insert svg ($icon | icon-to-elm) } 
let moduleBody = $icons | each { get svg } | str join "\n\n\n"
let exposed = $icons | each { $in.slug | icon-name-to-elm-word } | str join ", " 

let moduleText = $"module SimpleIcons exposing \(($exposed))

{-|
# Icons

Find your icon at the [Simple Icons project website]\(https://simpleicons.org/).

@docs ($exposed)
-}

import Svg as S
import Svg.Attributes as Sa
import Html.Attributes

svgRole : String -> S.Attribute msg
svgRole = Html.Attributes.attribute \"role\"

($moduleBody)
"

$moduleText | save --force $outputElmFile

elm-format $outputElmFile --yes
