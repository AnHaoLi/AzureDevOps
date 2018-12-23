FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["src/AzureDevOps.Web/AzureDevOps.Web.csproj", "src/AzureDevOps.Web/"]
RUN dotnet restore "src/AzureDevOps.Web/AzureDevOps.Web.csproj"
COPY . .
WORKDIR "/src/src/AzureDevOps.Web"
RUN dotnet build "AzureDevOps.Web.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "AzureDevOps.Web.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AzureDevOps.Web.dll"]