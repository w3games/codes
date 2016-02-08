# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils
DESCRIPTION="a proxy tool that corresponds the new specification changes of 2ch (data abolition, attrition acquired by API)"
HOMEPAGE="http://prokusi.wiki.fc2.com/wiki/${PN}"
SRC_URI="https://www.dropbox.com/sh/i3w3rj9lgklcy3u/AAAKKzaA3PbJxW3dj4-w8mIGa/${PN}/${PN}9x-${PV}-htmlonly.zip?dl=0 -> ${P}.zip"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}9x-${PV}
src_prepare() {
	cd ${S}/src/${PN}
	unzip ${P}.zip
	S=${S}/src/${PN}/${P}
	cd ${S}
	eapply ${FILESDIR}/${P}.patch
	eapply_user
	chmod +x ${S}/{compile,configure,depcomp,install-sh,missing}
}
src_configure() {
	econf
}
src_install() {
	emake DESTDIR="${D}" install
	dodoc README.txt
	newinitd ${FILESDIR}/${PN}.init ${PN}
	newconfd ${FILESDIR}/${PN}.conf ${PN}
}
