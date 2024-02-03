
#Путь до Host.appsettings
$apps_path="C:\Users\mitya\Documents\PowerShell\Projects\SmsSupportTools-by-Guildenstern\test_appsettings.json"


#Возвращает настройки хоста
function Get-HostAppSettings{
    #Если переменная с настройками не создана, создает ее
    if ($_HOSTAPPSETTINGS -like $null){

        #Возвращает ошибку если файл не найден
        if(Test-Path($apps_path)){
            $Global:_HOSTAPPSETTINGS=Get-Content $apps_path|ConvertFrom-Json -Depth 10
        }
        else {
            Write-Error -Message "File $apps_path not exist" -ErrorAction Stop
        }
    }

   #Возвращает переменную с настройками 
    return $_HOSTAPPSETTINGS
}

#Сохраняет настройки хоста
function Set-HostAppSettings{
    #Возвращает ошибку, если переменная с настройкми не создана (позволяет избежать случайного обнуления)
    if ($_HOSTAPPSETTINGS -like $null){
        Write-Error -Message "HostAppSettings is not init" -ErrorAction Stop
    }

    else{
        #Создание резервной копии
        #Если файл существует, создает его резервную копию, иначе нет. В теории при ненулевом APPSETTINGS этого быть не должно, но возможно если загрузить в него настройки и после этого удалить файл
        if (Test-Path($apps_path)){
            Move-Item -Path $apps_path -Destination (Add-PrefixToPath $apps_path) -Force
        }
        #Сохранение настроек
        ConvertTo-Json $_HOSTAPPSETTINGS -Depth 10 |Set-Content -Path $apps_path
    }
}

#Возвращает имя терминала (Corpus_G)
function Get-TerminalName{
    return (Get-HostAppSettings).TerminalSettings.Address
}

#Возвращает получателей писем анализатора в BCC
function Get-RecieversBCC {
    return (Get-HostAppSettings).MonitoringServiceSettings.AnalyzerSettings.EmailSettings.ReceiversBCC
}

#Возвращает получателей писем анализатора в Receivers
function Get-Recievers {
    return (Get-HostAppSettings).MonitoringServiceSettings.AnalyzerSettings.EmailSettings.Receivers
}

function Get-SaleObjectCode {
    $result = (Get-HostAppSettings).RKeeperSettings.SaleObjectCode
    if([String]::IsNullOrWhiteSpace($result)){
        Write-Error -Message "SaleObjectCode is Null" -ErrorAction Stop
    }
    return $result
}

function Get-ProductGuid{
    $result = (Get-HostAppSettings).RKeeperSettings.ProductGuid
    if([String]::IsNullOrWhiteSpace($result)){
        Write-Error -Message "ProductGuid is Null" -ErrorAction Stop
    }
    return $result
}