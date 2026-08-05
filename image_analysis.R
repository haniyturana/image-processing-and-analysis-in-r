# Image Processing and Analysis in R
# Clean, reproducible workflow for baseline and noisy images.

library(magick)

input_dir <- "images/original"
noisy_dir <- "images/noisy"
output_base <- "outputs"

output_edge <- file.path(output_base, "edge-detection")
output_transform <- file.path(output_base, "transformations")
output_segmentation <- file.path(output_base, "segmentation")
output_denoising <- file.path(output_base, "denoising")
output_morphology <- file.path(output_base, "morphology")

output_dirs <- c(output_edge, output_transform, output_segmentation, output_denoising, output_morphology)
for (d in output_dirs) {
  if (!dir.exists(d)) {
    dir.create(d, recursive = TRUE)
  }
}

read_image_files <- function(directory) {
  list.files(directory, pattern = "\\.(jpg|jpeg|png|gif)$", ignore.case = TRUE, full.names = TRUE)
}

process_baseline_image <- function(image_path) {
  image_name <- tools::file_path_sans_ext(basename(image_path))
  original <- image_read(image_path) %>% image_resize('800')
  grayscale <- image_convert(original, colorspace = "gray")

  edge_image <- image_edge(original, radius = 1)
  image_write(edge_image, file.path(output_edge, paste0(image_name, "_edge.jpg")))

  red_layer <- image_channel(original, "red")
  green_layer <- image_channel(original, "green")
  blue_layer <- image_channel(original, "blue")
  rgb_combined <- image_combine(c(red_layer, green_layer, blue_layer), colorspace = "sRGB")
  image_write(rgb_combined, file.path(output_transform, paste0(image_name, "_rgb.jpg")))

  transformed <- original %>%
    image_resize("600x600!") %>%
    image_scale("50%") %>%
    image_crop("400x400+100+100") %>%
    image_rotate(45)
  image_write(transformed, file.path(output_transform, paste0(image_name, "_transformed.jpg")))

  charcoal_image <- image_charcoal(original)
  image_write(charcoal_image, file.path(output_transform, paste0(image_name, "_charcoal.jpg")))

  sharpened_image <- image_convolve(original, matrix(c(0, -1, 0, -1, 5, -1, 0, -1, 0), nrow = 3))
  image_write(sharpened_image, file.path(output_transform, paste0(image_name, "_sharpened.jpg")))

  equalized_image <- image_equalize(original)
  image_write(equalized_image, file.path(output_transform, paste0(image_name, "_equalized.jpg")))

  rectangle <- image_crop(original, "600x600+250+250")
  image_write(rectangle, file.path(output_morphology, paste0(image_name, "_rectangle.jpg")))

  fuzzy_cutout <- image_transparent(original, color = "black", fuzz = 25)
  fuzzy_white <- image_background(fuzzy_cutout, "white")
  image_write(fuzzy_white, file.path(output_segmentation, paste0(image_name, "_fuzzy.png")))

  segmented <- image_threshold(grayscale, type = "white", threshold = "50%")
  image_write(segmented, file.path(output_segmentation, paste0(image_name, "_segmented.png")))

  eroded <- image_morphology(segmented, method = "erode", kernel = "disk:1")
  image_write(eroded, file.path(output_segmentation, paste0(image_name, "_eroded.png")))

  opened <- image_morphology(segmented, method = "open", kernel = "disk:1")
  image_write(opened, file.path(output_morphology, paste0(image_name, "_opened.png")))

  closed <- image_morphology(segmented, method = "close", kernel = "disk:1")
  image_write(closed, file.path(output_morphology, paste0(image_name, "_closed.png")))
}

process_noisy_image <- function(image_path) {
  image_name <- tools::file_path_sans_ext(basename(image_path))
  noisy_image <- image_read(image_path) %>% image_resize('800')
  denoised_image <- image_blur(noisy_image, radius = 2, sigma = 1.5)
  image_write(denoised_image, file.path(output_denoising, paste0(image_name, "_denoised.jpg")))
}

baseline_images <- read_image_files(input_dir)
for (image_file in baseline_images) {
  process_baseline_image(image_file)
}

noisy_images <- read_image_files(noisy_dir)
for (image_file in noisy_images) {
  process_noisy_image(image_file)
}
