<p align="center">
    <a href="https://travis-ci.org/hulab/POLocalizedString">
        <img src="http://img.shields.io/travis/hulab/POLocalizedString.svg?style=flat" alt="CI Status">
    </a>
    <a href="http://cocoapods.org/pods/POLocalizedString">
        <img src="https://img.shields.io/cocoapods/v/POLocalizedString.svg?style=flat" alt="Version">
    </a>
    <a href="http://cocoapods.org/pods/POLocalizedString">
        <img src="https://img.shields.io/cocoapods/l/POLocalizedString.svg?style=flat" alt="License">
    </a>
    <a href="http://cocoapods.org/pods/POLocalizedString">
        <img src="https://img.shields.io/cocoapods/p/POLocalizedString.svg?style=flat" alt="Platform">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat" alt="Carthage">
    </a>
</p>

----------------

POLocalizedString is a [gettext](https://www.gnu.org/software/gettext/) translations framework in substitution of Apple translations system.

> POLocalizedString is initially a fork of [pomo-iphone](https://github.com/pronebird/pomo-iphone).

# Features

+ Supports **[mo](https://www.gnu.org/software/gettext/manual/html_node/MO-Files.html)** and **[po](https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/PO-Files.html)** format.
+ Supports **plurals** forms.
+ Supports multiple Bundles.

## Basic usage

###### Objective-C
```objective-c
#import <POLocalizedString/POLocalizedString.h>

NSInteger numApples = 10;

// Translate single string
NSLog(@"Gettext translated string: %@", POLocalizedString(@"Hi, this is gettext!") );

// Translate plural string
NSLog(@"Gettext translated plural: %@", POLocalizedPluralFormat(@"%d apple", @"%d apples", numApples) );

// Translate and format altogether
NSLog(@"Gettext translated plural: %@", [NSString stringWithFormat:POLocalizedPluralFormat(@"%d apple", @"%d apples", numApples), numApples]);

```
###### Swift
```swift
@import POLocalizedString

let numApples = 10

// Translate single string
print("Gettext translated string: %@", "Hi, this is gettext!".localized);

// Translate plural string
print("Gettext translated plural: %@", "%d apple".localized(plural: "%d apples", n: numApples) );

// Translate and format altogether
print("Gettext translated plural: %@", "%d apple".localized(plural: "%d apples", n: numApples, with: numApples);

```

`POLocalizedString` looks for `.mo` or `.po` files with the following pattern:

`%app-bundle-path/%language.%extension`

where `%language` is a language two letter code (e.g. ru, en, es, etc..)
`%extension` is usually `mo` or `po`. `mo` files have higher priority since it's more compact format and supposed to be used for distribution.

Example path may look like that:

`/MyApp.app/es.mo`

## Installation

POLocalizedString is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "POLocalizedString"
```

## Poedit

### Settings

If you use Poedit, follow the instructions below to setup Objective-C parser.

Go to Poedit > Preferences and add new parser with the following settings:

- List of extensions:
`*.m;*.mm;*.c;*.h;`

- Parser command:
`xgettext --force-po -o %o %C %K %F -L ObjectiveC`

- An item in keywords list:
`-k%k`

- An item in input files:
`%f`

- Source code charset:
`--from-code=%c`

Also you can use `--add-comments=/` flag in Parser commands to enable translators' comments. In this example all comments starting with triple slash will be treated as translators' comments.

### Catalog

Setup the following keywords for your catalog to make Poedit work with your source code:

```
_
POLocalizedString
POLocalizedStringFromContext:2c,1
POLocalizedPluralString:3c,1,2
POLocalizedPluralStringFromContext:4c,1,2
POLocalizedStringInBundle:2
POLocalizedStringFromContextInBundle:3c,2
POLocalizedPluralStringInBundle:2,3
POLocalizedPluralStringFromContextInBundle:5c,2,3
```

## License

POLocalizedString is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
