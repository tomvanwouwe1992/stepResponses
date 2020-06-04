function xCOM = xCOM(dq1,dq2,dq3,dq4,dq5,g,l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1,q2,q3,q4,q5)
%XCOM
%    XCOM = XCOM(DQ1,DQ2,DQ3,DQ4,DQ5,G,L1,L2,L4,LC1,LC2,LC3,LC4,LC5,M1,M2,M3,M4,M5,Q1,Q2,Q3,Q4,Q5)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    28-May-2020 15:18:26

t2 = pi.*(1.0./2.0);
t3 = q1+t2;
t4 = cos(t3);
t5 = l1.*t4;
t6 = q2+t2;
t7 = cos(t6);
t8 = l2.*t7;
t9 = q4+t2;
t10 = cos(t9);
t11 = q5+t2;
t12 = sin(t3);
t13 = l1.*t12;
t14 = sin(t6);
t15 = l2.*t14;
t16 = q3+t2;
t17 = sin(t9);
t36 = sin(t16);
t38 = sin(t11);
t18 = m4.*(t13+t15-lc4.*t17)+m3.*(t13+t15+lc3.*t36)+m5.*(t13+t15-l4.*t17-lc5.*t38)+m2.*(t13+lc2.*t14)+lc1.*m1.*t12;
t19 = m1+m2+m3+m4+m5;
t20 = cos(t16);
t21 = lc3.*t20;
t22 = t5+t8+t21;
t23 = m3.*t22;
t24 = t5+t8-lc4.*t10;
t25 = m4.*t24;
t26 = lc2.*t7;
t27 = t5+t26;
t28 = m2.*t27;
t29 = cos(t11);
t30 = t5+t8-l4.*t10-lc5.*t29;
t31 = m5.*t30;
t32 = lc1.*m1.*t4;
t33 = t23+t25+t28+t31+t32;
t34 = 1.0./t19.^2;
t35 = dq1.*l1.*t12;
t37 = dq2.*l2.*t14;
t39 = 1.0./t19;
xCOM = t33.*t39-t39.*1.0./sqrt(g.*1.0./sqrt(t18.^2.*t34+t33.^2.*t34)).*(m2.*(t35+dq2.*lc2.*t14)+m5.*(t35+t37-dq4.*l4.*t17-dq5.*lc5.*t38)+m4.*(t35+t37-dq4.*lc4.*t17)+m3.*(t35+t37+dq3.*lc3.*t36)+dq1.*lc1.*m1.*t12);