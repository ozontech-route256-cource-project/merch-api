
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["./src/OzonEdu.MerchApi/OzonEdu.MerchApi.csproj", "./OzonEdu.MerchApi/"]
RUN dotnet restore "./OzonEdu.MerchApi/OzonEdu.MerchApi.csproj"
COPY ./src .
WORKDIR "/src"
RUN dotnet build "./OzonEdu.MerchApi/OzonEdu.MerchApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./OzonEdu.MerchApi/OzonEdu.MerchApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.MerchApi.dll"]