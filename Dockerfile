FROM httpd
# Define a imagem base a ser utilizada (Precisa já ter sido baixada)
COPY ./web/ /usr/local/apache2/htdocs/
# Copia a pasta Web do repositório para a imagem web_apache
EXPOSE 80
# Expoe a porta 80 dentro da imagem.