%-------------------------------------------------------------------------%
% Copyright (c) 2019 Modenese L.                                          %
%                                                                         %
%    Author:   Luca Modenese                                              %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script should be run after a dataset of stl geometries has been
% refined and has the purposes of reducing the size of files for storage
% and distribution, e.g. in GitHub.
% ----------------------------------------------------------------------- %
% Scripts that takes a set of triangulated geometries as input and computes
% the joint parameters for the lower limb joints based on those geometries.
% -----------------
% IMPORTANT NOTES |
%--------------------------------------------------------------------------
% 1) This function does not produce a complete set of joint parameters but
% only those available through geometrical analyses, that are:
%       * from pelvis: ground_pelvis_child
%       * from femur : hip_child  // knee_parent
%       * from tibia : knee_child** 
%       * from talus : ankle_child // subtalar parent
% other functions then complete the information required to generate a MSK
% model, e.g. use ankle child location and ankle axis to define an ankle
% parent reference system etc.
% ** note that the tibia geometry was not used to define the knee child 
% anatomical coord system in previous approaches, e.g. Modenese et al. JB 2018 
% 2) Bony landmarks are identified on all bones
% 3) Body-fixed Cartesian coordinate system are defined but not employed in
% the construction of the models.
% -------------
% DESIGN NOTE |
%--------------------------------------------------------------------------
% I thought about the structure of the JCS output structure variable.
% Currently it is:
%                   JCS.body_name.joint_name.parameter
% and could have been:
%                   JCS.joint_name.parameter
% I think the first option is better and will allow for better structures to
% save all model info in one structure, e.g.
%       Model.BodyName.(all_CS_fields)
%       Model.BodyName.(all_joints)
%       Model.BodyName.(all_BL)
% so that everything that has been processed here is immediately available
%--------------------------------------------------------------------------


function [JCS, BL, CS] = analyzeBoneGeometries(geom_set, method_fem, method_tibia, in_mm)

% setting defaults
if nargin<2; method_fem = ''; method_tibia = ''; in_mm = 1; end
if nargin<3; method_tibia = ''; in_mm = 1; end
if nargin<4; in_mm = 1; end

% ---- PELVIS -----
if isfield(geom_set,'pelvis') 
    [CS.pelvis, JCS.pelvis, BL.pelvis]  = GIBOK_pelvis(geom_set.pelvis, in_mm);
    %     addMarkersFromStruct(osimModel, 'pelvis', BL.pelvis, in_mm);
elseif isfield(geom_set,'pelvis_no_sacrum')
    [CS.pelvis, JCS.pelvis, BL.pelvis]  = GIBOK_pelvis(geom_set.pelvis_no_sacrum, in_mm);
    %     addMarkersFromStruct(osimModel, 'pelvis', BL.pelvis, in_mm);
end


% ---- FEMUR -----
if isfield(geom_set,'femur_r')
    switch method_fem
        case 'Miranda'
            [CS.femur_r, JCS.femur_r, BL.femur_r] = Miranda2010_buildfACS(geom_set.tibia_r);
        case 'Kai'
            [CS.femur_r, JCS.femur_r, BL.femur_r]  = CS_femur_Kai2014(geom_set.femur_r);
        case 'GFem-spheres'
            [CS.femur_r, JCS.femur_r, BL.femur_r] = GIBOK_femur(geom_set.femur_r, [], 'spheres');
        case 'GFem-ellipsoids'
            [CS.femur_r, JCS.femur_r, BL.femur_r] = GIBOK_femur(geom_set.femur_r, [], 'ellipsoids');
        case 'GFem-cylinder'
            [CS.femur_r, JCS.femur_r, BL.femur_r] = GIBOK_femur(geom_set.femur_r, [], 'cylinder');
        otherwise
            [CS.femur_r, JCS.femur_r, BL.femur_r] = GIBOK_femur(geom_set.femur_r);
    end
%     addMarkersFromStruct(osimModel, 'femur_r', BL.femur_r, in_mm);
end

%---- TIBIA -----
if isfield(geom_set,'tibia_r')
    switch method_tibia
        case 'Miranda' % same as Kai but using inertia
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = Miranda2010_buildtACS(geom_set.tibia_r);
        case 'Kai'
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = CS_tibia_Kai2014(geom_set.tibia_r);
        case 'GTib-plateau'
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = GIBOK_tibia(geom_set.tibia_r, [], 'plateau');
        case 'GTib-ellipse'
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = GIBOK_tibia(geom_set.tibia_r, [], 'ellipse');
        case 'GTib-centroids'
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = GIBOK_tibia(geom_set.tibia_r, [], 'centroids');
        otherwise
            [CS.tibia_r, JCS.tibia_r, BL.tibia_r] = CS_tibia_Kai2014(geom_set.tibia_r);
    end
%     addMarkersFromStruct(osimModel, 'tibia_r', BL.tibia_r, in_mm);
end

%---- TALUS/ANKLE -----
if isfield(geom_set,'talus_r')
    [CS.talus_r, JCS.talus_r] = GIBOK_talus(geom_set.talus_r);
end

%---- CALCANEUS/SUBTALAR -----
if isfield(geom_set,'calcn_r')
    [CS.calcn_r, JCS.calcn_r, BL.calcn_r] = GIBOK_calcn(geom_set.calcn_r);
%     addMarkersFromStruct(osimModel, 'calcn_r',   CalcnBL,  in_mm); 
end

end