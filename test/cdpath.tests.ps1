using module ..\Release\CDPath\CDPath.psm1
Describe 'cdpath' {
	push-location
	BeforeAll {
		mkdir TestDrive:\A\A\A
		mkdir TestDrive:\A\B
		mkdir TestDrive:\A\C
		mkdir TestDrive:\B\A
		mkdir TestDrive:\B\D
		mkdir TestDrive:\C\A
		Get-ChildItem TestDrive:\ -Recurse -Directory | ForEach-Object {
			$p = $_.fullname
			Set-Content -LiteralPath $p/file.txt -value 'text'
		}
		$script:TD = (Resolve-Path TestDrive:\).ProviderPath
	}

	BeforeEach {
		$env:TD = $null
		Set-Location TestDrive:\
	}

	it 'can set CDPATH' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$c.CDPath[0] | Should Be "TestDrive:\A"
		$c.CDPath[1] | Should Be "TestDrive:\B"
	}

	it 'can expand ~ in CDPATH' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath("~")
		$e = $c.GetExpandedCDPath()
		$e | Should Be $pwd.Provider.Home
	}

	it 'can change to C:\' {
		$can = Get-CDPathCandidate C:\
		$can[0] | Should -Be "C:\"
	}

	it 'can change to ~' {
		$provider = (Resolve-Path .).Provider
		Set-CDPathLocation ~
		$pwd.ProviderPath | Should -Be $provider.Home
	}

	it 'can get candidate from ...' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		Set-Location TestDrive:\A\A\A
		$candidates = $c.GetCandidates("...", $Null, $false)
		$td = (Resolve-Path TestDrive:\).ProviderPath
		$candidates[0].CandidatePath | Should Be "${TD}A"
	}

	it 'can get candidate with ending dir sep' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$candidates = $c.GetCandidates("A\", $Null, $false)
		$td = (Resolve-Path TestDrive:\).ProviderPath
		$candidates[0].CandidatePath | Should Be "${TD}A"
	}

	it 'expands cdpath strings' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B', '$env:TD\C'))
		$env:TD = "TestDrive:"
		$candidates = $c.GetCandidates("A", $Null, $false)
		$candidates.Count | Should Be 4
		$candidates[0].CandidatePath | Should Be "${TD}A"
		$candidates[2].CandidatePath | Should Be "${TD}B\A"
		$candidates[3].CandidatePath | Should Be "${TD}C\A"
	}

	it 'can get candidates from cdpath' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$candidates = $c.GetCandidates("A", $Null, $false)
		$candidates.Count | Should Be 3
		$candidates[0].CandidatePath | Should Be "${TD}A"
		$candidates[2].CandidatePath | Should Be "${TD}B\A"
	}

	it 'sets existing folder as first candidate' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		Set-Location TestDrive:\
		$candidates = $c.GetCandidates("A", $Null, $false)
		$candidates.Count | Should Be 3
		$candidates[0].CandidatePath | Should Be "${TD}A"
		$candidates[1].CandidatePath | Should Be "${TD}A\A"
		$candidates[2].CandidatePath | Should Be "${TD}B\A"
	}

	it 'gets multilevel paths' {
		$c = [CDPathData]::new("TestDrive:\cdpath")

		mkdir TestDrive:\B\A\DDD\EEE\FFF
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$candidates = $c.GetCandidates("A", ('d', 'e', 'f'), $false)
		$candidates.Count | Should Be 1
		$candidates[0].CandidatePath | Should Be "${TD}B\A\DDD\EEE\FFF"
	}

	it 'completes set-cdpathlocation top level' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$cpm = [CDPathCompleter]::new($c)
		$commandAst = {Set-CDPathLocation A}.Ast.EndBlock.Statements.PipelineElements[0]
		$res = $cpm.CompleteArgument("Set-CDPathLocation", "Path", "A", $commandAst, @{})
		$res.Count | Should Be 3
		$res[0].CompletionText | Should Be "A"
		$res[0].ToolTip | Should Be "${TD}A"
		$res[1].CompletionText | Should Be "A"
		$res[1].ToolTip | Should Be "${TD}A\A"
	}

	it 'completes set-cdpathlocation second level' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		mkdir TestDrive:\B\A1
		Set-Content TestDrive:\B\A.txt 'text'
		$c.SetPath(('TestDrive:\A', 'TestDrive:\B'))
		$cpm = [CDPathCompleter]::new($c)
		$commandAst = {Set-CDPathLocation B A}.Ast.EndBlock.Statements.PipelineElements[0]
		$res = $cpm.CompleteArgument("Set-CDPathLocation", "Remaining", "A", $commandAst, @{})
		$res.Count | Should Be 2
		$res[0].CompletionText | Should Be "B\A"
		$res[0].ToolTip | Should Be "${TD}B\A"
		$res[1].CompletionText | Should Be "B\A1"
		$res[1].ToolTip | Should Be "${TD}B\A1"
	}

	it 'completes set-cdpathlocation with path separator' {
		$c = [CDPathData]::new("TestDrive:\cdpath")
		$c.SetPath(('TestDrive:\'))
		$cpm = [CDPathCompleter]::new($c)
		mkdir TestDrive:\A\B\C\D
		$commandAst = {Set-CDPathLocation A\B\C}.Ast.EndBlock.Statements.PipelineElements[0]
		$res = $cpm.CompleteArgument("Set-CDPathLocation", "Path", "A\B\C", $commandAst, @{})
		$res.Count | Should Be 1
		$res[0].CompletionText | Should Be "A\B\C"
		$res[0].ToolTip | Should Be "${TD}A\B\C"
	}
	pop-location
}
