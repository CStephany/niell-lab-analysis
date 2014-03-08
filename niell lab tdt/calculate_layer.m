function [ layer ] = calculate_layer(tip_loc,theta)
%UNTITLED Summary of this function goes here
    %assign units to layers
%   Detailed explanation goes here
    %'tip_loc' is location of electrode tip recovered in histology in uM
    %' theta' is angle of electrode to surface of cortex, number_sites is
   
    %extracts first site of all tetrodes
    tet = cells(:,1);
    
    %converts tetrode location into phsyical distance from tip of electrode
    Distance = zeros(length(tet),1);
   
    Distance(tet==1)= 775;
    Distance(tet==5)= 675;
    Distance(tet==9)= 575;
    Distance(tet==13)= 475;
    Distance(tet==17)= 375;
    Distance(tet==21)= 275;
    Distance(tet==25)= 175;
    Distance(tet==29)= 75;
    Distance(tet==33)= 775;
    Distance(tet==37)= 675;
    Distance(tet==41)= 575;
    Distance(tet==45)= 475;
    Distance(tet==49)= 375;
    Distance(tet==53)= 275;
    Distance(tet==57)= 175;
    Distance(tet==61)= 75;
    
vert_dist = sind(theta)*Distance(:);
    
depth_site = (tip_loc - vert_dist);

layer = zeros(length(tet),1);
layer(depth_site<100)=1;
layer((depth_site>101)&(depth_site<220))=2;
layer((depth_site>221)&(depth_site<350))=3;
layer((depth_site>351)&(depth_site<550))=4;
layer((depth_site>551)&(depth_site<731))=5;
layer(depth_site>732)=6;

end
