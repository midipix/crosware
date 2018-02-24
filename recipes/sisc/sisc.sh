rname="sisc"
rver="1.16.6"
rurl="https://sourceforge.net/projects/${rname}/files/SISC/${rver}/${rname}-${rver}.tar.gz/download"
rfile="$(basename ${rurl//\/download/})"
rdir="${rname}-${rver}"
rsha256="65e15ac81d96e97de3ecabd409b3d2bc9307e624f46908d9f74047175c527ecf"
rprof="${cwetcprofd}/${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'export SISC_HOME=\"${cwsw}/${rname}/current\"' > "${rprof}"
  echo 'append_path \"\${SISC_HOME}\"' >> "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwextract "${cwdl}/${rfile}" "${cwsw}/${rname}"
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"