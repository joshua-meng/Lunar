function parseFileType(filename)

	local path, name = util.splitPathname(filename)

	-- Lunar extension
	if name == "extension.lua" then
		if util.isPathFile(path .. "/Lunar") or util.isPathFile(path .. "/Lunar.exe") then
			return 
                {
                    type = "lua", 
                    auto_complete_type = 1, 
                    api = "apis/lua/standard,apis/lua/util" ,
                    comment_line = "--",
					comment_block_begin = "--[[",
					comment_block_end = "]]"
                }
		end
	end

    if string.lower(util.fileExtension(name)) == "lua" and util.isPathFile("./cocos_run.lua") then
		return 
            {
                type = "lua", 
                auto_complete_type = 1, 
                api = "apis/lua/standard,cocos.api", 
                executor = "luaexec",
                project_src_dir = "src/app",
                plugin_goto = "plugins/goto_cocos_lua.lua",
                plugin_parse_api = "plugins/parse_supplement_api_cocos_lua.lua", 
                comment_line = "--",
				comment_block_begin = "--[[",
				comment_block_end = "]]"
            }
	end

	if string.lower(util.fileExtension(name)) == "lua" then
		return 
            {
                type = "lua", 
                auto_complete_type = 1, 
                api = "apis/lua", 
                executor = "luaexec",
                plugin_goto = "plugins/goto_lua.lua",
                plugin_parse_api = "plugins/parse_supplement_api_lua.lua", 
                comment_line = "--",
				comment_block_begin = "--[[",
				comment_block_end = "]]"
            }
	end
    
	if string.lower(util.fileExtension(name)) == "m" then
		return 
            {
                type = "octave", 
                auto_complete_type = 0,
                api = "apis/octave", 
                executor = "octave", 
                plugin_parse_api = "plugins/parse_supplement_api_octave.lua", 
                comment_line = "%"
            }
	end
	
	if string.lower(util.fileExtension(name)) == "js" then
		return 
            {
                type = "javascript", 
                auto_complete_type = 0,
                api = "apis/javascript", 
                executor = "", 
                comment_line = "//",
				comment_block_begin = "/*",
				comment_block_end = "*/"
            }
	end
	
	if string.lower(util.fileExtension(name)) == "html" then
		return 
            {
                type = "html", 
                auto_complete_type = 0,
				api = "apis/html", 
                executor = "firefox",
				comment_block_begin = "<!--",
				comment_block_end = "-->"
            }
	end
	
	if string.lower(util.fileExtension(name)) == "css" then
		return 
            {
                type = "css", 
                auto_complete_type = 0,
				api = "apis/css",
				comment_block_begin = "/*",
				comment_block_end = "*/"
            }
	end
    
    if string.lower(util.fileExtension(name)) == "sh" then
        return { type = "bash", comment_line = "#", api = "apis/bash" }
    end
    
	if string.lower(name) == "cmakelists.txt" or string.lower(util.fileExtension(name)) == "cmake" then
		return { type = "cmake", comment_line = "#", api = "apis/cmake" }
	end
    
    if string.lower(util.fileExtension(name)) == "py" then
        local python3 = "python3"
        if util.strContains(util.platformInfo(), "win", false) then
            python3 = "python"
        end
        
        return 
            {
                -- python3
                type = "python",
                auto_complete_type = 1,
                api = "apis/python",
                executor =  python3 .. " -u",
                plugin_goto = "plugins/goto_python.lua",
                plugin_parse_api = "plugins/parse_supplement_api_python3.lua", 
                comment_line = "#"
                
                -- python2
                --type = "python",
                --auto_complete_type = 1,
                --api = "apis/python/python",
                --executor = "python -u",
                --plugin_goto = "plugins/goto_python.lua",
                --plugin_parse_api = "plugins/parse_supplement_api_python.lua", 
                --comment_line = "#"
            }
    end

    if string.lower(util.fileExtension(name)) == "rb" then
        return 
            {
                -- python3
                type = "ruby",
                auto_complete_type = 0,
                api = "apis/ruby",
                executor = "ruby",
                comment_line = "#",
                comment_block_begin = "=begin\n",
				comment_block_end = "\n=end"
            }
    end
 
    
    if string.lower(util.fileExtension(name)) == "tcl" then
        return { type = "tcl", comment_line = "#" }
    end
    
    if string.lower(util.fileExtension(name)) == "java" then
        return 
			{ 
				type = "java",
				api = "apis/java", 
				comment_line = "//",
				comment_block_begin = "/*",
				comment_block_end = "*/"
			}
    end
    
    if string.lower(util.fileExtension(name)) == "cs" then
        return 
			{ 
				type = "csharp", 
				comment_line = "//",
				comment_block_begin = "/*",
				comment_block_end = "*/"
			}
    end
    
    if string.lower(util.fileExtension(name)) == "xml" or
       string.lower(util.fileExtension(name)) == "axml" or
       string.lower(util.fileExtension(name)) == "xaml" or
	   string.lower(util.fileExtension(name)) == "xsd" or
	   string.lower(util.fileExtension(name)) == "jxl" or
	   string.lower(util.fileExtension(name)) == "rxl" or
       string.lower(util.fileExtension(name)) == "tmx" or
	   string.lower(util.fileExtension(name)) == "project" then
        return 
			{ 
				type = "xml",
				comment_block_begin = "<!--",
				comment_block_end = "-->"
			}
    end
    
    if string.lower(util.fileExtension(name)) == "c" or
       string.lower(util.fileExtension(name)) == "h" or
       string.lower(util.fileExtension(name)) == "cpp" or
       string.lower(util.fileExtension(name)) == "hpp" or
       string.lower(util.fileExtension(name)) == "cxx" or
       string.lower(util.fileExtension(name)) == "hxx" then
        return 
            { 
                type = "cpp",
                api = "apis/cpp",
                auto_complete_type = 1,
				plugin_goto = "plugins/goto_cpp.lua",
				plugin_parse_api = "plugins/parse_supplement_api_cpp.lua", 
                comment_line = "//",
				comment_block_begin = "/*",
				comment_block_end = "*/"
            }
    end
end

function fileFilter()
	filter = {}
	table.insert(filter, "Lua Files(*.lua)")
    table.insert(filter, "Python Files(*.py)")
    table.insert(filter, "Ruby Files(*.rb)")
	table.insert(filter, "Bash Files(*.sh)")
	table.insert(filter, "Octave Files(*.m)")
    table.insert(filter, "Tcl Files(*.tcl)")
    table.insert(filter, "C/C++ Files(*.cpp;*.hpp;*.cxx;*.hxx;*.c;*.h)")
	table.insert(filter, "C# Files(*.csharp)")
	table.insert(filter, "Java Files(*.java)")
	table.insert(filter, "JavaScript Files(*.js)")
    table.insert(filter, "Xml Files(*.xml)")
    table.insert(filter, "Html Files(*.html)")
	table.insert(filter, "CSS Files(*.css)")
    
	return filter
end

function isLegalFile(filename)
	local ext = util.fileExtension(filename)
    if ext == "lua" or
        ext == "m" or
        ext == "sh" or
		ext == "bat" or
		ext == "cmd" or
        ext == "txt" or
        ext == "cmake" or
        ext == "py" or
        ext == "rb" or
        ext == "tcl" or
        ext == "java" or
        ext == "cs" or
        ext == "xml" or
        ext == "axml" or
        ext == "xaml" or
        ext == "tmx" or
		ext == "xsd" or
		ext == "jxl" or
		ext == "rxl" or
        ext == "html" or
        ext == "c" or
        ext == "h" or
        ext == "cpp" or
        ext == "cxx" or
        ext == "hpp" or
        ext == "hxx" or
        ext == "js" or
		ext == "css" or
        ext == "inf" or
		ext == "json" or
		ext == "mk" or
		ext == "api" or
		ext == "properties" or
		ext == "gitignore" or
		ext == "project" or
		ext == "classpath" or
		ext == "md" or
		ext == "cfg" or
        ext == "log" then
        
        return true
    end
    
    local base  = util.fileBaseName(filename)
    if string.lower(base) == "makefile" then
        return true
    end
	
	return false
end
