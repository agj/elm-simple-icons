# Files and directories.

let simpleIconsDir = "./node_modules/simple-icons"
let iconSvgsDir = $"($simpleIconsDir)/icons"
let iconDataFile = $"($simpleIconsDir)/data/simple-icons.json"
let outputElmFile = "./src/SimpleIcons.elm"

# Functions.

def icon-to-elm [] {
  let icon = $in
  let xml = open $"($iconSvgsDir)/($icon.slug).svg" | from xml
  let svgContent = $xml | children-to-elm | str join "\n"
  let body = $"toIcon \"#($icon.hex)\"\n($svgContent)" | indent
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
{-| Logo icon for “($icon.title)”. Its default color is `#($icon.hex)`.

($license)

($guidelines)
-}
($fixedName) : Icon
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
  let children = $node | children-to-elm

  [$"($tag) [ ($attributes) ]", ...$children] | str join "\n"
}

def children-to-elm [] {
  get content | each { $in | svg-to-elm } | to-elm-list
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

def indent [] {
  $in | lines | each { $"    ($in)" } | str join "\n" 
}

# Generation.

let iconData = open $iconDataFile | sort-by slug
let icons = $iconData | each {|icon| $icon | insert svg ($icon | icon-to-elm) } 
let moduleBody = $icons | each { get svg } | str join "\n\n\n"
let exposed = $icons | each { $in.slug | icon-name-to-elm-word } | str join ", " 
let allIconsBody = $icons | each { $"\( \"($in.slug)\", ($in.slug | icon-name-to-elm-word) )" }
  | to-elm-list | str join "\n" | indent

let moduleText = $"
module SimpleIcons exposing \(Icon, toHtml, allIcons, withColor, withInheritedTextColor, ($exposed))

{-|
@docs Icon

@docs toHtml

# Configuration

@docs withColor, withInheritedTextColor

# Icons

Find your icon at the [Simple Icons project website]\(https://simpleicons.org/).

In this package, slug names that start with a digit are prepended with `n_`, due
to limitations of the language.

@docs allIcons
@docs ($exposed)
-}

import Svg as S
import Svg.Attributes as Sa
import Html
import Html.Attributes as Ha
import Dict

svgRole : String -> S.Attribute msg
svgRole = Ha.attribute \"role\"

{-| The type of all icons in this package. Use `toHtml` to convert it into an
SVG node.
-}
type Icon =
    Icon
        { content : List \(S.Svg Never)
        , color : String
        }

{-| Sets the fill color of the icon. Can take any color value applicable
to the [CSS `fill`
property]\(https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/fill).

    SimpleIcons.elm
        |> SimpleIcons.withColor \"#000000\"
-}
withColor : String -> Icon -> Icon
withColor newColor \(Icon iconOptions) =
  Icon { iconOptions | color = newColor }

{-| Sets the icon's fill color to the same as the surrounding text color,
i.e. equivalent to the CSS `color` property. This is the same as `withColor
\"defaultColor\"`.

    SimpleIcons.elm
        |> SimpleIcons.withInheritedTextColor
-}
withInheritedTextColor : Icon -> Icon
withInheritedTextColor \(Icon iconOptions) =
  Icon { iconOptions | color = \"defaultColor\" }

{-| Converts your chosen `Icon` to a value that can be used in your HTML
view. Takes a list of SVG or HTML attributes, which you may use to add event
listeners, CSS classes, etc.

    SimpleIcons.elm
        |> SimpleIcons.toHtml []
-}
toHtml : List \(Html.Attribute msg) -> Icon -> Html.Html msg
toHtml theAttributes \(Icon iconOptions) =
    S.svg
      \(
          [ svgRole \"img\"
          , Sa.viewBox \"0 0 24 24\"
          , Ha.style \"fill\" iconOptions.color
          , Ha.style \"width\" \"1em\"
          , Ha.style \"height\" \"1em\"
          ]
              ++ theAttributes
      )
      \(iconOptions.content |> List.map \(Html.map never))


toIcon : String -> List \(S.Svg Never) -> Icon
toIcon theColor theContent =
  Icon { content = theContent, color = theColor }

{-| Dictionary of all the icons. The key is the identifying slug just as it is
in the original Simple Icons.
-}
allIcons : Dict.Dict String Icon
allIcons =
    Dict.fromList
($allIconsBody)

($moduleBody)
"

mkdir ./src/
$moduleText | save --force $outputElmFile

elm-format $outputElmFile --yes
