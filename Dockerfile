FROM ubuntu:24.04

ARG DEVPROXY_VERSION=1.0.0
ARG USERNAME=devproxy
ENV DEVPROXY_VERSION=${DEVPROXY_VERSION}

EXPOSE 8000 8897

LABEL name="dev-proxy/dev-proxy:${DEVPROXY_VERSION}" \
  description="Dev Proxy is an API simulator that helps you effortlessly test your app beyond the happy path." \
  homepage="https://aka.ms/devproxy" \
  maintainers="Waldek Mastykarz <waldek@mastykarz.nl>, \
  Garry Trinder <garry.trinder@live.com>" \
  org.opencontainers.image.source=https://github.com/dotnet/dev-proxy \
  org.opencontainers.image.description="Dev Proxy is an API simulator that helps you effortlessly test your app beyond the happy path." \
  org.opencontainers.image.licenses=MIT

WORKDIR /app

RUN apt -y update && apt -y upgrade && \
    apt install -y \
    curl unzip && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Create a new user
    useradd -ms /bin/bash ${USERNAME} && \
    # Install Dev Proxy
    /bin/bash -c "$(curl -sL https://aka.ms/devproxy/setup.sh)" -- v${DEVPROXY_VERSION} && \
    echo "export PATH=$PATH:$(pwd)/devproxy" >> /home/${USERNAME}/.bashrc && \
    # Create a directory for the configuration & root certificate
    mkdir -p /home/${USERNAME}/.config/dev-proxy/rootCert && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

# Prevents error "Couldn't find a valid ICU package" when running Dev Proxy
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    # Required for .NET to properly resolve SpecialFolder.ApplicationData
    XDG_DATA_HOME=/home/${USERNAME}/.config \
    # Put the root certificate in a sub folder so that it can be mounted
    DEV_PROXY_CERT_PATH=rootCert/rootCert.pfx

VOLUME /home/${USERNAME}/.config/dev-proxy/rootCert
VOLUME /config
WORKDIR /config

USER ${USERNAME}

ENTRYPOINT ["/app/devproxy/devproxy", "--ip-address", "0.0.0.0"]
