# crosware
Tools, things, stuff, miscellaneous, detritus, junk, etc., primarily for Chrome OS / Chromium OS. Eventually this will be a development-ish environment for Chrome OS on both ARM and x86 (32-bit and 64-bit for both). It should work on "normal" Linux too (Armbian, CentOS, Debian, Raspbian, Ubuntu - glibc for now since jgit requires a jdk).

## bootstrap

To bootstrap, using ```/usr/local/crosware``` with initial downloads in ```/usr/local/tmp```:

```
# allow your regular user to write to /usr/local
sudo chgrp ${GROUPS} /usr/local
sudo chmod 2775 /usr/local

# run the bootstrap
# use curl to download the primary shell script
# this in turn downloads a jdk, jgit and a toolchain
bash <(curl -kLs https://raw.githubusercontent.com/ryanwoodsmall/crosware/master/bin/crosware) bootstrap

# source the environment
source /usr/local/crosware/etc/profile
which crosware
```

## install some packages

```
# install some stuff
crosware install make busybox toybox

# update environment
source /usr/local/crosware/etc/profile

# see what we just installed
which -a make busybox toybox \
| xargs realpath \
| xargs toybox file
```

## update

To get new recipes:

```crosware update```

And to re-bootstrap (for any updated zulu, jgitsh, statictoolchain installs):

```crosware bootstrap```

### further usage

Run **crosware** without any arguments to see usage; i.e, a (possibly outdated) example:

```
usage: crosware [command]

commands:
  bootstrap : bootstrap crosware
  env : dump source-/eval-able crosware etc/profile
  help : show help
  install : attempt to build/install a package from a known recipe
  list-available : list available recipes which are not installed
  list-funcs : list crosware shell functions
  list-installed : list installed recipes
  list-recipes : list build recipes
  profile : show .profile addition
  run-func : run crosware shell function
  set : run 'set' to show full crosware environment
  show-env : run 'env' to show crosware environment
  uninstall : uninstall some packages
  update : attempt to update existing install of crosware
```

# notes

Ultimately I'd like this to be a self-hosting virtual distribution of sorts, targeting all variations of 32-/64-bit x86 and ARM on Chrome OS. A static-only GCC compiler using musl-libc (with musl-cross-make) is installed as part of the bootstrap; this sort of precludes things like emacs, but doesn't stop anyone from using a musl toolchain to build a glibc-based shared toolchain. Planning on starting out with shell script-based recipes for configuring/compiling/installing versioned "packages." Initial bootstrap looks something like:

- get a JDK (Azul Zulu OpenJDK)
- get jgit.sh (standalone)
- get static bootstrapped compiler
- checkout rest of project
- build GNU make
- build native busybox, toolbox, sed, etc. 
- build a few libs / support (ncurses, openssl, slang, zlib, bzip2, lzma, libevent, pkg-config)
- build a few packages (curl, vim w/syntax hightlighting, screen, tmux, links, lynx - mostly because I use them)

# environment

Environment stuff to figure out how to handle:

- ```PATH``` (working)
- ```PKG_CONFIG_LIBDIR/PKG_CONFIG_PATH``` (working)
- ```CC``` (working)
- ```CFLAGS``` (working)
- ```CPP``` (working)
- ```CPPFLAGS``` (working)
- ```CXX``` (working)
- ```LDFLAGS``` (working)
- ```MANPAGER``` (working)
- ```MANPATH```
- ```ACLOCAL_PATH```
- ```EDITOR``` (vim?)
- ```PAGER``` (working, set to less (gnu or busybox))

# stuff to figure out

See [the to-do list](TODO.md)

# links

Chromebrew looks nice and exists now: https://github.com/skycocker/chromebrew

Alpine and Sabotage are good sources of inspiration and patches:

- Alpine: https://alpinelinux.org/ and git: https://git.alpinelinux.org/
- Sabotage: http://sabotage.tech/ and git: https://github.com/sabotage-linux/sabotage/

The Alpine folks distribute a chroot installer (untested):

- https://github.com/alpinelinux/alpine-chroot-install

And I wrote a little quick/dirty Alpine chroot creator that works on Chrome/Chromium OS; no Docker or other software necessary.

- https://github.com/ryanwoodsmall/shell-ish/blob/master/bin/chralpine.sh

And the musl wiki has some pointers on patches and compatibility:

- https://wiki.musl-libc.org/compatibility.html#Software-compatibility,-patches-and-build-instructions

Mes might be useful at some point.

- https://gitlab.com/janneke/mes
- https://lists.gnu.org/archive/html/guile-user/2016-06/msg00061.html
- https://lists.gnu.org/archive/html/guile-user/2017-07/msg00089.html

Suckless has a list of good stuff:

- https://suckless.org/rocks/

Mark Williams Company open sourced Coherent; might be a good source for SUSv3/SUSv4/POSIX stuff:

- http://www.nesssoftware.com/home/mwc/source.php

Newer static musl compilers (GCC 6+) are "done," and should work to compile (static-only) binaries on Chrome OS:

- https://github.com/ryanwoodsmall/musl-misc/releases

# recipes

Bootstrap recipes:
- **zulu** azul zulu openjdk jvm
- **jgitsh** standalone jgit shell script
- **statictoolchain** musl-cross-make static toolchain

Working recipes:
- abcl (common lisp, https://common-lisp.net/project/armedbear/)
- autoconf
- automake
- bash (4.x, static)
- bc (gnu bc, dc)
- bdb47
- bison
- brogue
- busybox (static)
- byacc
- bzip2
- cflow
- check
- configgit (gnu config.guess, config.sub updates for musl, aarch64, etc. http://git.savannah.gnu.org/gitweb/?p=config.git;a=summary)
- coreutils (single static binary with symlinks, no nls/attr/acl/gmp/pcap/selinux)
- cppcheck
- cppi
- cscope
- cssc (gnu sccs)
- ctags (exberant ctags for now, universal ctags a better choice?)
- curl
- cvs
- cxref
- derby
- diffutils
- dropbear
- ed (gnu ed)
- expat
- file
- findutils
- flex
- gawk (gnu awk, currently appended to $PATH, should be prepended?)
- gc (working on x86\_64, aarch64; broken on i386, arm)
- gdbm
- gettext-tiny (named gettexttiny)
- git
- glib
- global
- grep (gnu grep)
- groff
- htop
- iftop
- indent
- iperf
  - iperf
  - iperf3
- j7zip
- jq (https://stedolan.github.io/jq/ - with oniguruma regex)
- jruby
- jscheme
- jython
- kawa (scheme)
- less
- libatomic\_ops (named libatomicops)
- libbsd
- libevent (no openssl support yet)
- libffi
- libgcrypt
- libgpg-error (named libgpgerror)
- libnl
- libpcap
- libssh2 (openssl, zlib)
- libtool
- libxml2
- libxslt
- links (ncurses)
- lua (posix, no readline)
- lynx (ncurses and slang, ncurses default)
- lzip
  - clzip
  - lunzip
  - lzip
  - lziprecover
  - lzlib
  - pdlzip
  - plzip
  - zutils
- m4
- make
- mbedtls (polarssl)
- mksh
- ncurses
- netbsd-curses (as netbsdcurses, manual CPPFLAGS/LDFLAGS for now - sabotage https://github.com/sabotage-linux/netbsd-curses)
- oniguruma (https://github.com/kkos/oniguruma)
- opennc (openbsd netcat http://systhread.net/coding/opennc.php)
- openssl
- p7zip
- patch (gnu)
- pcre
- pcre2
- perl
- pkg-config (named pkgconfig)
- python2 (very basic support)
- qemacs (https://bellard.org/qemacs/)
- rc (http://tobold.org/article/rc, https://github.com/rakitzis/rc - needs to be git hash, currently old release)
- rcs (gnu)
- readline
- rhino
- rlwrap
- rogue
- rsync
- screen
- sdkman (http://sdkman.io)
- sed (gnu gsed, prepended to $PATH, becomes default sed)
- sisc (scheme)
- slang
- slibtool (https://github.com/midipix-project/slibtool)
- socat
- sqlite
- suckless
  - 9base (https://tools.suckless.org/9base)
  - sbase (https://core.suckless.org/sbase)
  - ubase (https://core.suckless.org/ubase)
- svnkit
- texinfo (untested, requires perl)
- tig
- tmux
- toybox (static)
- unzip
- util-linux (as utillinux)
- vim (with syntax highlighting, which chrome/chromium os vim lacks)
- w3m (https://github.com/tats/w3m)
- wget
- wolfssl (cyassl)
- xmlstarlet (http://xmlstar.sourceforge.net/)
- xz (https://tukaani.org/xz/)
- zip
- zlib

Recipes to consider:
- ack (https://beyondgrep.com/)
- ag (the silver searcher https://geoff.greer.fm/ag/)
- assemblers?
  - fasm
  - nasm
  - vasm
  - yasm
- at&t ast (just ksh now?)
- at (http://ftp.debian.org/debian/pool/main/a/at/)
- axtls
- bigloo
- bmake (and mk, http://www.crufty.net/help/sjg/bmake.html and http://www.crufty.net/help/sjg/mk-files.htm)
- c-kermit (http://www.kermitproject.org/, and/or e-kermit...)
- chicken
- cmake
  - configure: ```./bootstrap --prefix=${cwsw}/cmake/$(basename $(pwd)) --no-system-libs --parallel=$(nproc)```
- cparser (https://pp.ipd.kit.edu/git/cparser/)
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?)
- docbook?
- dnsmasq
- dpic (https://ece.uwaterloo.ca/~aplevich/dpic/)
- duplicity (http://duplicity.nongnu.org/)
- editline (https://github.com/troglobit/editline)
- elinks (old, deprecated)
- ellcc (embedded clang build, http://ellcc.org/)
- emacs
  - 26.1 can be compiled without gnutls
  - needs aslr disabled during dump
  - or ```setarch $(uname -m) -R``` prepended to make?
- entr (http://entrproject.org/)
- gdb
- gmplib
  - needs m4
- gnutls
  - needs nettle, gmplib
  - configure needs ```--with-included-libtasn1 --with-included-unistring --without-p11-kit```
- go (chicken/egg problem with source builds on aarch64)
- gpg
- hadoop (version 2.x? 3.x? separate out into separate versioned recipes?)
- hbase (version?)
- hterm utils for chrome os (https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc)
- inetutils
- inotify-tools (https://github.com/rvoicilas/inotify-tools)
- java stuff
  - ant (included in sdkman)
  - antlr
  - beanshell
  - clojure (leiningen included in sdkman)
  - dynjs (dead?)
  - frege (https://github.com/Frege/frege)
  - gradle (included in sdkman)
  - grails (included in sdkman)
  - groovy (included in sdkman)
  - hg4j and client wrapper (https://github.com/nathansgreen/hg4j)
  - java-repl
  - jline
  - jmk (http://jmk.sourceforge.net/edu/neu/ccs/jmk/jmk.html)
  - kotlin (included in sdkman)
  - luaj
  - maven (included in sdkman)
  - mina (apache multipurpose infrastructure for network applications: java nio, ftp, sshd, etc.; https://mina.apache.org/)
  - nailgun (https://github.com/facebook/nailgun and http://www.martiansoftware.com/nailgun/)
  - nodyn (dead)
  - rembulan (jvm lua)
  - ringojs
  - sbt (included in sdkman)
  - scala (included in sdkman)
  - spark (included in sdkman)
- java jvm/jdk stuff
  - avian (https://readytalk.github.io/avian/)
  - cacao
  - jamvm
  - jikes rvm
  - maxine (https://github.com/beehive-lab/Maxine-VM)
  - openj9
  - ...
- jdbc
  - drivers
    - derby (included in derby.jar)
    - mariadb (https://mariadb.com/kb/en/library/about-mariadb-connector-j/)
    - mssql (https://github.com/Microsoft/mssql-jdbc)
    - mysql (https://dev.mysql.com/downloads/connector/j/)
    - oracle? (probably not)
    - postgresql (https://jdbc.postgresql.org/)
    - sqlite (https://bitbucket.org/xerial/sqlite-jdbc and https://github.com/xerial/sqlite-jdbc)
  - programs/clients/other
    - ha-jdbc (https://github.com/ha-jdbc/ha-jdbc)
    - henplus (https://github.com/neurolabs/henplus - formerly http://henplus.sourceforge.net/)
    - jisql (https://github.com/stdunbar/jisql)
- kerberos
  - heimdal
  - mit
- lf (https://github.com/gokcehan/lf - go)
- libedit
- libeditline
- libfuse (separate userspace? uses meson?)
- libgit2
  - uses cmake
  - needs curl, openssl, ssh2
  - configure: ```mkdir b ; cd b ; cmake -DCMAKE_INSTALL_PREFIX:PATH=${cwsw}/libgit2/$(basename $(cd .. ; pwd)) -DBUILD_SHARED_LIBS=OFF ..```
- libressl
- libtasn1
- libtirpc
- llvm / clang
- lrzsz (https://ohse.de/uwe/software/lrzsz.html)
- mailx (for sus/lsb/etc. - http://heirloom.sourceforge.net/mailx.html or https://www.gnu.org/software/mailutils/mailutils.html)
- man stuff
  - man-pages (https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/)
  - man-pages-posix (https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/man-pages-posix/)
  - stick with busybox man+groff+less or use man-db or old standard man?
  - MANPAGER and MANPATH settings
- mercurial / hg
  - need docutils: ```env PATH=${cwsw}/python2/current/bin:${PATH} pip install docutils```
  - config/build/install with: ```env PATH=${cwsw}/python2/current/bin:${PATH} make <all|install> PREFIX=${ridir} CPPFLAGS="${CPPFLAGS}" LDFLAGS="${LDFLAGS//-static/}" CFLAGS='' CPPFLAGS=''```
- meson (http://mesonbuild.com/ - python 3 and ninja)
- mg (https://github.com/hboetes/mg _or_? https://github.com/troglobit/mg)
- moreutils (https://joeyh.name/code/moreutils/)
- mpg123
- mpg321
- musl-utils
  - should these be in statictoolchain, i.e in https://github.com/ryanwoodsmall/musl-misc?
  - getconf (https://git.alpinelinux.org/cgit/aports/tree/main/musl/getconf.c)
  - getent (https://git.alpinelinux.org/cgit/aports/tree/main/musl/getent.c)
  - iconv (https://git.alpinelinux.org/cgit/aports/tree/main/musl/iconv.c)
- mutt
- nc / ncat / netcat
- nethack
- nettle
  - configure libdir=.../lib since lib64 may be set by default
- ninja
- node / npm (ugh)
- noice (https://git.2f30.org/noice/)
- nnn (https://github.com/jarun/nnn)
- nss (ugh)
- num-utils (http://suso.suso.org/programs/num-utils/index.phtml)
- openconnect
- p11-kit (https://p11-glue.github.io/p11-glue/p11-kit.html)
  - probably not...
  - "cannot be used as a static library" - what?
  - needs libffi, libtasn1
  - configure ```--without-libffi --without-libtasn1```
- parenj / parenjs
- pass (https://www.passwordstore.org/)
- pax
- pcc (http://pcc.ludd.ltu.se/)
- picolisp
  - picolisp (c, lisp)
  - ersatz picolisp (java)
- pigz
- plan9port (without x11; necessary? already have stripped down suckless 9base)
- procps-ng
- psmisc
- qemu
- racket
- ranger (https://ranger.github.io - python)
- rover (https://lecram.github.io/p/rover)
- rpcbind
- rvm?
- sharutils
- shells?
  - dash
  - es (https://github.com/wryun/es-shell)
  - fish
  - pdksh
  - tcsh (and/or standard csh)
  - zsh
- shuffle (http://savannah.nongnu.org/projects/shuffle/)
- sljit (http://sljit.sourceforge.net/)
- spidermonkey
- spidernode
- sparse (https://sparse.wiki.kernel.org/index.php/Main_Page)
- splint (https://en.wikipedia.org/wiki/Splint_(programming_tool))
- squashfs-tools (https://github.com/plougher/squashfs-tools/tree/master/squashfs-tools)
- sslwrap (http://www.rickk.com/sslwrap/ way old)
- strace
- stunnel
- subversion / svn
  - needs apr/apr-util (easy) and serf (uses scons, needs fiddling)
- tcc (http://repo.or.cz/w/tinycc.git)
- tinyscheme
- tinyssh (https://tinyssh.org and https://github.com/janmojzis/tinyssh)
- tre (https://github.com/laurikari/tre)
- tsocks
- upx (https://github.com/upx/upx)
- utalk (http://utalk.ourproject.org/)
- vifm (https://github.com/vifm/vifm)
- vpnc
- ytalk (http://ytalk.ourproject.org/)
- support libraries for building the above
- heirloom project tools (http://heirloom.sourceforge.net/)
- whatever else seems useful

Bootstrap recipes that need work (i.e., arch-specific versions installed into /usr/local/tmp/bootstrap, archive, etc.);
these could be used to create a fully functional build environment/initrd/chroot/container/etc.
- 9base
- bash
- busybox
- coreutils
- curl (https, static mbedtls binary is probably best candidate)
- dropbear
- git (https/ssh, could replace jgit, not require a jdk?)
- make
- openssl
- sbase
- statictoolchain
- toybox
- ubase
- utillinux
