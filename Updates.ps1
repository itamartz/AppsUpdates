function Get-UpdateForAnsible{
    $AllReleases = Invoke-RestMethod -Uri 'https://api.github.com/repos/ansible/ansible/releases' -UseBasicParsing | Sort-Object tag_name 
    $LatesRelease = $AllReleases | Select -First 1
    $LatesVersion = $LatesRelease.tag_name.Substring(1)
    
    return @{
        AnsibleLatesVersion = $LatesVersion
    }

}

function  Get-UpdateForSplunk{
    $download_page = Invoke-WebRequest -Uri "https://www.splunk.com/en_us/download/universal-forwarder.html" -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36"

    $x86matched = $download_page.Content -match 'data-filename="(splunkforwarder-\S+-x86-release\.msi)" data-link="(https://\S+\.msi)"'
    if ($x86matched) {
        $x86_filename = $matches[1]
        $x86_url = $matches[2]
    }
    Else
    {
        Write-Error "Could not find x86 file"
    }

    $x64matched = $download_page.Content -match 'data-filename="(splunkforwarder-\S+-x64-release\.msi)" data-link="(https://\S+\.msi)"'
    if ($x64matched) {
        $x64_filename = $matches[1]
        $x64_url = $matches[2]
    }
    Else
    {
        Write-Error "Could not find x64 file"
    }

    return @{
        Splunk        = $x64_url
    }
}

Get-UpdateForAnsible | Format-Table -auto
Get-UpdateForSplunk | Format-Table -auto
