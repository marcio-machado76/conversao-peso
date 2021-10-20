# conversao-peso

## *Aplicação escrita em C# utilizando ASP.NET Core*
  - Os passos a seguir descrevem como criar e excutar esta aplicação em containers.

## Criação do Dockerfile
  - As etapas de construção da imagem são descritas no exemplo Dockerfile abaixo:

```Dockerfile

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
EXPOSE 80 

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /myapp
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore ./ConversaoPeso.Web/ConversaoPeso.Web.csproj

# copiar o restante e criar um app
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /myapp/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# estágio da imagem final
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]

```

## Criando a imagem e enviando para o docker hub
  - Na criação da imagem para enviar para o registry do docker, é necessário um namespace válido e também adicionar um nome para o repositório e uma tag como utilizado logo abaixo:

  | Namespace | repositório | Tag |
  |-----------|-------------|-----|
  |machado1976 | conversao_peso|v1|
  |machado1976 | conversao_peso|latest|  

- Comando para criar a imagem.   
   `$ docker build -t machado1976/conversao_peso:v1 .`

- Enviando imagem com a tag v1 para o registry do docker.   
   `$ docker push machado1976/conversao_peso:v1`

- Adicionando tag latest.     
   `$ docker tag machado1976/conversao_peso:v1 conversao_peso:latest`

- Enviando imagem com a tag latest para o registry do docker.     
   `$ docker push machado1976/conversao_peso:latest`

## Criando o container
- Para criar e utilizar o container, basta executar o comando como descrito logo abaixo e alterar a porta que ficará exposta no host de acordo com a necessidade. Neste exemplo esta sendo utilizada a porta 8080 para ser acessada do host local.      

 `$ docker container run -d --name conversao_peso -p 8080:80 machado1976/conversao_peso:v1`

 ## Acessando a aplicação
 - Agora para acessar a aplicação é só utilizar o browser com o seguinte endereço:      
   ` http://localhost:8080 `
