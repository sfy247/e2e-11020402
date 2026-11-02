FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY src/e2e-11020402/e2e-11020402.csproj src/e2e-11020402/
RUN dotnet restore src/e2e-11020402/e2e-11020402.csproj
COPY src/ src/
RUN dotnet publish src/e2e-11020402/e2e-11020402.csproj -c Release -o /out --no-restore

# Chiseled: no shell, no package manager. The platform runs it as UID 10001
# with a read-only root filesystem.
FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble-chiseled
ENV ASPNETCORE_HTTP_PORTS=8080 DOTNET_EnableDiagnostics=0
WORKDIR /app
COPY --from=build /out .
USER 10001:10001
EXPOSE 8080
ENTRYPOINT ["dotnet", "e2e-11020402.dll"]
