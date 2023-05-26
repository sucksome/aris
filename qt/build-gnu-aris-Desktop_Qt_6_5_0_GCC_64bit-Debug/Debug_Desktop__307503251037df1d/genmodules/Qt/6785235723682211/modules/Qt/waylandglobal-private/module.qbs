import '../QtModule.qbs' as QtModule

QtModule {
    qtModuleName: "WaylandGlobal"
    Depends { name: "Qt"; submodules: []}

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
    cpp.defines: ["QT_WAYLANDGLOBAL_LIB"]
    cpp.systemIncludePaths: ["/home/saksham/Qt/6.5.0/gcc_64/include","/home/saksham/Qt/6.5.0/gcc_64/include/QtWaylandGlobal","/home/saksham/Qt/6.5.0/gcc_64/include/QtWaylandGlobal/6.5.0","/home/saksham/Qt/6.5.0/gcc_64/include/QtWaylandGlobal/6.5.0/QtWaylandGlobal"]
    cpp.libraryPaths: []
    
}
