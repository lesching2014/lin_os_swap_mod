MODID=lin_os_swap_mod
AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

# # Installation script
chmod 0755 $MODPATH/*

# Setting permissions
set_perm_recursive $MODPATH 0 0 0755 0644

# Load utility functions
. $MODPATH/vars.sh || abort

# Create Swapfile
function create_swapfile(){
    ui_print "- Trying to stop Existing Swapfile"
    ui_print "  (This can take a long time, do not panic if it looks stuck)"
    swapoff $SWAP_FILE_PATH/swapfile
    ui_print "- [OK]"
    rm -rf $SWAP_FILE_PATH
    mkdir $SWAP_FILE_PATH
    ui_print "- Creating a swapfile of $SWAP_BIN_SIZE MB"
    ui_print "  This can take a minute or two..."
    cd $SWAP_FILE_PATH && dd if=/dev/zero of=swapfile bs=1048576 count=$SWAP_BIN_SIZE
    ui_print "- [OK]"
    ui_print "- Making Swapfile..."
    cd $SWAP_FILE_PATH && mkswap swapfile
    ui_print "- [OK]"
    ui_print "- Create uninstall.sh file..."
    echo "swapoff $SWAP_FILE_PATH/swapfile" > $MODPATH/uninstall.sh
    echo "rm -rf $SWAP_FILE_PATH" >> $MODPATH/uninstall.sh
}

# Enable Swapfile settings
function enable_swapfile(){
    ui_print "- Setting Swappiness to $SWAPPINESS"
    sysctl vm.swappiness=$SWAPPINESS
    ui_print "- Now Reboot and see if it works!!"
}

# Start install
function custom_install() {
    ui_print "- Please keep the screen on during installation"
    ui_print "- Version $SWAP_MOD_VERSION"
    ui_print "- SWAP-SIZE: $SWAP_BIN_SIZE (MB)"
    ui_print "- SWAPPINESS: $SWAPPINESS"
    ui_print "- SWAP_FILE_PRIOR: $SWAP_FILE_PRIOR"
    ui_print "- SWAP_FILE_PATH: $SWAP_FILE_PATH"
    create_swapfile
    enable_swapfile
}

#
# # Custom installation
custom_install
