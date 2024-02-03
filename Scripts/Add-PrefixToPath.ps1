function Add-PrefixToPath{
    param(
        [Parameter(Mandatory)]
        [string] $path,
        [string] $prefix='OLD',
        [string] $delimitter='_'
    )
    $old_filename=Join-Path -Path (Split-Path -Path $path -Parent) -ChildPath ($prefix+$delimitter+(Split-Path -Path $path -Leaf))
    return $old_filename
}