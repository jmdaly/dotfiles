function MigrateDbGrants
{

<#
.SYNOPSIS
Migrate GRANTs from MySQL to MariaDB.

.DESCRIPTION
 - Side A:
   - Stop MariaDB, start MySQL
   - Read GRANT data
   - Stop MySQL, start MariaDB
   - Load GRANT data on MariaDB
 - Side B:
   - Ensure MySQL is stopped and MariaDB is running
   - Load GRANT data on MariaDB

Service objects for MySQL and MariaDB on Side A can be provided by the user,
this was done for development purposes to avoid the long wait times
Get-WmiObject calls make.

.INPUTS
None. You cannot pipe objects to Add-Extension.

.OUTPUTS
None
#>

    Param(
        # Focus only on Side A, skip all interaction with side B
        [switch]$SkipSideB = $false,

        # Do not actually perform any DB changes
        [switch]$WhatIf = $false,

        # Used user supplied MySQL service object for Side A. (Used in
        # developing to bypass loading time)
        $sysA_mysql,

        # Used user supplied MariaDB service object for Side A. (Used in
        # developing to bypass loading time)
        $sysB_maria
    )

    $mysql_dir="C:\Program Files (x86)\MySQL\MySQL Server 5.0\bin"
    $maria_dir="C:\Program Files\MariaDB 10.3\bin"
    $maria_service_name="MariaDB"

    $sysA = [PSCustomObject]@{
        sysAdminUser="administrator"
        sysAdminPassword=""
        db = [PSCustomObject]@{
            host="10.202.132.136"
            user="root"
            password=""
            clientMysql=$mysql_dir + "\mysql.exe"
            clientMaria=$maria_dir + "\mysql.exe"
        }
    }

    $sysB = [PSCustomObject]@{
        sysAdminUser="administrator"
        sysAdminPassword=""
        db = [PSCustomObject]@{
            host="10.202.132.140"
            user="root"
            password=""
            clientMysql=$mysql_dir + "\mysql.exe"
            clientMaria=$maria_dir + "\mysql.exe"
        }
    }

    ############################################################
    #                  END OF USER INPUT                       #
    ############################################################

    # Add credentials to the objects
    Add-Member -MemberType NoteProperty -InputObject $sysA -Name credentials -Value (
        New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sysA.sysAdminUser,(ConvertTo-SecureString -AsPlainText $sysA.sysAdminPassword -Force)
    )

    if ($SkipSideB)
    {
        Write-Host "Skipping all interaction with Side B" -ForegroundColor Yellow
    }
    else
    {
        Add-Member -MemberType NoteProperty -InputObject $sysB -Name credentials -Value (
            New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sysB.sysAdminUser,(ConvertTo-SecureString -AsPlainText $sysB.sysAdminPassword -Force)
        )
    }

    # Small lambda to wait for a desired state
    $waitFor = {
        param(
            [Parameter(Mandatory=$true)]$service,
            [Parameter(Mandatory=$true)]$state
        )

        $max_repeat = 100;
        do
        {
            $max_repeat--;
            $service.get()
            Write-Host "." -ForegroundColor Yellow -NoNewline
            sleep -Milliseconds 200
        } until ($service.State -eq "Running" -or $max_repeat -eq 0)
        if ($max_repeat -eq 0)
        {
            return $false
        }
        else
        {
            return $true
        }
    }


    # Grab the service.  Get-WmiObject is really slow, and each call to it creates
    # a new connection, new authentication, etc..  This can be avoided with CMI
    # sessions, but these appear to be restricted by default.
    Write-Host "Attempting to access services on Side A (" $sysA.db.Host ")" -ForegroundColor Green
    if ($sysA_mysql)
    {
        Write-Host "Using user supplied MySQL service" -ForegroundColor green
        Add-Member -InputObject $sysA -MemberType NoteProperty -Name mysql -Value $sysA_mysql
    }
    else
    {
        Add-Member -InputObject $sysA -MemberType NoteProperty -Name mysql -Value (
            Get-WmiObject -ComputerName $sysA.db.host -Class Win32_Service -Filter "Name='MySQL'" -credential $sysA.credentials
        )
    }
    if ($sysA_maria)
    {
        Write-Host "Using user supplied MariaDB service" -ForegroundColor green
        Add-Member -InputObject $sysA -MemberType NoteProperty -Name mariadb -Value $sysA_maria
    }
    else
    {
        Add-Member -InputObject $sysA -MemberType NoteProperty -Name mariadb -Value (
            Get-WmiObject -ComputerName $sysA.db.host -Class Win32_Service -Filter "Name='$maria_service_name'" -credential $sysA.credentials
        )
    }

    Write-Host "Initial State: MySQL=[" $sysA.mysql.State "] MariaDB=[" $sysA.mariadb.State "]"

    if (!$SkipSideB)
    {
        Write-Host "Attempting to access services on Side B (" $sysB.db.Host ") ... " -NoNewLine -ForegroundColor Green
        Add-Member -InputObject $sysB -MemberType NoteProperty -Name mysql -Value (
            Get-WmiObject -ComputerName $sysB.db.host -Class Win32_Service -Filter "Name='MySQL'" -credential $sysB.credentials
        )
        Add-Member -InputObject $sysB -MemberType NoteProperty -Name mariadb -Value (
            Get-WmiObject -ComputerName $sysB.db.host -Class Win32_Service -Filter "Name='$maria_service_name'" -credential $sysB.credentials
        )
        Write-Host "Initial State: MySQL=[" $sysB.mysql.State "] MariaDB=[" $sysB.mariadb.State "]"
    }


    ############################################################
    # At this point we have our WMI objects
    ############################################################

    # Make sure MySQL is running
    $sysA.mysql.get(); $sysA.mariaDb.get()
    if ($sysA.mariadb.State -eq "Running") { Write-Host "Stopping Maria" -ForegroundColor Magenta; $sysA.mariadb.StopService() }
    if ($sysA.mysql.State   -eq "Stopped") { Write-Host "Starting MySQL" -ForegroundColor Magenta; $sysA.mysql.StartService()  }

    $ret = &$waitFor -service $sysA.mysql -state "Running"
    if ($ret -eq 0) { Write-Host -ForegroundColor Red " Could not start MySQL service"; return; }

    ############################################################
    # MySQL is running, MariaDB is stopped, we can now do work
    ############################################################

    # Grab the GRANTS data
    $users = ("root", "webadmin", "IQliberty", "IQscript", "IQadmin", "I3user", "slave_user")
    $grants = @()
    ForEach ($u in $users)
    {
        $args=("-h", $sysA.db.host, "-u", $($sysA.db.user), "-p$($sysA.db.password)", "-B", "-N", "-e", "SHOW GRANTS FOR $u")
        $grants+=(& $sysA.db.clientMysql $args)
    }

    Write-Host "GRANTS data:`n" -ForegroundColor Green
    ForEach ($g in $grants) { Write-Host "$g;" }

    ############################################################
    # We have our data.  Disable MySQL, enable MariaDB
    ############################################################

    if (!$WhatIf)
    {
        # Make sure to start Maria
        $sysA.mysql.get(); $sysA.mariaDb.get()
        Write-Host "Current DB state: MySQL=[" $sysA.mysql.State "] MariaDB=[" $sysA.mariadb.State "]" -ForegroundColor Blue
        if ($sysA.mysql.State   -eq "Running") { Write-Host "Stopping MySQL" -ForegroundColor Magenta; $sysA.mysql.StopService()    }
        if ($sysA.mariadb.State -eq "Stopped") { Write-Host "Starting Maria" -ForegroundColor Magenta; $sysA.mariadb.StartService() }

        $ret = &$waitFor -service $sysA.mariadb -state "Running"
        if ($ret -eq 0) { Write-Host -ForegroundColor Red " Could not start MariaDB service"; return; }
    }

    ############################################################
    # Maria is now running, load our GRANT data into the DB
    ############################################################

    $args=("-h", $sysA.db.host, "-u", $($sysA.db.user), "-p$($sysA.db.password)", "-B", "-N", "-e")
    $query = ""
    ForEach ($g in $grants) { $query += "$g; " }
    $args += """$query"""

    # Load GRANTS into database
    if (!$WhatIf)
    {
        Write-Host "Loading GRANTS data onto Side A (" $sysA.db.Host ")" -ForegroundColor Yellow
        $outp = (& $sysA.db.clientMaria $args)

        if (!$SkipSideB)
        {
            # Deal with Side B, since Side B is more of a backup, we don't need to do
            # the same transfer, instead we can simply load the same data onto B.
            $sysA.mysql.get(); $sysA.mariaDb.get()
            Write-Host "Current DB state on side B: MySQL=[" $sysA.mysql.State "] MariaDB=[" $sysA.mariadb.State "]" -ForegroundColor Blue
            if ($sysB.mysql.State   -eq "Running") { Write-Host "Stopping MySQL" -ForegroundColor Magenta; $sysB.mysql.StopService()    }
            if ($sysB.mariadb.State -eq "Stopped") { Write-Host "Starting Maria" -ForegroundColor Magenta; $sysB.mariadb.StartService() }

            Write-Host "Loading GRANTS data onto Side B (" $sysB.db.Host ")" -ForegroundColor Yellow
            $outp = (& $sysB.db.clientMaria $args)
        }
    }
}

# vim: ts=4 sw=4 sts=0 expandtab ft=ps1 :
