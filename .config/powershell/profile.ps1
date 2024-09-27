function Import-Homebrew {
  switch ($true) {
    $IsWindows { return }
    $IsMacOS {
      switch ($(uname -m)) {
        "arm64" { $HOMEBREW_PREFIX = "/opt/homebrew" }
        "x86_64" { $HOMEBREW_PREFIX = "/usr/local" }
        default { return }
      }
    }
    $IsLinux { $HOMEBREW_PREFIX = "/home/linuxbrew/.homebrew" }
    default { return }
  }
  if (-Not (Test-Path "$HOMEBREW_PREFIX")) {
    $HOMEBREW_PREFIX = "$HOME/.local/opt/homebrew"
    if (-Not (Test-Path "$HOMEBREW_PREFIX")) {
      return
    }
  }
  $env:HOMEBREW_PREFIX = $HOMEBREW_PREFIX
  (& "$HOMEBREW_PREFIX/bin/brew" shellenv) |
  Out-String |
  Where-Object { $_ } |
  Invoke-Expression
  Remove-Item -Path Function:/Import-Homebrew
}
Import-Homebrew

# Cargo
function Import-Cargo {
  $CARGO_HOME = "$HOME/.cargo"
  if (-Not (Test-Path "$CARGO_HOME")) {
    return
  }
  $env:CARGO_HOME = $CARGO_HOME
  $env:PATH = "$CARGO_HOME/bin:$env:PATH"
  Remove-Item -Path Function:/Import-Cargo
}
Import-Cargo

# Conda
function Set-CondaAliases {
  $conda_aliases = @(
    "conda",
    "mamba",
    "2to3",
    "idle3",
    "pip", "pip3",
    "pydoc", "pydoc3",
    "python", "python3",
    "python3-config",
    "wheel", "wheel3"
  )
  foreach ($alias in $conda_aliases) {
    New-Item -Path Function:global:$alias -Value {
      if ($MyInvocation.ExpectingInput) {
        $input | Import-Conda $MyInvocation.MyCommand.Name $args
      }
      else {
        Import-Conda $MyInvocation.MyCommand.Name $args
      }
    } > $null
  }
  Remove-Item -Path Function:/Set-CondaAliases
}
function Uninstall-CondaAliases {
  $conda_aliases = @(
    "conda",
    "mamba",
    "2to3",
    "idle3",
    "pip", "pip3",
    "pydoc", "pydoc3",
    "python", "python3",
    "python3-config",
    "wheel", "wheel3"
  )
  foreach ($alias in $conda_aliases) {
    Remove-Item -Path Function:/$alias
  }
  Remove-Item -Path Function:/Uninstall-CondaAliases
}
function Import-Conda {
  Uninstall-CondaAliases
  if ($IsWindows) {
    $CONDA_ROOT = "$HOME/miniforge3"
  }
  else {
    $CONDA_ROOT = "$HOME/.local/opt/miniforge3"
  }
  If (-Not (Test-Path "$CONDA_ROOT/bin/conda")) {
    if ($args.Length -gt 0) {
      $cmd = $args[0]
      $cmd_args = $args[1..$args.Length]
      if ($MyInvocation.ExpectingInput) {
        $input | & $cmd @cmd_args
      }
      else {
        & $cmd @cmd_args
      }
    }
    return
  }
  $env:CONDA_ROOT = $CONDA_ROOT
  (& "$CONDA_ROOT/bin/conda" "shell.powershell" "hook") |
  Out-String |
  Where-Object { $_ } |
  Invoke-Expression
  if (Test-Path "$CONDA_ROOT/envs/default") {
    conda activate default
  }
  Remove-Item -Path Function:/Import-Conda
  if ($args.Length -gt 0) {
    $cmd = $args[0]
    $cmd_args = $args[1..$args.Length]
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd @cmd_args
    }
    else {
      & $cmd @cmd_args
    }
  }
}
Set-CondaAliases
