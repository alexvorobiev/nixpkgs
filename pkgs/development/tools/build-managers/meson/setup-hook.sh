mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "$dontAddPrefix" ]; then
        mesonFlags="--prefix=$prefix $mesonFlags"
    fi

    # See multiple-outputs.sh and meson’s coredata.py
    mesonFlags="\
        --libdir=${!outputLib}/lib --libexecdir=${!outputLib}/libexec \
        --bindir=${!outputBin}/bin --sbindir=${!outputBin}/sbin \
        --includedir=${!outputInclude}/include \
        --mandir=${!outputMan}/share/man --infodir=${!outputInfo}/share/info \
        --localedir=${!outputLib}/share/locale \
        $mesonFlags"

    # Build release by default.
    mesonFlags="--buildtype=${mesonBuildType:-release} $mesonFlags"

    echo "meson flags: $mesonFlags ${mesonFlagsArray[@]}"

    meson build $mesonFlags "${mesonFlagsArray[@]}"
    cd build

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "meson: enabled parallel building"
    fi

    runHook postConfigure
}

if [ -z "$dontUseMesonConfigure" -a -z "$configurePhase" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi

mesonCheckPhase() {
    runHook preCheck

    meson test

    runHook postCheck
}

if [ -z "$dontUseMesonCheck" -a -z "$checkPhase" ]; then
    checkPhase=mesonCheckPhase
fi
