workspace "Hazel"
architecture "x64"

configurations
{
    "Debug",
    "Release",
    "Dist"        
}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir ={}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"

project "Hazel"
    location "Hazel"
    kind "SharedLib"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir    ("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader "hzpch.h"
    pchsource "Hazel/src/hzpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
        "C:/dev/Hazel-s/Hazel/vendor/spdlog/include",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}"
    }



    links 
    { 
        "GLFW",
        "Glad",
        "opengl32.lib"
    }

    filter "system:windows"
        cppdialect "C++20"
        staticruntime "On"
        systemversion "latest"
        buildoptions { "/utf-8" }

        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL",
            "GLFW_INCLUDE_NONE"
        }

        postbuildcommands
        {   
            -- Make sure the Sandbox output folder exists
            ("{MKDIR} ../bin/" .. outputdir .. "/Sandbox"),

            -- Copy Hazel.dll into the Sandbox output folder
            ("{COPYFILE} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/Hazel.dll\"")
        }



    filter "configurations:Debug"
        defines "HZ_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        buildoptions "/MD"
        optimize "On"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir    ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "C:/dev/Hazel-s/Hazel/vendor/spdlog/include",
        "Hazel/src"
    }

    links
    {
        "Hazel"
    }

    filter "system:windows"
        cppdialect "C++20"
        staticruntime "On"
        systemversion "latest"
        buildoptions { "/utf-8" }

        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        buildoptions "/MD"
        optimize "On"
