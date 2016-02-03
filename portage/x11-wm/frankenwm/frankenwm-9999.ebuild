# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 savedconfig toolchain-funcs
DESCRIPTION="A fast dynamic tiling window manager"
HOMEPAGE="https://github.com/sulami/${PN}/"
MY_P=v${PV}
SRC_URI=""
#EGIT_REPO_URI="https://github.com/sulami/FrankenWM/"
EGIT_REPO_URI="https://github.com/sulami/${PN}/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-keysyms"
RDEPEND="${COMMON_DEPEND}"
S=${WORKDIR}/${P}
src_prepare() {
	restore_config config.h
	eapply_user
}
src_compile() {
	emake PREFIX=/usr CC="$(tc-getCC)"
}
src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README.md
	echo ${PN} > "${T}"/${PN}
	exeinto /etc/X11/Sessions
	doexe "${T}"/${PN}
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop
	save_config config.h
}
