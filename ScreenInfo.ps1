<#
================================================================================

         FILE:  ScreenInfo.ps1

        USAGE:  ScreenInfo.ps1 [-h]

  DESCRIPTION:  Show OS Logo and information about the session

      OPTIONS:  ---
 REQUIREMENTS:  ---
         BUGS:  ---
        NOTES:  ---
       AUTHOR:  Uwe Schimanski, uws@seabaer-ag.de
      COMPANY:  Seab@er Software
      Version:  20.06.15
      CREATED:  15.06.2020
     REVISION:  
================================================================================
#>
Try
{
    $Version = "22.01.03"
    $User = $env:username
    $Computer = $env:computername
    $Domain = $env:userdomain
    # Uptime start
	if ($PSVersionTable.PSVersion.Major -lt 6 )
	{
		$cimString = (Get-WmiObject Win32_OperatingSystem).LastBootUpTime
		$BootTime = [Management.ManagementDateTimeConverter]::ToDateTime($cimString)
	}
	else
	{
		$cimString = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
		$BootTime = $cimString
	}
    $BootDate = "{0:dd.MM.yyyy HH:mm:ss}" -f ($BootTime)
    $Now = "{0:dd.MM.yyyy HH:mm:ss}" -f (Get-Date)
    $NowTime = "{0:HH:mm:ss}" -f (Get-Date)
    $Up = New-TimeSpan -Start $BootTime -End (Get-Date)
    $UpDays = $Up.Days
    $UpHours = $Up.Hours
    $UpMinutes = $Up.Minutes
    $UpTime = $Up.Hours.ToString() + ":" + $Up.Minutes.ToString()
    $RamSum = 0
    $ShellVersion = $PSVersionTable.PSVersion.Major

    if ($UpDays -le 6)
    {
	    $UpWeek = 0
	    $UpDaysAll = $UpDays
    }
    else
    {
	    $A = $UpDays / 7
	    $UpWeek = [math]::Truncate($A)
	    $B = $UpWeek -as [int] # convert to integer
	    $C = $B * 7
	    $D = $UpDays - $C
	    $UpDaysAll = $UpDays
	    $UpDays = $D
    }
    # Uptime end
	if ($PSVersionTable.PSVersion.Major -lt 6 )
	{
		$OS = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem
		$Gpu = Get-WmiObject -ComputerName $Computer -Class Win32_VideoController
		$Cpu = Get-WmiObject -ComputerName $Computer -Class Win32_Processor
		$Up = "up $UpWeek weeks, $UpDays days, $UpHours hours, $UpMinutes minutes"
		# Ram
		$Ram = Get-WmiObject -ComputerName $Computer -Class Win32_PhysicalMemory
	}
	else
	{
		$OS = Get-CimInstance -Class Win32_OperatingSystem
		$Gpu = Get-CimInstance -Class Win32_VideoController
		$Cpu = Get-CimInstance -Class Win32_Processor
		$Up = "up $UpWeek weeks, $UpDays days, $UpHours hours, $UpMinutes minutes"
		# Ram
		$Ram = Get-CimInstance -Class Win32_PhysicalMemory
	}
    for ($i=0; $i -lt $Ram.Count; $i++)
    {
	    $RamSum = $RamSum + $Ram[$i].Capacity
    }
    switch ($RamSum)
    {
	    { $RamSum -ge ([math]::pow(1024,3)) -and $RamSum -lt ([math]::pow(1024,4))} { $RamHuman = "{0:n0}Gb" -f ($RamSum/1Gb)}
    }
    # IP Address
    #$IPClient = Test-Connection -ComputerName $Computer -Count 1
	$IpClient = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Wlan,Ethernet* -PrefixLength 24
    # Output Info
    $I1 = "{0,30} {1,-10}" -f "User Name:",$User
    $I2 = "{0,32} {1,-10}" -f "Computer:",$Computer
    $I3 = "{0,17} {1,-10}" -f "Domain:",$Domain
    $I4 = "{0,17} {1,-10}" -f "OS:",$OS.Caption
    $I5 = "{0,17} {1,-10}" -f "Uptime:",$Up
    $I6 = "{0,18} {1,-10}" -f "CPU:",$Cpu.Name
    $I7 = "{0,18} {1,-10}" -f "GPU:",$Gpu.Description
    $I8 = "{0,19} {1,-10}" -f "RAM:",$RamHuman
	$I9 = "{0,20} {1,-10}" -f "IP:",$IpClient.IPAddress
    #$I9 = "{0,20} {1,-10}" -f "IP:",$IpClient.IPV4Address.IPAddressToString
    $I10 = "{0,20} {1,-1}.{2,-1}" -f "Shell Version:",$ShellVersion,$PSVersionTable.PSVersion.Minor
    $V1 = "{0,15}" -f "ScreenInfo.ps1 (C) Seab@er Software by Uwe Schimanski - $Version`n"
    # Logo
    $L2 = "{0,30}" -f ":EEEEtttt::::z7"
    $L3 = "{0,30}" -f "'VEzjt:;;z>*'"
    #====== Output to Screen ======
    # Line 1
    Write-Host -ForegroundColor Red "`n         ,.=:^!^!t3Z3z.," -NoNewLine
    Write-Host -ForegroundColor Green "$I1"
    # Line 2
    Write-Host -ForegroundColor Red "        :tt:::tt333EE3" -NoNewLine
    Write-Host -ForegroundColor Green "$I2"
    # Line 3
    Write-Host -ForegroundColor Red "        Et:::ztt33EEE" -NoNewLine
    Write-Host -ForegroundColor Yellow "  @Ee.,      ..," -NoNewLine
    Write-Host -ForegroundColor Green "$I3"
    # Line 4
    Write-Host -ForegroundColor Red "       ;tt:::tt333EE7" -NoNewLine
    Write-Host -ForegroundColor Yellow " ;EEEEEEttttt33#" -NoNewLine
    Write-Host -ForegroundColor	Green "$I4"
    # Line 5
    Write-Host -ForegroundColor Red "      :Et:::zt333EEQ." -NoNewLine
    Write-Host -ForegroundColor Yellow " SEEEEEttttt33QL" -NoNewLine
    Write-Host -ForegroundColor Green	"$I5"
    # Line 6
    Write-Host -ForegroundColor Red "      it::::tt33EEF" -NoNewLine
    Write-Host -ForegroundColor Yellow "  @EEEEEEttttt33F" -NoNewLine	
    Write-Host -ForegroundColor Green "$I6"
    # Line 7
    Write-Host -ForegroundColor Red "     ;3=*^''''*4EEV" -NoNewLine
    Write-Host -ForegroundColor Yellow " :EEEEEEttttt33@." -NoNewLine
    Write-Host -ForegroundColor	Green "$I7"
    # Line 8
    Write-Host -ForegroundColor Cyan "     ,.=::::it=.," -NoNewLine
    Write-Host -ForegroundColor Yellow "   @EEEEEEtttz33QF" -NoNewLine
    Write-Host -ForegroundColor Green	"$I8"
    # Line 9
    Write-Host -ForegroundColor Cyan "    ;::::::::zt33" -NoNewLine
    Write-Host -ForegroundColor Yellow	"    '4EEEtttJi3P*" -NoNewline
    Write-Host -ForegroundColor Green "$I9"
    # Line 10
    Write-Host -ForegroundColor Cyan "   :t::::::::tt33" -NoNewLine
    Write-Host -ForegroundColor DarkYellow " :Z3z..     ,..g." -NoNewline
    Write-Host -ForegroundColor Green "$I10"
    # Line 11
    Write-Host -ForegroundColor Cyan "   i::::::::zt33F" -NoNewLine
    Write-Host -ForegroundColor DarkYellow " AEEEtttt::::ztF"
    # Line 12
    Write-Host -ForegroundColor Cyan "  ;:::::::::t33V" -NoNewLine
    Write-Host -ForegroundColor DarkYellow " ;EEEttttt::::t3"
    # Line 13
    Write-Host -ForegroundColor Cyan "  E::::::::zt33L" -NoNewLine
    Write-Host -ForegroundColor DarkYellow " @EEEtttt::::z3F"
    # Line 14
    Write-Host -ForegroundColor Cyan " {3=*A''''*4E3)" -NoNewLine
    Write-Host -ForegroundColor	DarkYellow " ;EEEtttt:::::tZ'"
    # Line 15
    Write-Host -ForegroundColor DarkYellow "$L2"
    # Line 16
    Write-Host -ForegroundColor DarkYellow "$L3" -NoNewline
    Write-Host -ForegroundColor Green "`t$V1"
}
Catch
{
    Write-Host -ForegroundColor Red "ERROR-001: Exception found!`n$_"
}