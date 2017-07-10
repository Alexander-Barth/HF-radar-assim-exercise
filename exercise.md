
# Example data

* Surface currents from an ROMS model of the Ligurian Sea
* In total 528 ensemble members

# Exercises

1. Compute the ensemble standard of the velocity vector as
$$\sqrt{ var(u) + var(v)}$$
Create a plot (x-axis is the longitude and y-axis is the latitude) and the color represents the ensemble standard.
2. What is the probablity that the speed (norm of the velocity vector) exceeds 20 cm/s ?
Create a plot (x-axis is the longitude and y-axis is the latitude) and the color represents the probability
3. Simplified twin experiement:
   * Let's assume that the last ensemble member is the reality (true current)
   * The last ensemble member will be used to extract observations, but it will not be used during the analysis
   * Assimilate radial observations of two HF radar sites
   * Optimize the position of two HF radar sites. We assume that the field of view of the HF Radar 120 degrees but the orientation of the antenna can be choosen freely.
   * Validate the mean of the analysis ensemble with the true currents


