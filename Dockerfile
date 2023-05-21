
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./src/OzonEdu.MerchService/OzonEdu.MerchService.csproj", "./OzonEdu.MerchService/"]
RUN dotnet restore "./OzonEdu.MerchService/OzonEdu.MerchService.csproj"
COPY ./src .
WORKDIR "/src"
RUN dotnet build "./OzonEdu.MerchService/OzonEdu.MerchService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./OzonEdu.MerchService/OzonEdu.MerchService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.MerchService.dll"]