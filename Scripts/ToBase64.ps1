#Преобразовывает текст в Base64 (из Интернета)
function ToBase64{
    param(
        [string]$value
    )
    $byte = [System.Text.Encoding]::UTF8.GetBytes($value)
    $result = [System.Convert]::ToBase64String($byte)
    return $result
}