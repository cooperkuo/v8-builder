set VERSION=%1

git config --global user.name "V8 Windows Builder"
git config --global user.email "v8.windows.builder@localhost"
git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true

cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
git checkout aa494771a85e13ec0b05546ae557f04452d4e0e1
cd ..
set PATH=%CD%\depot_tools;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient

call python --version


mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
cd v8
call git checkout 8.4.371.19
cd test\test262\data
call git config --system core.longpaths true
call git restore *
cd ..\..\..\
call gclient sync

echo =====[ Building V8 ]=====
call python .\tools\dev\v8gen.py x64.release -vv -- target_os="""win""" is_component_build=true use_custom_libcxx=false is_clang=false use_lld=false v8_enable_i18n_support=false v8_use_snapshot=false v8_use_external_startup_data=false symbol_level=0
