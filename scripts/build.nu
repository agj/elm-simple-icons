let iconsDir = "./node_modules/simple-icons/icons"

def icon-to-elm [] {
  let name = $in
  let body = open $"($iconsDir)/($name).svg" | from xml | svg-to-elm | indent
  let fixedName = $name | icon-name-to-elm-word
  $"($fixedName) : S.Svg x\n($fixedName) =\n($body)"
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

let iconsDir = "./node_modules/simple-icons/icons"
let icons = glob $"($iconsDir)/*.svg" | each { path parse | get stem }
let definitions = $icons | par-each { $in | icon-to-elm } 
let moduleBody = $definitions | str join "\n\n\n"

let moduleText = $"module SimpleIcons exposing \(..)

import Svg as S
import Svg.Attributes as Sa
import Html.Attributes

svgRole : String -> S.Attribute msg
svgRole = Html.Attributes.attribute \"role\"

($moduleBody)
"

$moduleText | save --force ./src/SimpleIcons.elm

elm-format ./src/SimpleIcons.elm --yes
