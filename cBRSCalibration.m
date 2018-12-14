close all

data = load('TriangCalibration.lvm');

piezoCal=11.6e-6/100;
wavelength=1300e-9;
elecGain=4.9;
F=0.5;

tim = data(:,1);
out = data(:, 2);
dist = data(:,3);

sampF=1/(tim(2)-tim(1));

startTime=1.62e4;
endTime=2.23e4;

tim = tim(startTime:endTime);
out = out(startTime:endTime);
dist = piezoCal*elecGain*dist(startTime:endTime);

dmaxs=[];
dmins=[];
maxs=[];
mins=[];
N=3;

for i=0:N-1
    
    startCut=floor((endTime-startTime)/N*i)+1;
    endCut=floor((endTime-startTime)/N*(i+1));
    
    [maxvalue, argmax]=max(out(startCut:endCut));
    [minvalue, argmin]=min(out(startCut:endCut));
    
    hold on
    figure(2)
    plot(dist(startCut:endCut),out(startCut:endCut))
    line([dist(argmax+startCut) dist(argmax+startCut)], [0 -1.5]); 
    line([dist(argmin+startCut) dist(argmin+startCut)], [0 -1.5]); 
    
    maxs=[maxs; maxvalue];
    mins=[mins; minvalue];
    dmaxs=[dmaxs; dist(argmax+startCut)];
    dmins=[dmins; dist(argmin+startCut)];
end

figure(1)
hold on
plot(dist, out, dist, detrend(1./(1+F*sin(pi*(dist+dist(1))/wavelength).^2),'constant')-0.8)
line([wavelength wavelength], [0 -1.5]);
line([wavelength*2 wavelength*2], [0 -1.5]);
line([wavelength*3 wavelength*3], [0 -1.5]);
hold off
xlabel('Displacement (m)')
ylabel('Intensity (V)')
grid on

disp(['Visibility: ' num2str(abs(mean((maxs-mins)./(maxs+mins)))) ' +- ' num2str(abs(std((maxs-mins)./(maxs+mins))))])
disp(['Wavelength: ' num2str(2*abs(mean(dmaxs-dmins))) ' +- ' num2str(2*abs(std(dmaxs-dmins)))])
disp(['MAY BE FACTORS OF TWO THAT ARE FUDGED!'])


