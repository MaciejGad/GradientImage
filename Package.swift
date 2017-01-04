import PackageDescription

let package = Package(
    name: "GradientImage",
     dependencies: [
        .Package(url: "https://github.com/MaciejGad/SwiftGD.git", versions:Version(1,2,0)..<Version(2,0,0))
    ]
)
