# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="A drop down terminal, similar to the consoles found in first person shooters"
HOMEPAGE="http://tilda.sourceforge.net"
SRC_URI="https://github.com/lanoxx/tilda/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/vte-2.9.1
	>=dev-libs/glib-2.30
	dev-libs/confuse
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${P}

# src_prepare() {
# 	epatch "${FILESDIR}"/${PN}-0.9.6-gdk_resources.patch
# 	epatch "${FILESDIR}"/${PN}-0.9.6-glib-single-include.patch
# }
