# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

FROM quay.io/fedora/fedora:44
RUN dnf copr enable -y sisyphus1813/odin-lang \
    && dnf install -y \
    bash-completion-2.17 \
    clang-22.1.8 \
    git-2.55.0 \
    hadolint-2.14.0 \
    kcov-43 \
    libXcursor-devel-1.2.3 \
    libXi-devel-1.8.3 \
    libXinerama-devel-1.1.5 \
    libxkbcommon-devel-1.13.1 \
    libXrandr-devel-1.5.4 \
    lldb-22.1.8 \
    mesa-libGL-devel-26.1.5 \
    odin-lang-2026.07 \
    ols-2026.06 \
    yamllint-1.38.0 \
    && dnf clean all
RUN useradd -m developer
USER developer
