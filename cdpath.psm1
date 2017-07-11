using namespace System.Management.Automation
using namespace System.Collections.Generic
using namespace System.Management.Automation.Language

Set-StrictMode -Version Latest

enum CandidateKind{
	Global
	CurrentDirectory
	CDPath
}

class CandidatePair : System.IComparable {

	[string] $CDPath
	[string] $CandidatePath
	[int] $CDPathIndex
	[CandidateKind] $Kind

	CandidatePair([string] $cdPath,	[string] $candidatePath, [int] $cdpathIndex, [CandidateKind] $kind) {
		$this.CDPath = $cdPath.TrimEnd([IO.Path]::DirectorySeparatorChar).TrimEnd([IO.Path]::AltDirectorySeparatorChar)
		$this.CandidatePath = $candidatePath.TrimEnd([IO.Path]::DirectorySeparatorChar).TrimEnd([IO.Path]::AltDirectorySeparatorChar)
		$this.CDPathIndex = $cdpathIndex
		$this.Kind = $kind
	}

	[string] ToString() {return $this.CandidatePath}

	[int] GetHashCode() {return "$($this.CandidatePath)$($this.CDPath)".GetHashCode()}

	[bool] Equals([object] $o) {
		$cp = $o -as [CandidatePair]
		return $null -ne $cp -and $cp.CDPath -eq $this.CDPath -and $cp.CandidatePath -eq $this.CandidatePath
	}

	[int] CompareTo([object] $o) {
		$cp = $o -as [CandidatePair]
		if ($null -eq $cp) {return -1}
		$res = $this.Kind.CompareTo($cp.Kind)
		if ($res -ne 0) {
			return $res
		}
		if ($this.Kind -eq [CandidateKind]::CDPath) {
			$res = $this.CDPathIndex.CompareTo($cp.CdPathIndex)
			if ($res -ne 0) {
				return $res
			}
		}
		return $this.CandidatePath.CompareTo($cp.CandidatePath)
	}
}

class CDPathData {
	[string[]] $CDPath
	[string] $PathFile
	[string] $PreviousWorkingDir = "~"
	[bool] $SetWindowTitle = $true

	CDPathData([string] $pathFile) {
		$this.Pathfile = $global:ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($pathFile)
		if (-not (Test-Path -PathType Leaf $this.PathFile)) {
			$this.SetPath("~")
		}
		$this.Update()
	}

	[void] Update() {
		$this.CDPath = foreach ($line in [io.File]::ReadAllLines($this.PathFile)) {
			$trimmedLine = $line.Trim()
			if ($trimmedLine) {
				$trimmedLine
			}
		}
	}
	[void] AddPath([string[]] $path, [bool] $prepend) {
		if ($prepend) {
			$this.CDPath = @($path) + $this.CDPath
		}
		else {
			$this.CDPath = $this.CDPath + $path
		}
	}
	[void] SetPath([string[]] $path) {
		[io.File]::WriteAllLines($this.PathFile, $path)
		$this.Update()
	}


	[CandidatePair[]] GetCandidates([string] $path, [string[]] $remaining, [bool] $exact) {
		$provider = $Null

		# Resolve Path
		$c = switch ($path) {
			'' { '~'; break}
			'.' { $pwd.ProviderPath; break }
			'..' { (Get-Item -LiteralPath '..').FullName; break }
			'-' { $this.PreviousWorkingDir; break }
			{$_ -match "^\.{3,}$"} {
				# .'ing shortcuts for ... and ....
				$Path = $path.Substring(1) -replace '\.', '..\'
				(Get-Item -LiteralPath $Path).FullName
				break
			}
		}
		if ($c) {
			return [CandidatePair]::new($null, $c, -1, [CandidateKind]::Global)
		}

		# If there are extra arguments, create a globbing expression
		# so that cd a b c => cd a*\b*\c*
		[bool]$pathEndsWithSep = $false
		$pathSep = [IO.Path]::DirectorySeparatorChar
		if ($path.EndsWith($pathSep)) {
			$pathEndsWithSep = $true
			$path = $path.TrimEnd($pathSep)
		}
		if ($pathEndsWithSep -and !$remaining) {
			[string[]] $searchPaths = "$path$pathSep", $path
		}
		else {
			[string[]] $searchPaths = $path
		}

		if ($Remaining) {
			$rest = $Remaining -join "*$pathSep"
			if ($rest.EndsWith($pathSep)) {
				$rest = $rest.TrimEnd($pathSep)
				$searchPaths = $searchPaths.Foreach{"$_*$pathSep$rest\", "$_*$pathSep$rest"}
			}
			else {
				$searchPaths = $searchPaths.Foreach{"$_*$pathSep$rest"}
			}
		}
		[HashSet[CandidatePair]] $candidates = [HashSet[CandidatePair]]::new()

		foreach ($sp in $searchPaths) {
			$rsp = $global:ExecutionContext.SessionState.Path.GetresolvedProviderPathFromPSPath("$sp*", [ref] $provider)
			foreach ($r in $rsp) {
				if (Test-Path -PathType Container $r) {
					$candidates.Add([CandidatePair]::new($pwd.ProviderPath, $r, -1, [CandidateKind]::CurrentDirectory))
				}
			}
		}

		[string[]] $expandedCdPaths = @($pwd.ProviderPath ) + $this.CDPath.Foreach{$global:ExecutionContext.InvokeCommand.ExpandString($_)}
		for ($i = 0; $i -lt $expandedCdPaths.Length; $i++) {
			$ecp = $expandedCdPaths[$i]
			if (-not $ecp -or ![IO.Path]::IsPathRooted($ecp)){
				continue
			}
			[string]$resolvedCDPath = $global:ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ecp)
			if ($resolvedCDPath -eq $pwd.ProviderPath) {
				continue
			}
			foreach ($p in $searchPaths) {
				[string[]]$CandidatePaths = if ($exact -or $p.EndsWith($pathSep)) {
					Join-Path $resolvedCDPath $p
				}
				else {
					Join-Path $resolvedCDPath "$p*" -Resolve -ea SilentlyContinue

				}
				foreach ($cp in $CandidatePaths) {
					if ($cp -and (Test-Path -PathType Container $cp)) {
						$cpair = [CandidatePair]::new($resolvedCDPath, $cp, $i, [CandidateKind]::CDPath)
						$candidates.Add($cpair)
					}
				}
			}
		}

		return $candidates | Sort-Object
	}

	[string] ToString() {
		return $this.CDPath -join ';'
	}
}


$script:data = [CDPathData]::new('~/.cdpath')


class CDPathCompleter : System.Management.Automation.IArgumentCompleter {
	[CDPathData] $data
	CDPathCompleter() {
		$this.Data = $script:data
	}
	CDPathCompleter([CDPathData] $data) {
		$this.data = $data
	}

	static [CompletionResult] ToCompletionResult([CandidatePair] $candidatePair) {

		$lt = $candidatePair.CandidatePath.Substring($candidatePair.CDPath.Length + 1)
		$ct = $lt
		if ($lt.Contains(' ')) {
			$ct = "'$lt'"
		}
		return [CompletionResult]::new($ct, $lt, [CompletionResultType]::ProviderContainer, $candidatePair.CandidatePath)
	}

	static [string[]] GetPathsFromCommandAst($commandAst) {
		$ce = $commandAst.CommandElements
		$paths = $ce.Where{$_ -is [StringConstantExpressionAst]}
		$count = $paths.Count - 1
		$res = [string[]]::new($count)
		for ($i = 0; $i -lt $res.Length; $i++) {
			$res[$i] = $paths[$i + 1].Value
		}
		return $res
	}

	[IEnumerable[CompletionResult]] CompleteRemaining([string] $wordToComplete,	[CommandAst] $commandAst, [bool] $exact) {
		$paths = [CDPathCompleter]::GetPathsFromCommandAst($commandAst)
		$res = [System.Collections.Generic.List[CompletionResult]]::new($paths.Length)

		$candidates = $this.Data.GetCandidates($paths[0], $paths[1..($paths.Length - 1)], $exact)
		foreach ($c in $candidates) {
			if ($c.CDPath) {
				$cr = [CDPathCompleter]::ToCompletionResult($c)
				$res.Add($cr)
			}
		}
		return $res
	}

	[IEnumerable[CompletionResult]] CompletePath([string] $wordToComplete, [CommandAst] $commandAst, [bool] $exact) {
		if ($commandAst.CommandElements.Count -ne 2) {
			return $null
		}

		$paths = [CDPathCompleter]::GetPathsFromCommandAst($commandAst)
		$res = [System.Collections.Generic.List[CompletionResult]]::new($paths.Length)
		$candidates = $this.Data.GetCandidates($paths[0], $null, $exact)

		foreach ($c in $candidates) {
			if ($c.CDPath) {
				$cr = [CDPathCompleter]::ToCompletionResult($c)
				$res.Add($cr)
			}
			elseif ($c.CandidatePath -and ($wordToComplete.EndsWith([IO.Path]::DirectorySeparatorChar) -or $wordToComplete.EndsWith([IO.Path]::AltDirectorySeparatorChar))) {
				$cp = $c.CandidatePath + [IO.Path]::DirectorySeparatorChar
				foreach ($r in [CompletionCompleters]::CompleteFilename($cp)) {
					if ($r.ResultType -eq [CompletionResultType]::ProviderContainer) {
						$res.Add($r)
					}
				}
			}
		}
		return $res
	}


	[IEnumerable[CompletionResult]] CompleteArgument([string] $commandName,
		[string] $parameterName,
		[string] $wordToComplete,
		[System.Management.Automation.Language.CommandAst] $commandAst,
		[System.Collections.IDictionary] $fakeBoundParameters) {
		$exact = $fakeBoundParameters["Exact"] -eq $true
		switch ($parameterName) {
			'Path' {
				return $this.CompletePath($wordToComplete, $commandAst, $exact); break
			}
			'Remaining' {
				return $this.CompleteRemaining($wordToComplete, $commandAst, $exact)
			}
		}
		return $null
	}
}


function Get-CDPathCandidate {
	[OutputType([string])]
	param(
		[Parameter(Mandatory)]
		[string] $path,
		[string[]] $remaining
	)
	$script:Data.GetCandidates($path, $remaining, $false)

}

<#
		.SYNOPSIS
		Changing location using by resolving a pattern agains a set of paths
		.DESCRIPTION
		CDPath replaces the 'cd' alias with Set-CDPathLocation

		Parts of paths can be specified with a space.

		PS> cd win mo

		will change directory to ~/documents/windowspowershell/modules


		.EXAMPLE
		Set-CDPathLocation ....

		The example changes the current location to the parent three levels up.
		.. (first parent)
		... (second parent)
		.... (third parent)

		.EXAMPLE
		Set-CDLocation 'C:\Program Files (X86)\Microsoft Visual Studio 12'
		Set-CDLocation ~
		# Go back to 'C:\Program Files (X86)\Microsoft Visual Studio 12'
		Set-CDPathLocation -

		.EXAMPLE

		Get-CDPath
		~/Documents/GitHub
		~/Documents
		~/corpsrc

		# go to ~/documents/WindowsPowerShell/Modules/CDPath
		Set-CDLocation win mod cdp


#>
function Set-CDPathLocation {
	[Alias('cd')]
	param(
		[Parameter(Position = 0)]
		[ArgumentCompleter([CDPathCompleter])]
		[string] $Path,
		[Parameter(ValueFromRemainingArguments)]
		[ArgumentCompleter([CDPathCompleter])]
		[string[]] $Remaining = $null,
		[switch] $Exact
	)

	$candidates = $script:data.GetCandidates($Path, $Remaining, $Exact)
	if ($candidates) {
		$prev = $pwd.ProviderPath
		Set-Location $candidates[0]
		$script:data.PreviousWorkingDir = $prev
		if ($data.SetWindowTitle) {
			$host.UI.RawUI.WindowTitle = $pwd.ProviderPath
		}
	}
	else {
		Write-Error -Message "Cannot Resolve path $Path $Remaining." -Category ([ErrorCategory]::ObjectNotFound)
	}
}

<#
		.SYNOPSIS
		Read the cdpath from ~/.cdpath

		.DESCRIPTION
		This is useful if you have modified your path file with an external editor
#>
function Update-Cdpath {
	$script:Data.Update()
}

<#
		.SYNOPSIS
		Adds one or more paths to your cdpath

		.DESCRIPTION
		This is useful if you have modified your path file with an external editor
#>
function Add-CDPath {
	param(
		[string[]] $Path
		,
		# Specify Prepend to add the paths before the existing paths
		[Switch] $Prepend
	)

	$script.Data.AddPath($Path, $Prepend)
}


function Get-CDPath {
	[CmdletBinding()]
	[OutputType([string])]
	param()
	$script:data.CDPath
}

function Get-CDPathOption {
	$script:Data
}

function Set-CDPath {
	param(
		[Parameter(Mandatory)]
		[string[]] $Path
	)
	$script:Data.SetPath($Path)
}

<#
		.SYNOPSIS
		Customizes the behavior of Set-CDPathLocation in CDPath
#>
function Set-CDPathOption {
	param(
		# Indicates if the the window title should be changed when changing location
		[Switch] $SetWindowTitle
	)
	if ($PSBoundParameters.ContainsKey('SetWindowTitle')) {
		$script:Data.SetWindowTitle = [bool] $SetWindowTitle
	}
}
