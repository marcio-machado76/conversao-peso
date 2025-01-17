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
