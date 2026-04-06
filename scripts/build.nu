let elmSvg = open "./node_modules/simple-icons/icons/elm.svg" | from xml

def to-elm [] {
  let node = $in

  if ($node | is-text-node) {
    return $"text \"($node | get content)\""
  }

  let tag = $node | get tag | tag-to-name
  let attributes = $node | get attributes | items {|name, value| attribute-to-elm $name $value } | str join ", "
  let children = $node | get content | each { $in | to-elm } | to-elm-list

  [$"($tag) [ ($attributes) ]", ...$children] | str join "\n"
}

def is-text-node [] {
  $in | get tag | is-empty
}

def tag-to-name [] {
  $in
}

def attribute-to-elm [name, value] {
  $"($name | tag-to-name) \"($value)\""
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

let moduleText = $"module SimpleIcons exposing \(..)

import Svg exposing \(..)
import Svg.Attributes exposing \(..)

elm : Svg x
elm =
($elmSvg | to-elm | indent)
"

$moduleText | save --force ./src/SimpleIcons.elm

elm-format ./src/SimpleIcons.elm --yes
