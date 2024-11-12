# LRStreakKit

* [Overview](#overview)
* [Installation](#installation)
* [Basic Usage](#basic-usage)
* [Customisation](#customisation)
    * [Persistence](#persistence)
        * [Custom Persistence](#custom-persistence)
    * [Appearance](#appearance)
        * [StreakView](#streakview)
        * [Make Your Own](#make-your-own)

## Overview

## Installation

## Basic Usage
To get started, call `setupStreak()` in the entry point of your application. This will inject an instance of `StreakManager` into the SwiftUI environment:
```swift
ContentView()
    .setupStreak()
```

When you want the user to update their streak, access the `StreakManager` from the environment and call `updateStreak()`. This operation may happen when the user first opens the app or when they complete a major action in the app.

```swift
@EnvironmentObject var streak: StreakManager

Button("Check in") {
    streak.updateStreak()
}
```

Finally, display the streak using the built in `StreakView`:
```swift
StreakView()
```

## Customisation

The library can be customised in a few ways to help it fit into your application.

### Persistence

By default, the streak data is stored in UserDefaults under the "DailyStreak" key. To change the key, update the `setupStreak()` method:

```swift
ContentView()
    .setupStreak(key: "CustomPersistenceKey")
```

You can also change the technology if UserDefaults isn't your cup of tea:

```swift
ContentView()
    .setupStreak(persistence: .documentsDirectory)
```

Of course you can change the file name too:

```swift
ContentView()
    .setupStreak(persistence: .documentsDirectory, key: "StreakData")
```

#### Custom Persistence

If one of the pre-determined persistence options doesn't work for you, you can make your own. Just handle saving and retrieving data:

```swift
class MyCustomPersistence: StreakPersistence {

    private let storageKey = "ReallyCustomKey"

    func getData() -> Data? {
        //
    }

    func save<T: Codable>(data: T) throws {
        //
    }
}
```
```swift
ContentView()
    .setupStreak(persistence: .custom(MyCustomPersistence()))
```

### Appearance

#### StreakView

#### Make Your Own