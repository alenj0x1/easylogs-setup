Write-Host "easy-logs Setup"

$easylogsClientRepository = "https://github.com/alenj0x1/easylogs-client.git"
$easylogsApiRepository = "https://github.com/alenj0x1/easylogs-api.git"

$installationDirectory = "easylogs";


if (-Not (Test-Path -Path $installationDirectory)) {
  mkdir $installationDirectory
  Write-Host "Base directory created..."
}

Set-Location $installationDirectory
Write-Host "Location changed to $installationDirectory"

# Client clone
if (-Not (Test-Path -Path "easylogs-client")) {
  git clone $easylogsClientRepository
  Write-Host "easylogs-client repository cloned..."
}

# Api Clone
if (-Not (Test-Path -Path "easylogs-api")) {
  git clone $easylogsApiRepository
  Write-Host "easylogs-api repository cloned..."
}