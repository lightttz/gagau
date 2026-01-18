FROM python:3.10-slim

# Instalar dependências e o motor de processos Supervisor
RUN apt-get update && apt-get install -y \
    curl tar wget procps ca-certificates supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instalar interface de monitoramento (Gradio)
RUN pip install --no-cache-dir "gradio>=4.0"

# Download do GagaNode (AppHub) - Feito no Build para evitar erro de DNS depois
RUN wget -O gaga.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz \
    && tar -zxf gaga.tar.gz \
    && mv apphub-linux-amd64 gaga_files \
    && rm gaga.tar.gz

# Download do Traffmonetizer CLI
RUN wget -O tm_cli https://traffmonetizer.com/download/container/linux/x64/traffmonetizer \
    && chmod +x tm_cli

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Porta para o dashboard de controle
EXPOSE 7860

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
