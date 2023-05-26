import '../QtModule.qbs' as QtModule

QtModule {
    qtModuleName: "QuickDialogs2QuickImpl"
    Depends { name: "Qt"; submodules: ["quickdialogs2quickimpl"]}

    architectures: ["x86_64"]
    targetPlatform: "linux"
    hasLibrary: false
    staticLibsDebug: []
    staticLibsRelease: []
    dynamicLibsDebug: []
    dynamicLibsRelease: []
    linkerFlagsDebug: []
    linkerFlagsRelease: []
    frameworksDebug: []
    frameworksRelease: []
    frameworkPathsDebug: []
    frameworkPathsRelease: []
    libNameForLinkerDebug: undefined
    libNameForLinkerRelease: undefined
    libFilePathDebug: undefined
    libFilePathRelease: undefined
    pluginTypes: []
    moduleConfig: []
    cpp.defines: []
    cpp.systemIncludePaths: ["/home/saksham/Qt/6.5.0/gcc_64/include/QtQuickDialogs2QuickImpl/6.5.0","/home/saksham/Qt/6.5.0/gcc_64/include/QtQuickDialogs2QuickImpl/6.5.0/QtQuickDialogs2QuickImpl"]
    cpp.libraryPaths: []
    
}
