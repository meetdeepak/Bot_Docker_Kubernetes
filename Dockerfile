FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-nanoserver-1903 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 3978

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-nanoserver-1903 AS build
WORKDIR /src
COPY ["EchoBot.csproj", "./"]
RUN dotnet restore "EchoBot.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "EchoBot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EchoBot.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EchoBot.dll"]