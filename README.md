# Downsampling Pipeline

This Nextflow pipeline performs downsampling on sequencing data. It takes a CSV file as input, which specifies the input files, desired downsampling size, sample names, and output paths.

## 1. Introduction

Briefly describe the purpose of this pipeline and the type of data it processes.  Mention the downsampling method used (if specific, like random sampling, etc.). Target audience for this documentation (e.g., bioinformaticians, researchers).

## 2. Pipeline Overview

Explain the overall workflow of the pipeline. Include a diagram if helpful.  Mention the key steps: reading the input CSV, preprocessing (details below), and outputting the downsampled data.

## 3. Usage

### 3.1.  Input Requirements

- **Input CSV:** Describe the required columns in the input CSV:
    - `sample_name`:  The name of the sample.
    - `input_path`: Semicolon-separated paths to input FASTQ file(s).  For paired-end data, two paths should be provided, separated by a semicolon. For single-end, only one path.
    - `down_size`: The target size for downsampling (e.g., number of reads).  Explain the units.
    - `output_path`: The path for the output downsampled FASTQ file(s).

### 3.2 Running the Pipeline

Provide the command to execute the pipeline.  Include clear instructions on how to specify parameters, especially the input CSV file. Example:

```bash
nextflow run main.nf -params-file params.yaml
```

### 3.3 Output
Describe the generated output files, their format (e.g., FASTQ), and their location (as specified in the input CSV). Explain how the output file names are constructed. For paired-end data, clarify the naming convention for R1 and R2 files.

## 4. Parameters
List and describe the configurable parameters of the pipeline (if any). For instance, if there's a parameter to control the random seed for downsampling, document it here.

## 5. Software Requirements
Nextflow
Software dependencies of the preprocess process, likely including tools like seqtk, fastp, etc.
## 6. Workflow Details (Optional)
Provide more details about the PREPROCESS workflow, including the tools used and any specific algorithms or procedures implemented.

## 7. Troubleshooting
Include common issues or error messages users might encounter and suggest solutions.

## 8. Example
Provide a minimal working example with a sample input CSV file and the expected output.

## 9. Contact
Provide contact information for support or questions.