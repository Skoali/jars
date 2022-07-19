$result = Invoke-WebRequest -UseBasicParsing -Uri "https://serverjars.com/api/fetchAll/mohist" 
$response = $result.Content | ConvertFrom-Json
$response.response | Format-Table -AutoSize
foreach ($version in $response.response) {
    $yes = $version.version
    Invoke-WebRequest -UseBasicParsing -Uri "https://serverjars.com/api/fetchJar/mohist/$yes" -OutFile "$yes.jar"
    $filehash = Get-FileHash -Path "$yes.jar" -Algorithm MD5 | Select-Object -ExpandProperty Hash
    $filehash = $filehash.ToLower()
    if (Test-Path -Path "$filehash" -PathType Leaf) {
      Remove-Item -Path "$yes.jar" -Force
    } else {
      Rename-Item -Path "$yes.jar" -NewName "$filehash"
      $filehash | Out-File -Append hashs.txt
    }
}
