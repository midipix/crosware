# TODO

- need to set ```set -o pipefail```? prolly
  - and ```trap...```
  - and use ```... ||:``` as a ```... || true``` shortcut
- need initial package installs as part of bootstrap?
  - make, sed, gettexttiny, gawk, ...
- check that we are running as root
  - note on perms if sudo/root is not wanted
- top directory (/usr/local/crosware)
  - will need to checkout repo in ```$(dirname ${cwtop})```
  - software install dir (/usr/local/crosware/software/packagename/packagename-vX.Y.Z)
  - download dir (/usr/local/crosware/download or ~/Downloads)
  - build dir (/usr/local/crosware/build)
  - current/previous symlinks for versioned installs
  - ignore directories with generated files (path, cpp/ld flags, ...)
  - ignore software install dir
- files to source w/path, compiler vars, pkg-config, etc.
  - top-level etc/profile to source
  - sources an etc/local and/or etc/local.d with shell snippets (obvious, local settings)
  - reads in generated shell snippets (one per package) to set:
    - PATH (etc/paths.d)
    - CC, CXX, CFLAGS, CXXFLAGS, CPPFLAGS, LDFLAGS (etc/cppflags.d, etc/ldflags.d, ...)
    - PKG_CONFIG_PATH, PKG_CONFIG_LIBDIR (etc/pkg-config.d)
- dependencies and dependants (maybe?)
  - simple directory of files with pkgname.dependents, pkgname.dependencies
- install must chase down upstream deps
- update may require downstream dep updates
  - var/deps/recipename/depname
  - var/reqs/recipename/reqname
- etc/local.d - scriptlets, not tracked in git
- var/ - track installs/versions
- update environment without rebootstrap
- profile.d file writer
- zulu, jgitsh, statictoolchain split out to separate install functions
  - trim down bootstrap/make
  - make them easier to upgrade
  - and cwbootstrap_... for statictoolchain/zulu/jgitsh
  - much easier to do that for manually installed git clones
  - can run individual steps with cwrunfunc
- recipes
  - rname - recipe name
  - rver - recipe version
  - rrel - internal release to aid upgrade? - XXX
  - rbreqs - split rreqs into normal requirements (rreqs) and build requirements
  - rbdir - recipe build dir
  - rtdir - recipe top dir where installs are done
  - ridir - versioned recipe install dir
  - rprof - profile.d file
  - rdeps / rbdeps? - deps and build deps?
  - rdesc - recipe description?
  - rsite - url for recipe
  - rlicense - license
  - rold - list of old versions to clean up recipes that do not fully remove rdir?
  - need to set sane default r* values in common.sh with ```: ${rblah:="blah.setting"}```
  - unset vals after parse so there is no bleed through?
  - generic profile.d generator
    - find bin dir, append_path it
    - find pc files, append_pkgcfg the dirs
    - libs...
    - inclues...
  - custom/pre/post functions
- recipe/function names
  - need _ instead of -
- whatprovides functionality
  - given a program or dir/subdir/blah path pattern dump the all directory names under software/ that match
  - generate index of files at install time
- os detector
  - chrome os/chromium os
  - alpine
  - centos
  - debian
  - ubuntu
- deleted recipes cannot be uninstalled (i.e, break when moving bison.sh to .OFF)
- cppflags/ldflags need to have dupes removed
- need ca certs for links/lynx/etc.
- setup a sysroot directory structure?
  - perl recipe has a simple example
  - fake /bin, /lib, /usr/bin, /usr/include, /usr/lib from static toolchain
  - link in/bind mount
  - add busybox/toybox (and real bash) for a chroot-able environment?
- man wrapper
  - busybox (man), less, groff
  - sets PAGER to (real less) ```less -R```
  - MANPATH?
- need a fallback mirror
- XXX - unset recipe vars should be a list
- XXX - cwinstall() should likely use associative array to only do a single install
  - i.e., ```crosware install make m4 make flex make``` should only install the make recipe *once*
- XXX - zulu/statictoolchain/jgitsh should have cwinstall/cwname/cwver/_... funcs
- XXX - downloads now go into ${cwdl}/${rname}/${rfile}
  - and all fetching should happen in cwfetch_recipe func
  - can run offline after all fetches are done
- XXX - use wget instead of curl?
  - ```wget -O -``` works (as does busybox version, which should be available everywhere
  - ssl/tls with busybox version may be funky
  - curl could theoretically bootstrap itself...
  - ... but openssl req needs perl, which requires things that need curl
    - mbedtls
- make jobs may need common cwmakeopts var
- ```strip``` script command
  -traverse ${cwtop}/software/*/*/bin/ and run ```strip --strip-all``` on any ELF binaries
- compiler opts
  - http://www.productive-cpp.com/hardening-cpp-programs-executable-space-protection-address-space-layout-randomization-aslr/
  - pic/pie/...
  - need to explore -fpic/-fPIC and -fpie/-fPIE and -pie
    - -fPIC works on x86_64/aarch64 at least
    - manually specified for now in recipe opt
  - -static-pie in GCC 7/8/+
  - force -static-libgcc -static-libstdc++
- ```archive``` step/script command to save tar of installed binary dir?
- cwrunfunc needs to be able to handle arguments
- LDFLAGS is over-expanded here, can probably remove \${LDFLAGS}
  - cannot set to bare ```-static``` in etc/profile and remove it from statictoolchain profile.d
  - statictoolchain profile.d file is self-contained, do not need any more environment to use it
  - do not muck with that
  - do something like this in etc/profile after all shell snippet parsing:
    - ```export LDFLAGS="-static ${LDFLAGS//-static /}"```
  - otherwise need a hash of seen flags to trim dupes, that gets slow if generalized
- need CW_EXT_GIT functionality
  - override provided jgit
  - ```CW_GIT_CMD```?
  - jigtsh/git should also provide ```${cwgitcmd}```
  - prefer git over jgitsh?
- hardlinks in statictoolchain archives?
  - should be symlinks, but may not be
- cwgenrecipe list
  - generate an .md with recipe names, versions, sites, etc.
- replace etc/profile append/prepend function subshells with ```if [[ ${1} =~ ${FLAGS} ]]```
  - speeds up processing of environment by ~2x
  - does not work for CPPFLAGS/LDFLAGS? becaues of -I or -L? or...?
  - looks like an early vs late eval thing when pattern matching using ```if [[ ... =~ ... ]]```?
- ```run-command``` function?
  - run a command in the crosware environment
  - useful for pkg-config, etc.
- function to update config.sub, config.guess, etc.
  - add a recipe for it?
  - http://git.savannah.gnu.org/gitweb/?p=config.git
- certs for openssl/wolfssl/mbedtls/gnutls/...
- recipes that need slibtool need a flag to set/use LIBTOOL=... on make/make install; i.e.:
```
: ${rlibtool:=""}

if [[ ${rlibtool} == "" && ${rreqs} =~ slibtool ]] ; then
  rlibtool="LIBTOOL='${cwsw}/slibtool/current/bin/slibtool-static -all-static'"
fi

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

unset rlibtool
```
- recipes that need autoreconf/libtoolize/etc. flag
- cwextract
  - which form to use? is this simpler?
  - separate out (de)compressor from (un)archiver?
    - ```bzcat ${archive}    | tar -C ${tgtdir} -xf -```
    - ```gzip -dc ${archive} | tar -C ${tgtdir} -xf -```
    - ```xzcat ${archive}    | tar -C ${tgtdir} -xf -```
  - add decompressors to prereqs check
- per-recipe environment variable listing declared variables
  - unset at end of recipe to discourage env var leaks
  - unset in main script as well to double-check
  - compare before/after environment and bail if anything is left dangling
- log builds
  - something like ```... 2>&1 | tee ${cwtop}/var/log/builds/${TS}-${rname}.out``` on main cwinstall() and for each prereq in cwcheckreqs_${rname}()
  - probably need associated log cleaning command
- native linux32/linux64 personality environment variable based on ${karch} for ```busybox setarch ____ -R cmd``` to disable ASLR
  - or just use util-linux ```setarch $(uname -m) -R cmd```?
- do ```unset d ; unset p``` at the end of **etc/profile**
  - might bleed through to recipe vars?
- linting, testing
  - bats (https://github.com/sstephenson/bats)
  - shellcheck (https://www.shellcheck.net/ and https://github.com/koalaman/shellcheck)
- static tool chain vars:
  - can be used to contruct a sysroot (i.e., in perl recipe)
  - cwstarch: ```gcc -dumpmachine```
  - cwsttop: ```cd $(dirname $(which gcc))/../ && pwd```
  - cwstbin: ```${cwsttop}/bin```
  - cwstlib: ```${cwsttop}/lib```
  - cwstabin: ```${cwsttop}/${cwstarch}/bin```
  - cwstainclude: ```${cwsttop}/${cwstarch}/include```
  - cwstalib: ```${cwsttop}/${cwstarch}/lib```
- prereqs really need to be a graph
  - ```install```, ```upgrade-all``` need to work on a dag
    - check prereq installed _or_...
    - check if installed prereq needs upgrade
    - recursively chase down to "root", i.e., until prereq graph is empty (or has only **make**)
    - only do this once - expensive
- need custom **cwclean_${rname}** for recipes where ```${rdir} != ${rbdir}``` and ```${rbdir} != ${cwbuild}/${rdir}```
