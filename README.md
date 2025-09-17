# 🌊 Seismic Unix Installation & Lab Repository

<div align="center">

![Seismic Unix](https://img.shields.io/badge/Seismic%20Unix-44R26-blue?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTMgMTJIMjEiIHN0cm9rZT0iY3VycmVudENvbG9yIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8L3N2Zz4K)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux-orange?style=for-the-badge&logo=linux)
![Shell](https://img.shields.io/badge/Shell-Bash-black?style=for-the-badge&logo=gnu-bash)

**An automated, user-friendly installation script for Seismic Unix with comprehensive lab assignments and examples**

[📥 Installation](#-installation) • [🚀 Quick Start](#-quick-start) • [📚 Lab Assignments](#-lab-assignments) • [🛠️ Usage](#-usage) • [📖 Documentation](#-documentation)

</div>

---

## 📋 Table of Contents

- [🌊 Seismic Unix Installation \& Lab Repository](#-seismic-unix-installation--lab-repository)
  - [📋 Table of Contents](#-table-of-contents)
  - [🎯 Overview](#-overview)
  - [✨ Features](#-features)
  - [🔧 System Requirements](#-system-requirements)
  - [📥 Installation](#-installation)
    - [🔄 Automatic Installation (Recommended)](#-automatic-installation-recommended)
    - [⚙️ Manual Installation](#️-manual-installation)
  - [🚀 Quick Start](#-quick-start)
  - [📚 Lab Assignments](#-lab-assignments)
  - [🗂️ Repository Structure](#️-repository-structure)
  - [🛠️ Usage Examples](#️-usage-examples)
  - [🔍 Troubleshooting](#-troubleshooting)
  - [📖 Documentation](#-documentation)
  - [🤝 Contributing](#-contributing)
  - [📝 Changelog](#-changelog)
  - [📜 License](#-license)
  - [👨‍💻 Author](#-author)
  - [🙏 Acknowledgments](#-acknowledgments)

---

## 🎯 Overview

This repository provides a **comprehensive solution** for installing and working with **Seismic Unix (SU)**, a powerful open-source seismic processing package. Whether you're a student learning seismic data processing or a researcher working with geophysical data, this repository offers:

- 🚀 **Automated Installation**: One-command installation with dependency management
- 📊 **Lab Assignments**: Complete collection of seismic processing exercises
- 📱 **Interactive Scripts**: User-friendly scripts with progress indicators
- 🎨 **Visual Examples**: Ready-to-run examples with visualization
- 📚 **Comprehensive Documentation**: Detailed guides and tutorials

---

## ✨ Features

### 🔧 Installation Script Features
- ✅ **Automated Dependency Management** - Automatically installs all required packages
- 🎨 **Colorized Output** - Beautiful, easy-to-read terminal output
- 📊 **Progress Indicators** - Real-time progress tracking
- 🛡️ **Error Handling** - Robust error detection and recovery
- 🔍 **System Validation** - Pre-installation system checks
- 💾 **Backup Creation** - Automatic backup of configuration files
- 🔧 **Multi-Shell Support** - Works with bash, zsh, and fish shells

### 📚 Repository Features
- 🧪 **Complete Lab Suite** - Full collection of seismic processing labs
- 📈 **Data Visualization** - Scripts for creating publication-quality plots
- 🔄 **Workflow Automation** - End-to-end processing pipelines
- 📖 **Detailed Documentation** - Step-by-step tutorials and guides
- 🎯 **Best Practices** - Industry-standard processing techniques

---

## 🔧 System Requirements

### Supported Operating Systems
- 🐧 **Ubuntu** 18.04 LTS or later
- 🐧 **Debian** 10 or later
- 🟡 **Other Linux distributions** (with manual dependency installation)

### Hardware Requirements
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: At least 2GB free space
- **CPU**: Any modern x86_64 processor

### Software Dependencies
> These are automatically installed by the script

<details>
<summary>📦 Click to view complete dependency list</summary>

**Development Tools:**
- `gcc` - GNU Compiler Collection
- `make` - Build automation tool
- `libc6-dev` - C library development files
- `build-essential` - Essential build tools

**Graphics Libraries:**
- `libx11-dev` - X11 development files
- `libxt-dev` - X Toolkit development files
- `libglu1-mesa-dev` - OpenGL utility library
- `freeglut3-dev` - OpenGL utility toolkit
- `libxmu-dev` - X11 miscellaneous utility library

**Fortran Support:**
- `gfortran` - GNU Fortran compiler

**GUI Libraries:**
- `libmotif-dev` - Motif development files

</details>

---

## 📥 Installation

### 🔄 Automatic Installation (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/seismic-unix-lab.git
   cd seismic-unix-lab
   ```

2. **Make the script executable:**
   ```bash
   chmod +x install_seismic_unix.sh
   ```

3. **Run the installation:**
   ```bash
   ./install_seismic_unix.sh
   ```

4. **Follow the interactive prompts:**
   - ✅ Choose installation directory (default: `~/SeismicUnix`)
   - ✅ Configure shell environment
   - ✅ Wait for automatic compilation

5. **Reload your shell:**
   ```bash
   source ~/.bashrc  # or ~/.zshrc for zsh users
   ```

### ⚙️ Manual Installation

<details>
<summary>🔧 Click for manual installation steps</summary>

If you prefer to install manually or need to customize the installation:

```bash
# 1. Install dependencies
sudo apt update
sudo apt install -y gcc make libc6-dev libx11-dev libxt-dev gfortran \
                    libglu1-mesa-dev freeglut3-dev libxmu-dev libxmu-headers \
                    libxi-dev libxt6 libmotif-dev

# 2. Create installation directory
export CWPROOT="$HOME/SeismicUnix"
mkdir -p "$CWPROOT"

# 3. Download and extract Seismic Unix
wget 'https://nextcloud.seismic-unix.org/s/LZpzc8jMzbWG9BZ/download?path=%2F&files=cwp_su_all_44R26.tgz&downloadStartSecret=d0kkx4lkunp' -O cwp_su_all_44R26.tgz
tar -xzf cwp_su_all_44R26.tgz -C "$CWPROOT"

# 4. Download pre-configured Makefile
wget https://gist.githubusercontent.com/botoseis/b6fc908ebf96fd19b092dda59e52abd2/raw/3b436dec519c6acd0eb7fb1442a387395406b2a5/Makefile.config -O "${CWPROOT}/src/Makefile.config"

# 5. Compile
cd "${CWPROOT}/src"
make install
make xtinstall
make finstall
make mglinstall
make utils
make xminstall
make sfinstall

# 6. Set up environment
echo "export CWPROOT='${CWPROOT}'" >> ~/.bashrc
echo 'export PATH="${PATH}:${CWPROOT}/bin"' >> ~/.bashrc
source ~/.bashrc
```

</details>

---

## 🚀 Quick Start

After successful installation, test your setup:

```bash
# Basic test - generate and display a synthetic seismogram
suplane | suximage title="My First Seismogram" &

# Create a simple wiggle trace display
suplane | suwigb title="Wiggle Display" xcur=2 &

# Generate Ricker wavelet
suricker | suxgraph title="Ricker Wavelet" &
```

**Expected Result:** Three windows should open displaying:
1. 🖼️ A synthetic seismic section (grayscale image)
2. 〰️ Wiggle trace display  
3. 📈 Ricker wavelet graph

---

## 📚 Lab Assignments

This repository includes a comprehensive set of lab assignments covering essential seismic processing techniques:

| Lab # | Topic | Description | Difficulty |
|-------|-------|-------------|------------|
| 📊 **Lab 01** | [Data Import & Visualization](labs/lab01/) | Loading SEG-Y data and basic visualization | 🟢 Beginner |
| 🔧 **Lab 02** | [Data Preprocessing](labs/lab02/) | Noise removal and trace editing | 🟢 Beginner |
| 📐 **Lab 03** | [Geometry Setup](labs/lab03/) | Survey geometry and coordinate systems | 🟡 Intermediate |
| ⚡ **Lab 04** | [Deconvolution](labs/lab04/) | Predictive and spiking deconvolution | 🟡 Intermediate |
| 📊 **Lab 05** | [Velocity Analysis](labs/lab05/) | Semblance analysis and velocity picking | 🟡 Intermediate |
| 🎯 **Lab 06** | [NMO Correction](labs/lab06/) | Normal moveout correction and stretch muting | 🟡 Intermediate |
| 🔄 **Lab 07** | [Stacking](labs/lab07/) | CMP stacking and stack enhancement | 🟡 Intermediate |
| 🌊 **Lab 08** | [Migration](labs/lab08/) | Time and depth migration techniques | 🔴 Advanced |
| 📈 **Lab 09** | [Amplitude Analysis](labs/lab09/) | AVO analysis and attribute extraction | 🔴 Advanced |
| 🎨 **Lab 10** | [Advanced Visualization](labs/lab10/) | Publication-quality plots and presentations | 🟡 Intermediate |

### 🗂️ Lab Structure
Each lab directory contains:
- 📋 `README.md` - Lab instructions and objectives
- 💻 `scripts/` - Processing scripts and workflows  
- 📊 `data/` - Sample datasets
- 🖼️ `results/` - Expected outputs and figures
- 📚 `docs/` - Additional documentation

---

## 🗂️ Repository Structure

```
seismic-unix-lab/
│
├── 📜 README.md                    # This file
├── 🛠️ install_seismic_unix.sh      # Enhanced installation script
├── 📝 LICENSE                      # MIT License
│
├── 📚 labs/                        # Lab assignments
│   ├── lab01_data_import/
│   ├── lab02_preprocessing/
│   ├── lab03_geometry/
│   ├── lab04_deconvolution/
│   ├── lab05_velocity_analysis/
│   ├── lab06_nmo_correction/
│   ├── lab07_stacking/
│   ├── lab08_migration/
│   ├── lab09_amplitude_analysis/
│   └── lab10_visualization/
│
├── 🔧 scripts/                     # Utility scripts
│   ├── utilities/
│   ├── plotting/
│   └── workflows/
│
├── 📊 data/                        # Sample datasets
│   ├── synthetic/
│   ├── field/
│   └── examples/
│
├── 📖 docs/                        # Documentation
│   ├── installation.md
│   ├── troubleshooting.md
│   ├── best_practices.md
│   └── api_reference.md
│
├── 🖼️ results/                     # Example outputs
│   ├── figures/
│   └── reports/
│
└── 🧪 tests/                       # Test scripts
    ├── unit_tests/
    └── integration_tests/
```

---

## 🛠️ Usage Examples

### Basic Seismic Processing Workflow

```bash
# 1. Load SEG-Y data
segyread tape=input.segy | segyclean > clean.su

# 2. Apply band-pass filter
sufilter < clean.su f=10,20,80,100 > filtered.su

# 3. Automatic gain control
sugain < filtered.su agc=1 wagc=0.5 > gained.su

# 4. Display results
suximage < gained.su title="Processed Seismic Section" &
```

### Velocity Analysis Example

```bash
#!/bin/bash
# Velocity analysis workflow

INPUT="field_data.su"
OUTPUT_DIR="velocity_analysis"
mkdir -p "$OUTPUT_DIR"

# 1. Sort to CDP gathers
susort < "$INPUT" cdp > sorted.su

# 2. Create velocity semblance
suvelan < sorted.su nv=50 dv=50 fv=1500 > semblance.su

# 3. Display semblance for picking
suximage < semblance.su title="Velocity Semblance" &

# 4. Apply picked velocities (example velocities)
sunmo < sorted.su vnmo=1500,2000,2500,3000 tnmo=0,1,2,3 > nmo_corrected.su
```

### Advanced Migration Script

```bash
#!/bin/bash
# Kirchhoff time migration example

INPUT="stacked_section.su"
VELOCITY_MODEL="velocity.su"

# Perform Kirchhoff migration
suktmig2d < "$INPUT" vfile="$VELOCITY_MODEL" \
          dx=12.5 dz=6.25 \
          aperx=1000 \
          antialias=1 \
          verbose=1 \
          > migrated_section.su

# Display results
suximage < migrated_section.su \
         title="Kirchhoff Time Migration" \
         label1="Time (s)" label2="Distance (m)" &
```

---

## 🔍 Troubleshooting

### Common Issues and Solutions

<details>
<summary>🚫 <strong>Installation fails with "command not found" errors</strong></summary>

**Problem**: Missing system dependencies

**Solution**:
```bash
# Update package lists first
sudo apt update

# Install essential build tools
sudo apt install -y build-essential wget curl

# Re-run the installation script
./install_seismic_unix.sh
```
</details>

<details>
<summary>🚫 <strong>Compilation errors during build</strong></summary>

**Problem**: Missing development headers or incompatible compiler

**Solutions**:
```bash
# Install additional development packages
sudo apt install -y linux-headers-$(uname -r)

# Check compiler version (GCC 7+ recommended)
gcc --version

# Clean and rebuild
cd $CWPROOT/src
make clean
make install
```
</details>

<details>
<summary>🚫 <strong>Graphics/X11 programs don't start</strong></summary>

**Problem**: Missing X11 libraries or display issues

**Solutions**:
```bash
# Install X11 development packages
sudo apt install -y xorg-dev libx11-dev libxt-dev

# Check display variable
echo $DISPLAY

# For SSH connections, enable X11 forwarding
ssh -X username@hostname

# Test X11 functionality
xeyes &  # Should open a simple X11 application
```
</details>

<details>
<summary>🚫 <strong>Programs run but produce no output</strong></summary>

**Problem**: PATH or CWPROOT environment variables not set correctly

**Solutions**:
```bash
# Check environment variables
echo $CWPROOT
echo $PATH | grep -o $CWPROOT/bin

# Re-source shell configuration
source ~/.bashrc  # or ~/.zshrc

# Manually set variables for current session
export CWPROOT="$HOME/SeismicUnix"
export PATH="$PATH:$CWPROOT/bin"

# Test installation
which suplane  # Should return path to program
```
</details>

<details>
<summary>🚫 <strong>Segmentation fault or core dump errors</strong></summary>

**Problem**: Memory issues or corrupted installation

**Solutions**:
```bash
# Check system resources
free -h
df -h $CWPROOT

# Reinstall specific components
cd $CWPROOT/src
make clean
make install

# Run with debugging
gdb suplane
(gdb) run
(gdb) bt  # Get backtrace if crash occurs
```
</details>

### 🆘 Getting Help

If you encounter issues not covered above:

1. 📖 **Check the documentation**: Browse the `docs/` directory
2. 🔍 **Search existing issues**: Look through repository issues
3. 📧 **Create a new issue**: Provide detailed error messages and system info
4. 💬 **Community support**: Join seismic processing forums

---

## 📖 Documentation

### 📚 Additional Resources

- 📘 **[Installation Guide](docs/installation.md)** - Detailed installation instructions
- 🔧 **[Troubleshooting Guide](docs/troubleshooting.md)** - Common problems and solutions  
- 🎯 **[Best Practices](docs/best_practices.md)** - Seismic processing workflows
- 📖 **[API Reference](docs/api_reference.md)** - Seismic Unix command reference
- 🎓 **[Learning Path](docs/learning_path.md)** - Structured learning progression

### 🔗 External Resources

- 🌐 **[Official Seismic Unix Website](http://www.cwp.mines.edu/cwpcodes/)**
- 📚 **[SU Documentation](http://sepwww.stanford.edu/oldsep/cliner/)**
- 🎓 **[Seismic Processing Tutorials](https://wiki.seg.org/wiki/Seismic_processing)**
- 📖 **[CWP/SU User Manual](http://www.cwp.mines.edu/cwpcodes/)**

---

## 🤝 Contributing

We welcome contributions from the seismic processing community! Here's how you can help:

### 🎯 Ways to Contribute

- 🐛 **Report bugs** and suggest improvements
- 📝 **Improve documentation** and tutorials
- 🧪 **Add new lab assignments** and examples
- 🔧 **Enhance installation scripts** and utilities
- 🎨 **Create visualization tools** and plotting scripts

### 🚀 Development Workflow

1. **🍴 Fork the repository**
2. **🌟 Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **💻 Make your changes** with clear, documented code
4. **✅ Test thoroughly** on supported platforms
5. **📝 Update documentation** as needed
6. **🔧 Commit changes**: `git commit -m 'Add amazing feature'`
7. **📤 Push to branch**: `git push origin feature/amazing-feature`
8. **🔄 Open a Pull Request** with detailed description

### 📋 Contribution Guidelines

- ✅ Follow existing code style and conventions
- ✅ Add tests for new functionality
- ✅ Update documentation for any changes
- ✅ Ensure compatibility with supported platforms
- ✅ Use meaningful commit messages

---

## 📝 Changelog

### Version 2.0.0 (Latest)
- 🎨 **Enhanced UI**: Colorized output with progress indicators
- 🛡️ **Improved Error Handling**: Robust error detection and recovery
- 🔍 **System Validation**: Pre-installation compatibility checks
- 💾 **Backup System**: Automatic configuration backups
- 🐚 **Multi-Shell Support**: Works with bash, zsh, and fish
- 📚 **Extended Documentation**: Comprehensive guides and tutorials

### Version 1.0.0
- 🚀 **Initial Release**: Basic installation functionality
- 📦 **Dependency Management**: Automated package installation
- 🔧 **Environment Setup**: PATH and CWPROOT configuration

<details>
<summary>📈 View detailed changelog</summary>

#### Version 2.0.0 - 2024-03-XX
**Added:**
- Interactive installation with user-friendly prompts
- Real-time progress tracking during compilation
- Automatic backup of existing configurations
- Support for multiple shell environments
- Enhanced error reporting with suggested solutions
- System compatibility validation

**Improved:**
- Installation script reliability and robustness
- Documentation with visual examples and tutorials
- Repository structure and organization
- Error messages and user feedback

**Fixed:**
- Path validation for directories with special characters
- Compilation issues on newer Ubuntu versions
- Environment variable persistence across shells
</details>

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 👨‍💻 Author

**[Your Name]**
- 🐙 GitHub: [@Ashraf-ISM](https://github.com/Ashraf-ISM/)
- 📧 Email: 23mc0049@iitism.ac.in
- 🎓 Institution: IIT (ISM) Dhanbad
- 💼 LinkedIn: [LinkedIn](https://www.linkedin.com/in/ashraf-iit-ism/)

*Geophysicist | Seismic Processing Specialist | Open Source Enthusiast*

---

## 🙏 Acknowledgments

Special thanks to the following individuals and organizations:

- 🏔️ **Colorado School of Mines** - For developing and maintaining Seismic Unix
- 🎓 **Center for Wave Phenomena (CWP)** - Original SU development team
- 🌐 **Open Source Community** - Contributors and maintainers
- 📚 **Educational Institutions** - Providing feedback and use cases
- 🔬 **Geophysical Researchers** - Testing and validation

### 🛠️ Built With

- 🐧 **Linux/Unix** - Primary development platform
- 🔧 **GNU Build System** - Compilation and installation
- 🐚 **Bash/Shell** - Scripting and automation
- 📊 **X11/Motif** - Graphics and user interface
- 🔢 **GNU Scientific Library** - Mathematical computations

---

<div align="center">

### 🌟 Star This Repository

If you find this project helpful, please consider giving it a ⭐!

**Happy Seismic Processing! 🌊📊🎯**

---

*Made with ❤️ for the seismic processing community*

![Seismic Wave](https://img.shields.io/badge/Seismic-Processing-blue?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTMgMTJIMjEiIHN0cm9rZT0iY3VycmVudENvbG9yIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgo8L3N2Zz4K)

</div>
