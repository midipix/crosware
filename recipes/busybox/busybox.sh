rname="busybox"
rver="1.28.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://${rname}.net/downloads/${rfile}"
rsha256="98fe1d3c311156c597cd5cfa7673bb377dc552b6fa20b5d3834579da3b13652e"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  curl -kLsO https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/bb_config_script.sh
  sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' bb_config_script.sh
  make defconfig HOSTCC=\"\${CC} -static\"
  bash bb_config_script.sh -m -s
  make oldconfig HOSTCC=\"\${CC} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j$(($(nproc)+1)) CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${rbdir}/bin"
  rm -f "${rbdir}/bin/${rname}"
  cp -a "${rname}" "${rbdir}/bin"
  for a in \$(./${rname} --list) ; do
    ln -sf "${rbdir}/bin/${rname}" "${rbdir}/bin/\${a}"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
