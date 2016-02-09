# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils
DESCRIPTION="a proxy tool that corresponds the new specification changes of 2ch (data abolition, attrition acquired by API)"
HOMEPAGE="http://xiwayy2kn32bo3ko.onion.link/test/read.cgi/tor/1424667677/
	  http://prokusi.wiki.fc2.com/wiki/${PN}"
SRC_URI="http://xiwayy2kn32bo3ko.onion.link/test/download.cgi?board=tor&id=2015111402581320163&filetype=.zip -> ${P}.zip"
SLOT="0"
KEYWORDS="~x86 ~amd64"
S=${WORKDIR}/${P}

src_prepare() {
	eapply ${FILESDIR}/${PN}-socks5h.diff
	eapply_user
}
src_install() {
	dodoc README.txt
	newinitd ${FILESDIR}/${PN}.init ${PN}
	newconfd ${FILESDIR}/${PN}.conf ${PN}
	cd ${S}/src
	make
	dobin ${PN}
}
