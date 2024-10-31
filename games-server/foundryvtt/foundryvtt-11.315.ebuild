##
#
##
EAPI=8
inherit systemd

DESCRIPTION="Foundry Virtual Table Top Server"
HOMEPAGE="https://foundryvtt.com"
SRC_URI="FoundryVTT-${PV}.zip"
SLOT="0"
LICENSE=""
KEYWORDS="~amd64"
RESTRICT="mirror strip fetch"

RDEPEND="
	acct-user/foundryvtt
	acct-group/foundryvtt
	net-libs/nodejs
"

QA_PRESTRIPPED="
	/opt/foundryvtt/resources/app/node_modules/classic-level/prebuilds/linux-x64/node.napi.glibc.node
"

pkg_nofetch() {
	elog "Download the client file ${A} from https://foundryvtt.com"
	elog "and place it into your DISTDIR directory."
}

src_unpack() {
	default

	#Run via nodejs, not the bundled executable
	rm -f ${WORKDIR}/*.so
	rm -f ${WORKDIR}/*.so.1
	rm -f ${WORKDIR}/icudtl.dat
	rm -r ${WORKDIR}/foundryvtt

	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/win32-*/
	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/darwin-*/
	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/android-*/

	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/linux-arm/

	# TODO: Make this controlled by current arch
	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/linux-arm64/

	rm -rf ${WORKDIR}/resources/app/node_modules/classic-level/prebuilds/linux-x64/node.napi.musl.node

	mkdir ${S}
	mv ${WORKDIR}/* ${S}/
}

src_install() {
	insinto /opt/foundryvtt
	doins -r ${S}/*

	keepdir /var/db/foundryvtt
	fowners -R foundryvtt:foundryvtt "${EPREFIX}/var/db/foundryvtt"

	systemd_dounit "${FILESDIR}"/foundryvtt.service
}
