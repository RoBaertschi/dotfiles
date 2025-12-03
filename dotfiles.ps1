$ErrorActionPreference = "Stop"
$WD = Get-Location

function make-backup($file) {
    if (Test-Path "$file.bak") {
	Write-Warning "make-backup: $file has already a backup, creating another one"
	make-backup "$file.bak"
    }
    Write-Warning "$file already exists. Moving to $file.bak"
    Move-Item -Path "$file" -Destination "$file.bak"
}

function link($from, $to) {
    if (Test-Path $HOME\$to) {
	make-backup "$HOME\$to"
    }
    
    New-Item -Path $HOME\$to -ItemType SymbolicLink -Value $WD\$from
}

function make-directory-if-not-exists($dir) {
    if (!(Test-Path $HOME\$dir)) {
	New-Item -Path $HOME\$dir -ItemType Directory
    }
}

link emacs\.emacs .emacs
make-directory-if-not-exists .emacs.d
link emacs\.emacs.d\odin-mode.el .emacs.d\odin-mode.el
