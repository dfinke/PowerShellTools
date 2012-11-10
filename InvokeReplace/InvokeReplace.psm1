function Invoke-Replace {
    param(
        $Match,
        $Replace,
        $Include="*",
        $BackupExtension
    )    

    $files = Get-ChildItem . $Include
    ForEach($file in $files) {

      Backup-File $file $BackupExtension
      $targetFile = $file.FullName
      
      [IO.File]::ReadLines($targetFile) -replace $Match, $Replace | 
        Set-Content $targetFile
    }
}

function Backup-File {
    param(        
        $File,
        $BackupExtension
    )

    if(!$BackupExtension) { return }

    $path = $File.FullName
    $destination = $path + $BackupExtension

    Copy-Item -Path $path -Destination $destination
}