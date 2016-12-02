import PackageDescription

let package = Package(
    name: "FluentTest",
    targets: [
        Target(name: "App", dependencies: ["AppLogic"]),
        ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/vapor/fluent.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor: 0),

    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        // "Tests",
    ]
)

