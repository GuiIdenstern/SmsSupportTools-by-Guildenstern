. '.\ToBase64 1.0.ps1'
. '.\Get-Hash 1.0.ps1'

#Возвращает код пользователя:  (userName + «;» + lowercase(md5(userName+password)) + «;» + lowercase(md5(token)))
function Get-MD5toAuthRequest{
param(
    [string]$login,
    [string]$password,
    [string]$token
)
#Получение первой части кода пользователя
$md5_1=Get-Hash($login+$password)

#Получение второй части кода пользователя
$md5_2=Get-Hash($token)

#Получение кода пользователя
$result=$login+';'+$md5_1+';'+$md5_2

return $result
}

#Возвращает id лизцензии RKeeper7, или код ошибки
    function Get-RK7License{
    param(
        [string]$login = 'r.biktimirov@smartmealservice.com',
        [string]$password = 'bMj,4kYH',
        [string]$token = 'f72246a4-a65d-4715-a15d-a4f61d8eee59',
        [string]$num_object = '126750212',
        [string]$guid = '655cee55-7bcd-4826-b6e0-a8ccf2017ef3'
    )

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


$args = @{
    login = 'r.biktimirov@smartmealservice.com'
    password = 'bMj,4kYH'
    token = 'f72246a4-a65d-4715-a15d-a4f61d8eee59'
    num_object = '126750212'
    guid = '655cee55-7bcd-4826-b6e0-a8ccf2017ef3'
  }
  <#>
  yughjv
  
  #>
Get-RK7License @args
