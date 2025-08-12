This directory is used as the TFTP root for PXE/iPXE booting via dnsmasq.

Place iPXE binaries here if you need to override or provide custom boot files (e.g., undionly.kpxe, ipxe.efi).

By default, the dnsmasq container uses built-in iPXE files, but you can mount or copy your own here if needed.

See the main README for more details on PXE/iPXE boot flow.
