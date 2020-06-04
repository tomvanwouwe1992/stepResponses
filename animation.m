function [] = animation(P,dt,D)
figure(10)
Px1 = [zeros(size(P,1),1) P(:,[1 3 5])];
Py1 = [zeros(size(P,1),1) P(:,[2 4 6])]; 

Px2 = [P(:,[3 7 9])];
Py2 = [P(:,[4 8 10])]; 

Hl=line(Px1(1,:), Py1(1,:)); hold on
H2=line(Px2(1,:), Py2(1,:)); hold on
axis equal
Hl=handle(Hl);
% Hl.Color='r';
 xlim([-0.6 3.6])
 ylim([-0.1 1.7])

for i = 1:1
for j=1:size(P,1)
    Hl.XData=Px1(j,:);
    Hl.YData=Py1(j,:);
    H2.XData=Px2(j,:);
    H2.YData=Py2(j,:);    
    if mod(j,4) == 0 || j ==1 
        scatter(Px1(j,1),Py1(j,1),1,'b');
        scatter(Px1(j,2),Py1(j,2),1,'b');
        scatter(Px1(j,4),Py1(j,4),1,'g');
        scatter(Px2(j,1),Py2(j,1),1,'g');
        scatter(Px2(j,2),Py2(j,2),1,'r');
        scatter(Px2(j,3),Py2(j,3),1,'r');
    end
    pause(0.1)
end
Px1 = Px1 + D;
Px2 = Px2 + D;

end