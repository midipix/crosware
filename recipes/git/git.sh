rname="git"
rver="2.19.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="345056aa9b8084280b1b9fe1374d232dec05a34e8849028a20bfdb56e920dbb5"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \"${cwdl}/${rname}/${rfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \"27af909c7a43ffc8b1736af19a6a68d8a5b177963ec4ddd2b2f9f0ed53bcc6ee\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-curl \
    --with-expat \
    --with-libpcre2 \
    --with-openssl \
    --with-perl=${cwsw}/perl/current/bin/perl \
    --without-iconv \
    --without-python \
    --without-tcltk \
      CC=\"\${CC}\" \
      CXX=\"\${CXX}\" \
      CFLAGS=\"\${CFLAGS}\" \
      CXXFLAGS=\"\${CXXFLAGS}\" \
      LDFLAGS=\"\${LDFLAGS}\" \
      LIBS='-lcurl -lssh2 -lssl -lcrypto -lz'
  sed -i.ORIG 's/-lcurl/-lcurl -lssh2 -lssl -lcrypto -lz/g' Makefile
  grep -ril sys/poll\\.h ${rbdir}/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} install NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  cwmkdir \"${ridir}/etc\"
  cwmkdir \"${ridir}/share/man\"
  tar -C \"${ridir}/share/man\" -Jxf \"${cwdl}/${rname}/${rfile//${rname}-${rver}/${rname}-manpages-${rver}}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
