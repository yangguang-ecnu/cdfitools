% config_gen.m 2 5 34 1
% make a config file for Sean's grating stim program
%% settings
blocks=20;

%% define some strings and things
rewards={...
'  $1_McDonalds '...
'  $1_Arbys '...
'  $1_Burger_King '...
};
rewardp=randperm(3);

cities={...
'  none '...
'  none '...
'  none '...
'  none '...
'  none '...
'  none '...
};
cityp=randperm(6);

stims={...
'1 1 '...
'1 2 '...
'1 0 '...
'2 1 '...
'2 2 '...
'2 0 '...
'0 1 '...
'0 2 '...
'0 0 '...
};
stimp=randperm(9);

timestrs={...
'[ 1000 1000 4000 1000 ] '...
'[ 3000 1000 8000 1000 ] '...
'[ 3000 1000 2000 1000 ] '...
};

%% build the nine stim strings
% environments, circle, disc, text, [timing], break 
% [timing] = environemnt, reward, ITI, fix
% ex: 1 1 1 test_1-1-1 [2000 1000 1000 1000] 0
ss{1}=[ stims{stimp(1)} '1 ' rewards{rewardp(1)} timestrs{1} '0'];
ss{2}=[ stims{stimp(2)} '1 ' cities{cityp(1)}    timestrs{1} '0'];
ss{3}=[ stims{stimp(3)} '1 ' cities{cityp(2)}    timestrs{1} '0'];
ss{4}=[ stims{stimp(4)} '2 ' rewards{rewardp(2)} timestrs{2} '0'];
ss{5}=[ stims{stimp(5)} '2 ' cities{cityp(3)}    timestrs{2} '0'];
ss{6}=[ stims{stimp(6)} '2 ' cities{cityp(4)}    timestrs{2} '0'];
ss{7}=[ stims{stimp(7)} '0 ' rewards{rewardp(3)} timestrs{3} '0'];
ss{8}=[ stims{stimp(8)} '0 ' cities{cityp(5)}    timestrs{3} '0'];
ss{9}=[ stims{stimp(9)} '0 ' cities{cityp(6)}    timestrs{3} '0'];

%% open the file
filename = 'config.txt';
fid = fopen(filename, 'wt');
%% write the file header
P={ 'square 	: 300 300 5 15'...
    'textbox	: 50 10'...
    'disks	    : 70 40 20 20'...
    ''...
    'Background	: 0.5  0.5  0.5'...
    'Black	    : 0.0  0.0  0.0'...
    'White	    : 1.0  1.0  1.0'... 
    'Gray	    : 0.75  0.75  0.75'...
    ''...
    'pause      : 45 90 135'...
    ''...
    'TRIALS'...
    };
for k = 1:size(P,2)
    fprintf(fid, '%s\n', P{k});
end

%% write out the trial lines
for k=1:blocks
    ssp=randperm(9);
    for m=ssp
        fprintf(fid, '%s\n', ss{m});
    end
end

%% write the end of the file
P={ 'TRIAL-END'...
    'make 		# ignore the rest'...
   };
for k = 1:size(P,2)
    fprintf(fid, '%s\n', P{k});
end

fprintf(fid, '\n %d trials\n', blocks*9);

%% clean up, show results
fclose(fid);
type(filename)

%% notes=======================================================
% 20 randperms of the following
% A1 2s 4s    dot left    stim 1  reward 1
% A2 2s 4s    dot left    stim 2  city 1
% A3 2s 4s    dot left    stim 3  city 2
% B1 4s 8s    dot up      stim 4  reward 2
% B2 4s 8s    dot up      stim 5  city 3
% B3 4s 8s    dot up      stim 6  city 4
% C1 4s 2s    dot right   stim 7  reward 3
% C2 4s 2s    dot right   stim 8  city 5
% C3 4s 2s    dot right   stim 9  city 6
% 
% randomly assign cities, stims and rewards
% rewards:
% $0.50 McDonalds
% $0.50 Arby's
% $0.50 Burger King
% 
% cities:
% now just indicates a "nothing" box
% 
% stims:
% 1 1
% 1 2
% 1 3
% 2 1
% 2 2
% 2 3
% 3 1
% 3 2
% 3 3
% 
%example config file============================================
% # Add comment starting with '#'
% square 	: 200 200 5 15
% textbox	: 50 10
% disks	: 70 40 20 20
% 
% Background	: 0.5  0.5  0.5
% Black	: 0.0  0.0  0.0 
% White	: 1.0  1.0  1.0 
% Gray	: 0.75  0.75  0.75
% 
% 
% TRIALS
% 0 0 0 test_0-0-0  [2000 1000 1000 1000] 0
% 1 1 1 test_1-1-1 [2000 1000 1000 1000] 0
% 2 2 2 test_2-2-2 [2000 1000 1000 1000] 0
% 0 0 0 3sec_env  [3000 1000 100 100] 0
% 1 1 1 3sec_reward [100 3000 100 100] 0
% 2 2 2 3set_ITI [100 1000 3000 100] 0
% TRIAL-END
% 
% make 		# ignore the rest
% 
% #square	: width, height, line_width, spacing_lines	
% #textbox 	: height, spacing_square_box
% #radius 	: disk_square, line_width, disk_outside, spacing_square_disk)
% #timing:	: CS US ITI fix
% 
% #Background	: 1.0  0.5  0.5
% #Black		: 0.0  0.0  0.0 
% #White		: 1.0  1.0  1.0 
% #Gray		: 0.75  0.75  0.75
% 
% #trials need to be encapsulated b/w "TRIALS" & "TRIAL-END"
% #each line contains:
% # 	environments, circle, disc, text, [timing], break 
% #		[timing] = environment/CS (box and dot), reward/US (box dot logo), ITI (dot), fixation
% 
% #make 		# ignore the rest