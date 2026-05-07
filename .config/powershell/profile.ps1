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
