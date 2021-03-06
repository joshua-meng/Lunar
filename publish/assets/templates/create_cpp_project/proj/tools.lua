local Tools = {}

function Tools.isPlatformWindows()
    return util.strContains(util.platformInfo(), "win", false)
end

function Tools.getAppName()
    if Tools.isPlatformWindows() then
        return "CppApplicationName.exe"
    else
        return "./CppApplicationName"
    end
end

function Tools.make()
    local application = './CppApplicationName'
    local cmake_cmd = 'cmake .'
    local make_cmd = 'make'

    if Tools.isPlatformWindows() then
        application = 'CppApplicationName.exe'
        cmake_cmd = 'cmake -G "MinGW Makefiles'
        make_cmd = 'mingw32-make'
    end

    print('Make started ...\n')

    util.pathRemove(application)
    os.execute(cmake_cmd)
    os.execute(make_cmd)

    if not util.isPathFile(application) then
        print('Make fail.\n')
        return false
    end

    print('Make success.\n')
    return true
end

return Tools
