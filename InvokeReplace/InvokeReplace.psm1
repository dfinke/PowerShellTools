function Invoke-Replace {
    <#
        .Synopsis
            PowerShell Inplace Editing 
        .Description
            
        .Example
            Invoke-Replace old new
            In all the files in the current directory, replace the string "old" with the string "new"

        .Example
            Invoke-Replace old new *.txt
            In all files with the extension '.txt' in the current directory, replace the string "old" with the string "new"

        .Example
            Invoke-Replace old new *.txt .bak
            In all files with the extension '.txt' in the current directory, create a copy and append the extension .bak and then replace the string "old" with the string "new"

        .Example
            Invoke-Replace "(?<=d)," ""
            In all the files in the current directory, use the regex "(?<=d)," to remove commas that immediately follow a digit
    #>
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