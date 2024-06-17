% To use this parallel-code phase algorithm, first initialize the acquisition object and configure its properties
initialsync = gnssSignalAcquirer;
initialsync.SampleRate = upconvert.IFSampleRate;
initialsync.IntermediateFrequency = CenterFrequency;

% Consider the data that is 1 millisecond long.
numSamples = SampleRate*IntegrationTime;
[allRxInput,prevSamples] = buffer(rxwaveform,numSamples);
nFrames = size(allRxInput,2);
numdetectsat = 0;
PRNIDsToSearch = 1:32;

for iBuffer = 1:nFrames
    bufferWave = allRxInput(:,iBuffer);

    if iBuffer == 1
        % This example assumes a hot start for all the satellites once initial synchronization is complete
        % Hence, perform initial synchronization only once in this example
        % When decoding the almanac data too, based on the available satellites, initial synchronization can be performed for the visible satellites only
        numSamplesForInitSync = SampleRate*1e-3; % Corresponding to 1 milliseccond
        [y,corrval] = initialsync(bufferWave(1:numSamplesForInitSync),1:32); % Search for all 32 GPS satellites
        PRNIDsToSearch = y(y(:,4).IsDetected==1,1).PRNID.';                  % Get row vector
        doppleroffsets = y(y(:,4).IsDetected==1,2).FrequencyOffset;
        codephoffsets = y(y(:,4).IsDetected==1,3).CodePhaseOffset;

        numdetectsat = length(PRNIDsToSearch);

        disp("The detected satellite PRN IDs: " + num2str(PRNIDsToSearch))
        if ShowVisualizations == 1
            for i = 1: size(PRNIDsToSearch,2)
                figure;
                mesh(initialsync.FrequencyRange(1):initialsync.FrequencyResolution:initialsync.FrequencyRange(2), ...
                    0:size(corrval,1)-1, corrval(:,:,1));
                xlabel("Doppler Offset")
                ylabel("Code Phase Offset")
                zlabel("Correlation")
                msg = "Correlation Plot for PRN ID: " + PRNIDsToSearch(i);
                title(msg)
                
                saveas(gcf, [OutputFolder, '\', 'Cross-Correlation-', num2str(PRNIDsToSearch(1)), '.png']);
            end   
        end

        % Initialize all the properties which must be accumulated.
        accuph = zeros(nFrames,numdetectsat); % Each column represents data from a satellite
        accufqy = zeros(nFrames,numdetectsat);
        accufqyerr = zeros(nFrames,numdetectsat);
        accupherr = zeros(nFrames,numdetectsat);
        accuintegwave = zeros(nFrames,numdetectsat);
        accudelay = zeros(nFrames,numdetectsat);
        accudelayerr = zeros(nFrames,numdetectsat);

        % Update properties for each tracking loop
        carrierCodeTrack = gnssSignalTracker;
        carrierCodeTrack.SampleRate = SampleRate;
        carrierCodeTrack.IntermediateFrequency = CenterFrequency;
        carrierCodeTrack.PLLNoiseBandwidth = PLLNoiseBandwidth;
        carrierCodeTrack.FLLNoiseBandwidth = FLLNoiseBandwidth;
        carrierCodeTrack.DLLNoiseBandwidth = DLLNoiseBandwidth;
        carrierCodeTrack.IntegrationTime = IntegrationTime;
        carrierCodeTrack.PRNID = PRNIDsToSearch;
        carrierCodeTrack.InitialFrequencyOffset = doppleroffsets;
        carrierCodeTrack.InitialCodePhaseOffset = codephoffsets;
    end

    [integwave,trackinfo] = carrierCodeTrack(bufferWave);

    % Accumulate the values to see the results at the end
    accuintegwave(iBuffer,:) = integwave;
    accufqyerr(iBuffer,:) = trackinfo.FrequencyError;
    accufqy(iBuffer,:) = trackinfo.FrequencyEstimate;
    accupherr(iBuffer,:) = trackinfo.PhaseError;
    accuph(iBuffer,:) = trackinfo.PhaseEstimate;
    accudelayerr(iBuffer,:) = trackinfo.DelayError;
    accudelay(iBuffer,:) = trackinfo.DelayEstimate;
end

trackedSignal = accuintegwave; % Useful for further GPS receiver processing

if ShowVisualizations == 1
    % for isat = 1:numdetectsat
    for isat = 1: size(PRNIDsToSearch,2) % See tracking results of all the detected satellites by using above line
        groupTitle = "Tracking Loop Results for Satellite PRN ID:" + PRNIDsToSearch(isat);

        figure

        % Plot the frequency discriminator output
        subplot(2,1,1)
        plot(accufqyerr(:,isat))
        xlabel("Milliseconds")
        ylabel("Frequency Error")
        title("Frequency Discriminator Output")

        % Plot the FLL output
        subplot(2,1,2)
        plot(accufqy(:,isat))
        xlabel("Milliseconds")
        ylabel("Estimated Frequency Offset")
        title("FLL Output")
        sgtitle("FLL " + groupTitle)

        saveas(gcf, [OutputFolder, '\', 'FLL-', num2str(PRNIDsToSearch(isat)), '.png']);

        figure

        % Plot the phase discriminator output
        subplot(2,1,1)
        plot(accupherr(:,isat))
        xlabel("Milliseconds")
        ylabel("Phase Error")
        title("Phase Discriminator Output")

        % Plot the PLL output
        subplot(2,1,2)
        plot(accuph(:,isat))
        xlabel("Milliseconds")
        ylabel("Estimated Phase")
        title("PLL Output")
        sgtitle("PLL " + groupTitle)

        saveas(gcf, [OutputFolder, '\', 'PLL-', num2str(PRNIDsToSearch(isat)), '.png']);

        figure

        % Plot the delay discriminator output
        subplot(2,1,1)
        plot(accudelayerr(:,isat))
        xlabel("Milliseconds")
        ylabel("Delay Error")
        title("Delay Discriminator Output")

        % Plot the DLL output
        subplot(2,1,2)
        plot(accudelay(:,isat))
        xlabel("Milliseconds")
        ylabel("Estimated Delay")
        title("DLL output in the units of number of C/A-code chips")
        sgtitle("DLL " + groupTitle)

        saveas(gcf, [OutputFolder, '\', 'DLL-', num2str(PRNIDsToSearch(isat)), '.png']);
    end
end

if ShowVisualizations == 1
    demodsamples = accuintegwave(301:end,:)/rms(accuintegwave(:));
    if ~isempty(demodsamples)
        scatterplot(demodsamples(:))

        saveas(gcf, [OutputFolder, '\', 'Scatter-', num2str(PRNIDsToSearch(isat)), '.png']);
    end
end