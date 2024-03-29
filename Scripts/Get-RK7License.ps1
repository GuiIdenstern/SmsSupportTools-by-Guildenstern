. '.\ToBase64.ps1'
. '.\Get-Hash.ps1'
. '.\Get-HostAppSettings.ps1'
. '.\Set-RKeeperAuthSettings.ps1'

#Возвращает id лизцензии RKeeper7, или код ошибки
    function Get-RK7LicenseId{

    #Получение логина RKeeper из файла настроек
    [string]$login=Get-RKeeperUsername

    #Получение пароля RKeeper из файла настроек (дешифрованного)
    [string]$password=Get-RKeeperPassword

    #Получение токена из фала настроек
    [string]$token=Get-RKeeperToken
    
    #Получение из настроек хоста restCode (код ресторана)
    [string]$num_object=Get-SaleObjectCode

    #Получение из настроек хоста GUID продукта (R-Keeper модуль XML-интерфейс для Приложения 12 мес ПО)
    [string]$guid=Get-ProductGuid


    #Получение кода пользователя
    $md5_1=Get-Hash($login+$password)
    $md5_2=Get-Hash($token)
    $md5=$login+';'+$md5_1+';'+$md5_2
 
    #Преобразование кода пользователя в Base64
    $base64=ToBase64 $md5

    #URL запроса
    $url='https://l.ucs.ru/ls5api/api/License/GetLicenseIdByAnchor?anchor=6%3A'+$guid+'%23'+$num_object+'/17' 
    
    #Заголовки запроса
    $headers=@{'usr'= $base64} 

    #Запрос
    $result=Invoke-WebRequest -Uri $url -Headers $headers

    #Парсинг кода ошибки (если есть)
    $result_error=($result.Content|ConvertFrom-Json).ErrorMessage
    if($result_error -notlike $null) {return $result_error}

    #Парсинг id лицензии из запроса
    $result_id=($result.Content|ConvertFrom-Json).id
   
    #Вывод сообщения о просроченной лицензии, если id нулевой
    if ($result_id -like $null) {return 'License is expired'}

    #Вывод id лицензии
    if ($result_id -notlike $null) {return "License ID: $result_id"}
}

Get-RK7LicenseId
