# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils
DESCRIPTION="A small program designed for UNIX based systems to quickly paste any piece of text to Pastebin.com."
SRC_URI="http://pastebin.com/etc/${PF}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S=${WORKDIR}/${P}
src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PF}.patch
}
src_compile() {
	emake
}
src_install() {
	einstall
}
