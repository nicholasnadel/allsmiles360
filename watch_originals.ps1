Function RunMyStuff {

# ----------------------------------------
# IM Configuration
$srcfolder = "C:\Users\Nicholas\Pictures\dslrBooth\Originals"
$destfolder = "C:\Users\Nicholas\Pictures\dslrBooth\cropped"
$im_convert_exe = "C:\Users\Nicholas\Pictures\dslrBooth\ImageMagick-7.0.3-Q16\convert.exe"
$src_filter = "*.jpg"
$dest_ext = "jpg"
$options = "convert -crop 100%x50% *.jpg cropped_%d.jpg +append cropped_0.jpg cropped_1.jpg combined.jpg"
$logfile = "C:\Users\Nicholas\Pictures\dslrBooth\allsmiles.txt"
# ----------------------------------------

$fp = New-Item -ItemType file $logfile -force
$count=0
foreach ($srcitem in $(Get-ChildItem $srcfolder -include $src_filter -recurse))
{
    $srcname = $srcitem.fullname

    # Construct the filename and filepath for the output
    $partial = $srcitem.FullName.Substring( $srcfolder.Length )
    $destname = $destfolder + $partial
    $destname= [System.IO.Path]::ChangeExtension( $destname , $dest_ext )
    $destpath = [System.IO.Path]::GetDirectoryName( $destname )

    # Create the destination path if it does not exist
    <# if (-not (test-path $destpath))
    {
        New-Item $destpath -type directory | Out-Null
    }
#>
    # Perform the conversion by calling an external tool
    $cmdline =  $im_convert_exe + " `"" + $srcname  + "`"" + $options + " `"" + $destname + "`" "
    #echo $cmdline
    invoke-expression -command $cmdline

    # Get information about the output file
    $destitem = Get-item $destname

    # Show and record information comparing the input and output files
    $info = [string]::Format( "{0} `t {1} `t {2} `t {3} `t {4} `t {5}", $count,
	$partial, $srcname, $destname, $srcitem.Length ,  $destitem.Length)
    echo $info
    Add-Content $fp $info

    $count=$count+1
}

}

Function Watch {
    $global:FileChanged = $false # dirty... any better suggestions?
    $folder = "C:\Users\Nicholas\Pictures\dslrBooth\Originals"
    $filter = "*.jpg"
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    Register-ObjectEvent $Watcher "Changed" -Action {$global:FileChanged = $true} > $null

    while ($true){
        while ($global:FileChanged -eq $false){
            # We need this to block the IO thread until there is something to run
            # so the script doesn't finish. If we call the action directly from
            # the event it won't be able to write to the console
            Start-Sleep -Milliseconds 100
        }

        # a file has changed, run our stuff on the I/O thread so we can see the output
        RunMyStuff

        # reset and go again
        $global:FileChanged = $false
    }
}

RunMyStuff # run the action at the start so I can see the current output
Watch
