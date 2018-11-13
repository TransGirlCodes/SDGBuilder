using BinaryBuilder

name = "bsgjl"
version = v"0.0.1"

sources = [
    "https://github.com/bioinfologics/bsg.git" =>
    "c4c26975670fd40203b8355b65aa71df6a0a2308",
]

script = raw"""
cd $WORKSPACE/srcdir
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_FIND_ROOT_PATH=${prefix} -DJulia_PREFIX=${prefix} -DBUILD_JULIA_INTERFACE=on ../bsg
make libbsg libbsgjl
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = Platform[]
_abis(p) = (:gcc7, :gcc8)
_archs(p) = (:x86_64,)

for p in (Linux, MacOS)
    for a in _archs(p)
        for abi in _abis(p)
            push!(platforms, p(a, compiler_abi = CompilerABI(abi)))
        end
    end
end

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libbsg", :libbsg),
    LibraryProduct(prefix, "libbsgjl", :libbsgjl)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/Bzip2Builder/releases/download/v1.0.6-1/build_Bzip2.v1.0.6.jl",
    "https://github.com/BenJWard/ZLibBuilder/releases/download/v1.2.11/build_ZLibBuilder.v1.2.11.jl",
    "https://github.com/JuliaInterop/libcxxwrap-julia/releases/download/v0.5.1/build_libcxxwrap-julia-1.0.v0.5.1.jl",
    "https://github.com/JuliaPackaging/JuliaBuilder/releases/download/v1.0.0-2/build_Julia.v1.0.0.jl"
]

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)