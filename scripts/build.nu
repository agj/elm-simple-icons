# FILES AND DIRECTORIES

let simpleIconsDir = "./node_modules/simple-icons"
let iconSvgsDir = $"($simpleIconsDir)/icons"
let iconDataFile = $"($simpleIconsDir)/data/simple-icons.json"
let outputElmFile = "./src/SimpleIcons.elm"


# FUNCTIONS

# Converts metadata for an icon (an entry from `simple-icons.json`) into a
# string representing a full Elm definition for said icon.
def icon-to-elm []: record<title: string, slug: string, hex: string> -> string {
  let icon = $in
  let xml = open $"($iconSvgsDir)/($icon.slug).svg" | from xml
  let svgContent = $xml | children-to-elm-list | str join "\n"
  let body = $"toIcon \"($icon.title)\" \"#($icon.hex)\"\n($svgContent)" | indent
  let fixedName = $icon.slug | icon-slug-to-elm-word
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

# Taking an XML-as-nuon SVG node, converts all of its child nodes into a list of
# lines of an Elm list representation, including `[]` and `,` syntax to separate
# each item.
def children-to-elm-list []: record<content: table<tag: string, attributes: record, content: list>> -> list<string> {
  get content | each { $in | svg-to-elm } | to-elm-list
}

# Takes an XML-as-nuon SVG node and converts it into Elm code as string.
def svg-to-elm []: record<tag: string, content: table<tag: oneof<string, nothing>, attributes: oneof<record, nothing>, content: oneof<list, string>>> -> string {
  let node = $in

  if ($node | is-text-node) {
    return $"S.text \"($node | get content)\""
  }

  if ($node.tag == "title") {
    # The `<title>` is added by `toHtml`.
    return
  }

  let tag = $node | get tag | tag-to-elm
  let attributes = $node | get attributes | items {|name, value| attribute-to-elm $name $value } | str join ", "
  let children = $node | children-to-elm-list

  [$"($tag) [ ($attributes) ]", ...$children] | str join "\n"
}

# Takes a list of strings of Elm code and formats it as an Elm list, adding `[]`
# and `,` syntax. Returns another list of strings.
def to-elm-list []: list<string> -> list<string> {
  let items = $in

  match $items {
    [] => [$"[]"]
    [$single] => [$"[ ($single) ]"]
    [$head, ..$tail] => {
      let tailWithCommas = $tail | each { $", ($in)" }
      [$"[ ($head)", ...$tailWithCommas, "]"]
    }
  }
}

# Determines whether an XML-as-nuon SVG node is a text node.
def is-text-node []: record<tag: oneof<string, nothing>> -> bool {
  $in.tag | is-empty
}

# Converts an SVG tag to an `elm/svg` function.
def tag-to-elm []: string -> string {
  $"S.($in)"
}

# Normalizes an icon slug to an Elm name suitable for a definition.
def icon-slug-to-elm-word []: string -> string {
  let $name = $in
  if ($name =~ '^\d') { $"n_($name)" } else { $name }
}

# Converts an attribute name and value to an Elm `Svg.Attribute` value.
def attribute-to-elm [name: string, value: string]: nothing -> string {
  $"($name | attribute-name-to-elm) \"($value)\""
}

# Converts an attribute name to an `elm/svg` attribute function.
def attribute-name-to-elm []: string -> string {
  match $in {
    "role" => "svgRole"
    _ => $"Sa.($in)"
  }
}

# Indents text by four spaces.
def indent []: string -> string {
  $in | lines | each { $"    ($in)" } | str join "\n" 
}


# GENERATION

let iconData = open $iconDataFile | sort-by slug
let icons = $iconData | par-each --keep-order {|icon| $icon | insert svg ($icon | icon-to-elm) } 
let exposed = $icons | each { $in.slug | icon-slug-to-elm-word } | str join ", " 
let allIconsBody = $icons | each { $"\( \"($in.slug)\", ($in.slug | icon-slug-to-elm-word) )" }
  | to-elm-list | str join "\n" | indent
let iconDefinitions = $icons | each { get svg } | str join "\n\n\n"

let moduleContent = $"
module SimpleIcons exposing \(Icon, toHtml, allIcons, withColor, withInheritedTextColor, withSize, withTitle, withNoTitle, ($exposed))

{-|
@docs Icon

@docs toHtml

# Configuration

@docs withColor, withInheritedTextColor, withSize, withTitle, withNoTitle

# Icons

Find your icon more easily at the [Simple Icons project
website]\(https://simpleicons.org/). Make sure to read the [legal
disclaimer]\(https://github.com/simple-icons/simple-icons/blob/develop/DISCLAIMER.md)
regarding licensing. Each icon below displays license information and
brand guidelines, if available.

Icon SVGs are by default colored with their “brand color”, and carry a `<title>`
element with the name of the project or brand, which should display on hover in
browsers. See [Configuration]\(#configuration) above to see how to change these
defaults.

In this package, icon definition names are the same as the slug you can find at
the Simple Icons website, with one caveat: due to limitations of the Elm syntax,
slug names that start with a digit are prepended with `n_`.

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

{-| The type for all icons in this package. Use `toHtml` to convert it into an
SVG node you can use in your view.
-}
type Icon =
    Icon
        { content : List \(S.Svg Never)
        , color : String
        , size : String
        , title : String
        }

{-| Sets the fill color of the icon. Can take any color value applicable
to the [CSS `fill`
property]\(https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/fill).

    SimpleIcons.elm
        |> SimpleIcons.withColor \"#000000\"
    --: SimpleIcons.Icon
-}
withColor : String -> Icon -> Icon
withColor newColor \(Icon iconOptions) =
  Icon { iconOptions | color = newColor }

{-| Sets the icon's fill color to the same as the surrounding text color,
i.e. equivalent to the CSS `color` property. This is the same as `withColor
\"currentColor\"`.

    SimpleIcons.elm
        |> SimpleIcons.withInheritedTextColor
    --: SimpleIcons.Icon
-}
withInheritedTextColor : Icon -> Icon
withInheritedTextColor \(Icon iconOptions) =
    Icon { iconOptions | color = \"currentColor\" }

{-| Sets the size of the icon to a CSS dimension. By default it is set to
`\"1em\"`, which is equivalent to the font size.

    SimpleIcons.elm
        |> SimpleIcons.withSize \"20px\"
    --: SimpleIcons.Icon
-}
withSize : String -> Icon -> Icon
withSize theSize \(Icon iconOptions) =
    Icon { iconOptions | size = theSize }

{-| Sets a new text for the `<title>` element \(which shows up on hover) for the
icon. The default is the name of the project or brand corresponding to the icon.

    SimpleIcons.elm
        |> SimpleIcons.withTitle \"Great functional language!\"
    --: SimpleIcons.Icon
-}
withTitle : String -> Icon -> Icon
withTitle theTitle \(Icon iconOptions) =
    Icon { iconOptions | title = theTitle }

{-| Removes the `<title>` element for the icon. Nothing will show up on hover.

    SimpleIcons.elm
        |> SimpleIcons.withNoTitle
    --: SimpleIcons.Icon
-}
withNoTitle : Icon -> Icon
withNoTitle \(Icon iconOptions) =
    Icon { iconOptions | title = "" }

{-| Converts your chosen `Icon` to a value that can be used in your HTML
view. Takes a list of SVG or HTML attributes, which you may use to add event
listeners, CSS classes, etc.

    import Html

    SimpleIcons.elm
        |> SimpleIcons.toHtml []
    --: Html.Html msg
-}
toHtml : List \(Html.Attribute msg) -> Icon -> Html.Html msg
toHtml theAttributes \(Icon iconOptions) =
    let
        titleNode : List \(S.Svg msg)
        titleNode =
            if iconOptions.title == ""
                then []
                else [ S.title [] [ Html.text iconOptions.title ] ]
    in
    S.svg
      \(
          [ svgRole \"img\"
          , Sa.viewBox \"0 0 24 24\"
          , Ha.style \"fill\" iconOptions.color
          , Ha.style \"width\" iconOptions.size
          , Ha.style \"height\" iconOptions.size
          ]
              ++ theAttributes
      )
      \(titleNode ++ \(iconOptions.content |> List.map \(Html.map never)))

toIcon : String -> String -> List \(S.Svg Never) -> Icon
toIcon theTitle theColor theContent =
  Icon { content = theContent, color = theColor, title = theTitle, size = \"1em\" }

-- ICONS

{-| Dictionary of all the icons. The keys are the slugs that identify each icon
in the Simple Icons project.
-}
allIcons : Dict.Dict String Icon
allIcons =
    Dict.fromList
($allIconsBody)

($iconDefinitions)
"

mkdir ./src/
$moduleContent | save --force $outputElmFile

elm-format $outputElmFile --yes
