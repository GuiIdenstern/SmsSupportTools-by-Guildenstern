
#Путь до Host.appsettings
$apps_path="C:\Users\mitya\Documents\PowerShell\Projects\SmsSupportTools-by-Guildenstern\test_appsettings.json"


#Возвращает настройки хоста
function Get-AppSettings{
    #Если переменная с настройками не создана, создает ее
    if ($_APPSETTINGS -like $null){
        $Global:_APPSETTINGS=Get-Content $apps_path|ConvertFrom-Json -Depth 10
    }

   #Возвращает переменную с настройками 
    return $_APPSETTINGS
}

#Сохраняет настройки хоста
function Set-AppSettings{
    #Возвращает ошибку, если переменная с настройкми не создана (позволяет избежать случайного обнуления)
    if ($_APPSETTINGS -like $null){
        Write-Error "AppSettings is not init"
    }

    else{
        #Создание резервной копии
        Rename-Item -Path $apps_path -NewName 'OLD_appsettings.json'
        #Сохранение настроек
        ConvertTo-Json $_APPSETTINGS -Depth 10 |Set-Content -Path $apps_path
    }
}

#Возвращает имя терминала (Corpus_G)
function Get-TerminalName{
    return (Get-AppSettings).TerminalSettings.Address
}

#Возвращает получателей писем анализатора в BCC
function Get-RecieversBCC {
    return (Get-AppSettings).MonitoringServiceSettings.AnalyzerSettings.EmailSettings.ReceiversBCC
}

#Возвращает получателей писем анализатора в Receivers
function Get-Recievers {
    return (Get-AppSettings).MonitoringServiceSettings.AnalyzerSettings.EmailSettings.Receivers
}

function Get-SaleObjectCode {
    $result = (Get-AppSettings).RKeeperSettings.SaleObjectCode
    if([String]::IsNullOrWhiteSpace($result)){
        Write-Error -Message "SaleObjectCode is Null" -ErrorAction Stop
    }
    return $result
}

function Get-ProductGuid{
    $result = (Get-AppSettings).RKeeperSettings.ProductGuid
    if([String]::IsNullOrWhiteSpace($result)){
        Write-Error -Message "ProductGuid is Null" -ErrorAction Stop
    }
    return $result
}