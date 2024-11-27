Write-Host "easy-logs Setup"

$clientRepository = "https://github.com/alenj0x1/easylogs-client.git"
$apiRepository = "https://github.com/alenj0x1/easylogs-api.git"
$resourceDockerComposeRaw = "https://raw.githubusercontent.com/alenj0x1/easylogs-setup/refs/heads/main/resources/docker-compose.yaml"
$resourceEnvClient = "https://raw.githubusercontent.com/alenj0x1/easylogs-setup/refs/heads/main/resources/.env"

$installationDirectory = "easylogs";
$clientDirectory = "easylogs-client"
$apiDirectory = "easylogs-api"

$baseUrlVariableName = "{{_BASE_URL_VARIABLE_}}"

# Check necessary resources on system
try {
  Get-Command docker -ErrorAction Stop
}
catch {
  Write-Host "'docker' is not installed on your system. This is necessary to perform the installation"
}

try {
  Get-Command git -ErrorAction Stop
}
catch {
  Write-Host "'git' is not installed on your system. This is necessary to perform the installation"
}

# - Installation directory
if (-Not (Test-Path -Path $installationDirectory)) {
  mkdir $installationDirectory
  Write-Host "Base directory created..."
}

Set-Location $installationDirectory
Write-Host "Location changed to $installationDirectory"

# - Get github repositories
$questionRepositories = Read-Host "You need to download some repositories to run the installation, do you want to continue?. y/n"

if ($questionRepositories -ne "y") {
  Write-Host "Installation cancelled."
}

if (-Not (Test-Path -Path "easylogs-client")) {
  git clone $clientRepository
  Write-Host "easylogs-client repository cloned..."
}

if (-Not (Test-Path -Path "easylogs-api")) {
  git clone $apiRepository
  Write-Host "easylogs-api repository cloned..."
}

# - Get resources
$questionResources = Read-Host "You need to download some resources to run the installation, do you want to continue?. y/n"

if ($questionResources -ne "y") {
  Write-Host "Installation cancelled."
}

Write-Host "Downloading resources..."

$dockerComposeName = "docker-compose.yml"
Invoke-WebRequest -Uri $resourceDockerComposeRaw -OutFile $dockerComposeName

$envClientPath = "./$clientDirectory/.env"
Invoke-WebRequest -Uri $resourceEnvClient -OutFile $envClientPath

Write-Host "Resources downloaded..."

# - Set variables
Write-Host "Configuring variables..."

# Client port configuration
$questionClientPort = Read-Host "On which port do you want the client (easylogs-client) to be running?"

$envClientContent = Get-Content $envClientPath
$envClientContent = $envClientContent -replace $baseUrlVariableName, $questionClientPort
$envClientContent | Set-Content $envClientPath

# Api port configuration
$questionApiPort = Read-Host "On which port do you want the api (easylogs-api) to be running?"

$launchApiPath = "./$apiDirectory/easylogsAPI.WebApi/Properties/launchSettings.json"

$launchApiContent = Get-Content $launchApiPath
$launchApiContent = $launchApiContent -replace $baseUrlVariableName, $questionApiPort
$launchApiContent | Set-Content $launchApiPath

Write-Host "Variables configured..."

# - Docker initialization
Write-Host "Initializing docker..."

docker compose up -d

Write-Host "easylogs is installed correctly in your system..."