close all

data = load('UnlockedNoise.lvm');

gain=0.5223e-6;
piezoCal=11.6e-6/100;

tim = data(:,1);
out = data(:, 2);
dist = data(:,3);

sampF=1/(tim(2)-tim(1));

startTime=43*sampF;
endTime=48*sampF;

tim = tim(startTime:endTime);
out = gain*out(startTime:endTime);
dist = piezoCal*dist(startTime:endTime);

[AI, ~]=asd2(out, 1/sampF, 5, 1, @hann);
[AC, F]=asd2(dist, 1/sampF, 5, 1, @hann);

figure(1)
plot(tim,  out, tim, dist)
xlabel('Time (s)')
ylabel('Signal (m)')
grid on

figure(2)
loglog(F,AI, F, AC)
xlabel('Frequency (Hz)')
ylabel('ASD (m/\surdHz)')
grid on

figure(3)
loglog(F,AI/15e-2)
xlabel('Frequency (Hz)')
ylabel('ASD (rad/\surdHz)')
grid on