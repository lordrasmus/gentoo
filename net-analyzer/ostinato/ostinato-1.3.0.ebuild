# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Packet generator and analyzer"
HOMEPAGE="https://ostinato.org/"
SRC_URI="https://github.com/pstavirs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

#https://github.com/pstavirs/ostinato/issues/173
# libpcap dep is versioned to pull in the fix for #602098
RDEPEND="
	<dev-libs/protobuf-22.5:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-libs/libnl:3
	>=net-libs/libpcap-1.8.1-r2
"
DEPEND="${RDEPEND}
	dev-qt/qtsvg:5
	dev-qt/qtxml:5"

PATCHES=(
	"${FILESDIR}/${PN}-0.9_p20180522-no-modeltest.patch"
)

src_configure() {
	sed -i 's#"/drone"#"/ostinato-drone"#' client/mainwindow.cpp || die
	eqmake5 PREFIX="/usr" ost.pro
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
	mv "${ED}"/usr/bin/{drone,ostinato-drone} || die
}
