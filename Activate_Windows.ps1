# Variables
$windowsKey = 'YOUR KEY'
$forceActivate = $false
$logFilePath = 'C:\Alamo\activation_log.txt'

try {
    # Check if Windows is activated
    $activationStatusRaw = & C:\Windows\System32\cscript.exe C:\Windows\System32\slmgr.vbs /dli

    # Parse the raw license data to find out if Windows is activated
    $licenseStatus = $activationStatusRaw | Select-String -Pattern "License Status"

    # Get the actual license status
    $isWindowsActivated = $licenseStatus -like "*License Status: Licensed*"

    # Check for forced activation or if Windows is not activated
    if ($forceActivate -or !$isWindowsActivated) {
        # Try to change the product key
        $keyChangeStatus = & C:\Windows\System32\cscript.exe C:\Windows\System32\slmgr.vbs /ipk $windowsKey

        # Try to activate Windows
        $activationAttemptStatus = & C:\Windows\System32\cscript.exe C:\Windows\System32\slmgr.vbs /ato

        # Write to log file
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Force Activation: $forceActivate"
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Initial Activation Status: $isWindowsActivated"
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Key Change Status: $keyChangeStatus"
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Activation Attempt Status: $activationAttemptStatus"
    } else {
        # Write to log file
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Force Activation: $forceActivate"
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Initial Activation Status: $isWindowsActivated"
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Activation not attempted as Windows is already activated"
    }
} catch {
    Add-Content -Path $logFilePath -Value "$(Get-Date) - An error occurred: $_"
}
