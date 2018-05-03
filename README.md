# Swifaults

[![Version](https://img.shields.io/cocoapods/v/Swifaults.svg?style=flat)](https://cocoapods.org/pods/Swifaults)
[![License](https://img.shields.io/cocoapods/l/Swifaults.svg?style=flat)](https://cocoapods.org/pods/Swifaults)
[![Platform](https://img.shields.io/cocoapods/p/Swifaults.svg?style=flat)](https://cocoapods.org/pods/Swifaults)

## About Swifaults

UserDefaults, the generic way.

`Swifaults` is a wrapper around `UserDefaults`, leveraging generics to provide a type safe, simple and clear interface. 

## Example

Usually, when you want to save a value to `UserDefaults` you'd do something like this:

```swift
let defaults = UserDefaults.standard
defaults.set("My value", for: "My key")
defaults.synchronize()
```
and for loading:
```swift
let defaults = UserDefaults.standard
let value = defaults.string(forKey: "My key")
```

`Swifaults` allows a clearer usage.

For saving:
```swift
let defaults = Defaults<String>(key: "My key")
defaults.save("My value")
```
and for loading:
```swift
let defaults = Defaults<String>(key: "My key")
let value = defaults.value() // value is a `String?`
```

It's also possible to provide a fallback to a default value in case that the value doesn't exist:

```swift
enum UserState: Int {
    case anonymous
    case loggedIn
    case premium
}

let defaults = Defaults<UserState>(key: "user.state")
let value = defaults.value(defaultValue: .anonymous)
```
and even inline conversion:
```swift
let defaults = Defaults<Int>(key: "user.state.raw")
let value = def.value(defaultValue: .anonymous, { UserState(rawValue: $0) })
```

Default also support saving `Encodable` and loading `Decodable` by using:

```swift
try? defaults.saveEncodableValue(myEncodable)

let myDecodableObject = defaults.decodableValue()
```

Simple. Give it a go.

## Installation

Swifaults is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Swifaults'
```

## Author

Oren Farhan

## License

Swifaults is available under the MIT license. See the LICENSE file for more info.
