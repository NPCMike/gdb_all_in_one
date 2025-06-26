#!/bin/sh

installer_path=$PWD

echo "[+] Checking for required dependencies..."

if command -v git >/dev/null 2>&1 ; then
    echo "[-] Git found!"
else
    echo "[-] Git not found! Aborting..."
    echo "[-] Please install git and try again."
    exit
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
    echo "[+] backing up gdbinit file"
    cp ~/.gdbinit ~/.gdbinit.back_up
fi

# download pwndbg
if [ -d ~/pwndbg ] || [ -h ~/.pwndbg ]; then
    echo "[-] Pwndbg found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_pwndbg

    if [ $skip_pwndbg = 'n' ]; then
        rm -rf ~/pwndbg
        git clone https://github.com/pwndbg/pwndbg.git ~/pwndbg

        cd ~/pwndbg
        ./setup.sh
    else
        echo "Pwndbg skipped"
    fi
else
    echo "[+] Downloading Pwndbg..."
    git clone https://github.com/pwndbg/pwndbg.git ~/pwndbg

    cd ~/pwndbg
    ./setup.sh
fi

# download gef
if [ -d ~/gef ] || [ -h ~/.gef ]; then
    echo "[-] GEF found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_gef

    if [ $skip_gef = 'n' ]; then
        rm -rf ~/gef
        git clone https://github.com/hugsy/gef.git ~/gef
    else
        echo "GEF skipped"
    fi
else
    echo "[+] Downloading GEF..."
    git clone https://github.com/hugsy/gef.git ~/gef
fi

cd $installer_path

echo "[+] Setting .gdbinit..."
sudo tee ~/.gdbinit > /dev/null <<EOF
define init-pwndbg
source ~/pwndbg/gdbinit.py
end
document init-pwndbg
Initializes PwnDBG
end

define init-gef
source ~/gef/gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end
EOF

echo "[+] Creating pwndbg launcher..."
sudo tee /usr/bin/pwndbg > /dev/null <<EOF
#!/bin/bash
exec gdb -q -ex "init-pwndbg" "\$@"
EOF

echo "[+] Creating gef launcher..."
sudo tee /usr/bin/gef > /dev/null <<EOF
#!/bin/bash
exec gdb -q -ex "init-gef" "\$@"
EOF

{
	echo "[+] Setting permissions..."
    sudo chmod +x /usr/bin/pwndbg
    sudo chmod +x /usr/bin/gef
} || {
  echo "[-] Permission denied"
    exit
}

echo "[+] Done"

