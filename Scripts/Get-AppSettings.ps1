. '.\Add-PrefixToPath.ps1'

$path="..\appsettings.json"


$_SETTINGS=@{
    RKeeperSettings=@{
        Username=""
        Password=""

    }
}

function Set-AppSettings{
    if (Test-Path($path)){
        Move-Item -Path $path -Destination (Add-PrefixToPath $path) -Force
    }
    ConvertTo-Json $_SETTINGS -Depth 10 |Set-Content -Path $path
}

function Get-AppSettings{
    #Если переменная с настройками не создана, создает ее
    if ($_APPSETTINGS -like $null){

        #Возвращает ошибку если файл не найден
        if(Test-Path($path)){
            $Global:_APPSETTINGS=Get-Content $path|ConvertFrom-Json -Depth 10
        }
        else {
            Write-Error -Message "File $path not exist" -ErrorAction Stop
        }
    }
   #Возвращает переменную с настройками 
    return $_APPSETTINGS
}

function Get-RKeeperUser{
    return (Get-AppSettings).RKeeperSettings.Username
}

function Get-RKeeperPassword{
    return (Get-AppSettings).RKeeperSettings.Password
}