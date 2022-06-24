function std_dv = findGamma(exposed_image,max_amount)

for g = 0.0: 0.5: max_amount % increase the gamma value by 0.5
contrastedImg = imadjust(exposed_image,[],[],g); % do gamma transformation using the respective gamma value

if g==0.0 % if it is the first element in the array, then need to start with the following
adjusted_std=[g std2(contrastedImg)]; %calculate standardDeviation
else
adjusted_std= vertcat(adjusted_std,[g std2(contrastedImg)]); % calculate standardDeviation and add element into the array 
end
end
std_dv =adjusted_std % return the array  of [gamma value used, standard deviation of the transformed image using the gamma value]