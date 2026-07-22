# docker-services — Homelab no NixOS

Stack de serviços self-hosted com Docker Compose + Nginx como reverse proxy.

vps-user:
	github-runner
	9911runner@

## Serviços

| Serviço     | URL                     | Descrição                         |
| ----------- | ----------------------- | --------------------------------- |
| Portainer   | portainer.homelab.local | Gerenciador visual de containers  |
| Vikunja     | vikunja.homelab.local   | Gerenciador de tarefas            |
| Grafana     | grafana.homelab.local   | Dashboards de monitoramento       |
| Uptime Kuma | uptime.homelab.local    | Monitor de uptime                 |
| Mealie      | mealie.homelab.local    | Gerenciador de receitas           |
| Vaultwarden | vault.homelab.local     | Gerenciador de senhas (Bitwarden) |
| Jellyfin    | media.homelab.local     | Servidor de mídia                 |
|             |                         |                                   |

## Configuração inicial

**1. Habilite o Docker no NixOS** — adicione ao `configuration.nix`:

```nix
virtualisation.docker = {
  enable = true;
  autoPrune.enable = true;
};

users.users.SEU_USUARIO.extraGroups = [ "docker" ];
```

```bash
sudo nixos-rebuild switch
```

**2. Configure as variáveis de ambiente:**

```bash
cp .env.example .env
nano .env
```

Gere tokens seguros com:
```bash
openssl rand -base64 32   # para VIKUNJA_JWT_SECRET
openssl rand -base64 48   # para VAULTWARDEN_ADMIN_TOKEN
```

**3. Configure o DNS local** — no NixOS via `configuration.nix`:

```nix
networking.hosts = {
  "127.0.0.1" = [
    "portainer.homelab.local"
    "vikunja.homelab.local"
    "grafana.homelab.local"
    "uptime.homelab.local"
    "mealie.homelab.local"
    "vault.homelab.local"
    "media.homelab.local"
  ];
};
```

**4. Suba os serviços:**

```bash
docker compose up -d
docker compose ps
```

## Permissões no rootless Docker (NixOS)

O NixOS usa user namespaces no Docker por padrão, o que causa erros de permissão em volumes de serviços como o Vikunja. A solução é usar bind mounts locais com o `chown` correto.

O uid mapeado aparece no log de erro, por exemplo:
```
process host uid=100999
```

Para corrigir, crie a pasta e ajuste a permissão:

```bash
mkdir -p ./data/vikunja-files
sudo chown -R 100999:100999 ./data/vikunja-files
```

E no `docker-compose.yml`, troque o volume nomeado pelo bind mount:

```yaml
vikunja:
  volumes:
    - ./data/vikunja-files:/app/vikunja/files
```

Aplique o mesmo padrão para qualquer outro serviço que apresentar o mesmo erro.

## Adicionando um novo serviço

**1.** Adicione o serviço no `docker-compose.yml` na rede `homelab`:

```yaml
  meu-servico:
    image: exemplo/imagem:latest
    container_name: meu-servico
    restart: unless-stopped
    networks:
      - homelab
```

**2.** Adicione o virtual host em `nginx/conf.d/services.conf`:

```nginx
server {
    listen 80;
    server_name meu-servico.homelab.local;
    location / {
        set $up http://meu-servico:PORTA;
        proxy_pass $up;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

> O `set $up` com `resolver 127.0.0.11` (já no topo do arquivo) garante que o Nginx não quebre na inicialização caso o container ainda não esteja pronto.

**3.** Adicione a entrada de DNS no `configuration.nix` e aplique `nixos-rebuild switch`.

**4.** Suba o serviço e recarregue o Nginx:

```bash
docker compose up -d meu-servico
docker compose restart nginx
```

## Comandos úteis

```bash
# Atualizar todas as imagens
docker compose pull && docker compose up -d

# Reiniciar um serviço
docker compose restart vikunja

# Ver logs em tempo real
docker compose logs -f vikunja

# Parar tudo
docker compose down
```

## Segurança

- Nunca versione o `.env` — ele já está no `.gitignore`.
- Desative signups no Vaultwarden e Mealie após criar sua conta.
- Para expor na internet, use HTTPS com Let's Encrypt via Certbot ou Traefik.
