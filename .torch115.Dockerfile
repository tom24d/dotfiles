FROM nvidia/cuda:11.5.2-cudnn8-devel-ubuntu18.04

RUN DEBIAN_FRONTEND=noninteractive \
apt-get update -y \
&& apt-get install -y --no-install-recommends \
git curl vim apt-transport-https ca-certificates \
llvm make wget \
build-essential libbz2-dev libdb-dev \
libreadline-dev libffi-dev libgdbm-dev liblzma-dev \
libncursesw5-dev libsqlite3-dev libssl-dev \
zlib1g-dev uuid-dev libgl1-mesa-dev \
&& apt-get autoremove \
&& rm -rf /var/lib/apt/lists/*

ENV HOME "/root"
ENV PYENV_ROOT "${HOME}/.pyenv"
ENV PATH "${PYENV_ROOT}/bin:${PATH}"

ENV PYTHON_VERSION 3.9.14

RUN git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv \
&& sed -Ei -e '/^([^#]|$)/ {a export PYENV_ROOT="$HOME/.pyenv" \
a export PATH="$PYENV_ROOT/bin:$PATH" \
a ' -e ':a' -e '$!{n;ba};}' ~/.profile \
&& eval "$(pyenv init --path)" \
&& eval "$(pyenv init -)" \
&& echo 'eval "$(pyenv init --path)"' >>~/.profile \
&& echo 'eval "$(pyenv init --path)"' >>~/.bashrc \
&& echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
&& pyenv install ${PYTHON_VERSION} \
&& pyenv global ${PYTHON_VERSION} \
&& . ~/.profile \
&& python -m venv work \
&& . work/bin/activate

RUN . ~/.profile \
&& pip install -U pip setuptools \
&& pip install torch torchvision torchaudio \
--extra-index-url https://download.pytorch.org/whl/cu115 \
&& pip install numpy scipy sklearn networkx

CMD ["python"]

