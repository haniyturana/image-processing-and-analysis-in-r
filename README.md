# Image Processing and Analysis in R

A clean, professional R project for structured image processing using the `magick` and `imager` packages.

## Project overview

This repository demonstrates a structured workflow for image analysis in R, including:

- baseline image loading
- grayscale conversion
- edge detection
- image transformation
- segmentation
- denoising
- morphology operations

## Repository structure

- `image_analysis.R` — main analysis script
- `images/original/` — baseline input images
- `images/noisy/` — noisy image examples for denoising tests
- `outputs/`
  - `edge-detection/` — edge detection results
  - `transformations/` — resized, rotated, filtered, sharpened, and other image transformations
  - `segmentation/` — segmentation results
  - `denoising/` — denoising results
  - `morphology/` — morphological operations results

## How to use

1. Place input images in `images/original/`.
2. Optionally place noisy images in `images/noisy/`.
3. Run `image_analysis.R` in R or RStudio.
4. Review generated outputs in the `outputs/` folders.

## Notes

- The repository is designed for reproducible image analysis in R.
- Only baseline source images are stored in `images/original/`.
- Processed images are stored under `outputs/` to keep the project organized.
