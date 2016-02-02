# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.
pkgname=xdgmenumaker
pkgver=0.9
pkgrel=0
pkgdesc="Xdgmenumaker generates application menus using xdg information for blackbox, compizboxmenu, fluxbox, icewm, jwm, pekwm and windowmaker."
arch=('i686' 'x86_64')
url="https://github.com/gapan/$pkgname"
license=('GPLv3')
groups=(local)
depends=('python' 'pyxdg' 'pygtk' 'pygobject' 'gobject-introspection' 'python-xdg')
optdepends=('txt2tags')
source=("https://github.com/gapan/$pkgname/archive/$pkgver.tar.gz")
md5sums=('6922ab45c9b8f6cae49af6ea12417585')
package() {
	cd "$pkgname-$pkgver"
	make DESTDIR="$pkgdir/" PREFIX=/usr install
}
