# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit multilib

DESCRIPTION="Open source programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+bootstrap clang debug emacs vim-syntax zsh-completion"

if [[ ${PV}	!= 9999 ]]; then
	SRC_URI="http://static.rust-lang.org/dist/${P}.tar.gz"
else
	inherit git-r3
	IUSE="${IUSE} heather"

	if use heather; then
		EGIT_REPO_URI="git://github.com/Heather/rust.git"
	else
		EGIT_REPO_URI="git://github.com/mozilla/rust.git"
	fi
fi


RDEPEND="zsh-completion? ( app-shells/zsh )"
DEPEND="${RDEPEND}
	clang? ( sys-devel/clang )
	>=dev-lang/perl-5.0
	>=dev-lang/python-2.6
"
PDEPEND="emacs? ( app-emacs/rust-mode )
	vim-syntax? ( app-vim/rust-mode )
"

src_configure() {
	"${ECONF_SOURCE:-.}"/configure \
		--prefix="${EPREFIX}"/usr \
		$(use_enable clang) \
		$(use_enable debug) \
		$(use_enable debug llvm-assertions) \
		$(use_enable !debug optimize) \
		$(use_enable !debug optimize-cxx) \
		$(use_enable !debug optimize-llvm) \
		$(use_enable !debug optimize-tests) \
		$(use_enable !bootstrap local-rust) \
		--local-rust-root="${EPREFIX}"/usr \
		--disable-manage-submodules \
	|| die
}

src_install() {
	default

	if use zsh-completion; then
		insinto "/usr/share/zsh/site-functions"
		doins src/etc/zsh/_rust
	fi

	rm -f "${ED}/usr/$(get_libdir)/librusti.so" || die
	rm -f "${ED}/usr/$(get_libdir)/librustc.so" || die
	rm -f "${ED}/usr/$(get_libdir)/librust.so" || die
	rm -f "${ED}/usr/$(get_libdir)/librustpkg.so" || die
	rm -f "${ED}/usr/$(get_libdir)/librustdoc.so" || die
}
