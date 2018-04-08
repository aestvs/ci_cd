task InstallDependencies {
 #   Install-Module Pester -SkipPublisherCheck -Force
   Install-Module PSScriptAnalyzer -Force -confirm:$false
}

task Analyze {
    $scriptAnalyzerParams = @{
        Path = "$BuildRoot\DSC_Resources\DSC_Test"
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
        ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Test {
    $invokePesterParams = @{
        Strict = $true
        PassThru = $true
        Verbose = $false
        EnableExit = $false
    }

    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester @invokePesterParams -OutputFormat  NUnitXml;

    $numberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

#missing verion update section

task Clean {
    $Artifacts = "$BuildRoot\Artifacts"
    
    if (Test-Path -Path $Artifacts)
    {
        Remove-Item "$Artifacts/*" -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Artifacts -Force
}