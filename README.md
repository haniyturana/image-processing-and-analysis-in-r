# Image Processing and Analysis in R

This repository contains an R-based image analysis project using `magick` and `imager`.

## Structure

- `image_analysis.R` — main analysis script
- `images/original/` — baseline input images
- `images/noisy/` — noisy input images for denoising experiments
- `outputs/`
  - `edge-detection/` — edge detection results
  - `transformations/` — resized, rotated, filtered, sharpened, and other image transformations
  - `segmentation/` — segmentation results
  - `denoising/` — denoising results
  - `morphology/` — morphological operations results


## Notes

- Use baseline images from `images/original/` as input.
- Generate derived results into `outputs/` using `image_analysis.R`.
- Keep only source images in `images/original/` for a clean project structure.
