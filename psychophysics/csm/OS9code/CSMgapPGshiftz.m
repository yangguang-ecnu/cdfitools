function CSMgapPGshiftz% This program alternates between square-wave CSM and a fixed-disparity plane, with intervening gray gaps% For CSM1, the fixed-disparity plane is at zero disparity% For CSM2, the fixed-disparity plane is at a disparity matching one or other of the CSM planes% msb 14 april 10 - updating for ptb3 and osx%****************************************************%% settingssterzShift = [ 1 0 1 0 ]*60; %%%=- msb to shift displays nasal or temporalhalfPeriod = 24; %Half-period of CSM2 but a full period of CSM due to four-phase cycle%24 gives 10 sec CSM, 2 sec gray, 10 sec fixed-disparity, 2 sec graynCycles = 5; % 6 gives 12 cycles of CSM, six of the null depth alternation in CSM2secsToDiscard = 16 ;dTPlan = 0.005;planFreq = round(1/dTPlan); %time sampling in the experimental plandT = 0.125;	% must not be changed !!!!gap=2; % duration of zero-disparity gap (sec)nonGap = halfPeriod/2-gap; % residual non-gap durationgapL=0.3; % luminance of the gapchoice = menu('CSM Frequency', '0.5 Hz','1 Hz', '2 Hz', '4 Hz');switch choice    case 1, period = 2;    case 2, period = 1;    case 3, period = 0.5;    case 4, period = 0.25;endchoice = menu('Stimulus','CSM1 ','CSM2');switch choice    case 1,  nullType=1;    case 2,  nullType=2;endsizeDot = 4;disparityMag=8;dispMagn=disparityMag/sizeDot;dispFixNull = 0;sizeX = 128;sizeY = 96;sizeFix = 4;dens = 0.1;sterRect = [0,0,sizeDot*sizeX,sizeDot*sizeY];sizeXY = sizeX*sizeY;% centerInd = (sizeX/2+0.5)*sizeY;surfaceType = 1;motionType = 1;fixType = 1;fixMov = 0;%% exp plan% sampled every dTPlan=5 msnHalfPeriodPlan = round(halfPeriod*planFreq);expPlan = [+(1:nHalfPeriodPlan), -(1:nHalfPeriodPlan)]; % 1 cycleexpPlan = expPlan * halfPeriod/nHalfPeriodPlan;expPlan = kron(ones(1,nCycles+1),expPlan); % nCycles+1 cyclesexpPlan = expPlan((2*nHalfPeriodPlan+1-planFreq*secsToDiscard):end); % nCycles + secsToDiscard upfrontMexpPlan=max(expPlan)/2; %precomputes max for gap insertionshift=0;gapPlan=[expPlan(end-shift+1:end) expPlan(1:end-shift)]; %shifts gapPlan FORWARD relative to expPlan%% white dots, color fixationplaneClut{1} = 255*[0,0,0;1,1,1];planeClut{2} = 255*[0,0,0;1,1,1];planeClut{3} = 255*[0,0,0;1,0.8,0.2];%% disparity planesplane0 = zeros(sizeY,sizeX);plane1 = ones(sizeY,sizeX);plane2 = plane1; plane2(round(sizeY*2/5)+1:round(sizeY*3/5),:) = 0;%% making cluts for the movieclut{1} = CombineCluts(planeClut,[1,0,2]);clut{2} = CombineCluts(planeClut,[0,1,2]);%% open screensscreenNumber=[1,2];window = [0 0];for n = 1:2    window(n) = Screen(screenNumber(n),'OpenWindow',0);end% defining rectangleswindowRect = Screen(window(1),'Rect');sterRect = CenterRect(sterRect,windowRect);%% prepare fixationstmp = zeros(sizeY,sizeX);tmp(sizeY/2, sizeX/2-4:sizeX/2+4)=1;tmp(sizeY/2-4:sizeY/2+4, sizeX/2)=1;%=- cross fixationfixInds{1} = find(tmp(:));% nonius lefttmp = zeros(sizeY,sizeX);tmp(sizeY/2-2*sizeFix:sizeY/2-1,sizeX/2) = 1;fixInds{2} = find(tmp(:));% nonius righttmp = flipud(tmp);fixInds{3} = find(tmp(:));% square+nonius leftfixInds{4} = union(fixInds{1},2*sizeFix*sizeY+fixInds{2});% square+nonius rightfixInds{5} = union(fixInds{1},2*sizeFix*sizeY+fixInds{3});%% wait to startplaneToBe{1:2} = plane0;planeBeen = planeToBe;ster = planeBeen;fprintf('Press any key to start');KbPressWaittime0 = GetSecs;t0 = time0;%% main loopfor k=1:1000000000    planeBeen{1} = planeToBe{1};    planeBeen{2} = planeToBe{2};    t1 = GetSecs;    t = t1 - t0;    nT = ceil(t*planFreq);    if nT > length(expPlan), break, end    planeToChange = rem(k,2);        switch motionType;        case 1, % step CSM stereomotion: CWT            if abs(expPlan(nT)) > MexpPlan  % Select for stereomotion for high values of expPlan                if surfaceType == 1                    if nullType==1 % CSM1                        dispMod = 0;                    else % nullType=2; CSM2                        dispMod = sign(expPlan(nT));                    end                else                    dispMod = 1;                end            else                dispMod = mod(expPlan(nT), period);                if dispMod < period/2                    dispMod = 1;                else                    dispMod = -1;                end            end            dFactor = round(dispMagn*dispMod);            if surfaceType == 1                disparity = dFactor*plane1;            else                disparity = dFactor*plane2;            end        case 2,  %sinusoidal stereomotion            if expPlan(nT) < 0                if surfaceType == 1                    dispMod = 0;                else                    dispMod = 1;                end            else                dispMod = sin(2*pi*expPlan(nT)/period);            end            dFactor = round(dispMagn*dispMod);            if surfaceType == 1                disparity = dFactor*plane1;            else                disparity = dFactor*plane2;            end    end        if fixMov        dispFix = round(dispMagn*dispMod);    else        dispFix = dispFixNull;    end        planeToBe{1} = round(rand(sizeY,sizeX)-.5+dens);    planeToBe{2} = round(rand(sizeY,sizeX)-.5+dens);    inds0 = (1:sizeXY)';    inds1 = inds0 - sizeY*disparity(:);    inds1 = max(inds1,1);    inds1 = min(inds1,sizeXY);    planeToBe{2}(inds1) = planeToBe{1}(inds0);        for n=1:2        % add plane        ster{n} = planeBeen{n}*2^planeToChange+planeToBe{n}*2^(1-planeToChange);        switch fixType;            case 1,                if n == 1                    ster{n}(fixInds{1}+floor(dispFix/2)*sizeY) = 4;                else                    ster{n}(fixInds{1}-ceil(dispFix/2)*sizeY) = 4;                end            case 2,                if n == 1                    ster{n}(fixInds{2}+floor(dispFix/2)*sizeY) = 4;                else                    ster{n}(fixInds{3}-ceil(dispFix/2)*sizeY) = 4;                end            case 3,                if n == 1                    ster{n}(fixInds{4}+floor(dispFix/2)*sizeY) = 4;                else                    ster{n}(fixInds{5}-ceil(dispFix/2)*sizeY) = 4;                end        end            end        for n=1:2                ep = abs(gapPlan(nT)) - MexpPlan; gep = ep - MexpPlan/2*(sign(ep)-1); % generates a double-frequency ramp                if gep > nonGap; % Changes display at end of each phase "gaps"            ster{n} = (1-gapL)*200*plane1;            if n == 1                ster{n}(fixInds{1}+floor(dispFix/2)*sizeY) = 4;            else                ster{n}(fixInds{1}-ceil(dispFix/2)*sizeY) = 4;            end        end                if k*dT<secsToDiscard % Changes display at beginning of run            ster{n} = (1-gapL)*200*plane1;            if n == 1                ster{n}(fixInds{1}+floor(dispFix/2)*sizeY) = 4;            else                ster{n}(fixInds{1}-ceil(dispFix/2)*sizeY) = 4;            end        end                Screen(window(n), 'PutImage', ster{n}, sterRect+sterzShift*((n-1.5)*2)); % show the stuff =- msb shift in or out by sterzShift                            end        time1 = GetSecs;    if time1 - time0 > dT        %			error('Rate is too fast')    else        while 1            time1 = GetSecs;            if time1 - time0 > dT                time0 = time1;                break            end        end    end        if k*dT>0 % never Change display at beginning of run        if gep < nonGap; % blocks flickering by showing dots only before gap            Screen(window(1),'SetClut',clut{2-planeToChange});            Screen(window(2),'SetClut',clut{2-planeToChange});        end    endendclear allScreen('MatlabToFront')