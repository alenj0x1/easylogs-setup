Write-Host "easy-logs Setup"

$clientRepository = "https://github.com/alenj0x1/easylogs-client.git"
$apiRepository = "https://github.com/alenj0x1/easylogs-api.git"
$resourceDockerComposeRaw = ""

$installationDirectory = "easylogs";

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
  Write-Hos "Installation cancelled."
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
  Write-Hos "Installation cancelled."
}

Write-Host "Downloading resources..."
Invoke-WebRequest -Uri $resourceDockerComposeRaw -OutFile $installationDirectory
Write-Host "Resources downloaded..."

# - Docker initialization
docker compose up -d

Write-Host "easylogs is installed correctly in your system..."