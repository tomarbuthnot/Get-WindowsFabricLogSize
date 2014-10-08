
# 0.1

# Assumes windows Fabric is on C:\

$VerbosePreference = "Continue"

$FinalOutput=  @()
Get-CsPool | Where-Object {$_.Services -like '*UserServer*'} |  
Select-Object -ExpandProperty Computers | 
ForEach-Object {
        Write-Verbose "Testing $_"
        $TestPath = $null
        $TestPath2 = $null
        # Note, no windows Fabric on 2010 Poool, Test_Path Coveres this
        $Path1 = "\\$_\C$\ProgramData\Windows Fabric\Fabric\log\Traces"
        $TestPath = Test-Path "$Path1"
        Write-Verbose "Test Path 1 Result: $TestPath" 
        
        # Alternate Path
        $Path2 = "\\$_\c$\ProgramData\Windows Fabric\Log\Traces"
        $TestPath2 = Test-Path "$path2"
        Write-Verbose "Test Path 2 Result: $TestPath2" 

        If ($TestPath)
            {
            $Size = Get-ChildItem "$Path1" | Measure-Object -property length -sum
            $Path = $Path1
            }
        
        If ($TestPath2)
            {
            $Size = Get-ChildItem "$Path2" | Measure-Object -property length -sum
            $Path = $path2
            }
            
            $FolderSizeMB = $size.sum / 1MB
            $FolderSizeMB = [Math]::Round($FolderSizeMB,2)
            Write-Verbose "Server $_"
            Write-Verbose "Path $Path"
            Write-Verbose "Size $FolderSizeMB MB"

                    $output = New-Object -TypeName PSobject 
                    $output | add-member NoteProperty "Computer" -value $_
                    $output | add-member NoteProperty "WinFabricLogSizeMB" -value $FolderSizeMB
                    $FinalOutput += $output

                } # Close Foreach-Object


$FinalOutput | Format-Table -AutoSize