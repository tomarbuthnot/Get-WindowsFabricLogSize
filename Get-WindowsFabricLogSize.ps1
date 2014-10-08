
# 0.1

$FinalOutput=  @()
Get-CsPool | Where-Object {$_.Services -like '*UserServer*'} |  
Select-Object -ExpandProperty Computers | 
ForEach-Object {
        Write-Host $_
        # Note, no windows Fabric on 2010 Poool, Test_Path Coveres this
        $TestPath = Test-Path "\\$_\C$\ProgramData\Windows Fabric\Fabric\log\Traces" 
        If ($TestPath)
            {
            $Size = Get-ChildItem "\\$_\C$\ProgramData\Windows Fabric\Fabric\log\Traces" | Measure-Object -property length -sum
            $FolderSizeMB = $size.sum / 1MB
            $FolderSizeMB = [Math]::Round($FolderSizeMB,2)
            Write-Verbose "Server $_"
            Write-Verbose "Path \\$_\C$\ProgramData\Windows Fabric\Fabric\log\Traces"
            Write-Verbose "Size $FolderSizeMB MB"

            $output = New-Object -TypeName PSobject 
                    $output | add-member NoteProperty "Computer" -value $_
                    $output | add-member NoteProperty "WinFabricLogSize" -value $FolderSizeMB
                    $FinalOutput += $output

            }

                } # Close Foreach-Object


$FinalOutput