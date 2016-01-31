# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )
inherit eutils git-r3 python-r1
DESCRIPTION="Command line tool that generates XDG menus for several window managers"
HOMEPAGE="https://github.com/gapan/${PN}"
SRC_URI="https://github.com/gapan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="app-text/txt2tags"
RDEPEND="${PYTHON_DEPS}
		dev-python/pyxdg"
src_install() {
	emake DESTDIR="${D}" PREFIX="${D}"/usr man install
}
