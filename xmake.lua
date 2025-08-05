set_version("0.9.4")
set_languages("c++14")

add_rules("mode.debug", "mode.release")

-- compile_commands.json
add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})

if is_plat("windows") then
    set_runtimes("MD")
    if is_mode("debug") then
        set_runtimes("MDd")
    end
end

add_includedirs(".")
add_includedirs("external/imgui")

target("imgui")
    set_kind("static")
    set_basename("imgui$(mode)") 
    
    add_files("external/imgui/imgui.cpp")
    add_files("external/imgui/imgui_draw.cpp") 
    add_files("external/imgui/imgui_tables.cpp")
    add_files("external/imgui/imgui_widgets.cpp")

    add_headerfiles("external/imgui/imgui.h")
    add_headerfiles("external/imgui/imgui_internal.h")
    add_headerfiles("external/imgui/imconfig.h")
    
    -- Disable obsolete ImGui functions
    add_defines("IMGUI_DISABLE_OBSOLETE_FUNCTIONS")

    if is_plat("windows") then
        add_defines("IMGUI_API=")
    end

target("cimguinodeeditor")
    set_kind("shared")
    set_basename("cimguinodeeditor")
    
    add_files("imgui_node_editor.cpp")
    add_files("imgui_node_editor_api.cpp") 
    add_files("imgui_canvas.cpp")
    add_files("crude_json.cpp")
    
    add_headerfiles("imgui_node_editor.h")
    add_headerfiles("imgui_node_editor_internal.h")
    add_headerfiles("imgui_canvas.h")
    add_headerfiles("crude_json.h")

    add_headerfiles("imgui_*.h", "imgui_*.inl")
    add_deps("imgui")

    -- Disable obsolete ImGui functions
    add_defines("IMGUI_DISABLE_OBSOLETE_FUNCTIONS")
    
    if is_plat("windows") then
        add_defines("IMGUI_NODE_EDITOR_API=extern \"C\" __declspec(dllexport)")
        add_defines("IMGUI_API=")
        add_shflags("/IMPLIB:$(builddir)/cimguinodeeditor.lib")
    else
        add_defines("IMGUI_NODE_EDITOR_API=extern \"C\" __attribute__((visibility(\"default\")))")
        add_cxflags("-fvisibility=hidden")
    end
