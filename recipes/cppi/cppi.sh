rname="cppi"
rver="1.18"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="12a505b98863f6c5cf1f749f9080be3b42b3eac5a35b59630e67bea7241364ca"
rreqs="make sed flex"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
