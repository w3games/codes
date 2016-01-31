# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
inherit git-r3 python-r1
DESCRIPTION="A command line tool that generates XDG application menus for several window managers"
HOMEPAGE="https://github.com/gapan/${PN}"
SRC_URI=""
EGIT_REPO_URI="https://github.com/gapan/${PN}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="app-text/txt2tags"
RDEPEND="${PYTHON_DEPS}
		dev-python/pyxdg"
src_install() {
	emake DESTDIR="${D}" PREFIX="${DESTTREE}" man install
}
