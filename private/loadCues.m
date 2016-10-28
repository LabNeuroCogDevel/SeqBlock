function s = loadCues(s, runnum)

files = dir(fullfile(s.cues.dir, 'a*jpg'));
shuf = Shuffle(files);

ct = 1;

for runnum = 1:s.info.numruns
    for blocki = 1:s.blocks.num
        for seq = 1:2
            s.cues.files(runnum, blocki, seq) = shuf(ct);

            [im cmap alpha] = imread(fullfile(s.cues.dir, s.cues.files(runnum, blocki, seq).name));
            %im(:,:,4) = alpha;
            [newimg, newcmap] = scaleImage(im, s.cues.size);
            s.cues.texture(runnum, blocki, seq) = Screen('MakeTexture', s.display.w, newimg);

            fadeimg = reduceContrast(newimg, s.cues.fadeLevel);
            s.cues.texture_faded(runnum, blocki, seq) = Screen('MakeTexture', s.display.w, fadeimg);

            ct = ct + 1;
        end
    end
end


% load instruction images
[im cmap alpha] = imread(fullfile(s.cues.dir, 'instruct1.jpg'));
[newimg, newcmap] = scaleImage(im, s.cues.size);
s.cues.instruct_texture(1) = Screen('MakeTexture', s.display.w, newimg);
fadeimg = reduceContrast(newimg, s.cues.fadeLevel);
s.cues.instruct_texture_faded(1) = Screen('MakeTexture', s.display.w, fadeimg);

[im cmap alpha] = imread(fullfile(s.cues.dir, 'instruct2.jpg'));
[newimg, newcmap] = scaleImage(im, s.cues.size);
s.cues.instruct_texture(2) = Screen('MakeTexture', s.display.w, newimg);
fadeimg = reduceContrast(newimg, s.cues.fadeLevel);
s.cues.instruct_texture_faded(2) = Screen('MakeTexture', s.display.w, fadeimg);


    function [img, map] = scaleImage(img, maxSize)
        [h,w,dim] = size(img);
        if h>w
            scaleFac = maxSize/h;
        else
            scaleFac = maxSize/w;
        end
        [img, map] = imresize(img, [round(h*scaleFac) round(w*scaleFac)]);
    end

    function f = reduceContrast(img, fadeLevel)
        f = 255-img; 
        f = f*fadeLevel; 
        f = 255-f;
    end

   s.flags.loadCues=1;
end