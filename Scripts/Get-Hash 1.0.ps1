function Get-Hash {
    param (
        [string] $value
    )
    $stream=[System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stream)
    $writer.write($value)
    $writer.Flush()
    $stream.Position = 0
    $hash = Get-FileHash -Algorithm MD5 -InputStream $stream

    #Закрытие потоков
    $writer.Close()
    $stream.Close()

    return $hash.Hash.ToLower()
}