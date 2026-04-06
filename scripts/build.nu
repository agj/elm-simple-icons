let elmSvg = open "./node_modules/simple-icons/icons/elm.svg" | from xml

def to-elm [] {
  let node = $in

  if ($node | is-text-node) {
    return $"text \"($node | get content)\""
  }

  let tag = $node | get tag | tag-to-name
  let attributes = $node | get attributes | items {|name, value| attribute-to-elm $name $value } | str join ", "
  let children = $node | get content | each { $in | to-elm } | str join ", "

  $"($tag) [ ($attributes) ] [\n($children) ]"
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

$elmSvg | to-elm
