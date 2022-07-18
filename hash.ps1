foreach ($file in Get-ChildItem -File -Recurse | Where-Object{($_.Extension -like '.jar')} | Select-Object -ExpandProperty Name) {
        $hash = Get-FileHash -Path $file -Algorithm MD5 | Select-Object -ExpandProperty Hash
        $hash = $hash.ToLower()
        if (Test-Path -Path "$hash" -PathType Leaf) {
            Remove-Item -Path "$file" -Force
        } else {
            Rename-Item -Path "$file" -NewName "$hash"
            $hash | Out-File -Append hashs.txt
        }
}
