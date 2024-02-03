

$path='..\Settings\RKeeperAuth_settings.json'

$default_token='f72246a4-a65d-4715-a15d-a4f61d8eee59'

function Set-RKeeperAuthSettings{

    #Ввод данных
    $username=Read-Host -Prompt 'Введите логин'
    $password=Read-Host -Prompt 'Введите пароль'

    #Ввод токена либо получение по умолчанию
    $token=Read-Host -Prompt 'Введите токен, либо нажмите Enter для ввода по умолчанию'
    if([string]::IsNullOrWhiteSpace($token)){
        $token=$default_token
    }

    #Преобразование текстового пароля в SecureString
    $sec_pass=ConvertTo-SecureString -String $password -AsPlainText 

    $_SETTINGS=@{
        Username=$username

        #Преобразование SecureString в текстовое представление
        Password=$sec_pass|ConvertFrom-SecureString 

        Token = $token
    }

    #Запись натсроек в файл
    ConvertTo-Json $_SETTINGS -Depth 10 |Set-Content -Path $path
}

function Get-RKeeperUsername{
    #Возвращает соержимое файла настроек
    (Get-Content $path|ConvertFrom-Json -Depth 10).
    #Имя пользователя
    Username
}

function Get-RKeeperPassword{
    #Возвращает соержимое файла настроек
    (Get-Content $path|ConvertFrom-Json -Depth 10).
    #Пароль
    Password
    #Преобразование текстового представления SecureString в объект
    |ConvertTo-SecureString 
    #Конвертация SecureString в читаемый текст
    |ConvertFrom-SecureString -AsPlainText
}

function Get-RKeeperToken{
    #Возвращает соержимое файла настроек
    (Get-Content $path|ConvertFrom-Json -Depth 10).
    #Токен
    Token
}

#Set-RKeeperAuthSettings