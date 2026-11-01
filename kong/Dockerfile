# Kong com a configuracao embutida na imagem: o Coolify faz o build a partir do
# repositorio, entao kong.yml vem sempre do git (arquivos montados no compose
# viram File Mount no Coolify e nao sao atualizados).
FROM kong:3.9
COPY kong.yml /kong/kong.yml
COPY entrypoint.sh /kong/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/kong/entrypoint.sh"]
