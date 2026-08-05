getwd()

#change to my wd
setwd("H:/My Drive/UKM/Sem2/Unstructured Data/project2/Task 1_q1_q2")

#convert image from color to grey

#install.packages("magick")

library(magick)

# Data acquisition
flower1 = image_read("flower1.jpg") %>% image_resize('800') #sebab just now run split fucntion make my R lag
flower2 = image_convert(flower1, colorspace = "gray")
flower2
image_write(flower2, "flower2.jpg")

people1 = image_read("people1.jpg")  %>% image_resize('800')
people2 = image_convert(people1, colorspace = "gray")
people2
image_write(people2, "people2.jpg")

scenary1 = image_read("scenary1.jpg")  %>% image_resize('800')
scenary2 = image_convert(scenary1, colorspace = "gray")
scenary2
image_write(scenary2, "scenary2.jpg")

building1 = image_read("building1.jpg")  %>% image_resize('800')
building2 = image_convert(building1, colorspace = "gray")
building2
image_write(building2, "building2.jpg")


food1 = image_read("food1.jpg")  %>% image_resize('800')
food2 = image_convert(food1, colorspace = "gray")
food2
image_write(food2, "food2.jpg")

#perform analysis for flower1

# perform the following analysis
#1. Edgedetection
edge = image_edge(flower1, radius = 1)
edge
image_write(edge, "flower1_edge.jpg")

#2. Splitting & concatenating image, but splitting still slow. so we convert to std RBG color
red = image_channel(flower1, "red")
blue = image_channel(flower1, "blue")
green = image_channel(flower1, "green")

splitting = c(red, blue, green)

concatenating = image_combine(splitting, colorspace ="sRGB")
image_write(concatenating, "flower1_concate.jpg")
#warna flower menjadi lebih terang sebab kesan dari concate RGB tadi.

#3. Image transformation such as resizing, rotation, scaling & cropping
transformed = (flower1) %>%
  image_resize("600x600!")%>%
  image_scale("50%") %>%
  image_crop("400x400+100+100") %>%
  image_rotate(45)
transformed
image_write(transformed, "flower1_transformed.jpg")

#when follow the step resizing, rotation, scaling & cropping, image become weird,
#rearrange step, resize, scale, crop, rotate hence image better

#4. Filtering image
filter = image_charcoal(flower1)
filter
image_write(filter, "flower1_filtered.jpg")


#5. Rectangular, circular and fuzzy selection
rectangle = image_crop(flower1, "600x600+250+250")
rectangle
image_write(rectangle, "flower1_rectangle.jpg")
# "600x600+250+250" adjust as how we like the image would be

# to create circular is not really direct, need to create a background shape circle 1st
info = image_info(flower1)
w = info$width
h = info$height

image_draw(image_blank(w,h,"black"))
symbols(w/2,h/2,circles=min(w,h)/3, bg ="white", inches = FALSE, add = TRUE)
circle = image_capture()

dev.off()

#then baru buat circular
circle_mask = image_transparent(circle, color = "black")
circular = image_composite(flower1, circle_mask, operator = "CopyOpacity") %>% 
  image_background("black")
circular

image_write(circular, "flower1_circular.jpg")

#fuzzy selection
fuzz_value = 25

fuzz_cutout = image_transparent(flower1, color = "black", fuzz = fuzz_value)
plot(fuzz_cutout)

image_write(fuzz_cutout, "flower1_fuzzy_blackbg.png")

#when do above method, image would always show black bg at all platform
#only at R Graphics it will show transparent background
#so, we need to add 1 more step, image_background to convert the
#color bg to white
fuzz_cutout_whitebg =  image_background(fuzz_cutout, "white")
image_write(fuzz_cutout_whitebg, "flower1_fuzzy_whitebg.png")


#6. Blurry &sharpen

#blur
blur = image_blur(flower1, radius = 10, sigma = 5)
plot(blur)#only Rstudio can display image without function plot
image_write(blur, "flower1_blur.png")


#sharp
kernel = matrix(c(0, -1, 0, -1, 5, -1, 0, -1, 0), nrow = 3)
sharp = image_convolve(flower1, kernel)
plot(sharp)
image_write(sharp, "flower1_sharp.png")


#7. Segmentation
#convert to grayscale 1st, which we ald did and named it as flower2

segmented = image_threshold(flower2, type = "white", threshold = "50%")
plot(segmented)

#then morphology using eroded
eroded = image_morphology(segmented,method = "erode", kernel = "disk:1")
plot(eroded)

image_write(eroded, "flower1_segmented.png")


#8. Histogram equalization
equalizer = image_equalize(flower1)
plot(equalizer)
image_write(equalizer, "flower1_hist_equalizer.png")


#9. Morphological operations
#opening  - to remove noise at background
opening = image_morphology(segmented,method = "open", kernel = "disk:1")
plot(opening)
image_write(opening, "flower1_opening.png")


#closing  - to remove noise at flowers
closing = image_morphology(segmented,method = "close", kernel = "disk:1")
plot(closing)
image_write(closing, "flower1_closing.png")


# now, i have tested on flower1, now i can do looping so 
# i dont need to manual repeat at all images
# take note segmented and morphology only can be done on image2  =grayscale image

#we skip flower cause it is done
color_images = c("people1.jpg", "scenary1.jpg", "building1.jpg", "food1.jpg")

for(f in color_images){
 img1 = image_read(f) %>% image_resize('800')
 img2 = image_convert(img1, colorspace = "gray")

 base_name = tools::file_path_sans_ext(f)

 #1.Edgedetection
 image_write(image_edge(img1, radius = 1), paste0(base_name, "_edge.jpg"))

 #2. Splitting & concatenating image, but splitting still slow. so we convert to std RBG color
 red = image_channel(img1, "red")
 blue = image_channel(img1, "blue")
 green = image_channel(img1, "green")

 splitting = c(red, blue, green)

 concatenating = image_combine(splitting, colorspace ="sRGB")
 image_write(concatenating, paste0(base_name, "_concate.jpg"))
#warna flower menjadi lebih terang sebab kesan dari concate RGB tadi.

 #3. Image transformation such as resizing, rotation, scaling & cropping
 transformed = (img1) %>%
  image_resize("600x600!")%>%
  image_scale("50%") %>%
  image_crop("400x400+100+100") %>%
  image_rotate(45)
 image_write(transformed, paste0(base_name,"_transformed.jpg"))

#when follow the step resizing, rotation, scaling & cropping, image become weird,
#rearrange step, resize, scale, crop, rotate hence image better

 #4. Filtering image
 image_write(image_charcoal(img1), paste0(base_name, "_filtered.jpg"))


 #5. Rectangular, circular and fuzzy selection
 image_write(image_crop(img1, "600x600+250+250"), paste0(base_name, "_rectangle.jpg"))
# "600x600+250+250" adjust as how we like the image would be

# to create circular is not really direct, need to create a background shape circle 1st
 info = image_info(img1)
 w = info$width
 h = info$height

 image_draw(image_blank(w,h,"black"))
 symbols(w/2,h/2,circles=min(w,h)/3, bg ="white", inches = FALSE, add = TRUE)
 circle = image_capture()

 dev.off()

 #then baru buat circular
 circle_mask = image_transparent(circle, color = "black")
 circular = image_composite(img1, circle_mask, operator = "CopyOpacity") %>% 
   image_background("black")
 circular

 image_write(circular,  paste0(base_name,  "_circular.jpg"))

 #fuzzy selection
 fuzz_value = 25

 fuzz_cutout = image_transparent(img1, color = "black", fuzz = fuzz_value)
 plot(fuzz_cutout)

 image_write(fuzz_cutout, paste0(base_name, "_fuzzy_blackbg.png"))

 #when do above method, image would always show black bg at all platform
 #only at R Graphics it will show transparent background
 #so, we need to add 1 more step, image_background to convert the
 #color bg to white
 fuzz_cutout_whitebg =  image_background(fuzz_cutout, "white")
 image_write(fuzz_cutout_whitebg, paste0(base_name, "_fuzzy_whitebg.png"))

 #6. Blurry &sharpen

 #blur
 image_write(image_blur(img1, radius = 10, sigma = 5), paste0(base_name,  "_blur.png"))


 #sharp
 kernel = matrix(c(0, -1, 0, -1, 5, -1, 0, -1, 0), nrow = 3)
 image_write(image_convolve(img1, kernel), paste0(base_name,   "_sharp.png"))


 #7. Segmentation
 #convert to grayscale 1st, which we ald did and named it as flower2

 segmented = image_threshold(img2, type = "white", threshold = "50%")

 #then morphology using eroded
 eroded = image_morphology(segmented,method = "erode", kernel = "disk:1")

 image_write(eroded, paste0(base_name,   "_segmented.png"))


 #8. Histogram equalization
 image_write(image_equalize(img1), paste0(base_name,   "_hist_equalizer.png"))


 #9. Morphological operations
 image_write(image_morphology(segmented,method = "open", kernel = "disk:1"), paste0(base_name,   "_opening.png"))


 #closing  - to remove noise at flowers
 image_write(image_morphology(segmented,method = "close", kernel = "disk:1"), paste0(base_name,   "_closing.png"))

}


#now, image is scattered in 1 folder hence become difficult to check/verify
#so, we segregate acccording to grouo

allpics = list.files(pattern  = "\\.(jpg|jpeg|png|gif)$", ignore.case  = TRUE)

category = c("flower", "people", "scenary", "building", "food")

for (cat in category){
 if (!dir.exists(cat)){dir.create(cat)}
 fail_category = allpics[grep(cat, allpics, ignore.case  = TRUE)]
 for (f in fail_category){
  file.copy(f, file.path(cat, f), overwrite = TRUE)
  if(!grepl(paste0(cat, "1\\."), f, ignore.case = TRUE)){
    file.remove(f)
  }
 }
}



#in case we run at got error becuase we have rename and re arrange the file
#this probably won't happen anymore, but just in case, this is the backup code
#to undone the action

category = c("flower", "people", "scenary",  "building", "food")

for (cat in category) {
  if (dir.exists(cat)) {
     master_files =  list.files(path = cat, pattern = "1\\.(jpg|jpeg|png|gif)$", full.names = TRUE)
     if (length(master_files) > 0) {
       for (f in master_files) {
         new_File  = basename(f)
         file.rename(f, new_File)
        }
      }
  }
}


##===================================================================================
### next, for QUESTION 3, 
##===================================================================================

setwd("H:/My Drive/UKM/Sem2/Unstructured Data/project2/Task 1_q1_q2/noise img")
options(timeout =300)

install.packages("imager", repos = "https://cloud.r-project.org/") #cause i cannot download the libabry earier
#error message:
#siro.au/bin/windows/contrib/4.5/igraph_2.3.2.zip': Timeout of 60 seconds was reached
#3: In download.file(urls, destfiles, "libcurl", mode = "wb", ...) :
 # URL 'https://cran.csiro.au/bin/windows/contrib/4.5/imager_1.0.8.zip': Timeout of 60 seconds was reached
#4: In download.file(urls, destfiles, "libcurl", mode = "wb", ...) :
 # some files were not downloaded
#> library("imager")
#Error in library("imager") : there
library(imager)

#error:
#Error: package or namespace load failed for ‘imager’ in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]]):
 #there is no package called ‘tiff’
#so, install tiff
#install.packages("tiff")
library(imager)

#now ok, proceed to denoising and morphology

#read use magic : image_read instead of imager : load.image because it can read any type of img format
mcolor1 = image_read("imgnoisecol1.jpg") #flower in a bottle (Chroma/ISO noise)
mcolor2 = image_read("imgnoisecol2.jpg") #scenary everest (Gaussian noise)

mgray1 = image_read("imgnoisegray1.png") #apple (Gaussian noise)
mgray2 = image_read("imgnoisegray2.gif") #man img (Salt & Pepper noise)

#convert object magick become cimg imager

color1 = magick2cimg(mcolor1)
color2 = magick2cimg(mcolor2)
gray1 = magick2cimg(mgray1)
gray2 = magick2cimg(mgray2)

#ensure gray is one type of gray variant color
gray1 = grayscale(gray1)
gray2 = grayscale(gray2)


# img denoising
#gaussion/ISO noise img
denoise_col1 = isoblur(color1, sigma =1.5) #iso img
denoise_col2 = isoblur(color2, sigma =2.0) #gausion img, higher sigma cause img has higher noise
denoise_gray1 = isoblur(gray1, sigma =1.5) #gausion img

#salt pepper noise
denoise_gray2 = medianblur(gray2, n=3)


#plot before vs after for color
png("comparison_b4after_color.png", width =1000, height=1000, res =120)#save comparison 

layout(matrix(1:4, nrow=2, ncol=2, byrow=TRUE))

plot(color1, main = "Ori noise col 1")
plot(denoise_col1, main = "denoised col 1")
plot(color2, main = "Ori noise col 2")
plot(denoise_col2, main = "denoised col 2")
dev.off()

#plot before vs after for gray
png("comparison_b4after_gray.png", width =1000, height=1000, res =120)
layout(matrix(1:4, nrow=2, ncol=2, byrow=TRUE))

plot(gray1, main = "Ori noise gray 1")
plot(denoise_gray1, main = "denoised gray 1")
plot(gray2, main = "Ori noise gray 2")
plot(denoise_gray2, main = "denoised gray 2")

dev.off()

#save individual

save.image(denoise_col1, "denoise_col1.jpg")
save.image(denoise_col2, "denoise_col2.jpg")
save.image(denoise_gray1, "denoise_gray1.jpg")
save.image(denoise_gray2, "denoise_gray2.jpg")



#next, perform morphology
#binarization
bin_col1=grayscale(denoise_col1)<0.5
bin_col2=grayscale(denoise_col2)<0.5
bin_gray1= denoise_gray1<0.5
bin_gray2= denoise_gray2<0.5

my_mask = imfill(x=15, y=15, val = 1)#adjust the pixellet at x and y to see img clearer


#morphology col1
png("morphology_col1.png", width =1000, height = 1000, res =120)
layout(matrix(1:4, nrow = 2, ncol = 2, byrow= TRUE))
plot(erode(bin_col1, my_mask), main = "Col1: Erosion")
plot(dilate(bin_col1, my_mask), main = "Col1: Dilation")
plot(mopening(bin_col1, my_mask), main = "Col1: Opening")
plot(mclosing(bin_col1, my_mask), main = "Col1: Closing")

dev.off()

##now, we just repeat the same process to the remaining images

others_img  = list(col2 = bin_col2,
                   gray1 = bin_gray1,
                   gray2 = bin_gray2
)

for (img_type in names(others_img)){
    current_img = others_img[[img_type]]
    img_file =paste0("morphology_", img_type, ".png")
    
    png(img_file, width =1000, height = 1000, res =  120)
    layout(matrix(1:4,  nrow = 2, ncol = 2, byrow = TRUE))


    plot(erode(current_img, my_mask), main = paste0(img_type, ": Erosion"))
    plot(dilate(current_img, my_mask), main = paste0(img_type, ": Dilation"))
    plot(mopening(current_img, my_mask), main = paste0(img_type, ": Opening"))
    plot(mclosing(current_img, my_mask), main = paste0(img_type, ": Closing"))

    dev.off()
}