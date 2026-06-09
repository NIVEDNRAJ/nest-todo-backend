# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["TodoApi.csproj", "./"]
RUN dotnet restore "TodoApi.csproj"

# Copy remaining source code and build
COPY . .
RUN dotnet build "TodoApi.csproj" -c Release -o /app/build

# Publish Stage
FROM build AS publish
RUN dotnet publish "TodoApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Production Stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose ports
EXPOSE 8080
EXPOSE 8081

ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "TodoApi.dll"]
