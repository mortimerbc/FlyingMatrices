#!/bin/bash
echo "FlyingMatrices"
echo "12th January of 2017"
echo "Calculate LandSat NDVI"
echo "Assign the input file to variable $input"
input=$(ls *.tif)
echo "Assign the name of the output file to variable $output_ndvi"
output_ndvi="ndvi.tif"
echo "Calculating the NDVI applying gdal_calc: command line raster calculator with numpy syntax"
gdal_calc.py -A $input --A_band=4 -B $input --B_band=3  --outfile=$output_ndvi  --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'
echo "show some histogram statistics of the NDVI file"
gdalinfo -hist -stats $output_ndvi
echo "resample 30m x 30m pixelsize NDVI output file to 60m x 60m, using gdalwarp to aggregate the averages of a resoluion using the output_ndvi file"
echo "method: average resampling, computes the average of all non-NODATA contributing pixels"
gdalwarp -tr 60 60 -r average $output_ndvi ndvi_averaged_60m.tif
echo "The output file of the resampling"
ndvi_resampled="ndvi_averaged_60m.tif"
echo "reproject resampled file to Lat/long WGS84 using EPSG:4326 code"
gdalwarp -t_srs EPSG:4326 $ndvi_resampled ndvi_60m_wgs84.tif