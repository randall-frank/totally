import logging
import shutil
import subprocess
import sys
import os

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("build")

# Note: these paths are for local Windows installs.  All of these tools
# can be installed under Linux as well, but these paths will need to change.
assembler = ".\\merlin32\\windows\\merlin32.exe"
assembler_libdir = ".\\merlin32\\library\\"
ciderpresscli = ".\\ciderpress\\cp2.exe"

# Check for all the tools to be present
prerequisites = True
for name in (assembler, assembler_libdir, ciderpresscli, ):
    if not os.path.exists(name):
        log.warning(f"required build tool: {name} could not be found.")
        prerequisites = False
if not prerequisites:
    log.error("Please install necessary build tools and rerun the build process.")
    sys.exit(1)

# Set the version number and start the build process
# Must be 5 characters
version = [1,0,1]
s=""
for v in version:
    s += f"{int(v):02x}0a"
s = s[:-2] + "ff"
version = f"{version[0]}.{version[1]}.{version[2]}"
    
# Burn the version number into the source file VERSION.S 
log.info("Generating 6502 source code...")
with open(os.path.join("src","VERSION.S"), "w") as out:
    text = f"version  HEX  {s}\n"
    out.write(text)

files = ["TOTALLY.S"]

log.info("Assembling 6502 source code...")

# compile sources
# Merlin does not handle subdirs very well...
orig_dir = os.getcwd()
os.chdir("src")
for name in files:
    cmd = [os.path.join("..", assembler), os.path.join("..", assembler_libdir), name]
    log.info(f"Assembling: {name}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if '[Error]' in result.stdout:
        result.returncode = 1
    if result.returncode != 0:
        log.error(f"assembling: {name}: {result.stdout}")
        sys.exit(1)
os.chdir(orig_dir)


log.info("Building .po disk image...")
# Create a release .po image
rel_filename = "Totally_Release.po"
try:
    os.remove(rel_filename)
except Exception:
    pass
cmd = [ciderpresscli, "create-disk-image", rel_filename, "140K", "prodos"]
result = subprocess.run(cmd, capture_output=True, text=True, check=True)
log.info(f"Created release disk image: {result.stdout} {result.stderr}")
cmd = [ciderpresscli, "rename", rel_filename, ":", f"TOTAL_{version}"]
result = subprocess.run(cmd, capture_output=True, text=True, check=True)
log.info(f"Renamed release disk image: {result.stdout} {result.stderr}")

# Copy system files - PRODOS, BASIC...  
try:
    os.remove("SYSTEM/_FileInformation.txt")
except Exception:
    pass
cmd = [ciderpresscli, "add", "--strip-paths", rel_filename, "SYSTEM"]
result = subprocess.run(cmd, capture_output=True, text=True, check=True)
log.info(f"System files added to disk image: {result.stdout} {result.stderr}")

for name in os.listdir("basic"):
    if name.upper().endswith(".ABAS"):
        root = os.path.splitext(name)[0]
        try:
            os.remove(os.path.join("basic", root))
        except Exception:
            pass
        # make a temp copy to rename the file so the import is clean
        shutil.copy(os.path.join("basic", name), os.path.join("basic", root))
        cmd = [ciderpresscli, "import", "--strip-paths", rel_filename, "bas",  f"basic/{root}"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        os.remove(os.path.join("basic", root))
        log.info(f"Imported: basic/{name} as {root}")

for name in os.listdir("bin"):
    if not name.startswith("_"):
        cmd = [ciderpresscli, "add", "--strip-paths", rel_filename, f"bin/{name}"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        log.info(f"Imported: {name}")

log.info(f"Build v{version} complete.")
 