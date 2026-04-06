let simpleIconsDir = "./node_modules/simple-icons"
let iconsDir = $"($simpleIconsDir)/icons"

def icon-to-elm [] {
  let icon = $in
  let body = open $"($iconsDir)/($icon.slug).svg" | from xml | svg-to-elm | indent
  let fixedName = $icon.slug | icon-name-to-elm-word
  $"
{-| Logo icon for “($icon.title)”. Default color is `#($icon.hex)`.
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

#################

let iconData = open $"($simpleIconsDir)/data/simple-icons.json" | sort-by slug
let icons = $iconData | each {|icon| $icon | insert svg ($icon | icon-to-elm) } 
let moduleBody = $icons | each { get svg } | str join "\n\n\n"
let exposed = $icons | each { $in.slug | icon-name-to-elm-word } | str join ", " 

let moduleText = $"module SimpleIcons exposing \(($exposed))

{-|
# Icons

@docs ($exposed)
-}

import Svg as S
import Svg.Attributes as Sa
import Html.Attributes

svgRole : String -> S.Attribute msg
svgRole = Html.Attributes.attribute \"role\"

($moduleBody)
"

$moduleText | save --force ./src/SimpleIcons.elm

elm-format ./src/SimpleIcons.elm --yes
