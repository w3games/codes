# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools subversion

DESCRIPTION="gtk2 based 2ch browser written in C++"
HOMEPAGE="http://sourceforge.jp/projects/jd4linux"
SRC_URI=""

ESVN_REPO_URI="http://svn.sourceforge.jp/svnroot/jd4linux/jd/trunk"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="pango gnome" # migemo"

RDEPEND=">=dev-cpp/gtkmm-2.6
    >=dev-cpp/glibmm-2.6
    >=dev-libs/libsigc++-2.0
    >=dev-libs/openssl-0.9.7
     gnome? ( >=dev-cpp/libgnomeuimm-2.0.0 )"
#    migemo? ( app-text/cmigemo )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
    subversion_fetch || die

    # replacement of subversion_bootstrap
    cd ${S}
    eautoreconf || die
    sed -i -e '/^CXXFLAGS/s:-ggdb::' configure || die "sed failed"
}

src_compile() {
    local myconf
    use pango && myconf="--with-pangolayout"
    use gnome && myconf="${myconf} --with-sessionlib=gnomeui"
    #use migemo && myconf="${myconf} --with-migemo"

    ./configure --prefix=/usr ${myconf} || die
    emake || die
}

src_install() {
    make DESTDIR="${D}" install || die "make install failed"
    doicon ${PN}.png
    domenu ${PN}.desktop
    dodoc COPYING README ChangeLog INSTALL
}
