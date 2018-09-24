function index = getAngleIndex(orientation)   
    orientation = orientation(1) + 180;
    index = round(orientation/15)+1;
    if index == 25
        index = 1;
    end
end

