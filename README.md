# gdb_all_in_one

A script to easily install and set up **pwndbg** and **GEF** for GDB.

All you need to do is download the `install.sh` file and run it.
![圖片](https://github.com/user-attachments/assets/beeb6f30-fa52-400d-b012-4e886009981d)


## Installation

1. Download the `install.sh` file.
2. Make it executable:
   ```bash
   # Type in bash
   chmod +x install.sh
   ```
3. Run the script：`./install.sh`
4. Done! You can now use to debug binary with pwndbg or gef:
    ```bash
    pwndbg <your_program>
    gef <your_program>
    ```

# Features

  Automatically installs and configures pwndbg and GEF.

  Creates convenient pwndbg and gef launchers.

  Backs up existing .gdbinit if present.
