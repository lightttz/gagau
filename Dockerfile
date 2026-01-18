FROM python:3.10-slim

# Instalar dependências de rede e sistema
RUN apt-get update && apt-get install -y \
    curl tar wget procps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Baixar o AppHub Pro (O "cérebro" do GagaNode)
RUN wget -O gaga.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz \
    && tar -zxf gaga.tar.gz \
    && mv apphub-linux-amd64 gaga_files \
    && rm gaga.tar.gz

# Copiar o script de inicialização
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Porta opcional para monitoramento
EXPOSE 7860

CMD ["./entrypoint.sh"]
