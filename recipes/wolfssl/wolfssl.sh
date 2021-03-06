rname="wolfssl"
rver="3.15.3"
rdir="${rname}-${rver}-stable"
rfile="v${rver}-stable.tar.gz"
rurl="https://github.com/wolfSSL/${rname}/archive/${rfile}"
rsha256="2b98d9ddac2a3188210de720051bed58f91910ee028a4b0a6dd6fd3c9ddb6fec"
rreqs="make perl m4 autoconf automake libtool zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
  touch cyassl/ctaocrypt/fips.h
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} libtoolize
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-all \
    --enable-singlethreaded \
    --enable-distro \
    --disable-fips \
    --enable-tlsv10 \
    --with-libz=\"${cwsw}/zlib/current/\" \
    --enable-jobserver=no \
    --disable-examples \
    --disable-openssh \
    --disable-opensslcoexist \
    --disable-opensslextra \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=\"-static -L${cwsw}/zlib/current/lib\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
