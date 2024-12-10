# Downsampling Pipeline

This Nextflow pipeline performs downsampling on sequencing data. It takes a CSV file as input, which specifies the input files, desired downsampling size, sample names, and output paths.

## 1. Introduction

This Nextflow pipeline facilitates downsampling of high-throughput sequencing data, enabling efficient analysis by reducing data volume while preserving representative sampling. It employs the seqtk sample command for downsampling, which performs random sampling of reads from input FASTQ files. This documentation is intended for bioinformaticians and researchers seeking to reduce computational burden and expedite analyses of large sequencing datasets. The pipeline accepts a CSV file specifying input data, desired downsampling size, and output locations, streamlining the downsampling process for various samples.

## 2. Pipeline Overview

This section provides an overview of the downsampling pipeline, outlining its key steps and data flow. A diagram illustrates the process from reading the input CSV, through the downsampling operation, to the generation of output FASTQ files.

+-------+      +-------------+      +--------+
| Input |----->| Downsampling |----->| Output |
|  CSV  |      |   (seqtk)   |      | FASTQ |
+-------+      +-------------+      +--------+

This simple DAG illustrates the flow:

- Input CSV: The pipeline starts by reading the input CSV file, which contains information about the samples, input files, desired downsampling size, and output locations.

- Downsampling (seqtk): The seqtk sample command is used to perform the downsampling. The input FASTQ files specified in the CSV are processed according to the down_size parameter. This is the core operation of the pipeline.

- Output FASTQ: The downsampled FASTQ files are written to the output locations specified in the CSV. The naming convention for paired-end data (R1 and R2) would be determined by the pipeline's implementation (not explicitly defined in the provided documentation).

## 3. Usage

### 3.1.  Input Requirements

- **Input CSV:** Describe the required columns in the input CSV:
    - `sample_name`:  The name of the sample.
    - `input_path`: Semicolon-separated paths to input FASTQ file(s).  For paired-end data, two paths should be provided, separated by a semicolon. For single-end, only one path.
    - `down_size`: The target size for downsampling (e.g., number of reads).  Explain the units.
    - `output_path`: The path for the output downsampled FASTQ file(s).

### 3.2 Running the Pipeline

To run the pipeline, execute the following command:

```bash
nextflow run main.nf -params-file params.yaml
```

The params.yaml file should contain the following parameters:

```
input: /path/to/input_file.csv
outdir: /path/to/output_directory
```

Where:

- input: Specifies the path to your input CSV file. This file must be formatted as described in the "Input Requirements" section (Section 3.1).
- outdir: Specifies the directory where the output FASTQ files will be written.

For example, if your input CSV is located at /data/samples.csv and you want to store the output in /results/downsampled, your params.yaml file would look like this:

```
input: /data/samples.csv
outdir: /results/downsampled
```

### 3.3 Output
The pipeline generates downsampled FASTQ files. For each sample listed in the input CSV, one or two output FASTQ files are created, depending on whether the input data is single-end or paired-end. The output files are written to the directory specified by the output_path column in the input CSV.

The output file names are constructed based on the sample_name and the original input file name. For single-end data, the output file will have the extension .fastq.gz. For paired-end data, two files are generated for each sample, following the naming convention <sample_name>_R1.fastq.gz and <sample_name>_R2.fastq.gz for read 1 and read 2, respectively.

## 4. Parameters
The pipeline currently uses the following parameters, defined in the params.yaml file:

- input: (Required) Path to the input CSV file.
- outdir: (Required) Path to the output directory.

There are no additional configurable parameters within the pipeline itself for controlling aspects like the random seed for downsampling. The seqtk sample command uses a pseudo-random number generator, and its seed is not explicitly set by this pipeline implementation, meaning it will likely default to a system- or process-dependent value. If repeatable downsampling is required, additional pipeline development would be necessary to introduce a seed parameter.

## 5. Software Requirements
This pipeline requires:

- Nextflow
- seqtk
- (Potentially others if a preprocessing step is implemented, such as fastp)

## 6. Workflow Details (Optional)

The core workflow consists of reading the input CSV, then using seqtk sample to downsample the FASTQ files according to the specified down_size. The pipeline does not include a dedicated preprocessing step.

## 7. Troubleshooting

- Input CSV Errors: Ensure the input CSV file is correctly formatted and contains all required columns. Check for typos in file paths and sample names.
- seqtk Errors: If seqtk encounters errors, verify that the input FASTQ files are valid and accessible. Check the seqtk documentation for specific error messages.
- Permissions Issues: Make sure the pipeline has write permissions to the specified output directory.

## 8. Example

Example input.csv:

```csv
sample_name,input_path,down_size,output_path
sample1,/path/to/sample1_R1.fastq.gz;/path/to/sample1_R2.fastq.gz,10000,/path/to/output/
sample2,/path/to/sample2.fastq.gz,5000,/path/to/output/
```

Expected Output (for sample1 in paired-end mode):

/path/to/output/sample1_R1.fastq.gz /path/to/output/sample1_R2.fastq.gz

Expected Output (for sample2 in single-end mode):

/path/to/output/sample2.fastq.gz

## 9. Contact

For support or questions, please contact @giusmar or @giuseppemartone on github.