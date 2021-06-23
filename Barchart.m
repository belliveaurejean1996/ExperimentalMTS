


figure
a=[rand(10,1)*100 zeros(10,1)  ];
b=[zeros(10,1)    rand(10,1)*5 ];
[AX,H1,H2] = plotyy([1:10],a, [1:10],b, 'bar', 'bar');
set(H1,'FaceColor','r') % a
set(H2,'FaceColor','b') % b