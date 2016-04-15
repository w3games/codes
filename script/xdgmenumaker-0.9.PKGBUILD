# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Your Name <youremail@domain.com>
pkgname=xdgmenumaker
pkgver=0.9
pkgrel=0
# epoch=
pkgdesc="Xdgmenumaker generates application menus using xdg information for blackbox, compizboxmenu, fluxbox, icewm, jwm, pekwm and windowmaker."
arch=('i686' 'x86_64')
url="https://github.com/gapan/$pkgname"
license=('GPLv3')
groups=(local)
depends=('python' 'pyxdg' 'pygtk' 'pygobject' 'gobject-introspection' 'python-xdg')
# makedepends=()
# checkdepends=()
optdepends=('txt2tags')
# provides=()
# conflicts=()
# replaces=()
# backup=()
# options=()
# install=
# changelog=
source=("https://github.com/gapan/$pkgname/archive/$pkgver.tar.gz")
# noextract=()
md5sums=('SKIP')
# validpgpkeys=()

# prepare() {
# 	cd "$pkgname-$pkgver"
# 	patch -p1 -i "$srcdir/$pkgname-$pkgver.patch"
# }

# build() {
# 	cd "$pkgname-$pkgver"
#	./configure prefix=/usr 
# 	make
# }

# check() {
# 	cd "$pkgname-$pkgver"
# 	make -k check
# }

package() {
	cd "$pkgname-$pkgver"
	make DESTDIR="$pkgdir/" PREFIX=/usr install
}
