FROM rockylinux:9

# Make all shells run in a safer way. Ref: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# Install rpm packages that we need. AWS Session Manager Plugin is not published in any repo that we can use, so we grab it directly from where they publish it in S3.
# hadolint ignore=DL3041
RUN dnf install -y --refresh \
  bind-utils \
  bzip2 \
  bzip2-devel \
  findutils \
  gcc \
  gcc-c++ \
  gettext \
  git \
  iptables-nft \
  jq \
  libffi-devel \
  libxslt-devel \
  make \
  ncurses-devel \
  openssl-devel \
  perl-Digest-SHA \
  readline-devel \
  sqlite-devel \
  unzip \
  wget \
  which \
  xz \
  https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm \
  && dnf clean all \
  && rm -rf /var/cache/yum/

# Install asdf. Get versions from https://github.com/asdf-vm/asdf/releases
ARG ASDF_VERSION="0.11.1"
ENV ASDF_VERSION=${ASDF_VERSION}
# hadolint ignore=SC2016
RUN git clone --branch v"${ASDF_VERSION}" --depth 1 https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" \
  && echo -e '\nsource $HOME/.asdf/asdf.sh' >> "${HOME}/.bashrc" \
  && echo -e '\nsource $HOME/.asdf/asdf.sh' >> "${HOME}/.profile" \
  && source "${HOME}/.asdf/asdf.sh"
ENV PATH="/root/.asdf/shims:/root/.asdf/bin:${PATH}"

# Install golang. Get versions using 'asdf list all golang'
ARG GOLANG_VERSION="1.19.5"
ENV GOLANG_VERSION=${GOLANG_VERSION}
RUN asdf plugin add golang \
  && asdf install golang "${GOLANG_VERSION}" \
  && asdf global golang "${GOLANG_VERSION}"

# Install golangci-lint. Get versions using 'asdf list all golangci-lint'
ARG GOLANGCILINT_VERSION="1.50.1"
ENV GOLANGCILINT_VERSION=${GOLANGCILINT_VERSION}
RUN asdf plugin add golangci-lint \
  && asdf install golangci-lint "${GOLANGCILINT_VERSION}" \
  && asdf global golangci-lint "${GOLANGCILINT_VERSION}"

# Install python. Get versions using 'asdf list all python'
ARG PYTHON_VERSION="3.11.1"
ENV PYTHON_VERSION=${PYTHON_VERSION}
RUN asdf plugin add python \
  && asdf install python "${PYTHON_VERSION}" \
  && asdf global python "${PYTHON_VERSION}"

# Install hadolint. Get versions using 'asdf list all hadolint'
ARG HADOLINT_VERSION="2.12.0"
ENV HADOLINT_VERSION=${HADOLINT_VERSION}
RUN asdf plugin add hadolint \
  && asdf install hadolint "${HADOLINT_VERSION}" \
  && asdf global hadolint "${HADOLINT_VERSION}"

# Install pre-commit. Get versions using 'asdf list all pre-commit'
ARG PRE_COMMIT_VERSION="3.0.1"
ENV PRE_COMMIT_VERSION=${PRE_COMMIT_VERSION}
RUN asdf plugin add pre-commit \
  && asdf install pre-commit "${PRE_COMMIT_VERSION}" \
  && asdf global pre-commit "${PRE_COMMIT_VERSION}"

# Install Terraform. Get versions using 'asdf list all terraform'
ARG TERRAFORM_VERSION="1.3.9"
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
RUN asdf plugin add terraform \
  && asdf install terraform "${TERRAFORM_VERSION}" \
  && asdf global terraform "${TERRAFORM_VERSION}"

# Install terraform-docs. Get versions using 'asdf list all terraform-docs'
ARG TERRAFORM_DOCS_VERSION="0.16.0"
ENV TERRAFORM_DOCS_VERSION=${TERRAFORM_DOCS_VERSION}
RUN asdf plugin add terraform-docs \
  && asdf install terraform-docs "${TERRAFORM_DOCS_VERSION}" \
  && asdf global terraform-docs "${TERRAFORM_DOCS_VERSION}"

# Install tflint. Get versions using 'asdf list all tflint'
ARG TFLINT_VERSION="0.44.1"
ENV TFLINT_VERSION=${TFLINT_VERSION}
RUN asdf plugin add tflint \
  && asdf install tflint "${TFLINT_VERSION}" \
  && asdf global tflint "${TFLINT_VERSION}"

# Install tfsec. Get versions using 'asdf list all tfsec'
ARG TFSEC_VERSION="1.28.1"
ENV TFSEC_VERSION=${TFSEC_VERSION}
RUN asdf plugin add tfsec \
  && asdf install tfsec "${TFSEC_VERSION}" \
  && asdf global tfsec "${TFSEC_VERSION}"

# Install checkov. Get versions using 'asdf list all checkov'
ARG CHECKOV_VERSION="2.3.3"
ENV CHECKOV_VERSION=${CHECKOV_VERSION}
RUN asdf plugin add checkov \
  && asdf install checkov "${CHECKOV_VERSION}" \
  && asdf global checkov "${CHECKOV_VERSION}"

# Install sops. Get versions using 'asdf list all sops'
ARG SOPS_VERSION="3.7.3"
ENV SOPS_VERSION=${SOPS_VERSION}
RUN asdf plugin add sops \
  && asdf install sops "${SOPS_VERSION}" \
  && asdf global sops "${SOPS_VERSION}"

# Install make. Get versions using 'asdf list all make'
ARG MAKE_VERSION="4.4"
ENV MAKE_VERSION=${MAKE_VERSION}
RUN asdf plugin add make \
  && asdf install make "${MAKE_VERSION}" \
  && asdf global make "${MAKE_VERSION}"

# Install adr-tools. Get versions using 'asdf list all adr-tools'
ARG ADR_TOOLS_VERSION="3.0.0"
ENV ADR_TOOLS_VERSION=${ADR_TOOLS_VERSION}
RUN asdf plugin add adr-tools \
  && asdf install adr-tools "${ADR_TOOLS_VERSION}" \
  && asdf global adr-tools "${ADR_TOOLS_VERSION}"

# Install awscli. Get versions using 'asdf list all awscli'
ARG AWSCLI_VERSION="2.11.0"
ENV AWSCLI_VERSION=${AWSCLI_VERSION}
RUN asdf plugin add awscli \
  && asdf install awscli "${AWSCLI_VERSION}" \
  && asdf global awscli "${AWSCLI_VERSION}"

# Install sshuttle. Get versions by running `pip index versions sshuttle`
ARG SSHUTTLE_VERSION="1.1.1"
ENV SSHUTTLE_VERSION=${SSHUTTLE_VERSION}
RUN pip install --force-reinstall -v "sshuttle==${SSHUTTLE_VERSION}"

# Support tools installed as root when running as any other user
ENV ASDF_DATA_DIR="/root/.asdf"

CMD ["/bin/bash"]
