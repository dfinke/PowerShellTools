cls

Import-Module ..\InvokeReplace.psm1 -Force

# Clear out test files 
rm *bak* -ErrorAction SilentlyContinue
rm *txt* -ErrorAction SilentlyContinue

function New-TestFiles {
    param (        
        $HowManyFiles,
        $Text,
        $FileNamePrefix,
        $Extention = ".txt"
    )

    1..3 | % {

        $fileName = "$($FileNamePrefix)$($_)$($Extention)"
        $Text | Set-Content .\$fileName
    }
}

function TestWithoutBackup {
    New-TestFiles 3 "1,000 2,000 1,2,3" Digits
    New-TestFiles 3 "this is old" TextFile

    Invoke-Replace "(?<=\d)," "" *.txt
    Invoke-Replace "old" "new" -Include *.txt
}

function TestWithBackup {
    New-TestFiles 3 "1,000 2,000 1,2,3" DigitsDoBkp
    New-TestFiles 3 "this is old" TextFileDoBkp

    Invoke-Replace "(?<=\d)," "" Dig*DoBkp*.txt .bak
    Invoke-Replace "old" "new" -Include Text*dobkp*.txt .bak
}

TestWithBackup
TestWithoutBackup